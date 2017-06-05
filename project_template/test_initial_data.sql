--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

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
    exclude_from_contributions boolean NOT NULL
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
    meta_keywords character varying(255),
    meta_description character varying(255),
    meta_title character varying(255),
    master_id integer
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
    layout_id integer
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
    brief text NOT NULL
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
    external_ref character varying(255) NOT NULL,
    CONSTRAINT icekit_plugins__maximum_dimension_pixels_4cc2ace4519637a2_check CHECK ((maximum_dimension_pixels >= 0)),
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
    name character varying(255) NOT NULL
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
-- Name: icekit_plugins_slideshow_slideshow id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_slideshow_slideshow ALTER COLUMN id SET DEFAULT nextval('slideshow_slideshow_id_seq'::regclass);


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
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: -
--

COPY auth_group (id, name) FROM stdin;
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('auth_group_id_seq', 10, true);


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
395	Can Use IIIF Image API	134	can_use_iiif_image_api
396	Can add layout	135	add_layout
397	Can change layout	135	change_layout
398	Can delete layout	135	delete_layout
399	Can add Asset category	136	add_mediacategory
400	Can change Asset category	136	change_mediacategory
401	Can delete Asset category	136	delete_mediacategory
402	Can add user	134	add_user
403	Can change user	134	change_user
404	Can delete user	134	delete_user
405	Can add Form entry	138	add_formentry
406	Can change Form entry	138	change_formentry
407	Can delete Form entry	138	delete_formentry
408	Can add Form field entry	139	add_fieldentry
409	Can change Form field entry	139	change_fieldentry
410	Can delete Form field entry	139	delete_fieldentry
411	Can add Form	140	add_form
412	Can change Form	140	change_form
413	Can delete Form	140	delete_form
414	Can add Field	141	add_field
415	Can change Field	141	change_field
416	Can delete Field	141	delete_field
417	Can add revision	142	add_revision
418	Can change revision	142	change_revision
419	Can delete revision	142	delete_revision
420	Can add version	143	add_version
421	Can change version	143	change_version
422	Can delete version	143	delete_version
423	Can add log entry	144	add_logentry
424	Can change log entry	144	change_logentry
425	Can delete log entry	144	delete_logentry
426	Can add permission	145	add_permission
427	Can change permission	145	change_permission
428	Can delete permission	145	delete_permission
429	Can add group	146	add_group
430	Can change group	146	change_group
431	Can delete group	146	delete_group
432	Can add content type	147	add_contenttype
433	Can change content type	147	change_contenttype
434	Can delete content type	147	delete_contenttype
435	Can add session	148	add_session
436	Can change session	148	change_session
437	Can delete session	148	delete_session
438	Can add redirect	149	add_redirect
439	Can change redirect	149	change_redirect
440	Can delete redirect	149	delete_redirect
441	Can add site	150	add_site
442	Can change site	150	change_site
443	Can delete site	150	delete_site
444	Can add task state	151	add_taskmeta
445	Can change task state	151	change_taskmeta
446	Can delete task state	151	delete_taskmeta
447	Can add saved group result	152	add_tasksetmeta
448	Can change saved group result	152	change_tasksetmeta
449	Can delete saved group result	152	delete_tasksetmeta
450	Can add interval	153	add_intervalschedule
451	Can change interval	153	change_intervalschedule
452	Can delete interval	153	delete_intervalschedule
453	Can add crontab	154	add_crontabschedule
454	Can change crontab	154	change_crontabschedule
455	Can delete crontab	154	delete_crontabschedule
456	Can add periodic tasks	155	add_periodictasks
457	Can change periodic tasks	155	change_periodictasks
458	Can delete periodic tasks	155	delete_periodictasks
459	Can add periodic task	156	add_periodictask
460	Can change periodic task	156	change_periodictask
461	Can delete periodic task	156	delete_periodictask
462	Can add worker	157	add_workerstate
463	Can change worker	157	change_workerstate
464	Can delete worker	157	delete_workerstate
465	Can add task	158	add_taskstate
466	Can change task	158	change_taskstate
467	Can delete task	158	delete_taskstate
468	Can add queue	159	add_queue
469	Can change queue	159	change_queue
470	Can delete queue	159	delete_queue
471	Can add message	160	add_message
472	Can change message	160	change_message
473	Can delete message	160	delete_message
474	Can add source	161	add_source
475	Can change source	161	change_source
476	Can delete source	161	delete_source
477	Can add thumbnail	162	add_thumbnail
478	Can change thumbnail	162	change_thumbnail
479	Can delete thumbnail	162	delete_thumbnail
480	Can add thumbnail dimensions	163	add_thumbnaildimensions
481	Can change thumbnail dimensions	163	change_thumbnaildimensions
482	Can delete thumbnail dimensions	163	delete_thumbnaildimensions
483	Can add Placeholder	164	add_placeholder
484	Can change Placeholder	164	change_placeholder
485	Can delete Placeholder	164	delete_placeholder
486	Can add Contentitem link	165	add_contentitem
487	Can change Contentitem link	165	change_contentitem
488	Can delete Contentitem link	165	delete_contentitem
489	Can add URL Node	166	add_urlnode
490	Can change URL Node	166	change_urlnode
491	Can delete URL Node	166	delete_urlnode
492	Can change Shared fields	166	change_shared_fields_urlnode
493	Can change Override URL field	166	change_override_url_urlnode
494	Can add URL Node translation	167	add_urlnode_translation
495	Can change URL Node translation	167	change_urlnode_translation
496	Can delete URL Node translation	167	delete_urlnode_translation
497	Can add Page	166	add_page
498	Can change Page	166	change_page
499	Can delete Page	166	delete_page
500	Can add html page	166	add_htmlpage
501	Can change html page	166	change_htmlpage
502	Can delete html page	166	delete_htmlpage
503	Can add Layout	169	add_pagelayout
504	Can change Layout	169	change_pagelayout
505	Can delete Layout	169	delete_pagelayout
506	Can add Redirect	173	add_redirectnode
507	Can change Redirect	173	change_redirectnode
508	Can delete Redirect	173	delete_redirectnode
509	Can add Plain text file	175	add_textfile
510	Can change Plain text file	175	change_textfile
511	Can delete Plain text file	175	delete_textfile
512	Can add Iframe	176	add_iframeitem
513	Can change Iframe	176	change_iframeitem
514	Can delete Iframe	176	delete_iframeitem
515	Can add Online media	177	add_oembeditem
516	Can change Online media	177	change_oembeditem
517	Can delete Online media	177	delete_oembeditem
518	Can add HTML code	178	add_rawhtmlitem
519	Can change HTML code	178	change_rawhtmlitem
520	Can delete HTML code	178	delete_rawhtmlitem
521	Can add Shared content	180	add_sharedcontent
522	Can change Shared content	180	change_sharedcontent
523	Can delete Shared content	180	delete_sharedcontent
524	Can add Shared content	181	add_sharedcontentitem
525	Can change Shared content	181	change_sharedcontentitem
526	Can delete Shared content	181	delete_sharedcontentitem
527	Can add workflow state	182	add_workflowstate
528	Can change workflow state	182	change_workflowstate
529	Can delete workflow state	182	delete_workflowstate
530	Can add response page	183	add_responsepage
531	Can change response page	183	change_responsepage
532	Can delete response page	183	delete_responsepage
533	Can add notification setting	184	add_notificationsetting
534	Can change notification setting	184	change_notificationsetting
535	Can delete notification setting	184	delete_notificationsetting
536	Can add has read message	185	add_hasreadmessage
537	Can change has read message	185	change_hasreadmessage
538	Can delete has read message	185	delete_hasreadmessage
539	Can add notification	186	add_notification
540	Can change notification	186	change_notification
541	Can delete notification	186	delete_notification
542	Can add follower information	187	add_followerinformation
543	Can change follower information	187	change_followerinformation
544	Can delete follower information	187	delete_followerinformation
545	Can Publish Article	188	can_publish
546	Can Republish Article	188	can_republish
547	Can Publish ArticleCategoryPage	189	can_publish
548	Can Republish ArticleCategoryPage	189	can_republish
549	Can add article	188	add_article
550	Can change article	188	change_article
551	Can delete article	188	delete_article
552	Can add article category page	189	add_articlecategorypage
553	Can change article category page	189	change_articlecategorypage
554	Can delete article category page	189	delete_articlecategorypage
555	Can Publish AuthorListing	190	can_publish
556	Can Republish AuthorListing	190	can_republish
557	Can Publish Author	191	can_publish
558	Can Republish Author	191	can_republish
559	Can add author listing	190	add_authorlisting
560	Can change author listing	190	change_authorlisting
561	Can delete author listing	190	delete_authorlisting
562	Can add author	191	add_author
563	Can change author	191	change_author
564	Can delete author	191	delete_author
565	Can Publish LayoutPage	192	can_publish
566	Can Republish LayoutPage	192	can_republish
567	Can add Page	192	add_layoutpage
568	Can change Page	192	change_layoutpage
569	Can delete Page	192	delete_layoutpage
570	Can Publish SearchPage	193	can_publish
571	Can Republish SearchPage	193	can_republish
572	Can add search page	193	add_searchpage
573	Can change search page	193	change_searchpage
574	Can delete search page	193	delete_searchpage
575	Can add Child Pages	194	add_childpageitem
576	Can change Child Pages	194	change_childpageitem
577	Can delete Child Pages	194	delete_childpageitem
578	Can add contact person	195	add_contactperson
579	Can change contact person	195	change_contactperson
580	Can delete contact person	195	delete_contactperson
581	Can add Contact Person	196	add_contactpersonitem
582	Can change Contact Person	196	change_contactpersonitem
583	Can delete Contact Person	196	delete_contactpersonitem
584	Can add Content Listing	197	add_contentlistingitem
585	Can change Content Listing	197	change_contentlistingitem
586	Can delete Content Listing	197	delete_contentlistingitem
587	Can add FAQ	198	add_faqitem
588	Can change FAQ	198	change_faqitem
589	Can delete FAQ	198	delete_faqitem
590	Can add file	199	add_file
591	Can change file	199	change_file
592	Can delete file	199	delete_file
593	Can add File	200	add_fileitem
594	Can change File	200	change_fileitem
595	Can delete File	200	delete_fileitem
596	Can add Horizontal Rule	201	add_horizontalruleitem
597	Can change Horizontal Rule	201	change_horizontalruleitem
598	Can delete Horizontal Rule	201	delete_horizontalruleitem
599	Can add image	202	add_image
600	Can change image	202	change_image
601	Can delete image	202	delete_image
602	Can add Image	203	add_imageitem
603	Can change Image	203	change_imageitem
604	Can delete Image	203	delete_imageitem
605	Can add Image derivative	204	add_imagerepurposeconfig
606	Can change Image derivative	204	change_imagerepurposeconfig
607	Can delete Image derivative	204	delete_imagerepurposeconfig
608	Can add Instagram Embed	205	add_instagramembeditem
609	Can change Instagram Embed	205	change_instagramembeditem
610	Can delete Instagram Embed	205	delete_instagramembeditem
611	Can add Page link	206	add_pagelink
612	Can change Page link	206	change_pagelink
613	Can delete Page link	206	delete_pagelink
614	Can add Article link	207	add_articlelink
615	Can change Article link	207	change_articlelink
616	Can delete Article link	207	delete_articlelink
617	Can add Author link	208	add_authorlink
618	Can change Author link	208	change_authorlink
619	Can delete Author link	208	delete_authorlink
620	Can add Google Map	209	add_mapitem
621	Can change Google Map	209	change_mapitem
622	Can delete Google Map	209	delete_mapitem
623	Can add Embedded media	210	add_oembedwithcaptionitem
624	Can change Embedded media	210	change_oembedwithcaptionitem
625	Can delete Embedded media	210	delete_oembedwithcaptionitem
626	Can add Page Anchor	211	add_pageanchoritem
627	Can change Page Anchor	211	change_pageanchoritem
628	Can delete Page Anchor	211	delete_pageanchoritem
629	Can add Page Anchor List	212	add_pageanchorlistitem
630	Can change Page Anchor List	212	change_pageanchorlistitem
631	Can delete Page Anchor List	212	delete_pageanchorlistitem
632	Can add Pull quote	213	add_quoteitem
633	Can change Pull quote	213	change_quoteitem
634	Can delete Pull quote	213	delete_quoteitem
635	Can add Form	214	add_formitem
636	Can change Form	214	change_formitem
637	Can delete Form	214	delete_formitem
638	Can Publish SlideShow	215	can_publish
639	Can Republish SlideShow	215	can_republish
640	Can add Image gallery	215	add_slideshow
641	Can change Image gallery	215	change_slideshow
642	Can delete Image gallery	215	delete_slideshow
643	Can add Slide show	216	add_slideshowitem
644	Can change Slide show	216	change_slideshowitem
645	Can delete Slide show	216	delete_slideshowitem
646	Can add Image Gallery	217	add_imagegalleryshowitem
647	Can change Image Gallery	217	change_imagegalleryshowitem
648	Can delete Image Gallery	217	delete_imagegalleryshowitem
649	Can add Twitter Embed	218	add_twitterembeditem
650	Can change Twitter Embed	218	change_twitterembeditem
651	Can delete Twitter Embed	218	delete_twitterembeditem
652	Can add Text	219	add_textitem
653	Can change Text	219	change_textitem
654	Can delete Text	219	delete_textitem
655	Can Publish EventBase	220	can_publish
656	Can Republish EventBase	220	can_republish
657	Can add recurrence rule	221	add_recurrencerule
658	Can change recurrence rule	221	change_recurrencerule
659	Can delete recurrence rule	221	delete_recurrencerule
660	Can add Event category	222	add_eventtype
661	Can change Event category	222	change_eventtype
662	Can delete Event category	222	delete_eventtype
663	Can add Event	220	add_eventbase
664	Can change Event	220	change_eventbase
665	Can delete Event	220	delete_eventbase
666	Can add event repeats generator	223	add_eventrepeatsgenerator
667	Can change event repeats generator	223	change_eventrepeatsgenerator
668	Can delete event repeats generator	223	delete_eventrepeatsgenerator
669	Can add occurrence	224	add_occurrence
670	Can change occurrence	224	change_occurrence
671	Can delete occurrence	224	delete_occurrence
672	Can Publish SimpleEvent	225	can_publish
673	Can Republish SimpleEvent	225	can_republish
674	Can add Simple event	225	add_simpleevent
675	Can change Simple event	225	change_simpleevent
676	Can delete Simple event	225	delete_simpleevent
677	Can add Event Content Listing	226	add_eventcontentlistingitem
678	Can change Event Content Listing	226	change_eventcontentlistingitem
679	Can delete Event Content Listing	226	delete_eventcontentlistingitem
680	Can add Event link	227	add_eventlink
681	Can change Event link	227	change_eventlink
682	Can delete Event link	227	delete_eventlink
683	Can add Today's events	228	add_todaysoccurrences
684	Can change Today's events	228	change_todaysoccurrences
685	Can delete Today's events	228	delete_todaysoccurrences
686	Can Publish EventListingPage	229	can_publish
687	Can Republish EventListingPage	229	can_republish
688	Can add Event listing for date	229	add_eventlistingpage
689	Can change Event listing for date	229	change_eventlistingpage
690	Can delete Event listing for date	229	delete_eventlistingpage
691	Can add setting	230	add_setting
692	Can change setting	230	change_setting
693	Can delete setting	230	delete_setting
694	Can add boolean	231	add_boolean
695	Can change boolean	231	change_boolean
696	Can delete boolean	231	delete_boolean
697	Can add date	232	add_date
698	Can change date	232	change_date
699	Can delete date	232	delete_date
700	Can add date time	233	add_datetime
701	Can change date time	233	change_datetime
702	Can delete date time	233	delete_datetime
703	Can add decimal	234	add_decimal
704	Can change decimal	234	change_decimal
705	Can delete decimal	234	delete_decimal
706	Can add file	235	add_file
707	Can change file	235	change_file
708	Can delete file	235	delete_file
709	Can add float	236	add_float
710	Can change float	236	change_float
711	Can delete float	236	delete_float
712	Can add image	237	add_image
713	Can change image	237	change_image
714	Can delete image	237	delete_image
715	Can add integer	238	add_integer
716	Can change integer	238	change_integer
717	Can delete integer	238	delete_integer
718	Can add text	239	add_text
719	Can change text	239	change_text
720	Can delete text	239	delete_text
721	Can add time	240	add_time
722	Can change time	240	change_time
723	Can delete time	240	delete_time
724	Can add user with email login	137	add_emailuser
725	Can change user with email login	137	change_emailuser
726	Can delete user with email login	137	delete_emailuser
727	Can add Email	241	add_email
728	Can change Email	241	change_email
729	Can delete Email	241	delete_email
730	Can add Log	242	add_log
731	Can change Log	242	change_log
732	Can delete Log	242	delete_log
733	Can add Email Template	243	add_emailtemplate
734	Can change Email Template	243	change_emailtemplate
735	Can delete Email Template	243	delete_emailtemplate
736	Can add Attachment	244	add_attachment
737	Can change Attachment	244	change_attachment
738	Can delete Attachment	244	delete_attachment
739	Can add Page	245	add_fluentpage
740	Can change Page	245	change_fluentpage
741	Can delete Page	245	delete_fluentpage
742	Can change Page layout	245	change_page_layout
743	Can Publish ArticleListing	246	can_publish
744	Can Republish ArticleListing	246	can_republish
745	Can Publish Article	247	can_publish
746	Can Republish Article	247	can_republish
747	Can Publish LayoutPageWithRelatedPages	248	can_publish
748	Can Republish LayoutPageWithRelatedPages	248	can_republish
749	Can Publish PublishingM2MModelA	249	can_publish
750	Can Republish PublishingM2MModelA	249	can_republish
751	Can Publish PublishingM2MModelB	250	can_publish
752	Can Republish PublishingM2MModelB	250	can_republish
753	Can add base model	251	add_basemodel
754	Can change base model	251	change_basemodel
755	Can delete base model	251	delete_basemodel
756	Can add foo with layout	252	add_foowithlayout
757	Can change foo with layout	252	change_foowithlayout
758	Can delete foo with layout	252	delete_foowithlayout
759	Can add bar with layout	253	add_barwithlayout
760	Can change bar with layout	253	change_barwithlayout
761	Can delete bar with layout	253	delete_barwithlayout
762	Can add baz with layout	254	add_bazwithlayout
763	Can change baz with layout	254	change_bazwithlayout
764	Can delete baz with layout	254	delete_bazwithlayout
765	Can add image test	255	add_imagetest
766	Can change image test	255	change_imagetest
767	Can delete image test	255	delete_imagetest
768	Can add article listing	246	add_articlelisting
769	Can change article listing	246	change_articlelisting
770	Can delete article listing	246	delete_articlelisting
771	Can add article	247	add_article
772	Can change article	247	change_article
773	Can delete article	247	delete_article
774	Can add layout page with related pages	248	add_layoutpagewithrelatedpages
775	Can change layout page with related pages	248	change_layoutpagewithrelatedpages
776	Can delete layout page with related pages	248	delete_layoutpagewithrelatedpages
777	Can add publishing m2m model a	249	add_publishingm2mmodela
778	Can change publishing m2m model a	249	change_publishingm2mmodela
779	Can delete publishing m2m model a	249	delete_publishingm2mmodela
780	Can add publishing m2m model b	250	add_publishingm2mmodelb
781	Can change publishing m2m model b	250	change_publishingm2mmodelb
782	Can delete publishing m2m model b	250	delete_publishingm2mmodelb
783	Can add publishing m2m through table	256	add_publishingm2mthroughtable
784	Can change publishing m2m through table	256	change_publishingm2mthroughtable
785	Can delete publishing m2m through table	256	delete_publishingm2mthroughtable
786	Can add Token	257	add_token
787	Can change Token	257	change_token
788	Can delete Token	257	delete_token
\.


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('auth_permission_id_seq', 788, true);


