International Image Interoperability Framework (IIIF)
=====================================================

Access to image-based resources is fundamental to research, scholarship and
the transmission of cultural knowledge. Digital images are a container for
much of the information content in the Web-based delivery of images, books,
newspapers, manuscripts, maps, scrolls, single sheet collections, and archival
 materials. Yet much of the Internet’s image-based resources are locked up in
 silos, with access restricted to bespoke, locally built applications.

A growing community of the world’s leading research libraries and image
repositories have embarked on an effort to collaboratively produce an
interoperable technology and community framework for image delivery.

IIIF (International Image Interoperability Framework) has the following goals:

-  To give scholars an unprecedented level of uniform and rich access to
   image-based resources hosted around the world.
-  To define a set of common application programming interfaces that support
   interoperability between image repositories.
-  To develop, cultivate and document shared technologies, such as image
   servers and web clients, that provide a world-class user experience in
   viewing, comparing, manipulating and annotating images.

Usage
-----

GLAMkit contains a basic implementation key parts of the
`IIIF 2.1 spec <http://iiif.io/api/image/2.1/>`_.
 allows privileged users (with ``can_use_iiif_image_api`` permission) to
 repurpose images using URL paths like::

   # original size as png file
   /iiif/{ID}/full/max/0/default.png

   # cropped to a square
   /iiif/{ID}/square/max/0/default.jpg

   # resize to 400px wide
   /iiif/{ID}/full/400,/0/default.jpg

   # resize to fit in 400x300, tif file
   /iiif/{ID}/full/!400,300/0/default.tif

   # crop to 400x300,
   /iiif/{ID}/full/!400,300/0/default.jpg

   # crop from 100,150 a region of 900x600 px, and resize to 300px wide.
   /iiif/{ID}/100,150,900,600/300,/0/default.png

   # original size as grayscale jpg file
   /iiif/{ID}/full/max/0/gray.jpg

   # metadata
   /iiif/{ID}/info.json

where ``{ID}`` is the ID of an image in the ``Image`` model.

The resulting image is created and stored permanently the first time it is
requested.

``ImageRepurposeConfig``
------------------------

The ``iiif.models.ImageRepurposeConfig`` model allows a user to define IIIF
parameters to apply to the images. For now, only resize, format and grayscale
options are implemented. The repurpose links are shown for each Image in the
admin.

Notes
-----

-  The feature was inspired by
   `Aaron Straup Cope <http://www.aaronland.info/weblog/2017/03/05/record/#numbers>`_
   and `Micah Walter <https://labs.cooperhewitt.org/2017/parting-gifts/>`_ working at
   the Cooper-Hewitt Labs, but we're less far along the path of asynchronous
   generation and efficient serving.

-  Because GLAMkit currently generates files synchronously and stores them
   permanently, and serves them via a proxy, the IIIF solution is not suitable
   for serving requests created by the general public. As such, we've limited
   usage to Users with the ``can_use_iiif_image_api`` permission. In future,
   we may allow public to read images, but only privileged users to create them,
   and/or we may introduce rate-limiting and image expiry of generated images
   for certain classes of users. That opens the way to using IIIF images
   throughout the GLAMkit front-end.

-  Image rotations other than 0 degrees aren't currently supported. Note that
   it should be possible to losslessly rotate jpgs by multiples of 90 degrees.

-  The resulting images have the color profile stripped for smaller file size,
   and there is no particular colorspace conversion before doing so.
   Implementers may wish to use the code in glamkit-imagetools for ensuring
   sRGB conversion either at upload time or at resize time.

-  The Django instance reads and serves the images from storage every time.
   Ideally the image would be statically served direct from the storage, and
   Django would redirect there.
