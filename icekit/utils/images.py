from easy_thumbnails.processors import scale_and_crop


def scale_and_crop_with_ranges(
    im, size, size_range=None, crop=False, upscale=False, zoom=None, target=None, **kwargs):
    """
    An easy_thumbnails processor that accepts a `size_range` tuple, which
    indicates that one or both dimensions can give by a number of pixels in
    order to minimize cropping.
    """

    min_width, min_height = size

    # if there's no restriction on range, or range isn't given, just act as
    # normal
    if min_width == 0 or min_height == 0 or not size_range:
        return scale_and_crop(im, size, crop, upscale, zoom, target, **kwargs)

    max_width = min_width + size_range[0]
    max_height = min_height + size_range[1]

    # figure out the minimum and maximum aspect ratios
    min_ar = min_width * 1.0 / max_height
    max_ar = max_width * 1.0 / min_height

    img_width, img_height = [float(v) for v in im.size]
    img_ar = img_width/img_height

    # clamp image aspect ratio to given range
    if img_ar <= min_ar:
        size = (min_width, max_height)
    elif img_ar >= max_ar:
        size = (max_width, min_height)
    else:
        # the aspect ratio of the image is within the allowed parameters.
        size = (max_width, max_height)


    return scale_and_crop(im, size, crop, upscale, zoom, target, **kwargs)
