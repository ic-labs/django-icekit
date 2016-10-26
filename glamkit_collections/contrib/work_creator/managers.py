from django.db import models

class WorkCreatorQuerySet(models.QuerySet):
    def creators_grouped_by_role(self):
        """
        :return: A generator yielding 2-tuples of (role, [creators]) where
        adjacent creators who share the same role are grouped together.
        """
        role = -1
        creators = []
        for wc in self:
            if wc.role != role:
                if creators:
                    yield (role, creators)
                role = wc.role
                creators = []
            creators.append(wc.creator)

        if creators:
            yield (role, creators)

class WorkImageQuerySet(models.QuerySet):
    def images_grouped_by_type(self):
        """
        :return: A generator yielding 2-tuples of (type, [creators]) where
        adjacent creators who share the same role are grouped together.
        """
        type = -1
        images = []
        for wc in self:
            if wc.type != type:
                if images:
                    yield (type, images)
                role = wc.role
                creators = []
                images.append(wc.image)

        if images:
            yield (type, images)
