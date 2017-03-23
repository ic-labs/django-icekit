SUPPORTED_EXTENSIONS = ('jpg', 'tif', 'png', 'gif')
UNSUPPORTED_EXTENSIONS = ('jp2', 'pdf', 'webp')
SUPPORTED_QUALITY = ('default', 'color', 'gray',)


class IIIFImageApiException(Exception):
    """ Base class for IIIF Image API Exceptions """
    pass


class ClientError(IIIFImageApiException):
    """ Invalid IIIF Image API operation requested by client """
    pass


class UnsupportedError(IIIFImageApiException):
    """ Unsupported IIIF Image API operation requested by client """
    pass


def parse_dimensions_string(dimension_string, permit_floats=False):
    # Split dimensions string into sections
    try:
        x, y, width, height = dimension_string.split(',')
    except ValueError, ex:
        raise ClientError(
            "Cannot split dimensions string %s: %s" % (dimension_string, ex))
    # Parse dimensions string sections into numerical values
    try:
        if permit_floats:
            x = float(x)
            y = float(y)
            width = float(width)
            height = float(height)
        else:
            x = int(x)
            y = int(y)
            width = int(width)
            height = int(height)
    except ValueError, ex:
        raise ClientError(
            "Cannot parse numbers from dimensions string %s: %s"
            % (dimension_string, ex))
    # Sanity-checks for numerical values
    # Negatives not permitted
    if x < 0 or y < 0 or width < 0 or height < 0:
        raise ClientError(
            "Negative numbers illegal in dimensions string %s"
            % dimension_string)
    # Zero width or height not permitted
    if width <= 0 or height <= 0:
        raise ClientError(
            "Zero numbers illegal in dimensions string %s"
            % dimension_string)
    return (x, y, width, height)


def parse_width_height_string(wh_string):
    # Split dimensions string into sections
    try:
        width, height = wh_string.split(',')
    except ValueError, ex:
        raise ClientError(
            "Cannot split width-height string %s: %s" % (wh_string, ex))
    # Parse width-height string sections into numerical values
    try:
        width = int(width) if width else None
        height = int(height) if height else None
    except ValueError, ex:
        raise ClientError(
            "Cannot parse numbers from width-height string %s: %s"
            % (wh_string, ex))
    # Sanity-checks for numerical values
    # At least one of width or height must be set
    if width is None and height is None:
        raise ClientError(
            "There must be a value in width-height string %s"
            % wh_string)
    # Negatives not permitted
    if (width is not None and width <= 0) or \
            (height is not None and height <= 0):
        raise ClientError(
            "Zero or negative numbers illegal in width-height string %s"
            % wh_string)
    return (width, height)


def parse_region(region, image_width, image_height):
    """
    Parse Region parameter to determine the rectangular portion of the full
    image to be returned, informed by the actual image dimensions.
    Returns (x, y, width, height):
        - x,y are pixel offsets into the image from the upper left
        - width, height are pixel dimensions for cropped image.
    """
    if region == 'full':
        # Return complete image, no cropping
        x, y, width, height = 0, 0, image_width, image_height
    elif region == 'square':
        square_size = min(image_width, image_height)
        # Generate x,y offsets to centre cropped image. This is not mandated
        # by the spec but is recommended as a sensible default.
        x = int((image_width - square_size) / 2)
        y = int((image_height - square_size) / 2)
        width = height = square_size
    elif region.startswith('pct:'):
        x_pct, y_pct, width_pct, height_pct = \
            parse_dimensions_string(region[4:], permit_floats=True)
        x, y, width, height = map(int, (
            x_pct / 100 * image_width,
            y_pct / 100 * image_height,
            width_pct / 100 * image_width,
            height_pct / 100 * image_height,
        ))
    else:
        x, y, width, height = parse_dimensions_string(region)
    # If region extends beyond original's dimensions, crop extends only to
    # image edge.
    width = min(width, image_width - x)
    height = min(height, image_height - y)
    return x, y, width, height


def parse_size(size, image_width, image_height):
    aspect_ratio = float(image_width) / image_height
    if size in ('full', 'max'):
        width, height = image_width, image_height

    elif size.startswith('pct:'):
        # Percentage applied to width and height
        pct = float(size[4:])
        width = pct / 100 * image_width
        height = pct / 100 * image_height

    elif size.startswith('!'):
        # Best fit
        width, height = parse_width_height_string(size[1:])

        # spec assumes both width and height are given. If not, let's just use
        # the image aspect ratio to fill in the blanks.

        if width is None and height is None:
            # no-op
            width = image_width
            height = image_height
        elif width is None:
            width = height * aspect_ratio
        elif height is None:
            height = width / aspect_ratio

        # now we're sure we have both width and height

        if width / aspect_ratio <= height:
            # Requested width is best-fit
            height = int(width / aspect_ratio)
        else:
            # Requested height is best-fit
            width = int(height * aspect_ratio)

    else:
        width, height = parse_width_height_string(size)
        if width is height is None:
            width = image_width
            height = image_height
        # Handle "w,"
        elif height is None:
            height = width / aspect_ratio
        # Handle ",h"
        elif width is None:
            width = height * aspect_ratio
    return int(width), int(height)


def parse_rotation(rotation_str, image_width, image_height):
    try:
        rotation = int(rotation_str) % 360
    except ValueError, ex:
        raise ClientError(
            "Cannot parse number from rotation string %s: %s"
            % (rotation_str, ex))
    valid = (0,)
    if rotation not in valid:
        raise UnsupportedError(
            "Image API rotation parameters other than %r degrees"
            " are not yet supported: %s" % (valid, rotation))
    return rotation


def parse_quality(quality):
    if quality not in SUPPORTED_QUALITY:
        raise UnsupportedError(
            "Image API quality parameters other than %r"
            " are not yet supported: %s" % (SUPPORTED_QUALITY, quality))
    return quality


def parse_format(output_format, image_format):
    # TODO Do we need to limit output format based on image's existing format?
    if output_format in UNSUPPORTED_EXTENSIONS:
        raise UnsupportedError(
            "Image API format parameters %r are not yet supported: %s"
            % (UNSUPPORTED_EXTENSIONS, output_format))
    if output_format not in SUPPORTED_EXTENSIONS:
        raise ClientError(
            "Invalid Image API format parameter not in %r: %s"
            % (SUPPORTED_EXTENSIONS + UNSUPPORTED_EXTENSIONS, output_format))
    return output_format
