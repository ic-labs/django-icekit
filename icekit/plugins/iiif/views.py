import os
try:
    from cStringIO import cStringIO as BytesIO
except ImportError:
    from django.utils.six import BytesIO
try:
    from PIL import Image
except ImportError:
    import Image

from easy_thumbnails import utils as et_utils

from django.contrib.auth.decorators import permission_required
from django.core.files.storage import get_storage_class
from django.db.models.loading import get_model
from django.http import FileResponse, HttpResponseBadRequest, HttpResponse, \
    HttpResponseRedirect
from django.shortcuts import get_object_or_404
from django.utils.timezone import make_naive

from fluent_utils.ajax import JsonResponse

from . import appsettings
from .utils import parse_region, parse_size, parse_rotation, parse_quality, \
    parse_format, make_canonical_path, ClientError, UnsupportedError


ICEkitImage = get_model('icekit_plugins_image', 'Image')

if appsettings.IIIF_STORAGE:
    iiif_storage = get_storage_class(appsettings.IIIF_STORAGE)()
else:
    iiif_storage = None


class HttpResponseNotImplemented(HttpResponse):
    status_code = 501


def _get_image_or_404(identifier, load_image=False):
    """
    Return image matching `identifier`.

    The `identifier` is expected to be a raw image ID for now, but may be
    more complex later.
    """
    ik_image = get_object_or_404(ICEkitImage, id=identifier)
    if not load_image:
        return ik_image, None

    ####################################################################
    # Image-loading incantation cribbed from easythumbnail's `pil_image`
    image = Image.open(BytesIO(ik_image.image.read()))
    # Fully load the image now to catch any problems with the image contents.
    try:
        # An "Image file truncated" exception can occur for some images that
        # are still mostly valid -- we'll swallow the exception.
        image.load()
    except IOError:
        pass
    # Try a second time to catch any other potential exceptions.
    image.load()
    if True:  # Support EXIF orientation data
        image = et_utils.exif_orientation(image)
    ####################################################################

    return ik_image, image


@permission_required('can_use_iiif_image_api')
def iiif_image_api_info(request, identifier_param):
    """
    Image Information endpoint for IIIF Image API 2.1, see
    http://iiif.io/api/image/2.1/#image-information
    """
    # TODO Add support for 'application/ld+json' response when requested
    accept_header = request.environ.get('HTTP_ACCEPT')
    if accept_header == 'application/ld+json':
        return HttpResponseNotImplemented(
            "JSON-LD response is not yet supported")

    ik_image, __ = _get_image_or_404(identifier_param)
    info = {
        "@context": "http://iiif.io/api/image/2/context.json",
        "@id": request.get_full_path(),
        "@type": "iiif:Image",
        "protocol": "http://iiif.io/api/image",
        "width": ik_image.width,
        "height": ik_image.height,
    }
    # TODO Return more complete info.json response per spec

    if ik_image.license:
        info['license'] = [ik_image.license]

    attribution_value = u' '.join([
        u"Credit: %s." % ik_image.credit if ik_image.credit else '',
        u"Provided by: %s." % ik_image.source if ik_image.source else '',
    ]).strip()
    if attribution_value:
        info['attribution'] = [{
            "@value": attribution_value,
            "@language": "en",
        }]

    # TODO Send header "Access-Control-Allow-Origin: *" per spec?
    return JsonResponse(info)


