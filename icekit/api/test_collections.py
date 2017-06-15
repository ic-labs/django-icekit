from django.apps import apps
from django.core.urlresolvers import reverse

from . import base_tests

Artwork = apps.get_model('gk_collections_artwork.Artwork')
Film = apps.get_model('gk_collections_film.Film')
Game = apps.get_model('gk_collections_game.Game')
Person = apps.get_model('gk_collections_person.PersonCreator')
Organization = apps.get_model(
    'gk_collections_organization.OrganizationCreator')
WorkCreator = apps.get_model(
    'gk_collections_work_creator.WorkCreator')
Role = apps.get_model(
    'gk_collections_work_creator.Role')


class _BaseCollectionAPITestCase(base_tests._BaseAPITestCase):
    """
    Tests for GLAMkit Collections API integration.
    """
    pass


class ArtworkAPITestCase(_BaseCollectionAPITestCase):
    API_NAME = 'artwork-api'  # Set to reverse-able name for API URLs
    BASE_DATA = {
        "url": "",
        "slug": "",
        "title": "",
        "publishing_is_draft": False,
        "creation_date_display": "",
        "creation_date_edtf": None,
        "origin": [],
        "subtitle": "",
        "oneliner": "",
        "department": "",
        "credit_line": "",
        "accession_number": "",
        "dimensions": {
            "display": "",
            "is_two_dimensional": False,
            "extent": "",
            "height_cm": None,
            "width_cm": None,
            "depth_cm": None,
            "weight_kg": None
        },
        "medium_display": "",
        "creators": [],
        "images": [],
        "id": "",
        "external_ref": None,
        "dt_created": "",
        "dt_modified": "",
        "admin_notes": "",
    }

    def setUp(self):
        super(ArtworkAPITestCase, self).setUp()

        self.artwork = Artwork.objects.create(
            title='Test Artwork',
        )

        self.artwork_published = self.artwork.publish()

    def test_list_artworks_with_get(self):
        response = self.client.get(self.listing_url())
        self.assertEqual(200, response.status_code)
        expected = {
            'count': 2,
            'next': None,
            'previous': None,
            'results': [
                self.build_item_data({
                    "url": 'http://testserver%s'
                    % self.detail_url(self.artwork_published.pk),
                    "slug": "test-artwork",
                    "title": "Test Artwork",
                    "publishing_is_draft": False,
                    "id": self.artwork_published.pk,
                    "dt_created": self.iso8601(
                        self.artwork_published.dt_created),
                    "dt_modified": self.iso8601(
                        self.artwork_published.dt_modified),
                }),
                self.build_item_data({
                    "url": 'http://testserver%s'
                    % self.detail_url(self.artwork.pk),
                    "slug": "test-artwork",
                    "title": "Test Artwork",
                    "publishing_is_draft": True,
                    "id": self.artwork.pk,
                    "dt_created": self.iso8601(
                        self.artwork.dt_created),
                    "dt_modified": self.iso8601(
                        self.artwork.dt_modified),
                }),
            ],
        }
        self.assertEqual(expected, response.data)

    def test_get_artwork_detail_with_get(self):
        response = self.client.get(
            self.detail_url(self.artwork_published.pk))
        self.assertEqual(200, response.status_code)
        expected = self.build_item_data({
            "url": 'http://testserver%s'
            % self.detail_url(self.artwork_published.pk),
            "slug": "test-artwork",
            "title": "Test Artwork",
            "publishing_is_draft": False,
            "id": self.artwork_published.pk,
            "dt_created": self.iso8601(
                self.artwork_published.dt_created),
            "dt_modified": self.iso8601(
                self.artwork_published.dt_modified),
        })
        self.assertEqual(expected, response.data)

    def test_add_artwork_with_post(self):
        response = self.client.post(
            self.listing_url(),
            {
                'title': 'New Artwork',
            },
        )
        self.assertEqual(201, response.status_code)
        new_artwork = Artwork.objects.get(
            slug=response.data['slug'],
            publishing_is_draft=response.data['publishing_is_draft'],
        )
        self.assertEqual('new-artwork', new_artwork.slug)
        self.assertEqual('New Artwork', new_artwork.title)
        self.assertTrue(new_artwork.publishing_is_draft)

    def test_replace_artwork_with_put(self):
        response = self.client.get(self.detail_url(self.artwork.id))
        self.assertEqual(200, response.status_code)

        artwork_data = response.data
        artwork_data['title'] = 'Replaced Artwork'

        response = self.client.put(
            self.detail_url(self.artwork.id),
            artwork_data,
        )
        self.assertEqual(200, response.status_code)
        updated_artwork = Artwork.objects.get(pk=self.artwork.pk)
        self.assertEqual('test-artwork', updated_artwork.slug)
        self.assertEqual('Replaced Artwork', updated_artwork.title)

    def test_update_artwork_with_patch(self):
        response = self.client.patch(
            self.detail_url(self.artwork.pk),
            {
                'title': 'Updated Artwork',
                'dimensions': {
                    'extent': '123cm',
                },
            },
        )
        self.assertEqual(200, response.status_code)
        updated_artwork = Artwork.objects.get(pk=self.artwork.pk)
        self.assertEqual('Updated Artwork', updated_artwork.title)
        self.assertEqual('123cm', updated_artwork.dimensions_extent)

    def test_delete_artwork_with_delete(self):
        response = self.client.delete(self.detail_url(self.artwork.pk))
        self.assertEqual(204, response.status_code)
        self.assertEqual(0, Artwork.objects.count())

    def test_api_user_permissions_are_correct(self):
        counter = {'value': 0}

        def extra_item_data_for_writes_fn():
            """ Hack to return a unique `slug` value each time """
            counter['value'] += 1
            value = counter['value']
            return {
                'title': 'Another Artwork %d' % value,
            }

        self.assert_api_user_permissions_are_correct(
            self.artwork.pk,
            Artwork,
            'artwork',
            extra_item_data_for_writes_fn=extra_item_data_for_writes_fn
        )