--
-- Data for Name: authtoken_token; Type: TABLE DATA; Schema: public; Owner: -
--

COPY authtoken_token (key, created, user_id) FROM stdin;
\.


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
-- Data for Name: contentitem_icekit_events_links_eventlink; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_events_links_eventlink (contentitem_ptr_id, style, type_override, title_override, oneliner_override, url_override, image_override, item_id, include_even_when_finished) FROM stdin;
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

COPY contentitem_ik_links_authorlink (contentitem_ptr_id, style, type_override, title_override, image_override, item_id, url_override, oneliner_override, exclude_from_contributions) FROM stdin;
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
-- Data for Name: contentitem_oembed_with_caption_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_oembed_with_caption_item (contentitem_ptr_id, embed_url, embed_max_width, embed_max_height, type, url, title, description, author_name, author_url, provider_name, provider_url, thumbnail_url, thumbnail_height, thumbnail_width, height, width, html, caption, is_16by9) FROM stdin;
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
-- Data for Name: contentitem_text_textitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_text_textitem (contentitem_ptr_id, text, style) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
13	2017-06-05 06:36:08.211207+01	91	Test Event	1		225	223
\.


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 15, true);


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_content_type (id, app_label, model) FROM stdin;
134	polymorphic_auth	user
135	icekit	layout
136	icekit	mediacategory
137	polymorphic_auth_email	emailuser
138	forms	formentry
139	forms	fieldentry
140	forms	form
141	forms	field
142	reversion	revision
143	reversion	version
144	admin	logentry
145	auth	permission
146	auth	group
147	contenttypes	contenttype
148	sessions	session
149	redirects	redirect
150	sites	site
151	djcelery	taskmeta
152	djcelery	tasksetmeta
153	djcelery	intervalschedule
154	djcelery	crontabschedule
155	djcelery	periodictasks
156	djcelery	periodictask
157	djcelery	workerstate
158	djcelery	taskstate
159	kombu_transport_django	queue
160	kombu_transport_django	message
161	easy_thumbnails	source
162	easy_thumbnails	thumbnail
163	easy_thumbnails	thumbnaildimensions
164	fluent_contents	placeholder
165	fluent_contents	contentitem
166	fluent_pages	urlnode
167	fluent_pages	urlnode_translation
168	fluent_pages	htmlpagetranslation
169	fluent_pages	pagelayout
170	fluent_pages	htmlpage
171	fluent_pages	page
172	redirectnode	redirectnodetranslation
173	redirectnode	redirectnode
174	textfile	textfiletranslation
175	textfile	textfile
176	iframe	iframeitem
177	oembeditem	oembeditem
178	rawhtml	rawhtmlitem
179	sharedcontent	sharedcontenttranslation
180	sharedcontent	sharedcontent
181	sharedcontent	sharedcontentitem
182	icekit_workflow	workflowstate
183	response_pages	responsepage
184	notifications	notificationsetting
185	notifications	hasreadmessage
186	notifications	notification
187	notifications	followerinformation
188	icekit_article	article
189	icekit_article	articlecategorypage
190	icekit_authors	authorlisting
191	icekit_authors	author
192	layout_page	layoutpage
193	search_page	searchpage
194	icekit_plugins_child_pages	childpageitem
195	icekit_plugins_contact_person	contactperson
196	icekit_plugins_contact_person	contactpersonitem
197	icekit_plugins_content_listing	contentlistingitem
198	icekit_plugins_faq	faqitem
199	icekit_plugins_file	file
200	icekit_plugins_file	fileitem
201	icekit_plugins_horizontal_rule	horizontalruleitem
202	icekit_plugins_image	image
203	icekit_plugins_image	imageitem
204	icekit_plugins_image	imagerepurposeconfig
205	icekit_plugins_instagram_embed	instagramembeditem
206	ik_links	pagelink
207	ik_links	articlelink
208	ik_links	authorlink
209	icekit_plugins_map	mapitem
210	icekit_plugins_oembed_with_caption	oembedwithcaptionitem
211	icekit_plugins_page_anchor	pageanchoritem
212	icekit_plugins_page_anchor_list	pageanchorlistitem
213	icekit_plugins_quote	quoteitem
214	icekit_plugins_reusable_form	formitem
215	icekit_plugins_slideshow	slideshow
216	icekit_plugins_slideshow	slideshowitem
217	image_gallery	imagegalleryshowitem
218	icekit_plugins_twitter_embed	twitterembeditem
219	text	textitem
220	icekit_events	eventbase
221	icekit_events	recurrencerule
222	icekit_events	eventtype
223	icekit_events	eventrepeatsgenerator
224	icekit_events	occurrence
225	icekit_event_types_simple	simpleevent
226	ik_event_listing	eventcontentlistingitem
227	icekit_events_links	eventlink
228	ik_events_todays_occurrences	todaysoccurrences
229	eventlistingfordate	eventlistingpage
230	model_settings	setting
231	model_settings	boolean
232	model_settings	date
233	model_settings	datetime
234	model_settings	decimal
235	model_settings	file
236	model_settings	float
237	model_settings	image
238	model_settings	integer
239	model_settings	text
240	model_settings	time
241	post_office	email
242	post_office	log
243	post_office	emailtemplate
244	post_office	attachment
245	fluentpage	fluentpage
246	tests	articlelisting
247	tests	article
248	tests	layoutpagewithrelatedpages
249	tests	publishingm2mmodela
250	tests	publishingm2mmodelb
251	tests	basemodel
252	tests	foowithlayout
253	tests	barwithlayout
254	tests	bazwithlayout
255	tests	imagetest
256	tests	publishingm2mthroughtable
257	authtoken	token
276	fluent_pages	fluentcontentspage
277	icekit	publishablefluentcontentspage
278	icekit	icekitfluentcontentspagemixin
279	layout_page	abstractlayoutpage
280	icekit_content_collections	abstractlistingpage
281	icekit_events	abstracteventlistingpage
282	icekit_events	abstracteventlistingfordatepage
283	search_page	abstractsearchpage
284	fluentpage	abstractfluentpage
\.


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_content_type_id_seq', 284, true);


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2017-06-05 05:54:07.034166+01
2	auth	0001_initial	2017-06-05 05:54:07.185646+01
3	polymorphic_auth	0001_initial	2017-06-05 05:54:07.28138+01
4	admin	0001_initial	2017-06-05 05:54:07.344291+01
5	contenttypes	0002_remove_content_type_name	2017-06-05 05:54:07.493378+01
6	auth	0002_alter_permission_name_max_length	2017-06-05 05:54:07.527777+01
7	auth	0003_alter_user_email_max_length	2017-06-05 05:54:07.588048+01
8	auth	0004_alter_user_username_opts	2017-06-05 05:54:07.648308+01
9	auth	0005_alter_user_last_login_null	2017-06-05 05:54:07.712563+01
10	auth	0006_require_contenttypes_0002	2017-06-05 05:54:07.715773+01
11	authtoken	0001_initial	2017-06-05 05:54:07.754247+01
12	authtoken	0002_auto_20160226_1747	2017-06-05 05:54:07.956325+01
13	djcelery	0001_initial	2017-06-05 05:54:08.191983+01
14	easy_thumbnails	0001_initial	2017-06-05 05:54:08.347914+01
15	easy_thumbnails	0002_thumbnaildimensions	2017-06-05 05:54:08.399057+01
16	icekit	0001_initial	2017-06-05 05:54:08.445908+01
17	fluent_contents	0001_initial	2017-06-05 05:54:08.700909+01
18	icekit_plugins_image	0001_initial	2017-06-05 05:54:08.822592+01
19	icekit_plugins_image	0002_auto_20150527_0022	2017-06-05 05:54:08.90166+01
20	icekit_plugins_image	0003_auto_20150623_0115	2017-06-05 05:54:08.974616+01
21	icekit_plugins_image	0004_auto_20151001_2023	2017-06-05 05:54:09.099959+01
22	icekit_plugins_image	0005_imageitem_caption_override	2017-06-05 05:54:09.193414+01
23	icekit_plugins_image	0006_auto_20160309_0453	2017-06-05 05:54:09.441809+01
24	icekit_plugins_image	0007_auto_20160920_1626	2017-06-05 05:54:09.691612+01
25	icekit_plugins_image	0008_auto_20160920_2114	2017-06-05 05:54:09.824446+01
26	icekit_plugins_image	0009_auto_20161026_2044	2017-06-05 05:54:09.885826+01
27	icekit	0002_layout	2017-06-05 05:54:09.930092+01
28	icekit	0003_layout_content_types	2017-06-05 05:54:10.044989+01
29	icekit	0004_auto_20150611_2044	2017-06-05 05:54:10.19597+01
30	icekit	0005_remove_layout_key	2017-06-05 05:54:10.276381+01
31	icekit	0006_auto_20150911_0744	2017-06-05 05:54:10.365343+01
32	sites	0001_initial	2017-06-05 05:54:10.389549+01
33	fluent_pages	0001_initial	2017-06-05 05:54:11.042863+01
34	eventlistingfordate	0001_initial	2017-06-05 05:54:11.166273+01
35	eventlistingfordate	0002_auto_20161018_1113	2017-06-05 05:54:11.276624+01
36	eventlistingfordate	0003_auto_20161019_1906	2017-06-05 05:54:11.373569+01
37	eventlistingfordate	0004_auto_20161115_1118	2017-06-05 05:54:11.679561+01
38	eventlistingfordate	0005_auto_20161130_1109	2017-06-05 05:54:11.838305+01
39	eventlistingfordate	0006_auto_20170519_1345	2017-06-05 05:54:12.061836+01
40	fluentpage	0001_initial	2017-06-05 05:54:12.195252+01
41	forms	0001_initial	2017-06-05 05:54:12.740174+01
42	forms	0002_auto_20160418_0120	2017-06-05 05:54:12.890715+01
43	icekit	0007_auto_20170310_1220	2017-06-05 05:54:13.032411+01
44	icekit_article	0001_initial	2017-06-05 05:54:13.77558+01
45	icekit_article	0002_auto_20161019_1906	2017-06-05 05:54:13.949266+01
46	icekit_article	0003_auto_20161110_1125	2017-06-05 05:54:14.529299+01
47	icekit_article	0004_article_hero_image	2017-06-05 05:54:14.722264+01
48	icekit_article	0005_add_hero	2017-06-05 05:54:15.24393+01
49	icekit_article	0006_auto_20161117_1800	2017-06-05 05:54:15.595689+01
50	icekit_article	0007_auto_20161130_1109	2017-06-05 05:54:16.027941+01
51	icekit_article	0008_auto_20170518_1629	2017-06-05 05:54:16.763544+01
52	icekit_plugins_image	0010_auto_20170307_1458	2017-06-05 05:54:18.929524+01
53	icekit_plugins_image	0011_auto_20170310_1853	2017-06-05 05:54:19.386533+01
54	icekit_plugins_image	0012_imagerepurposeconfig_is_cropping_allowed	2017-06-05 05:54:19.424689+01
55	icekit_plugins_image	0013_image_is_cropping_allowed	2017-06-05 05:54:19.655003+01
56	icekit_plugins_image	0014_image_external_ref	2017-06-05 05:54:19.873644+01
57	icekit_plugins_image	0015_auto_20170310_2004	2017-06-05 05:54:20.42637+01
58	icekit_plugins_image	0016_auto_20170314_1306	2017-06-05 05:54:20.461342+01
59	icekit_plugins_image	0017_auto_20170314_1352	2017-06-05 05:54:20.50871+01
60	icekit_plugins_image	0018_auto_20170314_1401	2017-06-05 05:54:20.513778+01
61	icekit_plugins_image	0016_auto_20170316_2021	2017-06-05 05:54:20.517878+01
62	icekit_plugins_image	0019_merge	2017-06-05 05:54:20.521778+01
63	icekit_plugins_image	0020_auto_20170317_1655	2017-06-05 05:54:20.556749+01
64	icekit_authors	0001_initial	2017-06-05 05:54:20.982961+01
65	icekit_authors	0002_auto_20161011_1522	2017-06-05 05:54:21.361144+01
66	icekit_authors	0003_auto_20161115_1118	2017-06-05 05:54:21.955195+01
67	icekit_authors	0004_auto_20161117_1201	2017-06-05 05:54:22.384211+01
68	icekit_authors	0005_auto_20161117_1824	2017-06-05 05:54:22.57879+01
69	icekit_authors	0006_auto_20161117_1825	2017-06-05 05:54:22.787174+01
70	icekit_authors	0007_auto_20161125_1720	2017-06-05 05:54:23.163947+01
71	icekit_authors	0008_auto_20161128_1049	2017-06-05 05:54:23.663191+01
72	icekit_authors	0009_auto_20170317_1655	2017-06-05 05:54:24.095264+01
73	icekit_authors	0010_auto_20170317_1656	2017-06-05 05:54:24.355286+01
74	icekit_authors	0011_auto_20170518_1629	2017-06-05 05:54:25.278614+01
109	icekit_plugins_child_pages	0001_initial	2017-06-05 05:54:36.56685+01
110	icekit_plugins_child_pages	0002_auto_20160821_2140	2017-06-05 05:54:36.794667+01
111	icekit_plugins_child_pages	0003_auto_20161123_1827	2017-06-05 05:54:37.020314+01
112	icekit_plugins_contact_person	0001_initial	2017-06-05 05:54:37.380715+01
113	icekit_plugins_contact_person	0002_auto_20161110_1531	2017-06-05 05:54:37.63045+01
114	icekit_plugins_contact_person	0003_auto_20170605_1109	2017-06-05 05:54:38.338521+01
115	icekit_plugins_content_listing	0001_initial	2017-06-05 05:54:38.602417+01
116	icekit_plugins_content_listing	0002_contentlistingitem_limit	2017-06-05 05:54:38.868987+01
117	icekit_plugins_content_listing	0003_contentlistingitem_no_items_message	2017-06-05 05:54:39.124939+01
118	icekit_plugins_faq	0001_initial	2017-06-05 05:54:39.378011+01
119	icekit_plugins_faq	0002_auto_20151013_1330	2017-06-05 05:54:39.872608+01
120	icekit_plugins_faq	0003_auto_20160821_2140	2017-06-05 05:54:40.151581+01
121	icekit_plugins_file	0001_initial	2017-06-05 05:54:40.671454+01
122	icekit_plugins_file	0002_auto_20160821_2140	2017-06-05 05:54:41.587206+01
123	icekit_plugins_horizontal_rule	0001_initial	2017-06-05 05:54:41.881986+01
124	icekit_plugins_horizontal_rule	0002_auto_20160821_2140	2017-06-05 05:54:42.217552+01
125	icekit_plugins_image	0011_auto_20170310_1220	2017-06-05 05:54:42.766676+01
126	icekit_plugins_image	0021_merge	2017-06-05 05:54:43.319542+01
127	icekit_plugins_instagram_embed	0001_initial	2017-06-05 05:54:43.617863+01
128	icekit_plugins_instagram_embed	0002_auto_20150723_1939	2017-06-05 05:54:43.90961+01
129	icekit_plugins_instagram_embed	0003_auto_20150724_0213	2017-06-05 05:54:47.112988+01
130	icekit_plugins_instagram_embed	0004_auto_20160821_2140	2017-06-05 05:54:47.356274+01
131	icekit_plugins_map	0001_initial	2017-06-05 05:54:47.594156+01
132	icekit_plugins_map	0002_auto_20160821_2140	2017-06-05 05:54:47.868889+01
133	icekit_plugins_map	0003_auto_20170531_1359	2017-06-05 05:54:48.543054+01
134	icekit_plugins_map	0004_auto_20170604_2148	2017-06-05 05:54:48.86408+01
135	icekit_plugins_oembed_with_caption	0001_initial	2017-06-05 05:54:49.193816+01
136	icekit_plugins_oembed_with_caption	0002_auto_20160821_2140	2017-06-05 05:54:49.457566+01
137	icekit_plugins_oembed_with_caption	0003_oembedwithcaptionitem_is_16by9	2017-06-05 05:54:49.739828+01
138	icekit_plugins_oembed_with_caption	0004_auto_20160919_2008	2017-06-05 05:54:50.016331+01
139	icekit_plugins_oembed_with_caption	0005_auto_20161027_1711	2017-06-05 05:54:50.294767+01
140	icekit_plugins_oembed_with_caption	0006_auto_20161027_2330	2017-06-05 05:54:50.847971+01
141	icekit_plugins_oembed_with_caption	0007_auto_20161110_1513	2017-06-05 05:54:51.128816+01
142	icekit_plugins_page_anchor	0001_initial	2017-06-05 05:54:51.420139+01
143	icekit_plugins_page_anchor	0002_auto_20160821_2140	2017-06-05 05:54:51.724731+01
144	icekit_plugins_page_anchor	0003_auto_20161125_1538	2017-06-05 05:54:52.012408+01
145	icekit_plugins_page_anchor	0004_auto_20161130_0741	2017-06-05 05:54:52.296958+01
146	icekit_plugins_page_anchor_list	0001_initial	2017-06-05 05:54:52.594488+01
147	icekit_plugins_page_anchor_list	0002_auto_20160821_2140	2017-06-05 05:54:52.915241+01
148	icekit_plugins_quote	0001_initial	2017-06-05 05:54:53.222114+01
149	icekit_plugins_quote	0002_auto_20160821_2140	2017-06-05 05:54:53.543062+01
150	icekit_plugins_quote	0003_auto_20160912_2218	2017-06-05 05:54:54.093274+01
151	icekit_plugins_quote	0004_auto_20161027_1717	2017-06-05 05:54:54.667495+01
152	icekit_plugins_reusable_form	0001_initial	2017-06-05 05:54:54.981371+01
153	icekit_plugins_reusable_form	0002_auto_20160821_2140	2017-06-05 05:54:55.299021+01
154	icekit_plugins_slideshow	0001_initial	2017-06-05 05:54:55.635973+01
155	icekit_plugins_slideshow	0002_auto_20150623_0115	2017-06-05 05:54:55.955695+01
156	icekit_plugins_slideshow	0003_auto_20160404_0118	2017-06-05 05:54:57.177799+01
157	icekit_plugins_slideshow	0004_auto_20160821_2140	2017-06-05 05:54:57.924767+01
158	icekit_plugins_slideshow	0005_auto_20160927_2305	2017-06-05 05:54:58.568469+01
159	icekit_plugins_slideshow	0006_auto_20170518_1629	2017-06-05 05:54:59.198592+01
160	icekit_plugins_twitter_embed	0001_initial	2017-06-05 05:54:59.542887+01
161	icekit_plugins_twitter_embed	0002_auto_20150724_0213	2017-06-05 05:55:00.183474+01
162	icekit_plugins_twitter_embed	0003_auto_20160821_2140	2017-06-05 05:55:00.637052+01
163	icekit_workflow	0001_initial	2017-06-05 05:55:01.005748+01
164	icekit_workflow	0002_auto_20161128_1105	2017-06-05 05:55:01.365629+01
165	icekit_workflow	0003_auto_20161130_0741	2017-06-05 05:55:01.698655+01
166	icekit_workflow	0004_auto_20170130_1146	2017-06-05 05:55:02.055229+01
167	icekit_workflow	0005_auto_20170208_1146	2017-06-05 05:55:02.433935+01
168	icekit_workflow	0006_auto_20170308_2044	2017-06-05 05:55:03.092686+01
169	iframe	0001_initial	2017-06-05 05:55:03.431524+01
170	ik_event_listing	0001_initial	2017-06-05 05:55:03.795315+01
175	ik_links	0001_initial	2017-06-05 05:55:09.943404+01
176	ik_links	0002_auto_20161117_1221	2017-06-05 05:55:10.987212+01
177	ik_links	0003_auto_20161117_1810	2017-06-05 05:55:12.062238+01
178	ik_links	0004_auto_20170314_1401	2017-06-05 05:55:13.099231+01
179	ik_links	0004_auto_20170306_1529	2017-06-05 05:55:14.146886+01
180	ik_links	0005_auto_20170511_1909	2017-06-05 05:55:15.201566+01
181	ik_links	0006_authorlink_exclude_from_contributions	2017-06-05 05:55:15.580818+01
182	image_gallery	0001_initial	2017-06-05 05:55:15.951126+01
183	image_gallery	0002_auto_20160927_2305	2017-06-05 05:55:16.390023+01
184	kombu_transport_django	0001_initial	2017-06-05 05:55:16.538037+01
185	layout_page	0001_initial	2017-06-05 05:55:16.946567+01
186	layout_page	0002_auto_20160419_2209	2017-06-05 05:55:18.440961+01
187	layout_page	0003_auto_20160810_1856	2017-06-05 05:55:18.826777+01
188	layout_page	0004_auto_20161110_1737	2017-06-05 05:55:20.024052+01
189	layout_page	0005_auto_20161125_1709	2017-06-05 05:55:20.429533+01
190	layout_page	0006_auto_20161130_1109	2017-06-05 05:55:20.866066+01
191	layout_page	0007_auto_20170509_1148	2017-06-05 05:55:21.248367+01
192	layout_page	0008_auto_20170518_1629	2017-06-05 05:55:22.029198+01
193	model_settings	0001_initial	2017-06-05 05:55:24.894408+01
194	model_settings	0002_auto_20150810_1620	2017-06-05 05:55:25.292311+01
195	notifications	0001_initial	2017-06-05 05:55:27.902608+01
196	notifications	0002_auto_20150901_2126	2017-06-05 05:55:28.877239+01
197	oembeditem	0001_initial	2017-06-05 05:55:29.358518+01
198	polymorphic_auth	0002_auto_20160725_2124	2017-06-05 05:55:30.380877+01
199	polymorphic_auth_email	0001_initial	2017-06-05 05:55:30.853112+01
200	post_office	0001_initial	2017-06-05 05:55:31.166366+01
201	post_office	0002_add_i18n_and_backend_alias	2017-06-05 05:55:32.135342+01
202	post_office	0003_longer_subject	2017-06-05 05:55:32.287189+01
203	post_office	0004_auto_20160607_0901	2017-06-05 05:55:33.771457+01
204	rawhtml	0001_initial	2017-06-05 05:55:34.267678+01
205	redirectnode	0001_initial	2017-06-05 05:55:35.681726+01
206	redirects	0001_initial	2017-06-05 05:55:36.180872+01
207	response_pages	0001_initial	2017-06-05 05:55:36.237227+01
208	reversion	0001_initial	2017-06-05 05:55:37.302322+01
209	reversion	0002_auto_20141216_1509	2017-06-05 05:55:37.882918+01
210	search_page	0001_initial	2017-06-05 05:55:38.413757+01
211	search_page	0002_auto_20160420_0029	2017-06-05 05:55:42.057061+01
212	search_page	0003_auto_20160810_1856	2017-06-05 05:55:42.559162+01
213	search_page	0004_auto_20161122_2121	2017-06-05 05:55:43.626768+01
214	search_page	0005_auto_20161125_1720	2017-06-05 05:55:44.631637+01
215	search_page	0006_searchpage_default_search_type	2017-06-05 05:55:45.181416+01
216	search_page	0007_auto_20170518_1629	2017-06-05 05:55:46.189525+01
217	sessions	0001_initial	2017-06-05 05:55:46.252574+01
218	sharedcontent	0001_initial	2017-06-05 05:55:49.113183+01
219	tests	0001_initial	2017-06-05 05:55:50.947052+01
220	tests	0002_unpublishablelayoutpage	2017-06-05 05:55:51.529541+01
221	tests	0003_auto_20160810_2054	2017-06-05 05:55:52.776326+01
222	tests	0004_auto_20160925_0758	2017-06-05 05:55:54.022025+01
223	tests	0005_auto_20161027_1428	2017-06-05 05:55:54.353994+01
224	tests	0006_auto_20161115_1219	2017-06-05 05:55:58.233807+01
225	tests	0007_auto_20161118_1044	2017-06-05 05:56:01.297152+01
226	tests	0008_auto_20161204_1456	2017-06-05 05:56:03.219368+01
227	tests	0009_auto_20170519_1232	2017-06-05 05:56:05.585588+01
228	tests	0010_auto_20170522_1600	2017-06-05 05:56:07.001775+01
229	text	0001_initial	2017-06-05 05:56:07.61005+01
230	text	0002_textitem_style	2017-06-05 05:56:08.256801+01
231	textfile	0001_initial	2017-06-05 05:56:08.835471+01
232	textfile	0002_add_translation_model	2017-06-05 05:56:10.035825+01
233	textfile	0003_migrate_translatable_fields	2017-06-05 05:56:10.090849+01
234	textfile	0004_remove_untranslated_fields	2017-06-05 05:56:10.768456+01
235	icekit_events	0001_initial	2017-06-05 07:01:42.572645+01
236	icekit_events	0002_recurrence_rules	2017-06-05 07:01:42.627627+01
237	icekit_events	0003_auto_20161021_1658	2017-06-05 07:01:42.767139+01
238	icekit_events	0004_eventbase_part_of	2017-06-05 07:01:42.919972+01
239	icekit_events	0005_auto_20161024_1742	2017-06-05 07:01:43.249996+01
240	icekit_events	0006_auto_20161107_1747	2017-06-05 07:01:43.777606+01
241	icekit_events	0007_type_fixtures	2017-06-05 07:01:43.804937+01
242	icekit_events	0008_occurrence_external_ref	2017-06-05 07:01:43.93986+01
243	icekit_events	0009_auto_20161125_1538	2017-06-05 07:01:44.211871+01
244	icekit_events	0010_eventbase_is_drop_in	2017-06-05 07:01:44.365739+01
245	icekit_events	0011_auto_20161128_1049	2017-06-05 07:01:45.197848+01
246	icekit_events	0012_occurrence_status	2017-06-05 07:01:45.327592+01
247	icekit_events	0012_eventtype_title_plural	2017-06-05 07:01:45.469336+01
248	icekit_events	0013_merge	2017-06-05 07:01:45.47485+01
249	icekit_events	0014_eventbase_human_times	2017-06-05 07:01:45.861171+01
250	icekit_events	0015_auto_20161208_0029	2017-06-05 07:01:45.993082+01
251	icekit_events	0016_auto_20161208_0030	2017-06-05 07:01:46.128853+01
252	icekit_events	0017_eventtype_color	2017-06-05 07:01:46.262329+01
253	icekit_events	0018_auto_20170307_1458	2017-06-05 07:01:46.389485+01
254	icekit_events	0019_auto_20170310_1220	2017-06-05 07:01:46.932228+01
255	icekit_events	0020_auto_20170317_1341	2017-06-05 07:01:47.164513+01
256	icekit_events	0018_auto_20170314_1401	2017-06-05 07:01:47.305418+01
257	icekit_events	0021_merge	2017-06-05 07:01:47.309229+01
258	icekit_events	0022_auto_20170320_1807	2017-06-05 07:01:47.781612+01
259	icekit_events	0023_auto_20170320_1820	2017-06-05 07:01:48.273053+01
260	icekit_events	0024_auto_20170320_1824	2017-06-05 07:01:48.39526+01
261	icekit_events	0025_auto_20170519_1327	2017-06-05 07:01:48.690324+01
262	icekit_event_types_simple	0001_initial	2017-06-05 07:04:32.822898+01
263	icekit_event_types_simple	0002_simpleevent_layout	2017-06-05 07:04:32.992105+01
264	icekit_event_types_simple	0003_auto_20161125_1701	2017-06-05 07:04:33.172207+01
265	icekit_events_links	0001_initial	2017-06-05 07:04:33.330768+01
266	icekit_events_links	0002_auto_20170314_1401	2017-06-05 07:04:33.4836+01
267	icekit_events_links	0003_auto_20170511_1909	2017-06-05 07:04:33.641878+01
268	icekit_events_links	0004_eventlink_include_even_when_finished	2017-06-05 07:04:33.805564+01
269	ik_event_listing	0002_auto_20170222_1136	2017-06-05 07:04:35.004682+01
270	ik_event_listing	0003_eventcontentlistingitem_no_items_message	2017-06-05 07:04:35.232442+01
271	ik_events_todays_occurrences	0001_initial	2017-06-05 07:04:35.487443+01
272	ik_events_todays_occurrences	0002_auto_20161207_1928	2017-06-05 07:04:35.939139+01
\.


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_migrations_id_seq', 272, true);


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
goillj2wuoj2euvmckxf7jzln2v32mtg	Y2ZiYzNkOWJkYmU0NjZmNTkzOTQxYjViM2U3YWFiMDIyYjBiOTY5NTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6Im1hc3Rlcl9wYXNzd29yZC5hdXRoLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaGFzaCI6IjFmNGYyY2U3MzJkMmMyYjkzZDE2N2E3NzA5NDc1NTU5MGIwYjFmOGMiLCJfYXV0aF91c2VyX2lkIjoiMjIzIn0=	2017-06-19 06:26:31.110456+01
\.