@permission_required('can_use_iiif_image_api')
def iiif_image_api(request, identifier_param, region_param, size_param,
                   rotation_param, quality_param, format_param):
    """ Image repurposing endpoint for IIIF Image API 2.1 """
    ik_image, image = _get_image_or_404(identifier_param, load_image=True)

    is_transparent = et_utils.is_transparent(image)
    is_grayscale = image.mode in ('L', 'LA')

    # Map format names used for IIIF URL path extension to proper name
    format_mapping = {
        'jpg': 'jpeg',
        'tif': 'tiff',
    }

    try:
        # Parse region
        x, y, r_width, r_height = parse_region(
            region_param, image.width, image.height)

        # Parse size
        s_width, s_height = parse_size(size_param, r_width, r_height)

        # Parse rotation
        is_mirrored, rotation_degrees = \
            parse_rotation(rotation_param, s_width, s_height)

        # Parse quality
        quality = parse_quality(quality_param)

        # Parse format
        # TODO Add support for unsupported formats (see `parse_format`)
        image_format = os.path.splitext(ik_image.image.name)[1][1:].lower()
        output_format = parse_format(format_param, image_format)
        corrected_format = format_mapping.get(output_format, output_format)

        # Redirect to canonical URL if appropriate, per
        # http://iiif.io/api/image/2.1/#canonical-uri-syntax
        canonical_path = make_canonical_path(
            identifier_param, image.width, image.height,
            (x, y, r_width, r_height),  # Region
            (s_width, s_height),  # Size
            (is_mirrored, rotation_degrees),  # Rotation
            quality,
            output_format
        )
        if request.path != canonical_path:
            return HttpResponseRedirect(canonical_path)

        # Determine storage file name for item
        if iiif_storage:
            # Replace '/' & ',' with '-' to keep separators of some kind in
            # storage file name, otherwise the characters get purged and
            # produce storage names with potentially ambiguous and clashing
            # values e.g. /3/100,100,200,200/... => iiif3100100200200
            storage_path = canonical_path[1:]  # Stip leading slash
            storage_path = storage_path.replace('/', '-').replace(',', '-')
            storage_path = iiif_storage.get_valid_name(storage_path)
            # Add path prefix to storage path to avoid dumping image files
            # into the root location of a storage location that might be
            # used for many purposes.
            if storage_path.startswith('iiif-'):
                # Strip redundant 'iiif-' prefix
                storage_path = storage_path[5:]
            storage_path = 'iiif/' + storage_path
        else:
            storage_path = None

        # Load pre-generated image from storage if one exists and it is
        # up-to-date with the original image
        # TODO I'm not confident this up-to-date check will work 100%
        # TODO Detect when original image would be unchanged & use it directly?
        if (
            storage_path and
            iiif_storage.exists(storage_path) and
            iiif_storage.created_time(storage_path) >=
                make_naive(ik_image.date_modified)
        ):
            return FileResponse(
                iiif_storage.open(storage_path),
                content_type='image/%s' % corrected_format,
            )

        ##################
        # Generate image #
        ##################

        # Apply region
        if x or y or r_width != image.width or r_height != image.height:
            box = (x, y, x + r_width, y + r_height)
            image = image.crop(box)

        # Apply size
        if s_width != r_width or s_height != r_height:
            size = (s_width, s_height)
            image = image.resize(size)

        # TODO Apply rotation

        # Apply quality
        # Much of this is cribbed from easythumbnails' `colorspace` processor
        # TODO Replace with glamkit-imagetools' sRGB colour space converter?
        if quality in ('default', 'color') and not is_grayscale:
            if is_transparent:
                new_mode = 'RGBA'
            else:
                new_mode = 'RGB'
        elif is_grayscale or quality == 'gray':
            if is_transparent:
                new_mode = 'LA'
            else:
                new_mode = 'L'
        if new_mode != image.mode:
            image = image.convert(new_mode)

        # Apply format and "save"
        result_image = BytesIO()
        image.save(result_image, format=corrected_format)

        # Save generated image to storage if possible
        if storage_path:
            iiif_storage.save(storage_path, result_image)

        # Set response content type
        result_image.seek(0)  # Reset to start of image data
        return FileResponse(
            result_image.read(),
            content_type='image/%s' % corrected_format,
        )
    # Handle error conditions per iiif.io/api/image/2.1/#server-responses
    except ClientError, ex:
        return HttpResponseBadRequest(ex.message)  # 400 response
    except UnsupportedError, ex:
        return HttpResponseNotImplemented(ex.message)  # 501 response
