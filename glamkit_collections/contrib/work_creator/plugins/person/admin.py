from glamkit_collections.contrib.work_creator.admin import CreatorChildAdmin


class PersonCreatorAdmin(CreatorChildAdmin):
    fieldsets = (
        ('Name', {
            'fields': (
                'name_full',
                'name_given',
                'name_family',
                'name_display',
                'name_sort',
                'slug',
            ),
        }),
        ('Background', {
            'fields': (
                'gender',
                'primary_occupation',
                (
                    'birth_place',
                    'birth_place_historic',
                ),
                'death_place',
                'background_ethnicity',
                'background_nationality',
                (
                    'background_neighborhood',
                    'background_city',
                ),
                (
                    'background_state_province',
                    'background_country',
                ),
                'background_continent',
            )
        }),
    ) + CreatorChildAdmin.fieldsets[1:]