class GameAPITestCase(_BaseCollectionAPITestCase):
    API_NAME = 'game-api'  # Set to reverse-able name for API URLs
    BASE_DATA = {
        "creation_date_display": "",
        "creation_date_edtf": None,
        "origin": [],
        "slug": "",
        "title": "",
        "subtitle": "",
        "oneliner": "",
        "department": "",
        "credit_line": "",
        "accession_number": "",
        #"rating": {
        #    "title": "",
        #    "slug": "",
        #    "image": None,
        #},
        #"media_type": {
        #    "title": "",
        #    "slug": ""
        #},
        "rating_annotation": "",
        "duration_minutes": None,
        "trailer": "",
        "imdb_link": "",
        "is_single_player": False,
        "is_multi_player": False,
        "creators": [],
        "images": [],
        "genres": [],
        "input_types": [],
        "platforms": [],
        "id": "",
        "external_ref": None,
        "dt_created": "",
        "dt_modified": "",
        "admin_notes": "",
    }

    def setUp(self):
        super(GameAPITestCase, self).setUp()

        self.game = Game.objects.create(
            title='Test Game',
        )

        self.game_published = self.game.publish()

    def test_list_games_with_get(self):
        response = self.client.get(self.listing_url())
        self.assertEqual(200, response.status_code)
        expected = {
            'count': 2,
            'next': None,
            'previous': None,
            'results': [
                self.build_item_data({
                    "url": 'http://testserver%s'
                    % self.detail_url(self.game_published.pk),
                    "slug": "test-game",
                    "title": "Test Game",
                    "publishing_is_draft": False,
                    "rating": None,
                    "media_type": None,
                    "id": self.game_published.pk,
                    "dt_created": self.iso8601(
                        self.game_published.dt_created),
                    "dt_modified": self.iso8601(
                        self.game_published.dt_modified),
                }),
                self.build_item_data({
                    "url": 'http://testserver%s'
                    % self.detail_url(self.game.pk),
                    "slug": "test-game",
                    "title": "Test Game",
                    "publishing_is_draft": True,
                    "rating": None,
                    "media_type": None,
                    "id": self.game.pk,
                    "dt_created": self.iso8601(
                        self.game.dt_created),
                    "dt_modified": self.iso8601(
                        self.game.dt_modified),
                }),
            ],
        }
        self.assertEqual(expected, response.data)

    def test_get_game_detail_with_get(self):
        response = self.client.get(
            self.detail_url(self.game_published.pk))
        self.assertEqual(200, response.status_code)
        expected = self.build_item_data({
            "url": 'http://testserver%s'
            % self.detail_url(self.game_published.pk),
            "slug": "test-game",
            "title": "Test Game",
            "publishing_is_draft": False,
            "rating": None,
            "media_type": None,
            "id": self.game_published.pk,
            "dt_created": self.iso8601(
                self.game_published.dt_created),
            "dt_modified": self.iso8601(
                self.game_published.dt_modified),
        })
        self.assertEqual(expected, response.data)

    def test_add_game_with_post(self):
        response = self.client.post(
            self.listing_url(),
            {
                'title': 'New Game',
            },
        )
        self.assertEqual(201, response.status_code)
        new_game = Game.objects.get(
            slug=response.data['slug'],
            publishing_is_draft=response.data['publishing_is_draft'],
        )
        self.assertEqual('new-game', new_game.slug)
        self.assertEqual('New Game', new_game.title)
        self.assertTrue(new_game.publishing_is_draft)

    def test_replace_game_with_put(self):
        response = self.client.get(self.detail_url(self.game.id))
        self.assertEqual(200, response.status_code)

        game_data = response.data
        game_data['title'] = 'Replaced Game'
        del(game_data['rating'])
        del(game_data['media_type'])

        response = self.client.put(
            self.detail_url(self.game.id),
            game_data,
        )
        self.assertEqual(200, response.status_code)
        updated_game = Game.objects.get(pk=self.game.pk)
        self.assertEqual('test-game', updated_game.slug)
        self.assertEqual('Replaced Game', updated_game.title)

    def test_update_game_with_patch(self):
        response = self.client.patch(
            self.detail_url(self.game.pk),
            {
                'title': 'Updated Game',
                'rating': {
                    'slug': 'pg',
                    'title': 'PG',
                },
            },
        )
        self.assertEqual(200, response.status_code)
        updated_game = Game.objects.get(pk=self.game.pk)
        self.assertEqual('Updated Game', updated_game.title)
        self.assertEqual('pg', updated_game.rating.slug)
        self.assertEqual('PG', updated_game.rating.title)

    def test_delete_game_with_delete(self):
        response = self.client.delete(self.detail_url(self.game.pk))
        self.assertEqual(204, response.status_code)
        self.assertEqual(0, Game.objects.count())

    def test_api_user_permissions_are_correct(self):
        counter = {'value': 0}

        def extra_item_data_for_writes_fn():
            """ Hack to return a unique `slug` value each time """
            counter['value'] += 1
            value = counter['value']
            return {
                'title': 'Another Game %d' % value,
                'slug': 'another-game-%d' % value,
                'rating': {
                    'slug': 'pg',
                },
                'media_type': {
                    'slug': 'dvd',
                },
            }

        self.assert_api_user_permissions_are_correct(
            self.game.pk,
            Game,
            'game',
            extra_item_data_for_writes_fn=extra_item_data_for_writes_fn
        )


