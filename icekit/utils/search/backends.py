from elasticstack.backends import ConfigurableElasticBackend, \
    ConfigurableElasticSearchEngine


class ICEkitConfigurableElasticBackend(ConfigurableElasticBackend):

    def build_search_kwargs(self, *args, **kwargs):
        # wrap the search query in a 'function_score' that boosts by the
        # 'boost' field value
        search_kwargs = super(ICEkitConfigurableElasticBackend, self).build_search_kwargs(*args, **kwargs)
        if search_kwargs.has_key('query'):
            query = search_kwargs['query']
            d = {
                'function_score': {
                    'query': query,
                    'field_value_factor': {'field': 'boost'}
                }
            }
            search_kwargs['query'] = d

        return search_kwargs

class ICEkitConfigurableElasticSearchEngine(ConfigurableElasticSearchEngine):
    backend = ICEkitConfigurableElasticBackend
