# Changelog

## (In developlment)
  #### When updating an existing project that uses any of the following plugins
  * brightcove
  * child_pages
  * faq
  * file
  * horizontal_rule
  * image
  * instagram_embed
  * map
  * map_with_text
  * oembed_with_caption
  * page_anchor
  * page_anchor_list
  * quote
  * reusable_form
  * slideshow
  * twitter_embed
  
  
  
  ##### You will need to make the following changes to the project:
  
  Run a manual SQL - to update migration history for renamed apps / models so that django knows that the changed apps and models migrations have already been applied
  
  in postgres:
    UPDATE django_migrations SET app='{new app label}' WHERE app='{old app label}';
    
    UPDATE django_migrations SET app='icekit_plugins_brightcove' WHERE app='brightcove';
    UPDATE django_migrations SET app='icekit_plugins_child_pages' WHERE app='child_pages';
    UPDATE django_migrations SET app='icekit_plugins_faq' WHERE app='faq';
    UPDATE django_migrations SET app='icekit_plugins_file' WHERE app='file';
    UPDATE django_migrations SET app='icekit_plugins_horizontal_rule' WHERE app='horizontal_rule';
    UPDATE django_migrations SET app='icekit_plugins_image' WHERE app='image';
    UPDATE django_migrations SET app='icekit_plugins_instagram_embed' WHERE app='instagram_embed';
    UPDATE django_migrations SET app='icekit_plugins_map' WHERE app='map';
    UPDATE django_migrations SET app='icekit_plugins_map_with_text' WHERE app='map_with_text';
    UPDATE django_migrations SET app='icekit_plugins_oembed_with_caption' WHERE app='oembed_with_caption';
    UPDATE django_migrations SET app='icekit_plugins_page_anchor' WHERE app='page_anchor';
    UPDATE django_migrations SET app='icekit_plugins_page_anchor_list' WHERE app='page_anchor_list';
    UPDATE django_migrations SET app='icekit_plugins_quote' WHERE app='quote';
    UPDATE django_migrations SET app='icekit_plugins_reusable_form' WHERE app='reusable_form';
    UPDATE django_migrations SET app='icekit_plugins_slideshow' WHERE app='slideshow';
    UPDATE django_migrations SET app='icekit_plugins_twitter_embed' WHERE app='twitter_embed';
      
  
  See also:
  [portable apps](docs/portable-apps.md)
    

## 0.1 (in development)
  * Add template tags to obtain slot contents via a descriptor.
  * Added `PlaceholderDescriptor` to allow slot contents to be accessed directly. Useful for 
  templates.
  * Initial development

Features:

  * Created app from [ixc-app-template]

[ixc-app-template]: https://github.com/ixc/ixc-app-template/
