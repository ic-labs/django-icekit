from glamkit_collections.contrib.work_creator.models import CreatorBase


class OrganizationCreator(CreatorBase):
    class Meta:
        verbose_name = "organization"

    def get_type(self):
        roles = self.get_primary_roles()
        if roles:
            return roles[0].role.title
        return "company"