class FilmAPITestCase(_BaseCollectionAPITestCase):
    API_NAME = 'film-api'  # Set to reverse-able name for API URLs
    BASE_DATA = {
        "url": "",
        "publishing_is_draft": True,
        "slug": "",
        "title": "",
        "creators": [],
        "images": [],
        "creation_date_display": "",
        "creation_date_edtf": None,
        "origin": [],
        "subtitle": "",
        "oneliner": "",
        "department": "",
        "credit_line": "",
        "accession_number": "",
        "rating": None,
        "genres": [],
        "media_type": None,
        "rating_annotation": "",
        "duration_minutes": None,
        "trailer": "",
        "imdb_link": "",
        "formats": [],
        "id": "",
        "external_ref": None,
        "dt_created": "",
        "dt_modified": "",
        "admin_notes": "",
    }

    def setUp(self):
        super(FilmAPITestCase, self).setUp()

        self.film = Film.objects.create(
            title='Test Film',
        )

        self.film_published = self.film.publish()

    def test_list_films_with_get(self):
        response = self.client.get(self.listing_url())
        self.assertEqual(200, response.status_code)
        expected = {
            'count': 2,
            'next': None,
            'previous': None,
            'results': [
                self.build_item_data({
                    "url": 'http://testserver%s'
                    % self.detail_url(self.film_published.pk),
                    "slug": "test-film",
                    "title": "Test Film",
                    "publishing_is_draft": False,
                    "rating": None,
                    "media_type": None,
                    "id": self.film_published.pk,
                    "dt_created": self.iso8601(
                        self.film_published.dt_created),
                    "dt_modified": self.iso8601(
                        self.film_published.dt_modified),
                }),
                self.build_item_data({
                    "url": 'http://testserver%s'
                    % self.detail_url(self.film.pk),
                    "slug": "test-film",
                    "title": "Test Film",
                    "publishing_is_draft": True,
                    "rating": None,
                    "media_type": None,
                    "id": self.film.pk,
                    "dt_created": self.iso8601(
                        self.film.dt_created),
                    "dt_modified": self.iso8601(
                        self.film.dt_modified),
                }),
            ],
        }
        self.assertEqual(expected, response.data)

    def test_get_film_detail_with_get(self):
        response = self.client.get(
            self.detail_url(self.film_published.pk))
        self.assertEqual(200, response.status_code)
        expected = self.build_item_data({
            "url": 'http://testserver%s'
            % self.detail_url(self.film_published.pk),
            "slug": "test-film",
            "title": "Test Film",
            "publishing_is_draft": False,
            "rating": None,
            "media_type": None,
            "id": self.film_published.pk,
            "dt_created": self.iso8601(
                self.film_published.dt_created),
            "dt_modified": self.iso8601(
                self.film_published.dt_modified),
        })
        self.assertEqual(expected, response.data)

    def test_add_film_with_post(self):
        response = self.client.post(
            self.listing_url(),
            {
                'title': 'New Film',
            },
        )
        self.assertEqual(201, response.status_code)
        new_film = Film.objects.get(
            slug=response.data['slug'],
            publishing_is_draft=response.data['publishing_is_draft'],
        )
        self.assertEqual('new-film', new_film.slug)
        self.assertEqual('New Film', new_film.title)
        self.assertTrue(new_film.publishing_is_draft)

    def test_replace_film_with_put(self):
        response = self.client.get(self.detail_url(self.film.id))
        self.assertEqual(200, response.status_code)

        film_data = response.data
        film_data['title'] = 'Replaced Film'
        del(film_data['rating'])
        del(film_data['media_type'])

        response = self.client.put(
            self.detail_url(self.film.id),
            film_data,
        )
        self.assertEqual(200, response.status_code)
        updated_film = Film.objects.get(pk=self.film.pk)
        self.assertEqual('test-film', updated_film.slug)
        self.assertEqual('Replaced Film', updated_film.title)

    def test_update_film_with_patch(self):
        response = self.client.patch(
            self.detail_url(self.film.pk),
            {
                'title': 'Updated Film',
                'rating': {
                    'slug': 'pg',
                    'title': 'PG',
                },
            },
        )
        self.assertEqual(200, response.status_code)
        updated_film = Film.objects.get(pk=self.film.pk)
        self.assertEqual('Updated Film', updated_film.title)
        self.assertEqual('pg', updated_film.rating.slug)
        self.assertEqual('PG', updated_film.rating.title)

    def test_delete_film_with_delete(self):
        response = self.client.delete(self.detail_url(self.film.pk))
        self.assertEqual(204, response.status_code)
        self.assertEqual(0, Film.objects.count())

    def test_api_user_permissions_are_correct(self):
        counter = {'value': 0}

        def extra_item_data_for_writes_fn():
            """ Hack to return a unique `slug` value each time """
            counter['value'] += 1
            value = counter['value']
            return {
                'title': 'Another Film %d' % value,
                'slug': 'another-film-%d' % value,
                'rating': {
                    'slug': 'pg',
                },
                'media_type': {
                    'slug': 'dvd',
                },
            }

        self.assert_api_user_permissions_are_correct(
            self.film.pk,
            Film,
            'film',
            extra_item_data_for_writes_fn=extra_item_data_for_writes_fn
        )


