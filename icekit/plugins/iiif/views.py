from easy_thumbnails.files import get_thumbnailer

from django.db.models.loading import get_model
from django.http import FileResponse
from django.shortcuts import get_object_or_404

from fluent_utils.ajax import JsonResponse

from .utils import parse_region, parse_size, parse_rotation, parse_quality, \
    parse_format


Image = get_model('icekit_plugins_image', 'Image')


def _get_image_or_404(identifier):
    """
    Return image matching `identifier`.

    The `identifier` is expected to be a raw image ID for now, but may be
    more complex later.
    """
    return get_object_or_404(Image, id=identifier)


# TODO Require privileged user
def iiif_image_api_info(request, identifier):
    """ Image Information endpoint for IIIF Image API 2.1 """
    image = _get_image_or_404(identifier)
    # TODO Return 'application/ld+json' response when requested
    return JsonResponse({
        "@context": "http://iiif.io/api/image/2/context.json",
        "@id": request.get_full_path(),
        "protocol": "http://iiif.io/api/image",
        "width": image.width,
        "height": image.height,
        # TODO Return more complete info.json response per spec
    })


# TODO Require privileged user
def iiif_image_api(request,
                   identifier, region, size, rotation, quality, output_format):
    """ Image repurposing endpoint for IIIF Image API 2.1 """
    # TODO Redirect to canonical URL
    image = _get_image_or_404(identifier)
    thumbnail_options = {}

    # Apply region (actual work done in thumbnail generation below)
    x, y, r_width, r_height = parse_region(region, image.width, image.height)

    # Apply size (actual work done in thumbnail generation below)
    s_width, s_height = parse_size(size, r_width, r_height)

    # TODO Apply rotation
    rotation = parse_rotation(rotation, s_width, s_height)

    # Apply quality
    quality = parse_quality(quality)
    if quality in ('default', 'color'):
        pass  # Nothing to do
    elif quality == 'gray':
        thumbnail_options['bw'] = True

    # Generate image
    # NOTE: Generates and saves a thumbnail to make subsequent lookups faster
    thumbnail_options.update({
        'crop': (x, y),
        'size': (s_width, s_height),
    })
    thumbnailer = get_thumbnailer(image.image)
    thumbnail = thumbnailer.get_thumbnail(thumbnail_options)

    # TODO Apply format
    output_format = parse_format(output_format)

    # Set response content type
    return FileResponse(
        open(thumbnail.path, 'rb'),
        content_type='image/%s' % output_format,
    )