--
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_site (id, domain, name) FROM stdin;
1	ik.lvh.me	ik
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

SELECT pg_catalog.setval('easy_thumbnails_source_id_seq', 1, true);


--
-- Data for Name: easy_thumbnails_thumbnail; Type: TABLE DATA; Schema: public; Owner: -
--

COPY easy_thumbnails_thumbnail (id, storage_hash, name, modified, source_id) FROM stdin;
\.


--
-- Name: easy_thumbnails_thumbnail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('easy_thumbnails_thumbnail_id_seq', 2, true);


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

SELECT pg_catalog.setval('file_file_id_seq', 6, true);


--
-- Data for Name: fluent_contents_contentitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_contents_contentitem (id, parent_id, language_code, sort_order, parent_type_id, placeholder_id, polymorphic_ctype_id) FROM stdin;
\.


--
-- Name: fluent_contents_contentitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_contents_contentitem_id_seq', 185, true);


--
-- Data for Name: fluent_contents_placeholder; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_contents_placeholder (id, slot, role, parent_id, title, parent_type_id) FROM stdin;
\.


--
-- Name: fluent_contents_placeholder_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_contents_placeholder_id_seq', 86, true);


--
-- Data for Name: fluent_pages_htmlpage_translation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_pages_htmlpage_translation (id, language_code, meta_keywords, meta_description, meta_title, master_id) FROM stdin;
\.