class PersonAPITestCase(_BaseCollectionAPITestCase):
    API_NAME = 'person-api'  # Set to reverse-able name for API URLs
    BASE_DATA = {
        "url": "",
        "slug": "",
        "name": {
            "display": "",
            "sort": "",
            "full": "",
            "given": "",
            "family": ""
        },
        "publishing_is_draft": False,
        "works": [],
        "portrait": None,
        "alt_slug": "",
        "website": "",
        "wikipedia_link": "",
        "birth_date_display": "",
        "birth_date_edtf": None,
        "birth_place": "",
        "birth_place_historic": "",
        "death_date_display": "",
        "death_date_edtf": None,
        "death_place": "",
        "background": {
            "ethnicity": "",
            "nationality": "",
            "neighborhood": "",
            "city": "",
            "state_province": "",
            "country": "",
            "continent": ""
        },
        "id": "",
        "external_ref": None,
        "dt_created": "",
        "dt_modified": "",
        "admin_notes": "",
    }

    def setUp(self):
        super(PersonAPITestCase, self).setUp()

        self.person = Person.objects.create(
            name_full='Test Person',
            name_family='Person',
            name_given='Test',
        )

        self.person_published = self.person.publish()

    def test_list_persons_with_get(self):
        response = self.client.get(self.listing_url())
        self.assertEqual(200, response.status_code)
        expected = {
            'count': 2,
            'next': None,
            'previous': None,
            'results': [
                self.build_item_data({
                    "url": 'http://testserver%s'
                    % self.detail_url(self.person_published.pk),
                    "slug": "person-test",
                    "name": {
                        "full": "Test Person",
                        "display": "Test Person",
                        "sort": "Person, Test",
                        "given": "Test",
                        "family": "Person"
                    },
                    "publishing_is_draft": False,
                    "id": self.person_published.pk,
                    "dt_created": self.iso8601(
                        self.person_published.dt_created),
                    "dt_modified": self.iso8601(
                        self.person_published.dt_modified),
                }),
                self.build_item_data({
                    "url": 'http://testserver%s'
                    % self.detail_url(self.person.pk),
                    "slug": "person-test",
                    "name": {
                        "full": "Test Person",
                        "display": "Test Person",
                        "sort": "Person, Test",
                        "given": "Test",
                        "family": "Person"
                    },
                    "publishing_is_draft": True,
                    "id": self.person.pk,
                    "dt_created": self.iso8601(self.person.dt_created),
                    "dt_modified": self.iso8601(self.person.dt_modified),
                }),
            ],
        }
        self.assertEqual(expected, response.data)

    def test_get_person_detail_with_get(self):
        response = self.client.get(
            self.detail_url(self.person_published.pk))
        self.assertEqual(200, response.status_code)
        expected = self.build_item_data({
            "url": 'http://testserver%s'
            % self.detail_url(self.person_published.pk),
            "slug": "person-test",
            "name": {
                "full": "Test Person",
                "display": "",
                "sort": "Person, Test",
                "given": "Test",
                "family": "Person"
            },
            "publishing_is_draft": False,
            "id": self.person_published.pk,
            "dt_created": self.iso8601(
                self.person_published.dt_created),
            "dt_modified": self.iso8601(
                self.person_published.dt_modified),
        })
        self.assertEqual(expected, response.data)

    def test_add_person_with_post(self):
        response = self.client.post(
            self.listing_url(),
            {
                "name": {
                    "full": "New Person",
                },
            },
        )
        self.assertEqual(201, response.status_code)
        new_person = Person.objects.get(
            slug=response.data['slug'],
            publishing_is_draft=response.data['publishing_is_draft'],
        )
        self.assertEqual('new-person', new_person.slug)
        self.assertEqual('New Person', new_person.name_full)
        self.assertTrue(new_person.publishing_is_draft)

    def test_replace_person_with_put(self):
        response = self.client.get(self.detail_url(self.person.id))
        self.assertEqual(200, response.status_code)

        person_data = response.data
        person_data['name'] = {
            'full': 'Replaced Person',
        }
        del(person_data['portrait'])

        response = self.client.put(
            self.detail_url(self.person.id),
            person_data,
        )
        self.assertEqual(200, response.status_code)
        updated_person = Person.objects.get(pk=self.person.pk)
        self.assertEqual('person-test', updated_person.slug)
        self.assertEqual('Replaced Person', updated_person.name_full)

    def test_update_person_with_patch(self):
        response = self.client.patch(
            self.detail_url(self.person.pk),
            {
                'name': {
                    'full': 'Updated Person',
                },
            },
        )
        self.assertEqual(200, response.status_code)
        updated_person = Person.objects.get(pk=self.person.pk)
        self.assertEqual('Updated Person', updated_person.name_full)

    def test_delete_person_with_delete(self):
        response = self.client.delete(self.detail_url(self.person.pk))
        self.assertEqual(204, response.status_code)
        self.assertEqual(0, Person.objects.count())

    def test_api_user_permissions_are_correct(self):
        counter = {'value': 0}

        def extra_item_data_for_writes_fn():
            """ Hack to return a unique `name.full` value each time """
            counter['value'] += 1
            value = counter['value']
            return {
                'name': {
                    'full': 'Another Person %d' % value,
                },
            }

        self.assert_api_user_permissions_are_correct(
            self.person.pk,
            Person,
            'personcreator',
            extra_item_data_for_writes_fn=extra_item_data_for_writes_fn,
            item_data_fields_to_remove=['portrait']
        )


