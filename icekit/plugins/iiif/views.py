from easy_thumbnails.files import get_thumbnailer

from django.db.models.loading import get_model
from django.http import FileResponse, HttpResponseBadRequest, HttpResponse
from django.shortcuts import get_object_or_404
from django.contrib.auth.decorators import permission_required

from fluent_utils.ajax import JsonResponse

from .utils import parse_region, parse_size, parse_rotation, parse_quality, \
    parse_format, ClientError, UnsupportedError


Image = get_model('icekit_plugins_image', 'Image')


class HttpResponseNotImplemented(HttpResponse):
    status_code = 501


def _get_image_or_404(identifier):
    """
    Return image matching `identifier`.

    The `identifier` is expected to be a raw image ID for now, but may be
    more complex later.
    """
    return get_object_or_404(Image, id=identifier)


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

    image = _get_image_or_404(identifier_param)
    info = {
        "@context": "http://iiif.io/api/image/2/context.json",
        "@id": request.get_full_path(),
        "@type": "iiif:Image",
        "protocol": "http://iiif.io/api/image",
        "width": image.width,
        "height": image.height,
    }
    # TODO Return more complete info.json response per spec

    if image.license:
        info['license'] = [image.license]

    attribution_value = u' '.join([
        u"Credit: %s." % image.credit if image.credit else '',
        u"Provided by: %s." % image.source if image.source else '',
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
    image = _get_image_or_404(identifier_param)
    thumbnail_options = {}

    try:
        # Apply region (actual work done in thumbnail generation below)
        x, y, r_width, r_height = parse_region(
            region_param, image.width, image.height)

        # Apply size (actual work done in thumbnail generation below)
        s_width, s_height = parse_size(size_param, r_width, r_height)

        # TODO Apply rotation
        parse_rotation(rotation_param, s_width, s_height)

        # Apply quality
        quality = parse_quality(quality_param)
        if quality in ('default', 'color'):
            pass  # Nothing to do
        elif quality == 'gray':
            thumbnail_options['bw'] = True

        # TODO Redirect to canonical URL per
        # http://iiif.io/api/image/2.1/#canonical-uri-syntax

        # Generate image
        # NOTE: Generates and saves a thumbnail to make subsequent lookups
        # faster
        thumbnail_options.update({
            'crop': (x, y),
            'size': (s_width, s_height),
        })
        thumbnailer = get_thumbnailer(image.image)
        thumbnail = thumbnailer.get_thumbnail(thumbnail_options)

        # TODO Apply format
        output_format = parse_format(format_param)

        # Set response content type
        return FileResponse(
            open(thumbnail.path, 'rb'),
            content_type='image/%s' % output_format,
        )
    # Handle error conditions per iiif.io/api/image/2.1/#server-responses
    except ClientError, ex:
        return HttpResponseBadRequest(ex.message)  # 400 response
    except UnsupportedError, ex:
        return HttpResponseNotImplemented(ex.message)  # 501 response
