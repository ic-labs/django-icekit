# TODO GLAMkit Collections unit tests should be in the 'glamkit-collections'
# project, not here, but that project has no test infrastructure so this is
# the quickest place and way to get some unit test coverage for now.
from django.apps import apps

from . import base_tests

Artwork = apps.get_model('gk_collections_artwork.Artwork')
Film = apps.get_model('gk_collections_film.Film')
Game = apps.get_model('gk_collections_game.Game')


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
        "date": {
            "display": "",
            "edtf": None,
        },
        "origin": {
            "country": "",
            "continent": "",
            "state_province": "",
            "city": "",
            "neighborhood": "",
            "colloquial": ""
        },
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
    }

    def setUp(self):
        super(ArtworkAPITestCase, self).setUp()

        self.artwork = Artwork.objects.create(
            slug='test-artwork',
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
                }),
                self.build_item_data({
                    "url": 'http://testserver%s'
                    % self.detail_url(self.artwork.pk),
                    "slug": "test-artwork",
                    "title": "Test Artwork",
                    "publishing_is_draft": True,
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
        })
        self.assertEqual(expected, response.data)

    def test_add_artwork_with_post(self):
        response = self.client.post(
            self.listing_url(),
            {
                'title': 'New Artwork',
                'slug': 'new-artwork',
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
                'slug': 'another-artwork-%d' % value,
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
        "date": {
            "display": "",
            "edtf": None,
        },
        "origin": {
            "country": "",
            "continent": "",
            "state_province": "",
            "city": "",
            "neighborhood": "",
            "colloquial": ""
        },
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
    }

    def setUp(self):
        super(GameAPITestCase, self).setUp()

        self.game = Game.objects.create(
            slug='test-game',
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
                }),
                self.build_item_data({
                    "url": 'http://testserver%s'
                    % self.detail_url(self.game.pk),
                    "slug": "test-game",
                    "title": "Test Game",
                    "publishing_is_draft": True,
                    "rating": None,
                    "media_type": None,
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
        })
        self.assertEqual(expected, response.data)

    def test_add_game_with_post(self):
        response = self.client.post(
            self.listing_url(),
            {
                'title': 'New Game',
                'slug': 'new-game',
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
        "date": {
            "display": "",
            "edtf": None,
        },
        "origin": {
            "continent": "",
            "country": "",
            "state_province": "",
            "city": "",
            "neighborhood": "",
            "colloquial": ""
        },
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
        "formats": []
    }

    def setUp(self):
        super(FilmAPITestCase, self).setUp()

        self.film = Film.objects.create(
            slug='test-film',
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
                }),
                self.build_item_data({
                    "url": 'http://testserver%s'
                    % self.detail_url(self.film.pk),
                    "slug": "test-film",
                    "title": "Test Film",
                    "publishing_is_draft": True,
                    "rating": None,
                    "media_type": None,
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
        })
        self.assertEqual(expected, response.data)

    def test_add_film_with_post(self):
        response = self.client.post(
            self.listing_url(),
            {
                'title': 'New Film',
                'slug': 'new-film',
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