class OrganizationAPITestCase(_BaseCollectionAPITestCase):
    API_NAME = 'organization-api'  # Set to reverse-able name for API URLs
    BASE_DATA = {
        "url": "",
        "slug": "",
        "name_full": "",
        "name_display": "",
        "name_sort": "",
        "creation_date_display": "",
        "creation_date_edtf": None,
        "closure_date_display": "",
        "closure_date_edtf": None,
        "publishing_is_draft": False,
        "works": [],
        "portrait": None,
        "alt_slug": "",
        "website": "",
        "wikipedia_link": "",
        "admin_notes": "",
        "type": "company",
        "type_plural": "companies",
        "id": "",
        "external_ref": None,
        "dt_created": "",
        "dt_modified": "",
        "admin_notes": "",
    }

    def setUp(self):
        super(OrganizationAPITestCase, self).setUp()

        self.organization = Organization.objects.create(
            name_full='Test Organization',
        )

        self.organization_published = self.organization.publish()

    def test_list_organizations_with_get(self):
        response = self.client.get(self.listing_url())
        self.assertEqual(200, response.status_code)
        expected = {
            'count': 2,
            'next': None,
            'previous': None,
            'results': [
                self.build_item_data({
                    "url": 'http://testserver%s'
                    % self.detail_url(self.organization_published.pk),
                    "name_full": "Test Organization",
                    "name_display": "Test Organization",
                    "name_sort": "Test Organization",
                    "slug": "test-organization",
                    "publishing_is_draft": False,
                    "id": self.organization_published.pk,
                    "dt_created": self.iso8601(
                        self.organization_published.dt_created),
                    "dt_modified": self.iso8601(
                        self.organization_published.dt_modified),
                }),
                self.build_item_data({
                    "url": 'http://testserver%s'
                    % self.detail_url(self.organization.pk),
                    "name_full": "Test Organization",
                    "name_display": "Test Organization",
                    "name_sort": "Test Organization",
                    "slug": "test-organization",
                    "publishing_is_draft": True,
                    "id": self.organization.pk,
                    "dt_created": self.iso8601(self.organization.dt_created),
                    "dt_modified": self.iso8601(self.organization.dt_modified),
                }),
            ],
        }
        self.assertEqual(expected, response.data)

    def test_get_organization_detail_with_get(self):
        response = self.client.get(
            self.detail_url(self.organization_published.pk))
        self.assertEqual(200, response.status_code)
        expected = self.build_item_data({
            "name_full": "Test Organization",
            "url": 'http://testserver%s'
            % self.detail_url(self.organization_published.pk),
            "name_display": "",
            "name_sort": "Test Organization",
            "slug": "test-organization",
            "publishing_is_draft": False,
            "id": self.organization_published.pk,
            "dt_created": self.iso8601(
                self.organization_published.dt_created),
            "dt_modified": self.iso8601(
                self.organization_published.dt_modified),
        })
        self.assertEqual(expected, response.data)

    def test_add_organization_with_post(self):
        response = self.client.post(
            self.listing_url(),
            {
                "name_full": "New Organization",
            },
        )
        self.assertEqual(201, response.status_code)
        new_organization = Organization.objects.get(
            slug=response.data['slug'],
            publishing_is_draft=response.data['publishing_is_draft'],
        )
        self.assertEqual('new-organization', new_organization.slug)
        self.assertEqual('New Organization', new_organization.name_full)
        self.assertEqual('New Organization', new_organization.name_display)
        self.assertEqual('New Organization', new_organization.name_sort)
        self.assertTrue(new_organization.publishing_is_draft)

    def test_replace_organization_with_put(self):
        response = self.client.get(self.detail_url(self.organization.id))
        self.assertEqual(200, response.status_code)

        organization_data = response.data
        organization_data['name_full'] = 'Replaced Organization'
        del(organization_data['portrait'])

        response = self.client.put(
            self.detail_url(self.organization.id),
            organization_data,
        )
        self.assertEqual(200, response.status_code)
        updated_organization = Organization.objects.get(
            pk=self.organization.pk)
        self.assertEqual('test-organization', updated_organization.slug)
        self.assertEqual(
            'Replaced Organization', updated_organization.name_full)
        # Note derived name fields are *not* updated
        self.assertEqual(
            'Test Organization', updated_organization.name_display)
        self.assertEqual(
            'Test Organization', updated_organization.name_sort)

    def test_update_organization_with_patch(self):
        response = self.client.patch(
            self.detail_url(self.organization.pk),
            {
                'name_full': 'Updated Organization',
            },
        )
        self.assertEqual(200, response.status_code)
        updated_organization = Organization.objects.get(
            pk=self.organization.pk)
        self.assertEqual(
            'Updated Organization', updated_organization.name_full)
        # Note other derived name fields are *not* updated
        self.assertEqual(
            'Test Organization', updated_organization.name_display)
        self.assertEqual(
            'Test Organization', updated_organization.name_sort)

    def test_delete_organization_with_delete(self):
        response = self.client.delete(self.detail_url(self.organization.pk))
        self.assertEqual(204, response.status_code)
        self.assertEqual(0, Organization.objects.count())

    def test_api_user_permissions_are_correct(self):
        counter = {'value': 0}

        def extra_item_data_for_writes_fn():
            """ Hack to return a unique `name.full` value each time """
            counter['value'] += 1
            value = counter['value']
            return {
                'name_full': 'Another Organization %d' % value,
            }

        self.assert_api_user_permissions_are_correct(
            self.organization.pk,
            Organization,
            'organizationcreator',
            extra_item_data_for_writes_fn=extra_item_data_for_writes_fn,
            item_data_fields_to_remove=['portrait']
        )


