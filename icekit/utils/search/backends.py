from elasticstack.backends import ConfigurableElasticBackend, \
    ConfigurableElasticSearchEngine


class ICEkitConfigurableElasticBackend(ConfigurableElasticBackend):
    """
    ElasticSearch dropped support for facets after version 1 and forced users
    to use aggregations instead, but Haystack as of 2.6.1 does not support
    this change.
    This backend implementation aims to hack the query-building and -processing
    steps for ElasticSearch queries to translate between 'facets' as used by
    SFMOMA (and Haystack) and 'aggs' as supported by ElasticSearch 2.
    See https://www.elastic.co/guide/en/elasticsearch/reference/1.7/search-facets-migrating-to-aggs.html
    Also https://www.elastic.co/guide/en/elasticsearch/reference/1.7/search-facets.html
    
    We also want to multiply scores by the 'boost' value in the results.
    """

    def build_search_kwargs(self, *args, **kwargs):
        # wrap the search query in a 'function_score' that boosts by the
        # 'boost' field value
        search_kwargs = super(ICEkitConfigurableElasticBackend, self).build_search_kwargs(*args, **kwargs)

        if 'facets' in search_kwargs:
            search_kwargs['aggs'] = search_kwargs['facets']
            del(search_kwargs['facets'])

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

    def _process_results(self, raw_results, *args, **kwargs):
        """
        Naively translate between the 'aggregations' search result data
        structure returned by ElasticSearch 2+ in response to 'aggs' queries
        into a structure with 'facets'-like content that Haystack (2.6.1) can
        understand and process, then pass it on to Haystack's default result
        processing code.
        WARNING: Only 'terms' facet types are currently supported.
        An example result:
            {
                'hits': <BLAH>
                'aggregations': {
                    'type_exact': {
                        'doc_count_error_upper_bound': 0,
                        'sum_other_doc_count': 0,
                        'buckets': [
                            {'key': 'artwork', 'doc_count': 14145},
                            {'key': 'artist', 'doc_count': 3360},
                            {'key': 'event', 'doc_count': 2606},
                            {'key': 'exhibition', 'doc_count': 416},
                            {'key': 'essay', 'doc_count': 20},
                            {'key': 'publication', 'doc_count': 1}
                        ]
                    }
                }
            }
        Will be translated to look like:
            {
                'hits': <BLAH>
                'facets': {
                    'type_exact': {
                        '_type': 'terms',
                        'terms': [
                            {'term': 'artwork', 'count': 14145},
                            {'term': 'artist', 'count': 3360},
                            {'term': 'event', 'count': 2606},
                            {'term': 'exhibition', 'count': 416},
                            {'term': 'essay', 'count': 20},
                            {'term': 'publication', 'count': 1}
                        ]
                    }
                }
            }
        NOTE: We don't bother cleaning up the data quite this much really, we
        just translate and duplicate item names and leave the old ones in place
        for a time when Haystack may support the real returned results.
        """
        if 'aggregations' in raw_results:
            for agg_fieldname, agg_info in raw_results['aggregations'].items():
                agg_info['_type'] = 'terms'
                for bucket_item in agg_info['buckets']:
                    if 'doc_count' in bucket_item:
                        bucket_item['term'] = bucket_item['key']
                        bucket_item['count'] = bucket_item['doc_count']
                agg_info['terms'] = agg_info['buckets']
            raw_results['facets'] = raw_results['aggregations']
        return super(ICEkitConfigurableElasticBackend, self) \
            ._process_results(raw_results, *args, **kwargs)


class ICEkitConfigurableElasticSearchEngine(ConfigurableElasticSearchEngine):
    backend = ICEkitConfigurableElasticBackend
