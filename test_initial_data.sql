--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: advanced_event_listing_page_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE advanced_event_listing_page_locations (
    id integer NOT NULL,
    advancedeventlistingpage_id integer NOT NULL,
    location_id integer NOT NULL
);


--
-- Name: advanced_event_listing_page_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE advanced_event_listing_page_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: advanced_event_listing_page_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE advanced_event_listing_page_locations_id_seq OWNED BY advanced_event_listing_page_locations.id;


--
-- Name: advanced_event_listing_page_primary_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE advanced_event_listing_page_primary_types (
    id integer NOT NULL,
    advancedeventlistingpage_id integer NOT NULL,
    eventtype_id integer NOT NULL
);


--
-- Name: advanced_event_listing_page_primary_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE advanced_event_listing_page_primary_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: advanced_event_listing_page_primary_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE advanced_event_listing_page_primary_types_id_seq OWNED BY advanced_event_listing_page_primary_types.id;


--
-- Name: advanced_event_listing_page_secondary_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE advanced_event_listing_page_secondary_types (
    id integer NOT NULL,
    advancedeventlistingpage_id integer NOT NULL,
    eventtype_id integer NOT NULL
);


--
-- Name: advanced_event_listing_page_secondary_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE advanced_event_listing_page_secondary_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: advanced_event_listing_page_secondary_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE advanced_event_listing_page_secondary_types_id_seq OWNED BY advanced_event_listing_page_secondary_types.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;


--
-- Name: authtoken_token; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE authtoken_token (
    key character varying(40) NOT NULL,
    created timestamp with time zone NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: biennale_of_sydney_biennaleevent; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE biennale_of_sydney_biennaleevent (
    eventbase_ptr_id integer NOT NULL,
    list_image character varying(100) NOT NULL,
    boosted_search_terms text NOT NULL,
    event_location_id integer,
    hero_image_id integer,
    layout_id integer
);


--
-- Name: biennale_of_sydney_biennaleevent_works; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE biennale_of_sydney_biennaleevent_works (
    id integer NOT NULL,
    biennaleevent_id integer NOT NULL,
    workbase_id integer NOT NULL
);


--
-- Name: biennale_of_sydney_biennaleevent_works_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE biennale_of_sydney_biennaleevent_works_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: biennale_of_sydney_biennaleevent_works_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE biennale_of_sydney_biennaleevent_works_id_seq OWNED BY biennale_of_sydney_biennaleevent_works.id;


--
-- Name: biennale_of_sydney_biennalelocation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE biennale_of_sydney_biennalelocation (
    id integer NOT NULL,
    brief text NOT NULL,
    admin_notes text NOT NULL,
    list_image character varying(100) NOT NULL,
    boosted_search_terms text NOT NULL,
    map_description text NOT NULL,
    map_zoom integer NOT NULL,
    map_center_lat numeric(9,6),
    map_center_long numeric(9,6),
    map_center_description character varying(255) NOT NULL,
    map_marker_lat numeric(9,6),
    map_marker_long numeric(9,6),
    map_marker_description character varying(255) NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    is_home_location boolean NOT NULL,
    address text NOT NULL,
    phone_number character varying(255) NOT NULL,
    phone_number_call_to_action character varying(255) NOT NULL,
    url character varying(200) NOT NULL,
    url_call_to_action character varying(255) NOT NULL,
    email character varying(254) NOT NULL,
    email_call_to_action character varying(255) NOT NULL,
    hero_image_id integer,
    layout_id integer,
    partner_id integer,
    publishing_linked_id integer,
    CONSTRAINT biennale_of_sydney_biennalelocation_map_zoom_check CHECK ((map_zoom >= 0))
);


--
-- Name: biennale_of_sydney_biennalelocation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE biennale_of_sydney_biennalelocation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: biennale_of_sydney_biennalelocation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE biennale_of_sydney_biennalelocation_id_seq OWNED BY biennale_of_sydney_biennalelocation.id;


--
-- Name: biennale_of_sydney_eventartist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE biennale_of_sydney_eventartist (
    id integer NOT NULL,
    type character varying(15) NOT NULL,
    artist_id integer NOT NULL,
    event_id integer NOT NULL
);


--
-- Name: biennale_of_sydney_eventartist_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE biennale_of_sydney_eventartist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: biennale_of_sydney_eventartist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE biennale_of_sydney_eventartist_id_seq OWNED BY biennale_of_sydney_eventartist.id;


--
-- Name: biennale_of_sydney_exhibition; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE biennale_of_sydney_exhibition (
    occurrence_ptr_id integer NOT NULL
);


--
-- Name: biennale_of_sydney_partner; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE biennale_of_sydney_partner (
    id integer NOT NULL,
    type character varying(24) NOT NULL
);


--
-- Name: biennale_of_sydney_partner_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE biennale_of_sydney_partner_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: biennale_of_sydney_partner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE biennale_of_sydney_partner_id_seq OWNED BY biennale_of_sydney_partner.id;


--
-- Name: celery_taskmeta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE celery_taskmeta (
    id integer NOT NULL,
    task_id character varying(255) NOT NULL,
    status character varying(50) NOT NULL,
    result text,
    date_done timestamp with time zone NOT NULL,
    traceback text,
    hidden boolean NOT NULL,
    meta text
);


--
-- Name: celery_taskmeta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE celery_taskmeta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: celery_taskmeta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE celery_taskmeta_id_seq OWNED BY celery_taskmeta.id;


--
-- Name: celery_tasksetmeta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE celery_tasksetmeta (
    id integer NOT NULL,
    taskset_id character varying(255) NOT NULL,
    result text NOT NULL,
    date_done timestamp with time zone NOT NULL,
    hidden boolean NOT NULL
);


--
-- Name: celery_tasksetmeta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE celery_tasksetmeta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: celery_tasksetmeta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE celery_tasksetmeta_id_seq OWNED BY celery_tasksetmeta.id;


--
-- Name: contentitem_gk_collections_links_creatorlink; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_gk_collections_links_creatorlink (
    contentitem_ptr_id integer NOT NULL,
    style character varying(255) NOT NULL,
    type_override character varying(255) NOT NULL,
    title_override character varying(255) NOT NULL,
    url_override character varying(255) NOT NULL,
    image_override character varying(100) NOT NULL,
    item_id integer NOT NULL,
    oneliner_override character varying(255) NOT NULL
);


--
-- Name: contentitem_gk_collections_links_worklink; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_gk_collections_links_worklink (
    contentitem_ptr_id integer NOT NULL,
    style character varying(255) NOT NULL,
    type_override character varying(255) NOT NULL,
    title_override character varying(255) NOT NULL,
    url_override character varying(255) NOT NULL,
    image_override character varying(100) NOT NULL,
    item_id integer NOT NULL,
    oneliner_override character varying(255) NOT NULL
);


--
-- Name: contentitem_glamkit_sponsors_beginsponsorblockitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_glamkit_sponsors_beginsponsorblockitem (
    contentitem_ptr_id integer NOT NULL,
    text text NOT NULL
);


--
-- Name: contentitem_glamkit_sponsors_endsponsorblockitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_glamkit_sponsors_endsponsorblockitem (
    contentitem_ptr_id integer NOT NULL,
    text text NOT NULL
);


--
-- Name: contentitem_glamkit_sponsors_sponsorpromoitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_glamkit_sponsors_sponsorpromoitem (
    contentitem_ptr_id integer NOT NULL,
    title character varying(120) NOT NULL,
    width integer NOT NULL,
    quality integer NOT NULL,
    sponsor_id integer NOT NULL
);


--
-- Name: contentitem_icekit_events_links_eventlink; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_events_links_eventlink (
    contentitem_ptr_id integer NOT NULL,
    style character varying(255) NOT NULL,
    type_override character varying(255) NOT NULL,
    title_override character varying(255) NOT NULL,
    oneliner_override character varying(255) NOT NULL,
    url_override character varying(255) NOT NULL,
    image_override character varying(100) NOT NULL,
    item_id integer NOT NULL,
    include_even_when_finished boolean NOT NULL
);


--
-- Name: contentitem_icekit_navigation_accountsnavigationitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_navigation_accountsnavigationitem (
    contentitem_ptr_id integer NOT NULL
);


--
-- Name: contentitem_icekit_navigation_navigationitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_navigation_navigationitem (
    contentitem_ptr_id integer NOT NULL,
    title character varying(255) NOT NULL,
    url character varying(300) NOT NULL,
    html_class character varying(255) NOT NULL
);


--
-- Name: contentitem_icekit_plugins_child_pages_childpageitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_child_pages_childpageitem (
    contentitem_ptr_id integer NOT NULL
);


--
-- Name: contentitem_icekit_plugins_contact_person_contactpersonitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_contact_person_contactpersonitem (
    contentitem_ptr_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: contentitem_icekit_plugins_content_listing_contentlistingitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_content_listing_contentlistingitem (
    contentitem_ptr_id integer NOT NULL,
    content_type_id integer NOT NULL,
    "limit" integer,
    no_items_message character varying(255)
);


--
-- Name: contentitem_icekit_plugins_faq_faqitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_faq_faqitem (
    contentitem_ptr_id integer NOT NULL,
    question text NOT NULL,
    answer text NOT NULL,
    load_open boolean NOT NULL
);


--
-- Name: contentitem_icekit_plugins_file_fileitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_file_fileitem (
    contentitem_ptr_id integer NOT NULL,
    file_id integer NOT NULL
);


--
-- Name: contentitem_icekit_plugins_horizontal_rule_horizontalruleitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_horizontal_rule_horizontalruleitem (
    contentitem_ptr_id integer NOT NULL
);


--
-- Name: contentitem_icekit_plugins_image_imageitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_image_imageitem (
    contentitem_ptr_id integer NOT NULL,
    image_id integer NOT NULL,
    caption_override text NOT NULL,
    show_caption boolean NOT NULL,
    show_title boolean NOT NULL,
    title_override character varying(512) NOT NULL
);


--
-- Name: contentitem_icekit_plugins_instagram_embed_instagramembeditem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_instagram_embed_instagramembeditem (
    contentitem_ptr_id integer NOT NULL,
    url character varying(200) NOT NULL,
    provider_url character varying(512) NOT NULL,
    media_id character varying(255) NOT NULL,
    author_name character varying(255) NOT NULL,
    height integer,
    width integer,
    thumbnail_url character varying(255) NOT NULL,
    thumbnail_width integer,
    thumbnail_height integer,
    provider_name character varying(255) NOT NULL,
    title character varying(512) NOT NULL,
    html text NOT NULL,
    version character varying(20) NOT NULL,
    author_url character varying(255) NOT NULL,
    author_id integer,
    type character varying(50) NOT NULL,
    CONSTRAINT contentitem_instagram_embed_instagramemb_thumbnail_height_check CHECK ((thumbnail_height >= 0)),
    CONSTRAINT contentitem_instagram_embed_instagramembe_thumbnail_width_check CHECK ((thumbnail_width >= 0)),
    CONSTRAINT contentitem_instagram_embed_instagramembeditem_author_id_check CHECK ((author_id >= 0)),
    CONSTRAINT contentitem_instagram_embed_instagramembeditem_height_check CHECK ((height >= 0)),
    CONSTRAINT contentitem_instagram_embed_instagramembeditem_width_check CHECK ((width >= 0))
);


--
-- Name: contentitem_icekit_plugins_location_locationitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_location_locationitem (
    contentitem_ptr_id integer NOT NULL,
    location_id integer NOT NULL
);


--
-- Name: contentitem_icekit_plugins_map_mapitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_map_mapitem (
    contentitem_ptr_id integer NOT NULL,
    _cleaned_embed_code text NOT NULL,
    _embed_code text NOT NULL
);


--
-- Name: contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem (
    contentitem_ptr_id integer NOT NULL
);


--
-- Name: contentitem_icekit_plugins_page_anchor_pageanchoritem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_page_anchor_pageanchoritem (
    contentitem_ptr_id integer NOT NULL,
    anchor_name character varying(60) NOT NULL
);


--
-- Name: contentitem_icekit_plugins_quote_quoteitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_quote_quoteitem (
    contentitem_ptr_id integer NOT NULL,
    quote text NOT NULL,
    attribution character varying(255) NOT NULL,
    organisation character varying(255) NOT NULL,
    url character varying(200) NOT NULL
);


--
-- Name: contentitem_icekit_plugins_reusable_form_formitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_reusable_form_formitem (
    contentitem_ptr_id integer NOT NULL,
    form_id integer NOT NULL
);


--
-- Name: contentitem_icekit_plugins_slideshow_slideshowitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_slideshow_slideshowitem (
    contentitem_ptr_id integer NOT NULL,
    slide_show_id integer NOT NULL
);


--
-- Name: contentitem_icekit_plugins_twitter_embed_twitterembeditem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_twitter_embed_twitterembeditem (
    contentitem_ptr_id integer NOT NULL,
    twitter_url character varying(200) NOT NULL,
    url character varying(512) NOT NULL,
    provider_url character varying(512) NOT NULL,
    cache_age character varying(255) NOT NULL,
    author_name character varying(255) NOT NULL,
    height integer,
    width integer,
    provider_name character varying(255) NOT NULL,
    version character varying(20) NOT NULL,
    author_url character varying(255) NOT NULL,
    type character varying(50) NOT NULL,
    html text NOT NULL,
    CONSTRAINT contentitem_twitter_embed_twitterembeditem_height_check CHECK ((height >= 0)),
    CONSTRAINT contentitem_twitter_embed_twitterembeditem_width_check CHECK ((width >= 0))
);


--
-- Name: contentitem_iframe_iframeitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_iframe_iframeitem (
    contentitem_ptr_id integer NOT NULL,
    src character varying(200) NOT NULL,
    width character varying(10) NOT NULL,
    height character varying(10) NOT NULL
);


--
-- Name: contentitem_ik_event_listing_eventcontentlistingitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_ik_event_listing_eventcontentlistingitem (
    contentitem_ptr_id integer NOT NULL,
    "limit" integer,
    content_type_id integer NOT NULL,
    from_date timestamp with time zone,
    from_days_ago integer,
    to_date timestamp with time zone,
    to_days_ahead integer,
    no_items_message character varying(255)
);


--
-- Name: contentitem_ik_events_todays_occurrences_todaysoccurrences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_ik_events_todays_occurrences_todaysoccurrences (
    contentitem_ptr_id integer NOT NULL,
    include_finished boolean NOT NULL,
    fall_back_to_next_day boolean NOT NULL,
    title character varying(255) NOT NULL
);


--
-- Name: contentitem_ik_links_articlelink; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_ik_links_articlelink (
    contentitem_ptr_id integer NOT NULL,
    style character varying(255) NOT NULL,
    type_override character varying(255) NOT NULL,
    title_override character varying(255) NOT NULL,
    image_override character varying(100) NOT NULL,
    item_id integer NOT NULL,
    url_override character varying(255) NOT NULL,
    oneliner_override character varying(255) NOT NULL
);


--
-- Name: contentitem_ik_links_authorlink; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_ik_links_authorlink (
    contentitem_ptr_id integer NOT NULL,
    style character varying(255) NOT NULL,
    type_override character varying(255) NOT NULL,
    title_override character varying(255) NOT NULL,
    image_override character varying(100) NOT NULL,
    item_id integer NOT NULL,
    url_override character varying(255) NOT NULL,
    oneliner_override character varying(255) NOT NULL,
    exclude_from_contributions boolean NOT NULL,
    exclude_from_authorship boolean NOT NULL
);


--
-- Name: contentitem_ik_links_pagelink; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_ik_links_pagelink (
    contentitem_ptr_id integer NOT NULL,
    style character varying(255) NOT NULL,
    type_override character varying(255) NOT NULL,
    title_override character varying(255) NOT NULL,
    image_override character varying(100) NOT NULL,
    item_id integer NOT NULL,
    url_override character varying(255) NOT NULL,
    oneliner_override character varying(255) NOT NULL
);


--
-- Name: contentitem_image_gallery_imagegalleryshowitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_image_gallery_imagegalleryshowitem (
    contentitem_ptr_id integer NOT NULL,
    slide_show_id integer NOT NULL
);


--
-- Name: contentitem_media_coverage_mediacoveragelist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_media_coverage_mediacoveragelist (
    contentitem_ptr_id integer NOT NULL
);


--
-- Name: contentitem_media_coverage_mediacoveragepromoitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_media_coverage_mediacoveragepromoitem (
    contentitem_ptr_id integer NOT NULL,
    media_coverage_id integer NOT NULL
);


--
-- Name: contentitem_oembed_with_caption_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_oembed_with_caption_item (
    contentitem_ptr_id integer NOT NULL,
    embed_url character varying(200) NOT NULL,
    embed_max_width integer,
    embed_max_height integer,
    type character varying(20),
    url character varying(200),
    title character varying(512),
    description text,
    author_name character varying(255),
    author_url character varying(200),
    provider_name character varying(255),
    provider_url character varying(200),
    thumbnail_url character varying(200),
    thumbnail_height integer,
    thumbnail_width integer,
    height integer,
    width integer,
    html text,
    caption text NOT NULL,
    is_16by9 boolean NOT NULL,
    content_title character varying(1000) NOT NULL,
    CONSTRAINT contentitem_oembed_with_caption_oembedwi_embed_max_height_check CHECK ((embed_max_height >= 0)),
    CONSTRAINT contentitem_oembed_with_caption_oembedwit_embed_max_width_check CHECK ((embed_max_width >= 0))
);


--
-- Name: contentitem_oembeditem_oembeditem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_oembeditem_oembeditem (
    contentitem_ptr_id integer NOT NULL,
    embed_url character varying(200) NOT NULL,
    embed_max_width integer,
    embed_max_height integer,
    type character varying(20),
    url character varying(200),
    title character varying(512),
    description text,
    author_name character varying(255),
    author_url character varying(200),
    provider_name character varying(255),
    provider_url character varying(200),
    thumbnail_url character varying(200),
    thumbnail_height integer,
    thumbnail_width integer,
    height integer,
    width integer,
    html text,
    CONSTRAINT contentitem_oembeditem_oembeditem_embed_max_height_check CHECK ((embed_max_height >= 0)),
    CONSTRAINT contentitem_oembeditem_oembeditem_embed_max_width_check CHECK ((embed_max_width >= 0))
);


--
-- Name: contentitem_rawhtml_rawhtmlitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_rawhtml_rawhtmlitem (
    contentitem_ptr_id integer NOT NULL,
    html text NOT NULL
);


--
-- Name: contentitem_sharedcontent_sharedcontentitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_sharedcontent_sharedcontentitem (
    contentitem_ptr_id integer NOT NULL,
    shared_content_id integer NOT NULL
);


--
-- Name: contentitem_staff_profile_list_staffprofileslist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_staff_profile_list_staffprofileslist (
    contentitem_ptr_id integer NOT NULL
);


--
-- Name: contentitem_text_textitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_text_textitem (
    contentitem_ptr_id integer NOT NULL,
    text text NOT NULL,
    style character varying(255) NOT NULL
);


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE django_admin_log_id_seq OWNED BY django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE django_migrations_id_seq OWNED BY django_migrations.id;


--
-- Name: django_redirect; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE django_redirect (
    id integer NOT NULL,
    site_id integer NOT NULL,
    old_path character varying(200) NOT NULL,
    new_path character varying(200) NOT NULL
);


--
-- Name: django_redirect_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE django_redirect_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: django_redirect_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE django_redirect_id_seq OWNED BY django_redirect.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


--
-- Name: django_site; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


--
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE django_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE django_site_id_seq OWNED BY django_site.id;


--
-- Name: djcelery_crontabschedule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE djcelery_crontabschedule (
    id integer NOT NULL,
    minute character varying(64) NOT NULL,
    hour character varying(64) NOT NULL,
    day_of_week character varying(64) NOT NULL,
    day_of_month character varying(64) NOT NULL,
    month_of_year character varying(64) NOT NULL
);


--
-- Name: djcelery_crontabschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE djcelery_crontabschedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: djcelery_crontabschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE djcelery_crontabschedule_id_seq OWNED BY djcelery_crontabschedule.id;


--
-- Name: djcelery_intervalschedule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE djcelery_intervalschedule (
    id integer NOT NULL,
    every integer NOT NULL,
    period character varying(24) NOT NULL
);


--
-- Name: djcelery_intervalschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE djcelery_intervalschedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: djcelery_intervalschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE djcelery_intervalschedule_id_seq OWNED BY djcelery_intervalschedule.id;


--
-- Name: djcelery_periodictask; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE djcelery_periodictask (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    task character varying(200) NOT NULL,
    args text NOT NULL,
    kwargs text NOT NULL,
    queue character varying(200),
    exchange character varying(200),
    routing_key character varying(200),
    expires timestamp with time zone,
    enabled boolean NOT NULL,
    last_run_at timestamp with time zone,
    total_run_count integer NOT NULL,
    date_changed timestamp with time zone NOT NULL,
    description text NOT NULL,
    crontab_id integer,
    interval_id integer,
    CONSTRAINT djcelery_periodictask_total_run_count_check CHECK ((total_run_count >= 0))
);


--
-- Name: djcelery_periodictask_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE djcelery_periodictask_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: djcelery_periodictask_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE djcelery_periodictask_id_seq OWNED BY djcelery_periodictask.id;


--
-- Name: djcelery_periodictasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE djcelery_periodictasks (
    ident smallint NOT NULL,
    last_update timestamp with time zone NOT NULL
);


--
-- Name: djcelery_taskstate; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE djcelery_taskstate (
    id integer NOT NULL,
    state character varying(64) NOT NULL,
    task_id character varying(36) NOT NULL,
    name character varying(200),
    tstamp timestamp with time zone NOT NULL,
    args text,
    kwargs text,
    eta timestamp with time zone,
    expires timestamp with time zone,
    result text,
    traceback text,
    runtime double precision,
    retries integer NOT NULL,
    hidden boolean NOT NULL,
    worker_id integer
);


--
-- Name: djcelery_taskstate_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE djcelery_taskstate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: djcelery_taskstate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE djcelery_taskstate_id_seq OWNED BY djcelery_taskstate.id;


--
-- Name: djcelery_workerstate; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE djcelery_workerstate (
    id integer NOT NULL,
    hostname character varying(255) NOT NULL,
    last_heartbeat timestamp with time zone
);


--
-- Name: djcelery_workerstate_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE djcelery_workerstate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: djcelery_workerstate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE djcelery_workerstate_id_seq OWNED BY djcelery_workerstate.id;


--
-- Name: djkombu_message; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE djkombu_message (
    id integer NOT NULL,
    visible boolean NOT NULL,
    sent_at timestamp with time zone,
    payload text NOT NULL,
    queue_id integer NOT NULL
);


--
-- Name: djkombu_message_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE djkombu_message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: djkombu_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE djkombu_message_id_seq OWNED BY djkombu_message.id;


--
-- Name: djkombu_queue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE djkombu_queue (
    id integer NOT NULL,
    name character varying(200) NOT NULL
);


--
-- Name: djkombu_queue_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE djkombu_queue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: djkombu_queue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE djkombu_queue_id_seq OWNED BY djkombu_queue.id;


--
-- Name: easy_thumbnails_source; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE easy_thumbnails_source (
    id integer NOT NULL,
    storage_hash character varying(40) NOT NULL,
    name character varying(255) NOT NULL,
    modified timestamp with time zone NOT NULL
);


--
-- Name: easy_thumbnails_source_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE easy_thumbnails_source_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: easy_thumbnails_source_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE easy_thumbnails_source_id_seq OWNED BY easy_thumbnails_source.id;


--
-- Name: easy_thumbnails_thumbnail; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE easy_thumbnails_thumbnail (
    id integer NOT NULL,
    storage_hash character varying(40) NOT NULL,
    name character varying(255) NOT NULL,
    modified timestamp with time zone NOT NULL,
    source_id integer NOT NULL
);


--
-- Name: easy_thumbnails_thumbnail_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE easy_thumbnails_thumbnail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: easy_thumbnails_thumbnail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE easy_thumbnails_thumbnail_id_seq OWNED BY easy_thumbnails_thumbnail.id;


--
-- Name: easy_thumbnails_thumbnaildimensions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE easy_thumbnails_thumbnaildimensions (
    id integer NOT NULL,
    thumbnail_id integer NOT NULL,
    width integer,
    height integer,
    CONSTRAINT easy_thumbnails_thumbnaildimensions_height_check CHECK ((height >= 0)),
    CONSTRAINT easy_thumbnails_thumbnaildimensions_width_check CHECK ((width >= 0))
);


--
-- Name: easy_thumbnails_thumbnaildimensions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE easy_thumbnails_thumbnaildimensions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: easy_thumbnails_thumbnaildimensions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE easy_thumbnails_thumbnaildimensions_id_seq OWNED BY easy_thumbnails_thumbnaildimensions.id;


--
-- Name: icekit_plugins_file_file_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_plugins_file_file_categories (
    id integer NOT NULL,
    file_id integer NOT NULL,
    mediacategory_id integer NOT NULL
);


--
-- Name: file_file_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE file_file_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: file_file_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE file_file_categories_id_seq OWNED BY icekit_plugins_file_file_categories.id;


--
-- Name: icekit_plugins_file_file; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_plugins_file_file (
    id integer NOT NULL,
    file character varying(100) NOT NULL,
    title character varying(255) NOT NULL,
    is_active boolean NOT NULL,
    admin_notes text NOT NULL
);


--
-- Name: file_file_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE file_file_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: file_file_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE file_file_id_seq OWNED BY icekit_plugins_file_file.id;


--
-- Name: fluent_contents_contentitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fluent_contents_contentitem (
    id integer NOT NULL,
    parent_id integer,
    language_code character varying(15) NOT NULL,
    sort_order integer NOT NULL,
    parent_type_id integer NOT NULL,
    placeholder_id integer,
    polymorphic_ctype_id integer
);


--
-- Name: fluent_contents_contentitem_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fluent_contents_contentitem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fluent_contents_contentitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fluent_contents_contentitem_id_seq OWNED BY fluent_contents_contentitem.id;


--
-- Name: fluent_contents_placeholder; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fluent_contents_placeholder (
    id integer NOT NULL,
    slot character varying(50) NOT NULL,
    role character varying(1) NOT NULL,
    parent_id integer,
    title character varying(255) NOT NULL,
    parent_type_id integer
);


--
-- Name: fluent_contents_placeholder_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fluent_contents_placeholder_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fluent_contents_placeholder_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fluent_contents_placeholder_id_seq OWNED BY fluent_contents_placeholder.id;


--
-- Name: fluent_pages_htmlpage_translation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fluent_pages_htmlpage_translation (
    id integer NOT NULL,
    language_code character varying(15) NOT NULL,
    meta_keywords character varying(255) NOT NULL,
    meta_description character varying(255) NOT NULL,
    meta_title character varying(255) NOT NULL,
    master_id integer,
    meta_image character varying(100) NOT NULL
);


--
-- Name: fluent_pages_htmlpage_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fluent_pages_htmlpage_translation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fluent_pages_htmlpage_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fluent_pages_htmlpage_translation_id_seq OWNED BY fluent_pages_htmlpage_translation.id;


--
-- Name: fluent_pages_pagelayout; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fluent_pages_pagelayout (
    id integer NOT NULL,
    key character varying(50) NOT NULL,
    title character varying(255) NOT NULL,
    template_path character varying(100) NOT NULL
);


--
-- Name: fluent_pages_pagelayout_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fluent_pages_pagelayout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fluent_pages_pagelayout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fluent_pages_pagelayout_id_seq OWNED BY fluent_pages_pagelayout.id;


--
-- Name: fluent_pages_urlnode; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fluent_pages_urlnode (
    id integer NOT NULL,
    lft integer NOT NULL,
    rght integer NOT NULL,
    tree_id integer NOT NULL,
    level integer NOT NULL,
    status character varying(1) NOT NULL,
    publication_date timestamp with time zone,
    publication_end_date timestamp with time zone,
    in_navigation boolean NOT NULL,
    in_sitemaps boolean NOT NULL,
    key character varying(50),
    creation_date timestamp with time zone NOT NULL,
    modification_date timestamp with time zone NOT NULL,
    author_id integer NOT NULL,
    parent_id integer,
    parent_site_id integer NOT NULL,
    polymorphic_ctype_id integer,
    CONSTRAINT fluent_pages_urlnode_level_check CHECK ((level >= 0)),
    CONSTRAINT fluent_pages_urlnode_lft_check CHECK ((lft >= 0)),
    CONSTRAINT fluent_pages_urlnode_rght_check CHECK ((rght >= 0)),
    CONSTRAINT fluent_pages_urlnode_tree_id_check CHECK ((tree_id >= 0))
);


--
-- Name: fluent_pages_urlnode_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fluent_pages_urlnode_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fluent_pages_urlnode_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fluent_pages_urlnode_id_seq OWNED BY fluent_pages_urlnode.id;


--
-- Name: fluent_pages_urlnode_translation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fluent_pages_urlnode_translation (
    id integer NOT NULL,
    language_code character varying(15) NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(100) NOT NULL,
    override_url character varying(255) NOT NULL,
    _cached_url character varying(255),
    master_id integer
);


--
-- Name: fluent_pages_urlnode_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fluent_pages_urlnode_translation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fluent_pages_urlnode_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fluent_pages_urlnode_translation_id_seq OWNED BY fluent_pages_urlnode_translation.id;


--
-- Name: forms_field; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE forms_field (
    id integer NOT NULL,
    label character varying(200) NOT NULL,
    slug character varying(100) NOT NULL,
    field_type integer NOT NULL,
    required boolean NOT NULL,
    visible boolean NOT NULL,
    choices character varying(1000) NOT NULL,
    "default" character varying(2000) NOT NULL,
    placeholder_text character varying(100),
    help_text character varying(100) NOT NULL,
    "order" integer,
    form_id integer NOT NULL
);


--
-- Name: forms_field_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forms_field_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forms_field_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forms_field_id_seq OWNED BY forms_field.id;


--
-- Name: forms_fieldentry; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE forms_fieldentry (
    id integer NOT NULL,
    field_id integer NOT NULL,
    value character varying(2000),
    entry_id integer NOT NULL
);


--
-- Name: forms_fieldentry_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forms_fieldentry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forms_fieldentry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forms_fieldentry_id_seq OWNED BY forms_fieldentry.id;


--
-- Name: forms_form; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE forms_form (
    id integer NOT NULL,
    title character varying(50) NOT NULL,
    slug character varying(100) NOT NULL,
    intro text NOT NULL,
    button_text character varying(50) NOT NULL,
    response text NOT NULL,
    redirect_url character varying(200),
    status integer NOT NULL,
    publish_date timestamp with time zone,
    expiry_date timestamp with time zone,
    login_required boolean NOT NULL,
    send_email boolean NOT NULL,
    email_from character varying(254) NOT NULL,
    email_copies character varying(200) NOT NULL,
    email_subject character varying(200) NOT NULL,
    email_message text NOT NULL
);


--
-- Name: forms_form_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forms_form_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forms_form_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forms_form_id_seq OWNED BY forms_form.id;


--
-- Name: forms_form_sites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE forms_form_sites (
    id integer NOT NULL,
    form_id integer NOT NULL,
    site_id integer NOT NULL
);


--
-- Name: forms_form_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forms_form_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forms_form_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forms_form_sites_id_seq OWNED BY forms_form_sites.id;


--
-- Name: forms_formentry; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE forms_formentry (
    id integer NOT NULL,
    entry_time timestamp with time zone NOT NULL,
    form_id integer NOT NULL
);


--
-- Name: forms_formentry_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forms_formentry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forms_formentry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forms_formentry_id_seq OWNED BY forms_formentry.id;


--
-- Name: gk_collections_artwork_artwork; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_artwork_artwork (
    workbase_ptr_id integer NOT NULL,
    medium_display character varying(255) NOT NULL,
    dimensions_is_two_dimensional boolean NOT NULL,
    dimensions_display character varying(255) NOT NULL,
    dimensions_extent character varying(255) NOT NULL,
    dimensions_width_cm double precision,
    dimensions_height_cm double precision,
    dimensions_depth_cm double precision,
    dimensions_weight_kg double precision
);


--
-- Name: gk_collections_film_film; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_film_film (
    workbase_ptr_id integer NOT NULL,
    rating_annotation character varying(255) NOT NULL,
    imdb_link character varying(200) NOT NULL,
    media_type_id integer,
    rating_id integer,
    trailer character varying(200) NOT NULL,
    duration_minutes integer,
    CONSTRAINT gk_collections_film_film_duration_minutes_check CHECK ((duration_minutes >= 0))
);


--
-- Name: gk_collections_film_film_formats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_film_film_formats (
    id integer NOT NULL,
    film_id integer NOT NULL,
    format_id integer NOT NULL
);


--
-- Name: gk_collections_film_film_formats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_film_film_formats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_film_film_formats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_film_film_formats_id_seq OWNED BY gk_collections_film_film_formats.id;


--
-- Name: gk_collections_film_film_genres; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_film_film_genres (
    id integer NOT NULL,
    film_id integer NOT NULL,
    genre_id integer NOT NULL
);


--
-- Name: gk_collections_film_film_genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_film_film_genres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_film_film_genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_film_film_genres_id_seq OWNED BY gk_collections_film_film_genres.id;


--
-- Name: gk_collections_film_format; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_film_format (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL
);


--
-- Name: gk_collections_film_format_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_film_format_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_film_format_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_film_format_id_seq OWNED BY gk_collections_film_format.id;


--
-- Name: gk_collections_game_game; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_game_game (
    workbase_ptr_id integer NOT NULL,
    rating_annotation character varying(255) NOT NULL,
    imdb_link character varying(200) NOT NULL,
    is_single_player boolean NOT NULL,
    is_multi_player boolean NOT NULL,
    media_type_id integer,
    rating_id integer,
    trailer character varying(200) NOT NULL,
    duration_minutes integer,
    CONSTRAINT gk_collections_game_game_duration_minutes_check CHECK ((duration_minutes >= 0))
);


--
-- Name: gk_collections_game_game_genres; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_game_game_genres (
    id integer NOT NULL,
    game_id integer NOT NULL,
    genre_id integer NOT NULL
);


--
-- Name: gk_collections_game_game_genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_game_game_genres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_game_game_genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_game_game_genres_id_seq OWNED BY gk_collections_game_game_genres.id;


--
-- Name: gk_collections_game_game_input_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_game_game_input_types (
    id integer NOT NULL,
    game_id integer NOT NULL,
    gameinputtype_id integer NOT NULL
);


--
-- Name: gk_collections_game_game_input_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_game_game_input_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_game_game_input_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_game_game_input_types_id_seq OWNED BY gk_collections_game_game_input_types.id;


--
-- Name: gk_collections_game_game_platforms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_game_game_platforms (
    id integer NOT NULL,
    game_id integer NOT NULL,
    gameplatform_id integer NOT NULL
);


--
-- Name: gk_collections_game_game_platforms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_game_game_platforms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_game_game_platforms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_game_game_platforms_id_seq OWNED BY gk_collections_game_game_platforms.id;


--
-- Name: gk_collections_game_gameinputtype; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_game_gameinputtype (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL
);


--
-- Name: gk_collections_game_gameinputtype_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_game_gameinputtype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_game_gameinputtype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_game_gameinputtype_id_seq OWNED BY gk_collections_game_gameinputtype.id;


--
-- Name: gk_collections_game_gameplatform; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_game_gameplatform (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL
);


--
-- Name: gk_collections_game_gameplatform_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_game_gameplatform_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_game_gameplatform_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_game_gameplatform_id_seq OWNED BY gk_collections_game_gameplatform.id;


--
-- Name: gk_collections_moving_image_genre; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_moving_image_genre (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL
);


--
-- Name: gk_collections_moving_image_genre_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_moving_image_genre_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_moving_image_genre_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_moving_image_genre_id_seq OWNED BY gk_collections_moving_image_genre.id;


--
-- Name: gk_collections_moving_image_mediatype; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_moving_image_mediatype (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    title_plural character varying(255) NOT NULL
);


--
-- Name: gk_collections_moving_image_mediatype_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_moving_image_mediatype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_moving_image_mediatype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_moving_image_mediatype_id_seq OWNED BY gk_collections_moving_image_mediatype.id;


--
-- Name: gk_collections_moving_image_movingimagework; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_moving_image_movingimagework (
    workbase_ptr_id integer NOT NULL,
    rating_annotation character varying(255) NOT NULL,
    imdb_link character varying(200) NOT NULL,
    media_type_id integer,
    rating_id integer,
    trailer character varying(200) NOT NULL,
    duration_minutes integer,
    CONSTRAINT gk_collections_moving_image_movingimagew_duration_minutes_check CHECK ((duration_minutes >= 0))
);


--
-- Name: gk_collections_moving_image_movingimagework_genres; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_moving_image_movingimagework_genres (
    id integer NOT NULL,
    movingimagework_id integer NOT NULL,
    genre_id integer NOT NULL
);


--
-- Name: gk_collections_moving_image_movingimagework_genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_moving_image_movingimagework_genres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_moving_image_movingimagework_genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_moving_image_movingimagework_genres_id_seq OWNED BY gk_collections_moving_image_movingimagework_genres.id;


--
-- Name: gk_collections_moving_image_rating; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_moving_image_rating (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    image character varying(100) NOT NULL
);


--
-- Name: gk_collections_moving_image_rating_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_moving_image_rating_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_moving_image_rating_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_moving_image_rating_id_seq OWNED BY gk_collections_moving_image_rating.id;


--
-- Name: gk_collections_organization_organizationcreator; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_organization_organizationcreator (
    creatorbase_ptr_id integer NOT NULL
);


--
-- Name: gk_collections_person_personcreator; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_person_personcreator (
    creatorbase_ptr_id integer NOT NULL,
    name_given character varying(255) NOT NULL,
    name_family character varying(255) NOT NULL,
    gender character varying(255) NOT NULL,
    primary_occupation character varying(255) NOT NULL,
    birth_place character varying(255) NOT NULL,
    birth_place_historic character varying(255) NOT NULL,
    death_place character varying(255) NOT NULL,
    background_ethnicity character varying(255) NOT NULL,
    background_nationality character varying(255) NOT NULL,
    background_neighborhood character varying(255) NOT NULL,
    background_city character varying(255) NOT NULL,
    background_state_province character varying(255) NOT NULL,
    background_country character varying(255) NOT NULL,
    background_continent character varying(255) NOT NULL
);


--
-- Name: gk_collections_work_creator_creatorbase; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_work_creator_creatorbase (
    id integer NOT NULL,
    list_image character varying(100) NOT NULL,
    boosted_search_terms text NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    name_display character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    alt_slug character varying(255) NOT NULL,
    website character varying(255) NOT NULL,
    wikipedia_link character varying(200) NOT NULL,
    admin_notes text NOT NULL,
    name_sort character varying(255) NOT NULL,
    layout_id integer,
    polymorphic_ctype_id integer,
    portrait_id integer,
    publishing_linked_id integer,
    name_full character varying(255) NOT NULL,
    dt_created timestamp with time zone NOT NULL,
    dt_modified timestamp with time zone NOT NULL,
    external_ref character varying(255),
    brief text NOT NULL,
    end_date_display character varying(255) NOT NULL,
    end_date_earliest date,
    end_date_edtf character varying(2000),
    end_date_latest date,
    end_date_sort_ascending date,
    end_date_sort_descending date,
    start_date_display character varying(255) NOT NULL,
    start_date_earliest date,
    start_date_edtf character varying(2000),
    start_date_latest date,
    start_date_sort_ascending date,
    start_date_sort_descending date
);


--
-- Name: gk_collections_work_creator_creatorbase_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_work_creator_creatorbase_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_work_creator_creatorbase_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_work_creator_creatorbase_id_seq OWNED BY gk_collections_work_creator_creatorbase.id;


--
-- Name: gk_collections_work_creator_personcreator; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_work_creator_personcreator (
    creatorbase_ptr_id integer NOT NULL,
    name_given character varying(255) NOT NULL,
    name_family character varying(255) NOT NULL,
    gender character varying(255) NOT NULL,
    primary_occupation character varying(255) NOT NULL,
    birth_place character varying(255) NOT NULL,
    birth_place_historic character varying(255) NOT NULL,
    death_place character varying(255) NOT NULL,
    background_ethnicity character varying(255) NOT NULL,
    background_nationality character varying(255) NOT NULL,
    background_neighborhood character varying(255) NOT NULL,
    background_city character varying(255) NOT NULL,
    background_state_province character varying(255) NOT NULL,
    background_country character varying(255) NOT NULL,
    background_continent character varying(255) NOT NULL
);


--
-- Name: gk_collections_work_creator_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_work_creator_role (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    past_tense character varying(255) NOT NULL,
    title_plural character varying(255) NOT NULL
);


--
-- Name: gk_collections_work_creator_role_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_work_creator_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_work_creator_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_work_creator_role_id_seq OWNED BY gk_collections_work_creator_role.id;


--
-- Name: gk_collections_work_creator_workbase; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_work_creator_workbase (
    id integer NOT NULL,
    list_image character varying(100) NOT NULL,
    boosted_search_terms text NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    slug character varying(255) NOT NULL,
    alt_slug character varying(255) NOT NULL,
    title character varying(511) NOT NULL,
    creation_date_display character varying(255) NOT NULL,
    credit_line text NOT NULL,
    accession_number character varying(255) NOT NULL,
    website character varying(200) NOT NULL,
    wikipedia_link character varying(200) NOT NULL,
    admin_notes text NOT NULL,
    layout_id integer,
    polymorphic_ctype_id integer,
    publishing_linked_id integer,
    department character varying(255) NOT NULL,
    oneliner character varying(511) NOT NULL,
    subtitle character varying(511) NOT NULL,
    creation_date_earliest date,
    creation_date_latest date,
    creation_date_sort_ascending date,
    creation_date_sort_descending date,
    dt_created timestamp with time zone NOT NULL,
    dt_modified timestamp with time zone NOT NULL,
    external_ref character varying(255),
    brief text NOT NULL,
    creation_date_edtf character varying(2000)
);


--
-- Name: gk_collections_work_creator_workbase_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_work_creator_workbase_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_work_creator_workbase_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_work_creator_workbase_id_seq OWNED BY gk_collections_work_creator_workbase.id;


--
-- Name: gk_collections_work_creator_workcreator; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_work_creator_workcreator (
    id integer NOT NULL,
    "order" integer NOT NULL,
    is_primary boolean NOT NULL,
    creator_id integer NOT NULL,
    role_id integer,
    work_id integer NOT NULL,
    CONSTRAINT gk_collections_work_creator_workcreator_order_check CHECK (("order" >= 0))
);


--
-- Name: gk_collections_work_creator_workcreator_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_work_creator_workcreator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_work_creator_workcreator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_work_creator_workcreator_id_seq OWNED BY gk_collections_work_creator_workcreator.id;


--
-- Name: gk_collections_work_creator_workimage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_work_creator_workimage (
    id integer NOT NULL,
    show_title boolean NOT NULL,
    show_caption boolean NOT NULL,
    title_override character varying(512) NOT NULL,
    caption_override text NOT NULL,
    "order" integer NOT NULL,
    image_id integer NOT NULL,
    type_id integer,
    work_id integer NOT NULL,
    CONSTRAINT gk_collections_work_creator_workimage_order_check CHECK (("order" >= 0))
);


--
-- Name: gk_collections_work_creator_workimage_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_work_creator_workimage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_work_creator_workimage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_work_creator_workimage_id_seq OWNED BY gk_collections_work_creator_workimage.id;


--
-- Name: gk_collections_work_creator_workimagetype; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_work_creator_workimagetype (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL
);


--
-- Name: gk_collections_work_creator_workimagetype_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_work_creator_workimagetype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_work_creator_workimagetype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_work_creator_workimagetype_id_seq OWNED BY gk_collections_work_creator_workimagetype.id;


--
-- Name: gk_collections_work_creator_workorigin; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gk_collections_work_creator_workorigin (
    id integer NOT NULL,
    "order" integer NOT NULL,
    geographic_location_id integer NOT NULL,
    work_id integer NOT NULL,
    CONSTRAINT gk_collections_work_creator_workor_order_6f96d7837de1cf57_check CHECK (("order" >= 0))
);


--
-- Name: gk_collections_work_creator_workorigin_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gk_collections_work_creator_workorigin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gk_collections_work_creator_workorigin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gk_collections_work_creator_workorigin_id_seq OWNED BY gk_collections_work_creator_workorigin.id;


--
-- Name: glamkit_collections_country; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE glamkit_collections_country (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    iso_country character varying(2) NOT NULL,
    continent character varying(31)
);


--
-- Name: glamkit_collections_country_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE glamkit_collections_country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: glamkit_collections_country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE glamkit_collections_country_id_seq OWNED BY glamkit_collections_country.id;


--
-- Name: glamkit_collections_geographiclocation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE glamkit_collections_geographiclocation (
    id integer NOT NULL,
    state_province character varying(255) NOT NULL,
    city character varying(255) NOT NULL,
    neighborhood character varying(255) NOT NULL,
    colloquial_historical character varying(255) NOT NULL,
    country_id integer,
    slug character varying(50) NOT NULL
);


--
-- Name: glamkit_collections_geographiclocation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE glamkit_collections_geographiclocation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: glamkit_collections_geographiclocation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE glamkit_collections_geographiclocation_id_seq OWNED BY glamkit_collections_geographiclocation.id;


--
-- Name: glamkit_sponsors_sponsor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE glamkit_sponsors_sponsor (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    logo_id integer NOT NULL
);


--
-- Name: glamkit_sponsors_sponsor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE glamkit_sponsors_sponsor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: glamkit_sponsors_sponsor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE glamkit_sponsors_sponsor_id_seq OWNED BY glamkit_sponsors_sponsor.id;


--
-- Name: icekit_article_article; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_article_article (
    id integer NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    layout_id integer,
    parent_id integer NOT NULL,
    publishing_linked_id integer,
    boosted_search_terms text NOT NULL,
    list_image character varying(100) NOT NULL,
    hero_image_id integer,
    admin_notes text NOT NULL,
    brief text NOT NULL
);


--
-- Name: icekit_article_article_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_article_article_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_article_article_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_article_article_id_seq OWNED BY icekit_article_article.id;


--
-- Name: icekit_articlecategorypage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_articlecategorypage (
    urlnode_ptr_id integer NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    layout_id integer,
    publishing_linked_id integer,
    boosted_search_terms text NOT NULL,
    hero_image_id integer,
    list_image character varying(100) NOT NULL,
    admin_notes text NOT NULL,
    brief text NOT NULL
);


--
-- Name: icekit_authorlisting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_authorlisting (
    urlnode_ptr_id integer NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    layout_id integer,
    publishing_linked_id integer,
    boosted_search_terms text NOT NULL,
    hero_image_id integer,
    list_image character varying(100) NOT NULL,
    admin_notes text NOT NULL,
    brief text NOT NULL
);


--
-- Name: icekit_authors_author; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_authors_author (
    id integer NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    given_names character varying(255) NOT NULL,
    family_name character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    oneliner character varying(255) NOT NULL,
    hero_image_id integer,
    publishing_linked_id integer,
    boosted_search_terms text NOT NULL,
    list_image character varying(100) NOT NULL,
    admin_notes text NOT NULL,
    brief text NOT NULL
);


--
-- Name: icekit_authors_author_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_authors_author_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_authors_author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_authors_author_id_seq OWNED BY icekit_authors_author.id;


--
-- Name: icekit_event_types_simple_simpleevent; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_event_types_simple_simpleevent (
    eventbase_ptr_id integer NOT NULL,
    layout_id integer,
    boosted_search_terms text NOT NULL,
    hero_image_id integer,
    list_image character varying(100) NOT NULL
);


--
-- Name: icekit_events_eventbase; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_events_eventbase (
    id integer NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    show_in_calendar boolean NOT NULL,
    human_dates character varying(255) NOT NULL,
    special_instructions text NOT NULL,
    cta_text character varying(255) NOT NULL,
    cta_url character varying(300),
    derived_from_id integer,
    polymorphic_ctype_id integer,
    publishing_linked_id integer,
    part_of_id integer,
    price_line character varying(255) NOT NULL,
    primary_type_id integer,
    external_ref character varying(255),
    has_tickets_available boolean NOT NULL,
    is_drop_in boolean NOT NULL,
    human_times character varying(255) NOT NULL,
    admin_notes text NOT NULL,
    brief text NOT NULL,
    location_id integer,
    price_detailed text NOT NULL
);


--
-- Name: icekit_events_eventbase_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_events_eventbase_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_events_eventbase_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_events_eventbase_id_seq OWNED BY icekit_events_eventbase.id;


--
-- Name: icekit_events_eventbase_secondary_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_events_eventbase_secondary_types (
    id integer NOT NULL,
    eventbase_id integer NOT NULL,
    eventtype_id integer NOT NULL
);


--
-- Name: icekit_events_eventbase_secondary_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_events_eventbase_secondary_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_events_eventbase_secondary_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_events_eventbase_secondary_types_id_seq OWNED BY icekit_events_eventbase_secondary_types.id;


--
-- Name: icekit_events_eventrepeatsgenerator; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_events_eventrepeatsgenerator (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    recurrence_rule text,
    start timestamp with time zone NOT NULL,
    "end" timestamp with time zone NOT NULL,
    is_all_day boolean NOT NULL,
    repeat_end timestamp with time zone,
    event_id integer NOT NULL
);


--
-- Name: icekit_events_eventrepeatsgenerator_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_events_eventrepeatsgenerator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_events_eventrepeatsgenerator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_events_eventrepeatsgenerator_id_seq OWNED BY icekit_events_eventrepeatsgenerator.id;


--
-- Name: icekit_events_eventtype; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_events_eventtype (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    is_public boolean NOT NULL,
    title_plural character varying(255) NOT NULL,
    color character varying(7) NOT NULL
);


--
-- Name: icekit_events_eventtype_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_events_eventtype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_events_eventtype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_events_eventtype_id_seq OWNED BY icekit_events_eventtype.id;


--
-- Name: icekit_events_occurrence; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_events_occurrence (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    start timestamp with time zone NOT NULL,
    "end" timestamp with time zone NOT NULL,
    is_all_day boolean NOT NULL,
    is_protected_from_regeneration boolean NOT NULL,
    is_cancelled boolean NOT NULL,
    is_hidden boolean NOT NULL,
    cancel_reason character varying(255),
    original_start timestamp with time zone,
    original_end timestamp with time zone,
    event_id integer NOT NULL,
    generator_id integer,
    external_ref character varying(255),
    status character varying(255)
);


--
-- Name: icekit_events_occurrence_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_events_occurrence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_events_occurrence_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_events_occurrence_id_seq OWNED BY icekit_events_occurrence.id;


--
-- Name: icekit_events_recurrencerule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_events_recurrencerule (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    description text NOT NULL,
    recurrence_rule text NOT NULL
);


--
-- Name: icekit_events_recurrencerule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_events_recurrencerule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_events_recurrencerule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_events_recurrencerule_id_seq OWNED BY icekit_events_recurrencerule.id;


--
-- Name: icekit_layout; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_layout (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    title character varying(255) NOT NULL,
    template_name character varying(255) NOT NULL
);


--
-- Name: icekit_layout_content_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_layout_content_types (
    id integer NOT NULL,
    layout_id integer NOT NULL,
    contenttype_id integer NOT NULL
);


--
-- Name: icekit_layout_content_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_layout_content_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_layout_content_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_layout_content_types_id_seq OWNED BY icekit_layout_content_types.id;


--
-- Name: icekit_layout_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_layout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_layout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_layout_id_seq OWNED BY icekit_layout.id;


--
-- Name: icekit_layoutpage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_layoutpage (
    urlnode_ptr_id integer NOT NULL,
    layout_id integer,
    publishing_is_draft boolean NOT NULL,
    publishing_linked_id integer,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    boosted_search_terms text NOT NULL,
    hero_image_id integer,
    list_image character varying(100) NOT NULL,
    admin_notes text NOT NULL,
    brief text NOT NULL
);


--
-- Name: icekit_mediacategory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_mediacategory (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: icekit_mediacategory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_mediacategory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_mediacategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_mediacategory_id_seq OWNED BY icekit_mediacategory.id;


--
-- Name: icekit_navigation_navigation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_navigation_navigation (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(50) NOT NULL,
    pre_html text NOT NULL,
    post_html text NOT NULL
);


--
-- Name: icekit_navigation_navigation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_navigation_navigation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_navigation_navigation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_navigation_navigation_id_seq OWNED BY icekit_navigation_navigation.id;


--
-- Name: icekit_plugins_contact_person_contactperson; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_plugins_contact_person_contactperson (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    phone_full character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone_display character varying(255) NOT NULL
);


--
-- Name: icekit_plugins_contact_person_contactperson_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_plugins_contact_person_contactperson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_plugins_contact_person_contactperson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_plugins_contact_person_contactperson_id_seq OWNED BY icekit_plugins_contact_person_contactperson.id;


--
-- Name: icekit_plugins_image_image; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_plugins_image_image (
    id integer NOT NULL,
    image character varying(100) NOT NULL,
    alt_text character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    caption text NOT NULL,
    is_ok_for_web boolean NOT NULL,
    notes text NOT NULL,
    credit character varying(255) NOT NULL,
    date_created timestamp with time zone NOT NULL,
    date_modified timestamp with time zone NOT NULL,
    height integer NOT NULL,
    license text NOT NULL,
    maximum_dimension_pixels integer,
    source character varying(255) NOT NULL,
    width integer NOT NULL,
    is_cropping_allowed boolean NOT NULL,
    external_ref character varying(1024) NOT NULL,
    CONSTRAINT icekit_plugins__maximum_dimension_pixels_1e2f4388a2b0cc30_check CHECK ((maximum_dimension_pixels >= 0)),
    CONSTRAINT icekit_plugins_image_image_height_check CHECK ((height >= 0)),
    CONSTRAINT icekit_plugins_image_image_width_check CHECK ((width >= 0))
);


--
-- Name: icekit_plugins_image_image_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_plugins_image_image_categories (
    id integer NOT NULL,
    image_id integer NOT NULL,
    mediacategory_id integer NOT NULL
);


--
-- Name: icekit_plugins_image_imagerepurposeconfig; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_plugins_image_imagerepurposeconfig (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    width integer,
    height integer,
    format character varying(4) NOT NULL,
    style character varying(16) NOT NULL,
    is_cropping_allowed boolean NOT NULL,
    CONSTRAINT icekit_plugins_image_imagerepurposeconfig_height_check CHECK ((height >= 0)),
    CONSTRAINT icekit_plugins_image_imagerepurposeconfig_width_check CHECK ((width >= 0))
);


--
-- Name: icekit_plugins_image_imagerepurposeconfig_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_plugins_image_imagerepurposeconfig_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_plugins_image_imagerepurposeconfig_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_plugins_image_imagerepurposeconfig_id_seq OWNED BY icekit_plugins_image_imagerepurposeconfig.id;


--
-- Name: icekit_plugins_location_location; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_plugins_location_location (
    id integer NOT NULL,
    brief text NOT NULL,
    admin_notes text NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    map_description text NOT NULL,
    map_center_description character varying(255) NOT NULL,
    map_zoom integer NOT NULL,
    map_marker_description character varying(255) NOT NULL,
    is_home_location boolean NOT NULL,
    address text NOT NULL,
    phone_number character varying(255) NOT NULL,
    url character varying(200) NOT NULL,
    email character varying(254) NOT NULL,
    email_call_to_action character varying(255) NOT NULL,
    layout_id integer,
    publishing_linked_id integer,
    boosted_search_terms text NOT NULL,
    hero_image_id integer,
    list_image character varying(100) NOT NULL,
    phone_number_call_to_action character varying(255) NOT NULL,
    url_call_to_action character varying(255) NOT NULL,
    map_center_lat numeric(9,6),
    map_center_long numeric(9,6),
    map_marker_lat numeric(9,6),
    map_marker_long numeric(9,6),
    CONSTRAINT icekit_plugins_location_location_map_zoom_check CHECK ((map_zoom >= 0))
);


--
-- Name: icekit_plugins_location_location_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_plugins_location_location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_plugins_location_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_plugins_location_location_id_seq OWNED BY icekit_plugins_location_location.id;


--
-- Name: icekit_plugins_slideshow_slideshow; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_plugins_slideshow_slideshow (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    show_title boolean NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_linked_id integer,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    admin_notes text NOT NULL,
    brief text NOT NULL
);


--
-- Name: icekit_press_releases_pressrelease; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_press_releases_pressrelease (
    id integer NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    print_version character varying(100),
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone,
    released timestamp with time zone,
    category_id integer,
    layout_id integer,
    publishing_linked_id integer,
    boosted_search_terms text NOT NULL,
    list_image character varying(100) NOT NULL,
    admin_notes text NOT NULL,
    brief text NOT NULL
);


--
-- Name: icekit_press_releases_pressrelease_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_press_releases_pressrelease_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_press_releases_pressrelease_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_press_releases_pressrelease_id_seq OWNED BY icekit_press_releases_pressrelease.id;


--
-- Name: icekit_press_releases_pressreleasecategory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_press_releases_pressreleasecategory (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: icekit_press_releases_pressreleasecategory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_press_releases_pressreleasecategory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icekit_press_releases_pressreleasecategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_press_releases_pressreleasecategory_id_seq OWNED BY icekit_press_releases_pressreleasecategory.id;


--
-- Name: icekit_searchpage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_searchpage (
    urlnode_ptr_id integer NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_linked_id integer,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    boosted_search_terms text NOT NULL,
    list_image character varying(100) NOT NULL,
    default_search_type character varying(255) NOT NULL,
    admin_notes text NOT NULL,
    brief text NOT NULL
);


--
-- Name: icekit_workflow_workflowstate; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_workflow_workflowstate (
    id integer NOT NULL,
    object_id integer NOT NULL,
    status character varying(254) NOT NULL,
    assigned_to_id integer,
    content_type_id integer NOT NULL,
    datetime_modified timestamp with time zone NOT NULL,
    CONSTRAINT workflow_workflowstate_object_id_check CHECK ((object_id >= 0))
);


--
-- Name: ik_event_listing_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ik_event_listing_types (
    id integer NOT NULL,
    eventcontentlistingitem_id integer NOT NULL,
    eventtype_id integer NOT NULL
);


--
-- Name: ik_event_listing_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ik_event_listing_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ik_event_listing_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ik_event_listing_types_id_seq OWNED BY ik_event_listing_types.id;


--
-- Name: ik_todays_occurrences_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ik_todays_occurrences_types (
    id integer NOT NULL,
    todaysoccurrences_id integer NOT NULL,
    eventtype_id integer NOT NULL
);


--
-- Name: ik_todays_occurrences_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ik_todays_occurrences_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ik_todays_occurrences_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ik_todays_occurrences_types_id_seq OWNED BY ik_todays_occurrences_types.id;


--
-- Name: image_image_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE image_image_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: image_image_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE image_image_categories_id_seq OWNED BY icekit_plugins_image_image_categories.id;


--
-- Name: image_image_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE image_image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: image_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE image_image_id_seq OWNED BY icekit_plugins_image_image.id;


--
-- Name: media_coverage_mediacoveragerecord; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE media_coverage_mediacoveragerecord (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    original_url character varying(200),
    title character varying(255) NOT NULL,
    description text NOT NULL,
    original_publication_date date
);


--
-- Name: media_coverage_mediacoveragerecord_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_coverage_mediacoveragerecord_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_coverage_mediacoveragerecord_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_coverage_mediacoveragerecord_id_seq OWNED BY media_coverage_mediacoveragerecord.id;


--
-- Name: model_settings_boolean; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_boolean (
    setting_ptr_id integer NOT NULL,
    value boolean NOT NULL
);


--
-- Name: model_settings_date; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_date (
    setting_ptr_id integer NOT NULL,
    value date NOT NULL
);


--
-- Name: model_settings_datetime; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_datetime (
    setting_ptr_id integer NOT NULL,
    value timestamp with time zone NOT NULL
);


--
-- Name: model_settings_decimal; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_decimal (
    setting_ptr_id integer NOT NULL,
    value numeric(20,10) NOT NULL
);


--
-- Name: model_settings_file; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_file (
    setting_ptr_id integer NOT NULL,
    value character varying(100) NOT NULL
);


--
-- Name: model_settings_float; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_float (
    setting_ptr_id integer NOT NULL,
    value double precision NOT NULL
);


--
-- Name: model_settings_image; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_image (
    setting_ptr_id integer NOT NULL,
    value character varying(100) NOT NULL
);


--
-- Name: model_settings_integer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_integer (
    setting_ptr_id integer NOT NULL,
    value integer NOT NULL
);


--
-- Name: model_settings_setting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_setting (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    polymorphic_ctype_id integer
);


--
-- Name: model_settings_setting_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE model_settings_setting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: model_settings_setting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE model_settings_setting_id_seq OWNED BY model_settings_setting.id;


--
-- Name: model_settings_text; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_text (
    setting_ptr_id integer NOT NULL,
    value character varying(255) NOT NULL
);


--
-- Name: model_settings_time; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_time (
    setting_ptr_id integer NOT NULL,
    value time without time zone NOT NULL
);


--
-- Name: notifications_followerinformation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications_followerinformation (
    id integer NOT NULL,
    object_id integer NOT NULL,
    content_type_id integer NOT NULL,
    polymorphic_ctype_id integer,
    CONSTRAINT notifications_followerinformation_object_id_check CHECK ((object_id >= 0))
);


--
-- Name: notifications_followerinformation_followers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications_followerinformation_followers (
    id integer NOT NULL,
    followerinformation_id integer NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: notifications_followerinformation_followers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_followerinformation_followers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_followerinformation_followers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_followerinformation_followers_id_seq OWNED BY notifications_followerinformation_followers.id;


--
-- Name: notifications_followerinformation_group_followers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications_followerinformation_group_followers (
    id integer NOT NULL,
    followerinformation_id integer NOT NULL,
    group_id integer NOT NULL
);


--
-- Name: notifications_followerinformation_group_followers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_followerinformation_group_followers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_followerinformation_group_followers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_followerinformation_group_followers_id_seq OWNED BY notifications_followerinformation_group_followers.id;


--
-- Name: notifications_followerinformation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_followerinformation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_followerinformation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_followerinformation_id_seq OWNED BY notifications_followerinformation.id;


--
-- Name: notifications_hasreadmessage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications_hasreadmessage (
    id integer NOT NULL,
    is_read boolean NOT NULL,
    "time" timestamp with time zone,
    is_removed boolean NOT NULL,
    notification_setting character varying(20) NOT NULL,
    email_sent boolean NOT NULL,
    message_id integer NOT NULL,
    person_id integer NOT NULL
);


--
-- Name: notifications_hasreadmessage_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_hasreadmessage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_hasreadmessage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_hasreadmessage_id_seq OWNED BY notifications_hasreadmessage.id;


--
-- Name: notifications_notification; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications_notification (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    title character varying(120) NOT NULL,
    notification text NOT NULL,
    is_removed boolean NOT NULL,
    user_id integer
);


--
-- Name: notifications_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_notification_id_seq OWNED BY notifications_notification.id;


--
-- Name: notifications_notificationsetting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications_notificationsetting (
    id integer NOT NULL,
    notification_type character varying(20) NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: notifications_notificationsetting_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_notificationsetting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_notificationsetting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_notificationsetting_id_seq OWNED BY notifications_notificationsetting.id;


--
-- Name: pagetype_advancedeventlisting_advancedeventlistingpage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pagetype_advancedeventlisting_advancedeventlistingpage (
    urlnode_ptr_id integer NOT NULL,
    brief text NOT NULL,
    admin_notes text NOT NULL,
    list_image character varying(100) NOT NULL,
    boosted_search_terms text NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    limit_to_home_locations boolean NOT NULL,
    default_start_date date,
    default_days_to_show integer,
    hero_image_id integer,
    layout_id integer,
    publishing_linked_id integer
);


--
-- Name: pagetype_eventlistingfordate_eventlistingpage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pagetype_eventlistingfordate_eventlistingpage (
    urlnode_ptr_id integer NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    layout_id integer,
    publishing_linked_id integer,
    boosted_search_terms text NOT NULL,
    hero_image_id integer,
    list_image character varying(100) NOT NULL,
    admin_notes text NOT NULL,
    brief text NOT NULL
);


--
-- Name: pagetype_fluentpage_fluentpage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pagetype_fluentpage_fluentpage (
    urlnode_ptr_id integer NOT NULL,
    layout_id integer
);


--
-- Name: pagetype_icekit_press_releases_pressreleaselisting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pagetype_icekit_press_releases_pressreleaselisting (
    urlnode_ptr_id integer NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    layout_id integer,
    publishing_linked_id integer,
    boosted_search_terms text NOT NULL,
    hero_image_id integer,
    list_image character varying(100) NOT NULL,
    admin_notes text NOT NULL,
    brief text NOT NULL
);


--
-- Name: pagetype_redirectnode_redirectnode; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pagetype_redirectnode_redirectnode (
    urlnode_ptr_id integer NOT NULL
);


--
-- Name: pagetype_textfile_textfile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pagetype_textfile_textfile (
    urlnode_ptr_id integer NOT NULL,
    content_type character varying(100) NOT NULL
);


--
-- Name: polymorphic_auth_email_emailuser; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE polymorphic_auth_email_emailuser (
    user_ptr_id integer NOT NULL,
    email character varying(254) NOT NULL
);


--
-- Name: polymorphic_auth_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE polymorphic_auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    created timestamp with time zone NOT NULL,
    polymorphic_ctype_id integer
);


--
-- Name: polymorphic_auth_user_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE polymorphic_auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


--
-- Name: polymorphic_auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE polymorphic_auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: polymorphic_auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE polymorphic_auth_user_groups_id_seq OWNED BY polymorphic_auth_user_groups.id;


--
-- Name: polymorphic_auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE polymorphic_auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: polymorphic_auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE polymorphic_auth_user_id_seq OWNED BY polymorphic_auth_user.id;


--
-- Name: polymorphic_auth_user_user_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE polymorphic_auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: polymorphic_auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE polymorphic_auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: polymorphic_auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE polymorphic_auth_user_user_permissions_id_seq OWNED BY polymorphic_auth_user_user_permissions.id;


--
-- Name: post_office_attachment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE post_office_attachment (
    id integer NOT NULL,
    file character varying(100) NOT NULL,
    name character varying(255) NOT NULL,
    mimetype character varying(255) NOT NULL
);


--
-- Name: post_office_attachment_emails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE post_office_attachment_emails (
    id integer NOT NULL,
    attachment_id integer NOT NULL,
    email_id integer NOT NULL
);


--
-- Name: post_office_attachment_emails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE post_office_attachment_emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_office_attachment_emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE post_office_attachment_emails_id_seq OWNED BY post_office_attachment_emails.id;


--
-- Name: post_office_attachment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE post_office_attachment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_office_attachment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE post_office_attachment_id_seq OWNED BY post_office_attachment.id;


--
-- Name: post_office_email; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE post_office_email (
    id integer NOT NULL,
    from_email character varying(254) NOT NULL,
    "to" text NOT NULL,
    cc text NOT NULL,
    bcc text NOT NULL,
    subject character varying(989) NOT NULL,
    message text NOT NULL,
    html_message text NOT NULL,
    status smallint,
    priority smallint,
    created timestamp with time zone NOT NULL,
    last_updated timestamp with time zone NOT NULL,
    scheduled_time timestamp with time zone,
    headers text,
    context text,
    template_id integer,
    backend_alias character varying(64) NOT NULL,
    CONSTRAINT post_office_email_priority_check CHECK ((priority >= 0)),
    CONSTRAINT post_office_email_status_check CHECK ((status >= 0))
);


--
-- Name: post_office_email_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE post_office_email_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_office_email_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE post_office_email_id_seq OWNED BY post_office_email.id;


--
-- Name: post_office_emailtemplate; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE post_office_emailtemplate (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    subject character varying(255) NOT NULL,
    content text NOT NULL,
    html_content text NOT NULL,
    created timestamp with time zone NOT NULL,
    last_updated timestamp with time zone NOT NULL,
    default_template_id integer,
    language character varying(12) NOT NULL
);


--
-- Name: post_office_emailtemplate_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE post_office_emailtemplate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_office_emailtemplate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE post_office_emailtemplate_id_seq OWNED BY post_office_emailtemplate.id;


--
-- Name: post_office_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE post_office_log (
    id integer NOT NULL,
    date timestamp with time zone NOT NULL,
    status smallint NOT NULL,
    exception_type character varying(255) NOT NULL,
    message text NOT NULL,
    email_id integer NOT NULL,
    CONSTRAINT post_office_log_status_check CHECK ((status >= 0))
);


--
-- Name: post_office_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE post_office_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_office_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE post_office_log_id_seq OWNED BY post_office_log.id;


--
-- Name: redirectnode_redirectnode_translation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE redirectnode_redirectnode_translation (
    id integer NOT NULL,
    language_code character varying(15) NOT NULL,
    new_url character varying(255) NOT NULL,
    redirect_type integer NOT NULL,
    master_id integer
);


--
-- Name: redirectnode_redirectnode_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE redirectnode_redirectnode_translation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: redirectnode_redirectnode_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE redirectnode_redirectnode_translation_id_seq OWNED BY redirectnode_redirectnode_translation.id;


--
-- Name: response_pages_responsepage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE response_pages_responsepage (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    type character varying(5) NOT NULL,
    is_active boolean NOT NULL
);


--
-- Name: response_pages_responsepage_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE response_pages_responsepage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: response_pages_responsepage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE response_pages_responsepage_id_seq OWNED BY response_pages_responsepage.id;


--
-- Name: reversion_revision; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE reversion_revision (
    id integer NOT NULL,
    manager_slug character varying(191) NOT NULL,
    date_created timestamp with time zone NOT NULL,
    comment text NOT NULL,
    user_id integer
);


--
-- Name: reversion_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reversion_revision_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reversion_revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reversion_revision_id_seq OWNED BY reversion_revision.id;


--
-- Name: reversion_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE reversion_version (
    id integer NOT NULL,
    object_id text NOT NULL,
    object_id_int integer,
    format character varying(255) NOT NULL,
    serialized_data text NOT NULL,
    object_repr text NOT NULL,
    content_type_id integer NOT NULL,
    revision_id integer NOT NULL
);


--
-- Name: reversion_version_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reversion_version_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reversion_version_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reversion_version_id_seq OWNED BY reversion_version.id;


--
-- Name: sharedcontent_sharedcontent; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sharedcontent_sharedcontent (
    id integer NOT NULL,
    slug character varying(50) NOT NULL,
    is_cross_site boolean NOT NULL,
    parent_site_id integer NOT NULL
);


--
-- Name: sharedcontent_sharedcontent_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sharedcontent_sharedcontent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sharedcontent_sharedcontent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sharedcontent_sharedcontent_id_seq OWNED BY sharedcontent_sharedcontent.id;


--
-- Name: sharedcontent_sharedcontent_translation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sharedcontent_sharedcontent_translation (
    id integer NOT NULL,
    language_code character varying(15) NOT NULL,
    title character varying(200) NOT NULL,
    master_id integer
);


--
-- Name: sharedcontent_sharedcontent_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sharedcontent_sharedcontent_translation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sharedcontent_sharedcontent_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sharedcontent_sharedcontent_translation_id_seq OWNED BY sharedcontent_sharedcontent_translation.id;


--
-- Name: slideshow_slideshow_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE slideshow_slideshow_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: slideshow_slideshow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE slideshow_slideshow_id_seq OWNED BY icekit_plugins_slideshow_slideshow.id;


--
-- Name: staff_profiles_department; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE staff_profiles_department (
    id integer NOT NULL,
    title character varying(255) NOT NULL
);


--
-- Name: staff_profiles_department_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE staff_profiles_department_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: staff_profiles_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE staff_profiles_department_id_seq OWNED BY staff_profiles_department.id;


--
-- Name: staff_profiles_staffprofile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE staff_profiles_staffprofile (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    status character varying(100) NOT NULL,
    status_changed timestamp with time zone NOT NULL,
    job_title character varying(100) NOT NULL,
    short_bio text NOT NULL,
    importance integer NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: staff_profiles_staffprofile_department; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE staff_profiles_staffprofile_department (
    id integer NOT NULL,
    staffprofile_id integer NOT NULL,
    department_id integer NOT NULL
);


--
-- Name: staff_profiles_staffprofile_department_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE staff_profiles_staffprofile_department_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: staff_profiles_staffprofile_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE staff_profiles_staffprofile_department_id_seq OWNED BY staff_profiles_staffprofile_department.id;


--
-- Name: staff_profiles_staffprofile_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE staff_profiles_staffprofile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: staff_profiles_staffprofile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE staff_profiles_staffprofile_id_seq OWNED BY staff_profiles_staffprofile.id;


--
-- Name: taggit_tag; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE taggit_tag (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(100) NOT NULL
);


--
-- Name: taggit_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggit_tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggit_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggit_tag_id_seq OWNED BY taggit_tag.id;


--
-- Name: taggit_taggeditem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE taggit_taggeditem (
    id integer NOT NULL,
    object_id integer NOT NULL,
    content_type_id integer NOT NULL,
    tag_id integer NOT NULL
);


--
-- Name: taggit_taggeditem_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggit_taggeditem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggit_taggeditem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggit_taggeditem_id_seq OWNED BY taggit_taggeditem.id;


--
-- Name: test_article; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE test_article (
    id integer NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    layout_id integer,
    publishing_linked_id integer,
    parent_id integer NOT NULL,
    boosted_search_terms text NOT NULL,
    list_image character varying(100) NOT NULL
);


--
-- Name: test_article_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE test_article_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: test_article_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE test_article_id_seq OWNED BY test_article.id;


--
-- Name: test_articlelisting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE test_articlelisting (
    urlnode_ptr_id integer NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    layout_id integer,
    publishing_linked_id integer,
    boosted_search_terms text NOT NULL,
    hero_image_id integer,
    list_image character varying(100) NOT NULL,
    admin_notes text NOT NULL,
    brief text NOT NULL
);


--
-- Name: test_layoutpage_with_related; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE test_layoutpage_with_related (
    urlnode_ptr_id integer NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    layout_id integer,
    publishing_linked_id integer,
    boosted_search_terms text NOT NULL,
    hero_image_id integer,
    list_image character varying(100) NOT NULL,
    admin_notes text NOT NULL,
    brief text NOT NULL
);


--
-- Name: test_layoutpage_with_related_related_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE test_layoutpage_with_related_related_pages (
    id integer NOT NULL,
    layoutpagewithrelatedpages_id integer NOT NULL,
    page_id integer NOT NULL
);


--
-- Name: test_layoutpage_with_related_related_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE test_layoutpage_with_related_related_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: test_layoutpage_with_related_related_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE test_layoutpage_with_related_related_pages_id_seq OWNED BY test_layoutpage_with_related_related_pages.id;


--
-- Name: tests_barwithlayout; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tests_barwithlayout (
    id integer NOT NULL,
    layout_id integer
);


--
-- Name: tests_barwithlayout_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_barwithlayout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tests_barwithlayout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_barwithlayout_id_seq OWNED BY tests_barwithlayout.id;


--
-- Name: tests_basemodel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tests_basemodel (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL
);


--
-- Name: tests_basemodel_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_basemodel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tests_basemodel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_basemodel_id_seq OWNED BY tests_basemodel.id;


--
-- Name: tests_bazwithlayout; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tests_bazwithlayout (
    id integer NOT NULL,
    layout_id integer
);


--
-- Name: tests_bazwithlayout_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_bazwithlayout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tests_bazwithlayout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_bazwithlayout_id_seq OWNED BY tests_bazwithlayout.id;


--
-- Name: tests_foowithlayout; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tests_foowithlayout (
    id integer NOT NULL,
    layout_id integer
);


--
-- Name: tests_foowithlayout_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_foowithlayout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tests_foowithlayout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_foowithlayout_id_seq OWNED BY tests_foowithlayout.id;


--
-- Name: tests_imagetest; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tests_imagetest (
    id integer NOT NULL,
    image character varying(100) NOT NULL
);


--
-- Name: tests_imagetest_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_imagetest_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tests_imagetest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_imagetest_id_seq OWNED BY tests_imagetest.id;


--
-- Name: tests_publishingm2mmodela; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tests_publishingm2mmodela (
    id integer NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    publishing_linked_id integer
);


--
-- Name: tests_publishingm2mmodela_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_publishingm2mmodela_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tests_publishingm2mmodela_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_publishingm2mmodela_id_seq OWNED BY tests_publishingm2mmodela.id;


--
-- Name: tests_publishingm2mmodelb; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tests_publishingm2mmodelb (
    id integer NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone,
    publishing_linked_id integer
);


--
-- Name: tests_publishingm2mmodelb_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_publishingm2mmodelb_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tests_publishingm2mmodelb_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_publishingm2mmodelb_id_seq OWNED BY tests_publishingm2mmodelb.id;


--
-- Name: tests_publishingm2mmodelb_related_a_models; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tests_publishingm2mmodelb_related_a_models (
    id integer NOT NULL,
    publishingm2mmodelb_id integer NOT NULL,
    publishingm2mmodela_id integer NOT NULL
);


--
-- Name: tests_publishingm2mmodelb_related_a_models_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_publishingm2mmodelb_related_a_models_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tests_publishingm2mmodelb_related_a_models_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_publishingm2mmodelb_related_a_models_id_seq OWNED BY tests_publishingm2mmodelb_related_a_models.id;


--
-- Name: tests_publishingm2mthroughtable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tests_publishingm2mthroughtable (
    id integer NOT NULL,
    a_model_id integer NOT NULL,
    b_model_id integer NOT NULL
);


--
-- Name: tests_publishingm2mthroughtable_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_publishingm2mthroughtable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tests_publishingm2mthroughtable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_publishingm2mthroughtable_id_seq OWNED BY tests_publishingm2mthroughtable.id;


--
-- Name: textfile_textfile_translation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE textfile_textfile_translation (
    id integer NOT NULL,
    language_code character varying(15) NOT NULL,
    content text NOT NULL,
    master_id integer
);


--
-- Name: textfile_textfile_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE textfile_textfile_translation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: textfile_textfile_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE textfile_textfile_translation_id_seq OWNED BY textfile_textfile_translation.id;


--
-- Name: workflow_workflowstate_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE workflow_workflowstate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflow_workflowstate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE workflow_workflowstate_id_seq OWNED BY icekit_workflow_workflowstate.id;


--
-- Name: advanced_event_listing_page_locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY advanced_event_listing_page_locations ALTER COLUMN id SET DEFAULT nextval('advanced_event_listing_page_locations_id_seq'::regclass);


--
-- Name: advanced_event_listing_page_primary_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY advanced_event_listing_page_primary_types ALTER COLUMN id SET DEFAULT nextval('advanced_event_listing_page_primary_types_id_seq'::regclass);


--
-- Name: advanced_event_listing_page_secondary_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY advanced_event_listing_page_secondary_types ALTER COLUMN id SET DEFAULT nextval('advanced_event_listing_page_secondary_types_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- Name: biennale_of_sydney_biennaleevent_works id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennaleevent_works ALTER COLUMN id SET DEFAULT nextval('biennale_of_sydney_biennaleevent_works_id_seq'::regclass);


--
-- Name: biennale_of_sydney_biennalelocation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennalelocation ALTER COLUMN id SET DEFAULT nextval('biennale_of_sydney_biennalelocation_id_seq'::regclass);


--
-- Name: biennale_of_sydney_eventartist id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_eventartist ALTER COLUMN id SET DEFAULT nextval('biennale_of_sydney_eventartist_id_seq'::regclass);


--
-- Name: biennale_of_sydney_partner id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_partner ALTER COLUMN id SET DEFAULT nextval('biennale_of_sydney_partner_id_seq'::regclass);


--
-- Name: celery_taskmeta id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_taskmeta ALTER COLUMN id SET DEFAULT nextval('celery_taskmeta_id_seq'::regclass);


--
-- Name: celery_tasksetmeta id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_tasksetmeta ALTER COLUMN id SET DEFAULT nextval('celery_tasksetmeta_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_admin_log ALTER COLUMN id SET DEFAULT nextval('django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_migrations ALTER COLUMN id SET DEFAULT nextval('django_migrations_id_seq'::regclass);


--
-- Name: django_redirect id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_redirect ALTER COLUMN id SET DEFAULT nextval('django_redirect_id_seq'::regclass);


--
-- Name: django_site id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_site ALTER COLUMN id SET DEFAULT nextval('django_site_id_seq'::regclass);


--
-- Name: djcelery_crontabschedule id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_crontabschedule ALTER COLUMN id SET DEFAULT nextval('djcelery_crontabschedule_id_seq'::regclass);


--
-- Name: djcelery_intervalschedule id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_intervalschedule ALTER COLUMN id SET DEFAULT nextval('djcelery_intervalschedule_id_seq'::regclass);


--
-- Name: djcelery_periodictask id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask ALTER COLUMN id SET DEFAULT nextval('djcelery_periodictask_id_seq'::regclass);


--
-- Name: djcelery_taskstate id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_taskstate ALTER COLUMN id SET DEFAULT nextval('djcelery_taskstate_id_seq'::regclass);


--
-- Name: djcelery_workerstate id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_workerstate ALTER COLUMN id SET DEFAULT nextval('djcelery_workerstate_id_seq'::regclass);


--
-- Name: djkombu_message id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_message ALTER COLUMN id SET DEFAULT nextval('djkombu_message_id_seq'::regclass);


--
-- Name: djkombu_queue id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_queue ALTER COLUMN id SET DEFAULT nextval('djkombu_queue_id_seq'::regclass);


--
-- Name: easy_thumbnails_source id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_source ALTER COLUMN id SET DEFAULT nextval('easy_thumbnails_source_id_seq'::regclass);


--
-- Name: easy_thumbnails_thumbnail id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnail ALTER COLUMN id SET DEFAULT nextval('easy_thumbnails_thumbnail_id_seq'::regclass);


--
-- Name: easy_thumbnails_thumbnaildimensions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnaildimensions ALTER COLUMN id SET DEFAULT nextval('easy_thumbnails_thumbnaildimensions_id_seq'::regclass);


--
-- Name: fluent_contents_contentitem id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem ALTER COLUMN id SET DEFAULT nextval('fluent_contents_contentitem_id_seq'::regclass);


--
-- Name: fluent_contents_placeholder id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_placeholder ALTER COLUMN id SET DEFAULT nextval('fluent_contents_placeholder_id_seq'::regclass);


--
-- Name: fluent_pages_htmlpage_translation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_htmlpage_translation ALTER COLUMN id SET DEFAULT nextval('fluent_pages_htmlpage_translation_id_seq'::regclass);


--
-- Name: fluent_pages_pagelayout id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_pagelayout ALTER COLUMN id SET DEFAULT nextval('fluent_pages_pagelayout_id_seq'::regclass);


--
-- Name: fluent_pages_urlnode id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode ALTER COLUMN id SET DEFAULT nextval('fluent_pages_urlnode_id_seq'::regclass);


--
-- Name: fluent_pages_urlnode_translation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode_translation ALTER COLUMN id SET DEFAULT nextval('fluent_pages_urlnode_translation_id_seq'::regclass);


--
-- Name: forms_field id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_field ALTER COLUMN id SET DEFAULT nextval('forms_field_id_seq'::regclass);


--
-- Name: forms_fieldentry id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_fieldentry ALTER COLUMN id SET DEFAULT nextval('forms_fieldentry_id_seq'::regclass);


--
-- Name: forms_form id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form ALTER COLUMN id SET DEFAULT nextval('forms_form_id_seq'::regclass);


--
-- Name: forms_form_sites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites ALTER COLUMN id SET DEFAULT nextval('forms_form_sites_id_seq'::regclass);


--
-- Name: forms_formentry id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_formentry ALTER COLUMN id SET DEFAULT nextval('forms_formentry_id_seq'::regclass);


--
-- Name: gk_collections_film_film_formats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_film_film_formats ALTER COLUMN id SET DEFAULT nextval('gk_collections_film_film_formats_id_seq'::regclass);


--
-- Name: gk_collections_film_film_genres id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_film_film_genres ALTER COLUMN id SET DEFAULT nextval('gk_collections_film_film_genres_id_seq'::regclass);


--
-- Name: gk_collections_film_format id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_film_format ALTER COLUMN id SET DEFAULT nextval('gk_collections_film_format_id_seq'::regclass);


--
-- Name: gk_collections_game_game_genres id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game_genres ALTER COLUMN id SET DEFAULT nextval('gk_collections_game_game_genres_id_seq'::regclass);


--
-- Name: gk_collections_game_game_input_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game_input_types ALTER COLUMN id SET DEFAULT nextval('gk_collections_game_game_input_types_id_seq'::regclass);


--
-- Name: gk_collections_game_game_platforms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game_platforms ALTER COLUMN id SET DEFAULT nextval('gk_collections_game_game_platforms_id_seq'::regclass);


--
-- Name: gk_collections_game_gameinputtype id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_gameinputtype ALTER COLUMN id SET DEFAULT nextval('gk_collections_game_gameinputtype_id_seq'::regclass);


--
-- Name: gk_collections_game_gameplatform id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_gameplatform ALTER COLUMN id SET DEFAULT nextval('gk_collections_game_gameplatform_id_seq'::regclass);


--
-- Name: gk_collections_moving_image_genre id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_moving_image_genre ALTER COLUMN id SET DEFAULT nextval('gk_collections_moving_image_genre_id_seq'::regclass);


--
-- Name: gk_collections_moving_image_mediatype id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_moving_image_mediatype ALTER COLUMN id SET DEFAULT nextval('gk_collections_moving_image_mediatype_id_seq'::regclass);


--
-- Name: gk_collections_moving_image_movingimagework_genres id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_moving_image_movingimagework_genres ALTER COLUMN id SET DEFAULT nextval('gk_collections_moving_image_movingimagework_genres_id_seq'::regclass);


--
-- Name: gk_collections_moving_image_rating id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_moving_image_rating ALTER COLUMN id SET DEFAULT nextval('gk_collections_moving_image_rating_id_seq'::regclass);


--
-- Name: gk_collections_work_creator_creatorbase id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_creatorbase ALTER COLUMN id SET DEFAULT nextval('gk_collections_work_creator_creatorbase_id_seq'::regclass);


--
-- Name: gk_collections_work_creator_role id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_role ALTER COLUMN id SET DEFAULT nextval('gk_collections_work_creator_role_id_seq'::regclass);


--
-- Name: gk_collections_work_creator_workbase id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workbase ALTER COLUMN id SET DEFAULT nextval('gk_collections_work_creator_workbase_id_seq'::regclass);


--
-- Name: gk_collections_work_creator_workcreator id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workcreator ALTER COLUMN id SET DEFAULT nextval('gk_collections_work_creator_workcreator_id_seq'::regclass);


--
-- Name: gk_collections_work_creator_workimage id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workimage ALTER COLUMN id SET DEFAULT nextval('gk_collections_work_creator_workimage_id_seq'::regclass);


--
-- Name: gk_collections_work_creator_workimagetype id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workimagetype ALTER COLUMN id SET DEFAULT nextval('gk_collections_work_creator_workimagetype_id_seq'::regclass);


--
-- Name: gk_collections_work_creator_workorigin id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workorigin ALTER COLUMN id SET DEFAULT nextval('gk_collections_work_creator_workorigin_id_seq'::regclass);


--
-- Name: glamkit_collections_country id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_collections_country ALTER COLUMN id SET DEFAULT nextval('glamkit_collections_country_id_seq'::regclass);


--
-- Name: glamkit_collections_geographiclocation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_collections_geographiclocation ALTER COLUMN id SET DEFAULT nextval('glamkit_collections_geographiclocation_id_seq'::regclass);


--
-- Name: glamkit_sponsors_sponsor id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_sponsors_sponsor ALTER COLUMN id SET DEFAULT nextval('glamkit_sponsors_sponsor_id_seq'::regclass);


--
-- Name: icekit_article_article id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article ALTER COLUMN id SET DEFAULT nextval('icekit_article_article_id_seq'::regclass);


--
-- Name: icekit_authors_author id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author ALTER COLUMN id SET DEFAULT nextval('icekit_authors_author_id_seq'::regclass);


--
-- Name: icekit_events_eventbase id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase ALTER COLUMN id SET DEFAULT nextval('icekit_events_eventbase_id_seq'::regclass);


--
-- Name: icekit_events_eventbase_secondary_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types ALTER COLUMN id SET DEFAULT nextval('icekit_events_eventbase_secondary_types_id_seq'::regclass);


--
-- Name: icekit_events_eventrepeatsgenerator id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventrepeatsgenerator ALTER COLUMN id SET DEFAULT nextval('icekit_events_eventrepeatsgenerator_id_seq'::regclass);


--
-- Name: icekit_events_eventtype id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventtype ALTER COLUMN id SET DEFAULT nextval('icekit_events_eventtype_id_seq'::regclass);


--
-- Name: icekit_events_occurrence id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_occurrence ALTER COLUMN id SET DEFAULT nextval('icekit_events_occurrence_id_seq'::regclass);


--
-- Name: icekit_events_recurrencerule id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_recurrencerule ALTER COLUMN id SET DEFAULT nextval('icekit_events_recurrencerule_id_seq'::regclass);


--
-- Name: icekit_layout id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout ALTER COLUMN id SET DEFAULT nextval('icekit_layout_id_seq'::regclass);


--
-- Name: icekit_layout_content_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types ALTER COLUMN id SET DEFAULT nextval('icekit_layout_content_types_id_seq'::regclass);


--
-- Name: icekit_mediacategory id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_mediacategory ALTER COLUMN id SET DEFAULT nextval('icekit_mediacategory_id_seq'::regclass);


--
-- Name: icekit_navigation_navigation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_navigation_navigation ALTER COLUMN id SET DEFAULT nextval('icekit_navigation_navigation_id_seq'::regclass);


--
-- Name: icekit_plugins_contact_person_contactperson id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_contact_person_contactperson ALTER COLUMN id SET DEFAULT nextval('icekit_plugins_contact_person_contactperson_id_seq'::regclass);


--
-- Name: icekit_plugins_file_file id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file ALTER COLUMN id SET DEFAULT nextval('file_file_id_seq'::regclass);


--
-- Name: icekit_plugins_file_file_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories ALTER COLUMN id SET DEFAULT nextval('file_file_categories_id_seq'::regclass);


--
-- Name: icekit_plugins_image_image id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image ALTER COLUMN id SET DEFAULT nextval('image_image_id_seq'::regclass);


--
-- Name: icekit_plugins_image_image_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories ALTER COLUMN id SET DEFAULT nextval('image_image_categories_id_seq'::regclass);


--
-- Name: icekit_plugins_image_imagerepurposeconfig id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_imagerepurposeconfig ALTER COLUMN id SET DEFAULT nextval('icekit_plugins_image_imagerepurposeconfig_id_seq'::regclass);


--
-- Name: icekit_plugins_location_location id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_location_location ALTER COLUMN id SET DEFAULT nextval('icekit_plugins_location_location_id_seq'::regclass);


--
-- Name: icekit_plugins_slideshow_slideshow id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_slideshow_slideshow ALTER COLUMN id SET DEFAULT nextval('slideshow_slideshow_id_seq'::regclass);


--
-- Name: icekit_press_releases_pressrelease id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease ALTER COLUMN id SET DEFAULT nextval('icekit_press_releases_pressrelease_id_seq'::regclass);


--
-- Name: icekit_press_releases_pressreleasecategory id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressreleasecategory ALTER COLUMN id SET DEFAULT nextval('icekit_press_releases_pressreleasecategory_id_seq'::regclass);


--
-- Name: icekit_workflow_workflowstate id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_workflow_workflowstate ALTER COLUMN id SET DEFAULT nextval('workflow_workflowstate_id_seq'::regclass);


--
-- Name: ik_event_listing_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types ALTER COLUMN id SET DEFAULT nextval('ik_event_listing_types_id_seq'::regclass);


--
-- Name: ik_todays_occurrences_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types ALTER COLUMN id SET DEFAULT nextval('ik_todays_occurrences_types_id_seq'::regclass);


--
-- Name: media_coverage_mediacoveragerecord id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_coverage_mediacoveragerecord ALTER COLUMN id SET DEFAULT nextval('media_coverage_mediacoveragerecord_id_seq'::regclass);


--
-- Name: model_settings_setting id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_setting ALTER COLUMN id SET DEFAULT nextval('model_settings_setting_id_seq'::regclass);


--
-- Name: notifications_followerinformation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation ALTER COLUMN id SET DEFAULT nextval('notifications_followerinformation_id_seq'::regclass);


--
-- Name: notifications_followerinformation_followers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers ALTER COLUMN id SET DEFAULT nextval('notifications_followerinformation_followers_id_seq'::regclass);


--
-- Name: notifications_followerinformation_group_followers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers ALTER COLUMN id SET DEFAULT nextval('notifications_followerinformation_group_followers_id_seq'::regclass);


--
-- Name: notifications_hasreadmessage id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_hasreadmessage ALTER COLUMN id SET DEFAULT nextval('notifications_hasreadmessage_id_seq'::regclass);


--
-- Name: notifications_notification id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notification ALTER COLUMN id SET DEFAULT nextval('notifications_notification_id_seq'::regclass);


--
-- Name: notifications_notificationsetting id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notificationsetting ALTER COLUMN id SET DEFAULT nextval('notifications_notificationsetting_id_seq'::regclass);


--
-- Name: polymorphic_auth_user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user ALTER COLUMN id SET DEFAULT nextval('polymorphic_auth_user_id_seq'::regclass);


--
-- Name: polymorphic_auth_user_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups ALTER COLUMN id SET DEFAULT nextval('polymorphic_auth_user_groups_id_seq'::regclass);


--
-- Name: polymorphic_auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('polymorphic_auth_user_user_permissions_id_seq'::regclass);


--
-- Name: post_office_attachment id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment ALTER COLUMN id SET DEFAULT nextval('post_office_attachment_id_seq'::regclass);


--
-- Name: post_office_attachment_emails id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails ALTER COLUMN id SET DEFAULT nextval('post_office_attachment_emails_id_seq'::regclass);


--
-- Name: post_office_email id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_email ALTER COLUMN id SET DEFAULT nextval('post_office_email_id_seq'::regclass);


--
-- Name: post_office_emailtemplate id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_emailtemplate ALTER COLUMN id SET DEFAULT nextval('post_office_emailtemplate_id_seq'::regclass);


--
-- Name: post_office_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_log ALTER COLUMN id SET DEFAULT nextval('post_office_log_id_seq'::regclass);


--
-- Name: redirectnode_redirectnode_translation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirectnode_redirectnode_translation ALTER COLUMN id SET DEFAULT nextval('redirectnode_redirectnode_translation_id_seq'::regclass);


--
-- Name: response_pages_responsepage id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY response_pages_responsepage ALTER COLUMN id SET DEFAULT nextval('response_pages_responsepage_id_seq'::regclass);


--
-- Name: reversion_revision id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_revision ALTER COLUMN id SET DEFAULT nextval('reversion_revision_id_seq'::regclass);


--
-- Name: reversion_version id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_version ALTER COLUMN id SET DEFAULT nextval('reversion_version_id_seq'::regclass);


--
-- Name: sharedcontent_sharedcontent id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent ALTER COLUMN id SET DEFAULT nextval('sharedcontent_sharedcontent_id_seq'::regclass);


--
-- Name: sharedcontent_sharedcontent_translation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent_translation ALTER COLUMN id SET DEFAULT nextval('sharedcontent_sharedcontent_translation_id_seq'::regclass);


--
-- Name: staff_profiles_department id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY staff_profiles_department ALTER COLUMN id SET DEFAULT nextval('staff_profiles_department_id_seq'::regclass);


--
-- Name: staff_profiles_staffprofile id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY staff_profiles_staffprofile ALTER COLUMN id SET DEFAULT nextval('staff_profiles_staffprofile_id_seq'::regclass);


--
-- Name: staff_profiles_staffprofile_department id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY staff_profiles_staffprofile_department ALTER COLUMN id SET DEFAULT nextval('staff_profiles_staffprofile_department_id_seq'::regclass);


--
-- Name: taggit_tag id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggit_tag ALTER COLUMN id SET DEFAULT nextval('taggit_tag_id_seq'::regclass);


--
-- Name: taggit_taggeditem id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggit_taggeditem ALTER COLUMN id SET DEFAULT nextval('taggit_taggeditem_id_seq'::regclass);


--
-- Name: test_article id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article ALTER COLUMN id SET DEFAULT nextval('test_article_id_seq'::regclass);


--
-- Name: test_layoutpage_with_related_related_pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages ALTER COLUMN id SET DEFAULT nextval('test_layoutpage_with_related_related_pages_id_seq'::regclass);


--
-- Name: tests_barwithlayout id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_barwithlayout ALTER COLUMN id SET DEFAULT nextval('tests_barwithlayout_id_seq'::regclass);


--
-- Name: tests_basemodel id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_basemodel ALTER COLUMN id SET DEFAULT nextval('tests_basemodel_id_seq'::regclass);


--
-- Name: tests_bazwithlayout id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_bazwithlayout ALTER COLUMN id SET DEFAULT nextval('tests_bazwithlayout_id_seq'::regclass);


--
-- Name: tests_foowithlayout id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_foowithlayout ALTER COLUMN id SET DEFAULT nextval('tests_foowithlayout_id_seq'::regclass);


--
-- Name: tests_imagetest id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_imagetest ALTER COLUMN id SET DEFAULT nextval('tests_imagetest_id_seq'::regclass);


--
-- Name: tests_publishingm2mmodela id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodela ALTER COLUMN id SET DEFAULT nextval('tests_publishingm2mmodela_id_seq'::regclass);


--
-- Name: tests_publishingm2mmodelb id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb ALTER COLUMN id SET DEFAULT nextval('tests_publishingm2mmodelb_id_seq'::regclass);


--
-- Name: tests_publishingm2mmodelb_related_a_models id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models ALTER COLUMN id SET DEFAULT nextval('tests_publishingm2mmodelb_related_a_models_id_seq'::regclass);


--
-- Name: tests_publishingm2mthroughtable id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mthroughtable ALTER COLUMN id SET DEFAULT nextval('tests_publishingm2mthroughtable_id_seq'::regclass);


--
-- Name: textfile_textfile_translation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY textfile_textfile_translation ALTER COLUMN id SET DEFAULT nextval('textfile_textfile_translation_id_seq'::regclass);


--
-- Data for Name: advanced_event_listing_page_locations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY advanced_event_listing_page_locations (id, advancedeventlistingpage_id, location_id) FROM stdin;
\.


--
-- Name: advanced_event_listing_page_locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('advanced_event_listing_page_locations_id_seq', 1, false);


--
-- Data for Name: advanced_event_listing_page_primary_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY advanced_event_listing_page_primary_types (id, advancedeventlistingpage_id, eventtype_id) FROM stdin;
\.


--
-- Name: advanced_event_listing_page_primary_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('advanced_event_listing_page_primary_types_id_seq', 1, false);


--
-- Data for Name: advanced_event_listing_page_secondary_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY advanced_event_listing_page_secondary_types (id, advancedeventlistingpage_id, eventtype_id) FROM stdin;
\.


--
-- Name: advanced_event_listing_page_secondary_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('advanced_event_listing_page_secondary_types_id_seq', 1, false);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: -
--

COPY auth_group (id, name) FROM stdin;
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('auth_group_id_seq', 1, false);


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('auth_group_permissions_id_seq', 1, false);


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add layout	1	add_layout
2	Can change layout	1	change_layout
3	Can delete layout	1	delete_layout
4	Can add Asset category	2	add_mediacategory
5	Can change Asset category	2	change_mediacategory
6	Can delete Asset category	2	delete_mediacategory
7	Can add user	4	add_user
8	Can change user	4	change_user
9	Can delete user	4	delete_user
10	Can add Form entry	5	add_formentry
11	Can change Form entry	5	change_formentry
12	Can delete Form entry	5	delete_formentry
13	Can add Form field entry	6	add_fieldentry
14	Can change Form field entry	6	change_fieldentry
15	Can delete Form field entry	6	delete_fieldentry
16	Can add Form	7	add_form
17	Can change Form	7	change_form
18	Can delete Form	7	delete_form
19	Can add Field	8	add_field
20	Can change Field	8	change_field
21	Can delete Field	8	delete_field
22	Can add revision	9	add_revision
23	Can change revision	9	change_revision
24	Can delete revision	9	delete_revision
25	Can add version	10	add_version
26	Can change version	10	change_version
27	Can delete version	10	delete_version
28	Can add log entry	11	add_logentry
29	Can change log entry	11	change_logentry
30	Can delete log entry	11	delete_logentry
31	Can add permission	12	add_permission
32	Can change permission	12	change_permission
33	Can delete permission	12	delete_permission
34	Can add group	13	add_group
35	Can change group	13	change_group
36	Can delete group	13	delete_group
37	Can add content type	14	add_contenttype
38	Can change content type	14	change_contenttype
39	Can delete content type	14	delete_contenttype
40	Can add session	15	add_session
41	Can change session	15	change_session
42	Can delete session	15	delete_session
43	Can add Token	16	add_token
44	Can change Token	16	change_token
45	Can delete Token	16	delete_token
46	Can add redirect	17	add_redirect
47	Can change redirect	17	change_redirect
48	Can delete redirect	17	delete_redirect
49	Can add site	18	add_site
50	Can change site	18	change_site
51	Can delete site	18	delete_site
52	Can add task state	19	add_taskmeta
53	Can change task state	19	change_taskmeta
54	Can delete task state	19	delete_taskmeta
55	Can add saved group result	20	add_tasksetmeta
56	Can change saved group result	20	change_tasksetmeta
57	Can delete saved group result	20	delete_tasksetmeta
58	Can add interval	21	add_intervalschedule
59	Can change interval	21	change_intervalschedule
60	Can delete interval	21	delete_intervalschedule
61	Can add crontab	22	add_crontabschedule
62	Can change crontab	22	change_crontabschedule
63	Can delete crontab	22	delete_crontabschedule
64	Can add periodic tasks	23	add_periodictasks
65	Can change periodic tasks	23	change_periodictasks
66	Can delete periodic tasks	23	delete_periodictasks
67	Can add periodic task	24	add_periodictask
68	Can change periodic task	24	change_periodictask
69	Can delete periodic task	24	delete_periodictask
70	Can add worker	25	add_workerstate
71	Can change worker	25	change_workerstate
72	Can delete worker	25	delete_workerstate
73	Can add task	26	add_taskstate
74	Can change task	26	change_taskstate
75	Can delete task	26	delete_taskstate
76	Can add queue	27	add_queue
77	Can change queue	27	change_queue
78	Can delete queue	27	delete_queue
79	Can add message	28	add_message
80	Can change message	28	change_message
81	Can delete message	28	delete_message
82	Can add source	29	add_source
83	Can change source	29	change_source
84	Can delete source	29	delete_source
85	Can add thumbnail	30	add_thumbnail
86	Can change thumbnail	30	change_thumbnail
87	Can delete thumbnail	30	delete_thumbnail
88	Can add thumbnail dimensions	31	add_thumbnaildimensions
89	Can change thumbnail dimensions	31	change_thumbnaildimensions
90	Can delete thumbnail dimensions	31	delete_thumbnaildimensions
91	Can add Placeholder	32	add_placeholder
92	Can change Placeholder	32	change_placeholder
93	Can delete Placeholder	32	delete_placeholder
94	Can add Contentitem link	33	add_contentitem
95	Can change Contentitem link	33	change_contentitem
96	Can delete Contentitem link	33	delete_contentitem
97	Can add URL Node	34	add_urlnode
98	Can change URL Node	34	change_urlnode
99	Can delete URL Node	34	delete_urlnode
100	Can change Shared fields	34	change_shared_fields_urlnode
101	Can change Override URL field	34	change_override_url_urlnode
102	Can add URL Node translation	35	add_urlnode_translation
103	Can change URL Node translation	35	change_urlnode_translation
104	Can delete URL Node translation	35	delete_urlnode_translation
105	Can add Page	34	add_page
106	Can change Page	34	change_page
107	Can delete Page	34	delete_page
108	Can add html page	34	add_htmlpage
109	Can change html page	34	change_htmlpage
110	Can delete html page	34	delete_htmlpage
111	Can add Layout	37	add_pagelayout
112	Can change Layout	37	change_pagelayout
113	Can delete Layout	37	delete_pagelayout
114	Can add Redirect	41	add_redirectnode
115	Can change Redirect	41	change_redirectnode
116	Can delete Redirect	41	delete_redirectnode
117	Can add Plain text file	43	add_textfile
118	Can change Plain text file	43	change_textfile
119	Can delete Plain text file	43	delete_textfile
120	Can add Iframe	44	add_iframeitem
121	Can change Iframe	44	change_iframeitem
122	Can delete Iframe	44	delete_iframeitem
123	Can add Online media	45	add_oembeditem
124	Can change Online media	45	change_oembeditem
125	Can delete Online media	45	delete_oembeditem
126	Can add HTML code	46	add_rawhtmlitem
127	Can change HTML code	46	change_rawhtmlitem
128	Can delete HTML code	46	delete_rawhtmlitem
129	Can add Shared content	48	add_sharedcontent
130	Can change Shared content	48	change_sharedcontent
131	Can delete Shared content	48	delete_sharedcontent
132	Can add Shared content	49	add_sharedcontentitem
133	Can change Shared content	49	change_sharedcontentitem
134	Can delete Shared content	49	delete_sharedcontentitem
135	Can add workflow state	50	add_workflowstate
136	Can change workflow state	50	change_workflowstate
137	Can delete workflow state	50	delete_workflowstate
138	Can add response page	51	add_responsepage
139	Can change response page	51	change_responsepage
140	Can delete response page	51	delete_responsepage
141	Can add navigation	52	add_navigation
142	Can change navigation	52	change_navigation
143	Can delete navigation	52	delete_navigation
144	Can add Navigation Item	53	add_navigationitem
145	Can change Navigation Item	53	change_navigationitem
146	Can delete Navigation Item	53	delete_navigationitem
147	Can add Accounts Navigation Item	54	add_accountsnavigationitem
148	Can change Accounts Navigation Item	54	change_accountsnavigationitem
149	Can delete Accounts Navigation Item	54	delete_accountsnavigationitem
150	Can add notification setting	55	add_notificationsetting
151	Can change notification setting	55	change_notificationsetting
152	Can delete notification setting	55	delete_notificationsetting
153	Can add has read message	56	add_hasreadmessage
154	Can change has read message	56	change_hasreadmessage
155	Can delete has read message	56	delete_hasreadmessage
156	Can add notification	57	add_notification
157	Can change notification	57	change_notification
158	Can delete notification	57	delete_notification
159	Can add follower information	58	add_followerinformation
160	Can change follower information	58	change_followerinformation
161	Can delete follower information	58	delete_followerinformation
162	Can Publish Article	59	can_publish
163	Can Republish Article	59	can_republish
164	Can Publish ArticleCategoryPage	60	can_publish
165	Can Republish ArticleCategoryPage	60	can_republish
166	Can add article	59	add_article
167	Can change article	59	change_article
168	Can delete article	59	delete_article
169	Can add article category page	60	add_articlecategorypage
170	Can change article category page	60	change_articlecategorypage
171	Can delete article category page	60	delete_articlecategorypage
172	Can Publish AuthorListing	61	can_publish
173	Can Republish AuthorListing	61	can_republish
174	Can Publish Author	62	can_publish
175	Can Republish Author	62	can_republish
176	Can add author listing	61	add_authorlisting
177	Can change author listing	61	change_authorlisting
178	Can delete author listing	61	delete_authorlisting
179	Can add author	62	add_author
180	Can change author	62	change_author
181	Can delete author	62	delete_author
182	Can Publish LayoutPage	63	can_publish
183	Can Republish LayoutPage	63	can_republish
184	Can add Page	63	add_layoutpage
185	Can change Page	63	change_layoutpage
186	Can delete Page	63	delete_layoutpage
187	Can Publish SearchPage	64	can_publish
188	Can Republish SearchPage	64	can_republish
189	Can add search page	64	add_searchpage
190	Can change search page	64	change_searchpage
191	Can delete search page	64	delete_searchpage
192	Can add Child Pages	65	add_childpageitem
193	Can change Child Pages	65	change_childpageitem
194	Can delete Child Pages	65	delete_childpageitem
195	Can add contact person	66	add_contactperson
196	Can change contact person	66	change_contactperson
197	Can delete contact person	66	delete_contactperson
198	Can add Contact Person	67	add_contactpersonitem
199	Can change Contact Person	67	change_contactpersonitem
200	Can delete Contact Person	67	delete_contactpersonitem
201	Can add Content Listing	68	add_contentlistingitem
202	Can change Content Listing	68	change_contentlistingitem
203	Can delete Content Listing	68	delete_contentlistingitem
204	Can add FAQ	69	add_faqitem
205	Can change FAQ	69	change_faqitem
206	Can delete FAQ	69	delete_faqitem
207	Can add file	70	add_file
208	Can change file	70	change_file
209	Can delete file	70	delete_file
210	Can add File	71	add_fileitem
211	Can change File	71	change_fileitem
212	Can delete File	71	delete_fileitem
213	Can add Horizontal Rule	72	add_horizontalruleitem
214	Can change Horizontal Rule	72	change_horizontalruleitem
215	Can delete Horizontal Rule	72	delete_horizontalruleitem
216	Can add image	73	add_image
217	Can change image	73	change_image
218	Can delete image	73	delete_image
219	Can add Image	74	add_imageitem
220	Can change Image	74	change_imageitem
221	Can delete Image	74	delete_imageitem
222	Can add Image derivative	75	add_imagerepurposeconfig
223	Can change Image derivative	75	change_imagerepurposeconfig
224	Can delete Image derivative	75	delete_imagerepurposeconfig
225	Can add Instagram Embed	76	add_instagramembeditem
226	Can change Instagram Embed	76	change_instagramembeditem
227	Can delete Instagram Embed	76	delete_instagramembeditem
228	Can add Page link	77	add_pagelink
229	Can change Page link	77	change_pagelink
230	Can delete Page link	77	delete_pagelink
231	Can add Article link	78	add_articlelink
232	Can change Article link	78	change_articlelink
233	Can delete Article link	78	delete_articlelink
234	Can add Author link	79	add_authorlink
235	Can change Author link	79	change_authorlink
236	Can delete Author link	79	delete_authorlink
237	Can add Google Map	80	add_mapitem
238	Can change Google Map	80	change_mapitem
239	Can delete Google Map	80	delete_mapitem
240	Can add Embedded media	81	add_oembedwithcaptionitem
241	Can change Embedded media	81	change_oembedwithcaptionitem
242	Can delete Embedded media	81	delete_oembedwithcaptionitem
243	Can add Page Anchor	82	add_pageanchoritem
244	Can change Page Anchor	82	change_pageanchoritem
245	Can delete Page Anchor	82	delete_pageanchoritem
246	Can add Page Anchor List	83	add_pageanchorlistitem
247	Can change Page Anchor List	83	change_pageanchorlistitem
248	Can delete Page Anchor List	83	delete_pageanchorlistitem
249	Can add Pull quote	84	add_quoteitem
250	Can change Pull quote	84	change_quoteitem
251	Can delete Pull quote	84	delete_quoteitem
252	Can add Form	85	add_formitem
253	Can change Form	85	change_formitem
254	Can delete Form	85	delete_formitem
255	Can Publish SlideShow	86	can_publish
256	Can Republish SlideShow	86	can_republish
257	Can add Image gallery	86	add_slideshow
258	Can change Image gallery	86	change_slideshow
259	Can delete Image gallery	86	delete_slideshow
260	Can add Slide show	87	add_slideshowitem
261	Can change Slide show	87	change_slideshowitem
262	Can delete Slide show	87	delete_slideshowitem
263	Can add Image Gallery	88	add_imagegalleryshowitem
264	Can change Image Gallery	88	change_imagegalleryshowitem
265	Can delete Image Gallery	88	delete_imagegalleryshowitem
266	Can add Twitter Embed	89	add_twitterembeditem
267	Can change Twitter Embed	89	change_twitterembeditem
268	Can delete Twitter Embed	89	delete_twitterembeditem
269	Can add Text	90	add_textitem
270	Can change Text	90	change_textitem
271	Can delete Text	90	delete_textitem
272	Can Publish Location	91	can_publish
273	Can Republish Location	91	can_republish
274	Can add location	91	add_location
275	Can change location	91	change_location
276	Can delete location	91	delete_location
277	Can add Location	92	add_locationitem
278	Can change Location	92	change_locationitem
279	Can delete Location	92	delete_locationitem
280	Can Publish EventBase	93	can_publish
281	Can Republish EventBase	93	can_republish
282	Can add recurrence rule	94	add_recurrencerule
283	Can change recurrence rule	94	change_recurrencerule
284	Can delete recurrence rule	94	delete_recurrencerule
285	Can add Event category	95	add_eventtype
286	Can change Event category	95	change_eventtype
287	Can delete Event category	95	delete_eventtype
288	Can add Event	93	add_eventbase
289	Can change Event	93	change_eventbase
290	Can delete Event	93	delete_eventbase
291	Can add event repeats generator	96	add_eventrepeatsgenerator
292	Can change event repeats generator	96	change_eventrepeatsgenerator
293	Can delete event repeats generator	96	delete_eventrepeatsgenerator
294	Can add occurrence	97	add_occurrence
295	Can change occurrence	97	change_occurrence
296	Can delete occurrence	97	delete_occurrence
297	Can Publish SimpleEvent	98	can_publish
298	Can Republish SimpleEvent	98	can_republish
299	Can add Simple event	98	add_simpleevent
300	Can change Simple event	98	change_simpleevent
301	Can delete Simple event	98	delete_simpleevent
302	Can Publish EventListingPage	99	can_publish
303	Can Republish EventListingPage	99	can_republish
304	Can add Event listing for date	99	add_eventlistingpage
305	Can change Event listing for date	99	change_eventlistingpage
306	Can delete Event listing for date	99	delete_eventlistingpage
307	Can Publish AdvancedEventListingPage	100	can_publish
308	Can Republish AdvancedEventListingPage	100	can_republish
309	Can add Advanced Event listing	100	add_advancedeventlistingpage
310	Can change Advanced Event listing	100	change_advancedeventlistingpage
311	Can delete Advanced Event listing	100	delete_advancedeventlistingpage
312	Can add Event Content Listing	101	add_eventcontentlistingitem
313	Can change Event Content Listing	101	change_eventcontentlistingitem
314	Can delete Event Content Listing	101	delete_eventcontentlistingitem
315	Can add Event link	102	add_eventlink
316	Can change Event link	102	change_eventlink
317	Can delete Event link	102	delete_eventlink
318	Can add Today's events	103	add_todaysoccurrences
319	Can change Today's events	103	change_todaysoccurrences
320	Can delete Today's events	103	delete_todaysoccurrences
321	Can add country	104	add_country
322	Can change country	104	change_country
323	Can delete country	104	delete_country
324	Can add geographic location	105	add_geographiclocation
325	Can change geographic location	105	change_geographiclocation
326	Can delete geographic location	105	delete_geographiclocation
327	Can Publish CreatorBase	106	can_publish
328	Can Republish CreatorBase	106	can_republish
329	Can Publish WorkBase	107	can_publish
330	Can Republish WorkBase	107	can_republish
331	Can add creator	106	add_creatorbase
332	Can change creator	106	change_creatorbase
333	Can delete creator	106	delete_creatorbase
334	Can add work origin	108	add_workorigin
335	Can change work origin	108	change_workorigin
336	Can delete work origin	108	delete_workorigin
337	Can add work	107	add_workbase
338	Can change work	107	change_workbase
339	Can delete work	107	delete_workbase
340	Can add role	109	add_role
341	Can change role	109	change_role
342	Can delete role	109	delete_role
343	Can add Work-Creator relation	110	add_workcreator
344	Can change Work-Creator relation	110	change_workcreator
345	Can delete Work-Creator relation	110	delete_workcreator
346	Can add Image type	111	add_workimagetype
347	Can change Image type	111	change_workimagetype
348	Can delete Image type	111	delete_workimagetype
349	Can add Image	112	add_workimage
350	Can change Image	112	change_workimage
351	Can delete Image	112	delete_workimage
352	Can add Work link	113	add_worklink
353	Can change Work link	113	change_worklink
354	Can delete Work link	113	delete_worklink
355	Can add Creator link	114	add_creatorlink
356	Can change Creator link	114	change_creatorlink
357	Can delete Creator link	114	delete_creatorlink
358	Can add sponsor	115	add_sponsor
359	Can change sponsor	115	change_sponsor
360	Can delete sponsor	115	delete_sponsor
361	Can add Begin Sponsor Block	116	add_beginsponsorblockitem
362	Can change Begin Sponsor Block	116	change_beginsponsorblockitem
363	Can delete Begin Sponsor Block	116	delete_beginsponsorblockitem
364	Can add End sponsor block	117	add_endsponsorblockitem
365	Can change End sponsor block	117	change_endsponsorblockitem
366	Can delete End sponsor block	117	delete_endsponsorblockitem
367	Can add Sponsor promo	118	add_sponsorpromoitem
368	Can change Sponsor promo	118	change_sponsorpromoitem
369	Can delete Sponsor promo	118	delete_sponsorpromoitem
370	Can Publish PressReleaseListing	119	can_publish
371	Can Republish PressReleaseListing	119	can_republish
372	Can Publish PressRelease	120	can_publish
373	Can Republish PressRelease	120	can_republish
374	Can add Press release listing	119	add_pressreleaselisting
375	Can change Press release listing	119	change_pressreleaselisting
376	Can delete Press release listing	119	delete_pressreleaselisting
377	Can add press release category	121	add_pressreleasecategory
378	Can change press release category	121	change_pressreleasecategory
379	Can delete press release category	121	delete_pressreleasecategory
380	Can add press release	120	add_pressrelease
381	Can change press release	120	change_pressrelease
382	Can delete press release	120	delete_pressrelease
383	Can add setting	122	add_setting
384	Can change setting	122	change_setting
385	Can delete setting	122	delete_setting
386	Can add boolean	123	add_boolean
387	Can change boolean	123	change_boolean
388	Can delete boolean	123	delete_boolean
389	Can add date	124	add_date
390	Can change date	124	change_date
391	Can delete date	124	delete_date
392	Can add date time	125	add_datetime
393	Can change date time	125	change_datetime
394	Can delete date time	125	delete_datetime
395	Can add decimal	126	add_decimal
396	Can change decimal	126	change_decimal
397	Can delete decimal	126	delete_decimal
398	Can add file	127	add_file
399	Can change file	127	change_file
400	Can delete file	127	delete_file
401	Can add float	128	add_float
402	Can change float	128	change_float
403	Can delete float	128	delete_float
404	Can add image	129	add_image
405	Can change image	129	change_image
406	Can delete image	129	delete_image
407	Can add integer	130	add_integer
408	Can change integer	130	change_integer
409	Can delete integer	130	delete_integer
410	Can add text	131	add_text
411	Can change text	131	change_text
412	Can delete text	131	delete_text
413	Can add time	132	add_time
414	Can change time	132	change_time
415	Can delete time	132	delete_time
416	Can add user with email login	3	add_emailuser
417	Can change user with email login	3	change_emailuser
418	Can delete user with email login	3	delete_emailuser
419	Can add Email	133	add_email
420	Can change Email	133	change_email
421	Can delete Email	133	delete_email
422	Can add Log	134	add_log
423	Can change Log	134	change_log
424	Can delete Log	134	delete_log
425	Can add Email Template	135	add_emailtemplate
426	Can change Email Template	135	change_emailtemplate
427	Can delete Email Template	135	delete_emailtemplate
428	Can add Attachment	136	add_attachment
429	Can change Attachment	136	change_attachment
430	Can delete Attachment	136	delete_attachment
431	Can add Page	137	add_fluentpage
432	Can change Page	137	change_fluentpage
433	Can delete Page	137	delete_fluentpage
434	Can change Page layout	137	change_page_layout
435	Can Publish ArticleListing	138	can_publish
436	Can Republish ArticleListing	138	can_republish
437	Can Publish Article	139	can_publish
438	Can Republish Article	139	can_republish
439	Can Publish LayoutPageWithRelatedPages	140	can_publish
440	Can Republish LayoutPageWithRelatedPages	140	can_republish
441	Can Publish PublishingM2MModelA	141	can_publish
442	Can Republish PublishingM2MModelA	141	can_republish
443	Can Publish PublishingM2MModelB	142	can_publish
444	Can Republish PublishingM2MModelB	142	can_republish
445	Can add base model	143	add_basemodel
446	Can change base model	143	change_basemodel
447	Can delete base model	143	delete_basemodel
448	Can add foo with layout	144	add_foowithlayout
449	Can change foo with layout	144	change_foowithlayout
450	Can delete foo with layout	144	delete_foowithlayout
451	Can add bar with layout	145	add_barwithlayout
452	Can change bar with layout	145	change_barwithlayout
453	Can delete bar with layout	145	delete_barwithlayout
454	Can add baz with layout	146	add_bazwithlayout
455	Can change baz with layout	146	change_bazwithlayout
456	Can delete baz with layout	146	delete_bazwithlayout
457	Can add image test	147	add_imagetest
458	Can change image test	147	change_imagetest
459	Can delete image test	147	delete_imagetest
460	Can add article listing	138	add_articlelisting
461	Can change article listing	138	change_articlelisting
462	Can delete article listing	138	delete_articlelisting
463	Can add article	139	add_article
464	Can change article	139	change_article
465	Can delete article	139	delete_article
466	Can add layout page with related pages	140	add_layoutpagewithrelatedpages
467	Can change layout page with related pages	140	change_layoutpagewithrelatedpages
468	Can delete layout page with related pages	140	delete_layoutpagewithrelatedpages
469	Can add publishing m2m model a	141	add_publishingm2mmodela
470	Can change publishing m2m model a	141	change_publishingm2mmodela
471	Can delete publishing m2m model a	141	delete_publishingm2mmodela
472	Can add publishing m2m model b	142	add_publishingm2mmodelb
473	Can change publishing m2m model b	142	change_publishingm2mmodelb
474	Can delete publishing m2m model b	142	delete_publishingm2mmodelb
475	Can add publishing m2m through table	148	add_publishingm2mthroughtable
476	Can change publishing m2m through table	148	change_publishingm2mthroughtable
477	Can delete publishing m2m through table	148	delete_publishingm2mthroughtable
478	Can Publish Artwork	149	can_publish
479	Can Republish Artwork	149	can_republish
480	Can add artwork	149	add_artwork
481	Can change artwork	149	change_artwork
482	Can delete artwork	149	delete_artwork
483	Can Publish Film	150	can_publish
484	Can Republish Film	150	can_republish
485	Can add format	151	add_format
486	Can change format	151	change_format
487	Can delete format	151	delete_format
488	Can add film	150	add_film
489	Can change film	150	change_film
490	Can delete film	150	delete_film
491	Can Publish Game	152	can_publish
492	Can Republish Game	152	can_republish
493	Can add game input type	153	add_gameinputtype
494	Can change game input type	153	change_gameinputtype
495	Can delete game input type	153	delete_gameinputtype
496	Can add game platform	154	add_gameplatform
497	Can change game platform	154	change_gameplatform
498	Can delete game platform	154	delete_gameplatform
499	Can add game	152	add_game
500	Can change game	152	change_game
501	Can delete game	152	delete_game
502	Can Publish MovingImageWork	155	can_publish
503	Can Republish MovingImageWork	155	can_republish
504	Can add rating	156	add_rating
505	Can change rating	156	change_rating
506	Can delete rating	156	delete_rating
507	Can add genre	157	add_genre
508	Can change genre	157	change_genre
509	Can delete genre	157	delete_genre
510	Can add media type	158	add_mediatype
511	Can change media type	158	change_mediatype
512	Can delete media type	158	delete_mediatype
513	Can add moving image work	155	add_movingimagework
514	Can change moving image work	155	change_movingimagework
515	Can delete moving image work	155	delete_movingimagework
516	Can Publish OrganizationCreator	159	can_publish
517	Can Republish OrganizationCreator	159	can_republish
518	Can add organization	159	add_organizationcreator
519	Can change organization	159	change_organizationcreator
520	Can delete organization	159	delete_organizationcreator
521	Can Publish PersonCreator	160	can_publish
522	Can Republish PersonCreator	160	can_republish
523	Can add person	160	add_personcreator
524	Can change person	160	change_personcreator
525	Can delete person	160	delete_personcreator
526	Can Publish BiennaleEvent	161	can_publish
527	Can Republish BiennaleEvent	161	can_republish
528	Can Publish BiennaleLocation	162	can_publish
529	Can Republish BiennaleLocation	162	can_republish
530	Can add Biennale Event	161	add_biennaleevent
531	Can change Biennale Event	161	change_biennaleevent
532	Can delete Biennale Event	161	delete_biennaleevent
533	Can add event artist	163	add_eventartist
534	Can change event artist	163	change_eventartist
535	Can delete event artist	163	delete_eventartist
536	Can add exhibition	164	add_exhibition
537	Can change exhibition	164	change_exhibition
538	Can delete exhibition	164	delete_exhibition
539	Can add partner	165	add_partner
540	Can change partner	165	change_partner
541	Can delete partner	165	delete_partner
542	Can add biennale location	162	add_biennalelocation
543	Can change biennale location	162	change_biennalelocation
544	Can delete biennale location	162	delete_biennalelocation
545	Can add department	166	add_department
546	Can change department	166	change_department
547	Can delete department	166	delete_department
548	Can add staff profile	167	add_staffprofile
549	Can change staff profile	167	change_staffprofile
550	Can delete staff profile	167	delete_staffprofile
551	Can add staff profiles list	168	add_staffprofileslist
552	Can change staff profiles list	168	change_staffprofileslist
553	Can delete staff profiles list	168	delete_staffprofileslist
554	Can add media coverage promo item	169	add_mediacoveragepromoitem
555	Can change media coverage promo item	169	change_mediacoveragepromoitem
556	Can delete media coverage promo item	169	delete_mediacoveragepromoitem
557	Can add media coverage record	170	add_mediacoveragerecord
558	Can change media coverage record	170	change_mediacoveragerecord
559	Can delete media coverage record	170	delete_mediacoveragerecord
560	Can add media coverage list	171	add_mediacoveragelist
561	Can change media coverage list	171	change_mediacoveragelist
562	Can delete media coverage list	171	delete_mediacoveragelist
563	Can add Tag	172	add_tag
564	Can change Tag	172	change_tag
565	Can delete Tag	172	delete_tag
566	Can add Tagged Item	173	add_taggeditem
567	Can change Tagged Item	173	change_taggeditem
568	Can delete Tagged Item	173	delete_taggeditem
569	Can Use IIIF Image API	4	can_use_iiif_image_api
\.


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('auth_permission_id_seq', 569, true);


--
-- Data for Name: authtoken_token; Type: TABLE DATA; Schema: public; Owner: -
--

COPY authtoken_token (key, created, user_id) FROM stdin;
\.


--
-- Data for Name: biennale_of_sydney_biennaleevent; Type: TABLE DATA; Schema: public; Owner: -
--

COPY biennale_of_sydney_biennaleevent (eventbase_ptr_id, list_image, boosted_search_terms, event_location_id, hero_image_id, layout_id) FROM stdin;
\.


--
-- Data for Name: biennale_of_sydney_biennaleevent_works; Type: TABLE DATA; Schema: public; Owner: -
--

COPY biennale_of_sydney_biennaleevent_works (id, biennaleevent_id, workbase_id) FROM stdin;
\.


--
-- Name: biennale_of_sydney_biennaleevent_works_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('biennale_of_sydney_biennaleevent_works_id_seq', 1, false);


--
-- Data for Name: biennale_of_sydney_biennalelocation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY biennale_of_sydney_biennalelocation (id, brief, admin_notes, list_image, boosted_search_terms, map_description, map_zoom, map_center_lat, map_center_long, map_center_description, map_marker_lat, map_marker_long, map_marker_description, publishing_is_draft, publishing_modified_at, publishing_published_at, title, slug, is_home_location, address, phone_number, phone_number_call_to_action, url, url_call_to_action, email, email_call_to_action, hero_image_id, layout_id, partner_id, publishing_linked_id) FROM stdin;
\.


--
-- Name: biennale_of_sydney_biennalelocation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('biennale_of_sydney_biennalelocation_id_seq', 1, false);


--
-- Data for Name: biennale_of_sydney_eventartist; Type: TABLE DATA; Schema: public; Owner: -
--

COPY biennale_of_sydney_eventartist (id, type, artist_id, event_id) FROM stdin;
\.


--
-- Name: biennale_of_sydney_eventartist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('biennale_of_sydney_eventartist_id_seq', 1, false);


--
-- Data for Name: biennale_of_sydney_exhibition; Type: TABLE DATA; Schema: public; Owner: -
--

COPY biennale_of_sydney_exhibition (occurrence_ptr_id) FROM stdin;
\.


--
-- Data for Name: biennale_of_sydney_partner; Type: TABLE DATA; Schema: public; Owner: -
--

COPY biennale_of_sydney_partner (id, type) FROM stdin;
\.


--
-- Name: biennale_of_sydney_partner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('biennale_of_sydney_partner_id_seq', 1, false);


--
-- Data for Name: celery_taskmeta; Type: TABLE DATA; Schema: public; Owner: -
--

COPY celery_taskmeta (id, task_id, status, result, date_done, traceback, hidden, meta) FROM stdin;
\.


--
-- Name: celery_taskmeta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('celery_taskmeta_id_seq', 1, false);


--
-- Data for Name: celery_tasksetmeta; Type: TABLE DATA; Schema: public; Owner: -
--

COPY celery_tasksetmeta (id, taskset_id, result, date_done, hidden) FROM stdin;
\.


--
-- Name: celery_tasksetmeta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('celery_tasksetmeta_id_seq', 1, false);


--
-- Data for Name: contentitem_gk_collections_links_creatorlink; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_gk_collections_links_creatorlink (contentitem_ptr_id, style, type_override, title_override, url_override, image_override, item_id, oneliner_override) FROM stdin;
\.


--
-- Data for Name: contentitem_gk_collections_links_worklink; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_gk_collections_links_worklink (contentitem_ptr_id, style, type_override, title_override, url_override, image_override, item_id, oneliner_override) FROM stdin;
\.


--
-- Data for Name: contentitem_glamkit_sponsors_beginsponsorblockitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_glamkit_sponsors_beginsponsorblockitem (contentitem_ptr_id, text) FROM stdin;
\.


--
-- Data for Name: contentitem_glamkit_sponsors_endsponsorblockitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_glamkit_sponsors_endsponsorblockitem (contentitem_ptr_id, text) FROM stdin;
\.


--
-- Data for Name: contentitem_glamkit_sponsors_sponsorpromoitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_glamkit_sponsors_sponsorpromoitem (contentitem_ptr_id, title, width, quality, sponsor_id) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_events_links_eventlink; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_events_links_eventlink (contentitem_ptr_id, style, type_override, title_override, oneliner_override, url_override, image_override, item_id, include_even_when_finished) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_navigation_accountsnavigationitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_navigation_accountsnavigationitem (contentitem_ptr_id) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_navigation_navigationitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_navigation_navigationitem (contentitem_ptr_id, title, url, html_class) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_plugins_child_pages_childpageitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_child_pages_childpageitem (contentitem_ptr_id) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_plugins_contact_person_contactpersonitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_contact_person_contactpersonitem (contentitem_ptr_id, contact_id) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_plugins_content_listing_contentlistingitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_content_listing_contentlistingitem (contentitem_ptr_id, content_type_id, "limit", no_items_message) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_plugins_faq_faqitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_faq_faqitem (contentitem_ptr_id, question, answer, load_open) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_plugins_file_fileitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_file_fileitem (contentitem_ptr_id, file_id) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_plugins_horizontal_rule_horizontalruleitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_horizontal_rule_horizontalruleitem (contentitem_ptr_id) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_plugins_image_imageitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_image_imageitem (contentitem_ptr_id, image_id, caption_override, show_caption, show_title, title_override) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_plugins_instagram_embed_instagramembeditem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_instagram_embed_instagramembeditem (contentitem_ptr_id, url, provider_url, media_id, author_name, height, width, thumbnail_url, thumbnail_width, thumbnail_height, provider_name, title, html, version, author_url, author_id, type) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_plugins_location_locationitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_location_locationitem (contentitem_ptr_id, location_id) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_plugins_map_mapitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_map_mapitem (contentitem_ptr_id, _cleaned_embed_code, _embed_code) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem (contentitem_ptr_id) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_plugins_page_anchor_pageanchoritem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_page_anchor_pageanchoritem (contentitem_ptr_id, anchor_name) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_plugins_quote_quoteitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_quote_quoteitem (contentitem_ptr_id, quote, attribution, organisation, url) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_plugins_reusable_form_formitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_reusable_form_formitem (contentitem_ptr_id, form_id) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_plugins_slideshow_slideshowitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_slideshow_slideshowitem (contentitem_ptr_id, slide_show_id) FROM stdin;
\.


--
-- Data for Name: contentitem_icekit_plugins_twitter_embed_twitterembeditem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_twitter_embed_twitterembeditem (contentitem_ptr_id, twitter_url, url, provider_url, cache_age, author_name, height, width, provider_name, version, author_url, type, html) FROM stdin;
\.


--
-- Data for Name: contentitem_iframe_iframeitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_iframe_iframeitem (contentitem_ptr_id, src, width, height) FROM stdin;
\.


--
-- Data for Name: contentitem_ik_event_listing_eventcontentlistingitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_ik_event_listing_eventcontentlistingitem (contentitem_ptr_id, "limit", content_type_id, from_date, from_days_ago, to_date, to_days_ahead, no_items_message) FROM stdin;
\.


--
-- Data for Name: contentitem_ik_events_todays_occurrences_todaysoccurrences; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_ik_events_todays_occurrences_todaysoccurrences (contentitem_ptr_id, include_finished, fall_back_to_next_day, title) FROM stdin;
\.


--
-- Data for Name: contentitem_ik_links_articlelink; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_ik_links_articlelink (contentitem_ptr_id, style, type_override, title_override, image_override, item_id, url_override, oneliner_override) FROM stdin;
\.


--
-- Data for Name: contentitem_ik_links_authorlink; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_ik_links_authorlink (contentitem_ptr_id, style, type_override, title_override, image_override, item_id, url_override, oneliner_override, exclude_from_contributions, exclude_from_authorship) FROM stdin;
\.


--
-- Data for Name: contentitem_ik_links_pagelink; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_ik_links_pagelink (contentitem_ptr_id, style, type_override, title_override, image_override, item_id, url_override, oneliner_override) FROM stdin;
\.


--
-- Data for Name: contentitem_image_gallery_imagegalleryshowitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_image_gallery_imagegalleryshowitem (contentitem_ptr_id, slide_show_id) FROM stdin;
\.


--
-- Data for Name: contentitem_media_coverage_mediacoveragelist; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_media_coverage_mediacoveragelist (contentitem_ptr_id) FROM stdin;
\.


--
-- Data for Name: contentitem_media_coverage_mediacoveragepromoitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_media_coverage_mediacoveragepromoitem (contentitem_ptr_id, media_coverage_id) FROM stdin;
\.


--
-- Data for Name: contentitem_oembed_with_caption_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_oembed_with_caption_item (contentitem_ptr_id, embed_url, embed_max_width, embed_max_height, type, url, title, description, author_name, author_url, provider_name, provider_url, thumbnail_url, thumbnail_height, thumbnail_width, height, width, html, caption, is_16by9, content_title) FROM stdin;
\.


--
-- Data for Name: contentitem_oembeditem_oembeditem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_oembeditem_oembeditem (contentitem_ptr_id, embed_url, embed_max_width, embed_max_height, type, url, title, description, author_name, author_url, provider_name, provider_url, thumbnail_url, thumbnail_height, thumbnail_width, height, width, html) FROM stdin;
\.


--
-- Data for Name: contentitem_rawhtml_rawhtmlitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_rawhtml_rawhtmlitem (contentitem_ptr_id, html) FROM stdin;
\.


--
-- Data for Name: contentitem_sharedcontent_sharedcontentitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_sharedcontent_sharedcontentitem (contentitem_ptr_id, shared_content_id) FROM stdin;
\.


--
-- Data for Name: contentitem_staff_profile_list_staffprofileslist; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_staff_profile_list_staffprofileslist (contentitem_ptr_id) FROM stdin;
\.


--
-- Data for Name: contentitem_text_textitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_text_textitem (contentitem_ptr_id, text, style) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 1, false);


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_content_type (id, app_label, model) FROM stdin;
1	icekit	layout
2	icekit	mediacategory
3	polymorphic_auth_email	emailuser
4	polymorphic_auth	user
5	forms	formentry
6	forms	fieldentry
7	forms	form
8	forms	field
9	reversion	revision
10	reversion	version
11	admin	logentry
12	auth	permission
13	auth	group
14	contenttypes	contenttype
15	sessions	session
16	authtoken	token
17	redirects	redirect
18	sites	site
19	djcelery	taskmeta
20	djcelery	tasksetmeta
21	djcelery	intervalschedule
22	djcelery	crontabschedule
23	djcelery	periodictasks
24	djcelery	periodictask
25	djcelery	workerstate
26	djcelery	taskstate
27	kombu_transport_django	queue
28	kombu_transport_django	message
29	easy_thumbnails	source
30	easy_thumbnails	thumbnail
31	easy_thumbnails	thumbnaildimensions
32	fluent_contents	placeholder
33	fluent_contents	contentitem
34	fluent_pages	urlnode
35	fluent_pages	urlnode_translation
36	fluent_pages	htmlpagetranslation
37	fluent_pages	pagelayout
38	fluent_pages	page
39	fluent_pages	htmlpage
40	redirectnode	redirectnodetranslation
41	redirectnode	redirectnode
42	textfile	textfiletranslation
43	textfile	textfile
44	iframe	iframeitem
45	oembeditem	oembeditem
46	rawhtml	rawhtmlitem
47	sharedcontent	sharedcontenttranslation
48	sharedcontent	sharedcontent
49	sharedcontent	sharedcontentitem
50	icekit_workflow	workflowstate
51	response_pages	responsepage
52	icekit_navigation	navigation
53	icekit_navigation	navigationitem
54	icekit_navigation	accountsnavigationitem
55	notifications	notificationsetting
56	notifications	hasreadmessage
57	notifications	notification
58	notifications	followerinformation
59	icekit_article	article
60	icekit_article	articlecategorypage
61	icekit_authors	authorlisting
62	icekit_authors	author
63	layout_page	layoutpage
64	search_page	searchpage
65	icekit_plugins_child_pages	childpageitem
66	icekit_plugins_contact_person	contactperson
67	icekit_plugins_contact_person	contactpersonitem
68	icekit_plugins_content_listing	contentlistingitem
69	icekit_plugins_faq	faqitem
70	icekit_plugins_file	file
71	icekit_plugins_file	fileitem
72	icekit_plugins_horizontal_rule	horizontalruleitem
73	icekit_plugins_image	image
74	icekit_plugins_image	imageitem
75	icekit_plugins_image	imagerepurposeconfig
76	icekit_plugins_instagram_embed	instagramembeditem
77	ik_links	pagelink
78	ik_links	articlelink
79	ik_links	authorlink
80	icekit_plugins_map	mapitem
81	icekit_plugins_oembed_with_caption	oembedwithcaptionitem
82	icekit_plugins_page_anchor	pageanchoritem
83	icekit_plugins_page_anchor_list	pageanchorlistitem
84	icekit_plugins_quote	quoteitem
85	icekit_plugins_reusable_form	formitem
86	icekit_plugins_slideshow	slideshow
87	icekit_plugins_slideshow	slideshowitem
88	image_gallery	imagegalleryshowitem
89	icekit_plugins_twitter_embed	twitterembeditem
90	text	textitem
91	icekit_plugins_location	location
92	icekit_plugins_location	locationitem
93	icekit_events	eventbase
94	icekit_events	recurrencerule
95	icekit_events	eventtype
96	icekit_events	eventrepeatsgenerator
97	icekit_events	occurrence
98	icekit_event_types_simple	simpleevent
99	eventlistingfordate	eventlistingpage
100	advancedeventlisting	advancedeventlistingpage
101	ik_event_listing	eventcontentlistingitem
102	icekit_events_links	eventlink
103	ik_events_todays_occurrences	todaysoccurrences
104	glamkit_collections	country
105	glamkit_collections	geographiclocation
106	gk_collections_work_creator	creatorbase
107	gk_collections_work_creator	workbase
108	gk_collections_work_creator	workorigin
109	gk_collections_work_creator	role
110	gk_collections_work_creator	workcreator
111	gk_collections_work_creator	workimagetype
112	gk_collections_work_creator	workimage
113	gk_collections_links	worklink
114	gk_collections_links	creatorlink
115	glamkit_sponsors	sponsor
116	glamkit_sponsors	beginsponsorblockitem
117	glamkit_sponsors	endsponsorblockitem
118	glamkit_sponsors	sponsorpromoitem
119	icekit_press_releases	pressreleaselisting
120	icekit_press_releases	pressrelease
121	icekit_press_releases	pressreleasecategory
122	model_settings	setting
123	model_settings	boolean
124	model_settings	date
125	model_settings	datetime
126	model_settings	decimal
127	model_settings	file
128	model_settings	float
129	model_settings	image
130	model_settings	integer
131	model_settings	text
132	model_settings	time
133	post_office	email
134	post_office	log
135	post_office	emailtemplate
136	post_office	attachment
137	fluentpage	fluentpage
138	tests	articlelisting
139	tests	article
140	tests	layoutpagewithrelatedpages
141	tests	publishingm2mmodela
142	tests	publishingm2mmodelb
143	tests	basemodel
144	tests	foowithlayout
145	tests	barwithlayout
146	tests	bazwithlayout
147	tests	imagetest
148	tests	publishingm2mthroughtable
149	gk_collections_artwork	artwork
150	gk_collections_film	film
151	gk_collections_film	format
152	gk_collections_game	game
153	gk_collections_game	gameinputtype
154	gk_collections_game	gameplatform
155	gk_collections_moving_image	movingimagework
156	gk_collections_moving_image	rating
157	gk_collections_moving_image	genre
158	gk_collections_moving_image	mediatype
159	gk_collections_organization	organizationcreator
160	gk_collections_person	personcreator
161	biennale_of_sydney	biennaleevent
162	biennale_of_sydney	biennalelocation
163	biennale_of_sydney	eventartist
164	biennale_of_sydney	exhibition
165	biennale_of_sydney	partner
166	staff_profiles	department
167	staff_profiles	staffprofile
168	staff_profile_list	staffprofileslist
169	media_coverage	mediacoveragepromoitem
170	media_coverage	mediacoveragerecord
171	media_coverage	mediacoveragelist
172	taggit	tag
173	taggit	taggeditem
\.


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_content_type_id_seq', 173, true);


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2018-01-03 09:55:59.611902+11
2	auth	0001_initial	2018-01-03 09:55:59.757878+11
3	polymorphic_auth	0001_initial	2018-01-03 09:55:59.828908+11
4	admin	0001_initial	2018-01-03 09:55:59.887929+11
5	taggit	0001_initial	2018-01-03 09:56:00.066276+11
6	taggit	0002_auto_20150616_2121	2018-01-03 09:56:00.177837+11
7	icekit	0001_initial	2018-01-03 09:56:00.218034+11
8	icekit	0002_layout	2018-01-03 09:56:00.258806+11
9	icekit	0003_layout_content_types	2018-01-03 09:56:00.361017+11
10	icekit	0004_auto_20150611_2044	2018-01-03 09:56:00.526061+11
11	icekit	0005_remove_layout_key	2018-01-03 09:56:00.635465+11
12	icekit	0006_auto_20150911_0744	2018-01-03 09:56:00.755857+11
13	icekit	0007_auto_20170310_1220	2018-01-03 09:56:00.784609+11
14	icekit_plugins_location	0001_initial	2018-01-03 09:56:01.057085+11
15	fluent_contents	0001_initial	2018-01-03 09:56:01.79129+11
16	icekit_plugins_image	0001_initial	2018-01-03 09:56:01.922615+11
17	icekit_plugins_image	0002_auto_20150527_0022	2018-01-03 09:56:02.013264+11
18	icekit_plugins_image	0003_auto_20150623_0115	2018-01-03 09:56:02.192966+11
19	icekit_plugins_image	0004_auto_20151001_2023	2018-01-03 09:56:02.625394+11
20	icekit_plugins_image	0005_imageitem_caption_override	2018-01-03 09:56:02.812874+11
21	icekit_plugins_image	0006_auto_20160309_0453	2018-01-03 09:56:03.337537+11
22	icekit_plugins_image	0007_auto_20160920_1626	2018-01-03 09:56:13.869393+11
23	icekit_plugins_image	0008_auto_20160920_2114	2018-01-03 09:56:14.185687+11
24	icekit_plugins_image	0009_auto_20161026_2044	2018-01-03 09:56:14.27899+11
25	icekit_plugins_image	0010_auto_20170307_1458	2018-01-03 09:56:15.614706+11
26	icekit_plugins_image	0011_auto_20170310_1853	2018-01-03 09:56:15.889329+11
27	icekit_plugins_image	0012_imagerepurposeconfig_is_cropping_allowed	2018-01-03 09:56:15.933954+11
28	icekit_plugins_image	0013_image_is_cropping_allowed	2018-01-03 09:56:16.087805+11
29	icekit_plugins_image	0014_image_external_ref	2018-01-03 09:56:16.203148+11
30	icekit_plugins_image	0015_auto_20170310_2004	2018-01-03 09:56:16.548136+11
31	icekit_plugins_image	0016_auto_20170314_1306	2018-01-03 09:56:16.608317+11
32	icekit_plugins_image	0017_auto_20170314_1352	2018-01-03 09:56:16.654271+11
33	icekit_plugins_image	0018_auto_20170314_1401	2018-01-03 09:56:16.671526+11
34	icekit_plugins_image	0016_auto_20170316_2021	2018-01-03 09:56:16.681195+11
35	icekit_plugins_image	0019_merge	2018-01-03 09:56:16.689857+11
36	icekit_plugins_image	0020_auto_20170317_1655	2018-01-03 09:56:16.728098+11
37	icekit_plugins_image	0011_auto_20170310_1220	2018-01-03 09:56:16.908181+11
38	icekit_plugins_image	0021_merge	2018-01-03 09:56:17.155318+11
39	icekit_plugins_image	0022_auto_20170622_1024	2018-01-03 09:56:17.30173+11
40	icekit_plugins_location	0002_auto_20170724_1019	2018-01-03 09:56:17.678886+11
41	icekit_plugins_location	0003_locationitem	2018-01-03 09:56:17.883479+11
42	icekit_plugins_location	0004_auto_20170905_1129	2018-01-03 09:56:18.037804+11
43	icekit_plugins_location	0005_auto_20170905_1136	2018-01-03 09:56:18.461355+11
44	contenttypes	0002_remove_content_type_name	2018-01-03 09:56:19.030008+11
45	icekit_events	0001_initial	2018-01-03 09:56:19.694777+11
46	icekit_events	0002_recurrence_rules	2018-01-03 09:56:19.772412+11
47	icekit_events	0003_auto_20161021_1658	2018-01-03 09:56:19.94782+11
48	icekit_events	0004_eventbase_part_of	2018-01-03 09:56:20.170454+11
49	icekit_events	0005_auto_20161024_1742	2018-01-03 09:56:20.525288+11
50	icekit_events	0006_auto_20161107_1747	2018-01-03 09:56:20.96256+11
51	icekit_events	0007_type_fixtures	2018-01-03 09:56:21.038491+11
52	icekit_events	0008_occurrence_external_ref	2018-01-03 09:56:21.162465+11
53	icekit_events	0009_auto_20161125_1538	2018-01-03 09:56:21.476272+11
54	icekit_events	0010_eventbase_is_drop_in	2018-01-03 09:56:21.700141+11
55	icekit_events	0011_auto_20161128_1049	2018-01-03 09:56:22.397992+11
56	icekit_events	0012_occurrence_status	2018-01-03 09:56:22.529834+11
57	icekit_events	0012_eventtype_title_plural	2018-01-03 09:56:22.667539+11
58	icekit_events	0013_merge	2018-01-03 09:56:22.673922+11
59	icekit_events	0014_eventbase_human_times	2018-01-03 09:56:22.894394+11
60	icekit_events	0015_auto_20161208_0029	2018-01-03 09:56:23.073803+11
61	icekit_events	0016_auto_20161208_0030	2018-01-03 09:56:23.189552+11
62	icekit_events	0017_eventtype_color	2018-01-03 09:56:23.339847+11
63	icekit_events	0018_auto_20170307_1458	2018-01-03 09:56:23.541242+11
64	icekit_events	0019_auto_20170310_1220	2018-01-03 09:56:23.98736+11
65	icekit_events	0020_auto_20170317_1341	2018-01-03 09:56:24.21449+11
66	icekit_events	0018_auto_20170314_1401	2018-01-03 09:56:24.397118+11
67	icekit_events	0021_merge	2018-01-03 09:56:24.409625+11
68	icekit_events	0022_auto_20170320_1807	2018-01-03 09:56:24.722184+11
69	icekit_events	0023_auto_20170320_1820	2018-01-03 09:56:25.04607+11
70	icekit_events	0024_auto_20170320_1824	2018-01-03 09:56:25.208706+11
71	icekit_events	0025_auto_20170519_1327	2018-01-03 09:56:25.476893+11
72	icekit_events	0026_eventbase_location	2018-01-03 09:56:25.681132+11
73	icekit_events	0027_auto_20170721_1613	2018-01-03 09:56:25.891036+11
74	icekit_events	0028_eventbase_price_detailed	2018-01-03 09:56:26.018828+11
75	icekit_events	0029_fix_malformed_rrules_20170830_1101	2018-01-03 09:56:26.055108+11
76	sites	0001_initial	2018-01-03 09:56:26.126112+11
77	fluent_pages	0001_initial	2018-01-03 09:56:27.299646+11
78	advancedeventlisting	0001_initial	2018-01-03 09:56:27.530675+11
79	advancedeventlisting	0002_advancedeventlistingpage_tags	2018-01-03 09:56:27.753475+11
80	auth	0002_alter_permission_name_max_length	2018-01-03 09:56:27.998754+11
81	auth	0003_alter_user_email_max_length	2018-01-03 09:56:28.175186+11
82	auth	0004_alter_user_username_opts	2018-01-03 09:56:28.378905+11
83	auth	0005_alter_user_last_login_null	2018-01-03 09:56:28.664486+11
84	auth	0006_require_contenttypes_0002	2018-01-03 09:56:28.670871+11
85	authtoken	0001_initial	2018-01-03 09:56:28.865928+11
86	authtoken	0002_auto_20160226_1747	2018-01-03 09:56:29.72777+11
87	glamkit_collections	0001_initial	2018-01-03 09:56:29.866156+11
88	glamkit_collections	0002_auto_20170412_1520	2018-01-03 09:56:30.633219+11
89	glamkit_collections	0003_auto_20170412_1742	2018-01-03 09:56:30.738731+11
90	gk_collections_work_creator	0001_initial	2018-01-03 09:56:33.500584+11
91	gk_collections_work_creator	0002_workbase_department	2018-01-03 09:56:33.883771+11
92	gk_collections_work_creator	0003_auto_20161026_1606	2018-01-03 09:56:34.487319+11
93	gk_collections_work_creator	0004_auto_20161026_1828	2018-01-03 09:56:36.81285+11
94	gk_collections_work_creator	0005_workbase_images	2018-01-03 09:56:37.133779+11
95	gk_collections_work_creator	0006_auto_20161026_2259	2018-01-03 09:56:37.861008+11
96	gk_collections_work_creator	0007_auto_20161028_1904	2018-01-03 09:56:38.264277+11
97	gk_collections_work_creator	0008_auto_20161114_1240	2018-01-03 09:56:39.021368+11
98	gk_collections_work_creator	0009_auto_20161117_1757	2018-01-03 09:56:39.401454+11
99	gk_collections_work_creator	0010_auto_20161128_1049	2018-01-03 09:56:40.554818+11
100	gk_collections_work_creator	0011_role_title_plural	2018-01-03 09:56:40.974693+11
101	gk_collections_work_creator	0012_auto_20170412_1744	2018-01-03 09:56:41.478355+11
102	gk_collections_work_creator	0013_auto_20170412_1724	2018-01-03 09:56:41.553359+11
103	gk_collections_work_creator	0014_auto_20170412_1745	2018-01-03 09:56:44.340755+11
104	gk_collections_work_creator	0015_auto_20170412_1816	2018-01-03 09:56:44.698603+11
105	gk_collections_work_creator	0016_auto_20170412_2338	2018-01-03 09:56:45.1297+11
106	gk_collections_work_creator	0017_workbase_origin_locations	2018-01-03 09:56:45.596612+11
107	gk_collections_work_creator	0018_workbase_external_ref	2018-01-03 09:56:46.650396+11
108	gk_collections_work_creator	0019_auto_20170515_2004	2018-01-03 09:56:47.080071+11
109	gk_collections_work_creator	0020_auto_20170518_2017	2018-01-03 09:56:49.305352+11
110	gk_collections_work_creator	0021_auto_20170518_2023	2018-01-03 09:56:52.717783+11
111	gk_collections_work_creator	0022_auto_20170518_2034	2018-01-03 09:56:57.532454+11
112	gk_collections_work_creator	0023_auto_20170522_1508	2018-01-03 09:56:58.805705+11
113	gk_collections_work_creator	0024_auto_20170502_2209	2018-01-03 09:56:59.550273+11
114	gk_collections_work_creator	0025_creatorbase_name_full	2018-01-03 09:56:59.966603+11
115	gk_collections_work_creator	0026_auto_20170516_1518	2018-01-03 09:57:02.477499+11
116	gk_collections_work_creator	0027_auto_20170518_1611	2018-01-03 09:57:02.914697+11
117	gk_collections_work_creator	0028_auto_20170523_1141	2018-01-03 09:57:03.295188+11
118	gk_collections_work_creator	0029_auto_20170523_1149	2018-01-03 09:57:04.085607+11
119	gk_collections_work_creator	0030_auto_20170523_1243	2018-01-03 09:57:07.025328+11
120	gk_collections_work_creator	0031_auto_20170606_1126	2018-01-03 09:57:23.983002+11
121	gk_collections_work_creator	0032_tidy_names	2018-01-03 09:57:24.066888+11
122	gk_collections_work_creator	0033_auto_20170615_2002	2018-01-03 09:57:24.872457+11
123	icekit_events	0030_auto_20171002_1551	2018-01-03 09:57:25.158475+11
124	biennale_of_sydney	0001_initial	2018-01-03 09:57:29.936145+11
125	biennale_of_sydney	0002_auto_20180102_1636	2018-01-03 09:57:30.619634+11
126	djcelery	0001_initial	2018-01-03 09:57:31.006019+11
127	easy_thumbnails	0001_initial	2018-01-03 09:57:31.234479+11
128	easy_thumbnails	0002_thumbnaildimensions	2018-01-03 09:57:31.315835+11
129	eventlistingfordate	0001_initial	2018-01-03 09:57:31.672073+11
130	eventlistingfordate	0002_auto_20161018_1113	2018-01-03 09:57:32.027871+11
131	eventlistingfordate	0003_auto_20161019_1906	2018-01-03 09:57:32.349902+11
132	eventlistingfordate	0004_auto_20161115_1118	2018-01-03 09:57:33.389985+11
133	eventlistingfordate	0005_auto_20161130_1109	2018-01-03 09:57:33.775983+11
134	eventlistingfordate	0006_auto_20170519_1345	2018-01-03 09:57:34.491369+11
135	eventlistingfordate	0007_eventlistingpage_tags	2018-01-03 09:57:34.824905+11
136	fluent_pages	0002_add_htmlpage_meta_image	2018-01-03 09:57:35.206495+11
137	fluent_pages	0003_set_htmlpage_defaults	2018-01-03 09:57:35.256451+11
138	fluent_pages	0004_add_htmlpage_not_null	2018-01-03 09:57:36.770467+11
139	fluent_pages	0005_urlnode_tags	2018-01-03 09:57:37.353228+11
140	fluentpage	0001_initial	2018-01-03 09:57:37.764508+11
141	forms	0001_initial	2018-01-03 09:57:39.29945+11
142	forms	0002_auto_20160418_0120	2018-01-03 09:57:39.735096+11
143	gk_collections_artwork	0001_initial	2018-01-03 09:57:40.139355+11
144	gk_collections_artwork	0002_remove_artwork_department	2018-01-03 09:57:40.147231+11
145	gk_collections_moving_image	0001_initial	2018-01-03 09:57:40.280041+11
146	gk_collections_moving_image	0002_auto_20161026_1312	2018-01-03 09:57:41.125849+11
147	gk_collections_moving_image	0003_movingimagework_trailer	2018-01-03 09:57:41.601652+11
148	gk_collections_moving_image	0004_auto_20161110_1419	2018-01-03 09:57:42.45188+11
149	gk_collections_moving_image	0005_auto_20161117_1801	2018-01-03 09:57:43.393035+11
150	gk_collections_film	0001_initial	2018-01-03 09:57:45.780686+11
151	gk_collections_film	0002_film_trailer	2018-01-03 09:57:46.300044+11
152	gk_collections_film	0003_auto_20161117_1801	2018-01-03 09:57:47.776126+11
153	gk_collections_film	0004_auto_20161130_1109	2018-01-03 09:57:48.88993+11
154	gk_collections_game	0001_initial	2018-01-03 09:57:51.691914+11
155	gk_collections_game	0002_game_trailer	2018-01-03 09:57:52.379572+11
156	gk_collections_game	0003_auto_20161117_1801	2018-01-03 09:57:54.656348+11
157	gk_collections_game	0004_auto_20161130_1109	2018-01-03 09:57:56.015508+11
158	gk_collections_links	0001_initial	2018-01-03 09:57:57.462603+11
159	gk_collections_links	0002_auto_20161117_1810	2018-01-03 09:57:58.830336+11
160	gk_collections_links	0003_auto_20171226_1745	2018-01-03 09:58:00.204308+11
161	gk_collections_moving_image	0006_auto_20161130_1142	2018-01-03 09:58:02.279597+11
162	gk_collections_organization	0001_initial	2018-01-03 09:58:02.990465+11
163	gk_collections_person	0001_initial	2018-01-03 09:58:03.723036+11
164	gk_collections_person	0002_remove_personcreator_name_full	2018-01-03 09:58:03.732965+11
165	gk_collections_person	0003_auto_20170606_1158	2018-01-03 09:58:08.770459+11
166	gk_collections_work_creator	0034_personcreator	2018-01-03 09:58:09.510886+11
167	glamkit_collections	0004_geographiclocation_slug	2018-01-03 09:58:10.278621+11
168	glamkit_sponsors	0001_initial	2018-01-03 09:58:11.010697+11
169	glamkit_sponsors	0002_beginsponsorblockitem_endsponsorblockitem_sponsorpromoitem	2018-01-03 09:58:13.288478+11
170	glamkit_sponsors	0003_sponsor_tags	2018-01-03 09:58:14.256652+11
171	icekit_article	0001_initial	2018-01-03 09:58:23.585832+11
172	icekit_article	0002_auto_20161019_1906	2018-01-03 09:58:24.148934+11
173	icekit_article	0003_auto_20161110_1125	2018-01-03 09:58:25.869404+11
174	icekit_article	0004_article_hero_image	2018-01-03 09:58:26.517742+11
175	icekit_article	0005_add_hero	2018-01-03 09:58:28.64968+11
176	icekit_article	0006_auto_20161117_1800	2018-01-03 09:58:29.949163+11
177	icekit_article	0007_auto_20161130_1109	2018-01-03 09:58:31.187703+11
178	icekit_article	0008_auto_20170518_1629	2018-01-03 09:58:33.62344+11
179	icekit_article	0009_auto_20171226_1745	2018-01-03 09:58:34.811768+11
180	icekit_authors	0001_initial	2018-01-03 09:58:36.524144+11
181	icekit_authors	0002_auto_20161011_1522	2018-01-03 09:58:37.869677+11
182	icekit_authors	0003_auto_20161115_1118	2018-01-03 09:58:39.788408+11
183	icekit_authors	0004_auto_20161117_1201	2018-01-03 09:58:41.038352+11
184	icekit_authors	0005_auto_20161117_1824	2018-01-03 09:58:41.660884+11
185	icekit_authors	0006_auto_20161117_1825	2018-01-03 09:58:42.316946+11
186	icekit_authors	0007_auto_20161125_1720	2018-01-03 09:58:44.036245+11
187	icekit_authors	0008_auto_20161128_1049	2018-01-03 09:58:45.566594+11
188	icekit_authors	0009_auto_20170317_1655	2018-01-03 09:58:47.117233+11
189	icekit_authors	0010_auto_20170317_1656	2018-01-03 09:58:47.967083+11
190	icekit_authors	0011_auto_20170518_1629	2018-01-03 09:58:51.782813+11
191	icekit_authors	0012_authorlisting_tags	2018-01-03 09:58:52.72107+11
192	icekit_event_types_simple	0001_initial	2018-01-03 09:58:53.665831+11
283	ik_links	0001_initial	2018-01-03 10:02:36.436161+11
193	icekit_event_types_simple	0002_simpleevent_layout	2018-01-03 09:58:54.517144+11
194	icekit_event_types_simple	0003_auto_20161125_1701	2018-01-03 09:58:55.295136+11
195	icekit_event_types_simple	0004_auto_20170727_1403	2018-01-03 09:58:59.082493+11
196	icekit_event_types_simple	0005_simpleevent_tags	2018-01-03 09:59:00.145437+11
197	icekit_events_links	0001_initial	2018-01-03 09:59:01.27004+11
198	icekit_events_links	0002_auto_20170314_1401	2018-01-03 09:59:03.082569+11
199	icekit_events_links	0003_auto_20170511_1909	2018-01-03 09:59:04.193038+11
200	icekit_events_links	0004_eventlink_include_even_when_finished	2018-01-03 09:59:06.198284+11
201	icekit_navigation	0001_initial	2018-01-03 09:59:08.68801+11
202	icekit_plugins_child_pages	0001_initial	2018-01-03 09:59:09.704082+11
203	icekit_plugins_child_pages	0002_auto_20160821_2140	2018-01-03 09:59:10.771971+11
204	icekit_plugins_child_pages	0003_auto_20161123_1827	2018-01-03 09:59:12.025075+11
205	icekit_plugins_contact_person	0001_initial	2018-01-03 09:59:14.018004+11
206	icekit_plugins_contact_person	0002_auto_20161110_1531	2018-01-03 09:59:15.674886+11
207	icekit_plugins_contact_person	0003_auto_20170605_1109	2018-01-03 09:59:20.385922+11
208	icekit_plugins_content_listing	0001_initial	2018-01-03 09:59:21.701268+11
209	icekit_plugins_content_listing	0002_contentlistingitem_limit	2018-01-03 09:59:23.926521+11
210	icekit_plugins_content_listing	0003_contentlistingitem_no_items_message	2018-01-03 09:59:25.803046+11
211	icekit_plugins_faq	0001_initial	2018-01-03 09:59:27.85087+11
212	icekit_plugins_faq	0002_auto_20151013_1330	2018-01-03 09:59:31.02496+11
213	icekit_plugins_faq	0003_auto_20160821_2140	2018-01-03 09:59:33.627723+11
214	icekit_plugins_file	0001_initial	2018-01-03 09:59:36.022705+11
215	icekit_plugins_file	0002_auto_20160821_2140	2018-01-03 09:59:41.459025+11
216	icekit_plugins_file	0003_file_tags	2018-01-03 09:59:59.90849+11
217	icekit_plugins_horizontal_rule	0001_initial	2018-01-03 10:00:00.720909+11
218	icekit_plugins_horizontal_rule	0002_auto_20160821_2140	2018-01-03 10:00:01.473245+11
219	icekit_plugins_image	0023_image_tags	2018-01-03 10:00:02.210265+11
220	icekit_plugins_instagram_embed	0001_initial	2018-01-03 10:00:03.122304+11
221	icekit_plugins_instagram_embed	0002_auto_20150723_1939	2018-01-03 10:00:04.178071+11
222	icekit_plugins_instagram_embed	0003_auto_20150724_0213	2018-01-03 10:00:08.044266+11
223	icekit_plugins_instagram_embed	0004_auto_20160821_2140	2018-01-03 10:00:08.897732+11
224	icekit_plugins_location	0006_auto_20171005_1525	2018-01-03 10:00:10.595296+11
225	icekit_plugins_location	0007_auto_20171005_1708	2018-01-03 10:00:28.67875+11
226	icekit_plugins_map	0001_initial	2018-01-03 10:00:30.471226+11
227	icekit_plugins_map	0002_auto_20160821_2140	2018-01-03 10:00:33.155779+11
228	icekit_plugins_map	0003_auto_20170531_1359	2018-01-03 10:00:37.444643+11
229	icekit_plugins_map	0004_auto_20170604_2148	2018-01-03 10:00:39.336048+11
230	icekit_plugins_oembed_with_caption	0001_initial	2018-01-03 10:00:40.942819+11
231	icekit_plugins_oembed_with_caption	0002_auto_20160821_2140	2018-01-03 10:00:42.536965+11
232	icekit_plugins_oembed_with_caption	0003_oembedwithcaptionitem_is_16by9	2018-01-03 10:00:44.277767+11
233	icekit_plugins_oembed_with_caption	0004_auto_20160919_2008	2018-01-03 10:00:45.286441+11
234	icekit_plugins_oembed_with_caption	0005_auto_20161027_1711	2018-01-03 10:00:46.226778+11
235	icekit_plugins_oembed_with_caption	0006_auto_20161027_2330	2018-01-03 10:00:48.428392+11
236	icekit_plugins_oembed_with_caption	0007_auto_20161110_1513	2018-01-03 10:00:49.440613+11
237	icekit_plugins_oembed_with_caption	0008_oembedwithcaptionitem_content_title	2018-01-03 10:00:50.37378+11
238	icekit_plugins_page_anchor	0001_initial	2018-01-03 10:00:51.306619+11
239	icekit_plugins_page_anchor	0002_auto_20160821_2140	2018-01-03 10:00:52.47672+11
240	icekit_plugins_page_anchor	0003_auto_20161125_1538	2018-01-03 10:00:53.977683+11
241	icekit_plugins_page_anchor	0004_auto_20161130_0741	2018-01-03 10:00:55.674774+11
242	icekit_plugins_page_anchor_list	0001_initial	2018-01-03 10:00:57.711+11
243	icekit_plugins_page_anchor_list	0002_auto_20160821_2140	2018-01-03 10:00:59.438092+11
244	icekit_plugins_quote	0001_initial	2018-01-03 10:01:01.074112+11
245	icekit_plugins_quote	0002_auto_20160821_2140	2018-01-03 10:01:02.602806+11
246	icekit_plugins_quote	0003_auto_20160912_2218	2018-01-03 10:01:05.548861+11
247	icekit_plugins_quote	0004_auto_20161027_1717	2018-01-03 10:01:09.372601+11
248	icekit_plugins_reusable_form	0001_initial	2018-01-03 10:01:11.247678+11
249	icekit_plugins_reusable_form	0002_auto_20160821_2140	2018-01-03 10:01:12.273086+11
250	icekit_plugins_slideshow	0001_initial	2018-01-03 10:01:13.586772+11
251	icekit_plugins_slideshow	0002_auto_20150623_0115	2018-01-03 10:01:15.011221+11
252	icekit_plugins_slideshow	0003_auto_20160404_0118	2018-01-03 10:01:20.105317+11
253	icekit_plugins_slideshow	0004_auto_20160821_2140	2018-01-03 10:01:22.654394+11
254	icekit_plugins_slideshow	0005_auto_20160927_2305	2018-01-03 10:01:24.798986+11
255	icekit_plugins_slideshow	0006_auto_20170518_1629	2018-01-03 10:01:28.099637+11
256	icekit_plugins_slideshow	0007_slideshow_tags	2018-01-03 10:01:29.838862+11
257	icekit_plugins_twitter_embed	0001_initial	2018-01-03 10:01:31.696196+11
258	icekit_plugins_twitter_embed	0002_auto_20150724_0213	2018-01-03 10:01:34.848709+11
259	icekit_plugins_twitter_embed	0003_auto_20160821_2140	2018-01-03 10:01:46.982328+11
260	icekit_press_releases	0001_initial	2018-01-03 10:01:51.351576+11
261	icekit_press_releases	0002_auto_20160810_1832	2018-01-03 10:01:54.608535+11
262	icekit_press_releases	0003_auto_20160810_1856	2018-01-03 10:01:57.747949+11
263	icekit_press_releases	0004_auto_20160926_2341	2018-01-03 10:01:58.872079+11
264	icekit_press_releases	0005_auto_20161110_1531	2018-01-03 10:02:02.688603+11
265	icekit_press_releases	0006_auto_20161115_1118	2018-01-03 10:02:05.890944+11
266	icekit_press_releases	0007_auto_20161117_1201	2018-01-03 10:02:08.010763+11
267	icekit_press_releases	0008_auto_20161128_1049	2018-01-03 10:02:09.054211+11
268	icekit_press_releases	0009_auto_20170519_1308	2018-01-03 10:02:11.060861+11
269	icekit_press_releases	0010_add_brief	2018-01-03 10:02:13.003733+11
270	icekit_press_releases	0011_auto_20171226_1745	2018-01-03 10:02:14.942594+11
271	icekit_workflow	0001_initial	2018-01-03 10:02:15.958022+11
272	icekit_workflow	0002_auto_20161128_1105	2018-01-03 10:02:17.009191+11
273	icekit_workflow	0003_auto_20161130_0741	2018-01-03 10:02:17.94987+11
274	icekit_workflow	0004_auto_20170130_1146	2018-01-03 10:02:19.053297+11
275	icekit_workflow	0005_auto_20170208_1146	2018-01-03 10:02:20.109115+11
276	icekit_workflow	0006_auto_20170308_2044	2018-01-03 10:02:22.092036+11
277	iframe	0001_initial	2018-01-03 10:02:23.068523+11
278	ik_event_listing	0001_initial	2018-01-03 10:02:24.158192+11
279	ik_event_listing	0002_auto_20170222_1136	2018-01-03 10:02:29.141628+11
280	ik_event_listing	0003_eventcontentlistingitem_no_items_message	2018-01-03 10:02:30.183268+11
281	ik_events_todays_occurrences	0001_initial	2018-01-03 10:02:31.246731+11
282	ik_events_todays_occurrences	0002_auto_20161207_1928	2018-01-03 10:02:33.31187+11
284	ik_links	0002_auto_20161117_1221	2018-01-03 10:02:39.654333+11
285	ik_links	0003_auto_20161117_1810	2018-01-03 10:02:42.933613+11
286	ik_links	0004_auto_20170314_1401	2018-01-03 10:02:46.126869+11
287	ik_links	0004_auto_20170306_1529	2018-01-03 10:02:49.486174+11
288	ik_links	0005_auto_20170511_1909	2018-01-03 10:02:56.287208+11
289	ik_links	0006_authorlink_exclude_from_contributions	2018-01-03 10:02:57.262859+11
290	ik_links	0007_authorlink_exclude_from_authorship	2018-01-03 10:02:58.199165+11
291	image_gallery	0001_initial	2018-01-03 10:02:59.198709+11
292	image_gallery	0002_auto_20160927_2305	2018-01-03 10:03:00.151198+11
293	kombu_transport_django	0001_initial	2018-01-03 10:03:00.43121+11
294	layout_page	0001_initial	2018-01-03 10:03:01.520261+11
295	layout_page	0002_auto_20160419_2209	2018-01-03 10:03:05.572974+11
296	layout_page	0003_auto_20160810_1856	2018-01-03 10:03:06.56355+11
297	layout_page	0004_auto_20161110_1737	2018-01-03 10:03:09.974106+11
298	layout_page	0005_auto_20161125_1709	2018-01-03 10:03:10.996912+11
299	layout_page	0006_auto_20161130_1109	2018-01-03 10:03:12.18929+11
300	layout_page	0007_auto_20170509_1148	2018-01-03 10:03:13.192525+11
301	layout_page	0008_auto_20170518_1629	2018-01-03 10:03:15.226549+11
302	layout_page	0009_layoutpage_tags	2018-01-03 10:03:16.315244+11
303	media_coverage	0001_initial	2018-01-03 10:03:17.331383+11
304	media_coverage	0002_auto_20171127_1607	2018-01-03 10:03:18.409618+11
305	media_coverage	0003_mediacoveragelist	2018-01-03 10:03:19.400789+11
306	media_coverage	0004_auto_20171210_0708	2018-01-03 10:03:22.81656+11
307	model_settings	0001_initial	2018-01-03 10:03:26.026144+11
308	model_settings	0002_auto_20150810_1620	2018-01-03 10:03:27.169055+11
309	notifications	0001_initial	2018-01-03 10:03:34.522016+11
310	notifications	0002_auto_20150901_2126	2018-01-03 10:03:37.017508+11
311	oembeditem	0001_initial	2018-01-03 10:03:38.284231+11
312	polymorphic_auth	0002_auto_20160725_2124	2018-01-03 10:03:40.981101+11
313	polymorphic_auth_email	0001_initial	2018-01-03 10:03:42.24765+11
314	post_office	0001_initial	2018-01-03 10:03:42.81189+11
315	post_office	0002_add_i18n_and_backend_alias	2018-01-03 10:03:44.670695+11
316	post_office	0003_longer_subject	2018-01-03 10:03:45.016283+11
317	post_office	0004_auto_20160607_0901	2018-01-03 10:03:51.489345+11
318	post_office	0005_auto_20170515_0013	2018-01-03 10:03:51.668108+11
319	post_office	0006_attachment_mimetype	2018-01-03 10:03:51.819472+11
320	rawhtml	0001_initial	2018-01-03 10:03:52.860237+11
321	redirectnode	0001_initial	2018-01-03 10:03:56.547677+11
322	redirects	0001_initial	2018-01-03 10:03:57.858757+11
323	response_pages	0001_initial	2018-01-03 10:03:58.000469+11
324	reversion	0001_initial	2018-01-03 10:04:00.68547+11
325	reversion	0002_auto_20141216_1509	2018-01-03 10:04:01.977199+11
326	search_page	0001_initial	2018-01-03 10:04:03.283807+11
327	search_page	0002_auto_20160420_0029	2018-01-03 10:04:08.433921+11
328	search_page	0003_auto_20160810_1856	2018-01-03 10:04:09.6574+11
329	search_page	0004_auto_20161122_2121	2018-01-03 10:04:12.210226+11
330	search_page	0005_auto_20161125_1720	2018-01-03 10:04:14.936981+11
331	search_page	0006_searchpage_default_search_type	2018-01-03 10:04:16.327651+11
332	search_page	0007_auto_20170518_1629	2018-01-03 10:04:18.915259+11
333	search_page	0008_searchpage_tags	2018-01-03 10:04:20.318147+11
334	sessions	0001_initial	2018-01-03 10:04:20.429231+11
335	sharedcontent	0001_initial	2018-01-03 10:04:27.215734+11
336	staff_profile_list	0001_initial	2018-01-03 10:04:28.569996+11
337	staff_profiles	0001_initial	2018-01-03 10:04:30.051834+11
338	staff_profiles	0002_auto_20171123_1655	2018-01-03 10:04:31.553959+11
339	staff_profiles	0003_auto_20171127_1253	2018-01-03 10:04:32.987073+11
340	tests	0001_initial	2018-01-03 10:04:37.60261+11
341	tests	0002_unpublishablelayoutpage	2018-01-03 10:04:39.100738+11
342	tests	0003_auto_20160810_2054	2018-01-03 10:04:42.1247+11
343	tests	0004_auto_20160925_0758	2018-01-03 10:04:45.348672+11
344	tests	0005_auto_20161027_1428	2018-01-03 10:04:45.897757+11
345	tests	0006_auto_20161115_1219	2018-01-03 10:04:59.370455+11
346	tests	0007_auto_20161118_1044	2018-01-03 10:05:02.207015+11
347	tests	0008_auto_20161204_1456	2018-01-03 10:05:06.683936+11
348	tests	0009_auto_20170519_1232	2018-01-03 10:05:12.702559+11
349	tests	0010_auto_20170522_1600	2018-01-03 10:05:15.983136+11
350	text	0001_initial	2018-01-03 10:05:17.464077+11
351	text	0002_textitem_style	2018-01-03 10:05:18.9608+11
352	textfile	0001_initial	2018-01-03 10:05:20.474486+11
353	textfile	0002_add_translation_model	2018-01-03 10:05:23.344059+11
354	textfile	0003_migrate_translatable_fields	2018-01-03 10:05:23.41145+11
355	textfile	0004_remove_untranslated_fields	2018-01-03 10:05:24.915063+11
\.


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_migrations_id_seq', 355, true);


--
-- Data for Name: django_redirect; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_redirect (id, site_id, old_path, new_path) FROM stdin;
\.


--
-- Name: django_redirect_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_redirect_id_seq', 1, false);


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_site (id, domain, name) FROM stdin;
1	biennale-of-sydney.lvh.me	biennale-of-sydney
\.


--
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_site_id_seq', 1, true);


--
-- Data for Name: djcelery_crontabschedule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY djcelery_crontabschedule (id, minute, hour, day_of_week, day_of_month, month_of_year) FROM stdin;
\.


--
-- Name: djcelery_crontabschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('djcelery_crontabschedule_id_seq', 1, false);


--
-- Data for Name: djcelery_intervalschedule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY djcelery_intervalschedule (id, every, period) FROM stdin;
\.


--
-- Name: djcelery_intervalschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('djcelery_intervalschedule_id_seq', 1, false);


--
-- Data for Name: djcelery_periodictask; Type: TABLE DATA; Schema: public; Owner: -
--

COPY djcelery_periodictask (id, name, task, args, kwargs, queue, exchange, routing_key, expires, enabled, last_run_at, total_run_count, date_changed, description, crontab_id, interval_id) FROM stdin;
\.


--
-- Name: djcelery_periodictask_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('djcelery_periodictask_id_seq', 1, false);


--
-- Data for Name: djcelery_periodictasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY djcelery_periodictasks (ident, last_update) FROM stdin;
\.


--
-- Data for Name: djcelery_taskstate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY djcelery_taskstate (id, state, task_id, name, tstamp, args, kwargs, eta, expires, result, traceback, runtime, retries, hidden, worker_id) FROM stdin;
\.


--
-- Name: djcelery_taskstate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('djcelery_taskstate_id_seq', 1, false);


--
-- Data for Name: djcelery_workerstate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY djcelery_workerstate (id, hostname, last_heartbeat) FROM stdin;
\.


--
-- Name: djcelery_workerstate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('djcelery_workerstate_id_seq', 1, false);


--
-- Data for Name: djkombu_message; Type: TABLE DATA; Schema: public; Owner: -
--

COPY djkombu_message (id, visible, sent_at, payload, queue_id) FROM stdin;
\.


--
-- Name: djkombu_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('djkombu_message_id_seq', 1, false);


--
-- Data for Name: djkombu_queue; Type: TABLE DATA; Schema: public; Owner: -
--

COPY djkombu_queue (id, name) FROM stdin;
\.


--
-- Name: djkombu_queue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('djkombu_queue_id_seq', 1, false);


--
-- Data for Name: easy_thumbnails_source; Type: TABLE DATA; Schema: public; Owner: -
--

COPY easy_thumbnails_source (id, storage_hash, name, modified) FROM stdin;
\.


--
-- Name: easy_thumbnails_source_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('easy_thumbnails_source_id_seq', 1, false);


--
-- Data for Name: easy_thumbnails_thumbnail; Type: TABLE DATA; Schema: public; Owner: -
--

COPY easy_thumbnails_thumbnail (id, storage_hash, name, modified, source_id) FROM stdin;
\.


--
-- Name: easy_thumbnails_thumbnail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('easy_thumbnails_thumbnail_id_seq', 1, false);


--
-- Data for Name: easy_thumbnails_thumbnaildimensions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY easy_thumbnails_thumbnaildimensions (id, thumbnail_id, width, height) FROM stdin;
\.


--
-- Name: easy_thumbnails_thumbnaildimensions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('easy_thumbnails_thumbnaildimensions_id_seq', 1, false);


--
-- Name: file_file_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('file_file_categories_id_seq', 1, false);


--
-- Name: file_file_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('file_file_id_seq', 1, false);


--
-- Data for Name: fluent_contents_contentitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_contents_contentitem (id, parent_id, language_code, sort_order, parent_type_id, placeholder_id, polymorphic_ctype_id) FROM stdin;
\.


--
-- Name: fluent_contents_contentitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_contents_contentitem_id_seq', 1, false);


--
-- Data for Name: fluent_contents_placeholder; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_contents_placeholder (id, slot, role, parent_id, title, parent_type_id) FROM stdin;
\.


--
-- Name: fluent_contents_placeholder_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_contents_placeholder_id_seq', 1, false);


--
-- Data for Name: fluent_pages_htmlpage_translation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_pages_htmlpage_translation (id, language_code, meta_keywords, meta_description, meta_title, master_id, meta_image) FROM stdin;
\.


--
-- Name: fluent_pages_htmlpage_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_pages_htmlpage_translation_id_seq', 1, false);


--
-- Data for Name: fluent_pages_pagelayout; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_pages_pagelayout (id, key, title, template_path) FROM stdin;
\.


--
-- Name: fluent_pages_pagelayout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_pages_pagelayout_id_seq', 1, false);


--
-- Data for Name: fluent_pages_urlnode; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_pages_urlnode (id, lft, rght, tree_id, level, status, publication_date, publication_end_date, in_navigation, in_sitemaps, key, creation_date, modification_date, author_id, parent_id, parent_site_id, polymorphic_ctype_id) FROM stdin;
\.


--
-- Name: fluent_pages_urlnode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_pages_urlnode_id_seq', 1, false);


--
-- Data for Name: fluent_pages_urlnode_translation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_pages_urlnode_translation (id, language_code, title, slug, override_url, _cached_url, master_id) FROM stdin;
\.


--
-- Name: fluent_pages_urlnode_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_pages_urlnode_translation_id_seq', 1, false);


--
-- Data for Name: forms_field; Type: TABLE DATA; Schema: public; Owner: -
--

COPY forms_field (id, label, slug, field_type, required, visible, choices, "default", placeholder_text, help_text, "order", form_id) FROM stdin;
\.


--
-- Name: forms_field_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('forms_field_id_seq', 1, false);


--
-- Data for Name: forms_fieldentry; Type: TABLE DATA; Schema: public; Owner: -
--

COPY forms_fieldentry (id, field_id, value, entry_id) FROM stdin;
\.


--
-- Name: forms_fieldentry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('forms_fieldentry_id_seq', 1, false);


--
-- Data for Name: forms_form; Type: TABLE DATA; Schema: public; Owner: -
--

COPY forms_form (id, title, slug, intro, button_text, response, redirect_url, status, publish_date, expiry_date, login_required, send_email, email_from, email_copies, email_subject, email_message) FROM stdin;
\.


--
-- Name: forms_form_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('forms_form_id_seq', 1, false);


--
-- Data for Name: forms_form_sites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY forms_form_sites (id, form_id, site_id) FROM stdin;
\.


--
-- Name: forms_form_sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('forms_form_sites_id_seq', 1, false);


--
-- Data for Name: forms_formentry; Type: TABLE DATA; Schema: public; Owner: -
--

COPY forms_formentry (id, entry_time, form_id) FROM stdin;
\.


--
-- Name: forms_formentry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('forms_formentry_id_seq', 1, false);


--
-- Data for Name: gk_collections_artwork_artwork; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_artwork_artwork (workbase_ptr_id, medium_display, dimensions_is_two_dimensional, dimensions_display, dimensions_extent, dimensions_width_cm, dimensions_height_cm, dimensions_depth_cm, dimensions_weight_kg) FROM stdin;
\.


--
-- Data for Name: gk_collections_film_film; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_film_film (workbase_ptr_id, rating_annotation, imdb_link, media_type_id, rating_id, trailer, duration_minutes) FROM stdin;
\.


--
-- Data for Name: gk_collections_film_film_formats; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_film_film_formats (id, film_id, format_id) FROM stdin;
\.


--
-- Name: gk_collections_film_film_formats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_film_film_formats_id_seq', 1, false);


--
-- Data for Name: gk_collections_film_film_genres; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_film_film_genres (id, film_id, genre_id) FROM stdin;
\.


--
-- Name: gk_collections_film_film_genres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_film_film_genres_id_seq', 1, false);


--
-- Data for Name: gk_collections_film_format; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_film_format (id, title, slug) FROM stdin;
\.


--
-- Name: gk_collections_film_format_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_film_format_id_seq', 1, false);


--
-- Data for Name: gk_collections_game_game; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_game_game (workbase_ptr_id, rating_annotation, imdb_link, is_single_player, is_multi_player, media_type_id, rating_id, trailer, duration_minutes) FROM stdin;
\.


--
-- Data for Name: gk_collections_game_game_genres; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_game_game_genres (id, game_id, genre_id) FROM stdin;
\.


--
-- Name: gk_collections_game_game_genres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_game_game_genres_id_seq', 1, false);


--
-- Data for Name: gk_collections_game_game_input_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_game_game_input_types (id, game_id, gameinputtype_id) FROM stdin;
\.


--
-- Name: gk_collections_game_game_input_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_game_game_input_types_id_seq', 1, false);


--
-- Data for Name: gk_collections_game_game_platforms; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_game_game_platforms (id, game_id, gameplatform_id) FROM stdin;
\.


--
-- Name: gk_collections_game_game_platforms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_game_game_platforms_id_seq', 1, false);


--
-- Data for Name: gk_collections_game_gameinputtype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_game_gameinputtype (id, title, slug) FROM stdin;
\.


--
-- Name: gk_collections_game_gameinputtype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_game_gameinputtype_id_seq', 1, false);


--
-- Data for Name: gk_collections_game_gameplatform; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_game_gameplatform (id, title, slug) FROM stdin;
\.


--
-- Name: gk_collections_game_gameplatform_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_game_gameplatform_id_seq', 1, false);


--
-- Data for Name: gk_collections_moving_image_genre; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_moving_image_genre (id, title, slug) FROM stdin;
\.


--
-- Name: gk_collections_moving_image_genre_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_moving_image_genre_id_seq', 1, false);


--
-- Data for Name: gk_collections_moving_image_mediatype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_moving_image_mediatype (id, title, slug, title_plural) FROM stdin;
\.


--
-- Name: gk_collections_moving_image_mediatype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_moving_image_mediatype_id_seq', 1, false);


--
-- Data for Name: gk_collections_moving_image_movingimagework; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_moving_image_movingimagework (workbase_ptr_id, rating_annotation, imdb_link, media_type_id, rating_id, trailer, duration_minutes) FROM stdin;
\.


--
-- Data for Name: gk_collections_moving_image_movingimagework_genres; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_moving_image_movingimagework_genres (id, movingimagework_id, genre_id) FROM stdin;
\.


--
-- Name: gk_collections_moving_image_movingimagework_genres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_moving_image_movingimagework_genres_id_seq', 1, false);


--
-- Data for Name: gk_collections_moving_image_rating; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_moving_image_rating (id, title, slug, image) FROM stdin;
\.


--
-- Name: gk_collections_moving_image_rating_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_moving_image_rating_id_seq', 1, false);


--
-- Data for Name: gk_collections_organization_organizationcreator; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_organization_organizationcreator (creatorbase_ptr_id) FROM stdin;
\.


--
-- Data for Name: gk_collections_person_personcreator; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_person_personcreator (creatorbase_ptr_id, name_given, name_family, gender, primary_occupation, birth_place, birth_place_historic, death_place, background_ethnicity, background_nationality, background_neighborhood, background_city, background_state_province, background_country, background_continent) FROM stdin;
\.


--
-- Data for Name: gk_collections_work_creator_creatorbase; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_work_creator_creatorbase (id, list_image, boosted_search_terms, publishing_is_draft, publishing_modified_at, publishing_published_at, name_display, slug, alt_slug, website, wikipedia_link, admin_notes, name_sort, layout_id, polymorphic_ctype_id, portrait_id, publishing_linked_id, name_full, dt_created, dt_modified, external_ref, brief, end_date_display, end_date_earliest, end_date_edtf, end_date_latest, end_date_sort_ascending, end_date_sort_descending, start_date_display, start_date_earliest, start_date_edtf, start_date_latest, start_date_sort_ascending, start_date_sort_descending) FROM stdin;
\.


--
-- Name: gk_collections_work_creator_creatorbase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_work_creator_creatorbase_id_seq', 1, false);


--
-- Data for Name: gk_collections_work_creator_personcreator; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_work_creator_personcreator (creatorbase_ptr_id, name_given, name_family, gender, primary_occupation, birth_place, birth_place_historic, death_place, background_ethnicity, background_nationality, background_neighborhood, background_city, background_state_province, background_country, background_continent) FROM stdin;
\.


--
-- Data for Name: gk_collections_work_creator_role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_work_creator_role (id, title, slug, past_tense, title_plural) FROM stdin;
\.


--
-- Name: gk_collections_work_creator_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_work_creator_role_id_seq', 1, false);


--
-- Data for Name: gk_collections_work_creator_workbase; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_work_creator_workbase (id, list_image, boosted_search_terms, publishing_is_draft, publishing_modified_at, publishing_published_at, slug, alt_slug, title, creation_date_display, credit_line, accession_number, website, wikipedia_link, admin_notes, layout_id, polymorphic_ctype_id, publishing_linked_id, department, oneliner, subtitle, creation_date_earliest, creation_date_latest, creation_date_sort_ascending, creation_date_sort_descending, dt_created, dt_modified, external_ref, brief, creation_date_edtf) FROM stdin;
\.


--
-- Name: gk_collections_work_creator_workbase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_work_creator_workbase_id_seq', 1, false);


--
-- Data for Name: gk_collections_work_creator_workcreator; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_work_creator_workcreator (id, "order", is_primary, creator_id, role_id, work_id) FROM stdin;
\.


--
-- Name: gk_collections_work_creator_workcreator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_work_creator_workcreator_id_seq', 1, false);


--
-- Data for Name: gk_collections_work_creator_workimage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_work_creator_workimage (id, show_title, show_caption, title_override, caption_override, "order", image_id, type_id, work_id) FROM stdin;
\.


--
-- Name: gk_collections_work_creator_workimage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_work_creator_workimage_id_seq', 1, false);


--
-- Data for Name: gk_collections_work_creator_workimagetype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_work_creator_workimagetype (id, title, slug) FROM stdin;
\.


--
-- Name: gk_collections_work_creator_workimagetype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_work_creator_workimagetype_id_seq', 1, false);


--
-- Data for Name: gk_collections_work_creator_workorigin; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_work_creator_workorigin (id, "order", geographic_location_id, work_id) FROM stdin;
\.


--
-- Name: gk_collections_work_creator_workorigin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_work_creator_workorigin_id_seq', 1, false);


--
-- Data for Name: glamkit_collections_country; Type: TABLE DATA; Schema: public; Owner: -
--

COPY glamkit_collections_country (id, title, slug, iso_country, continent) FROM stdin;
1	Afghanistan	afghanistan	AF	AS
2	Åland Islands	aland-islands	AX	EU
3	Albania	albania	AL	EU
4	Algeria	algeria	DZ	AF
5	American Samoa	american-samoa	AS	OC
6	Andorra	andorra	AD	EU
7	Angola	angola	AO	AF
8	Anguilla	anguilla	AI	NA
9	Antarctica	antarctica	AQ	AN
10	Antigua and Barbuda	antigua-and-barbuda	AG	NA
11	Argentina	argentina	AR	SA
12	Armenia	armenia	AM	AS
13	Aruba	aruba	AW	NA
14	Australia	australia	AU	OC
15	Austria	austria	AT	EU
16	Azerbaijan	azerbaijan	AZ	AS
17	Bahamas	bahamas	BS	NA
18	Bahrain	bahrain	BH	AS
19	Bangladesh	bangladesh	BD	AS
20	Barbados	barbados	BB	NA
21	Belarus	belarus	BY	EU
22	Belgium	belgium	BE	EU
23	Belize	belize	BZ	NA
24	Benin	benin	BJ	AF
25	Bermuda	bermuda	BM	NA
26	Bhutan	bhutan	BT	AS
27	Bolivia	bolivia	BO	SA
28	Bonaire, Sint Eustatius and Saba	bonaire-sint-eustatius-and-saba	BQ	\N
29	Bosnia and Herzegovina	bosnia-and-herzegovina	BA	EU
30	Botswana	botswana	BW	AF
31	Bouvet Island	bouvet-island	BV	AN
32	Brazil	brazil	BR	SA
33	British Indian Ocean Territory	british-indian-ocean-territory	IO	AS
34	Brunei	brunei	BN	AS
35	Bulgaria	bulgaria	BG	EU
36	Burkina Faso	burkina-faso	BF	AF
37	Burundi	burundi	BI	AF
38	Cabo Verde	cabo-verde	CV	AF
39	Cambodia	cambodia	KH	AS
40	Cameroon	cameroon	CM	AF
41	Canada	canada	CA	NA
42	Cayman Islands	cayman-islands	KY	NA
43	Central African Republic	central-african-republic	CF	AF
44	Chad	chad	TD	AF
45	Chile	chile	CL	SA
46	China	china	CN	AS
47	Christmas Island	christmas-island	CX	AS
48	Cocos (Keeling) Islands	cocos-keeling-islands	CC	AS
49	Colombia	colombia	CO	SA
50	Comoros	comoros	KM	AF
51	Congo	congo	CG	AF
52	Congo (the Democratic Republic of the)	congo-the-democratic-republic-of-the	CD	AF
53	Cook Islands	cook-islands	CK	OC
54	Costa Rica	costa-rica	CR	NA
55	Côte d'Ivoire	cote-divoire	CI	AF
56	Croatia	croatia	HR	EU
57	Cuba	cuba	CU	NA
58	Curaçao	curacao	CW	\N
59	Cyprus	cyprus	CY	AS
60	Czechia	czechia	CZ	EU
61	Denmark	denmark	DK	EU
62	Djibouti	djibouti	DJ	AF
63	Dominica	dominica	DM	NA
64	Dominican Republic	dominican-republic	DO	NA
65	Ecuador	ecuador	EC	SA
66	Egypt	egypt	EG	AF
67	El Salvador	el-salvador	SV	NA
68	Equatorial Guinea	equatorial-guinea	GQ	AF
69	Eritrea	eritrea	ER	AF
70	Estonia	estonia	EE	EU
71	Ethiopia	ethiopia	ET	AF
72	Falkland Islands  [Malvinas]	falkland-islands-malvinas	FK	SA
73	Faroe Islands	faroe-islands	FO	EU
74	Fiji	fiji	FJ	OC
75	Finland	finland	FI	EU
76	France	france	FR	EU
77	French Guiana	french-guiana	GF	SA
78	French Polynesia	french-polynesia	PF	OC
79	French Southern Territories	french-southern-territories	TF	AN
80	Gabon	gabon	GA	AF
81	Gambia	gambia	GM	AF
82	Georgia	georgia	GE	AS
83	Germany	germany	DE	EU
84	Ghana	ghana	GH	AF
85	Gibraltar	gibraltar	GI	EU
86	Greece	greece	GR	EU
87	Greenland	greenland	GL	NA
88	Grenada	grenada	GD	NA
89	Guadeloupe	guadeloupe	GP	NA
90	Guam	guam	GU	OC
91	Guatemala	guatemala	GT	NA
92	Guernsey	guernsey	GG	EU
93	Guinea	guinea	GN	AF
94	Guinea-Bissau	guinea-bissau	GW	AF
95	Guyana	guyana	GY	SA
96	Haiti	haiti	HT	NA
97	Heard Island and McDonald Islands	heard-island-and-mcdonald-islands	HM	AN
98	Holy See	holy-see	VA	EU
99	Honduras	honduras	HN	NA
100	Hong Kong	hong-kong	HK	AS
101	Hungary	hungary	HU	EU
102	Iceland	iceland	IS	EU
103	India	india	IN	AS
104	Indonesia	indonesia	ID	AS
105	Iran	iran	IR	AS
106	Iraq	iraq	IQ	AS
107	Ireland	ireland	IE	EU
108	Isle of Man	isle-of-man	IM	EU
109	Israel	israel	IL	AS
110	Italy	italy	IT	EU
111	Jamaica	jamaica	JM	NA
112	Japan	japan	JP	AS
113	Jersey	jersey	JE	EU
114	Jordan	jordan	JO	AS
115	Kazakhstan	kazakhstan	KZ	AS
116	Kenya	kenya	KE	AF
117	Kiribati	kiribati	KI	OC
118	Kuwait	kuwait	KW	AS
119	Kyrgyzstan	kyrgyzstan	KG	AS
120	Laos	laos	LA	AS
121	Latvia	latvia	LV	EU
122	Lebanon	lebanon	LB	AS
123	Lesotho	lesotho	LS	AF
124	Liberia	liberia	LR	AF
125	Libya	libya	LY	AF
126	Liechtenstein	liechtenstein	LI	EU
127	Lithuania	lithuania	LT	EU
128	Luxembourg	luxembourg	LU	EU
129	Macao	macao	MO	AS
130	Macedonia	macedonia	MK	EU
131	Madagascar	madagascar	MG	AF
132	Malawi	malawi	MW	AF
133	Malaysia	malaysia	MY	AS
134	Maldives	maldives	MV	AS
135	Mali	mali	ML	AF
136	Malta	malta	MT	EU
137	Marshall Islands	marshall-islands	MH	OC
138	Martinique	martinique	MQ	NA
139	Mauritania	mauritania	MR	AF
140	Mauritius	mauritius	MU	AF
141	Mayotte	mayotte	YT	AF
142	Mexico	mexico	MX	NA
143	Micronesia (Federated States of)	micronesia-federated-states-of	FM	OC
144	Moldova	moldova	MD	EU
145	Monaco	monaco	MC	EU
146	Mongolia	mongolia	MN	AS
147	Montenegro	montenegro	ME	EU
148	Montserrat	montserrat	MS	NA
149	Morocco	morocco	MA	AF
150	Mozambique	mozambique	MZ	AF
151	Myanmar	myanmar	MM	AS
152	Namibia	namibia	NA	AF
153	Nauru	nauru	NR	OC
154	Nepal	nepal	NP	AS
155	Netherlands	netherlands	NL	EU
156	New Caledonia	new-caledonia	NC	OC
157	New Zealand	new-zealand	NZ	OC
158	Nicaragua	nicaragua	NI	NA
159	Niger	niger	NE	AF
160	Nigeria	nigeria	NG	AF
161	Niue	niue	NU	OC
162	Norfolk Island	norfolk-island	NF	OC
163	North Korea	north-korea	KP	AS
164	Northern Mariana Islands	northern-mariana-islands	MP	OC
165	Norway	norway	NO	EU
166	Oman	oman	OM	AS
167	Pakistan	pakistan	PK	AS
168	Palau	palau	PW	OC
169	Palestine, State of	palestine-state-of	PS	AS
170	Panama	panama	PA	NA
171	Papua New Guinea	papua-new-guinea	PG	OC
172	Paraguay	paraguay	PY	SA
173	Peru	peru	PE	SA
174	Philippines	philippines	PH	AS
175	Pitcairn	pitcairn	PN	OC
176	Poland	poland	PL	EU
177	Portugal	portugal	PT	EU
178	Puerto Rico	puerto-rico	PR	NA
179	Qatar	qatar	QA	AS
180	Réunion	reunion	RE	AF
181	Romania	romania	RO	EU
182	Russia	russia	RU	EU
183	Rwanda	rwanda	RW	AF
184	Saint Barthélemy	saint-barthelemy	BL	NA
185	Saint Helena, Ascension and Tristan da Cunha	saint-helena-ascension-and-tristan-da-cunha	SH	AF
186	Saint Kitts and Nevis	saint-kitts-and-nevis	KN	NA
187	Saint Lucia	saint-lucia	LC	NA
188	Saint Martin (French part)	saint-martin-french-part	MF	NA
189	Saint Pierre and Miquelon	saint-pierre-and-miquelon	PM	NA
190	Saint Vincent and the Grenadines	saint-vincent-and-the-grenadines	VC	NA
191	Samoa	samoa	WS	OC
192	San Marino	san-marino	SM	EU
193	Sao Tome and Principe	sao-tome-and-principe	ST	AF
194	Saudi Arabia	saudi-arabia	SA	AS
195	Senegal	senegal	SN	AF
196	Serbia	serbia	RS	EU
197	Seychelles	seychelles	SC	AF
198	Sierra Leone	sierra-leone	SL	AF
199	Singapore	singapore	SG	AS
200	Sint Maarten (Dutch part)	sint-maarten-dutch-part	SX	\N
201	Slovakia	slovakia	SK	EU
202	Slovenia	slovenia	SI	EU
203	Solomon Islands	solomon-islands	SB	OC
204	Somalia	somalia	SO	AF
205	South Africa	south-africa	ZA	AF
206	South Georgia and the South Sandwich Islands	south-georgia-and-the-south-sandwich-islands	GS	AN
207	South Korea	south-korea	KR	AS
208	South Sudan	south-sudan	SS	AF
209	Spain	spain	ES	EU
210	Sri Lanka	sri-lanka	LK	AS
211	Sudan	sudan	SD	AF
212	Suriname	suriname	SR	SA
213	Svalbard and Jan Mayen	svalbard-and-jan-mayen	SJ	EU
214	Swaziland	swaziland	SZ	AF
215	Sweden	sweden	SE	EU
216	Switzerland	switzerland	CH	EU
217	Syria	syria	SY	AS
218	Taiwan	taiwan	TW	AS
219	Tajikistan	tajikistan	TJ	AS
220	Tanzania	tanzania	TZ	AF
221	Thailand	thailand	TH	AS
222	Timor-Leste	timor-leste	TL	AS
223	Togo	togo	TG	AF
224	Tokelau	tokelau	TK	OC
225	Tonga	tonga	TO	OC
226	Trinidad and Tobago	trinidad-and-tobago	TT	NA
227	Tunisia	tunisia	TN	AF
228	Turkey	turkey	TR	EU
229	Turkmenistan	turkmenistan	TM	AS
230	Turks and Caicos Islands	turks-and-caicos-islands	TC	NA
231	Tuvalu	tuvalu	TV	OC
232	Uganda	uganda	UG	AF
233	Ukraine	ukraine	UA	EU
234	United Arab Emirates	united-arab-emirates	AE	AS
235	United Kingdom	united-kingdom	GB	EU
236	United States Minor Outlying Islands	united-states-minor-outlying-islands	UM	OC
237	United States of America	united-states-of-america	US	NA
238	Uruguay	uruguay	UY	SA
239	Uzbekistan	uzbekistan	UZ	AS
240	Vanuatu	vanuatu	VU	OC
241	Venezuela	venezuela	VE	SA
242	Vietnam	vietnam	VN	AS
243	Virgin Islands (British)	virgin-islands-british	VG	NA
244	Virgin Islands (U.S.)	virgin-islands-us	VI	NA
245	Wallis and Futuna	wallis-and-futuna	WF	OC
246	Western Sahara	western-sahara	EH	AF
247	Yemen	yemen	YE	AS
248	Zambia	zambia	ZM	AF
249	Zimbabwe	zimbabwe	ZW	AF
\.


--
-- Name: glamkit_collections_country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('glamkit_collections_country_id_seq', 249, true);


--
-- Data for Name: glamkit_collections_geographiclocation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY glamkit_collections_geographiclocation (id, state_province, city, neighborhood, colloquial_historical, country_id, slug) FROM stdin;
\.


--
-- Name: glamkit_collections_geographiclocation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('glamkit_collections_geographiclocation_id_seq', 1, false);


--
-- Data for Name: glamkit_sponsors_sponsor; Type: TABLE DATA; Schema: public; Owner: -
--

COPY glamkit_sponsors_sponsor (id, name, url, logo_id) FROM stdin;
\.


--
-- Name: glamkit_sponsors_sponsor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('glamkit_sponsors_sponsor_id_seq', 1, false);


--
-- Data for Name: icekit_article_article; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_article_article (id, publishing_is_draft, publishing_modified_at, publishing_published_at, title, slug, layout_id, parent_id, publishing_linked_id, boosted_search_terms, list_image, hero_image_id, admin_notes, brief) FROM stdin;
\.


--
-- Name: icekit_article_article_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_article_article_id_seq', 1, false);


--
-- Data for Name: icekit_articlecategorypage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_articlecategorypage (urlnode_ptr_id, publishing_is_draft, publishing_modified_at, publishing_published_at, layout_id, publishing_linked_id, boosted_search_terms, hero_image_id, list_image, admin_notes, brief) FROM stdin;
\.


--
-- Data for Name: icekit_authorlisting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_authorlisting (urlnode_ptr_id, publishing_is_draft, publishing_modified_at, publishing_published_at, layout_id, publishing_linked_id, boosted_search_terms, hero_image_id, list_image, admin_notes, brief) FROM stdin;
\.


--
-- Data for Name: icekit_authors_author; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_authors_author (id, publishing_is_draft, publishing_modified_at, publishing_published_at, given_names, family_name, slug, url, oneliner, hero_image_id, publishing_linked_id, boosted_search_terms, list_image, admin_notes, brief) FROM stdin;
\.


--
-- Name: icekit_authors_author_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_authors_author_id_seq', 1, false);


--
-- Data for Name: icekit_event_types_simple_simpleevent; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_event_types_simple_simpleevent (eventbase_ptr_id, layout_id, boosted_search_terms, hero_image_id, list_image) FROM stdin;
\.


--
-- Data for Name: icekit_events_eventbase; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_events_eventbase (id, publishing_is_draft, publishing_modified_at, publishing_published_at, title, slug, created, modified, show_in_calendar, human_dates, special_instructions, cta_text, cta_url, derived_from_id, polymorphic_ctype_id, publishing_linked_id, part_of_id, price_line, primary_type_id, external_ref, has_tickets_available, is_drop_in, human_times, admin_notes, brief, location_id, price_detailed) FROM stdin;
\.


--
-- Name: icekit_events_eventbase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_events_eventbase_id_seq', 1, false);


--
-- Data for Name: icekit_events_eventbase_secondary_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_events_eventbase_secondary_types (id, eventbase_id, eventtype_id) FROM stdin;
\.


--
-- Name: icekit_events_eventbase_secondary_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_events_eventbase_secondary_types_id_seq', 1, false);


--
-- Data for Name: icekit_events_eventrepeatsgenerator; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_events_eventrepeatsgenerator (id, created, modified, recurrence_rule, start, "end", is_all_day, repeat_end, event_id) FROM stdin;
\.


--
-- Name: icekit_events_eventrepeatsgenerator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_events_eventrepeatsgenerator_id_seq', 1, false);


--
-- Data for Name: icekit_events_eventtype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_events_eventtype (id, title, slug, is_public, title_plural, color) FROM stdin;
1	Education	education	f		#cccccc
2	Members	members	f		#cccccc
\.


--
-- Name: icekit_events_eventtype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_events_eventtype_id_seq', 2, true);


--
-- Data for Name: icekit_events_occurrence; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_events_occurrence (id, created, modified, start, "end", is_all_day, is_protected_from_regeneration, is_cancelled, is_hidden, cancel_reason, original_start, original_end, event_id, generator_id, external_ref, status) FROM stdin;
\.


--
-- Name: icekit_events_occurrence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_events_occurrence_id_seq', 1, false);


--
-- Data for Name: icekit_events_recurrencerule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_events_recurrencerule (id, created, modified, description, recurrence_rule) FROM stdin;
6	2018-01-03 09:56:19.762798+11	2018-01-03 09:56:19.762938+11	Yearly, except Xmas day	RRULE:FREQ=YEARLY\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25
5	2018-01-03 09:56:19.759776+11	2018-01-03 09:56:19.759894+11	Monthly, except Xmas day	RRULE:FREQ=MONTHLY\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25
4	2018-01-03 09:56:19.756594+11	2018-01-03 09:56:19.756682+11	Weekly, except Xmas day	RRULE:FREQ=WEEKLY\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25
3	2018-01-03 09:56:19.754708+11	2018-01-03 09:56:19.754762+11	Daily, Weekends, except Xmas day	RRULE:FREQ=DAILY;BYDAY=SA,SU\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25
2	2018-01-03 09:56:19.752786+11	2018-01-03 09:56:19.752856+11	Daily, Weekdays, except Xmas day	RRULE:FREQ=DAILY;BYDAY=MO,TU,WE,TH,FR\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25
1	2018-01-03 09:56:19.721026+11	2018-01-03 09:56:19.742249+11	Daily, except Xmas day	RRULE:FREQ=DAILY\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25
\.


--
-- Name: icekit_events_recurrencerule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_events_recurrencerule_id_seq', 6, true);


--
-- Data for Name: icekit_layout; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_layout (id, created, modified, title, template_name) FROM stdin;
\.


--
-- Data for Name: icekit_layout_content_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_layout_content_types (id, layout_id, contenttype_id) FROM stdin;
\.


--
-- Name: icekit_layout_content_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_layout_content_types_id_seq', 1, false);


--
-- Name: icekit_layout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_layout_id_seq', 1, false);


--
-- Data for Name: icekit_layoutpage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_layoutpage (urlnode_ptr_id, layout_id, publishing_is_draft, publishing_linked_id, publishing_modified_at, publishing_published_at, boosted_search_terms, hero_image_id, list_image, admin_notes, brief) FROM stdin;
\.


--
-- Data for Name: icekit_mediacategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_mediacategory (id, created, modified, name) FROM stdin;
\.


--
-- Name: icekit_mediacategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_mediacategory_id_seq', 1, false);


--
-- Data for Name: icekit_navigation_navigation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_navigation_navigation (id, name, slug, pre_html, post_html) FROM stdin;
\.


--
-- Name: icekit_navigation_navigation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_navigation_navigation_id_seq', 1, false);


--
-- Data for Name: icekit_plugins_contact_person_contactperson; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_plugins_contact_person_contactperson (id, name, title, phone_full, email, phone_display) FROM stdin;
\.


--
-- Name: icekit_plugins_contact_person_contactperson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_plugins_contact_person_contactperson_id_seq', 1, false);


--
-- Data for Name: icekit_plugins_file_file; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_plugins_file_file (id, file, title, is_active, admin_notes) FROM stdin;
\.


--
-- Data for Name: icekit_plugins_file_file_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_plugins_file_file_categories (id, file_id, mediacategory_id) FROM stdin;
\.


--
-- Data for Name: icekit_plugins_image_image; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_plugins_image_image (id, image, alt_text, title, caption, is_ok_for_web, notes, credit, date_created, date_modified, height, license, maximum_dimension_pixels, source, width, is_cropping_allowed, external_ref) FROM stdin;
\.


--
-- Data for Name: icekit_plugins_image_image_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_plugins_image_image_categories (id, image_id, mediacategory_id) FROM stdin;
\.


--
-- Data for Name: icekit_plugins_image_imagerepurposeconfig; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_plugins_image_imagerepurposeconfig (id, title, slug, width, height, format, style, is_cropping_allowed) FROM stdin;
1	Original		\N	\N	jpg	default	f
2	Presentation		1280	1024	jpg	default	f
3	Facebook		1200	\N	jpg	default	f
4	Twitter		440	220	jpg	default	t
5	Instagram		1080	1080	jpg	default	t
6	YouTube		1280	760	jpg	default	t
\.


--
-- Name: icekit_plugins_image_imagerepurposeconfig_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_plugins_image_imagerepurposeconfig_id_seq', 6, true);


--
-- Data for Name: icekit_plugins_location_location; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_plugins_location_location (id, brief, admin_notes, publishing_is_draft, publishing_modified_at, publishing_published_at, title, slug, map_description, map_center_description, map_zoom, map_marker_description, is_home_location, address, phone_number, url, email, email_call_to_action, layout_id, publishing_linked_id, boosted_search_terms, hero_image_id, list_image, phone_number_call_to_action, url_call_to_action, map_center_lat, map_center_long, map_marker_lat, map_marker_long) FROM stdin;
\.


--
-- Name: icekit_plugins_location_location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_plugins_location_location_id_seq', 1, false);


--
-- Data for Name: icekit_plugins_slideshow_slideshow; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_plugins_slideshow_slideshow (id, title, show_title, publishing_is_draft, publishing_linked_id, publishing_modified_at, publishing_published_at, admin_notes, brief) FROM stdin;
\.


--
-- Data for Name: icekit_press_releases_pressrelease; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_press_releases_pressrelease (id, publishing_is_draft, publishing_modified_at, publishing_published_at, title, slug, print_version, created, modified, released, category_id, layout_id, publishing_linked_id, boosted_search_terms, list_image, admin_notes, brief) FROM stdin;
\.


--
-- Name: icekit_press_releases_pressrelease_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_press_releases_pressrelease_id_seq', 1, false);


--
-- Data for Name: icekit_press_releases_pressreleasecategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_press_releases_pressreleasecategory (id, name) FROM stdin;
\.


--
-- Name: icekit_press_releases_pressreleasecategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_press_releases_pressreleasecategory_id_seq', 1, false);


--
-- Data for Name: icekit_searchpage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_searchpage (urlnode_ptr_id, publishing_is_draft, publishing_linked_id, publishing_modified_at, publishing_published_at, boosted_search_terms, list_image, default_search_type, admin_notes, brief) FROM stdin;
\.


--
-- Data for Name: icekit_workflow_workflowstate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_workflow_workflowstate (id, object_id, status, assigned_to_id, content_type_id, datetime_modified) FROM stdin;
\.


--
-- Data for Name: ik_event_listing_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ik_event_listing_types (id, eventcontentlistingitem_id, eventtype_id) FROM stdin;
\.


--
-- Name: ik_event_listing_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('ik_event_listing_types_id_seq', 1, false);


--
-- Data for Name: ik_todays_occurrences_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ik_todays_occurrences_types (id, todaysoccurrences_id, eventtype_id) FROM stdin;
\.


--
-- Name: ik_todays_occurrences_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('ik_todays_occurrences_types_id_seq', 1, false);


--
-- Name: image_image_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('image_image_categories_id_seq', 1, false);


--
-- Name: image_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('image_image_id_seq', 1, false);


--
-- Data for Name: media_coverage_mediacoveragerecord; Type: TABLE DATA; Schema: public; Owner: -
--

COPY media_coverage_mediacoveragerecord (id, created, modified, original_url, title, description, original_publication_date) FROM stdin;
\.


--
-- Name: media_coverage_mediacoveragerecord_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('media_coverage_mediacoveragerecord_id_seq', 1, false);


--
-- Data for Name: model_settings_boolean; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_boolean (setting_ptr_id, value) FROM stdin;
\.


--
-- Data for Name: model_settings_date; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_date (setting_ptr_id, value) FROM stdin;
\.


--
-- Data for Name: model_settings_datetime; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_datetime (setting_ptr_id, value) FROM stdin;
\.


--
-- Data for Name: model_settings_decimal; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_decimal (setting_ptr_id, value) FROM stdin;
\.


--
-- Data for Name: model_settings_file; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_file (setting_ptr_id, value) FROM stdin;
\.


--
-- Data for Name: model_settings_float; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_float (setting_ptr_id, value) FROM stdin;
\.


--
-- Data for Name: model_settings_image; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_image (setting_ptr_id, value) FROM stdin;
\.


--
-- Data for Name: model_settings_integer; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_integer (setting_ptr_id, value) FROM stdin;
\.


--
-- Data for Name: model_settings_setting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_setting (id, name, polymorphic_ctype_id) FROM stdin;
\.


--
-- Name: model_settings_setting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('model_settings_setting_id_seq', 1, false);


--
-- Data for Name: model_settings_text; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_text (setting_ptr_id, value) FROM stdin;
\.


--
-- Data for Name: model_settings_time; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_time (setting_ptr_id, value) FROM stdin;
\.


--
-- Data for Name: notifications_followerinformation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifications_followerinformation (id, object_id, content_type_id, polymorphic_ctype_id) FROM stdin;
\.


--
-- Data for Name: notifications_followerinformation_followers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifications_followerinformation_followers (id, followerinformation_id, user_id) FROM stdin;
\.


--
-- Name: notifications_followerinformation_followers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifications_followerinformation_followers_id_seq', 1, false);


--
-- Data for Name: notifications_followerinformation_group_followers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifications_followerinformation_group_followers (id, followerinformation_id, group_id) FROM stdin;
\.


--
-- Name: notifications_followerinformation_group_followers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifications_followerinformation_group_followers_id_seq', 1, false);


--
-- Name: notifications_followerinformation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifications_followerinformation_id_seq', 1, false);


--
-- Data for Name: notifications_hasreadmessage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifications_hasreadmessage (id, is_read, "time", is_removed, notification_setting, email_sent, message_id, person_id) FROM stdin;
\.


--
-- Name: notifications_hasreadmessage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifications_hasreadmessage_id_seq', 1, false);


--
-- Data for Name: notifications_notification; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifications_notification (id, created, modified, title, notification, is_removed, user_id) FROM stdin;
\.


--
-- Name: notifications_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifications_notification_id_seq', 1, false);


--
-- Data for Name: notifications_notificationsetting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifications_notificationsetting (id, notification_type, user_id) FROM stdin;
1	ALL	1
\.


--
-- Name: notifications_notificationsetting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifications_notificationsetting_id_seq', 1, true);


--
-- Data for Name: pagetype_advancedeventlisting_advancedeventlistingpage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pagetype_advancedeventlisting_advancedeventlistingpage (urlnode_ptr_id, brief, admin_notes, list_image, boosted_search_terms, publishing_is_draft, publishing_modified_at, publishing_published_at, limit_to_home_locations, default_start_date, default_days_to_show, hero_image_id, layout_id, publishing_linked_id) FROM stdin;
\.


--
-- Data for Name: pagetype_eventlistingfordate_eventlistingpage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pagetype_eventlistingfordate_eventlistingpage (urlnode_ptr_id, publishing_is_draft, publishing_modified_at, publishing_published_at, layout_id, publishing_linked_id, boosted_search_terms, hero_image_id, list_image, admin_notes, brief) FROM stdin;
\.


--
-- Data for Name: pagetype_fluentpage_fluentpage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pagetype_fluentpage_fluentpage (urlnode_ptr_id, layout_id) FROM stdin;
\.


--
-- Data for Name: pagetype_icekit_press_releases_pressreleaselisting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pagetype_icekit_press_releases_pressreleaselisting (urlnode_ptr_id, publishing_is_draft, publishing_modified_at, publishing_published_at, layout_id, publishing_linked_id, boosted_search_terms, hero_image_id, list_image, admin_notes, brief) FROM stdin;
\.


--
-- Data for Name: pagetype_redirectnode_redirectnode; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pagetype_redirectnode_redirectnode (urlnode_ptr_id) FROM stdin;
\.


--
-- Data for Name: pagetype_textfile_textfile; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pagetype_textfile_textfile (urlnode_ptr_id, content_type) FROM stdin;
\.


--
-- Data for Name: polymorphic_auth_email_emailuser; Type: TABLE DATA; Schema: public; Owner: -
--

COPY polymorphic_auth_email_emailuser (user_ptr_id, email) FROM stdin;
1	admin@biennale-of-sydney.lvh.me
\.


--
-- Data for Name: polymorphic_auth_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY polymorphic_auth_user (id, password, last_login, is_superuser, is_staff, is_active, first_name, last_name, created, polymorphic_ctype_id) FROM stdin;
1	pbkdf2_sha256$20000$g58QbMp5P7lJ$vvYD+bYDIpq8wx+o5QlilRWJupeuKKTTp7ZnIl8P/Kw=	\N	t	t	t	Admin		2018-01-03 10:05:25.57259+11	3
\.


--
-- Data for Name: polymorphic_auth_user_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY polymorphic_auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Name: polymorphic_auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('polymorphic_auth_user_groups_id_seq', 1, false);


--
-- Name: polymorphic_auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('polymorphic_auth_user_id_seq', 1, true);


--
-- Data for Name: polymorphic_auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY polymorphic_auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Name: polymorphic_auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('polymorphic_auth_user_user_permissions_id_seq', 1, false);


--
-- Data for Name: post_office_attachment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY post_office_attachment (id, file, name, mimetype) FROM stdin;
\.


--
-- Data for Name: post_office_attachment_emails; Type: TABLE DATA; Schema: public; Owner: -
--

COPY post_office_attachment_emails (id, attachment_id, email_id) FROM stdin;
\.


--
-- Name: post_office_attachment_emails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('post_office_attachment_emails_id_seq', 1, false);


--
-- Name: post_office_attachment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('post_office_attachment_id_seq', 1, false);


--
-- Data for Name: post_office_email; Type: TABLE DATA; Schema: public; Owner: -
--

COPY post_office_email (id, from_email, "to", cc, bcc, subject, message, html_message, status, priority, created, last_updated, scheduled_time, headers, context, template_id, backend_alias) FROM stdin;
\.


--
-- Name: post_office_email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('post_office_email_id_seq', 1, false);


--
-- Data for Name: post_office_emailtemplate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY post_office_emailtemplate (id, name, description, subject, content, html_content, created, last_updated, default_template_id, language) FROM stdin;
\.


--
-- Name: post_office_emailtemplate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('post_office_emailtemplate_id_seq', 1, false);


--
-- Data for Name: post_office_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY post_office_log (id, date, status, exception_type, message, email_id) FROM stdin;
\.


--
-- Name: post_office_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('post_office_log_id_seq', 1, false);


--
-- Data for Name: redirectnode_redirectnode_translation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY redirectnode_redirectnode_translation (id, language_code, new_url, redirect_type, master_id) FROM stdin;
\.


--
-- Name: redirectnode_redirectnode_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('redirectnode_redirectnode_translation_id_seq', 1, false);


--
-- Data for Name: response_pages_responsepage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY response_pages_responsepage (id, title, type, is_active) FROM stdin;
\.


--
-- Name: response_pages_responsepage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('response_pages_responsepage_id_seq', 1, false);


--
-- Data for Name: reversion_revision; Type: TABLE DATA; Schema: public; Owner: -
--

COPY reversion_revision (id, manager_slug, date_created, comment, user_id) FROM stdin;
\.


--
-- Name: reversion_revision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('reversion_revision_id_seq', 1, false);


--
-- Data for Name: reversion_version; Type: TABLE DATA; Schema: public; Owner: -
--

COPY reversion_version (id, object_id, object_id_int, format, serialized_data, object_repr, content_type_id, revision_id) FROM stdin;
\.


--
-- Name: reversion_version_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('reversion_version_id_seq', 1, false);


--
-- Data for Name: sharedcontent_sharedcontent; Type: TABLE DATA; Schema: public; Owner: -
--

COPY sharedcontent_sharedcontent (id, slug, is_cross_site, parent_site_id) FROM stdin;
\.


--
-- Name: sharedcontent_sharedcontent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sharedcontent_sharedcontent_id_seq', 1, false);


--
-- Data for Name: sharedcontent_sharedcontent_translation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY sharedcontent_sharedcontent_translation (id, language_code, title, master_id) FROM stdin;
\.


--
-- Name: sharedcontent_sharedcontent_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sharedcontent_sharedcontent_translation_id_seq', 1, false);


--
-- Name: slideshow_slideshow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('slideshow_slideshow_id_seq', 1, false);


--
-- Data for Name: staff_profiles_department; Type: TABLE DATA; Schema: public; Owner: -
--

COPY staff_profiles_department (id, title) FROM stdin;
\.


--
-- Name: staff_profiles_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('staff_profiles_department_id_seq', 1, false);


--
-- Data for Name: staff_profiles_staffprofile; Type: TABLE DATA; Schema: public; Owner: -
--

COPY staff_profiles_staffprofile (id, created, modified, status, status_changed, job_title, short_bio, importance, user_id) FROM stdin;
\.


--
-- Data for Name: staff_profiles_staffprofile_department; Type: TABLE DATA; Schema: public; Owner: -
--

COPY staff_profiles_staffprofile_department (id, staffprofile_id, department_id) FROM stdin;
\.


--
-- Name: staff_profiles_staffprofile_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('staff_profiles_staffprofile_department_id_seq', 1, false);


--
-- Name: staff_profiles_staffprofile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('staff_profiles_staffprofile_id_seq', 1, false);


--
-- Data for Name: taggit_tag; Type: TABLE DATA; Schema: public; Owner: -
--

COPY taggit_tag (id, name, slug) FROM stdin;
\.


--
-- Name: taggit_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('taggit_tag_id_seq', 1, false);


--
-- Data for Name: taggit_taggeditem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY taggit_taggeditem (id, object_id, content_type_id, tag_id) FROM stdin;
\.


--
-- Name: taggit_taggeditem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('taggit_taggeditem_id_seq', 1, false);


--
-- Data for Name: test_article; Type: TABLE DATA; Schema: public; Owner: -
--

COPY test_article (id, publishing_is_draft, publishing_modified_at, publishing_published_at, title, slug, layout_id, publishing_linked_id, parent_id, boosted_search_terms, list_image) FROM stdin;
\.


--
-- Name: test_article_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('test_article_id_seq', 1, false);


--
-- Data for Name: test_articlelisting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY test_articlelisting (urlnode_ptr_id, publishing_is_draft, publishing_modified_at, publishing_published_at, layout_id, publishing_linked_id, boosted_search_terms, hero_image_id, list_image, admin_notes, brief) FROM stdin;
\.


--
-- Data for Name: test_layoutpage_with_related; Type: TABLE DATA; Schema: public; Owner: -
--

COPY test_layoutpage_with_related (urlnode_ptr_id, publishing_is_draft, publishing_modified_at, publishing_published_at, layout_id, publishing_linked_id, boosted_search_terms, hero_image_id, list_image, admin_notes, brief) FROM stdin;
\.


--
-- Data for Name: test_layoutpage_with_related_related_pages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY test_layoutpage_with_related_related_pages (id, layoutpagewithrelatedpages_id, page_id) FROM stdin;
\.


--
-- Name: test_layoutpage_with_related_related_pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('test_layoutpage_with_related_related_pages_id_seq', 1, false);


--
-- Data for Name: tests_barwithlayout; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_barwithlayout (id, layout_id) FROM stdin;
\.


--
-- Name: tests_barwithlayout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_barwithlayout_id_seq', 1, false);


--
-- Data for Name: tests_basemodel; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_basemodel (id, created, modified) FROM stdin;
\.


--
-- Name: tests_basemodel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_basemodel_id_seq', 1, false);


--
-- Data for Name: tests_bazwithlayout; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_bazwithlayout (id, layout_id) FROM stdin;
\.


--
-- Name: tests_bazwithlayout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_bazwithlayout_id_seq', 1, false);


--
-- Data for Name: tests_foowithlayout; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_foowithlayout (id, layout_id) FROM stdin;
\.


--
-- Name: tests_foowithlayout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_foowithlayout_id_seq', 1, false);


--
-- Data for Name: tests_imagetest; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_imagetest (id, image) FROM stdin;
\.


--
-- Name: tests_imagetest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_imagetest_id_seq', 1, false);


--
-- Data for Name: tests_publishingm2mmodela; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_publishingm2mmodela (id, publishing_is_draft, publishing_modified_at, publishing_published_at, publishing_linked_id) FROM stdin;
\.


--
-- Name: tests_publishingm2mmodela_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_publishingm2mmodela_id_seq', 1, false);


--
-- Data for Name: tests_publishingm2mmodelb; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_publishingm2mmodelb (id, publishing_is_draft, publishing_modified_at, publishing_published_at, publishing_linked_id) FROM stdin;
\.


--
-- Name: tests_publishingm2mmodelb_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_publishingm2mmodelb_id_seq', 1, false);


--
-- Data for Name: tests_publishingm2mmodelb_related_a_models; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_publishingm2mmodelb_related_a_models (id, publishingm2mmodelb_id, publishingm2mmodela_id) FROM stdin;
\.


--
-- Name: tests_publishingm2mmodelb_related_a_models_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_publishingm2mmodelb_related_a_models_id_seq', 1, false);


--
-- Data for Name: tests_publishingm2mthroughtable; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_publishingm2mthroughtable (id, a_model_id, b_model_id) FROM stdin;
\.


--
-- Name: tests_publishingm2mthroughtable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_publishingm2mthroughtable_id_seq', 1, false);


--
-- Data for Name: textfile_textfile_translation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY textfile_textfile_translation (id, language_code, content, master_id) FROM stdin;
\.


--
-- Name: textfile_textfile_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('textfile_textfile_translation_id_seq', 1, false);


--
-- Name: workflow_workflowstate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('workflow_workflowstate_id_seq', 1, false);


--
-- Name: advanced_event_listing_page_locations advanced_event_listing_page_l_advancedeventlistingpage_id_l_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY advanced_event_listing_page_locations
    ADD CONSTRAINT advanced_event_listing_page_l_advancedeventlistingpage_id_l_key UNIQUE (advancedeventlistingpage_id, location_id);


--
-- Name: advanced_event_listing_page_locations advanced_event_listing_page_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY advanced_event_listing_page_locations
    ADD CONSTRAINT advanced_event_listing_page_locations_pkey PRIMARY KEY (id);


--
-- Name: advanced_event_listing_page_primary_types advanced_event_listing_page_p_advancedeventlistingpage_id_e_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY advanced_event_listing_page_primary_types
    ADD CONSTRAINT advanced_event_listing_page_p_advancedeventlistingpage_id_e_key UNIQUE (advancedeventlistingpage_id, eventtype_id);


--
-- Name: advanced_event_listing_page_primary_types advanced_event_listing_page_primary_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY advanced_event_listing_page_primary_types
    ADD CONSTRAINT advanced_event_listing_page_primary_types_pkey PRIMARY KEY (id);


--
-- Name: advanced_event_listing_page_secondary_types advanced_event_listing_page_s_advancedeventlistingpage_id_e_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY advanced_event_listing_page_secondary_types
    ADD CONSTRAINT advanced_event_listing_page_s_advancedeventlistingpage_id_e_key UNIQUE (advancedeventlistingpage_id, eventtype_id);


--
-- Name: advanced_event_listing_page_secondary_types advanced_event_listing_page_secondary_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY advanced_event_listing_page_secondary_types
    ADD CONSTRAINT advanced_event_listing_page_secondary_types_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_key UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_key UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: authtoken_token authtoken_token_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY authtoken_token
    ADD CONSTRAINT authtoken_token_pkey PRIMARY KEY (key);


--
-- Name: authtoken_token authtoken_token_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_key UNIQUE (user_id);


--
-- Name: biennale_of_sydney_biennaleevent_works biennale_of_sydney_biennaleeve_biennaleevent_id_workbase_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennaleevent_works
    ADD CONSTRAINT biennale_of_sydney_biennaleeve_biennaleevent_id_workbase_id_key UNIQUE (biennaleevent_id, workbase_id);


--
-- Name: biennale_of_sydney_biennaleevent biennale_of_sydney_biennaleevent_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennaleevent
    ADD CONSTRAINT biennale_of_sydney_biennaleevent_pkey PRIMARY KEY (eventbase_ptr_id);


--
-- Name: biennale_of_sydney_biennaleevent_works biennale_of_sydney_biennaleevent_works_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennaleevent_works
    ADD CONSTRAINT biennale_of_sydney_biennaleevent_works_pkey PRIMARY KEY (id);


--
-- Name: biennale_of_sydney_biennalelocation biennale_of_sydney_biennalelocation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennalelocation
    ADD CONSTRAINT biennale_of_sydney_biennalelocation_pkey PRIMARY KEY (id);


--
-- Name: biennale_of_sydney_biennalelocation biennale_of_sydney_biennalelocation_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennalelocation
    ADD CONSTRAINT biennale_of_sydney_biennalelocation_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: biennale_of_sydney_biennalelocation biennale_of_sydney_biennalelocation_slug_48cf9dcdb7c81e40_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennalelocation
    ADD CONSTRAINT biennale_of_sydney_biennalelocation_slug_48cf9dcdb7c81e40_uniq UNIQUE (slug, publishing_linked_id);


--
-- Name: biennale_of_sydney_eventartist biennale_of_sydney_eventartist_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_eventartist
    ADD CONSTRAINT biennale_of_sydney_eventartist_pkey PRIMARY KEY (id);


--
-- Name: biennale_of_sydney_exhibition biennale_of_sydney_exhibition_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_exhibition
    ADD CONSTRAINT biennale_of_sydney_exhibition_pkey PRIMARY KEY (occurrence_ptr_id);


--
-- Name: biennale_of_sydney_partner biennale_of_sydney_partner_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_partner
    ADD CONSTRAINT biennale_of_sydney_partner_pkey PRIMARY KEY (id);


--
-- Name: celery_taskmeta celery_taskmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_taskmeta
    ADD CONSTRAINT celery_taskmeta_pkey PRIMARY KEY (id);


--
-- Name: celery_taskmeta celery_taskmeta_task_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_taskmeta
    ADD CONSTRAINT celery_taskmeta_task_id_key UNIQUE (task_id);


--
-- Name: celery_tasksetmeta celery_tasksetmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_tasksetmeta
    ADD CONSTRAINT celery_tasksetmeta_pkey PRIMARY KEY (id);


--
-- Name: celery_tasksetmeta celery_tasksetmeta_taskset_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_tasksetmeta
    ADD CONSTRAINT celery_tasksetmeta_taskset_id_key UNIQUE (taskset_id);


--
-- Name: contentitem_icekit_plugins_child_pages_childpageitem contentitem_child_pages_childpageitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_child_pages_childpageitem
    ADD CONSTRAINT contentitem_child_pages_childpageitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_faq_faqitem contentitem_faq_faqitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_faq_faqitem
    ADD CONSTRAINT contentitem_faq_faqitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_file_fileitem contentitem_file_fileitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_file_fileitem
    ADD CONSTRAINT contentitem_file_fileitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_gk_collections_links_creatorlink contentitem_gk_collections_links_creatorlink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_gk_collections_links_creatorlink
    ADD CONSTRAINT contentitem_gk_collections_links_creatorlink_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_gk_collections_links_worklink contentitem_gk_collections_links_worklink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_gk_collections_links_worklink
    ADD CONSTRAINT contentitem_gk_collections_links_worklink_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_glamkit_sponsors_beginsponsorblockitem contentitem_glamkit_sponsors_beginsponsorblockitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_beginsponsorblockitem
    ADD CONSTRAINT contentitem_glamkit_sponsors_beginsponsorblockitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_glamkit_sponsors_endsponsorblockitem contentitem_glamkit_sponsors_endsponsorblockitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_endsponsorblockitem
    ADD CONSTRAINT contentitem_glamkit_sponsors_endsponsorblockitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_glamkit_sponsors_sponsorpromoitem contentitem_glamkit_sponsors_sponsorpromoitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_sponsorpromoitem
    ADD CONSTRAINT contentitem_glamkit_sponsors_sponsorpromoitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_horizontal_rule_horizontalruleitem contentitem_horizontal_rule_horizontalruleitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_horizontal_rule_horizontalruleitem
    ADD CONSTRAINT contentitem_horizontal_rule_horizontalruleitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_events_links_eventlink contentitem_icekit_events_links_eventlink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_events_links_eventlink
    ADD CONSTRAINT contentitem_icekit_events_links_eventlink_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_navigation_accountsnavigationitem contentitem_icekit_navigation_accountsnavigationitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_navigation_accountsnavigationitem
    ADD CONSTRAINT contentitem_icekit_navigation_accountsnavigationitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_navigation_navigationitem contentitem_icekit_navigation_navigationitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_navigation_navigationitem
    ADD CONSTRAINT contentitem_icekit_navigation_navigationitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_contact_person_contactpersonitem contentitem_icekit_plugins_contact_person_contactpersonite_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_contact_person_contactpersonitem
    ADD CONSTRAINT contentitem_icekit_plugins_contact_person_contactpersonite_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_content_listing_contentlistingitem contentitem_icekit_plugins_content_listing_contentlistingi_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_content_listing_contentlistingitem
    ADD CONSTRAINT contentitem_icekit_plugins_content_listing_contentlistingi_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_location_locationitem contentitem_icekit_plugins_location_locationitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_location_locationitem
    ADD CONSTRAINT contentitem_icekit_plugins_location_locationitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_iframe_iframeitem contentitem_iframe_iframeitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_iframe_iframeitem
    ADD CONSTRAINT contentitem_iframe_iframeitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_ik_event_listing_eventcontentlistingitem contentitem_ik_event_listing_eventcontentlistingitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_event_listing_eventcontentlistingitem
    ADD CONSTRAINT contentitem_ik_event_listing_eventcontentlistingitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_ik_events_todays_occurrences_todaysoccurrences contentitem_ik_events_todays_occurrences_todaysoccurrences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_events_todays_occurrences_todaysoccurrences
    ADD CONSTRAINT contentitem_ik_events_todays_occurrences_todaysoccurrences_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_ik_links_articlelink contentitem_ik_links_articlelink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_articlelink
    ADD CONSTRAINT contentitem_ik_links_articlelink_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_ik_links_authorlink contentitem_ik_links_authorlink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_authorlink
    ADD CONSTRAINT contentitem_ik_links_authorlink_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_ik_links_pagelink contentitem_ik_links_pagelink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_pagelink
    ADD CONSTRAINT contentitem_ik_links_pagelink_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_image_gallery_imagegalleryshowitem contentitem_image_gallery_imagegalleryshowitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_image_gallery_imagegalleryshowitem
    ADD CONSTRAINT contentitem_image_gallery_imagegalleryshowitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_image_imageitem contentitem_image_imageitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_image_imageitem
    ADD CONSTRAINT contentitem_image_imageitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_instagram_embed_instagramembeditem contentitem_instagram_embed_instagramembeditem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_instagram_embed_instagramembeditem
    ADD CONSTRAINT contentitem_instagram_embed_instagramembeditem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_map_mapitem contentitem_map_mapitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_map_mapitem
    ADD CONSTRAINT contentitem_map_mapitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_media_coverage_mediacoveragelist contentitem_media_coverage_mediacoveragelist_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_media_coverage_mediacoveragelist
    ADD CONSTRAINT contentitem_media_coverage_mediacoveragelist_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_media_coverage_mediacoveragepromoitem contentitem_media_coverage_mediacoveragepromoitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_media_coverage_mediacoveragepromoitem
    ADD CONSTRAINT contentitem_media_coverage_mediacoveragepromoitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_oembed_with_caption_item contentitem_oembed_with_caption_oembedwithcaptionitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_oembed_with_caption_item
    ADD CONSTRAINT contentitem_oembed_with_caption_oembedwithcaptionitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_oembeditem_oembeditem contentitem_oembeditem_oembeditem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_oembeditem_oembeditem
    ADD CONSTRAINT contentitem_oembeditem_oembeditem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem contentitem_page_anchor_list_pageanchorlistitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem
    ADD CONSTRAINT contentitem_page_anchor_list_pageanchorlistitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_page_anchor_pageanchoritem contentitem_page_anchor_pageanchoritem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_page_anchor_pageanchoritem
    ADD CONSTRAINT contentitem_page_anchor_pageanchoritem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_quote_quoteitem contentitem_quote_quoteitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_quote_quoteitem
    ADD CONSTRAINT contentitem_quote_quoteitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_rawhtml_rawhtmlitem contentitem_rawhtml_rawhtmlitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_rawhtml_rawhtmlitem
    ADD CONSTRAINT contentitem_rawhtml_rawhtmlitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_reusable_form_formitem contentitem_reusable_form_formitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_reusable_form_formitem
    ADD CONSTRAINT contentitem_reusable_form_formitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_sharedcontent_sharedcontentitem contentitem_sharedcontent_sharedcontentitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_sharedcontent_sharedcontentitem
    ADD CONSTRAINT contentitem_sharedcontent_sharedcontentitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_slideshow_slideshowitem contentitem_slideshow_slideshowitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_slideshow_slideshowitem
    ADD CONSTRAINT contentitem_slideshow_slideshowitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_staff_profile_list_staffprofileslist contentitem_staff_profile_list_staffprofileslist_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_staff_profile_list_staffprofileslist
    ADD CONSTRAINT contentitem_staff_profile_list_staffprofileslist_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_text_textitem contentitem_text_textitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_text_textitem
    ADD CONSTRAINT contentitem_text_textitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_twitter_embed_twitterembeditem contentitem_twitter_embed_twitterembeditem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_twitter_embed_twitterembeditem
    ADD CONSTRAINT contentitem_twitter_embed_twitterembeditem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_48e66fefed0a3828_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_48e66fefed0a3828_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_redirect django_redirect_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_redirect
    ADD CONSTRAINT django_redirect_pkey PRIMARY KEY (id);


--
-- Name: django_redirect django_redirect_site_id_old_path_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_redirect
    ADD CONSTRAINT django_redirect_site_id_old_path_key UNIQUE (site_id, old_path);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: django_site django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: djcelery_crontabschedule djcelery_crontabschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_crontabschedule
    ADD CONSTRAINT djcelery_crontabschedule_pkey PRIMARY KEY (id);


--
-- Name: djcelery_intervalschedule djcelery_intervalschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_intervalschedule
    ADD CONSTRAINT djcelery_intervalschedule_pkey PRIMARY KEY (id);


--
-- Name: djcelery_periodictask djcelery_periodictask_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT djcelery_periodictask_name_key UNIQUE (name);


--
-- Name: djcelery_periodictask djcelery_periodictask_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT djcelery_periodictask_pkey PRIMARY KEY (id);


--
-- Name: djcelery_periodictasks djcelery_periodictasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictasks
    ADD CONSTRAINT djcelery_periodictasks_pkey PRIMARY KEY (ident);


--
-- Name: djcelery_taskstate djcelery_taskstate_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_taskstate
    ADD CONSTRAINT djcelery_taskstate_pkey PRIMARY KEY (id);


--
-- Name: djcelery_taskstate djcelery_taskstate_task_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_taskstate
    ADD CONSTRAINT djcelery_taskstate_task_id_key UNIQUE (task_id);


--
-- Name: djcelery_workerstate djcelery_workerstate_hostname_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_workerstate
    ADD CONSTRAINT djcelery_workerstate_hostname_key UNIQUE (hostname);


--
-- Name: djcelery_workerstate djcelery_workerstate_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_workerstate
    ADD CONSTRAINT djcelery_workerstate_pkey PRIMARY KEY (id);


--
-- Name: djkombu_message djkombu_message_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_message
    ADD CONSTRAINT djkombu_message_pkey PRIMARY KEY (id);


--
-- Name: djkombu_queue djkombu_queue_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_queue
    ADD CONSTRAINT djkombu_queue_name_key UNIQUE (name);


--
-- Name: djkombu_queue djkombu_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_queue
    ADD CONSTRAINT djkombu_queue_pkey PRIMARY KEY (id);


--
-- Name: easy_thumbnails_source easy_thumbnails_source_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_source
    ADD CONSTRAINT easy_thumbnails_source_pkey PRIMARY KEY (id);


--
-- Name: easy_thumbnails_source easy_thumbnails_source_storage_hash_460eb9876af1bf1f_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_source
    ADD CONSTRAINT easy_thumbnails_source_storage_hash_460eb9876af1bf1f_uniq UNIQUE (storage_hash, name);


--
-- Name: easy_thumbnails_thumbnail easy_thumbnails_thumbnail_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnail
    ADD CONSTRAINT easy_thumbnails_thumbnail_pkey PRIMARY KEY (id);


--
-- Name: easy_thumbnails_thumbnail easy_thumbnails_thumbnail_storage_hash_a3b64e35538f78e_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnail
    ADD CONSTRAINT easy_thumbnails_thumbnail_storage_hash_a3b64e35538f78e_uniq UNIQUE (storage_hash, name, source_id);


--
-- Name: easy_thumbnails_thumbnaildimensions easy_thumbnails_thumbnaildimensions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnaildimensions
    ADD CONSTRAINT easy_thumbnails_thumbnaildimensions_pkey PRIMARY KEY (id);


--
-- Name: easy_thumbnails_thumbnaildimensions easy_thumbnails_thumbnaildimensions_thumbnail_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnaildimensions
    ADD CONSTRAINT easy_thumbnails_thumbnaildimensions_thumbnail_id_key UNIQUE (thumbnail_id);


--
-- Name: icekit_plugins_file_file_categories file_file_categories_file_id_mediacategory_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories
    ADD CONSTRAINT file_file_categories_file_id_mediacategory_id_key UNIQUE (file_id, mediacategory_id);


--
-- Name: icekit_plugins_file_file_categories file_file_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories
    ADD CONSTRAINT file_file_categories_pkey PRIMARY KEY (id);


--
-- Name: icekit_plugins_file_file file_file_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file
    ADD CONSTRAINT file_file_pkey PRIMARY KEY (id);


--
-- Name: fluent_contents_contentitem fluent_contents_contentitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem
    ADD CONSTRAINT fluent_contents_contentitem_pkey PRIMARY KEY (id);


--
-- Name: fluent_contents_placeholder fluent_contents_placeholde_parent_type_id_22a3450b5b527e0f_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_placeholder
    ADD CONSTRAINT fluent_contents_placeholde_parent_type_id_22a3450b5b527e0f_uniq UNIQUE (parent_type_id, parent_id, slot);


--
-- Name: fluent_contents_placeholder fluent_contents_placeholder_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_placeholder
    ADD CONSTRAINT fluent_contents_placeholder_pkey PRIMARY KEY (id);


--
-- Name: fluent_pages_htmlpage_translation fluent_pages_htmlpage_trans_language_code_4f981b8f4b502ddf_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_htmlpage_translation
    ADD CONSTRAINT fluent_pages_htmlpage_trans_language_code_4f981b8f4b502ddf_uniq UNIQUE (language_code, master_id);


--
-- Name: fluent_pages_htmlpage_translation fluent_pages_htmlpage_translation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_htmlpage_translation
    ADD CONSTRAINT fluent_pages_htmlpage_translation_pkey PRIMARY KEY (id);


--
-- Name: fluent_pages_pagelayout fluent_pages_pagelayout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_pagelayout
    ADD CONSTRAINT fluent_pages_pagelayout_pkey PRIMARY KEY (id);


--
-- Name: fluent_pages_urlnode fluent_pages_urlnode_parent_site_id_3b2d9d4db81a8c8d_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_pages_urlnode_parent_site_id_3b2d9d4db81a8c8d_uniq UNIQUE (parent_site_id, key);


--
-- Name: fluent_pages_urlnode fluent_pages_urlnode_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_pages_urlnode_pkey PRIMARY KEY (id);


--
-- Name: fluent_pages_urlnode_translation fluent_pages_urlnode_transl_language_code_20aa476a21dc7923_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode_translation
    ADD CONSTRAINT fluent_pages_urlnode_transl_language_code_20aa476a21dc7923_uniq UNIQUE (language_code, master_id);


--
-- Name: fluent_pages_urlnode_translation fluent_pages_urlnode_translation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode_translation
    ADD CONSTRAINT fluent_pages_urlnode_translation_pkey PRIMARY KEY (id);


--
-- Name: forms_field forms_field_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_field
    ADD CONSTRAINT forms_field_pkey PRIMARY KEY (id);


--
-- Name: forms_fieldentry forms_fieldentry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_fieldentry
    ADD CONSTRAINT forms_fieldentry_pkey PRIMARY KEY (id);


--
-- Name: forms_form forms_form_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form
    ADD CONSTRAINT forms_form_pkey PRIMARY KEY (id);


--
-- Name: forms_form_sites forms_form_sites_form_id_site_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites
    ADD CONSTRAINT forms_form_sites_form_id_site_id_key UNIQUE (form_id, site_id);


--
-- Name: forms_form_sites forms_form_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites
    ADD CONSTRAINT forms_form_sites_pkey PRIMARY KEY (id);


--
-- Name: forms_form forms_form_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form
    ADD CONSTRAINT forms_form_slug_key UNIQUE (slug);


--
-- Name: forms_formentry forms_formentry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_formentry
    ADD CONSTRAINT forms_formentry_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_artwork_artwork gk_collections_artwork_artwork_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_artwork_artwork
    ADD CONSTRAINT gk_collections_artwork_artwork_pkey PRIMARY KEY (workbase_ptr_id);


--
-- Name: gk_collections_film_film_formats gk_collections_film_film_formats_film_id_format_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_film_film_formats
    ADD CONSTRAINT gk_collections_film_film_formats_film_id_format_id_key UNIQUE (film_id, format_id);


--
-- Name: gk_collections_film_film_formats gk_collections_film_film_formats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_film_film_formats
    ADD CONSTRAINT gk_collections_film_film_formats_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_film_film_genres gk_collections_film_film_genres_film_id_genre_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_film_film_genres
    ADD CONSTRAINT gk_collections_film_film_genres_film_id_genre_id_key UNIQUE (film_id, genre_id);


--
-- Name: gk_collections_film_film_genres gk_collections_film_film_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_film_film_genres
    ADD CONSTRAINT gk_collections_film_film_genres_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_film_film gk_collections_film_film_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_film_film
    ADD CONSTRAINT gk_collections_film_film_pkey PRIMARY KEY (workbase_ptr_id);


--
-- Name: gk_collections_film_format gk_collections_film_format_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_film_format
    ADD CONSTRAINT gk_collections_film_format_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_game_game_genres gk_collections_game_game_genres_game_id_genre_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game_genres
    ADD CONSTRAINT gk_collections_game_game_genres_game_id_genre_id_key UNIQUE (game_id, genre_id);


--
-- Name: gk_collections_game_game_genres gk_collections_game_game_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game_genres
    ADD CONSTRAINT gk_collections_game_game_genres_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_game_game_input_types gk_collections_game_game_input_typ_game_id_gameinputtype_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game_input_types
    ADD CONSTRAINT gk_collections_game_game_input_typ_game_id_gameinputtype_id_key UNIQUE (game_id, gameinputtype_id);


--
-- Name: gk_collections_game_game_input_types gk_collections_game_game_input_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game_input_types
    ADD CONSTRAINT gk_collections_game_game_input_types_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_game_game gk_collections_game_game_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game
    ADD CONSTRAINT gk_collections_game_game_pkey PRIMARY KEY (workbase_ptr_id);


--
-- Name: gk_collections_game_game_platforms gk_collections_game_game_platforms_game_id_gameplatform_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game_platforms
    ADD CONSTRAINT gk_collections_game_game_platforms_game_id_gameplatform_id_key UNIQUE (game_id, gameplatform_id);


--
-- Name: gk_collections_game_game_platforms gk_collections_game_game_platforms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game_platforms
    ADD CONSTRAINT gk_collections_game_game_platforms_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_game_gameinputtype gk_collections_game_gameinputtype_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_gameinputtype
    ADD CONSTRAINT gk_collections_game_gameinputtype_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_game_gameplatform gk_collections_game_gameplatform_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_gameplatform
    ADD CONSTRAINT gk_collections_game_gameplatform_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_moving_image_genre gk_collections_moving_image_genre_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_moving_image_genre
    ADD CONSTRAINT gk_collections_moving_image_genre_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_moving_image_mediatype gk_collections_moving_image_mediatype_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_moving_image_mediatype
    ADD CONSTRAINT gk_collections_moving_image_mediatype_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_moving_image_movingimagework_genres gk_collections_moving_image_mov_movingimagework_id_genre_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_moving_image_movingimagework_genres
    ADD CONSTRAINT gk_collections_moving_image_mov_movingimagework_id_genre_id_key UNIQUE (movingimagework_id, genre_id);


--
-- Name: gk_collections_moving_image_movingimagework_genres gk_collections_moving_image_movingimagework_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_moving_image_movingimagework_genres
    ADD CONSTRAINT gk_collections_moving_image_movingimagework_genres_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_moving_image_movingimagework gk_collections_moving_image_movingimagework_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_moving_image_movingimagework
    ADD CONSTRAINT gk_collections_moving_image_movingimagework_pkey PRIMARY KEY (workbase_ptr_id);


--
-- Name: gk_collections_moving_image_rating gk_collections_moving_image_rating_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_moving_image_rating
    ADD CONSTRAINT gk_collections_moving_image_rating_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_organization_organizationcreator gk_collections_organization_organizationcreator_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_organization_organizationcreator
    ADD CONSTRAINT gk_collections_organization_organizationcreator_pkey PRIMARY KEY (creatorbase_ptr_id);


--
-- Name: gk_collections_person_personcreator gk_collections_person_personcreator_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_person_personcreator
    ADD CONSTRAINT gk_collections_person_personcreator_pkey PRIMARY KEY (creatorbase_ptr_id);


--
-- Name: gk_collections_work_creator_creatorbase gk_collections_work_creator_creatorb_slug_38bdbe04a998d89c_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_creatorbase
    ADD CONSTRAINT gk_collections_work_creator_creatorb_slug_38bdbe04a998d89c_uniq UNIQUE (slug, publishing_is_draft);


--
-- Name: gk_collections_work_creator_creatorbase gk_collections_work_creator_creatorbas_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_creatorbase
    ADD CONSTRAINT gk_collections_work_creator_creatorbas_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: gk_collections_work_creator_creatorbase gk_collections_work_creator_creatorbase_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_creatorbase
    ADD CONSTRAINT gk_collections_work_creator_creatorbase_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_work_creator_personcreator gk_collections_work_creator_personcreator_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_personcreator
    ADD CONSTRAINT gk_collections_work_creator_personcreator_pkey PRIMARY KEY (creatorbase_ptr_id);


--
-- Name: gk_collections_work_creator_role gk_collections_work_creator_role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_role
    ADD CONSTRAINT gk_collections_work_creator_role_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_work_creator_workcreator gk_collections_work_creator_wo_creator_id_288ce1445371d746_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workcreator
    ADD CONSTRAINT gk_collections_work_creator_wo_creator_id_288ce1445371d746_uniq UNIQUE (creator_id, work_id, role_id);


--
-- Name: gk_collections_work_creator_workbase gk_collections_work_creator_workbase_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workbase
    ADD CONSTRAINT gk_collections_work_creator_workbase_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_work_creator_workbase gk_collections_work_creator_workbase_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workbase
    ADD CONSTRAINT gk_collections_work_creator_workbase_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: gk_collections_work_creator_workbase gk_collections_work_creator_workbase_slug_1cba27cb83c661b2_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workbase
    ADD CONSTRAINT gk_collections_work_creator_workbase_slug_1cba27cb83c661b2_uniq UNIQUE (slug, publishing_is_draft);


--
-- Name: gk_collections_work_creator_workcreator gk_collections_work_creator_workcreator_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workcreator
    ADD CONSTRAINT gk_collections_work_creator_workcreator_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_work_creator_workimage gk_collections_work_creator_workimage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workimage
    ADD CONSTRAINT gk_collections_work_creator_workimage_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_work_creator_workimagetype gk_collections_work_creator_workimagetype_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workimagetype
    ADD CONSTRAINT gk_collections_work_creator_workimagetype_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_work_creator_workorigin gk_collections_work_creator_workorigin_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workorigin
    ADD CONSTRAINT gk_collections_work_creator_workorigin_pkey PRIMARY KEY (id);


--
-- Name: glamkit_collections_country glamkit_collections_country_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_collections_country
    ADD CONSTRAINT glamkit_collections_country_pkey PRIMARY KEY (id);


--
-- Name: glamkit_collections_geographiclocation glamkit_collections_geographiclocation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_collections_geographiclocation
    ADD CONSTRAINT glamkit_collections_geographiclocation_pkey PRIMARY KEY (id);


--
-- Name: glamkit_sponsors_sponsor glamkit_sponsors_sponsor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_sponsors_sponsor
    ADD CONSTRAINT glamkit_sponsors_sponsor_pkey PRIMARY KEY (id);


--
-- Name: icekit_article_article icekit_article_article_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT icekit_article_article_pkey PRIMARY KEY (id);


--
-- Name: icekit_article_article icekit_article_article_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT icekit_article_article_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: icekit_article_article icekit_article_article_slug_7899db1a04ae9135_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT icekit_article_article_slug_7899db1a04ae9135_uniq UNIQUE (slug, parent_id, publishing_linked_id);


--
-- Name: icekit_authors_author icekit_authors_author_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author
    ADD CONSTRAINT icekit_authors_author_pkey PRIMARY KEY (id);


--
-- Name: icekit_authors_author icekit_authors_author_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author
    ADD CONSTRAINT icekit_authors_author_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: icekit_event_types_simple_simpleevent icekit_event_types_simple_simpleevent_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_event_types_simple_simpleevent
    ADD CONSTRAINT icekit_event_types_simple_simpleevent_pkey PRIMARY KEY (eventbase_ptr_id);


--
-- Name: icekit_events_eventbase icekit_events_eventbase_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT icekit_events_eventbase_pkey PRIMARY KEY (id);


--
-- Name: icekit_events_eventbase icekit_events_eventbase_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT icekit_events_eventbase_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: icekit_events_eventbase_secondary_types icekit_events_eventbase_secondary_eventbase_id_eventtype_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types
    ADD CONSTRAINT icekit_events_eventbase_secondary_eventbase_id_eventtype_id_key UNIQUE (eventbase_id, eventtype_id);


--
-- Name: icekit_events_eventbase_secondary_types icekit_events_eventbase_secondary_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types
    ADD CONSTRAINT icekit_events_eventbase_secondary_types_pkey PRIMARY KEY (id);


--
-- Name: icekit_events_eventrepeatsgenerator icekit_events_eventrepeatsgenerator_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventrepeatsgenerator
    ADD CONSTRAINT icekit_events_eventrepeatsgenerator_pkey PRIMARY KEY (id);


--
-- Name: icekit_events_eventtype icekit_events_eventtype_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventtype
    ADD CONSTRAINT icekit_events_eventtype_pkey PRIMARY KEY (id);


--
-- Name: icekit_events_occurrence icekit_events_occurrence_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_occurrence
    ADD CONSTRAINT icekit_events_occurrence_pkey PRIMARY KEY (id);


--
-- Name: icekit_events_recurrencerule icekit_events_recurrencerule_description_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_recurrencerule
    ADD CONSTRAINT icekit_events_recurrencerule_description_key UNIQUE (description);


--
-- Name: icekit_events_recurrencerule icekit_events_recurrencerule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_recurrencerule
    ADD CONSTRAINT icekit_events_recurrencerule_pkey PRIMARY KEY (id);


--
-- Name: icekit_events_recurrencerule icekit_events_recurrencerule_recurrence_rule_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_recurrencerule
    ADD CONSTRAINT icekit_events_recurrencerule_recurrence_rule_key UNIQUE (recurrence_rule);


--
-- Name: icekit_layout_content_types icekit_layout_content_types_layout_id_contenttype_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types
    ADD CONSTRAINT icekit_layout_content_types_layout_id_contenttype_id_key UNIQUE (layout_id, contenttype_id);


--
-- Name: icekit_layout_content_types icekit_layout_content_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types
    ADD CONSTRAINT icekit_layout_content_types_pkey PRIMARY KEY (id);


--
-- Name: icekit_layout icekit_layout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout
    ADD CONSTRAINT icekit_layout_pkey PRIMARY KEY (id);


--
-- Name: icekit_layout icekit_layout_template_name_15bed6a42add9969_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout
    ADD CONSTRAINT icekit_layout_template_name_15bed6a42add9969_uniq UNIQUE (template_name);


--
-- Name: icekit_mediacategory icekit_mediacategory_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_mediacategory
    ADD CONSTRAINT icekit_mediacategory_name_key UNIQUE (name);


--
-- Name: icekit_mediacategory icekit_mediacategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_mediacategory
    ADD CONSTRAINT icekit_mediacategory_pkey PRIMARY KEY (id);


--
-- Name: icekit_navigation_navigation icekit_navigation_navigation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_navigation_navigation
    ADD CONSTRAINT icekit_navigation_navigation_pkey PRIMARY KEY (id);


--
-- Name: icekit_plugins_contact_person_contactperson icekit_plugins_contact_person_contactperson_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_contact_person_contactperson
    ADD CONSTRAINT icekit_plugins_contact_person_contactperson_pkey PRIMARY KEY (id);


--
-- Name: icekit_plugins_image_imagerepurposeconfig icekit_plugins_image_imagerepurposeconfig_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_imagerepurposeconfig
    ADD CONSTRAINT icekit_plugins_image_imagerepurposeconfig_pkey PRIMARY KEY (id);


--
-- Name: icekit_plugins_location_location icekit_plugins_location_location_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_location_location
    ADD CONSTRAINT icekit_plugins_location_location_pkey PRIMARY KEY (id);


--
-- Name: icekit_plugins_location_location icekit_plugins_location_location_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_location_location
    ADD CONSTRAINT icekit_plugins_location_location_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: icekit_plugins_location_location icekit_plugins_location_location_slug_13ce2ac3e71025c_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_location_location
    ADD CONSTRAINT icekit_plugins_location_location_slug_13ce2ac3e71025c_uniq UNIQUE (slug, publishing_linked_id);


--
-- Name: icekit_press_releases_pressrelease icekit_press_releases_pressrelease_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease
    ADD CONSTRAINT icekit_press_releases_pressrelease_pkey PRIMARY KEY (id);


--
-- Name: icekit_press_releases_pressrelease icekit_press_releases_pressrelease_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease
    ADD CONSTRAINT icekit_press_releases_pressrelease_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: icekit_press_releases_pressreleasecategory icekit_press_releases_pressreleasecategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressreleasecategory
    ADD CONSTRAINT icekit_press_releases_pressreleasecategory_pkey PRIMARY KEY (id);


--
-- Name: ik_event_listing_types ik_event_listing_types_eventcontentlistingitem_id_eventtype_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types
    ADD CONSTRAINT ik_event_listing_types_eventcontentlistingitem_id_eventtype_key UNIQUE (eventcontentlistingitem_id, eventtype_id);


--
-- Name: ik_event_listing_types ik_event_listing_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types
    ADD CONSTRAINT ik_event_listing_types_pkey PRIMARY KEY (id);


--
-- Name: ik_todays_occurrences_types ik_todays_occurrences_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types
    ADD CONSTRAINT ik_todays_occurrences_types_pkey PRIMARY KEY (id);


--
-- Name: ik_todays_occurrences_types ik_todays_occurrences_types_todaysoccurrences_id_eventtype__key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types
    ADD CONSTRAINT ik_todays_occurrences_types_todaysoccurrences_id_eventtype__key UNIQUE (todaysoccurrences_id, eventtype_id);


--
-- Name: icekit_plugins_image_image_categories image_image_categories_image_id_mediacategory_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories
    ADD CONSTRAINT image_image_categories_image_id_mediacategory_id_key UNIQUE (image_id, mediacategory_id);


--
-- Name: icekit_plugins_image_image_categories image_image_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories
    ADD CONSTRAINT image_image_categories_pkey PRIMARY KEY (id);


--
-- Name: icekit_plugins_image_image image_image_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image
    ADD CONSTRAINT image_image_pkey PRIMARY KEY (id);


--
-- Name: media_coverage_mediacoveragerecord media_coverage_mediacoveragerecord_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_coverage_mediacoveragerecord
    ADD CONSTRAINT media_coverage_mediacoveragerecord_pkey PRIMARY KEY (id);


--
-- Name: model_settings_boolean model_settings_boolean_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_boolean
    ADD CONSTRAINT model_settings_boolean_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_date model_settings_date_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_date
    ADD CONSTRAINT model_settings_date_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_datetime model_settings_datetime_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_datetime
    ADD CONSTRAINT model_settings_datetime_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_decimal model_settings_decimal_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_decimal
    ADD CONSTRAINT model_settings_decimal_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_file model_settings_file_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_file
    ADD CONSTRAINT model_settings_file_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_float model_settings_float_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_float
    ADD CONSTRAINT model_settings_float_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_image model_settings_image_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_image
    ADD CONSTRAINT model_settings_image_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_integer model_settings_integer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_integer
    ADD CONSTRAINT model_settings_integer_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_setting model_settings_setting_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_setting
    ADD CONSTRAINT model_settings_setting_name_key UNIQUE (name);


--
-- Name: model_settings_setting model_settings_setting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_setting
    ADD CONSTRAINT model_settings_setting_pkey PRIMARY KEY (id);


--
-- Name: model_settings_text model_settings_text_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_text
    ADD CONSTRAINT model_settings_text_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_time model_settings_time_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_time
    ADD CONSTRAINT model_settings_time_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: notifications_followerinformation notifications_followerinf_content_type_id_70f1082bab78fa53_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation
    ADD CONSTRAINT notifications_followerinf_content_type_id_70f1082bab78fa53_uniq UNIQUE (content_type_id, object_id);


--
-- Name: notifications_followerinformation_group_followers notifications_followerinforma_followerinformation_id_group__key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers
    ADD CONSTRAINT notifications_followerinforma_followerinformation_id_group__key UNIQUE (followerinformation_id, group_id);


--
-- Name: notifications_followerinformation_followers notifications_followerinforma_followerinformation_id_user_i_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers
    ADD CONSTRAINT notifications_followerinforma_followerinformation_id_user_i_key UNIQUE (followerinformation_id, user_id);


--
-- Name: notifications_followerinformation_followers notifications_followerinformation_followers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers
    ADD CONSTRAINT notifications_followerinformation_followers_pkey PRIMARY KEY (id);


--
-- Name: notifications_followerinformation_group_followers notifications_followerinformation_group_followers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers
    ADD CONSTRAINT notifications_followerinformation_group_followers_pkey PRIMARY KEY (id);


--
-- Name: notifications_followerinformation notifications_followerinformation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation
    ADD CONSTRAINT notifications_followerinformation_pkey PRIMARY KEY (id);


--
-- Name: notifications_hasreadmessage notifications_hasreadmessage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_hasreadmessage
    ADD CONSTRAINT notifications_hasreadmessage_pkey PRIMARY KEY (id);


--
-- Name: notifications_notification notifications_notification_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notification
    ADD CONSTRAINT notifications_notification_pkey PRIMARY KEY (id);


--
-- Name: notifications_notificationsetting notifications_notificationsetting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notificationsetting
    ADD CONSTRAINT notifications_notificationsetting_pkey PRIMARY KEY (id);


--
-- Name: notifications_notificationsetting notifications_notificationsetting_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notificationsetting
    ADD CONSTRAINT notifications_notificationsetting_user_id_key UNIQUE (user_id);


--
-- Name: pagetype_advancedeventlisting_advancedeventlistingpage pagetype_advancedeventlisting_advanced_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_advancedeventlisting_advancedeventlistingpage
    ADD CONSTRAINT pagetype_advancedeventlisting_advanced_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: pagetype_advancedeventlisting_advancedeventlistingpage pagetype_advancedeventlisting_advancedeventlistingpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_advancedeventlisting_advancedeventlistingpage
    ADD CONSTRAINT pagetype_advancedeventlisting_advancedeventlistingpage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: pagetype_eventlistingfordate_eventlistingpage pagetype_eventlistingfordate_eventlist_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT pagetype_eventlistingfordate_eventlist_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: pagetype_eventlistingfordate_eventlistingpage pagetype_eventlistingfordate_eventlistingpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT pagetype_eventlistingfordate_eventlistingpage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: pagetype_fluentpage_fluentpage pagetype_fluentpage_fluentpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_fluentpage_fluentpage
    ADD CONSTRAINT pagetype_fluentpage_fluentpage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: icekit_articlecategorypage pagetype_icekit_article_articlecategor_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT pagetype_icekit_article_articlecategor_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: icekit_articlecategorypage pagetype_icekit_article_articlecategorypage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT pagetype_icekit_article_articlecategorypage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: icekit_authorlisting pagetype_icekit_authors_authorlisting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT pagetype_icekit_authors_authorlisting_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: icekit_authorlisting pagetype_icekit_authors_authorlisting_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT pagetype_icekit_authors_authorlisting_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: pagetype_icekit_press_releases_pressreleaselisting pagetype_icekit_press_releases_pressre_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT pagetype_icekit_press_releases_pressre_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: pagetype_icekit_press_releases_pressreleaselisting pagetype_icekit_press_releases_pressreleaselisting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT pagetype_icekit_press_releases_pressreleaselisting_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: icekit_layoutpage pagetype_layout_page_layoutpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT pagetype_layout_page_layoutpage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: icekit_layoutpage pagetype_layout_page_layoutpage_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT pagetype_layout_page_layoutpage_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: pagetype_redirectnode_redirectnode pagetype_redirectnode_redirectnode_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_redirectnode_redirectnode
    ADD CONSTRAINT pagetype_redirectnode_redirectnode_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: icekit_searchpage pagetype_search_page_searchpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_searchpage
    ADD CONSTRAINT pagetype_search_page_searchpage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: icekit_searchpage pagetype_search_page_searchpage_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_searchpage
    ADD CONSTRAINT pagetype_search_page_searchpage_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: pagetype_textfile_textfile pagetype_textfile_textfile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_textfile_textfile
    ADD CONSTRAINT pagetype_textfile_textfile_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: polymorphic_auth_email_emailuser polymorphic_auth_email_emailuser_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_email_emailuser
    ADD CONSTRAINT polymorphic_auth_email_emailuser_email_key UNIQUE (email);


--
-- Name: polymorphic_auth_email_emailuser polymorphic_auth_email_emailuser_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_email_emailuser
    ADD CONSTRAINT polymorphic_auth_email_emailuser_pkey PRIMARY KEY (user_ptr_id);


--
-- Name: polymorphic_auth_user_groups polymorphic_auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups
    ADD CONSTRAINT polymorphic_auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: polymorphic_auth_user_groups polymorphic_auth_user_groups_user_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups
    ADD CONSTRAINT polymorphic_auth_user_groups_user_id_group_id_key UNIQUE (user_id, group_id);


--
-- Name: polymorphic_auth_user polymorphic_auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user
    ADD CONSTRAINT polymorphic_auth_user_pkey PRIMARY KEY (id);


--
-- Name: polymorphic_auth_user_user_permissions polymorphic_auth_user_user_permission_user_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions
    ADD CONSTRAINT polymorphic_auth_user_user_permission_user_id_permission_id_key UNIQUE (user_id, permission_id);


--
-- Name: polymorphic_auth_user_user_permissions polymorphic_auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions
    ADD CONSTRAINT polymorphic_auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: post_office_attachment_emails post_office_attachment_emails_attachment_id_email_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails
    ADD CONSTRAINT post_office_attachment_emails_attachment_id_email_id_key UNIQUE (attachment_id, email_id);


--
-- Name: post_office_attachment_emails post_office_attachment_emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails
    ADD CONSTRAINT post_office_attachment_emails_pkey PRIMARY KEY (id);


--
-- Name: post_office_attachment post_office_attachment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment
    ADD CONSTRAINT post_office_attachment_pkey PRIMARY KEY (id);


--
-- Name: post_office_email post_office_email_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_email
    ADD CONSTRAINT post_office_email_pkey PRIMARY KEY (id);


--
-- Name: post_office_emailtemplate post_office_emailtemplate_name_719f3a639bcd9704_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_emailtemplate
    ADD CONSTRAINT post_office_emailtemplate_name_719f3a639bcd9704_uniq UNIQUE (name, language, default_template_id);


--
-- Name: post_office_emailtemplate post_office_emailtemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_emailtemplate
    ADD CONSTRAINT post_office_emailtemplate_pkey PRIMARY KEY (id);


--
-- Name: post_office_log post_office_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_log
    ADD CONSTRAINT post_office_log_pkey PRIMARY KEY (id);


--
-- Name: redirectnode_redirectnode_translation redirectnode_redirectnode_t_language_code_2056cae8e783e3ac_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirectnode_redirectnode_translation
    ADD CONSTRAINT redirectnode_redirectnode_t_language_code_2056cae8e783e3ac_uniq UNIQUE (language_code, master_id);


--
-- Name: redirectnode_redirectnode_translation redirectnode_redirectnode_translation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirectnode_redirectnode_translation
    ADD CONSTRAINT redirectnode_redirectnode_translation_pkey PRIMARY KEY (id);


--
-- Name: response_pages_responsepage response_pages_responsepage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY response_pages_responsepage
    ADD CONSTRAINT response_pages_responsepage_pkey PRIMARY KEY (id);


--
-- Name: response_pages_responsepage response_pages_responsepage_type_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY response_pages_responsepage
    ADD CONSTRAINT response_pages_responsepage_type_key UNIQUE (type);


--
-- Name: reversion_revision reversion_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_revision
    ADD CONSTRAINT reversion_revision_pkey PRIMARY KEY (id);


--
-- Name: reversion_version reversion_version_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_version
    ADD CONSTRAINT reversion_version_pkey PRIMARY KEY (id);


--
-- Name: sharedcontent_sharedcontent sharedcontent_sharedconten_parent_site_id_33f143528080eef7_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent
    ADD CONSTRAINT sharedcontent_sharedconten_parent_site_id_33f143528080eef7_uniq UNIQUE (parent_site_id, slug);


--
-- Name: sharedcontent_sharedcontent_translation sharedcontent_sharedcontent_language_code_55687ddb33f9ca08_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent_translation
    ADD CONSTRAINT sharedcontent_sharedcontent_language_code_55687ddb33f9ca08_uniq UNIQUE (language_code, master_id);


--
-- Name: sharedcontent_sharedcontent sharedcontent_sharedcontent_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent
    ADD CONSTRAINT sharedcontent_sharedcontent_pkey PRIMARY KEY (id);


--
-- Name: sharedcontent_sharedcontent_translation sharedcontent_sharedcontent_translation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent_translation
    ADD CONSTRAINT sharedcontent_sharedcontent_translation_pkey PRIMARY KEY (id);


--
-- Name: icekit_plugins_slideshow_slideshow slideshow_slideshow_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_slideshow_slideshow
    ADD CONSTRAINT slideshow_slideshow_pkey PRIMARY KEY (id);


--
-- Name: icekit_plugins_slideshow_slideshow slideshow_slideshow_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_slideshow_slideshow
    ADD CONSTRAINT slideshow_slideshow_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: staff_profiles_department staff_profiles_department_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY staff_profiles_department
    ADD CONSTRAINT staff_profiles_department_pkey PRIMARY KEY (id);


--
-- Name: staff_profiles_staffprofile_department staff_profiles_staffprofile_d_staffprofile_id_department_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY staff_profiles_staffprofile_department
    ADD CONSTRAINT staff_profiles_staffprofile_d_staffprofile_id_department_id_key UNIQUE (staffprofile_id, department_id);


--
-- Name: staff_profiles_staffprofile_department staff_profiles_staffprofile_department_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY staff_profiles_staffprofile_department
    ADD CONSTRAINT staff_profiles_staffprofile_department_pkey PRIMARY KEY (id);


--
-- Name: staff_profiles_staffprofile staff_profiles_staffprofile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY staff_profiles_staffprofile
    ADD CONSTRAINT staff_profiles_staffprofile_pkey PRIMARY KEY (id);


--
-- Name: taggit_tag taggit_tag_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggit_tag
    ADD CONSTRAINT taggit_tag_name_key UNIQUE (name);


--
-- Name: taggit_tag taggit_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggit_tag
    ADD CONSTRAINT taggit_tag_pkey PRIMARY KEY (id);


--
-- Name: taggit_tag taggit_tag_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggit_tag
    ADD CONSTRAINT taggit_tag_slug_key UNIQUE (slug);


--
-- Name: taggit_taggeditem taggit_taggeditem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggit_taggeditem
    ADD CONSTRAINT taggit_taggeditem_pkey PRIMARY KEY (id);


--
-- Name: test_article test_article_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT test_article_pkey PRIMARY KEY (id);


--
-- Name: test_article test_article_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT test_article_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: test_articlelisting test_articlelisting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT test_articlelisting_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: test_articlelisting test_articlelisting_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT test_articlelisting_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: test_layoutpage_with_related_related_pages test_layoutpage_with_related__layoutpagewithrelatedpages_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages
    ADD CONSTRAINT test_layoutpage_with_related__layoutpagewithrelatedpages_id_key UNIQUE (layoutpagewithrelatedpages_id, page_id);


--
-- Name: test_layoutpage_with_related test_layoutpage_with_related_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT test_layoutpage_with_related_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: test_layoutpage_with_related test_layoutpage_with_related_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT test_layoutpage_with_related_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: test_layoutpage_with_related_related_pages test_layoutpage_with_related_related_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages
    ADD CONSTRAINT test_layoutpage_with_related_related_pages_pkey PRIMARY KEY (id);


--
-- Name: tests_barwithlayout tests_barwithlayout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_barwithlayout
    ADD CONSTRAINT tests_barwithlayout_pkey PRIMARY KEY (id);


--
-- Name: tests_basemodel tests_basemodel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_basemodel
    ADD CONSTRAINT tests_basemodel_pkey PRIMARY KEY (id);


--
-- Name: tests_bazwithlayout tests_bazwithlayout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_bazwithlayout
    ADD CONSTRAINT tests_bazwithlayout_pkey PRIMARY KEY (id);


--
-- Name: tests_foowithlayout tests_foowithlayout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_foowithlayout
    ADD CONSTRAINT tests_foowithlayout_pkey PRIMARY KEY (id);


--
-- Name: tests_imagetest tests_imagetest_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_imagetest
    ADD CONSTRAINT tests_imagetest_pkey PRIMARY KEY (id);


--
-- Name: tests_publishingm2mmodela tests_publishingm2mmodela_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodela
    ADD CONSTRAINT tests_publishingm2mmodela_pkey PRIMARY KEY (id);


--
-- Name: tests_publishingm2mmodela tests_publishingm2mmodela_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodela
    ADD CONSTRAINT tests_publishingm2mmodela_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: tests_publishingm2mmodelb tests_publishingm2mmodelb_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb
    ADD CONSTRAINT tests_publishingm2mmodelb_pkey PRIMARY KEY (id);


--
-- Name: tests_publishingm2mmodelb tests_publishingm2mmodelb_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb
    ADD CONSTRAINT tests_publishingm2mmodelb_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: tests_publishingm2mmodelb_related_a_models tests_publishingm2mmodelb_rel_publishingm2mmodelb_id_publis_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models
    ADD CONSTRAINT tests_publishingm2mmodelb_rel_publishingm2mmodelb_id_publis_key UNIQUE (publishingm2mmodelb_id, publishingm2mmodela_id);


--
-- Name: tests_publishingm2mmodelb_related_a_models tests_publishingm2mmodelb_related_a_models_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models
    ADD CONSTRAINT tests_publishingm2mmodelb_related_a_models_pkey PRIMARY KEY (id);


--
-- Name: tests_publishingm2mthroughtable tests_publishingm2mthroughtable_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mthroughtable
    ADD CONSTRAINT tests_publishingm2mthroughtable_pkey PRIMARY KEY (id);


--
-- Name: textfile_textfile_translation textfile_textfile_translati_language_code_6001ecbb700c76de_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY textfile_textfile_translation
    ADD CONSTRAINT textfile_textfile_translati_language_code_6001ecbb700c76de_uniq UNIQUE (language_code, master_id);


--
-- Name: textfile_textfile_translation textfile_textfile_translation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY textfile_textfile_translation
    ADD CONSTRAINT textfile_textfile_translation_pkey PRIMARY KEY (id);


--
-- Name: icekit_workflow_workflowstate workflow_workflowstate_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_workflow_workflowstate
    ADD CONSTRAINT workflow_workflowstate_pkey PRIMARY KEY (id);


--
-- Name: advanced_event_listing_page_locations_c3016fad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX advanced_event_listing_page_locations_c3016fad ON advanced_event_listing_page_locations USING btree (advancedeventlistingpage_id);


--
-- Name: advanced_event_listing_page_locations_e274a5da; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX advanced_event_listing_page_locations_e274a5da ON advanced_event_listing_page_locations USING btree (location_id);


--
-- Name: advanced_event_listing_page_primary_types_79752242; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX advanced_event_listing_page_primary_types_79752242 ON advanced_event_listing_page_primary_types USING btree (eventtype_id);


--
-- Name: advanced_event_listing_page_primary_types_c3016fad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX advanced_event_listing_page_primary_types_c3016fad ON advanced_event_listing_page_primary_types USING btree (advancedeventlistingpage_id);


--
-- Name: advanced_event_listing_page_secondary_types_79752242; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX advanced_event_listing_page_secondary_types_79752242 ON advanced_event_listing_page_secondary_types USING btree (eventtype_id);


--
-- Name: advanced_event_listing_page_secondary_types_c3016fad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX advanced_event_listing_page_secondary_types_c3016fad ON advanced_event_listing_page_secondary_types USING btree (advancedeventlistingpage_id);


--
-- Name: auth_group_name_2542f4f1d193d530_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_name_2542f4f1d193d530_like ON auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_0e939a4f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_0e939a4f ON auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_8373b171; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_8373b171 ON auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_417f1b1c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_permission_417f1b1c ON auth_permission USING btree (content_type_id);


--
-- Name: authtoken_token_key_35a3c80500624275_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX authtoken_token_key_35a3c80500624275_like ON authtoken_token USING btree (key varchar_pattern_ops);


--
-- Name: biennale_of_sydney_biennaleevent_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX biennale_of_sydney_biennaleevent_441a5015 ON biennale_of_sydney_biennaleevent USING btree (hero_image_id);


--
-- Name: biennale_of_sydney_biennaleevent_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX biennale_of_sydney_biennaleevent_72bc1be0 ON biennale_of_sydney_biennaleevent USING btree (layout_id);


--
-- Name: biennale_of_sydney_biennaleevent_9c2c8efe; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX biennale_of_sydney_biennaleevent_9c2c8efe ON biennale_of_sydney_biennaleevent USING btree (event_location_id);


--
-- Name: biennale_of_sydney_biennaleevent_works_0213cf1b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX biennale_of_sydney_biennaleevent_works_0213cf1b ON biennale_of_sydney_biennaleevent_works USING btree (workbase_id);


--
-- Name: biennale_of_sydney_biennaleevent_works_3e198cbd; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX biennale_of_sydney_biennaleevent_works_3e198cbd ON biennale_of_sydney_biennaleevent_works USING btree (biennaleevent_id);


--
-- Name: biennale_of_sydney_biennalelocation_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX biennale_of_sydney_biennalelocation_2dbcba41 ON biennale_of_sydney_biennalelocation USING btree (slug);


--
-- Name: biennale_of_sydney_biennalelocation_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX biennale_of_sydney_biennalelocation_441a5015 ON biennale_of_sydney_biennalelocation USING btree (hero_image_id);


--
-- Name: biennale_of_sydney_biennalelocation_4e98b6eb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX biennale_of_sydney_biennalelocation_4e98b6eb ON biennale_of_sydney_biennalelocation USING btree (partner_id);


--
-- Name: biennale_of_sydney_biennalelocation_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX biennale_of_sydney_biennalelocation_72bc1be0 ON biennale_of_sydney_biennalelocation USING btree (layout_id);


--
-- Name: biennale_of_sydney_biennalelocation_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX biennale_of_sydney_biennalelocation_b667876a ON biennale_of_sydney_biennalelocation USING btree (publishing_is_draft);


--
-- Name: biennale_of_sydney_biennalelocation_slug_217c1b45c41939ee_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX biennale_of_sydney_biennalelocation_slug_217c1b45c41939ee_like ON biennale_of_sydney_biennalelocation USING btree (slug varchar_pattern_ops);


--
-- Name: biennale_of_sydney_eventartist_4437cfac; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX biennale_of_sydney_eventartist_4437cfac ON biennale_of_sydney_eventartist USING btree (event_id);


--
-- Name: biennale_of_sydney_eventartist_ca949605; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX biennale_of_sydney_eventartist_ca949605 ON biennale_of_sydney_eventartist USING btree (artist_id);


--
-- Name: celery_taskmeta_662f707d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX celery_taskmeta_662f707d ON celery_taskmeta USING btree (hidden);


--
-- Name: celery_taskmeta_task_id_27a0ecc6cf26fda7_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX celery_taskmeta_task_id_27a0ecc6cf26fda7_like ON celery_taskmeta USING btree (task_id varchar_pattern_ops);


--
-- Name: celery_tasksetmeta_662f707d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX celery_tasksetmeta_662f707d ON celery_tasksetmeta USING btree (hidden);


--
-- Name: celery_tasksetmeta_taskset_id_42d7f97d524a2fcb_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX celery_tasksetmeta_taskset_id_42d7f97d524a2fcb_like ON celery_tasksetmeta USING btree (taskset_id varchar_pattern_ops);


--
-- Name: contentitem_file_fileitem_814552b9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_file_fileitem_814552b9 ON contentitem_icekit_plugins_file_fileitem USING btree (file_id);


--
-- Name: contentitem_gk_collections_links_creatorlink_82bfda79; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_gk_collections_links_creatorlink_82bfda79 ON contentitem_gk_collections_links_creatorlink USING btree (item_id);


--
-- Name: contentitem_gk_collections_links_worklink_82bfda79; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_gk_collections_links_worklink_82bfda79 ON contentitem_gk_collections_links_worklink USING btree (item_id);


--
-- Name: contentitem_glamkit_sponsors_sponsorpromoitem_42545d36; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_glamkit_sponsors_sponsorpromoitem_42545d36 ON contentitem_glamkit_sponsors_sponsorpromoitem USING btree (sponsor_id);


--
-- Name: contentitem_icekit_events_links_eventlink_82bfda79; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_icekit_events_links_eventlink_82bfda79 ON contentitem_icekit_events_links_eventlink USING btree (item_id);


--
-- Name: contentitem_icekit_plugins_contact_person_contactpersonitemff5b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_icekit_plugins_contact_person_contactpersonitemff5b ON contentitem_icekit_plugins_contact_person_contactpersonitem USING btree (contact_id);


--
-- Name: contentitem_icekit_plugins_content_listing_contentlistingit9442; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_icekit_plugins_content_listing_contentlistingit9442 ON contentitem_icekit_plugins_content_listing_contentlistingitem USING btree (content_type_id);


--
-- Name: contentitem_icekit_plugins_location_locationitem_e274a5da; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_icekit_plugins_location_locationitem_e274a5da ON contentitem_icekit_plugins_location_locationitem USING btree (location_id);


--
-- Name: contentitem_ik_event_listing_eventcontentlistingitem_417f1b1c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_ik_event_listing_eventcontentlistingitem_417f1b1c ON contentitem_ik_event_listing_eventcontentlistingitem USING btree (content_type_id);


--
-- Name: contentitem_ik_links_articlelink_82bfda79; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_ik_links_articlelink_82bfda79 ON contentitem_ik_links_articlelink USING btree (item_id);


--
-- Name: contentitem_ik_links_authorlink_82bfda79; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_ik_links_authorlink_82bfda79 ON contentitem_ik_links_authorlink USING btree (item_id);


--
-- Name: contentitem_ik_links_pagelink_82bfda79; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_ik_links_pagelink_82bfda79 ON contentitem_ik_links_pagelink USING btree (item_id);


--
-- Name: contentitem_image_gallery_imagegalleryshowitem_e2c5ae20; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_image_gallery_imagegalleryshowitem_e2c5ae20 ON contentitem_image_gallery_imagegalleryshowitem USING btree (slide_show_id);


--
-- Name: contentitem_image_imageitem_f33175e6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_image_imageitem_f33175e6 ON contentitem_icekit_plugins_image_imageitem USING btree (image_id);


--
-- Name: contentitem_media_coverage_mediacoveragepromoitem_76d3d8fd; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_media_coverage_mediacoveragepromoitem_76d3d8fd ON contentitem_media_coverage_mediacoveragepromoitem USING btree (media_coverage_id);


--
-- Name: contentitem_reusable_form_formitem_d6cba1ad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_reusable_form_formitem_d6cba1ad ON contentitem_icekit_plugins_reusable_form_formitem USING btree (form_id);


--
-- Name: contentitem_sharedcontent_sharedcontentitem_9855ad04; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_sharedcontent_sharedcontentitem_9855ad04 ON contentitem_sharedcontent_sharedcontentitem USING btree (shared_content_id);


--
-- Name: contentitem_slideshow_slideshowitem_e2c5ae20; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_slideshow_slideshowitem_e2c5ae20 ON contentitem_icekit_plugins_slideshow_slideshowitem USING btree (slide_show_id);


--
-- Name: django_admin_log_417f1b1c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_417f1b1c ON django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_e8701ad4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_e8701ad4 ON django_admin_log USING btree (user_id);


--
-- Name: django_redirect_91a0b591; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_redirect_91a0b591 ON django_redirect USING btree (old_path);


--
-- Name: django_redirect_9365d6e7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_redirect_9365d6e7 ON django_redirect USING btree (site_id);


--
-- Name: django_redirect_old_path_62f4319ab4e32d43_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_redirect_old_path_62f4319ab4e32d43_like ON django_redirect USING btree (old_path varchar_pattern_ops);


--
-- Name: django_session_de54fa62; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_de54fa62 ON django_session USING btree (expire_date);


--
-- Name: django_session_session_key_3b72e33cf90b7252_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_session_key_3b72e33cf90b7252_like ON django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: djcelery_periodictask_1dcd7040; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_periodictask_1dcd7040 ON djcelery_periodictask USING btree (interval_id);


--
-- Name: djcelery_periodictask_f3f0d72a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_periodictask_f3f0d72a ON djcelery_periodictask USING btree (crontab_id);


--
-- Name: djcelery_periodictask_name_33650d8ab9340e64_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_periodictask_name_33650d8ab9340e64_like ON djcelery_periodictask USING btree (name varchar_pattern_ops);


--
-- Name: djcelery_taskstate_662f707d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_662f707d ON djcelery_taskstate USING btree (hidden);


--
-- Name: djcelery_taskstate_863bb2ee; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_863bb2ee ON djcelery_taskstate USING btree (tstamp);


--
-- Name: djcelery_taskstate_9ed39e2e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_9ed39e2e ON djcelery_taskstate USING btree (state);


--
-- Name: djcelery_taskstate_b068931c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_b068931c ON djcelery_taskstate USING btree (name);


--
-- Name: djcelery_taskstate_ce77e6ef; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_ce77e6ef ON djcelery_taskstate USING btree (worker_id);


--
-- Name: djcelery_taskstate_name_457fb31f71f1ed57_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_name_457fb31f71f1ed57_like ON djcelery_taskstate USING btree (name varchar_pattern_ops);


--
-- Name: djcelery_taskstate_state_6f3f3933ed0ea6de_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_state_6f3f3933ed0ea6de_like ON djcelery_taskstate USING btree (state varchar_pattern_ops);


--
-- Name: djcelery_taskstate_task_id_412c032fb4c7ae9e_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_task_id_412c032fb4c7ae9e_like ON djcelery_taskstate USING btree (task_id varchar_pattern_ops);


--
-- Name: djcelery_workerstate_f129901a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_workerstate_f129901a ON djcelery_workerstate USING btree (last_heartbeat);


--
-- Name: djcelery_workerstate_hostname_1ff2e9a527b4c01a_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_workerstate_hostname_1ff2e9a527b4c01a_like ON djcelery_workerstate USING btree (hostname varchar_pattern_ops);


--
-- Name: djkombu_message_46cf0e59; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djkombu_message_46cf0e59 ON djkombu_message USING btree (visible);


--
-- Name: djkombu_message_75249aa1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djkombu_message_75249aa1 ON djkombu_message USING btree (queue_id);


--
-- Name: djkombu_message_df2f2974; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djkombu_message_df2f2974 ON djkombu_message USING btree (sent_at);


--
-- Name: djkombu_queue_name_4d6ee8e02fb474df_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djkombu_queue_name_4d6ee8e02fb474df_like ON djkombu_queue USING btree (name varchar_pattern_ops);


--
-- Name: easy_thumbnails_source_b068931c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_source_b068931c ON easy_thumbnails_source USING btree (name);


--
-- Name: easy_thumbnails_source_b454e115; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_source_b454e115 ON easy_thumbnails_source USING btree (storage_hash);


--
-- Name: easy_thumbnails_source_name_7f52841040d12600_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_source_name_7f52841040d12600_like ON easy_thumbnails_source USING btree (name varchar_pattern_ops);


--
-- Name: easy_thumbnails_source_storage_hash_46d411ad46132e93_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_source_storage_hash_46d411ad46132e93_like ON easy_thumbnails_source USING btree (storage_hash varchar_pattern_ops);


--
-- Name: easy_thumbnails_thumbnail_0afd9202; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_thumbnail_0afd9202 ON easy_thumbnails_thumbnail USING btree (source_id);


--
-- Name: easy_thumbnails_thumbnail_b068931c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_thumbnail_b068931c ON easy_thumbnails_thumbnail USING btree (name);


--
-- Name: easy_thumbnails_thumbnail_b454e115; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_thumbnail_b454e115 ON easy_thumbnails_thumbnail USING btree (storage_hash);


--
-- Name: easy_thumbnails_thumbnail_name_318f5b5e3f8dde84_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_thumbnail_name_318f5b5e3f8dde84_like ON easy_thumbnails_thumbnail USING btree (name varchar_pattern_ops);


--
-- Name: easy_thumbnails_thumbnail_storage_hash_637276e146728f49_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_thumbnail_storage_hash_637276e146728f49_like ON easy_thumbnails_thumbnail USING btree (storage_hash varchar_pattern_ops);


--
-- Name: file_file_categories_814552b9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX file_file_categories_814552b9 ON icekit_plugins_file_file_categories USING btree (file_id);


--
-- Name: file_file_categories_a1a67fb1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX file_file_categories_a1a67fb1 ON icekit_plugins_file_file_categories USING btree (mediacategory_id);


--
-- Name: fluent_contents_contentitem_2e3c0484; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_contentitem_2e3c0484 ON fluent_contents_contentitem USING btree (parent_type_id);


--
-- Name: fluent_contents_contentitem_60716c2f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_contentitem_60716c2f ON fluent_contents_contentitem USING btree (language_code);


--
-- Name: fluent_contents_contentitem_667a6151; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_contentitem_667a6151 ON fluent_contents_contentitem USING btree (placeholder_id);


--
-- Name: fluent_contents_contentitem_a73f1f77; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_contentitem_a73f1f77 ON fluent_contents_contentitem USING btree (sort_order);


--
-- Name: fluent_contents_contentitem_d3e32c49; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_contentitem_d3e32c49 ON fluent_contents_contentitem USING btree (polymorphic_ctype_id);


--
-- Name: fluent_contents_contentitem_language_code_6e79eb7ffc08c79_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_contentitem_language_code_6e79eb7ffc08c79_like ON fluent_contents_contentitem USING btree (language_code varchar_pattern_ops);


--
-- Name: fluent_contents_placeholder_2e3c0484; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_placeholder_2e3c0484 ON fluent_contents_placeholder USING btree (parent_type_id);


--
-- Name: fluent_contents_placeholder_5e97994e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_placeholder_5e97994e ON fluent_contents_placeholder USING btree (slot);


--
-- Name: fluent_contents_placeholder_slot_78ede225d746896d_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_placeholder_slot_78ede225d746896d_like ON fluent_contents_placeholder USING btree (slot varchar_pattern_ops);


--
-- Name: fluent_pages_htmlpage_trans_language_code_6d6c7168b720df89_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_htmlpage_trans_language_code_6d6c7168b720df89_like ON fluent_pages_htmlpage_translation USING btree (language_code varchar_pattern_ops);


--
-- Name: fluent_pages_htmlpage_translation_60716c2f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_htmlpage_translation_60716c2f ON fluent_pages_htmlpage_translation USING btree (language_code);


--
-- Name: fluent_pages_htmlpage_translation_90349b61; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_htmlpage_translation_90349b61 ON fluent_pages_htmlpage_translation USING btree (master_id);


--
-- Name: fluent_pages_pagelayout_3c6e0b8a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_pagelayout_3c6e0b8a ON fluent_pages_pagelayout USING btree (key);


--
-- Name: fluent_pages_pagelayout_key_14e6dfd28da1f33d_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_pagelayout_key_14e6dfd28da1f33d_like ON fluent_pages_pagelayout USING btree (key varchar_pattern_ops);


--
-- Name: fluent_pages_urlnode_0b39ac3a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_0b39ac3a ON fluent_pages_urlnode USING btree (in_sitemaps);


--
-- Name: fluent_pages_urlnode_2247c5f0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_2247c5f0 ON fluent_pages_urlnode USING btree (publication_end_date);


--
-- Name: fluent_pages_urlnode_3c6e0b8a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_3c6e0b8a ON fluent_pages_urlnode USING btree (key);


--
-- Name: fluent_pages_urlnode_3cfbd988; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_3cfbd988 ON fluent_pages_urlnode USING btree (rght);


--
-- Name: fluent_pages_urlnode_4e147804; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_4e147804 ON fluent_pages_urlnode USING btree (parent_site_id);


--
-- Name: fluent_pages_urlnode_4f331e2f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_4f331e2f ON fluent_pages_urlnode USING btree (author_id);


--
-- Name: fluent_pages_urlnode_656442a0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_656442a0 ON fluent_pages_urlnode USING btree (tree_id);


--
-- Name: fluent_pages_urlnode_6be37982; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_6be37982 ON fluent_pages_urlnode USING btree (parent_id);


--
-- Name: fluent_pages_urlnode_93b83098; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_93b83098 ON fluent_pages_urlnode USING btree (publication_date);


--
-- Name: fluent_pages_urlnode_9acb4454; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_9acb4454 ON fluent_pages_urlnode USING btree (status);


--
-- Name: fluent_pages_urlnode_c9e9a848; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_c9e9a848 ON fluent_pages_urlnode USING btree (level);


--
-- Name: fluent_pages_urlnode_caf7cc51; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_caf7cc51 ON fluent_pages_urlnode USING btree (lft);


--
-- Name: fluent_pages_urlnode_d3e32c49; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_d3e32c49 ON fluent_pages_urlnode USING btree (polymorphic_ctype_id);


--
-- Name: fluent_pages_urlnode_db3eb53f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_db3eb53f ON fluent_pages_urlnode USING btree (in_navigation);


--
-- Name: fluent_pages_urlnode_key_5fd6b2b46435063e_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_key_5fd6b2b46435063e_like ON fluent_pages_urlnode USING btree (key varchar_pattern_ops);


--
-- Name: fluent_pages_urlnode_status_9890769c90b472_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_status_9890769c90b472_like ON fluent_pages_urlnode USING btree (status varchar_pattern_ops);


--
-- Name: fluent_pages_urlnode_transl_language_code_119ca012f2f4ac45_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_transl_language_code_119ca012f2f4ac45_like ON fluent_pages_urlnode_translation USING btree (language_code varchar_pattern_ops);


--
-- Name: fluent_pages_urlnode_translat__cached_url_4cb6cc6ff0ea98dc_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_translat__cached_url_4cb6cc6ff0ea98dc_like ON fluent_pages_urlnode_translation USING btree (_cached_url varchar_pattern_ops);


--
-- Name: fluent_pages_urlnode_translation_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_translation_2dbcba41 ON fluent_pages_urlnode_translation USING btree (slug);


--
-- Name: fluent_pages_urlnode_translation_60716c2f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_translation_60716c2f ON fluent_pages_urlnode_translation USING btree (language_code);


--
-- Name: fluent_pages_urlnode_translation_90349b61; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_translation_90349b61 ON fluent_pages_urlnode_translation USING btree (master_id);


--
-- Name: fluent_pages_urlnode_translation_f2efa396; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_translation_f2efa396 ON fluent_pages_urlnode_translation USING btree (_cached_url);


--
-- Name: fluent_pages_urlnode_translation_slug_7453994c8a581a25_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_translation_slug_7453994c8a581a25_like ON fluent_pages_urlnode_translation USING btree (slug varchar_pattern_ops);


--
-- Name: forms_field_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_field_2dbcba41 ON forms_field USING btree (slug);


--
-- Name: forms_field_d6cba1ad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_field_d6cba1ad ON forms_field USING btree (form_id);


--
-- Name: forms_field_slug_1b52f4021b2f4469_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_field_slug_1b52f4021b2f4469_like ON forms_field USING btree (slug varchar_pattern_ops);


--
-- Name: forms_fieldentry_b64a62ea; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_fieldentry_b64a62ea ON forms_fieldentry USING btree (entry_id);


--
-- Name: forms_form_sites_9365d6e7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_form_sites_9365d6e7 ON forms_form_sites USING btree (site_id);


--
-- Name: forms_form_sites_d6cba1ad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_form_sites_d6cba1ad ON forms_form_sites USING btree (form_id);


--
-- Name: forms_form_slug_4b0b6cef5919dbd0_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_form_slug_4b0b6cef5919dbd0_like ON forms_form USING btree (slug varchar_pattern_ops);


--
-- Name: forms_formentry_d6cba1ad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_formentry_d6cba1ad ON forms_formentry USING btree (form_id);


--
-- Name: gk_collections_film_film_183208e5; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_film_film_183208e5 ON gk_collections_film_film USING btree (media_type_id);


--
-- Name: gk_collections_film_film_c14e3df7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_film_film_c14e3df7 ON gk_collections_film_film USING btree (rating_id);


--
-- Name: gk_collections_film_film_formats_cd2a3d01; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_film_film_formats_cd2a3d01 ON gk_collections_film_film_formats USING btree (film_id);


--
-- Name: gk_collections_film_film_formats_f2fa2147; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_film_film_formats_f2fa2147 ON gk_collections_film_film_formats USING btree (format_id);


--
-- Name: gk_collections_film_film_genres_080a38f3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_film_film_genres_080a38f3 ON gk_collections_film_film_genres USING btree (genre_id);


--
-- Name: gk_collections_film_film_genres_cd2a3d01; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_film_film_genres_cd2a3d01 ON gk_collections_film_film_genres USING btree (film_id);


--
-- Name: gk_collections_film_format_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_film_format_2dbcba41 ON gk_collections_film_format USING btree (slug);


--
-- Name: gk_collections_film_format_slug_6b05968663e634c3_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_film_format_slug_6b05968663e634c3_like ON gk_collections_film_format USING btree (slug varchar_pattern_ops);


--
-- Name: gk_collections_game_game_183208e5; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_game_game_183208e5 ON gk_collections_game_game USING btree (media_type_id);


--
-- Name: gk_collections_game_game_c14e3df7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_game_game_c14e3df7 ON gk_collections_game_game USING btree (rating_id);


--
-- Name: gk_collections_game_game_genres_080a38f3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_game_game_genres_080a38f3 ON gk_collections_game_game_genres USING btree (genre_id);


--
-- Name: gk_collections_game_game_genres_6072f8b3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_game_game_genres_6072f8b3 ON gk_collections_game_game_genres USING btree (game_id);


--
-- Name: gk_collections_game_game_input_types_0675d79d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_game_game_input_types_0675d79d ON gk_collections_game_game_input_types USING btree (gameinputtype_id);


--
-- Name: gk_collections_game_game_input_types_6072f8b3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_game_game_input_types_6072f8b3 ON gk_collections_game_game_input_types USING btree (game_id);


--
-- Name: gk_collections_game_game_platforms_46c9c2d4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_game_game_platforms_46c9c2d4 ON gk_collections_game_game_platforms USING btree (gameplatform_id);


--
-- Name: gk_collections_game_game_platforms_6072f8b3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_game_game_platforms_6072f8b3 ON gk_collections_game_game_platforms USING btree (game_id);


--
-- Name: gk_collections_game_gameinputtype_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_game_gameinputtype_2dbcba41 ON gk_collections_game_gameinputtype USING btree (slug);


--
-- Name: gk_collections_game_gameinputtype_slug_d0f8b99db3cde59_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_game_gameinputtype_slug_d0f8b99db3cde59_like ON gk_collections_game_gameinputtype USING btree (slug varchar_pattern_ops);


--
-- Name: gk_collections_game_gameplatform_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_game_gameplatform_2dbcba41 ON gk_collections_game_gameplatform USING btree (slug);


--
-- Name: gk_collections_game_gameplatform_slug_131f8feff6833a45_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_game_gameplatform_slug_131f8feff6833a45_like ON gk_collections_game_gameplatform USING btree (slug varchar_pattern_ops);


--
-- Name: gk_collections_moving_image_genre_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_moving_image_genre_2dbcba41 ON gk_collections_moving_image_genre USING btree (slug);


--
-- Name: gk_collections_moving_image_genre_slug_e539f5a4dacf018_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_moving_image_genre_slug_e539f5a4dacf018_like ON gk_collections_moving_image_genre USING btree (slug varchar_pattern_ops);


--
-- Name: gk_collections_moving_image_mediatyp_slug_30308c83f51a0d59_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_moving_image_mediatyp_slug_30308c83f51a0d59_like ON gk_collections_moving_image_mediatype USING btree (slug varchar_pattern_ops);


--
-- Name: gk_collections_moving_image_mediatype_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_moving_image_mediatype_2dbcba41 ON gk_collections_moving_image_mediatype USING btree (slug);


--
-- Name: gk_collections_moving_image_movingimagework_183208e5; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_moving_image_movingimagework_183208e5 ON gk_collections_moving_image_movingimagework USING btree (media_type_id);


--
-- Name: gk_collections_moving_image_movingimagework_c14e3df7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_moving_image_movingimagework_c14e3df7 ON gk_collections_moving_image_movingimagework USING btree (rating_id);


--
-- Name: gk_collections_moving_image_movingimagework_genres_080a38f3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_moving_image_movingimagework_genres_080a38f3 ON gk_collections_moving_image_movingimagework_genres USING btree (genre_id);


--
-- Name: gk_collections_moving_image_movingimagework_genres_61699a61; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_moving_image_movingimagework_genres_61699a61 ON gk_collections_moving_image_movingimagework_genres USING btree (movingimagework_id);


--
-- Name: gk_collections_moving_image_rating_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_moving_image_rating_2dbcba41 ON gk_collections_moving_image_rating USING btree (slug);


--
-- Name: gk_collections_moving_image_rating_slug_7cd4ca50d9cdf5d3_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_moving_image_rating_slug_7cd4ca50d9cdf5d3_like ON gk_collections_moving_image_rating USING btree (slug varchar_pattern_ops);


--
-- Name: gk_collections_work_creator_crea_alt_slug_11625d4df9d30962_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_crea_alt_slug_11625d4df9d30962_like ON gk_collections_work_creator_creatorbase USING btree (alt_slug varchar_pattern_ops);


--
-- Name: gk_collections_work_creator_creatorb_slug_40eec63e2b85cc46_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_creatorb_slug_40eec63e2b85cc46_like ON gk_collections_work_creator_creatorbase USING btree (slug varchar_pattern_ops);


--
-- Name: gk_collections_work_creator_creatorbase_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_creatorbase_2dbcba41 ON gk_collections_work_creator_creatorbase USING btree (slug);


--
-- Name: gk_collections_work_creator_creatorbase_5c907d8c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_creatorbase_5c907d8c ON gk_collections_work_creator_creatorbase USING btree (alt_slug);


--
-- Name: gk_collections_work_creator_creatorbase_6968df0c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_creatorbase_6968df0c ON gk_collections_work_creator_creatorbase USING btree (portrait_id);


--
-- Name: gk_collections_work_creator_creatorbase_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_creatorbase_72bc1be0 ON gk_collections_work_creator_creatorbase USING btree (layout_id);


--
-- Name: gk_collections_work_creator_creatorbase_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_creatorbase_b667876a ON gk_collections_work_creator_creatorbase USING btree (publishing_is_draft);


--
-- Name: gk_collections_work_creator_creatorbase_d3e32c49; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_creatorbase_d3e32c49 ON gk_collections_work_creator_creatorbase USING btree (polymorphic_ctype_id);


--
-- Name: gk_collections_work_creator_role_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_role_2dbcba41 ON gk_collections_work_creator_role USING btree (slug);


--
-- Name: gk_collections_work_creator_role_slug_557a1e9cd55d539c_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_role_slug_557a1e9cd55d539c_like ON gk_collections_work_creator_role USING btree (slug varchar_pattern_ops);


--
-- Name: gk_collections_work_creator_work_alt_slug_696de9d3b1fea4ec_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_work_alt_slug_696de9d3b1fea4ec_like ON gk_collections_work_creator_workbase USING btree (alt_slug varchar_pattern_ops);


--
-- Name: gk_collections_work_creator_workbase_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workbase_2dbcba41 ON gk_collections_work_creator_workbase USING btree (slug);


--
-- Name: gk_collections_work_creator_workbase_5c907d8c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workbase_5c907d8c ON gk_collections_work_creator_workbase USING btree (alt_slug);


--
-- Name: gk_collections_work_creator_workbase_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workbase_72bc1be0 ON gk_collections_work_creator_workbase USING btree (layout_id);


--
-- Name: gk_collections_work_creator_workbase_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workbase_b667876a ON gk_collections_work_creator_workbase USING btree (publishing_is_draft);


--
-- Name: gk_collections_work_creator_workbase_d3e32c49; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workbase_d3e32c49 ON gk_collections_work_creator_workbase USING btree (polymorphic_ctype_id);


--
-- Name: gk_collections_work_creator_workbase_slug_1276aa6b9c14d1e4_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workbase_slug_1276aa6b9c14d1e4_like ON gk_collections_work_creator_workbase USING btree (slug varchar_pattern_ops);


--
-- Name: gk_collections_work_creator_workcreator_3700153c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workcreator_3700153c ON gk_collections_work_creator_workcreator USING btree (creator_id);


--
-- Name: gk_collections_work_creator_workcreator_84566833; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workcreator_84566833 ON gk_collections_work_creator_workcreator USING btree (role_id);


--
-- Name: gk_collections_work_creator_workcreator_84c7ac35; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workcreator_84c7ac35 ON gk_collections_work_creator_workcreator USING btree (work_id);


--
-- Name: gk_collections_work_creator_workimag_slug_6285fb3bf3c2ce81_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workimag_slug_6285fb3bf3c2ce81_like ON gk_collections_work_creator_workimagetype USING btree (slug varchar_pattern_ops);


--
-- Name: gk_collections_work_creator_workimage_84c7ac35; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workimage_84c7ac35 ON gk_collections_work_creator_workimage USING btree (work_id);


--
-- Name: gk_collections_work_creator_workimage_94757cae; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workimage_94757cae ON gk_collections_work_creator_workimage USING btree (type_id);


--
-- Name: gk_collections_work_creator_workimage_f33175e6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workimage_f33175e6 ON gk_collections_work_creator_workimage USING btree (image_id);


--
-- Name: gk_collections_work_creator_workimagetype_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workimagetype_2dbcba41 ON gk_collections_work_creator_workimagetype USING btree (slug);


--
-- Name: gk_collections_work_creator_workorigin_84c7ac35; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workorigin_84c7ac35 ON gk_collections_work_creator_workorigin USING btree (work_id);


--
-- Name: gk_collections_work_creator_workorigin_9d0222b2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workorigin_9d0222b2 ON gk_collections_work_creator_workorigin USING btree (geographic_location_id);


--
-- Name: glamkit_collections_country_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX glamkit_collections_country_2dbcba41 ON glamkit_collections_country USING btree (slug);


--
-- Name: glamkit_collections_country_slug_1351206a27b079a5_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX glamkit_collections_country_slug_1351206a27b079a5_like ON glamkit_collections_country USING btree (slug varchar_pattern_ops);


--
-- Name: glamkit_collections_geographiclocati_slug_2ed330985c0dfefc_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX glamkit_collections_geographiclocati_slug_2ed330985c0dfefc_like ON glamkit_collections_geographiclocation USING btree (slug varchar_pattern_ops);


--
-- Name: glamkit_collections_geographiclocation_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX glamkit_collections_geographiclocation_2dbcba41 ON glamkit_collections_geographiclocation USING btree (slug);


--
-- Name: glamkit_collections_geographiclocation_93bfec8a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX glamkit_collections_geographiclocation_93bfec8a ON glamkit_collections_geographiclocation USING btree (country_id);


--
-- Name: glamkit_sponsors_sponsor_8c0ff365; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX glamkit_sponsors_sponsor_8c0ff365 ON glamkit_sponsors_sponsor USING btree (logo_id);


--
-- Name: icekit_article_article_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_article_article_2dbcba41 ON icekit_article_article USING btree (slug);


--
-- Name: icekit_article_article_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_article_article_441a5015 ON icekit_article_article USING btree (hero_image_id);


--
-- Name: icekit_article_article_6be37982; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_article_article_6be37982 ON icekit_article_article USING btree (parent_id);


--
-- Name: icekit_article_article_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_article_article_72bc1be0 ON icekit_article_article USING btree (layout_id);


--
-- Name: icekit_article_article_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_article_article_b667876a ON icekit_article_article USING btree (publishing_is_draft);


--
-- Name: icekit_article_article_slug_55663dde3c557fe7_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_article_article_slug_55663dde3c557fe7_like ON icekit_article_article USING btree (slug varchar_pattern_ops);


--
-- Name: icekit_authors_author_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_authors_author_2dbcba41 ON icekit_authors_author USING btree (slug);


--
-- Name: icekit_authors_author_6968df0c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_authors_author_6968df0c ON icekit_authors_author USING btree (hero_image_id);


--
-- Name: icekit_authors_author_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_authors_author_b667876a ON icekit_authors_author USING btree (publishing_is_draft);


--
-- Name: icekit_authors_author_slug_30b23d53d3944c61_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_authors_author_slug_30b23d53d3944c61_like ON icekit_authors_author USING btree (slug varchar_pattern_ops);


--
-- Name: icekit_event_types_simple_simpleevent_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_event_types_simple_simpleevent_441a5015 ON icekit_event_types_simple_simpleevent USING btree (hero_image_id);


--
-- Name: icekit_event_types_simple_simpleevent_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_event_types_simple_simpleevent_72bc1be0 ON icekit_event_types_simple_simpleevent USING btree (layout_id);


--
-- Name: icekit_events_eventbase_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_2dbcba41 ON icekit_events_eventbase USING btree (slug);


--
-- Name: icekit_events_eventbase_6cad1465; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_6cad1465 ON icekit_events_eventbase USING btree (part_of_id);


--
-- Name: icekit_events_eventbase_7af97c1b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_7af97c1b ON icekit_events_eventbase USING btree (primary_type_id);


--
-- Name: icekit_events_eventbase_7fa10fbf; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_7fa10fbf ON icekit_events_eventbase USING btree (derived_from_id);


--
-- Name: icekit_events_eventbase_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_9ae73c65 ON icekit_events_eventbase USING btree (modified);


--
-- Name: icekit_events_eventbase_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_b667876a ON icekit_events_eventbase USING btree (publishing_is_draft);


--
-- Name: icekit_events_eventbase_d3e32c49; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_d3e32c49 ON icekit_events_eventbase USING btree (polymorphic_ctype_id);


--
-- Name: icekit_events_eventbase_e274a5da; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_e274a5da ON icekit_events_eventbase USING btree (location_id);


--
-- Name: icekit_events_eventbase_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_e2fa5388 ON icekit_events_eventbase USING btree (created);


--
-- Name: icekit_events_eventbase_secondary_types_09b50619; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_secondary_types_09b50619 ON icekit_events_eventbase_secondary_types USING btree (eventbase_id);


--
-- Name: icekit_events_eventbase_secondary_types_79752242; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_secondary_types_79752242 ON icekit_events_eventbase_secondary_types USING btree (eventtype_id);


--
-- Name: icekit_events_eventbase_slug_68725dec8be344e6_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_slug_68725dec8be344e6_like ON icekit_events_eventbase USING btree (slug varchar_pattern_ops);


--
-- Name: icekit_events_eventrepeatsgenerator_32f63e2e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventrepeatsgenerator_32f63e2e ON icekit_events_eventrepeatsgenerator USING btree (is_all_day);


--
-- Name: icekit_events_eventrepeatsgenerator_4437cfac; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventrepeatsgenerator_4437cfac ON icekit_events_eventrepeatsgenerator USING btree (event_id);


--
-- Name: icekit_events_eventrepeatsgenerator_7f021a14; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventrepeatsgenerator_7f021a14 ON icekit_events_eventrepeatsgenerator USING btree ("end");


--
-- Name: icekit_events_eventrepeatsgenerator_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventrepeatsgenerator_9ae73c65 ON icekit_events_eventrepeatsgenerator USING btree (modified);


--
-- Name: icekit_events_eventrepeatsgenerator_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventrepeatsgenerator_e2fa5388 ON icekit_events_eventrepeatsgenerator USING btree (created);


--
-- Name: icekit_events_eventrepeatsgenerator_ea2b2676; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventrepeatsgenerator_ea2b2676 ON icekit_events_eventrepeatsgenerator USING btree (start);


--
-- Name: icekit_events_eventtype_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventtype_2dbcba41 ON icekit_events_eventtype USING btree (slug);


--
-- Name: icekit_events_eventtype_slug_13a819bd8b959b21_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventtype_slug_13a819bd8b959b21_like ON icekit_events_eventtype USING btree (slug varchar_pattern_ops);


--
-- Name: icekit_events_occurrence_213f2807; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_occurrence_213f2807 ON icekit_events_occurrence USING btree (is_protected_from_regeneration);


--
-- Name: icekit_events_occurrence_32f63e2e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_occurrence_32f63e2e ON icekit_events_occurrence USING btree (is_all_day);


--
-- Name: icekit_events_occurrence_4437cfac; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_occurrence_4437cfac ON icekit_events_occurrence USING btree (event_id);


--
-- Name: icekit_events_occurrence_5a9e8819; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_occurrence_5a9e8819 ON icekit_events_occurrence USING btree (generator_id);


--
-- Name: icekit_events_occurrence_7f021a14; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_occurrence_7f021a14 ON icekit_events_occurrence USING btree ("end");


--
-- Name: icekit_events_occurrence_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_occurrence_9ae73c65 ON icekit_events_occurrence USING btree (modified);


--
-- Name: icekit_events_occurrence_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_occurrence_e2fa5388 ON icekit_events_occurrence USING btree (created);


--
-- Name: icekit_events_occurrence_ea2b2676; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_occurrence_ea2b2676 ON icekit_events_occurrence USING btree (start);


--
-- Name: icekit_events_recurrencer_recurrence_rule_1a3d37ab149fdd07_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_recurrencer_recurrence_rule_1a3d37ab149fdd07_like ON icekit_events_recurrencerule USING btree (recurrence_rule text_pattern_ops);


--
-- Name: icekit_events_recurrencerule_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_recurrencerule_9ae73c65 ON icekit_events_recurrencerule USING btree (modified);


--
-- Name: icekit_events_recurrencerule_description_939e01506672716_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_recurrencerule_description_939e01506672716_like ON icekit_events_recurrencerule USING btree (description text_pattern_ops);


--
-- Name: icekit_events_recurrencerule_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_recurrencerule_e2fa5388 ON icekit_events_recurrencerule USING btree (created);


--
-- Name: icekit_layout_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_layout_9ae73c65 ON icekit_layout USING btree (modified);


--
-- Name: icekit_layout_content_types_17321e91; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_layout_content_types_17321e91 ON icekit_layout_content_types USING btree (contenttype_id);


--
-- Name: icekit_layout_content_types_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_layout_content_types_72bc1be0 ON icekit_layout_content_types USING btree (layout_id);


--
-- Name: icekit_layout_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_layout_e2fa5388 ON icekit_layout USING btree (created);


--
-- Name: icekit_layout_template_name_15bed6a42add9969_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_layout_template_name_15bed6a42add9969_like ON icekit_layout USING btree (template_name varchar_pattern_ops);


--
-- Name: icekit_mediacategory_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_mediacategory_9ae73c65 ON icekit_mediacategory USING btree (modified);


--
-- Name: icekit_mediacategory_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_mediacategory_e2fa5388 ON icekit_mediacategory USING btree (created);


--
-- Name: icekit_mediacategory_name_1427d258ad1c40d6_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_mediacategory_name_1427d258ad1c40d6_like ON icekit_mediacategory USING btree (name varchar_pattern_ops);


--
-- Name: icekit_navigation_navigation_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_navigation_navigation_2dbcba41 ON icekit_navigation_navigation USING btree (slug);


--
-- Name: icekit_navigation_navigation_slug_fe9b587b6950777_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_navigation_navigation_slug_fe9b587b6950777_like ON icekit_navigation_navigation USING btree (slug varchar_pattern_ops);


--
-- Name: icekit_plugins_image_imagerepurposec_slug_38a62a03d5152b88_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_plugins_image_imagerepurposec_slug_38a62a03d5152b88_like ON icekit_plugins_image_imagerepurposeconfig USING btree (slug varchar_pattern_ops);


--
-- Name: icekit_plugins_image_imagerepurposeconfig_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_plugins_image_imagerepurposeconfig_2dbcba41 ON icekit_plugins_image_imagerepurposeconfig USING btree (slug);


--
-- Name: icekit_plugins_location_location_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_plugins_location_location_2dbcba41 ON icekit_plugins_location_location USING btree (slug);


--
-- Name: icekit_plugins_location_location_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_plugins_location_location_441a5015 ON icekit_plugins_location_location USING btree (hero_image_id);


--
-- Name: icekit_plugins_location_location_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_plugins_location_location_72bc1be0 ON icekit_plugins_location_location USING btree (layout_id);


--
-- Name: icekit_plugins_location_location_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_plugins_location_location_b667876a ON icekit_plugins_location_location USING btree (publishing_is_draft);


--
-- Name: icekit_plugins_location_location_slug_5521d47cf91e06de_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_plugins_location_location_slug_5521d47cf91e06de_like ON icekit_plugins_location_location USING btree (slug varchar_pattern_ops);


--
-- Name: icekit_press_releases_pressrelease_23690fd7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_23690fd7 ON icekit_press_releases_pressrelease USING btree (released);


--
-- Name: icekit_press_releases_pressrelease_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_2dbcba41 ON icekit_press_releases_pressrelease USING btree (slug);


--
-- Name: icekit_press_releases_pressrelease_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_72bc1be0 ON icekit_press_releases_pressrelease USING btree (layout_id);


--
-- Name: icekit_press_releases_pressrelease_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_9ae73c65 ON icekit_press_releases_pressrelease USING btree (modified);


--
-- Name: icekit_press_releases_pressrelease_b583a629; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_b583a629 ON icekit_press_releases_pressrelease USING btree (category_id);


--
-- Name: icekit_press_releases_pressrelease_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_b667876a ON icekit_press_releases_pressrelease USING btree (publishing_is_draft);


--
-- Name: icekit_press_releases_pressrelease_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_e2fa5388 ON icekit_press_releases_pressrelease USING btree (created);


--
-- Name: icekit_press_releases_pressrelease_slug_f80a55f5bcf550d_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_slug_f80a55f5bcf550d_like ON icekit_press_releases_pressrelease USING btree (slug varchar_pattern_ops);


--
-- Name: ik_event_listing_types_79752242; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ik_event_listing_types_79752242 ON ik_event_listing_types USING btree (eventtype_id);


--
-- Name: ik_event_listing_types_fed6ef54; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ik_event_listing_types_fed6ef54 ON ik_event_listing_types USING btree (eventcontentlistingitem_id);


--
-- Name: ik_todays_occurrences_types_70a97ca9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ik_todays_occurrences_types_70a97ca9 ON ik_todays_occurrences_types USING btree (todaysoccurrences_id);


--
-- Name: ik_todays_occurrences_types_79752242; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ik_todays_occurrences_types_79752242 ON ik_todays_occurrences_types USING btree (eventtype_id);


--
-- Name: image_image_categories_a1a67fb1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX image_image_categories_a1a67fb1 ON icekit_plugins_image_image_categories USING btree (mediacategory_id);


--
-- Name: image_image_categories_f33175e6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX image_image_categories_f33175e6 ON icekit_plugins_image_image_categories USING btree (image_id);


--
-- Name: model_settings_setting_d3e32c49; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX model_settings_setting_d3e32c49 ON model_settings_setting USING btree (polymorphic_ctype_id);


--
-- Name: model_settings_setting_name_68afb3124af9e3c2_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX model_settings_setting_name_68afb3124af9e3c2_like ON model_settings_setting USING btree (name varchar_pattern_ops);


--
-- Name: notifications_followerinformation_417f1b1c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_followerinformation_417f1b1c ON notifications_followerinformation USING btree (content_type_id);


--
-- Name: notifications_followerinformation_d3e32c49; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_followerinformation_d3e32c49 ON notifications_followerinformation USING btree (polymorphic_ctype_id);


--
-- Name: notifications_followerinformation_followers_e8701ad4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_followerinformation_followers_e8701ad4 ON notifications_followerinformation_followers USING btree (user_id);


--
-- Name: notifications_followerinformation_followers_ed2a121f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_followerinformation_followers_ed2a121f ON notifications_followerinformation_followers USING btree (followerinformation_id);


--
-- Name: notifications_followerinformation_group_followers_0e939a4f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_followerinformation_group_followers_0e939a4f ON notifications_followerinformation_group_followers USING btree (group_id);


--
-- Name: notifications_followerinformation_group_followers_ed2a121f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_followerinformation_group_followers_ed2a121f ON notifications_followerinformation_group_followers USING btree (followerinformation_id);


--
-- Name: notifications_hasreadmessage_4ccaa172; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_hasreadmessage_4ccaa172 ON notifications_hasreadmessage USING btree (message_id);


--
-- Name: notifications_hasreadmessage_a8452ca7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_hasreadmessage_a8452ca7 ON notifications_hasreadmessage USING btree (person_id);


--
-- Name: notifications_notification_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_notification_9ae73c65 ON notifications_notification USING btree (modified);


--
-- Name: notifications_notification_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_notification_e2fa5388 ON notifications_notification USING btree (created);


--
-- Name: notifications_notification_e8701ad4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_notification_e8701ad4 ON notifications_notification USING btree (user_id);


--
-- Name: pagetype_advancedeventlisting_advancedeventlistingpage_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_advancedeventlisting_advancedeventlistingpage_441a5015 ON pagetype_advancedeventlisting_advancedeventlistingpage USING btree (hero_image_id);


--
-- Name: pagetype_advancedeventlisting_advancedeventlistingpage_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_advancedeventlisting_advancedeventlistingpage_72bc1be0 ON pagetype_advancedeventlisting_advancedeventlistingpage USING btree (layout_id);


--
-- Name: pagetype_advancedeventlisting_advancedeventlistingpage_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_advancedeventlisting_advancedeventlistingpage_b667876a ON pagetype_advancedeventlisting_advancedeventlistingpage USING btree (publishing_is_draft);


--
-- Name: pagetype_eventlistingfordate_eventlistingpage_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_eventlistingfordate_eventlistingpage_441a5015 ON pagetype_eventlistingfordate_eventlistingpage USING btree (hero_image_id);


--
-- Name: pagetype_eventlistingfordate_eventlistingpage_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_eventlistingfordate_eventlistingpage_72bc1be0 ON pagetype_eventlistingfordate_eventlistingpage USING btree (layout_id);


--
-- Name: pagetype_eventlistingfordate_eventlistingpage_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_eventlistingfordate_eventlistingpage_b667876a ON pagetype_eventlistingfordate_eventlistingpage USING btree (publishing_is_draft);


--
-- Name: pagetype_fluentpage_fluentpage_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_fluentpage_fluentpage_72bc1be0 ON pagetype_fluentpage_fluentpage USING btree (layout_id);


--
-- Name: pagetype_icekit_article_articlecategorypage_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_article_articlecategorypage_441a5015 ON icekit_articlecategorypage USING btree (hero_image_id);


--
-- Name: pagetype_icekit_article_articlecategorypage_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_article_articlecategorypage_72bc1be0 ON icekit_articlecategorypage USING btree (layout_id);


--
-- Name: pagetype_icekit_article_articlecategorypage_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_article_articlecategorypage_b667876a ON icekit_articlecategorypage USING btree (publishing_is_draft);


--
-- Name: pagetype_icekit_authors_authorlisting_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_authors_authorlisting_441a5015 ON icekit_authorlisting USING btree (hero_image_id);


--
-- Name: pagetype_icekit_authors_authorlisting_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_authors_authorlisting_72bc1be0 ON icekit_authorlisting USING btree (layout_id);


--
-- Name: pagetype_icekit_authors_authorlisting_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_authors_authorlisting_b667876a ON icekit_authorlisting USING btree (publishing_is_draft);


--
-- Name: pagetype_icekit_press_releases_pressreleaselisting_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_press_releases_pressreleaselisting_441a5015 ON pagetype_icekit_press_releases_pressreleaselisting USING btree (hero_image_id);


--
-- Name: pagetype_icekit_press_releases_pressreleaselisting_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_press_releases_pressreleaselisting_72bc1be0 ON pagetype_icekit_press_releases_pressreleaselisting USING btree (layout_id);


--
-- Name: pagetype_icekit_press_releases_pressreleaselisting_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_press_releases_pressreleaselisting_b667876a ON pagetype_icekit_press_releases_pressreleaselisting USING btree (publishing_is_draft);


--
-- Name: pagetype_layout_page_layoutpage_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_layout_page_layoutpage_441a5015 ON icekit_layoutpage USING btree (hero_image_id);


--
-- Name: pagetype_layout_page_layoutpage_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_layout_page_layoutpage_72bc1be0 ON icekit_layoutpage USING btree (layout_id);


--
-- Name: pagetype_layout_page_layoutpage_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_layout_page_layoutpage_b667876a ON icekit_layoutpage USING btree (publishing_is_draft);


--
-- Name: pagetype_search_page_searchpage_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_search_page_searchpage_b667876a ON icekit_searchpage USING btree (publishing_is_draft);


--
-- Name: polymorphic_auth_email_emailuser_email_4f8470685d524242_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX polymorphic_auth_email_emailuser_email_4f8470685d524242_like ON polymorphic_auth_email_emailuser USING btree (email varchar_pattern_ops);


--
-- Name: polymorphic_auth_user_d3e32c49; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX polymorphic_auth_user_d3e32c49 ON polymorphic_auth_user USING btree (polymorphic_ctype_id);


--
-- Name: polymorphic_auth_user_groups_0e939a4f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX polymorphic_auth_user_groups_0e939a4f ON polymorphic_auth_user_groups USING btree (group_id);


--
-- Name: polymorphic_auth_user_groups_e8701ad4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX polymorphic_auth_user_groups_e8701ad4 ON polymorphic_auth_user_groups USING btree (user_id);


--
-- Name: polymorphic_auth_user_user_permissions_8373b171; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX polymorphic_auth_user_user_permissions_8373b171 ON polymorphic_auth_user_user_permissions USING btree (permission_id);


--
-- Name: polymorphic_auth_user_user_permissions_e8701ad4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX polymorphic_auth_user_user_permissions_e8701ad4 ON polymorphic_auth_user_user_permissions USING btree (user_id);


--
-- Name: post_office_attachment_emails_07ba63f5; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_attachment_emails_07ba63f5 ON post_office_attachment_emails USING btree (attachment_id);


--
-- Name: post_office_attachment_emails_fdfd0ebf; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_attachment_emails_fdfd0ebf ON post_office_attachment_emails USING btree (email_id);


--
-- Name: post_office_email_3acc0b7a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_email_3acc0b7a ON post_office_email USING btree (last_updated);


--
-- Name: post_office_email_74f53564; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_email_74f53564 ON post_office_email USING btree (template_id);


--
-- Name: post_office_email_9acb4454; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_email_9acb4454 ON post_office_email USING btree (status);


--
-- Name: post_office_email_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_email_e2fa5388 ON post_office_email USING btree (created);


--
-- Name: post_office_email_ed24d584; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_email_ed24d584 ON post_office_email USING btree (scheduled_time);


--
-- Name: post_office_emailtemplate_dea6f63e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_emailtemplate_dea6f63e ON post_office_emailtemplate USING btree (default_template_id);


--
-- Name: post_office_log_fdfd0ebf; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_log_fdfd0ebf ON post_office_log USING btree (email_id);


--
-- Name: redirectnode_redirectnode_t_language_code_1c846d7cc1f2a3e4_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX redirectnode_redirectnode_t_language_code_1c846d7cc1f2a3e4_like ON redirectnode_redirectnode_translation USING btree (language_code varchar_pattern_ops);


--
-- Name: redirectnode_redirectnode_translation_60716c2f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX redirectnode_redirectnode_translation_60716c2f ON redirectnode_redirectnode_translation USING btree (language_code);


--
-- Name: redirectnode_redirectnode_translation_90349b61; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX redirectnode_redirectnode_translation_90349b61 ON redirectnode_redirectnode_translation USING btree (master_id);


--
-- Name: response_pages_responsepage_type_58b272464b64ba55_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX response_pages_responsepage_type_58b272464b64ba55_like ON response_pages_responsepage USING btree (type varchar_pattern_ops);


--
-- Name: reversion_revision_b16b0f06; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reversion_revision_b16b0f06 ON reversion_revision USING btree (manager_slug);


--
-- Name: reversion_revision_c69e55a4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reversion_revision_c69e55a4 ON reversion_revision USING btree (date_created);


--
-- Name: reversion_revision_e8701ad4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reversion_revision_e8701ad4 ON reversion_revision USING btree (user_id);


--
-- Name: reversion_revision_manager_slug_7a025b8ba27c41af_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reversion_revision_manager_slug_7a025b8ba27c41af_like ON reversion_revision USING btree (manager_slug varchar_pattern_ops);


--
-- Name: reversion_version_0c9ba3a3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reversion_version_0c9ba3a3 ON reversion_version USING btree (object_id_int);


--
-- Name: reversion_version_417f1b1c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reversion_version_417f1b1c ON reversion_version USING btree (content_type_id);


--
-- Name: reversion_version_5de09a8d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reversion_version_5de09a8d ON reversion_version USING btree (revision_id);


--
-- Name: sharedcontent_sharedcontent_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sharedcontent_sharedcontent_2dbcba41 ON sharedcontent_sharedcontent USING btree (slug);


--
-- Name: sharedcontent_sharedcontent_4e147804; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sharedcontent_sharedcontent_4e147804 ON sharedcontent_sharedcontent USING btree (parent_site_id);


--
-- Name: sharedcontent_sharedcontent_language_code_31971be95bd13760_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sharedcontent_sharedcontent_language_code_31971be95bd13760_like ON sharedcontent_sharedcontent_translation USING btree (language_code varchar_pattern_ops);


--
-- Name: sharedcontent_sharedcontent_slug_4a3ac4204db23d0_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sharedcontent_sharedcontent_slug_4a3ac4204db23d0_like ON sharedcontent_sharedcontent USING btree (slug varchar_pattern_ops);


--
-- Name: sharedcontent_sharedcontent_translation_60716c2f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sharedcontent_sharedcontent_translation_60716c2f ON sharedcontent_sharedcontent_translation USING btree (language_code);


--
-- Name: sharedcontent_sharedcontent_translation_90349b61; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sharedcontent_sharedcontent_translation_90349b61 ON sharedcontent_sharedcontent_translation USING btree (master_id);


--
-- Name: slideshow_slideshow_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX slideshow_slideshow_b667876a ON icekit_plugins_slideshow_slideshow USING btree (publishing_is_draft);


--
-- Name: staff_profiles_staffprofile_department_bf691be4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX staff_profiles_staffprofile_department_bf691be4 ON staff_profiles_staffprofile_department USING btree (department_id);


--
-- Name: staff_profiles_staffprofile_department_d3a25dcc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX staff_profiles_staffprofile_department_d3a25dcc ON staff_profiles_staffprofile_department USING btree (staffprofile_id);


--
-- Name: staff_profiles_staffprofile_e8701ad4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX staff_profiles_staffprofile_e8701ad4 ON staff_profiles_staffprofile USING btree (user_id);


--
-- Name: taggit_tag_name_79f4f7b6e4e3527b_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX taggit_tag_name_79f4f7b6e4e3527b_like ON taggit_tag USING btree (name varchar_pattern_ops);


--
-- Name: taggit_tag_slug_6bd433aed4f74f83_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX taggit_tag_slug_6bd433aed4f74f83_like ON taggit_tag USING btree (slug varchar_pattern_ops);


--
-- Name: taggit_taggeditem_417f1b1c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX taggit_taggeditem_417f1b1c ON taggit_taggeditem USING btree (content_type_id);


--
-- Name: taggit_taggeditem_76f094bc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX taggit_taggeditem_76f094bc ON taggit_taggeditem USING btree (tag_id);


--
-- Name: taggit_taggeditem_af31437c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX taggit_taggeditem_af31437c ON taggit_taggeditem USING btree (object_id);


--
-- Name: taggit_taggeditem_content_type_id_19be80e3bd9f4554_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX taggit_taggeditem_content_type_id_19be80e3bd9f4554_idx ON taggit_taggeditem USING btree (content_type_id, object_id);


--
-- Name: test_article_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_article_2dbcba41 ON test_article USING btree (slug);


--
-- Name: test_article_6be37982; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_article_6be37982 ON test_article USING btree (parent_id);


--
-- Name: test_article_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_article_72bc1be0 ON test_article USING btree (layout_id);


--
-- Name: test_article_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_article_b667876a ON test_article USING btree (publishing_is_draft);


--
-- Name: test_article_slug_58a105c51f5ee789_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_article_slug_58a105c51f5ee789_like ON test_article USING btree (slug varchar_pattern_ops);


--
-- Name: test_articlelisting_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_articlelisting_441a5015 ON test_articlelisting USING btree (hero_image_id);


--
-- Name: test_articlelisting_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_articlelisting_72bc1be0 ON test_articlelisting USING btree (layout_id);


--
-- Name: test_articlelisting_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_articlelisting_b667876a ON test_articlelisting USING btree (publishing_is_draft);


--
-- Name: test_layoutpage_with_related_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_layoutpage_with_related_441a5015 ON test_layoutpage_with_related USING btree (hero_image_id);


--
-- Name: test_layoutpage_with_related_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_layoutpage_with_related_72bc1be0 ON test_layoutpage_with_related USING btree (layout_id);


--
-- Name: test_layoutpage_with_related_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_layoutpage_with_related_b667876a ON test_layoutpage_with_related USING btree (publishing_is_draft);


--
-- Name: test_layoutpage_with_related_related_pages_1a63c800; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_layoutpage_with_related_related_pages_1a63c800 ON test_layoutpage_with_related_related_pages USING btree (page_id);


--
-- Name: test_layoutpage_with_related_related_pages_9ee295f2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_layoutpage_with_related_related_pages_9ee295f2 ON test_layoutpage_with_related_related_pages USING btree (layoutpagewithrelatedpages_id);


--
-- Name: tests_barwithlayout_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_barwithlayout_72bc1be0 ON tests_barwithlayout USING btree (layout_id);


--
-- Name: tests_basemodel_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_basemodel_9ae73c65 ON tests_basemodel USING btree (modified);


--
-- Name: tests_basemodel_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_basemodel_e2fa5388 ON tests_basemodel USING btree (created);


--
-- Name: tests_bazwithlayout_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_bazwithlayout_72bc1be0 ON tests_bazwithlayout USING btree (layout_id);


--
-- Name: tests_foowithlayout_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_foowithlayout_72bc1be0 ON tests_foowithlayout USING btree (layout_id);


--
-- Name: tests_publishingm2mmodela_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_publishingm2mmodela_b667876a ON tests_publishingm2mmodela USING btree (publishing_is_draft);


--
-- Name: tests_publishingm2mmodelb_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_publishingm2mmodelb_b667876a ON tests_publishingm2mmodelb USING btree (publishing_is_draft);


--
-- Name: tests_publishingm2mmodelb_related_a_models_7c583a2c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_publishingm2mmodelb_related_a_models_7c583a2c ON tests_publishingm2mmodelb_related_a_models USING btree (publishingm2mmodela_id);


--
-- Name: tests_publishingm2mmodelb_related_a_models_b6e38a3a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_publishingm2mmodelb_related_a_models_b6e38a3a ON tests_publishingm2mmodelb_related_a_models USING btree (publishingm2mmodelb_id);


--
-- Name: tests_publishingm2mthroughtable_0b893a6c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_publishingm2mthroughtable_0b893a6c ON tests_publishingm2mthroughtable USING btree (a_model_id);


--
-- Name: tests_publishingm2mthroughtable_684652a4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_publishingm2mthroughtable_684652a4 ON tests_publishingm2mthroughtable USING btree (b_model_id);


--
-- Name: textfile_textfile_translati_language_code_10bf6f074737be5a_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX textfile_textfile_translati_language_code_10bf6f074737be5a_like ON textfile_textfile_translation USING btree (language_code varchar_pattern_ops);


--
-- Name: textfile_textfile_translation_60716c2f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX textfile_textfile_translation_60716c2f ON textfile_textfile_translation USING btree (language_code);


--
-- Name: textfile_textfile_translation_90349b61; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX textfile_textfile_translation_90349b61 ON textfile_textfile_translation USING btree (master_id);


--
-- Name: workflow_workflowstate_02c1725c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workflow_workflowstate_02c1725c ON icekit_workflow_workflowstate USING btree (assigned_to_id);


--
-- Name: workflow_workflowstate_417f1b1c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workflow_workflowstate_417f1b1c ON icekit_workflow_workflowstate USING btree (content_type_id);


--
-- Name: test_layoutpage_with_related D025b6518882fa5fed4e23381f953006; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT "D025b6518882fa5fed4e23381f953006" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_publishingm2mmodelb_related_a_models D039bddfec27220c75f8faf5613dd3cb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models
    ADD CONSTRAINT "D039bddfec27220c75f8faf5613dd3cb" FOREIGN KEY (publishingm2mmodela_id) REFERENCES tests_publishingm2mmodela(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_film_film D069dae8d5f59fbc87dc68fb8efada62; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_film_film
    ADD CONSTRAINT "D069dae8d5f59fbc87dc68fb8efada62" FOREIGN KEY (media_type_id) REFERENCES gk_collections_moving_image_mediatype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_icekit_press_releases_pressreleaselisting D0785ae290b7fa974ae631496b37cbb6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT "D0785ae290b7fa974ae631496b37cbb6" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_article_article D086aa67fc868943b203e5cf0d5f08d3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT "D086aa67fc868943b203e5cf0d5f08d3" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_article_article(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_work_creator_creatorbase D0afb0e03029d3232cdab808fe9b44a5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_creatorbase
    ADD CONSTRAINT "D0afb0e03029d3232cdab808fe9b44a5" FOREIGN KEY (publishing_linked_id) REFERENCES gk_collections_work_creator_creatorbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_publishingm2mmodelb D0dbdace4ed76e6fefe8fb1837b5ff68; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb
    ADD CONSTRAINT "D0dbdace4ed76e6fefe8fb1837b5ff68" FOREIGN KEY (publishing_linked_id) REFERENCES tests_publishingm2mmodelb(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_page_anchor_pageanchoritem D0eaaca1816b6895851e13ffa475ea7f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_page_anchor_pageanchoritem
    ADD CONSTRAINT "D0eaaca1816b6895851e13ffa475ea7f" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_image_gallery_imagegalleryshowitem D1017b86abf6d97bc50de749b11bce14; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_image_gallery_imagegalleryshowitem
    ADD CONSTRAINT "D1017b86abf6d97bc50de749b11bce14" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: redirectnode_redirectnode_translation D10236ab2fc1d1ada635811bee53b963; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirectnode_redirectnode_translation
    ADD CONSTRAINT "D10236ab2fc1d1ada635811bee53b963" FOREIGN KEY (master_id) REFERENCES pagetype_redirectnode_redirectnode(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_icekit_press_releases_pressreleaselisting D108d28f58e2de087c1981c102c10c13; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT "D108d28f58e2de087c1981c102c10c13" FOREIGN KEY (publishing_linked_id) REFERENCES pagetype_icekit_press_releases_pressreleaselisting(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_glamkit_sponsors_beginsponsorblockitem D14be4d1a76a0f532264c3fdfcb08b92; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_beginsponsorblockitem
    ADD CONSTRAINT "D14be4d1a76a0f532264c3fdfcb08b92" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_moving_image_movingimagework_genres D15ebca852088073f1ae9185a09815b3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_moving_image_movingimagework_genres
    ADD CONSTRAINT "D15ebca852088073f1ae9185a09815b3" FOREIGN KEY (movingimagework_id) REFERENCES gk_collections_moving_image_movingimagework(workbase_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_twitter_embed_twitterembeditem D18e384846cbfff241bd06ef2fc6c353; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_twitter_embed_twitterembeditem
    ADD CONSTRAINT "D18e384846cbfff241bd06ef2fc6c353" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_event_listing_eventcontentlistingitem D1932b1a64236f831bade674fb262069; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_event_listing_eventcontentlistingitem
    ADD CONSTRAINT "D1932b1a64236f831bade674fb262069" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_press_releases_pressrelease D1a55970361a34077e82be174c2fd356; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease
    ADD CONSTRAINT "D1a55970361a34077e82be174c2fd356" FOREIGN KEY (category_id) REFERENCES icekit_press_releases_pressreleasecategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_staff_profile_list_staffprofileslist D1b4e9cd6cec24e33cfcd4447449ee09; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_staff_profile_list_staffprofileslist
    ADD CONSTRAINT "D1b4e9cd6cec24e33cfcd4447449ee09" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_layoutpage_with_related D1c8868751961666831007d6ef9bbca6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT "D1c8868751961666831007d6ef9bbca6" FOREIGN KEY (publishing_linked_id) REFERENCES test_layoutpage_with_related(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_eventlistingfordate_eventlistingpage D1f9143bd32620989c7d8da225157c34; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT "D1f9143bd32620989c7d8da225157c34" FOREIGN KEY (publishing_linked_id) REFERENCES pagetype_eventlistingfordate_eventlistingpage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_followerinformation_followers D21648cef40fd3acffd5be82db4cc484; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers
    ADD CONSTRAINT "D21648cef40fd3acffd5be82db4cc484" FOREIGN KEY (followerinformation_id) REFERENCES notifications_followerinformation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_links_articlelink D23b7a24d9edadf578409f0538a80fd9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_articlelink
    ADD CONSTRAINT "D23b7a24d9edadf578409f0538a80fd9" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventbase D2511cc883de77ed25a35760c22e6ce3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT "D2511cc883de77ed25a35760c22e6ce3" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_layoutpage D257969290853cde49cacf2422cfb232; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT "D257969290853cde49cacf2422cfb232" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_instagram_embed_instagramembeditem D262ef8d09327f375d17a26dcaad8cdc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_instagram_embed_instagramembeditem
    ADD CONSTRAINT "D262ef8d09327f375d17a26dcaad8cdc" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_location_locationitem D27c24e9282f3883489686dd805bb42f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_location_locationitem
    ADD CONSTRAINT "D27c24e9282f3883489686dd805bb42f" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_sharedcontent_sharedcontentitem D2a72cb4eb88582473075dbadc30b8db; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_sharedcontent_sharedcontentitem
    ADD CONSTRAINT "D2a72cb4eb88582473075dbadc30b8db" FOREIGN KEY (shared_content_id) REFERENCES sharedcontent_sharedcontent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphic_auth_user D2ae52888fb3dab881802d2d4e72e19d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user
    ADD CONSTRAINT "D2ae52888fb3dab881802d2d4e72e19d" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_setting D2c9852fb35ac284a461b2f2af69362c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_setting
    ADD CONSTRAINT "D2c9852fb35ac284a461b2f2af69362c" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_image_imageitem D2d48554abb5de7c08d118eaaeac4bab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_image_imageitem
    ADD CONSTRAINT "D2d48554abb5de7c08d118eaaeac4bab" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_contents_contentitem D2d8e9334a3d4470655f51bc5f1dd141; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem
    ADD CONSTRAINT "D2d8e9334a3d4470655f51bc5f1dd141" FOREIGN KEY (placeholder_id) REFERENCES fluent_contents_placeholder(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_plugins_location_location D34f8acd5aaac89283636878749a6a9e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_location_location
    ADD CONSTRAINT "D34f8acd5aaac89283636878749a6a9e" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_plugins_location_location(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_article D35df7b69f079518165079747e863c89; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT "D35df7b69f079518165079747e863c89" FOREIGN KEY (parent_id) REFERENCES test_articlelisting(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_navigation_accountsnavigationitem D3715f8d77093d9165708dc0b70241e1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_navigation_accountsnavigationitem
    ADD CONSTRAINT "D3715f8d77093d9165708dc0b70241e1" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_authors_author D378e565c6cbf34df35ed205dd7f7d53; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author
    ADD CONSTRAINT "D378e565c6cbf34df35ed205dd7f7d53" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_game_game_input_types D3814f360d8067403154cffefee55e71; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game_input_types
    ADD CONSTRAINT "D3814f360d8067403154cffefee55e71" FOREIGN KEY (game_id) REFERENCES gk_collections_game_game(workbase_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_film_film D3a8ae9cd2c47dc1508cebe0eb3784f9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_film_film
    ADD CONSTRAINT "D3a8ae9cd2c47dc1508cebe0eb3784f9" FOREIGN KEY (workbase_ptr_id) REFERENCES gk_collections_work_creator_workbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ik_todays_occurrences_types D3b74790370a7085c8a2be88a3e326f4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types
    ADD CONSTRAINT "D3b74790370a7085c8a2be88a3e326f4" FOREIGN KEY (todaysoccurrences_id) REFERENCES contentitem_ik_events_todays_occurrences_todaysoccurrences(contentitem_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_article_article D3c35497d6263135cbc0b85d71a88c48; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT "D3c35497d6263135cbc0b85d71a88c48" FOREIGN KEY (parent_id) REFERENCES icekit_articlecategorypage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_layoutpage_with_related_related_pages D3f00e8f5b1788801edca8f23bbd794d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages
    ADD CONSTRAINT "D3f00e8f5b1788801edca8f23bbd794d" FOREIGN KEY (layoutpagewithrelatedpages_id) REFERENCES test_layoutpage_with_related(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_publishingm2mmodela D40ea9c3e332dc41f0b9045317a745b4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodela
    ADD CONSTRAINT "D40ea9c3e332dc41f0b9045317a745b4" FOREIGN KEY (publishing_linked_id) REFERENCES tests_publishingm2mmodela(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_child_pages_childpageitem D415c5307dc3bf9e12d3f2b220667f51; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_child_pages_childpageitem
    ADD CONSTRAINT "D415c5307dc3bf9e12d3f2b220667f51" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_person_personcreator D4183ae00da509c50438c1d949c0ffee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_person_personcreator
    ADD CONSTRAINT "D4183ae00da509c50438c1d949c0ffee" FOREIGN KEY (creatorbase_ptr_id) REFERENCES gk_collections_work_creator_creatorbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_moving_image_movingimagework D4371d6b5ff4302c54aabfc425eca97d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_moving_image_movingimagework
    ADD CONSTRAINT "D4371d6b5ff4302c54aabfc425eca97d" FOREIGN KEY (workbase_ptr_id) REFERENCES gk_collections_work_creator_workbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_media_coverage_mediacoveragepromoitem D46341d7365dcf83ee9ec16d20b54467; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_media_coverage_mediacoveragepromoitem
    ADD CONSTRAINT "D46341d7365dcf83ee9ec16d20b54467" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_game_game_input_types D470f9679172d09109b910389724b65f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game_input_types
    ADD CONSTRAINT "D470f9679172d09109b910389724b65f" FOREIGN KEY (gameinputtype_id) REFERENCES gk_collections_game_gameinputtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_moving_image_movingimagework D488e78c8935d4df24485830e39846a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_moving_image_movingimagework
    ADD CONSTRAINT "D488e78c8935d4df24485830e39846a7" FOREIGN KEY (media_type_id) REFERENCES gk_collections_moving_image_mediatype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_work_creator_personcreator D49108f135c0a0faaa2a3066ca5130c6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_personcreator
    ADD CONSTRAINT "D49108f135c0a0faaa2a3066ca5130c6" FOREIGN KEY (creatorbase_ptr_id) REFERENCES gk_collections_work_creator_creatorbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_layoutpage D49d124b7e29e3d325bf81d4f74195dd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT "D49d124b7e29e3d325bf81d4f74195dd" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_layoutpage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventbase D4a64d86ae1b82ae13525d6311e77abc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT "D4a64d86ae1b82ae13525d6311e77abc" FOREIGN KEY (location_id) REFERENCES icekit_plugins_location_location(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_moving_image_movingimagework_genres D4a899dc6115e2df072ffdf457e00583; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_moving_image_movingimagework_genres
    ADD CONSTRAINT "D4a899dc6115e2df072ffdf457e00583" FOREIGN KEY (genre_id) REFERENCES gk_collections_moving_image_genre(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: biennale_of_sydney_biennaleevent D4c34d30f4a761fcfa0573c83d8a7506; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennaleevent
    ADD CONSTRAINT "D4c34d30f4a761fcfa0573c83d8a7506" FOREIGN KEY (eventbase_ptr_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: advanced_event_listing_page_primary_types D4c90e792f63886e801d3ddc95ea0ded; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY advanced_event_listing_page_primary_types
    ADD CONSTRAINT "D4c90e792f63886e801d3ddc95ea0ded" FOREIGN KEY (advancedeventlistingpage_id) REFERENCES pagetype_advancedeventlisting_advancedeventlistingpage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: biennale_of_sydney_eventartist D50138b98e286ea80b50a004695bd9a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_eventartist
    ADD CONSTRAINT "D50138b98e286ea80b50a004695bd9a3" FOREIGN KEY (event_id) REFERENCES biennale_of_sydney_biennaleevent(eventbase_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_gk_collections_links_worklink D512bf7700d2288dd9dda49a28b68866; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_gk_collections_links_worklink
    ADD CONSTRAINT "D512bf7700d2288dd9dda49a28b68866" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_work_creator_workcreator D518ad1bed3cba364a636c0618f2f14e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workcreator
    ADD CONSTRAINT "D518ad1bed3cba364a636c0618f2f14e" FOREIGN KEY (work_id) REFERENCES gk_collections_work_creator_workbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_work_creator_workbase D584f9cae1b7c8269154b44df0b81506; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workbase
    ADD CONSTRAINT "D584f9cae1b7c8269154b44df0b81506" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_game_game_platforms D5893a5c57165396966c082656df6718; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game_platforms
    ADD CONSTRAINT "D5893a5c57165396966c082656df6718" FOREIGN KEY (gameplatform_id) REFERENCES gk_collections_game_gameplatform(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: advanced_event_listing_page_secondary_types D5a3e83d6e08e78695184f6a8a43feef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY advanced_event_listing_page_secondary_types
    ADD CONSTRAINT "D5a3e83d6e08e78695184f6a8a43feef" FOREIGN KEY (advancedeventlistingpage_id) REFERENCES pagetype_advancedeventlisting_advancedeventlistingpage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_advancedeventlisting_advancedeventlistingpage D5b31a897675a66966684651d76e27ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_advancedeventlisting_advancedeventlistingpage
    ADD CONSTRAINT "D5b31a897675a66966684651d76e27ca" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: biennale_of_sydney_biennaleevent D5ed2826d262a0806e1394fb770c0582; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennaleevent
    ADD CONSTRAINT "D5ed2826d262a0806e1394fb770c0582" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_work_creator_workorigin D63a9be24664edc54b40467c68a62e54; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workorigin
    ADD CONSTRAINT "D63a9be24664edc54b40467c68a62e54" FOREIGN KEY (work_id) REFERENCES gk_collections_work_creator_workbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_work_creator_workorigin D66f6593c59802d30a0bc9109d4536bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workorigin
    ADD CONSTRAINT "D66f6593c59802d30a0bc9109d4536bc" FOREIGN KEY (geographic_location_id) REFERENCES glamkit_collections_geographiclocation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_contents_contentitem D671b8897cfd290ae2b79840a03b9442; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem
    ADD CONSTRAINT "D671b8897cfd290ae2b79840a03b9442" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: biennale_of_sydney_biennaleevent_works D6cb1586eb040311aa23b17f1aada829; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennaleevent_works
    ADD CONSTRAINT "D6cb1586eb040311aa23b17f1aada829" FOREIGN KEY (biennaleevent_id) REFERENCES biennale_of_sydney_biennaleevent(eventbase_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_article_article D6cc6b94cd57bff439b5a1574af80dc5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT "D6cc6b94cd57bff439b5a1574af80dc5" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_occurrence D6e2ae137dc96731929f4bff60b3c32b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_occurrence
    ADD CONSTRAINT "D6e2ae137dc96731929f4bff60b3c32b" FOREIGN KEY (generator_id) REFERENCES icekit_events_eventrepeatsgenerator(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_work_creator_creatorbase D6f93338bccb85a02670d95099e4f76a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_creatorbase
    ADD CONSTRAINT "D6f93338bccb85a02670d95099e4f76a" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_film_film_genres D7095d33afbf13bc6ee7a524d1cab840; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_film_film_genres
    ADD CONSTRAINT "D7095d33afbf13bc6ee7a524d1cab840" FOREIGN KEY (film_id) REFERENCES gk_collections_film_film(workbase_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_file_fileitem D761721258496278299358b4136d41df; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_file_fileitem
    ADD CONSTRAINT "D761721258496278299358b4136d41df" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_pages_urlnode D7a3fc9d3bb97e23ea9cf205be3b2c0c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT "D7a3fc9d3bb97e23ea9cf205be3b2c0c" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_work_creator_workimage D7b7d2b8d23954f45f9bedf51de93df1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workimage
    ADD CONSTRAINT "D7b7d2b8d23954f45f9bedf51de93df1" FOREIGN KEY (type_id) REFERENCES gk_collections_work_creator_workimagetype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_location_locationitem D7bc9cefb04c17b4afe18e267338d1ba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_location_locationitem
    ADD CONSTRAINT "D7bc9cefb04c17b4afe18e267338d1ba" FOREIGN KEY (location_id) REFERENCES icekit_plugins_location_location(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_plugins_location_location D7bd0e39e96f4ef7f2c394ee598acc3d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_location_location
    ADD CONSTRAINT "D7bd0e39e96f4ef7f2c394ee598acc3d" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_articlecategorypage D7eb38846be01c05db959b785c779db0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT "D7eb38846be01c05db959b785c779db0" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: biennale_of_sydney_biennaleevent D7f27e0bb25fe220704149e6e887eb65; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennaleevent
    ADD CONSTRAINT "D7f27e0bb25fe220704149e6e887eb65" FOREIGN KEY (event_location_id) REFERENCES biennale_of_sydney_biennalelocation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_oembed_with_caption_item D7f8a5ce2acd9ccd6d3d68c3f7b38481; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_oembed_with_caption_item
    ADD CONSTRAINT "D7f8a5ce2acd9ccd6d3d68c3f7b38481" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: biennale_of_sydney_exhibition D816e1c0e57022364200aa7a8078a72d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_exhibition
    ADD CONSTRAINT "D816e1c0e57022364200aa7a8078a72d" FOREIGN KEY (occurrence_ptr_id) REFERENCES icekit_events_occurrence(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_gk_collections_links_creatorlink D818b69a857cbf50000b8b513d32977a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_gk_collections_links_creatorlink
    ADD CONSTRAINT "D818b69a857cbf50000b8b513d32977a" FOREIGN KEY (item_id) REFERENCES gk_collections_work_creator_creatorbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_authorlisting D82e4bd7a8a76afce216a15ae8ca5443; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT "D82e4bd7a8a76afce216a15ae8ca5443" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_authorlisting(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_work_creator_workcreator D838ae193fea77f08d46316c634b688f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workcreator
    ADD CONSTRAINT "D838ae193fea77f08d46316c634b688f" FOREIGN KEY (creator_id) REFERENCES gk_collections_work_creator_creatorbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_film_film D85ccf2e7d1a99e42312477298c91190; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_film_film
    ADD CONSTRAINT "D85ccf2e7d1a99e42312477298c91190" FOREIGN KEY (rating_id) REFERENCES gk_collections_moving_image_rating(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_film_film_genres D8af97326e2b2b9e5b505ab3a43fc3a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_film_film_genres
    ADD CONSTRAINT "D8af97326e2b2b9e5b505ab3a43fc3a6" FOREIGN KEY (genre_id) REFERENCES gk_collections_moving_image_genre(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_links_authorlink D8b2c634bd0d51eb737191b34eafeaf7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_authorlink
    ADD CONSTRAINT "D8b2c634bd0d51eb737191b34eafeaf7" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_followerinformation_group_followers D8bba9853bd84ea691421ccc6e34475a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers
    ADD CONSTRAINT "D8bba9853bd84ea691421ccc6e34475a" FOREIGN KEY (followerinformation_id) REFERENCES notifications_followerinformation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem D8d4bc0fbe3245ef128ec969f62a3a14; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem
    ADD CONSTRAINT "D8d4bc0fbe3245ef128ec969f62a3a14" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_faq_faqitem D8d812079bae01d01a8687421585d7e4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_faq_faqitem
    ADD CONSTRAINT "D8d812079bae01d01a8687421585d7e4" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_slideshow_slideshowitem D91b2e3ceec24d28c7fe3ab867f74f86; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_slideshow_slideshowitem
    ADD CONSTRAINT "D91b2e3ceec24d28c7fe3ab867f74f86" FOREIGN KEY (slide_show_id) REFERENCES icekit_plugins_slideshow_slideshow(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_authors_author D93224f62a29e116bb641a5c8ac143f1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author
    ADD CONSTRAINT "D93224f62a29e116bb641a5c8ac143f1" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_authors_author(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_work_creator_workcreator D95a82c3ab02e6b51146bee9a273de0b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workcreator
    ADD CONSTRAINT "D95a82c3ab02e6b51146bee9a273de0b" FOREIGN KEY (role_id) REFERENCES gk_collections_work_creator_role(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_game_game_genres D97c03713dbf10fcda7a8c3bda33280d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game_genres
    ADD CONSTRAINT "D97c03713dbf10fcda7a8c3bda33280d" FOREIGN KEY (genre_id) REFERENCES gk_collections_moving_image_genre(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: post_office_emailtemplate D983fb834bc9fc79d710897b61d10c2a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_emailtemplate
    ADD CONSTRAINT "D983fb834bc9fc79d710897b61d10c2a" FOREIGN KEY (default_template_id) REFERENCES post_office_emailtemplate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_media_coverage_mediacoveragelist D98681069182b88c1f82d875070d692d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_media_coverage_mediacoveragelist
    ADD CONSTRAINT "D98681069182b88c1f82d875070d692d" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_map_mapitem D9b16854893e1a185fbe935b18bcec6f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_map_mapitem
    ADD CONSTRAINT "D9b16854893e1a185fbe935b18bcec6f" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_content_listing_contentlistingitem D9becfa82a538aee9fe02e72771956b7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_content_listing_contentlistingitem
    ADD CONSTRAINT "D9becfa82a538aee9fe02e72771956b7" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_publishingm2mmodelb_related_a_models a12e2fd92e712e82950343c6d27d20b0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models
    ADD CONSTRAINT a12e2fd92e712e82950343c6d27d20b0 FOREIGN KEY (publishingm2mmodelb_id) REFERENCES tests_publishingm2mmodelb(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_game_game a194fd221522c34ffe88e5b60e1c8e1f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game
    ADD CONSTRAINT a194fd221522c34ffe88e5b60e1c8e1f FOREIGN KEY (rating_id) REFERENCES gk_collections_moving_image_rating(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_contact_person_contactpersonitem a1f93fe5220e497aeab815883039bc91; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_contact_person_contactpersonitem
    ADD CONSTRAINT a1f93fe5220e497aeab815883039bc91 FOREIGN KEY (contact_id) REFERENCES icekit_plugins_contact_person_contactperson(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_iframe_iframeitem a3195551c97eb7db1113ee5c275baa62; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_iframe_iframeitem
    ADD CONSTRAINT a3195551c97eb7db1113ee5c275baa62 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_searchpage a34fde41444216520561787a524d4d43; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_searchpage
    ADD CONSTRAINT a34fde41444216520561787a524d4d43 FOREIGN KEY (publishing_linked_id) REFERENCES icekit_searchpage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_organization_organizationcreator a3c9a764033aa2f130e5851b2b5ddbf1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_organization_organizationcreator
    ADD CONSTRAINT a3c9a764033aa2f130e5851b2b5ddbf1 FOREIGN KEY (creatorbase_ptr_id) REFERENCES gk_collections_work_creator_creatorbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_sharedcontent_sharedcontentitem a451efc5280a52ec12016fec73064d27; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_sharedcontent_sharedcontentitem
    ADD CONSTRAINT a451efc5280a52ec12016fec73064d27 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_events_todays_occurrences_todaysoccurrences a4873d6ec8dc4df8300afdd729308081; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_events_todays_occurrences_todaysoccurrences
    ADD CONSTRAINT a4873d6ec8dc4df8300afdd729308081 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_contact_person_contactpersonitem a5fe354e733885d9dcabc390fdfa972c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_contact_person_contactpersonitem
    ADD CONSTRAINT a5fe354e733885d9dcabc390fdfa972c FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_text_textitem aa1a8b94b9ec42d2f1642fe2ce1b71fb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_text_textitem
    ADD CONSTRAINT aa1a8b94b9ec42d2f1642fe2ce1b71fb FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: advanced_event_listing_page_secondary_types adv_eventtype_id_61ebe9c06b00d3c3_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY advanced_event_listing_page_secondary_types
    ADD CONSTRAINT adv_eventtype_id_61ebe9c06b00d3c3_fk_icekit_events_eventtype_id FOREIGN KEY (eventtype_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: advanced_event_listing_page_primary_types adv_eventtype_id_6f67b627ad73fe5d_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY advanced_event_listing_page_primary_types
    ADD CONSTRAINT adv_eventtype_id_6f67b627ad73fe5d_fk_icekit_events_eventtype_id FOREIGN KEY (eventtype_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_content_type_id_27370f80dab142b5_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_content_type_id_27370f80dab142b5_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_group_id_724a3b2a773cf635_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_group_id_724a3b2a773cf635_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permission_id_3a4771de4be04a62_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permission_id_3a4771de4be04a62_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: authtoken_token authtoken__user_id_4155cdcba86d515f_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY authtoken_token
    ADD CONSTRAINT authtoken__user_id_4155cdcba86d515f_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_articlecategorypage b01aabb956e9a6e6202c691174fcffd9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT b01aabb956e9a6e6202c691174fcffd9 FOREIGN KEY (publishing_linked_id) REFERENCES icekit_articlecategorypage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_game_game b46c12c5e280e6b5e6c6ded8d954d5e9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game
    ADD CONSTRAINT b46c12c5e280e6b5e6c6ded8d954d5e9 FOREIGN KEY (workbase_ptr_id) REFERENCES gk_collections_work_creator_workbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_artwork_artwork b5b9b0c95681071186d30ff8c241073e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_artwork_artwork
    ADD CONSTRAINT b5b9b0c95681071186d30ff8c241073e FOREIGN KEY (workbase_ptr_id) REFERENCES gk_collections_work_creator_workbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_articlelisting b5f5fbdbdba0e8cc0523c33583965130; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT b5f5fbdbdba0e8cc0523c33583965130 FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_reusable_form_formitem b777fa07e72100dae73ebf822ba23275; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_reusable_form_formitem
    ADD CONSTRAINT b777fa07e72100dae73ebf822ba23275 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_events_links_eventlink baec5ac7ec224ef1c6d4d0a3407374dc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_events_links_eventlink
    ADD CONSTRAINT baec5ac7ec224ef1c6d4d0a3407374dc FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_event_types_simple_simpleevent be81a48effb593e6d1a0b38b918818d6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_event_types_simple_simpleevent
    ADD CONSTRAINT be81a48effb593e6d1a0b38b918818d6 FOREIGN KEY (eventbase_ptr_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: biennale_of_sydney_biennalelocation bi_partner_id_2a8c69482f286b77_fk_biennale_of_sydney_partner_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennalelocation
    ADD CONSTRAINT bi_partner_id_2a8c69482f286b77_fk_biennale_of_sydney_partner_id FOREIGN KEY (partner_id) REFERENCES biennale_of_sydney_partner(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: biennale_of_sydney_biennalelocation biennale_of_sydn_layout_id_458bda74b9268882_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennalelocation
    ADD CONSTRAINT biennale_of_sydn_layout_id_458bda74b9268882_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: biennale_of_sydney_biennaleevent biennale_of_sydne_layout_id_14c096954a97b6e_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennaleevent
    ADD CONSTRAINT biennale_of_sydne_layout_id_14c096954a97b6e_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_slideshow_slideshowitem c06489a416f7337ba5176a9dffa38aea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_slideshow_slideshowitem
    ADD CONSTRAINT c06489a416f7337ba5176a9dffa38aea FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_moving_image_movingimagework c1b46e5928240dbd0c59ec7739ab56d1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_moving_image_movingimagework
    ADD CONSTRAINT c1b46e5928240dbd0c59ec7739ab56d1 FOREIGN KEY (rating_id) REFERENCES gk_collections_moving_image_rating(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_eventlistingfordate_eventlistingpage c28024cefb7662ffcb8d252bf65db819; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT c28024cefb7662ffcb8d252bf65db819 FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_oembeditem_oembeditem c5bca8c4faa3251e3baed63141e3e9c6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_oembeditem_oembeditem
    ADD CONSTRAINT c5bca8c4faa3251e3baed63141e3e9c6 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_followerinformation c6ea5779f4760af813a76930d90d3d71; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation
    ADD CONSTRAINT c6ea5779f4760af813a76930d90d3d71 FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_game_game_platforms c7a1928f6c5c195b07be13953a5c5e83; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game_platforms
    ADD CONSTRAINT c7a1928f6c5c195b07be13953a5c5e83 FOREIGN KEY (game_id) REFERENCES gk_collections_game_game(workbase_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventbase c873642c949ee5ad9b4cfb10fa4ad224; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT c873642c949ee5ad9b4cfb10fa4ad224 FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_articlelisting c89561c9b04e6337c29cc37f36528774; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT c89561c9b04e6337c29cc37f36528774 FOREIGN KEY (publishing_linked_id) REFERENCES test_articlelisting(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: staff_profiles_staffprofile_department ca0583bfe2f6b47c700f6c2b19c94790; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY staff_profiles_staffprofile_department
    ADD CONSTRAINT ca0583bfe2f6b47c700f6c2b19c94790 FOREIGN KEY (staffprofile_id) REFERENCES staff_profiles_staffprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_glamkit_sponsors_endsponsorblockitem ce0f965204d3a042bd299f29b1c2c200; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_endsponsorblockitem
    ADD CONSTRAINT ce0f965204d3a042bd299f29b1c2c200 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: biennale_of_sydney_biennaleevent_works cf473210cbce7ea555fd12542da847c5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennaleevent_works
    ADD CONSTRAINT cf473210cbce7ea555fd12542da847c5 FOREIGN KEY (workbase_id) REFERENCES gk_collections_work_creator_workbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_content_listing_contentlistingitem cont_content_type_id_20fcf3b91636e72e_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_content_listing_contentlistingitem
    ADD CONSTRAINT cont_content_type_id_20fcf3b91636e72e_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_event_listing_eventcontentlistingitem cont_content_type_id_3201287517ac3d2a_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_event_listing_eventcontentlistingitem
    ADD CONSTRAINT cont_content_type_id_3201287517ac3d2a_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_glamkit_sponsors_sponsorpromoitem cont_sponsor_id_3b962ce349e64ec5_fk_glamkit_sponsors_sponsor_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_sponsorpromoitem
    ADD CONSTRAINT cont_sponsor_id_3b962ce349e64ec5_fk_glamkit_sponsors_sponsor_id FOREIGN KEY (sponsor_id) REFERENCES glamkit_sponsors_sponsor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_events_links_eventlink contenti_item_id_46b0c3c50d1b5767_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_events_links_eventlink
    ADD CONSTRAINT contenti_item_id_46b0c3c50d1b5767_fk_icekit_events_eventbase_id FOREIGN KEY (item_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_links_articlelink contentit_item_id_5dde376d4423036d_fk_icekit_article_article_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_articlelink
    ADD CONSTRAINT contentit_item_id_5dde376d4423036d_fk_icekit_article_article_id FOREIGN KEY (item_id) REFERENCES icekit_article_article(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_links_authorlink contentite_item_id_64c3350976ec4cef_fk_icekit_authors_author_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_authorlink
    ADD CONSTRAINT contentite_item_id_64c3350976ec4cef_fk_icekit_authors_author_id FOREIGN KEY (item_id) REFERENCES icekit_authors_author(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_file_fileitem contentitem_file_filei_file_id_41d982a051f93ff4_fk_file_file_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_file_fileitem
    ADD CONSTRAINT contentitem_file_filei_file_id_41d982a051f93ff4_fk_file_file_id FOREIGN KEY (file_id) REFERENCES icekit_plugins_file_file(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_image_imageitem contentitem_image_i_image_id_1494c3f02fb4cb5a_fk_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_image_imageitem
    ADD CONSTRAINT contentitem_image_i_image_id_1494c3f02fb4cb5a_fk_image_image_id FOREIGN KEY (image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_links_pagelink contentitem_item_id_6bec5485deadcde5_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_pagelink
    ADD CONSTRAINT contentitem_item_id_6bec5485deadcde5_fk_fluent_pages_urlnode_id FOREIGN KEY (item_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_reusable_form_formitem contentitem_reusable__form_id_2a5d8a3fd07a2d45_fk_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_reusable_form_formitem
    ADD CONSTRAINT contentitem_reusable__form_id_2a5d8a3fd07a2d45_fk_forms_form_id FOREIGN KEY (form_id) REFERENCES forms_form(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_quote_quoteitem d08655a0fb70a394e7dc90d02b4ab689; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_quote_quoteitem
    ADD CONSTRAINT d08655a0fb70a394e7dc90d02b4ab689 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: biennale_of_sydney_biennalelocation d4586d4dd4a45113c7b1571bfc9b3d49; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennalelocation
    ADD CONSTRAINT d4586d4dd4a45113c7b1571bfc9b3d49 FOREIGN KEY (publishing_linked_id) REFERENCES biennale_of_sydney_biennalelocation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_gk_collections_links_worklink d4bca7f41a85124524ec0c7b188d7ef9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_gk_collections_links_worklink
    ADD CONSTRAINT d4bca7f41a85124524ec0c7b188d7ef9 FOREIGN KEY (item_id) REFERENCES gk_collections_work_creator_workbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_links_pagelink d61fa2f5efff33a971f7e6fa5980f417; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_pagelink
    ADD CONSTRAINT d61fa2f5efff33a971f7e6fa5980f417 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: textfile_textfile_translation d6933d8b81cbe4a3239a8f1755fb18d7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY textfile_textfile_translation
    ADD CONSTRAINT d6933d8b81cbe4a3239a8f1755fb18d7 FOREIGN KEY (master_id) REFERENCES pagetype_textfile_textfile(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_media_coverage_mediacoveragepromoitem d77763354db1d13c8c377ef7d267c014; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_media_coverage_mediacoveragepromoitem
    ADD CONSTRAINT d77763354db1d13c8c377ef7d267c014 FOREIGN KEY (media_coverage_id) REFERENCES media_coverage_mediacoveragerecord(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ik_event_listing_types d77e08605546b732ffad03feb72d8842; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types
    ADD CONSTRAINT d77e08605546b732ffad03feb72d8842 FOREIGN KEY (eventcontentlistingitem_id) REFERENCES contentitem_ik_event_listing_eventcontentlistingitem(contentitem_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_horizontal_rule_horizontalruleitem d911dd914117c1d1c487abc3150a95ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_horizontal_rule_horizontalruleitem
    ADD CONSTRAINT d911dd914117c1d1c487abc3150a95ca FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_film_film_formats db2cf1e3042436ba060c1900a6be65e5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_film_film_formats
    ADD CONSTRAINT db2cf1e3042436ba060c1900a6be65e5 FOREIGN KEY (film_id) REFERENCES gk_collections_film_film(workbase_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: biennale_of_sydney_eventartist db616a9577260b6f22c1425e4276bbe5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_eventartist
    ADD CONSTRAINT db616a9577260b6f22c1425e4276bbe5 FOREIGN KEY (artist_id) REFERENCES gk_collections_work_creator_creatorbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: staff_profiles_staffprofile_department department_id_1193113b968f1256_fk_staff_profiles_department_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY staff_profiles_staffprofile_department
    ADD CONSTRAINT department_id_1193113b968f1256_fk_staff_profiles_department_id FOREIGN KEY (department_id) REFERENCES staff_profiles_department(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventbase derived_from_id_4ca94a5c35555e18_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT derived_from_id_4ca94a5c35555e18_fk_icekit_events_eventbase_id FOREIGN KEY (derived_from_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djcelery_periodictask dj_interval_id_30fa42bc9bf13de3_fk_djcelery_intervalschedule_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT dj_interval_id_30fa42bc9bf13de3_fk_djcelery_intervalschedule_id FOREIGN KEY (interval_id) REFERENCES djcelery_intervalschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log djan_content_type_id_2ee54a0b566322dc_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT djan_content_type_id_2ee54a0b566322dc_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_adm_user_id_178fd86613f54cc7_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_adm_user_id_178fd86613f54cc7_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_redirect django_redirect_site_id_3ec6e9338bffdda8_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_redirect
    ADD CONSTRAINT django_redirect_site_id_3ec6e9338bffdda8_fk_django_site_id FOREIGN KEY (site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djcelery_periodictask djce_crontab_id_7db53a3b5fc74da0_fk_djcelery_crontabschedule_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT djce_crontab_id_7db53a3b5fc74da0_fk_djcelery_crontabschedule_id FOREIGN KEY (crontab_id) REFERENCES djcelery_crontabschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djcelery_taskstate djcelery__worker_id_174e758d707f372f_fk_djcelery_workerstate_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_taskstate
    ADD CONSTRAINT djcelery__worker_id_174e758d707f372f_fk_djcelery_workerstate_id FOREIGN KEY (worker_id) REFERENCES djcelery_workerstate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djkombu_message djkombu_message_queue_id_5a2601c8ff6bdff9_fk_djkombu_queue_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_message
    ADD CONSTRAINT djkombu_message_queue_id_5a2601c8ff6bdff9_fk_djkombu_queue_id FOREIGN KEY (queue_id) REFERENCES djkombu_queue(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_press_releases_pressrelease e282bd2ef32fe88c09087e4fe5dc4c75; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease
    ADD CONSTRAINT e282bd2ef32fe88c09087e4fe5dc4c75 FOREIGN KEY (publishing_linked_id) REFERENCES icekit_press_releases_pressrelease(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_game_game_genres e6aac5ea62ec253f18374d941a948122; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game_genres
    ADD CONSTRAINT e6aac5ea62ec253f18374d941a948122 FOREIGN KEY (game_id) REFERENCES gk_collections_game_game(workbase_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_image_gallery_imagegalleryshowitem e6edc2436de4d1702f11091b91f6a464; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_image_gallery_imagegalleryshowitem
    ADD CONSTRAINT e6edc2436de4d1702f11091b91f6a464 FOREIGN KEY (slide_show_id) REFERENCES icekit_plugins_slideshow_slideshow(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_navigation_navigationitem e877e92a30aa505dcd6f2956360b7142; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_navigation_navigationitem
    ADD CONSTRAINT e877e92a30aa505dcd6f2956360b7142 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: advanced_event_listing_page_locations e98e3a40f1408117c5b7a98ef282d40a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY advanced_event_listing_page_locations
    ADD CONSTRAINT e98e3a40f1408117c5b7a98ef282d40a FOREIGN KEY (advancedeventlistingpage_id) REFERENCES pagetype_advancedeventlisting_advancedeventlistingpage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: easy_thumbnails_thumbnaildimensions e_thumbnail_id_5e1d9464da9a2f72_fk_easy_thumbnails_thumbnail_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnaildimensions
    ADD CONSTRAINT e_thumbnail_id_5e1d9464da9a2f72_fk_easy_thumbnails_thumbnail_id FOREIGN KEY (thumbnail_id) REFERENCES easy_thumbnails_thumbnail(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_work_creator_workbase eaec2f6dd1aa93f3a871c63f814e83ae; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workbase
    ADD CONSTRAINT eaec2f6dd1aa93f3a871c63f814e83ae FOREIGN KEY (publishing_linked_id) REFERENCES gk_collections_work_creator_workbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: easy_thumbnails_thumbnail easy_th_source_id_4ae2708751edd0eb_fk_easy_thumbnails_source_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnail
    ADD CONSTRAINT easy_th_source_id_4ae2708751edd0eb_fk_easy_thumbnails_source_id FOREIGN KEY (source_id) REFERENCES easy_thumbnails_source(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_advancedeventlisting_advancedeventlistingpage ed75959a8013b7d0262cd68eab7c0336; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_advancedeventlisting_advancedeventlistingpage
    ADD CONSTRAINT ed75959a8013b7d0262cd68eab7c0336 FOREIGN KEY (publishing_linked_id) REFERENCES pagetype_advancedeventlisting_advancedeventlistingpage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_work_creator_workimage f100ec9ee6e70fa37759010e4d24cab1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workimage
    ADD CONSTRAINT f100ec9ee6e70fa37759010e4d24cab1 FOREIGN KEY (work_id) REFERENCES gk_collections_work_creator_workbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_rawhtml_rawhtmlitem f119b486cffb5b1c2b5628554f3b1cd1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_rawhtml_rawhtmlitem
    ADD CONSTRAINT f119b486cffb5b1c2b5628554f3b1cd1 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: biennale_of_sydney_biennalelocation f13f36b87671005809e6bb049279b44d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY biennale_of_sydney_biennalelocation
    ADD CONSTRAINT f13f36b87671005809e6bb049279b44d FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_gk_collections_links_creatorlink f42c7f9c308d59569a87620a020674e6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_gk_collections_links_creatorlink
    ADD CONSTRAINT f42c7f9c308d59569a87620a020674e6 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_glamkit_sponsors_sponsorpromoitem f540f0666a3186d9626e43d5861223fe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_sponsorpromoitem
    ADD CONSTRAINT f540f0666a3186d9626e43d5861223fe FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_authorlisting f6c829e36c98dd75434664f55cbfa5f6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT f6c829e36c98dd75434664f55cbfa5f6 FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: advanced_event_listing_page_locations f7c2c621dcf3c5dbf781d8bfac086090; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY advanced_event_listing_page_locations
    ADD CONSTRAINT f7c2c621dcf3c5dbf781d8bfac086090 FOREIGN KEY (location_id) REFERENCES icekit_plugins_location_location(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_game_game fbcbf332d46d0a97d9a2fb355d77f90f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_game_game
    ADD CONSTRAINT fbcbf332d46d0a97d9a2fb355d77f90f FOREIGN KEY (media_type_id) REFERENCES gk_collections_moving_image_mediatype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_plugins_file_file_categories fi_mediacategory_id_6d12e20e449ffd9b_fk_icekit_mediacategory_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories
    ADD CONSTRAINT fi_mediacategory_id_6d12e20e449ffd9b_fk_icekit_mediacategory_id FOREIGN KEY (mediacategory_id) REFERENCES icekit_mediacategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_plugins_file_file_categories file_file_categories_file_id_389afbef97ad1118_fk_file_file_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories
    ADD CONSTRAINT file_file_categories_file_id_389afbef97ad1118_fk_file_file_id FOREIGN KEY (file_id) REFERENCES icekit_plugins_file_file(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_contents_contentitem fluen_parent_type_id_1f12adfddd577f27_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem
    ADD CONSTRAINT fluen_parent_type_id_1f12adfddd577f27_fk_django_content_type_id FOREIGN KEY (parent_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_contents_placeholder fluen_parent_type_id_727fd7ca8fda0a5e_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_placeholder
    ADD CONSTRAINT fluen_parent_type_id_727fd7ca8fda0a5e_fk_django_content_type_id FOREIGN KEY (parent_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_pages_urlnode fluent_p_author_id_48a0e14b2ce15a16_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_p_author_id_48a0e14b2ce15a16_fk_polymorphic_auth_user_id FOREIGN KEY (author_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_pages_htmlpage_translation fluent_pa_master_id_43dd5c14deaa84c5_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_htmlpage_translation
    ADD CONSTRAINT fluent_pa_master_id_43dd5c14deaa84c5_fk_fluent_pages_urlnode_id FOREIGN KEY (master_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_pages_urlnode_translation fluent_pa_master_id_51656e998d3a4e7f_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode_translation
    ADD CONSTRAINT fluent_pa_master_id_51656e998d3a4e7f_fk_fluent_pages_urlnode_id FOREIGN KEY (master_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_pages_urlnode fluent_pa_parent_id_24d344859f6ba737_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_pa_parent_id_24d344859f6ba737_fk_fluent_pages_urlnode_id FOREIGN KEY (parent_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_pages_urlnode fluent_pages__parent_site_id_7c7e12844aeac5be_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_pages__parent_site_id_7c7e12844aeac5be_fk_django_site_id FOREIGN KEY (parent_site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: forms_field forms_field_form_id_63df41bfc9df0063_fk_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_field
    ADD CONSTRAINT forms_field_form_id_63df41bfc9df0063_fk_forms_form_id FOREIGN KEY (form_id) REFERENCES forms_form(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: forms_fieldentry forms_fieldentr_entry_id_45c5ce4b74da34ab_fk_forms_formentry_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_fieldentry
    ADD CONSTRAINT forms_fieldentr_entry_id_45c5ce4b74da34ab_fk_forms_formentry_id FOREIGN KEY (entry_id) REFERENCES forms_formentry(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: forms_form_sites forms_form_sites_form_id_39d26f06536cb341_fk_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites
    ADD CONSTRAINT forms_form_sites_form_id_39d26f06536cb341_fk_forms_form_id FOREIGN KEY (form_id) REFERENCES forms_form(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: forms_form_sites forms_form_sites_site_id_7e4877889795e942_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites
    ADD CONSTRAINT forms_form_sites_site_id_7e4877889795e942_fk_django_site_id FOREIGN KEY (site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: forms_formentry forms_formentry_form_id_3c29d14f599b7db5_fk_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_formentry
    ADD CONSTRAINT forms_formentry_form_id_3c29d14f599b7db5_fk_forms_form_id FOREIGN KEY (form_id) REFERENCES forms_form(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: glamkit_collections_geographiclocation g_country_id_7bbd18ec1ea34907_fk_glamkit_collections_country_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_collections_geographiclocation
    ADD CONSTRAINT g_country_id_7bbd18ec1ea34907_fk_glamkit_collections_country_id FOREIGN KEY (country_id) REFERENCES glamkit_collections_country(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_film_film_formats gk__format_id_2a8e47095f6ce5c0_fk_gk_collections_film_format_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_film_film_formats
    ADD CONSTRAINT gk__format_id_2a8e47095f6ce5c0_fk_gk_collections_film_format_id FOREIGN KEY (format_id) REFERENCES gk_collections_film_format(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_work_creator_workimage gk_c_image_id_21ad8c725e0e1053_fk_icekit_plugins_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workimage
    ADD CONSTRAINT gk_c_image_id_21ad8c725e0e1053_fk_icekit_plugins_image_image_id FOREIGN KEY (image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_work_creator_workbase gk_collections_w_layout_id_138b5c99407b6bac_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workbase
    ADD CONSTRAINT gk_collections_w_layout_id_138b5c99407b6bac_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_work_creator_creatorbase gk_collections_wo_layout_id_bb3f2fc6fe843ca_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_creatorbase
    ADD CONSTRAINT gk_collections_wo_layout_id_bb3f2fc6fe843ca_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_work_creator_creatorbase gk_portrait_id_7feee241f900c3d_fk_icekit_plugins_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_creatorbase
    ADD CONSTRAINT gk_portrait_id_7feee241f900c3d_fk_icekit_plugins_image_image_id FOREIGN KEY (portrait_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: glamkit_sponsors_sponsor glamk_logo_id_478c69b579f53a09_fk_icekit_plugins_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_sponsors_sponsor
    ADD CONSTRAINT glamk_logo_id_478c69b579f53a09_fk_icekit_plugins_image_image_id FOREIGN KEY (logo_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_event_types_simple_simpleevent hero_image_id_8100f4b170301f7_fk_icekit_plugins_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_event_types_simple_simpleevent
    ADD CONSTRAINT hero_image_id_8100f4b170301f7_fk_icekit_plugins_image_image_id FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_workflow_workflowstate ice_assigned_to_id_4edebb14efe37660_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_workflow_workflowstate
    ADD CONSTRAINT ice_assigned_to_id_4edebb14efe37660_fk_polymorphic_auth_user_id FOREIGN KEY (assigned_to_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventbase_secondary_types ice_eventbase_id_34db9ad2f14a3a65_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types
    ADD CONSTRAINT ice_eventbase_id_34db9ad2f14a3a65_fk_icekit_events_eventbase_id FOREIGN KEY (eventbase_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventbase_secondary_types ice_eventtype_id_79756bd11e9773c8_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types
    ADD CONSTRAINT ice_eventtype_id_79756bd11e9773c8_fk_icekit_events_eventtype_id FOREIGN KEY (eventtype_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_layout_content_types iceki_contenttype_id_53e706733b0edd45_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types
    ADD CONSTRAINT iceki_contenttype_id_53e706733b0edd45_fk_django_content_type_id FOREIGN KEY (contenttype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventbase iceki_part_of_id_65af7f7d497c149e_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT iceki_part_of_id_65af7f7d497c149e_fk_icekit_events_eventbase_id FOREIGN KEY (part_of_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventrepeatsgenerator icekit__event_id_62844f3d1735101f_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventrepeatsgenerator
    ADD CONSTRAINT icekit__event_id_62844f3d1735101f_fk_icekit_events_eventbase_id FOREIGN KEY (event_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_occurrence icekit__event_id_69a2fab89444d0ec_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_occurrence
    ADD CONSTRAINT icekit__event_id_69a2fab89444d0ec_fk_icekit_events_eventbase_id FOREIGN KEY (event_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_article_article icekit_article_ar_layout_id_942e01deec90889_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT icekit_article_ar_layout_id_942e01deec90889_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_event_types_simple_simpleevent icekit_event_typ_layout_id_5f7f673ee61c0203_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_event_types_simple_simpleevent
    ADD CONSTRAINT icekit_event_typ_layout_id_5f7f673ee61c0203_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_layout_content_types icekit_layout_co_layout_id_4e2ea79860c2f50f_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types
    ADD CONSTRAINT icekit_layout_co_layout_id_4e2ea79860c2f50f_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_plugins_location_location icekit_plugins_l_layout_id_23818f2a03e33192_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_location_location
    ADD CONSTRAINT icekit_plugins_l_layout_id_23818f2a03e33192_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_press_releases_pressrelease icekit_press_rel_layout_id_3289eb88e4e22283_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease
    ADD CONSTRAINT icekit_press_rel_layout_id_3289eb88e4e22283_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ik_todays_occurrences_types ik__eventtype_id_197662b242e4476e_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types
    ADD CONSTRAINT ik__eventtype_id_197662b242e4476e_fk_icekit_events_eventtype_id FOREIGN KEY (eventtype_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ik_event_listing_types ik__eventtype_id_44ae6eb990faf9e5_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types
    ADD CONSTRAINT ik__eventtype_id_44ae6eb990faf9e5_fk_icekit_events_eventtype_id FOREIGN KEY (eventtype_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_plugins_image_image_categories im_mediacategory_id_4bb2fc7b461c411b_fk_icekit_mediacategory_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories
    ADD CONSTRAINT im_mediacategory_id_4bb2fc7b461c411b_fk_icekit_mediacategory_id FOREIGN KEY (mediacategory_id) REFERENCES icekit_mediacategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_plugins_image_image_categories image_image_categor_image_id_1917b221ad5c13aa_fk_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories
    ADD CONSTRAINT image_image_categor_image_id_1917b221ad5c13aa_fk_image_image_id FOREIGN KEY (image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_file mo_setting_ptr_id_113d1b787f766741_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_file
    ADD CONSTRAINT mo_setting_ptr_id_113d1b787f766741_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_date mo_setting_ptr_id_29c91ee728f688ef_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_date
    ADD CONSTRAINT mo_setting_ptr_id_29c91ee728f688ef_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_decimal mo_setting_ptr_id_2b369a48d606cac5_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_decimal
    ADD CONSTRAINT mo_setting_ptr_id_2b369a48d606cac5_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_datetime mo_setting_ptr_id_34e30ee97d2048ac_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_datetime
    ADD CONSTRAINT mo_setting_ptr_id_34e30ee97d2048ac_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_image mo_setting_ptr_id_3f23eae7a4e997a1_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_image
    ADD CONSTRAINT mo_setting_ptr_id_3f23eae7a4e997a1_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_text mo_setting_ptr_id_48daa82a6aa7fe86_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_text
    ADD CONSTRAINT mo_setting_ptr_id_48daa82a6aa7fe86_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_integer mo_setting_ptr_id_68280d43a706a6a2_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_integer
    ADD CONSTRAINT mo_setting_ptr_id_68280d43a706a6a2_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_float mo_setting_ptr_id_7f7d099d8f8725f8_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_float
    ADD CONSTRAINT mo_setting_ptr_id_7f7d099d8f8725f8_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_time mod_setting_ptr_id_61969392ea8ba04_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_time
    ADD CONSTRAINT mod_setting_ptr_id_61969392ea8ba04_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_boolean mod_setting_ptr_id_b37b200bcd8b634_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_boolean
    ADD CONSTRAINT mod_setting_ptr_id_b37b200bcd8b634_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_hasreadmessage no_message_id_15fc655d81d42216_fk_notifications_notification_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_hasreadmessage
    ADD CONSTRAINT no_message_id_15fc655d81d42216_fk_notifications_notification_id FOREIGN KEY (message_id) REFERENCES notifications_notification(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_followerinformation noti_content_type_id_25176205787bc640_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation
    ADD CONSTRAINT noti_content_type_id_25176205787bc640_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_hasreadmessage notificat_person_id_2dedfe1b0cc1c4f_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_hasreadmessage
    ADD CONSTRAINT notificat_person_id_2dedfe1b0cc1c4f_fk_polymorphic_auth_user_id FOREIGN KEY (person_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_notificationsetting notificati_user_id_1c79438b0db29f34_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notificationsetting
    ADD CONSTRAINT notificati_user_id_1c79438b0db29f34_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_followerinformation_followers notificati_user_id_3691e04f15b23ca5_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers
    ADD CONSTRAINT notificati_user_id_3691e04f15b23ca5_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_notification notificatio_user_id_d2c749d63b98da3_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notification
    ADD CONSTRAINT notificatio_user_id_d2c749d63b98da3_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_followerinformation_group_followers notifications_followe_group_id_382aa5d41b382c4_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers
    ADD CONSTRAINT notifications_followe_group_id_382aa5d41b382c4_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_articlecategorypage page_urlnode_ptr_id_40da7b79440f8d12_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT page_urlnode_ptr_id_40da7b79440f8d12_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_searchpage page_urlnode_ptr_id_53ae5eb493a47a4c_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_searchpage
    ADD CONSTRAINT page_urlnode_ptr_id_53ae5eb493a47a4c_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_eventlistingfordate_eventlistingpage page_urlnode_ptr_id_5b75ee30fd561da9_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT page_urlnode_ptr_id_5b75ee30fd561da9_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_advancedeventlisting_advancedeventlistingpage page_urlnode_ptr_id_63bcba6bf160295f_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_advancedeventlisting_advancedeventlistingpage
    ADD CONSTRAINT page_urlnode_ptr_id_63bcba6bf160295f_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_authorlisting page_urlnode_ptr_id_658163482a77657e_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT page_urlnode_ptr_id_658163482a77657e_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_textfile_textfile page_urlnode_ptr_id_6b6781a553c29892_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_textfile_textfile
    ADD CONSTRAINT page_urlnode_ptr_id_6b6781a553c29892_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_icekit_press_releases_pressreleaselisting paget_urlnode_ptr_id_196702bf44e24ca_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT paget_urlnode_ptr_id_196702bf44e24ca_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_layoutpage paget_urlnode_ptr_id_39f01de3c44de8c_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT paget_urlnode_ptr_id_39f01de3c44de8c_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_redirectnode_redirectnode paget_urlnode_ptr_id_7df0d132fff2d84_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_redirectnode_redirectnode
    ADD CONSTRAINT paget_urlnode_ptr_id_7df0d132fff2d84_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_fluentpage_fluentpage paget_urlnode_ptr_id_d1f152530963fce_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_fluentpage_fluentpage
    ADD CONSTRAINT paget_urlnode_ptr_id_d1f152530963fce_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_fluentpage_fluentpage pagety_layout_id_61335d7d1a3d259b_fk_fluent_pages_pagelayout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_fluentpage_fluentpage
    ADD CONSTRAINT pagety_layout_id_61335d7d1a3d259b_fk_fluent_pages_pagelayout_id FOREIGN KEY (layout_id) REFERENCES fluent_pages_pagelayout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_advancedeventlisting_advancedeventlistingpage pagetype_advance_layout_id_415f903e3610b5bc_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_advancedeventlisting_advancedeventlistingpage
    ADD CONSTRAINT pagetype_advance_layout_id_415f903e3610b5bc_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_eventlistingfordate_eventlistingpage pagetype_eventli_layout_id_3dec48548ec94eee_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT pagetype_eventli_layout_id_3dec48548ec94eee_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_icekit_press_releases_pressreleaselisting pagetype_icekit__layout_id_35f66b5d4ec658cd_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT pagetype_icekit__layout_id_35f66b5d4ec658cd_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_authorlisting pagetype_icekit__layout_id_4565bf2de46f5f67_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT pagetype_icekit__layout_id_4565bf2de46f5f67_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_articlecategorypage pagetype_icekit__layout_id_76b69dbbfe8b61a9_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT pagetype_icekit__layout_id_76b69dbbfe8b61a9_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_layoutpage pagetype_layout__layout_id_4e10f6e36b84a4e9_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT pagetype_layout__layout_id_4e10f6e36b84a4e9_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: post_office_email po_template_id_2289630bd12d88ef_fk_post_office_emailtemplate_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_email
    ADD CONSTRAINT po_template_id_2289630bd12d88ef_fk_post_office_emailtemplate_id FOREIGN KEY (template_id) REFERENCES post_office_emailtemplate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphic_auth_email_emailuser polymo_user_ptr_id_269f2dcc6921c94e_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_email_emailuser
    ADD CONSTRAINT polymo_user_ptr_id_269f2dcc6921c94e_fk_polymorphic_auth_user_id FOREIGN KEY (user_ptr_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphic_auth_user_user_permissions polymorphi_permission_id_445ec93de921e13f_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions
    ADD CONSTRAINT polymorphi_permission_id_445ec93de921e13f_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphic_auth_user_groups polymorphi_user_id_1a43fe0feea7817f_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups
    ADD CONSTRAINT polymorphi_user_id_1a43fe0feea7817f_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphic_auth_user_user_permissions polymorphi_user_id_5d3c23423daa2db1_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions
    ADD CONSTRAINT polymorphi_user_id_5d3c23423daa2db1_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphic_auth_user_groups polymorphic_auth_use_group_id_139972f731376246_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups
    ADD CONSTRAINT polymorphic_auth_use_group_id_139972f731376246_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: post_office_attachment_emails pos_attachment_id_3fdc547fc6c12601_fk_post_office_attachment_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails
    ADD CONSTRAINT pos_attachment_id_3fdc547fc6c12601_fk_post_office_attachment_id FOREIGN KEY (attachment_id) REFERENCES post_office_attachment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: post_office_attachment_emails post_office_a_email_id_3a9ef88c50a50be1_fk_post_office_email_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails
    ADD CONSTRAINT post_office_a_email_id_3a9ef88c50a50be1_fk_post_office_email_id FOREIGN KEY (email_id) REFERENCES post_office_email(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: post_office_log post_office_l_email_id_2d14eab2f4726aa0_fk_post_office_email_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_log
    ADD CONSTRAINT post_office_l_email_id_2d14eab2f4726aa0_fk_post_office_email_id FOREIGN KEY (email_id) REFERENCES post_office_email(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventbase primary_type_id_33cef4a4045a994b_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT primary_type_id_33cef4a4045a994b_fk_icekit_events_eventtype_id FOREIGN KEY (primary_type_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_plugins_slideshow_slideshow publishing_linked_id_e78e7cfa7283c46_fk_slideshow_slideshow_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_slideshow_slideshow
    ADD CONSTRAINT publishing_linked_id_e78e7cfa7283c46_fk_slideshow_slideshow_id FOREIGN KEY (publishing_linked_id) REFERENCES icekit_plugins_slideshow_slideshow(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reversion_version reve_content_type_id_5ab7252998e91e33_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_version
    ADD CONSTRAINT reve_content_type_id_5ab7252998e91e33_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reversion_revision reversion__user_id_19fa399f76509e74_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_revision
    ADD CONSTRAINT reversion__user_id_19fa399f76509e74_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reversion_version reversion_revision_id_5fe76f2d5382a428_fk_reversion_revision_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_version
    ADD CONSTRAINT reversion_revision_id_5fe76f2d5382a428_fk_reversion_revision_id FOREIGN KEY (revision_id) REFERENCES reversion_revision(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: sharedcontent_sharedcontent_translation sh_master_id_399b59107f18e84c_fk_sharedcontent_sharedcontent_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent_translation
    ADD CONSTRAINT sh_master_id_399b59107f18e84c_fk_sharedcontent_sharedcontent_id FOREIGN KEY (master_id) REFERENCES sharedcontent_sharedcontent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: sharedcontent_sharedcontent sharedcontent_parent_site_id_76138b47e42fbadb_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent
    ADD CONSTRAINT sharedcontent_parent_site_id_76138b47e42fbadb_fk_django_site_id FOREIGN KEY (parent_site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: staff_profiles_staffprofile staff_prof_user_id_27fbfa855749b863_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY staff_profiles_staffprofile
    ADD CONSTRAINT staff_prof_user_id_27fbfa855749b863_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: taggit_taggeditem tagg_content_type_id_3bf3ec5a0633b47f_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggit_taggeditem
    ADD CONSTRAINT tagg_content_type_id_3bf3ec5a0633b47f_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: taggit_taggeditem taggit_taggeditem_tag_id_455c28cb02bcb710_fk_taggit_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggit_taggeditem
    ADD CONSTRAINT taggit_taggeditem_tag_id_455c28cb02bcb710_fk_taggit_tag_id FOREIGN KEY (tag_id) REFERENCES taggit_tag(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_publishingm2mthroughtable tes_a_model_id_6b356d37c18a348f_fk_tests_publishingm2mmodela_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mthroughtable
    ADD CONSTRAINT tes_a_model_id_6b356d37c18a348f_fk_tests_publishingm2mmodela_id FOREIGN KEY (a_model_id) REFERENCES tests_publishingm2mmodela(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_publishingm2mthroughtable tes_b_model_id_268a0cec22a89694_fk_tests_publishingm2mmodelb_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mthroughtable
    ADD CONSTRAINT tes_b_model_id_268a0cec22a89694_fk_tests_publishingm2mmodelb_id FOREIGN KEY (b_model_id) REFERENCES tests_publishingm2mmodelb(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_article test_ar_publishing_linked_id_39352ef8febefc7_fk_test_article_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT test_ar_publishing_linked_id_39352ef8febefc7_fk_test_article_id FOREIGN KEY (publishing_linked_id) REFERENCES test_article(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_article test_article_layout_id_66816f9a33a3a487_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT test_article_layout_id_66816f9a33a3a487_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_articlelisting test_articlelist_layout_id_769b2185204ae574_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT test_articlelist_layout_id_769b2185204ae574_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_layoutpage_with_related_related_pages test_layout_page_id_19c9ea8952aaa255_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages
    ADD CONSTRAINT test_layout_page_id_19c9ea8952aaa255_fk_fluent_pages_urlnode_id FOREIGN KEY (page_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_layoutpage_with_related test_layoutpage__layout_id_7c2d4ee3603a30d1_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT test_layoutpage__layout_id_7c2d4ee3603a30d1_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_articlelisting test_urlnode_ptr_id_1c1bae8a46ec3717_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT test_urlnode_ptr_id_1c1bae8a46ec3717_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_layoutpage_with_related test_urlnode_ptr_id_6de7a10f4ff347ba_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT test_urlnode_ptr_id_6de7a10f4ff347ba_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_barwithlayout tests_barwithlay_layout_id_2416ac73463cd44a_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_barwithlayout
    ADD CONSTRAINT tests_barwithlay_layout_id_2416ac73463cd44a_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_bazwithlayout tests_bazwithlay_layout_id_268f275fa6c5bbce_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_bazwithlayout
    ADD CONSTRAINT tests_bazwithlay_layout_id_268f275fa6c5bbce_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_foowithlayout tests_foowithlayo_layout_id_1f57df17eefae2b_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_foowithlayout
    ADD CONSTRAINT tests_foowithlayo_layout_id_1f57df17eefae2b_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_workflow_workflowstate work_content_type_id_6fc720eba7077388_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_workflow_workflowstate
    ADD CONSTRAINT work_content_type_id_6fc720eba7077388_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