class WorkCreatorRelationshipAPITestCase(_BaseCollectionAPITestCase):
    API_NAME = 'workcreator-api'  # Set to reverse-able name for API URLs
    BASE_DATA = {
        "url": "",
        "work": {
            "url": "",
            "title": "",
            "creation_date_display": "",
            "creation_date_edtf": None,
        },
        "creator": {
            "url": "",
            "name_display": ""
        },
        "role": {
            "slug": "painter",
            "title": "Painter",
            "title_plural": "Painters",
            "past_tense": "Painted",
        },
        "is_primary": True,
        "order": 0,
    }

    def setUp(self):
        super(WorkCreatorRelationshipAPITestCase, self).setUp()

        self.artwork = Artwork.objects.create(
            title='Test Artwork',
        )

        self.person = Person.objects.create(
            name_full='Test Person',
            name_family='Person',
            name_given='Test',
        )

        self.organization = Organization.objects.create(
            name_full='Test Organization',
        )

        self.role = Role.objects.create(
            slug='painter',
            title='Painter',
            title_plural='Painters',
            past_tense='Painted',
        )
        self.workcreator = WorkCreator.objects.create(
            work=self.artwork,
            creator=self.person,
            role=self.role,
        )

    def test_list_workcreators_with_get(self):
        response = self.client.get(self.listing_url())
        self.assertEqual(200, response.status_code)
        expected = {
            'count': 1,
            'next': None,
            'previous': None,
            'results': [
                self.build_item_data({
                    "url": "http://testserver%s"
                    % self.detail_url(self.workcreator.pk),
                    "id": self.workcreator.pk,
                    "work": {
                        "url": "http://testserver%s" % reverse(
                            'api:%s-detail' % ArtworkAPITestCase.API_NAME,
                            args=[self.artwork.pk]),
                        "id": self.artwork.pk,
                        "title": self.artwork.title,
                    },
                    "creator": {
                        "url": "http://testserver%s" % reverse(
                            'api:%s-detail' % PersonAPITestCase.API_NAME,
                            args=[self.person.pk]),
                        "id": self.person.pk,
                        "name_display": self.person.name_display,
                    },
                }),
            ],
        }
        self.assertEqual(expected, response.data)

    def test_get_workcreator_detail_with_get(self):
        response = self.client.get(
            self.detail_url(self.workcreator.pk))
        self.assertEqual(200, response.status_code)
        expected = self.build_item_data({
            "url": 'http://testserver%s'
            % self.detail_url(self.workcreator.pk),
            "id": self.workcreator.pk,
            "work": {
                "url": "http://testserver%s" % reverse(
                    'api:%s-detail' % ArtworkAPITestCase.API_NAME,
                    args=[self.artwork.pk]),
                "id": self.artwork.pk,
                "title": self.artwork.title,
            },
            "creator": {
                "url": "http://testserver%s" % reverse(
                    'api:%s-detail' % PersonAPITestCase.API_NAME,
                    args=[self.person.pk]),
                "id": self.person.pk,
                "name_display": self.person.name_display,
            },
        })
        self.assertEqual(expected, response.data)

    def test_add_workcreator_with_post(self):
        response = self.client.post(
            self.listing_url(),
            {
                'work': {'id': self.artwork.pk},
                'creator': {'id': self.organization.pk},
                # Create new role
                'role': {
                    'slug': 'funder',
                    'title': 'Funder',
                    'title_plural': 'Funders',
                    'past_tense': 'Funded',
                },
            },
        )
        self.assertEqual(201, response.status_code)
        self.assertEqual(2, WorkCreator.objects.count())
        new_workcreator = WorkCreator.objects.get(pk=response.data['id'])
        self.assertEqual(self.artwork, new_workcreator.work)
        self.assertEqual(self.organization, new_workcreator.creator)
        self.assertEqual('funder', new_workcreator.role.slug)

    def test_replace_workcreator_creator_with_put(self):
        self.assertEqual(self.person, self.workcreator.creator)

        response = self.client.get(self.detail_url(self.workcreator.id))
        self.assertEqual(200, response.status_code)

        workcreator_data = response.data
        workcreator_data['creator'] = {'id': self.organization.pk}

        response = self.client.put(
            self.detail_url(self.workcreator.pk),
            workcreator_data,
        )
        self.assertEqual(200, response.status_code)
        updated_workcreator = WorkCreator.objects.get(pk=self.workcreator.pk)
        self.assertEqual(self.organization, updated_workcreator.creator)

    def test_replace_workcreator_work_with_put(self):
        self.assertEqual(self.artwork, self.workcreator.work)
        self.assertEqual(self.role, self.workcreator.role)

        response = self.client.get(self.detail_url(self.workcreator.id))
        self.assertEqual(200, response.status_code)

        film = Film.objects.create(
            title='Test Film',
        )
        role = Role.objects.create(
            slug='director',
            title='Director',
            title_plural='Directors',
            past_tense='Directed',
        )
        workcreator_data = response.data
        workcreator_data['work'] = {'id': film.pk}
        workcreator_data['role'] = {'slug': role.slug}

        response = self.client.put(
            self.detail_url(self.workcreator.pk),
            workcreator_data,
        )
        self.assertEqual(200, response.status_code)
        updated_workcreator = WorkCreator.objects.get(pk=self.workcreator.pk)
        self.assertEqual(film, updated_workcreator.work)
        self.assertEqual(role, updated_workcreator.role)

    def test_update_workcreator_with_patch(self):
        self.assertEqual(self.artwork, self.workcreator.work)
        self.assertEqual(self.person, self.workcreator.creator)

        game = Game.objects.create(
            title='Test Game',
        )
        response = self.client.patch(
            self.detail_url(self.workcreator.pk),
            {
                'work': {'id': game.pk},
                'creator': {'id': self.organization.pk},
            },
        )
        self.assertEqual(200, response.status_code)

        updated_workcreator = WorkCreator.objects.get(pk=self.workcreator.pk)
        self.assertEqual(game, updated_workcreator.work)
        self.assertEqual(self.organization, updated_workcreator.creator)

    def test_delete_workcreator_with_delete(self):
        response = self.client.delete(self.detail_url(self.workcreator.pk))
        self.assertEqual(204, response.status_code)
        self.assertEqual(0, WorkCreator.objects.count())

    def test_api_user_permissions_are_correct(self):
        def extra_item_data_for_writes_fn():
            return {
                'work': {'id': self.artwork.pk},
                'creator': {'id': self.organization.pk},
            }

        self.assert_api_user_permissions_are_correct(
            self.workcreator.pk,
            WorkCreator,
            'workcreator',
            extra_item_data_for_writes_fn=extra_item_data_for_writes_fn,
        )