--
-- Name: fluent_pages_htmlpage_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_pages_htmlpage_translation_id_seq', 157, true);


--
-- Data for Name: fluent_pages_pagelayout; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_pages_pagelayout (id, key, title, template_path) FROM stdin;
\.


--
-- Name: fluent_pages_pagelayout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_pages_pagelayout_id_seq', 14, true);


--
-- Data for Name: fluent_pages_urlnode; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_pages_urlnode (id, lft, rght, tree_id, level, status, publication_date, publication_end_date, in_navigation, in_sitemaps, key, creation_date, modification_date, author_id, parent_id, parent_site_id, polymorphic_ctype_id) FROM stdin;
\.


--
-- Name: fluent_pages_urlnode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_pages_urlnode_id_seq', 180, true);


--
-- Data for Name: fluent_pages_urlnode_translation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_pages_urlnode_translation (id, language_code, title, slug, override_url, _cached_url, master_id) FROM stdin;
\.


--
-- Name: fluent_pages_urlnode_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_pages_urlnode_translation_id_seq', 169, true);


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

SELECT pg_catalog.setval('forms_form_id_seq', 9, true);


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
-- Data for Name: icekit_article_article; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_article_article (id, publishing_is_draft, publishing_modified_at, publishing_published_at, title, slug, layout_id, parent_id, publishing_linked_id, boosted_search_terms, list_image, hero_image_id, admin_notes, brief) FROM stdin;
\.


--
-- Name: icekit_article_article_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_article_article_id_seq', 3, true);


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

SELECT pg_catalog.setval('icekit_authors_author_id_seq', 4, true);


--
-- Data for Name: icekit_event_types_simple_simpleevent; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_event_types_simple_simpleevent (eventbase_ptr_id, layout_id) FROM stdin;
\.


--
-- Data for Name: icekit_events_eventbase; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_events_eventbase (id, publishing_is_draft, publishing_modified_at, publishing_published_at, title, slug, created, modified, show_in_calendar, human_dates, special_instructions, cta_text, cta_url, derived_from_id, polymorphic_ctype_id, publishing_linked_id, part_of_id, price_line, primary_type_id, external_ref, has_tickets_available, is_drop_in, human_times, admin_notes, brief) FROM stdin;
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
1	2017-06-05 07:01:42.593201+01	2017-06-05 07:01:42.60922+01	Daily, except Xmas day	RRULE:FREQ=DAILY;\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25
2	2017-06-05 07:01:42.613628+01	2017-06-05 07:01:42.613702+01	Daily, Weekdays, except Xmas day	RRULE:FREQ=DAILY;BYDAY=MO,TU,WE,TH,FR;\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25
3	2017-06-05 07:01:42.616191+01	2017-06-05 07:01:42.616262+01	Daily, Weekends, except Xmas day	RRULE:FREQ=DAILY;BYDAY=SA,SU;\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25
4	2017-06-05 07:01:42.618739+01	2017-06-05 07:01:42.618804+01	Weekly, except Xmas day	RRULE:FREQ=WEEKLY;\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25
5	2017-06-05 07:01:42.621207+01	2017-06-05 07:01:42.621269+01	Monthly, except Xmas day	RRULE:FREQ=MONTHLY;\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25
6	2017-06-05 07:01:42.623542+01	2017-06-05 07:01:42.623598+01	Yearly, except Xmas day	RRULE:FREQ=YEARLY;\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25
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

SELECT pg_catalog.setval('icekit_layout_content_types_id_seq', 84, true);


--
-- Name: icekit_layout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_layout_id_seq', 98, true);


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

SELECT pg_catalog.setval('icekit_mediacategory_id_seq', 4, true);


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
\.


--
-- Name: icekit_plugins_image_imagerepurposeconfig_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_plugins_image_imagerepurposeconfig_id_seq', 6, true);


--
-- Data for Name: icekit_plugins_slideshow_slideshow; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_plugins_slideshow_slideshow (id, title, show_title, publishing_is_draft, publishing_linked_id, publishing_modified_at, publishing_published_at, admin_notes, brief) FROM stdin;
\.


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

SELECT pg_catalog.setval('image_image_id_seq', 34, true);


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
22	DRAFT_SECRET_KEY	239
\.


--
-- Name: model_settings_setting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('model_settings_setting_id_seq', 22, true);


--
-- Data for Name: model_settings_text; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_text (setting_ptr_id, value) FROM stdin;
22	GrDrfmlMVeuibUh9ZodQEzjK8xZH44bXxgyEvbeOfEIZIVwUyv
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
120	ALL	211
132	ALL	223
\.


--
-- Name: notifications_notificationsetting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifications_notificationsetting_id_seq', 158, true);


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
211	admin@ik.lvh.me
223	greg@interaction.net.au
\.


--
-- Data for Name: polymorphic_auth_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY polymorphic_auth_user (id, password, last_login, is_superuser, is_staff, is_active, first_name, last_name, created, polymorphic_ctype_id) FROM stdin;
211	pbkdf2_sha256$20000$BygnvBPRMOJA$vDOAnb/z/n71EvDIuPrTZ0NjRMNq2btpZuJT28d5rdA=	\N	t	t	t	Admin		2017-06-05 06:01:16.209509+01	137
223	pbkdf2_sha256$20000$ZEcac1yQmo9I$MIrrfv3TSf/PYmbBMNk7FZ5dpX87W2qVsc140OHMJag=	2017-06-05 06:26:31.098418+01	t	t	t	Greg	Turner	2017-06-05 06:26:09.109261+01	137
\.


--
-- Data for Name: polymorphic_auth_user_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY polymorphic_auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Name: polymorphic_auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('polymorphic_auth_user_groups_id_seq', 10, true);


--
-- Name: polymorphic_auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('polymorphic_auth_user_id_seq', 249, true);


--
-- Data for Name: polymorphic_auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY polymorphic_auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Name: polymorphic_auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('polymorphic_auth_user_user_permissions_id_seq', 19, true);


--
-- Data for Name: post_office_attachment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY post_office_attachment (id, file, name) FROM stdin;
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

SELECT pg_catalog.setval('response_pages_responsepage_id_seq', 8, true);


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

SELECT pg_catalog.setval('slideshow_slideshow_id_seq', 52, true);


--
-- Data for Name: test_article; Type: TABLE DATA; Schema: public; Owner: -
--

COPY test_article (id, publishing_is_draft, publishing_modified_at, publishing_published_at, title, slug, layout_id, publishing_linked_id, parent_id, boosted_search_terms, list_image) FROM stdin;
\.


--
-- Name: test_article_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('test_article_id_seq', 21, true);


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

SELECT pg_catalog.setval('test_layoutpage_with_related_related_pages_id_seq', 1, true);


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

SELECT pg_catalog.setval('tests_basemodel_id_seq', 1, true);


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

SELECT pg_catalog.setval('tests_imagetest_id_seq', 2, true);


--
-- Data for Name: tests_publishingm2mmodela; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_publishingm2mmodela (id, publishing_is_draft, publishing_modified_at, publishing_published_at, publishing_linked_id) FROM stdin;
\.


--
-- Name: tests_publishingm2mmodela_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_publishingm2mmodela_id_seq', 4, true);


