from django.db.models.loading import get_model
from django.http import Http404, HttpResponseRedirect
from django.shortcuts import get_object_or_404

from fluent_utils.ajax import JsonResponse


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
                   identifier, region, size, rotation, quality, format
):
    """ Image repurposing endpoint for IIIF Image API 2.1 """
    # TODO Redirect to canonical URL
    image = _get_image_or_404(identifier)
    # TODO Sanity-check image request parameters
    # TODO Process image request parameters
    # TODO Convert image
    # TODO Set response content type
    return None
