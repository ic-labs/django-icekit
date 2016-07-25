from django.db import models


class WorkCreatorBase(models.Model):
    """
    Implementing subclasses should define

    artist = models.ForeignKey(Artist)
    artwork = models.ForeignKey(Artwork)
    """

    artist = models.ForeignKey('collection.Artist')
    artwork = models.ForeignKey('collection.Artwork')

    order = models.PositiveIntegerField()
    role = models.CharField(max_length=255)

    last_updated = models.DateTimeField(
        auto_now=True,
        help_text="Every shadow import updates this timestamp. This is used to determine which obsolete records to delete at the end of import."
    )

    class Meta:
        abstract = True
        unique_together = ('artist', 'artwork', 'role')
        ordering = ("order", )

    def __unicode__(self):
        return unicode(self.artwork)

    @property
    def admin_hero_image(self):
        return self.artwork.admin_hero_image