--
-- Data for Name: tests_publishingm2mmodelb; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_publishingm2mmodelb (id, publishing_is_draft, publishing_modified_at, publishing_published_at, publishing_linked_id) FROM stdin;
\.


--
-- Name: tests_publishingm2mmodelb_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_publishingm2mmodelb_id_seq', 2, true);


--
-- Data for Name: tests_publishingm2mmodelb_related_a_models; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_publishingm2mmodelb_related_a_models (id, publishingm2mmodelb_id, publishingm2mmodela_id) FROM stdin;
\.


--
-- Name: tests_publishingm2mmodelb_related_a_models_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_publishingm2mmodelb_related_a_models_id_seq', 5, true);


--
-- Data for Name: tests_publishingm2mthroughtable; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_publishingm2mthroughtable (id, a_model_id, b_model_id) FROM stdin;
\.


--
-- Name: tests_publishingm2mthroughtable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_publishingm2mthroughtable_id_seq', 4, true);


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

SELECT pg_catalog.setval('workflow_workflowstate_id_seq', 12, true);


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
-- Name: django_content_type django_content_type_app_label_2ca6b82262765616_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_2ca6b82262765616_uniq UNIQUE (app_label, model);


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
-- Name: easy_thumbnails_source easy_thumbnails_source_storage_hash_7bd609ca10204665_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_source
    ADD CONSTRAINT easy_thumbnails_source_storage_hash_7bd609ca10204665_uniq UNIQUE (storage_hash, name);


--
-- Name: easy_thumbnails_thumbnail easy_thumbnails_thumbnail_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnail
    ADD CONSTRAINT easy_thumbnails_thumbnail_pkey PRIMARY KEY (id);


--
-- Name: easy_thumbnails_thumbnail easy_thumbnails_thumbnail_storage_hash_7bdb30671e8cf370_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnail
    ADD CONSTRAINT easy_thumbnails_thumbnail_storage_hash_7bdb30671e8cf370_uniq UNIQUE (storage_hash, name, source_id);


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
-- Name: fluent_contents_placeholder fluent_contents_placeholde_parent_type_id_240ea1f478ca3e6b_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_placeholder
    ADD CONSTRAINT fluent_contents_placeholde_parent_type_id_240ea1f478ca3e6b_uniq UNIQUE (parent_type_id, parent_id, slot);


--
-- Name: fluent_contents_placeholder fluent_contents_placeholder_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_placeholder
    ADD CONSTRAINT fluent_contents_placeholder_pkey PRIMARY KEY (id);


--
-- Name: fluent_pages_htmlpage_translation fluent_pages_htmlpage_trans_language_code_131e0dc167dc6f87_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_htmlpage_translation
    ADD CONSTRAINT fluent_pages_htmlpage_trans_language_code_131e0dc167dc6f87_uniq UNIQUE (language_code, master_id);


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
-- Name: fluent_pages_urlnode fluent_pages_urlnode_parent_site_id_4c49e5100e5e7157_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_pages_urlnode_parent_site_id_4c49e5100e5e7157_uniq UNIQUE (parent_site_id, key);


--
-- Name: fluent_pages_urlnode fluent_pages_urlnode_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_pages_urlnode_pkey PRIMARY KEY (id);


--
-- Name: fluent_pages_urlnode_translation fluent_pages_urlnode_transl_language_code_53a0fa1d022b99a5_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode_translation
    ADD CONSTRAINT fluent_pages_urlnode_transl_language_code_53a0fa1d022b99a5_uniq UNIQUE (language_code, master_id);


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
-- Name: icekit_article_article icekit_article_article_slug_25a9422bfa087bcf_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT icekit_article_article_slug_25a9422bfa087bcf_uniq UNIQUE (slug, parent_id, publishing_linked_id);


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
-- Name: icekit_layout icekit_layout_template_name_51ca5bdce3b0e013_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout
    ADD CONSTRAINT icekit_layout_template_name_51ca5bdce3b0e013_uniq UNIQUE (template_name);


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
-- Name: notifications_followerinformation notifications_followerinf_content_type_id_34dbf2ba40daaec7_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation
    ADD CONSTRAINT notifications_followerinf_content_type_id_34dbf2ba40daaec7_uniq UNIQUE (content_type_id, object_id);


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
-- Name: post_office_emailtemplate post_office_emailtemplate_language_7b42158785987104_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_emailtemplate
    ADD CONSTRAINT post_office_emailtemplate_language_7b42158785987104_uniq UNIQUE (language, default_template_id);


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
-- Name: redirectnode_redirectnode_translation redirectnode_redirectnode_t_language_code_3a6e074f90d1d0da_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirectnode_redirectnode_translation
    ADD CONSTRAINT redirectnode_redirectnode_t_language_code_3a6e074f90d1d0da_uniq UNIQUE (language_code, master_id);


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
-- Name: sharedcontent_sharedcontent sharedcontent_sharedconten_parent_site_id_594439596c0ef877_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent
    ADD CONSTRAINT sharedcontent_sharedconten_parent_site_id_594439596c0ef877_uniq UNIQUE (parent_site_id, slug);


--
-- Name: sharedcontent_sharedcontent_translation sharedcontent_sharedcontent_language_code_232e6d20b958ebaa_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent_translation
    ADD CONSTRAINT sharedcontent_sharedcontent_language_code_232e6d20b958ebaa_uniq UNIQUE (language_code, master_id);


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
-- Name: textfile_textfile_translation textfile_textfile_translati_language_code_7ab87386314d474c_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY textfile_textfile_translation
    ADD CONSTRAINT textfile_textfile_translati_language_code_7ab87386314d474c_uniq UNIQUE (language_code, master_id);


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
-- Name: auth_group_name_676b22f4f50afa6_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_name_676b22f4f50afa6_like ON auth_group USING btree (name varchar_pattern_ops);


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
-- Name: authtoken_token_key_1cc45282f991944d_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX authtoken_token_key_1cc45282f991944d_like ON authtoken_token USING btree (key varchar_pattern_ops);


--
-- Name: celery_taskmeta_662f707d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX celery_taskmeta_662f707d ON celery_taskmeta USING btree (hidden);


--
-- Name: celery_taskmeta_task_id_56bd5bd45b13e715_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX celery_taskmeta_task_id_56bd5bd45b13e715_like ON celery_taskmeta USING btree (task_id varchar_pattern_ops);


--
-- Name: celery_tasksetmeta_662f707d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX celery_tasksetmeta_662f707d ON celery_tasksetmeta USING btree (hidden);


--
-- Name: celery_tasksetmeta_taskset_id_3c86596ee45b0337_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX celery_tasksetmeta_taskset_id_3c86596ee45b0337_like ON celery_tasksetmeta USING btree (taskset_id varchar_pattern_ops);


--
-- Name: contentitem_file_fileitem_814552b9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_file_fileitem_814552b9 ON contentitem_icekit_plugins_file_fileitem USING btree (file_id);


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
-- Name: django_redirect_old_path_423749bca64fa1d3_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_redirect_old_path_423749bca64fa1d3_like ON django_redirect USING btree (old_path varchar_pattern_ops);


--
-- Name: django_session_de54fa62; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_de54fa62 ON django_session USING btree (expire_date);


--
-- Name: django_session_session_key_4f96f8825d5f854e_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_session_key_4f96f8825d5f854e_like ON django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: djcelery_periodictask_1dcd7040; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_periodictask_1dcd7040 ON djcelery_periodictask USING btree (interval_id);


--
-- Name: djcelery_periodictask_f3f0d72a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_periodictask_f3f0d72a ON djcelery_periodictask USING btree (crontab_id);


--
-- Name: djcelery_periodictask_name_6a863189883e39d4_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_periodictask_name_6a863189883e39d4_like ON djcelery_periodictask USING btree (name varchar_pattern_ops);


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
-- Name: djcelery_taskstate_name_6ebb6bed983f7213_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_name_6ebb6bed983f7213_like ON djcelery_taskstate USING btree (name varchar_pattern_ops);


--
-- Name: djcelery_taskstate_state_303905250e6e8efe_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_state_303905250e6e8efe_like ON djcelery_taskstate USING btree (state varchar_pattern_ops);


--
-- Name: djcelery_taskstate_task_id_2c03312c452f8832_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_task_id_2c03312c452f8832_like ON djcelery_taskstate USING btree (task_id varchar_pattern_ops);


--
-- Name: djcelery_workerstate_f129901a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_workerstate_f129901a ON djcelery_workerstate USING btree (last_heartbeat);


--
-- Name: djcelery_workerstate_hostname_eff9e51f61ce9b0_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_workerstate_hostname_eff9e51f61ce9b0_like ON djcelery_workerstate USING btree (hostname varchar_pattern_ops);


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
-- Name: djkombu_queue_name_32e3697217471337_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djkombu_queue_name_32e3697217471337_like ON djkombu_queue USING btree (name varchar_pattern_ops);


--
-- Name: easy_thumbnails_source_b068931c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_source_b068931c ON easy_thumbnails_source USING btree (name);


--
-- Name: easy_thumbnails_source_b454e115; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_source_b454e115 ON easy_thumbnails_source USING btree (storage_hash);


--
-- Name: easy_thumbnails_source_name_2cdf551177349aee_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_source_name_2cdf551177349aee_like ON easy_thumbnails_source USING btree (name varchar_pattern_ops);


--
-- Name: easy_thumbnails_source_storage_hash_6391ec47cb76aeeb_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_source_storage_hash_6391ec47cb76aeeb_like ON easy_thumbnails_source USING btree (storage_hash varchar_pattern_ops);


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
-- Name: easy_thumbnails_thumbnail_name_3389c9c991b19384_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_thumbnail_name_3389c9c991b19384_like ON easy_thumbnails_thumbnail USING btree (name varchar_pattern_ops);


--
-- Name: easy_thumbnails_thumbnail_storage_hash_7173a067e1497c69_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_thumbnail_storage_hash_7173a067e1497c69_like ON easy_thumbnails_thumbnail USING btree (storage_hash varchar_pattern_ops);


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
-- Name: fluent_contents_contentitem_language_code_795642d249cca281_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_contentitem_language_code_795642d249cca281_like ON fluent_contents_contentitem USING btree (language_code varchar_pattern_ops);


--
-- Name: fluent_contents_placeholder_2e3c0484; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_placeholder_2e3c0484 ON fluent_contents_placeholder USING btree (parent_type_id);


--
-- Name: fluent_contents_placeholder_5e97994e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_placeholder_5e97994e ON fluent_contents_placeholder USING btree (slot);


--
-- Name: fluent_contents_placeholder_slot_1ab8f9a82078d741_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_placeholder_slot_1ab8f9a82078d741_like ON fluent_contents_placeholder USING btree (slot varchar_pattern_ops);


--
-- Name: fluent_pages_htmlpage_trans_language_code_1f1d3920e3e8c1cd_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_htmlpage_trans_language_code_1f1d3920e3e8c1cd_like ON fluent_pages_htmlpage_translation USING btree (language_code varchar_pattern_ops);


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
-- Name: fluent_pages_pagelayout_key_763283eca32da45f_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_pagelayout_key_763283eca32da45f_like ON fluent_pages_pagelayout USING btree (key varchar_pattern_ops);


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
-- Name: fluent_pages_urlnode_key_633df632703477ee_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_key_633df632703477ee_like ON fluent_pages_urlnode USING btree (key varchar_pattern_ops);


--
-- Name: fluent_pages_urlnode_status_69cc4f700e362f8_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_status_69cc4f700e362f8_like ON fluent_pages_urlnode USING btree (status varchar_pattern_ops);


--
-- Name: fluent_pages_urlnode_transl_language_code_35716f6b8043475f_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_transl_language_code_35716f6b8043475f_like ON fluent_pages_urlnode_translation USING btree (language_code varchar_pattern_ops);


--
-- Name: fluent_pages_urlnode_translati__cached_url_dbb46892063880c_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_translati__cached_url_dbb46892063880c_like ON fluent_pages_urlnode_translation USING btree (_cached_url varchar_pattern_ops);


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
-- Name: fluent_pages_urlnode_translation_slug_4aea7cc4d78f3041_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_translation_slug_4aea7cc4d78f3041_like ON fluent_pages_urlnode_translation USING btree (slug varchar_pattern_ops);


--
-- Name: forms_field_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_field_2dbcba41 ON forms_field USING btree (slug);


--
-- Name: forms_field_d6cba1ad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_field_d6cba1ad ON forms_field USING btree (form_id);


--
-- Name: forms_field_slug_7612e03ab066cd87_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_field_slug_7612e03ab066cd87_like ON forms_field USING btree (slug varchar_pattern_ops);


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
-- Name: forms_form_slug_7d33ba52b9be44ea_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_form_slug_7d33ba52b9be44ea_like ON forms_form USING btree (slug varchar_pattern_ops);


--
-- Name: forms_formentry_d6cba1ad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_formentry_d6cba1ad ON forms_formentry USING btree (form_id);


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
-- Name: icekit_article_article_slug_3e2dcc0eaf2d265d_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_article_article_slug_3e2dcc0eaf2d265d_like ON icekit_article_article USING btree (slug varchar_pattern_ops);


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
-- Name: icekit_authors_author_slug_7edf5753487a0bed_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_authors_author_slug_7edf5753487a0bed_like ON icekit_authors_author USING btree (slug varchar_pattern_ops);


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
-- Name: icekit_events_eventbase_slug_55e3139cedbc37ce_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_slug_55e3139cedbc37ce_like ON icekit_events_eventbase USING btree (slug varchar_pattern_ops);


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
-- Name: icekit_events_eventtype_slug_831d80d48a50c6b_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventtype_slug_831d80d48a50c6b_like ON icekit_events_eventtype USING btree (slug varchar_pattern_ops);


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
-- Name: icekit_events_recurrencer_recurrence_rule_5056772ce88a0e87_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_recurrencer_recurrence_rule_5056772ce88a0e87_like ON icekit_events_recurrencerule USING btree (recurrence_rule text_pattern_ops);


--
-- Name: icekit_events_recurrencerule_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_recurrencerule_9ae73c65 ON icekit_events_recurrencerule USING btree (modified);


--
-- Name: icekit_events_recurrencerule_description_5d62fcf28cc02e22_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_recurrencerule_description_5d62fcf28cc02e22_like ON icekit_events_recurrencerule USING btree (description text_pattern_ops);


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
-- Name: icekit_layout_template_name_51ca5bdce3b0e013_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_layout_template_name_51ca5bdce3b0e013_like ON icekit_layout USING btree (template_name varchar_pattern_ops);


--
-- Name: icekit_mediacategory_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_mediacategory_9ae73c65 ON icekit_mediacategory USING btree (modified);


--
-- Name: icekit_mediacategory_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_mediacategory_e2fa5388 ON icekit_mediacategory USING btree (created);


--
-- Name: icekit_mediacategory_name_52b2304abb56c344_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_mediacategory_name_52b2304abb56c344_like ON icekit_mediacategory USING btree (name varchar_pattern_ops);


--
-- Name: icekit_plugins_image_imagerepurposeco_slug_f84e29252b1ebd0_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_plugins_image_imagerepurposeco_slug_f84e29252b1ebd0_like ON icekit_plugins_image_imagerepurposeconfig USING btree (slug varchar_pattern_ops);


--
-- Name: icekit_plugins_image_imagerepurposeconfig_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_plugins_image_imagerepurposeconfig_2dbcba41 ON icekit_plugins_image_imagerepurposeconfig USING btree (slug);


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
-- Name: model_settings_setting_name_27700ca16b5aa2d8_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX model_settings_setting_name_27700ca16b5aa2d8_like ON model_settings_setting USING btree (name varchar_pattern_ops);


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
-- Name: polymorphic_auth_email_emailuser_email_2c1c668cb751ae82_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX polymorphic_auth_email_emailuser_email_2c1c668cb751ae82_like ON polymorphic_auth_email_emailuser USING btree (email varchar_pattern_ops);


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
-- Name: redirectnode_redirectnode_t_language_code_4e9944a3de482d46_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX redirectnode_redirectnode_t_language_code_4e9944a3de482d46_like ON redirectnode_redirectnode_translation USING btree (language_code varchar_pattern_ops);


--
-- Name: redirectnode_redirectnode_translation_60716c2f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX redirectnode_redirectnode_translation_60716c2f ON redirectnode_redirectnode_translation USING btree (language_code);


--
-- Name: redirectnode_redirectnode_translation_90349b61; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX redirectnode_redirectnode_translation_90349b61 ON redirectnode_redirectnode_translation USING btree (master_id);


--
-- Name: response_pages_responsepage_type_7dc01dda95ca6d1d_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX response_pages_responsepage_type_7dc01dda95ca6d1d_like ON response_pages_responsepage USING btree (type varchar_pattern_ops);


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
-- Name: reversion_revision_manager_slug_4f5b09cb8aec4bcf_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reversion_revision_manager_slug_4f5b09cb8aec4bcf_like ON reversion_revision USING btree (manager_slug varchar_pattern_ops);


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
-- Name: sharedcontent_sharedcontent_language_code_62beebd23b62472a_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sharedcontent_sharedcontent_language_code_62beebd23b62472a_like ON sharedcontent_sharedcontent_translation USING btree (language_code varchar_pattern_ops);


--
-- Name: sharedcontent_sharedcontent_slug_51a37775e3fa48f0_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sharedcontent_sharedcontent_slug_51a37775e3fa48f0_like ON sharedcontent_sharedcontent USING btree (slug varchar_pattern_ops);


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
-- Name: test_article_slug_3ff5415f65be65e5_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_article_slug_3ff5415f65be65e5_like ON test_article USING btree (slug varchar_pattern_ops);


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
-- Name: textfile_textfile_translati_language_code_35c5feaf61076648_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX textfile_textfile_translati_language_code_35c5feaf61076648_like ON textfile_textfile_translation USING btree (language_code varchar_pattern_ops);


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
-- Name: contentitem_icekit_plugins_child_pages_childpageitem D0245fb6fed75b5ab189d00502bf89ab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_child_pages_childpageitem
    ADD CONSTRAINT "D0245fb6fed75b5ab189d00502bf89ab" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_occurrence D0e168d2cdff7d8319d1eecf33653cea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_occurrence
    ADD CONSTRAINT "D0e168d2cdff7d8319d1eecf33653cea" FOREIGN KEY (generator_id) REFERENCES icekit_events_eventrepeatsgenerator(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_publishingm2mmodela D1139f6178e9a5bbe8622cb6c3ff5501; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodela
    ADD CONSTRAINT "D1139f6178e9a5bbe8622cb6c3ff5501" FOREIGN KEY (publishing_linked_id) REFERENCES tests_publishingm2mmodela(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_reusable_form_formitem D12477a2f0a0d5cc8473b59aa423c01d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_reusable_form_formitem
    ADD CONSTRAINT "D12477a2f0a0d5cc8473b59aa423c01d" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_authors_author D1390adc07c948fcb4036694056c43f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author
    ADD CONSTRAINT "D1390adc07c948fcb4036694056c43f8" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: redirectnode_redirectnode_translation D1e267042378ced9fb59eab349c0f15f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirectnode_redirectnode_translation
    ADD CONSTRAINT "D1e267042378ced9fb59eab349c0f15f" FOREIGN KEY (master_id) REFERENCES pagetype_redirectnode_redirectnode(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_events_links_eventlink D213cad7dfd479d7419701a826fc1aec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_events_links_eventlink
    ADD CONSTRAINT "D213cad7dfd479d7419701a826fc1aec" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_eventlistingfordate_eventlistingpage D2557a361662f5aad422a1fbfbf08942; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT "D2557a361662f5aad422a1fbfbf08942" FOREIGN KEY (publishing_linked_id) REFERENCES pagetype_eventlistingfordate_eventlistingpage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_authorlisting D29f75d8d503c908cb3e4107e4c26fed; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT "D29f75d8d503c908cb3e4107e4c26fed" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_layoutpage_with_related D2b591764c90eb8df816b78297d8dcd5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT "D2b591764c90eb8df816b78297d8dcd5" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_page_anchor_pageanchoritem D2c8564c420ecd1850b5d24dd6ed2be3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_page_anchor_pageanchoritem
    ADD CONSTRAINT "D2c8564c420ecd1850b5d24dd6ed2be3" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ik_todays_occurrences_types D2fd5f4741354fede69a82729219d231; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types
    ADD CONSTRAINT "D2fd5f4741354fede69a82729219d231" FOREIGN KEY (todaysoccurrences_id) REFERENCES contentitem_ik_events_todays_occurrences_todaysoccurrences(contentitem_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_articlecategorypage D359c6762c45e1a4e978b00663944036; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT "D359c6762c45e1a4e978b00663944036" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_articlecategorypage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventbase D3b8e1e090c44d9f870f3b66caca5ae9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT "D3b8e1e090c44d9f870f3b66caca5ae9" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_event_types_simple_simpleevent D3c2d44564dd7f568e73116a1fafb482; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_event_types_simple_simpleevent
    ADD CONSTRAINT "D3c2d44564dd7f568e73116a1fafb482" FOREIGN KEY (eventbase_ptr_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_authorlisting D3f72b36b8354fcc55813da655df821d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT "D3f72b36b8354fcc55813da655df821d" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_authorlisting(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ik_event_listing_types D534fa81577cb27c90194c8eb8707cfe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types
    ADD CONSTRAINT "D534fa81577cb27c90194c8eb8707cfe" FOREIGN KEY (eventcontentlistingitem_id) REFERENCES contentitem_ik_event_listing_eventcontentlistingitem(contentitem_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_pages_urlnode D56f259b60847c71a6bf5c3fcfa42f66; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT "D56f259b60847c71a6bf5c3fcfa42f66" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: textfile_textfile_translation D58fce3347c4bdfcab927c538a74c793; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY textfile_textfile_translation
    ADD CONSTRAINT "D58fce3347c4bdfcab927c538a74c793" FOREIGN KEY (master_id) REFERENCES pagetype_textfile_textfile(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_slideshow_slideshowitem D59fe44fe9e5aefe1054bf0b2b4e5862; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_slideshow_slideshowitem
    ADD CONSTRAINT "D59fe44fe9e5aefe1054bf0b2b4e5862" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_publishingm2mmodelb_related_a_models D5ce9d01712873a19b40ba7c73274f82; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models
    ADD CONSTRAINT "D5ce9d01712873a19b40ba7c73274f82" FOREIGN KEY (publishingm2mmodelb_id) REFERENCES tests_publishingm2mmodelb(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_image_imageitem D5e1f2542df3427c4259a5b9f94dc3a9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_image_imageitem
    ADD CONSTRAINT "D5e1f2542df3427c4259a5b9f94dc3a9" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_publishingm2mmodelb_related_a_models D62dd130fe963777318ef625b65e3587; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models
    ADD CONSTRAINT "D62dd130fe963777318ef625b65e3587" FOREIGN KEY (publishingm2mmodela_id) REFERENCES tests_publishingm2mmodela(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_followerinformation_group_followers D648d90c316ad733a485d8dd04d22a96; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers
    ADD CONSTRAINT "D648d90c316ad733a485d8dd04d22a96" FOREIGN KEY (followerinformation_id) REFERENCES notifications_followerinformation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_image_gallery_imagegalleryshowitem D656c93cfd181fd1df9e1fe7b2f1a7d1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_image_gallery_imagegalleryshowitem
    ADD CONSTRAINT "D656c93cfd181fd1df9e1fe7b2f1a7d1" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_articlelisting D668b920129450e2c896f576f0890769; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT "D668b920129450e2c896f576f0890769" FOREIGN KEY (publishing_linked_id) REFERENCES test_articlelisting(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_oembed_with_caption_item D674cbf2aea8bebe7a5c3ee1b2a543bb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_oembed_with_caption_item
    ADD CONSTRAINT "D674cbf2aea8bebe7a5c3ee1b2a543bb" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_followerinformation_followers D6917805e321253c9bb22f0d61a5d38f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers
    ADD CONSTRAINT "D6917805e321253c9bb22f0d61a5d38f" FOREIGN KEY (followerinformation_id) REFERENCES notifications_followerinformation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_layoutpage D69b752fae4b023166a9972d5d0d8c69; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT "D69b752fae4b023166a9972d5d0d8c69" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_events_todays_occurrences_todaysoccurrences D6a33e4c59c4a031e13f92afc3e129fd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_events_todays_occurrences_todaysoccurrences
    ADD CONSTRAINT "D6a33e4c59c4a031e13f92afc3e129fd" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_contents_contentitem D6a43d513db9d24d96c7c21dabcf84f5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem
    ADD CONSTRAINT "D6a43d513db9d24d96c7c21dabcf84f5" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_authors_author D6b3902cf9671b92c8203e23d49e4f3a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author
    ADD CONSTRAINT "D6b3902cf9671b92c8203e23d49e4f3a" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_authors_author(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventbase D6c4c0d55b1296eafbe99fede3685e89; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT "D6c4c0d55b1296eafbe99fede3685e89" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_links_pagelink D72b3192f934d3cf0249ab6bd6b07f03; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_pagelink
    ADD CONSTRAINT "D72b3192f934d3cf0249ab6bd6b07f03" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_horizontal_rule_horizontalruleitem D746928cdc079e1b9e31b78b58158e65; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_horizontal_rule_horizontalruleitem
    ADD CONSTRAINT "D746928cdc079e1b9e31b78b58158e65" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_layoutpage_with_related D74ff5fd75b2702b5c73aa81b62f58ef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT "D74ff5fd75b2702b5c73aa81b62f58ef" FOREIGN KEY (publishing_linked_id) REFERENCES test_layoutpage_with_related(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_file_fileitem D7a61198c03a809e52d177a4a32077d7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_file_fileitem
    ADD CONSTRAINT "D7a61198c03a809e52d177a4a32077d7" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_article D7d2a9b5365df4e58c84ecdad482fe4c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT "D7d2a9b5365df4e58c84ecdad482fe4c" FOREIGN KEY (parent_id) REFERENCES test_articlelisting(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_followerinformation D7d9421c0dee31db03ad49b802f1d943; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation
    ADD CONSTRAINT "D7d9421c0dee31db03ad49b802f1d943" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_layoutpage D7f8167aa9d0d2b028bedcfe5ed3e32c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT "D7f8167aa9d0d2b028bedcfe5ed3e32c" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_layoutpage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_article_article D8228d3eacb2b5095420947ae3d00f00; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT "D8228d3eacb2b5095420947ae3d00f00" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_article_article(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_instagram_embed_instagramembeditem D892b3ae82379c196d74d17cb7b26b14; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_instagram_embed_instagramembeditem
    ADD CONSTRAINT "D892b3ae82379c196d74d17cb7b26b14" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_links_authorlink D8ad5f23ed00d30b6ae7068ae725adc1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_authorlink
    ADD CONSTRAINT "D8ad5f23ed00d30b6ae7068ae725adc1" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_article_article D8d69b5b30fc71aed00ddf236779316b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT "D8d69b5b30fc71aed00ddf236779316b" FOREIGN KEY (parent_id) REFERENCES icekit_articlecategorypage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_contents_contentitem D9120a5e8b6cf31cc03b38401d0b829b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem
    ADD CONSTRAINT "D9120a5e8b6cf31cc03b38401d0b829b" FOREIGN KEY (placeholder_id) REFERENCES fluent_contents_placeholder(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_eventlistingfordate_eventlistingpage D94c2a91a5b49eb6a1669eb622770dd8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT "D94c2a91a5b49eb6a1669eb622770dd8" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_text_textitem D963bf23cc2bbb2541437049b04a9490; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_text_textitem
    ADD CONSTRAINT "D963bf23cc2bbb2541437049b04a9490" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_contact_person_contactpersonitem D9dffe0c8cd92e52bad901d12fb6cb94; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_contact_person_contactpersonitem
    ADD CONSTRAINT "D9dffe0c8cd92e52bad901d12fb6cb94" FOREIGN KEY (contact_id) REFERENCES icekit_plugins_contact_person_contactperson(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_content_listing_contentlistingitem a7ad0f3ab9eece5f10263ee1e751354f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_content_listing_contentlistingitem
    ADD CONSTRAINT a7ad0f3ab9eece5f10263ee1e751354f FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_image_gallery_imagegalleryshowitem a8a3c84526b5bb62ec7381f1b24c7fb5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_image_gallery_imagegalleryshowitem
    ADD CONSTRAINT a8a3c84526b5bb62ec7381f1b24c7fb5 FOREIGN KEY (slide_show_id) REFERENCES icekit_plugins_slideshow_slideshow(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: post_office_emailtemplate ab563fdec8e3292c5558f933e5d5f7bd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_emailtemplate
    ADD CONSTRAINT ab563fdec8e3292c5558f933e5d5f7bd FOREIGN KEY (default_template_id) REFERENCES post_office_emailtemplate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_oembeditem_oembeditem acb7b587835487702e85d5a43ea3830e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_oembeditem_oembeditem
    ADD CONSTRAINT acb7b587835487702e85d5a43ea3830e FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_links_articlelink acfc3144c21804f82af5821cbf278457; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_articlelink
    ADD CONSTRAINT acfc3144c21804f82af5821cbf278457 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_plugins_slideshow_slideshow af7eff6d97aa6682ccb619ce20e073cd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_slideshow_slideshow
    ADD CONSTRAINT af7eff6d97aa6682ccb619ce20e073cd FOREIGN KEY (publishing_linked_id) REFERENCES icekit_plugins_slideshow_slideshow(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth__content_type_id_a28c4ab1069e97b_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth__content_type_id_a28c4ab1069e97b_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_group_id_1b80906b4e9a50c9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_group_id_1b80906b4e9a50c9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permission_id_65c3c59c45b0da02_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permission_id_65c3c59c45b0da02_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: authtoken_token authtoken__user_id_3a70355ce1a875dd_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY authtoken_token
    ADD CONSTRAINT authtoken__user_id_3a70355ce1a875dd_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_articlelisting b57d035c68cd3f3d512e48e3f2dedea8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT b57d035c68cd3f3d512e48e3f2dedea8 FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_quote_quoteitem bb02428515ded559e9cc6be4b4ed226c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_quote_quoteitem
    ADD CONSTRAINT bb02428515ded559e9cc6be4b4ed226c FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_iframe_iframeitem bfb7ed18891f160b6ddb82b332873a77; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_iframe_iframeitem
    ADD CONSTRAINT bfb7ed18891f160b6ddb82b332873a77 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_twitter_embed_twitterembeditem c2c288ab70dcc6f54ffee48b5bb4a431; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_twitter_embed_twitterembeditem
    ADD CONSTRAINT c2c288ab70dcc6f54ffee48b5bb4a431 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem c3cbe36e2a2afbfc1aff35ebf2827ec4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem
    ADD CONSTRAINT c3cbe36e2a2afbfc1aff35ebf2827ec4 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_event_listing_eventcontentlistingitem c43b6e1c444043d045ec6d700824d3d0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_event_listing_eventcontentlistingitem
    ADD CONSTRAINT c43b6e1c444043d045ec6d700824d3d0 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_article_article cde74934885e04bdd3fa4703a96ddbfe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT cde74934885e04bdd3fa4703a96ddbfe FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_event_listing_eventcontentlistingitem cont_content_type_id_4b84cbdeee587f42_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_event_listing_eventcontentlistingitem
    ADD CONSTRAINT cont_content_type_id_4b84cbdeee587f42_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_content_listing_contentlistingitem cont_content_type_id_5c4212e7b55da8d0_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_content_listing_contentlistingitem
    ADD CONSTRAINT cont_content_type_id_5c4212e7b55da8d0_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_events_links_eventlink contenti_item_id_3ecd38d2c1024b09_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_events_links_eventlink
    ADD CONSTRAINT contenti_item_id_3ecd38d2c1024b09_fk_icekit_events_eventbase_id FOREIGN KEY (item_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_links_articlelink contentit_item_id_6902f837a26ce9c3_fk_icekit_article_article_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_articlelink
    ADD CONSTRAINT contentit_item_id_6902f837a26ce9c3_fk_icekit_article_article_id FOREIGN KEY (item_id) REFERENCES icekit_article_article(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_links_authorlink contentite_item_id_166cbb8078c57e7f_fk_icekit_authors_author_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_authorlink
    ADD CONSTRAINT contentite_item_id_166cbb8078c57e7f_fk_icekit_authors_author_id FOREIGN KEY (item_id) REFERENCES icekit_authors_author(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_file_fileitem contentitem_file_fileit_file_id_d5b107ada6f8076_fk_file_file_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_file_fileitem
    ADD CONSTRAINT contentitem_file_fileit_file_id_d5b107ada6f8076_fk_file_file_id FOREIGN KEY (file_id) REFERENCES icekit_plugins_file_file(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_image_imageitem contentitem_image_i_image_id_3d419aab9ff251b6_fk_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_image_imageitem
    ADD CONSTRAINT contentitem_image_i_image_id_3d419aab9ff251b6_fk_image_image_id FOREIGN KEY (image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_ik_links_pagelink contentitem_item_id_6ba466c7a00d0435_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_pagelink
    ADD CONSTRAINT contentitem_item_id_6ba466c7a00d0435_fk_fluent_pages_urlnode_id FOREIGN KEY (item_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_reusable_form_formitem contentitem_reusable__form_id_24bfa0a3b7c27b5b_fk_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_reusable_form_formitem
    ADD CONSTRAINT contentitem_reusable__form_id_24bfa0a3b7c27b5b_fk_forms_form_id FOREIGN KEY (form_id) REFERENCES forms_form(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_faq_faqitem dc94ec01eade3071557808468f97a5ee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_faq_faqitem
    ADD CONSTRAINT dc94ec01eade3071557808468f97a5ee FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventbase derived_from_id_5c02da1134f17c16_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT derived_from_id_5c02da1134f17c16_fk_icekit_events_eventbase_id FOREIGN KEY (derived_from_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_map_mapitem dfe949fbe177f7fb98826c17d44659b0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_map_mapitem
    ADD CONSTRAINT dfe949fbe177f7fb98826c17d44659b0 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_sharedcontent_sharedcontentitem dfec62abb9fdccad6e5b490fe735e043; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_sharedcontent_sharedcontentitem
    ADD CONSTRAINT dfec62abb9fdccad6e5b490fe735e043 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djcelery_periodictask dj_interval_id_1e059af646f49561_fk_djcelery_intervalschedule_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT dj_interval_id_1e059af646f49561_fk_djcelery_intervalschedule_id FOREIGN KEY (interval_id) REFERENCES djcelery_intervalschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log djan_content_type_id_2ca7e25efca8933c_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT djan_content_type_id_2ca7e25efca8933c_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_adm_user_id_18f270e65b0de43f_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_adm_user_id_18f270e65b0de43f_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_redirect django_redirect_site_id_2fd85d7e03155322_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_redirect
    ADD CONSTRAINT django_redirect_site_id_2fd85d7e03155322_fk_django_site_id FOREIGN KEY (site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djcelery_periodictask djce_crontab_id_78b22ce49259bc58_fk_djcelery_crontabschedule_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT djce_crontab_id_78b22ce49259bc58_fk_djcelery_crontabschedule_id FOREIGN KEY (crontab_id) REFERENCES djcelery_crontabschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djcelery_taskstate djcelery__worker_id_7de9d217baa22059_fk_djcelery_workerstate_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_taskstate
    ADD CONSTRAINT djcelery__worker_id_7de9d217baa22059_fk_djcelery_workerstate_id FOREIGN KEY (worker_id) REFERENCES djcelery_workerstate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djkombu_message djkombu_message_queue_id_39d8365252f2f8ad_fk_djkombu_queue_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_message
    ADD CONSTRAINT djkombu_message_queue_id_39d8365252f2f8ad_fk_djkombu_queue_id FOREIGN KEY (queue_id) REFERENCES djkombu_queue(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_publishingm2mmodelb e0049c351b059eb36c39b42ee05a4cc9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb
    ADD CONSTRAINT e0049c351b059eb36c39b42ee05a4cc9 FOREIGN KEY (publishing_linked_id) REFERENCES tests_publishingm2mmodelb(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: easy_thumbnails_thumbnaildimensions e_thumbnail_id_329715e45dd2e01a_fk_easy_thumbnails_thumbnail_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnaildimensions
    ADD CONSTRAINT e_thumbnail_id_329715e45dd2e01a_fk_easy_thumbnails_thumbnail_id FOREIGN KEY (thumbnail_id) REFERENCES easy_thumbnails_thumbnail(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_slideshow_slideshowitem ea5e6c5d8f51f9affb146c4beb49c329; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_slideshow_slideshowitem
    ADD CONSTRAINT ea5e6c5d8f51f9affb146c4beb49c329 FOREIGN KEY (slide_show_id) REFERENCES icekit_plugins_slideshow_slideshow(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: easy_thumbnails_thumbnail easy_th_source_id_584430c2d61eb0c5_fk_easy_thumbnails_source_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnail
    ADD CONSTRAINT easy_th_source_id_584430c2d61eb0c5_fk_easy_thumbnails_source_id FOREIGN KEY (source_id) REFERENCES easy_thumbnails_source(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_layoutpage_with_related_related_pages ec7c10d960fccba9451d31dcd783ef04; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages
    ADD CONSTRAINT ec7c10d960fccba9451d31dcd783ef04 FOREIGN KEY (layoutpagewithrelatedpages_id) REFERENCES test_layoutpage_with_related(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_icekit_plugins_contact_person_contactpersonitem efd03fd7ec02fb27d20d77b5921f2d14; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_contact_person_contactpersonitem
    ADD CONSTRAINT efd03fd7ec02fb27d20d77b5921f2d14 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_articlecategorypage f10d285205dd02ef874b92dedea80a53; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT f10d285205dd02ef874b92dedea80a53 FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_rawhtml_rawhtmlitem f6405575945e2e3d8a56ef9c7b5406cf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_rawhtml_rawhtmlitem
    ADD CONSTRAINT f6405575945e2e3d8a56ef9c7b5406cf FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_setting f8ab1bffe888d6f7bd62f3ec57257cf8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_setting
    ADD CONSTRAINT f8ab1bffe888d6f7bd62f3ec57257cf8 FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_sharedcontent_sharedcontentitem f9e7d70c6343c742213c5e0cc5593bad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_sharedcontent_sharedcontentitem
    ADD CONSTRAINT f9e7d70c6343c742213c5e0cc5593bad FOREIGN KEY (shared_content_id) REFERENCES sharedcontent_sharedcontent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_searchpage fbd8a006e177de81b99f68b52fcbf5dc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_searchpage
    ADD CONSTRAINT fbd8a006e177de81b99f68b52fcbf5dc FOREIGN KEY (publishing_linked_id) REFERENCES icekit_searchpage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_plugins_file_file_categories fil_mediacategory_id_865783e5d23d365_fk_icekit_mediacategory_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories
    ADD CONSTRAINT fil_mediacategory_id_865783e5d23d365_fk_icekit_mediacategory_id FOREIGN KEY (mediacategory_id) REFERENCES icekit_mediacategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_plugins_file_file_categories file_file_categories_file_id_6a258773adece998_fk_file_file_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories
    ADD CONSTRAINT file_file_categories_file_id_6a258773adece998_fk_file_file_id FOREIGN KEY (file_id) REFERENCES icekit_plugins_file_file(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_contents_contentitem fluen_parent_type_id_6af048a6406f5c81_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem
    ADD CONSTRAINT fluen_parent_type_id_6af048a6406f5c81_fk_django_content_type_id FOREIGN KEY (parent_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_contents_placeholder fluen_parent_type_id_7a4e056027c5655a_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_placeholder
    ADD CONSTRAINT fluen_parent_type_id_7a4e056027c5655a_fk_django_content_type_id FOREIGN KEY (parent_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_pages_urlnode fluent_p_author_id_32d23b3a9980ed76_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_p_author_id_32d23b3a9980ed76_fk_polymorphic_auth_user_id FOREIGN KEY (author_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_pages_urlnode_translation fluent_pa_master_id_28f9a5bcea4a4f93_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode_translation
    ADD CONSTRAINT fluent_pa_master_id_28f9a5bcea4a4f93_fk_fluent_pages_urlnode_id FOREIGN KEY (master_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_pages_htmlpage_translation fluent_pa_master_id_3748913884cbde81_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_htmlpage_translation
    ADD CONSTRAINT fluent_pa_master_id_3748913884cbde81_fk_fluent_pages_urlnode_id FOREIGN KEY (master_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_pages_urlnode fluent_pa_parent_id_3f0fb02f3c868405_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_pa_parent_id_3f0fb02f3c868405_fk_fluent_pages_urlnode_id FOREIGN KEY (parent_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_pages_urlnode fluent_pages_u_parent_site_id_858c8cfc1c06214_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_pages_u_parent_site_id_858c8cfc1c06214_fk_django_site_id FOREIGN KEY (parent_site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: forms_field forms_field_form_id_537de51c5672aae9_fk_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_field
    ADD CONSTRAINT forms_field_form_id_537de51c5672aae9_fk_forms_form_id FOREIGN KEY (form_id) REFERENCES forms_form(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: forms_fieldentry forms_fieldentr_entry_id_7493975110141081_fk_forms_formentry_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_fieldentry
    ADD CONSTRAINT forms_fieldentr_entry_id_7493975110141081_fk_forms_formentry_id FOREIGN KEY (entry_id) REFERENCES forms_formentry(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: forms_form_sites forms_form_sites_form_id_56607289ba1beeb3_fk_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites
    ADD CONSTRAINT forms_form_sites_form_id_56607289ba1beeb3_fk_forms_form_id FOREIGN KEY (form_id) REFERENCES forms_form(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: forms_form_sites forms_form_sites_site_id_2e2d33cdfa579ec6_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites
    ADD CONSTRAINT forms_form_sites_site_id_2e2d33cdfa579ec6_fk_django_site_id FOREIGN KEY (site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: forms_formentry forms_formentry_form_id_362c34b9cb448095_fk_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_formentry
    ADD CONSTRAINT forms_formentry_form_id_362c34b9cb448095_fk_forms_form_id FOREIGN KEY (form_id) REFERENCES forms_form(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_workflow_workflowstate ice_assigned_to_id_11e83c2cc7585a34_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_workflow_workflowstate
    ADD CONSTRAINT ice_assigned_to_id_11e83c2cc7585a34_fk_polymorphic_auth_user_id FOREIGN KEY (assigned_to_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventbase_secondary_types ice_eventbase_id_1644608096866a53_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types
    ADD CONSTRAINT ice_eventbase_id_1644608096866a53_fk_icekit_events_eventbase_id FOREIGN KEY (eventbase_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventbase_secondary_types ice_eventtype_id_28150fccc0fe3490_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types
    ADD CONSTRAINT ice_eventtype_id_28150fccc0fe3490_fk_icekit_events_eventtype_id FOREIGN KEY (eventtype_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_layout_content_types iceki_contenttype_id_2dc535d16c6b1523_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types
    ADD CONSTRAINT iceki_contenttype_id_2dc535d16c6b1523_fk_django_content_type_id FOREIGN KEY (contenttype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventbase iceki_part_of_id_54b010b207bc18aa_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT iceki_part_of_id_54b010b207bc18aa_fk_icekit_events_eventbase_id FOREIGN KEY (part_of_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_occurrence icekit__event_id_52acf2456feaaa96_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_occurrence
    ADD CONSTRAINT icekit__event_id_52acf2456feaaa96_fk_icekit_events_eventbase_id FOREIGN KEY (event_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_article_article icekit_article_a_layout_id_5a5bea523c7d3faf_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT icekit_article_a_layout_id_5a5bea523c7d3faf_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventrepeatsgenerator icekit_e_event_id_2e9900bae08dc8d_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventrepeatsgenerator
    ADD CONSTRAINT icekit_e_event_id_2e9900bae08dc8d_fk_icekit_events_eventbase_id FOREIGN KEY (event_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_event_types_simple_simpleevent icekit_event_typ_layout_id_2657fd1d7ee7ef61_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_event_types_simple_simpleevent
    ADD CONSTRAINT icekit_event_typ_layout_id_2657fd1d7ee7ef61_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_layout_content_types icekit_layout_co_layout_id_706624d375bb5f39_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types
    ADD CONSTRAINT icekit_layout_co_layout_id_706624d375bb5f39_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ik_event_listing_types ik__eventtype_id_3af887d92b2d6951_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types
    ADD CONSTRAINT ik__eventtype_id_3af887d92b2d6951_fk_icekit_events_eventtype_id FOREIGN KEY (eventtype_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ik_todays_occurrences_types ik_t_eventtype_id_4a770759a799f18_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types
    ADD CONSTRAINT ik_t_eventtype_id_4a770759a799f18_fk_icekit_events_eventtype_id FOREIGN KEY (eventtype_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_plugins_image_image_categories im_mediacategory_id_794fd88978b44d3d_fk_icekit_mediacategory_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories
    ADD CONSTRAINT im_mediacategory_id_794fd88978b44d3d_fk_icekit_mediacategory_id FOREIGN KEY (mediacategory_id) REFERENCES icekit_mediacategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_plugins_image_image_categories image_image_categor_image_id_44d822caadd9755c_fk_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories
    ADD CONSTRAINT image_image_categor_image_id_44d822caadd9755c_fk_image_image_id FOREIGN KEY (image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_date mo_setting_ptr_id_14d706ba177074c5_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_date
    ADD CONSTRAINT mo_setting_ptr_id_14d706ba177074c5_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_image mo_setting_ptr_id_22aa74d0801598ff_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_image
    ADD CONSTRAINT mo_setting_ptr_id_22aa74d0801598ff_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_text mo_setting_ptr_id_231fc7f8eee415e6_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_text
    ADD CONSTRAINT mo_setting_ptr_id_231fc7f8eee415e6_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_time mo_setting_ptr_id_4a155e59ffcfc870_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_time
    ADD CONSTRAINT mo_setting_ptr_id_4a155e59ffcfc870_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_float mo_setting_ptr_id_4ddfa74cebf53e3a_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_float
    ADD CONSTRAINT mo_setting_ptr_id_4ddfa74cebf53e3a_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_integer mo_setting_ptr_id_6c3217230fdc8b58_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_integer
    ADD CONSTRAINT mo_setting_ptr_id_6c3217230fdc8b58_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_file mo_setting_ptr_id_74fa35fe22baaeed_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_file
    ADD CONSTRAINT mo_setting_ptr_id_74fa35fe22baaeed_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_decimal mo_setting_ptr_id_79b50faeb0433e91_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_decimal
    ADD CONSTRAINT mo_setting_ptr_id_79b50faeb0433e91_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_boolean mo_setting_ptr_id_7a5572d8aff4dc72_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_boolean
    ADD CONSTRAINT mo_setting_ptr_id_7a5572d8aff4dc72_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: model_settings_datetime mod_setting_ptr_id_aad8956f5afba40_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_datetime
    ADD CONSTRAINT mod_setting_ptr_id_aad8956f5afba40_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_hasreadmessage no_message_id_1972d14a6c39bdfc_fk_notifications_notification_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_hasreadmessage
    ADD CONSTRAINT no_message_id_1972d14a6c39bdfc_fk_notifications_notification_id FOREIGN KEY (message_id) REFERENCES notifications_notification(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_followerinformation noti_content_type_id_6e2f52401d6ded8a_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation
    ADD CONSTRAINT noti_content_type_id_6e2f52401d6ded8a_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_hasreadmessage notifica_person_id_2e45a28707d9a12b_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_hasreadmessage
    ADD CONSTRAINT notifica_person_id_2e45a28707d9a12b_fk_polymorphic_auth_user_id FOREIGN KEY (person_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_notification notificati_user_id_2bfa1ca26dbc1b05_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notification
    ADD CONSTRAINT notificati_user_id_2bfa1ca26dbc1b05_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_notificationsetting notificati_user_id_3dfb012e22083e1a_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notificationsetting
    ADD CONSTRAINT notificati_user_id_3dfb012e22083e1a_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_followerinformation_followers notificati_user_id_4b74ed93f7727133_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers
    ADD CONSTRAINT notificati_user_id_4b74ed93f7727133_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_followerinformation_group_followers notifications_follow_group_id_6150e9b99f6b1928_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers
    ADD CONSTRAINT notifications_follow_group_id_6150e9b99f6b1928_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_searchpage page_urlnode_ptr_id_29daf354bb5aa9c0_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_searchpage
    ADD CONSTRAINT page_urlnode_ptr_id_29daf354bb5aa9c0_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_articlecategorypage page_urlnode_ptr_id_4609f474221c9746_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT page_urlnode_ptr_id_4609f474221c9746_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_redirectnode_redirectnode page_urlnode_ptr_id_472ceffe40b31372_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_redirectnode_redirectnode
    ADD CONSTRAINT page_urlnode_ptr_id_472ceffe40b31372_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_fluentpage_fluentpage page_urlnode_ptr_id_4aee60e4d7d9a760_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_fluentpage_fluentpage
    ADD CONSTRAINT page_urlnode_ptr_id_4aee60e4d7d9a760_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_textfile_textfile page_urlnode_ptr_id_52fd7d5be9a40704_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_textfile_textfile
    ADD CONSTRAINT page_urlnode_ptr_id_52fd7d5be9a40704_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_layoutpage page_urlnode_ptr_id_534f2802de6d5478_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT page_urlnode_ptr_id_534f2802de6d5478_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_eventlistingfordate_eventlistingpage page_urlnode_ptr_id_5bed3793e6bf6eaf_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT page_urlnode_ptr_id_5bed3793e6bf6eaf_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_authorlisting page_urlnode_ptr_id_6829f0a117bed67a_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT page_urlnode_ptr_id_6829f0a117bed67a_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_fluentpage_fluentpage pagetyp_layout_id_2836cc41f327e8d_fk_fluent_pages_pagelayout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_fluentpage_fluentpage
    ADD CONSTRAINT pagetyp_layout_id_2836cc41f327e8d_fk_fluent_pages_pagelayout_id FOREIGN KEY (layout_id) REFERENCES fluent_pages_pagelayout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_eventlistingfordate_eventlistingpage pagetype_eventli_layout_id_537a04fe7d60797c_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT pagetype_eventli_layout_id_537a04fe7d60797c_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_articlecategorypage pagetype_icekit__layout_id_6ad44ce83ed48759_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT pagetype_icekit__layout_id_6ad44ce83ed48759_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_authorlisting pagetype_icekit_a_layout_id_579f2925b72c7f3_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT pagetype_icekit_a_layout_id_579f2925b72c7f3_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_layoutpage pagetype_layout__layout_id_383a0d79e7f4eecb_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT pagetype_layout__layout_id_383a0d79e7f4eecb_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: post_office_email po_template_id_2235a2220887a14d_fk_post_office_emailtemplate_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_email
    ADD CONSTRAINT po_template_id_2235a2220887a14d_fk_post_office_emailtemplate_id FOREIGN KEY (template_id) REFERENCES post_office_emailtemplate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphic_auth_email_emailuser polymo_user_ptr_id_6a8caf8215fa215a_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_email_emailuser
    ADD CONSTRAINT polymo_user_ptr_id_6a8caf8215fa215a_fk_polymorphic_auth_user_id FOREIGN KEY (user_ptr_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphic_auth_user_user_permissions polymorphi_permission_id_36de5f52f29bcced_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions
    ADD CONSTRAINT polymorphi_permission_id_36de5f52f29bcced_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphic_auth_user_groups polymorphi_user_id_70007f039c5af827_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups
    ADD CONSTRAINT polymorphi_user_id_70007f039c5af827_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphic_auth_user_groups polymorphic_auth_use_group_id_45442508aa2549f0_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups
    ADD CONSTRAINT polymorphic_auth_use_group_id_45442508aa2549f0_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphic_auth_user polymorphic_ctype_id_3c51ab6f5715609_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user
    ADD CONSTRAINT polymorphic_ctype_id_3c51ab6f5715609_fk_django_content_type_id FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphic_auth_user_user_permissions polymorphic_user_id_c16c15b51d75529_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions
    ADD CONSTRAINT polymorphic_user_id_c16c15b51d75529_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: post_office_attachment_emails pos_attachment_id_5a5c523010d54e09_fk_post_office_attachment_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails
    ADD CONSTRAINT pos_attachment_id_5a5c523010d54e09_fk_post_office_attachment_id FOREIGN KEY (attachment_id) REFERENCES post_office_attachment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: post_office_attachment_emails post_office_a_email_id_104aca12e136a983_fk_post_office_email_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails
    ADD CONSTRAINT post_office_a_email_id_104aca12e136a983_fk_post_office_email_id FOREIGN KEY (email_id) REFERENCES post_office_email(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: post_office_log post_office_l_email_id_3aca67ab61c8afc4_fk_post_office_email_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_log
    ADD CONSTRAINT post_office_l_email_id_3aca67ab61c8afc4_fk_post_office_email_id FOREIGN KEY (email_id) REFERENCES post_office_email(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_events_eventbase primary_type_id_490cb646066da147_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT primary_type_id_490cb646066da147_fk_icekit_events_eventtype_id FOREIGN KEY (primary_type_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reversion_version reve_content_type_id_238aa26c9d058501_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_version
    ADD CONSTRAINT reve_content_type_id_238aa26c9d058501_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reversion_revision reversion__user_id_29c60f0af1f08184_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_revision
    ADD CONSTRAINT reversion__user_id_29c60f0af1f08184_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reversion_version reversion_revision_id_2a7e1dbaccb99362_fk_reversion_revision_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_version
    ADD CONSTRAINT reversion_revision_id_2a7e1dbaccb99362_fk_reversion_revision_id FOREIGN KEY (revision_id) REFERENCES reversion_revision(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: sharedcontent_sharedcontent_translation sh_master_id_5a5dbb4cc1beb25e_fk_sharedcontent_sharedcontent_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent_translation
    ADD CONSTRAINT sh_master_id_5a5dbb4cc1beb25e_fk_sharedcontent_sharedcontent_id FOREIGN KEY (master_id) REFERENCES sharedcontent_sharedcontent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: sharedcontent_sharedcontent sharedcontent_parent_site_id_5041fde35c20f8e5_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent
    ADD CONSTRAINT sharedcontent_parent_site_id_5041fde35c20f8e5_fk_django_site_id FOREIGN KEY (parent_site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_publishingm2mthroughtable tes_a_model_id_345a955ca0abca61_fk_tests_publishingm2mmodela_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mthroughtable
    ADD CONSTRAINT tes_a_model_id_345a955ca0abca61_fk_tests_publishingm2mmodela_id FOREIGN KEY (a_model_id) REFERENCES tests_publishingm2mmodela(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_publishingm2mthroughtable tes_b_model_id_3692289f81c86798_fk_tests_publishingm2mmodelb_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mthroughtable
    ADD CONSTRAINT tes_b_model_id_3692289f81c86798_fk_tests_publishingm2mmodelb_id FOREIGN KEY (b_model_id) REFERENCES tests_publishingm2mmodelb(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_article test_a_publishing_linked_id_385d0c31c9e4bc37_fk_test_article_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT test_a_publishing_linked_id_385d0c31c9e4bc37_fk_test_article_id FOREIGN KEY (publishing_linked_id) REFERENCES test_article(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_article test_article_layout_id_10d9d3adf777cfe1_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT test_article_layout_id_10d9d3adf777cfe1_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_articlelisting test_articlelist_layout_id_6b1323ac3164fc12_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT test_articlelist_layout_id_6b1323ac3164fc12_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_layoutpage_with_related_related_pages test_layout_page_id_32cfd027c0ba39c9_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages
    ADD CONSTRAINT test_layout_page_id_32cfd027c0ba39c9_fk_fluent_pages_urlnode_id FOREIGN KEY (page_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_layoutpage_with_related test_layoutpage__layout_id_756762b157cacb59_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT test_layoutpage__layout_id_756762b157cacb59_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_articlelisting test_urlnode_ptr_id_3038986819ea3a7f_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT test_urlnode_ptr_id_3038986819ea3a7f_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_layoutpage_with_related test_urlnode_ptr_id_4c0be4710c8865ac_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT test_urlnode_ptr_id_4c0be4710c8865ac_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_barwithlayout tests_barwithlay_layout_id_777458b9d8368e9c_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_barwithlayout
    ADD CONSTRAINT tests_barwithlay_layout_id_777458b9d8368e9c_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_bazwithlayout tests_bazwithlay_layout_id_61f850373d403e6c_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_bazwithlayout
    ADD CONSTRAINT tests_bazwithlay_layout_id_61f850373d403e6c_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_foowithlayout tests_foowithlay_layout_id_2796868910770293_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_foowithlayout
    ADD CONSTRAINT tests_foowithlay_layout_id_2796868910770293_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_workflow_workflowstate workf_content_type_id_f9926f5b5bf1f70_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_workflow_workflowstate
    ADD CONSTRAINT workf_content_type_id_f9926f5b5bf1f70_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

