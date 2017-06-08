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
    end_date_edtf character varying(255),
    end_date_latest date,
    end_date_sort_ascending date,
    end_date_sort_descending date,
    start_date_display character varying(255) NOT NULL,
    start_date_earliest date,
    start_date_edtf character varying(255),
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
    creation_date_edtf character varying(255)
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
    CONSTRAINT gk_collections_work_creator_workor_order_2f205b3e35c292bd_check CHECK (("order" >= 0))
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
    list_image character varying(100) NOT NULL
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
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_taskmeta ALTER COLUMN id SET DEFAULT nextval('celery_taskmeta_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_tasksetmeta ALTER COLUMN id SET DEFAULT nextval('celery_tasksetmeta_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_admin_log ALTER COLUMN id SET DEFAULT nextval('django_admin_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_migrations ALTER COLUMN id SET DEFAULT nextval('django_migrations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_redirect ALTER COLUMN id SET DEFAULT nextval('django_redirect_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_site ALTER COLUMN id SET DEFAULT nextval('django_site_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_crontabschedule ALTER COLUMN id SET DEFAULT nextval('djcelery_crontabschedule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_intervalschedule ALTER COLUMN id SET DEFAULT nextval('djcelery_intervalschedule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask ALTER COLUMN id SET DEFAULT nextval('djcelery_periodictask_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_taskstate ALTER COLUMN id SET DEFAULT nextval('djcelery_taskstate_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_workerstate ALTER COLUMN id SET DEFAULT nextval('djcelery_workerstate_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_message ALTER COLUMN id SET DEFAULT nextval('djkombu_message_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_queue ALTER COLUMN id SET DEFAULT nextval('djkombu_queue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_source ALTER COLUMN id SET DEFAULT nextval('easy_thumbnails_source_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnail ALTER COLUMN id SET DEFAULT nextval('easy_thumbnails_thumbnail_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnaildimensions ALTER COLUMN id SET DEFAULT nextval('easy_thumbnails_thumbnaildimensions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem ALTER COLUMN id SET DEFAULT nextval('fluent_contents_contentitem_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_placeholder ALTER COLUMN id SET DEFAULT nextval('fluent_contents_placeholder_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_htmlpage_translation ALTER COLUMN id SET DEFAULT nextval('fluent_pages_htmlpage_translation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_pagelayout ALTER COLUMN id SET DEFAULT nextval('fluent_pages_pagelayout_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode ALTER COLUMN id SET DEFAULT nextval('fluent_pages_urlnode_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode_translation ALTER COLUMN id SET DEFAULT nextval('fluent_pages_urlnode_translation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_field ALTER COLUMN id SET DEFAULT nextval('forms_field_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_fieldentry ALTER COLUMN id SET DEFAULT nextval('forms_fieldentry_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form ALTER COLUMN id SET DEFAULT nextval('forms_form_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites ALTER COLUMN id SET DEFAULT nextval('forms_form_sites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_formentry ALTER COLUMN id SET DEFAULT nextval('forms_formentry_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_creatorbase ALTER COLUMN id SET DEFAULT nextval('gk_collections_work_creator_creatorbase_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_role ALTER COLUMN id SET DEFAULT nextval('gk_collections_work_creator_role_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workbase ALTER COLUMN id SET DEFAULT nextval('gk_collections_work_creator_workbase_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workcreator ALTER COLUMN id SET DEFAULT nextval('gk_collections_work_creator_workcreator_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workimage ALTER COLUMN id SET DEFAULT nextval('gk_collections_work_creator_workimage_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workimagetype ALTER COLUMN id SET DEFAULT nextval('gk_collections_work_creator_workimagetype_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workorigin ALTER COLUMN id SET DEFAULT nextval('gk_collections_work_creator_workorigin_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_collections_country ALTER COLUMN id SET DEFAULT nextval('glamkit_collections_country_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_collections_geographiclocation ALTER COLUMN id SET DEFAULT nextval('glamkit_collections_geographiclocation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_sponsors_sponsor ALTER COLUMN id SET DEFAULT nextval('glamkit_sponsors_sponsor_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article ALTER COLUMN id SET DEFAULT nextval('icekit_article_article_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author ALTER COLUMN id SET DEFAULT nextval('icekit_authors_author_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase ALTER COLUMN id SET DEFAULT nextval('icekit_events_eventbase_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types ALTER COLUMN id SET DEFAULT nextval('icekit_events_eventbase_secondary_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventrepeatsgenerator ALTER COLUMN id SET DEFAULT nextval('icekit_events_eventrepeatsgenerator_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventtype ALTER COLUMN id SET DEFAULT nextval('icekit_events_eventtype_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_occurrence ALTER COLUMN id SET DEFAULT nextval('icekit_events_occurrence_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_recurrencerule ALTER COLUMN id SET DEFAULT nextval('icekit_events_recurrencerule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout ALTER COLUMN id SET DEFAULT nextval('icekit_layout_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types ALTER COLUMN id SET DEFAULT nextval('icekit_layout_content_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_mediacategory ALTER COLUMN id SET DEFAULT nextval('icekit_mediacategory_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_contact_person_contactperson ALTER COLUMN id SET DEFAULT nextval('icekit_plugins_contact_person_contactperson_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file ALTER COLUMN id SET DEFAULT nextval('file_file_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories ALTER COLUMN id SET DEFAULT nextval('file_file_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image ALTER COLUMN id SET DEFAULT nextval('image_image_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories ALTER COLUMN id SET DEFAULT nextval('image_image_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_imagerepurposeconfig ALTER COLUMN id SET DEFAULT nextval('icekit_plugins_image_imagerepurposeconfig_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_slideshow_slideshow ALTER COLUMN id SET DEFAULT nextval('slideshow_slideshow_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease ALTER COLUMN id SET DEFAULT nextval('icekit_press_releases_pressrelease_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressreleasecategory ALTER COLUMN id SET DEFAULT nextval('icekit_press_releases_pressreleasecategory_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_workflow_workflowstate ALTER COLUMN id SET DEFAULT nextval('workflow_workflowstate_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types ALTER COLUMN id SET DEFAULT nextval('ik_event_listing_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types ALTER COLUMN id SET DEFAULT nextval('ik_todays_occurrences_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_setting ALTER COLUMN id SET DEFAULT nextval('model_settings_setting_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation ALTER COLUMN id SET DEFAULT nextval('notifications_followerinformation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers ALTER COLUMN id SET DEFAULT nextval('notifications_followerinformation_followers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers ALTER COLUMN id SET DEFAULT nextval('notifications_followerinformation_group_followers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_hasreadmessage ALTER COLUMN id SET DEFAULT nextval('notifications_hasreadmessage_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notification ALTER COLUMN id SET DEFAULT nextval('notifications_notification_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notificationsetting ALTER COLUMN id SET DEFAULT nextval('notifications_notificationsetting_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user ALTER COLUMN id SET DEFAULT nextval('polymorphic_auth_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups ALTER COLUMN id SET DEFAULT nextval('polymorphic_auth_user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('polymorphic_auth_user_user_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment ALTER COLUMN id SET DEFAULT nextval('post_office_attachment_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails ALTER COLUMN id SET DEFAULT nextval('post_office_attachment_emails_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_email ALTER COLUMN id SET DEFAULT nextval('post_office_email_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_emailtemplate ALTER COLUMN id SET DEFAULT nextval('post_office_emailtemplate_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_log ALTER COLUMN id SET DEFAULT nextval('post_office_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirectnode_redirectnode_translation ALTER COLUMN id SET DEFAULT nextval('redirectnode_redirectnode_translation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY response_pages_responsepage ALTER COLUMN id SET DEFAULT nextval('response_pages_responsepage_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_revision ALTER COLUMN id SET DEFAULT nextval('reversion_revision_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_version ALTER COLUMN id SET DEFAULT nextval('reversion_version_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent ALTER COLUMN id SET DEFAULT nextval('sharedcontent_sharedcontent_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent_translation ALTER COLUMN id SET DEFAULT nextval('sharedcontent_sharedcontent_translation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article ALTER COLUMN id SET DEFAULT nextval('test_article_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages ALTER COLUMN id SET DEFAULT nextval('test_layoutpage_with_related_related_pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_barwithlayout ALTER COLUMN id SET DEFAULT nextval('tests_barwithlayout_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_basemodel ALTER COLUMN id SET DEFAULT nextval('tests_basemodel_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_bazwithlayout ALTER COLUMN id SET DEFAULT nextval('tests_bazwithlayout_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_foowithlayout ALTER COLUMN id SET DEFAULT nextval('tests_foowithlayout_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_imagetest ALTER COLUMN id SET DEFAULT nextval('tests_imagetest_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodela ALTER COLUMN id SET DEFAULT nextval('tests_publishingm2mmodela_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb ALTER COLUMN id SET DEFAULT nextval('tests_publishingm2mmodelb_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models ALTER COLUMN id SET DEFAULT nextval('tests_publishingm2mmodelb_related_a_models_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mthroughtable ALTER COLUMN id SET DEFAULT nextval('tests_publishingm2mthroughtable_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
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

SELECT pg_catalog.setval('auth_group_id_seq', 20, true);


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
\.


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('auth_permission_id_seq', 850, true);


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
\.


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 44, true);


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_content_type (id, app_label, model) FROM stdin;
\.


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_content_type_id_seq', 302, true);


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2017-06-05 14:54:07.034166+10
2	auth	0001_initial	2017-06-05 14:54:07.185646+10
3	polymorphic_auth	0001_initial	2017-06-05 14:54:07.28138+10
4	admin	0001_initial	2017-06-05 14:54:07.344291+10
5	contenttypes	0002_remove_content_type_name	2017-06-05 14:54:07.493378+10
6	auth	0002_alter_permission_name_max_length	2017-06-05 14:54:07.527777+10
7	auth	0003_alter_user_email_max_length	2017-06-05 14:54:07.588048+10
8	auth	0004_alter_user_username_opts	2017-06-05 14:54:07.648308+10
9	auth	0005_alter_user_last_login_null	2017-06-05 14:54:07.712563+10
10	auth	0006_require_contenttypes_0002	2017-06-05 14:54:07.715773+10
11	authtoken	0001_initial	2017-06-05 14:54:07.754247+10
12	authtoken	0002_auto_20160226_1747	2017-06-05 14:54:07.956325+10
13	djcelery	0001_initial	2017-06-05 14:54:08.191983+10
14	easy_thumbnails	0001_initial	2017-06-05 14:54:08.347914+10
15	easy_thumbnails	0002_thumbnaildimensions	2017-06-05 14:54:08.399057+10
16	icekit	0001_initial	2017-06-05 14:54:08.445908+10
17	fluent_contents	0001_initial	2017-06-05 14:54:08.700909+10
18	icekit_plugins_image	0001_initial	2017-06-05 14:54:08.822592+10
19	icekit_plugins_image	0002_auto_20150527_0022	2017-06-05 14:54:08.90166+10
20	icekit_plugins_image	0003_auto_20150623_0115	2017-06-05 14:54:08.974616+10
21	icekit_plugins_image	0004_auto_20151001_2023	2017-06-05 14:54:09.099959+10
22	icekit_plugins_image	0005_imageitem_caption_override	2017-06-05 14:54:09.193414+10
23	icekit_plugins_image	0006_auto_20160309_0453	2017-06-05 14:54:09.441809+10
24	icekit_plugins_image	0007_auto_20160920_1626	2017-06-05 14:54:09.691612+10
25	icekit_plugins_image	0008_auto_20160920_2114	2017-06-05 14:54:09.824446+10
26	icekit_plugins_image	0009_auto_20161026_2044	2017-06-05 14:54:09.885826+10
27	icekit	0002_layout	2017-06-05 14:54:09.930092+10
28	icekit	0003_layout_content_types	2017-06-05 14:54:10.044989+10
29	icekit	0004_auto_20150611_2044	2017-06-05 14:54:10.19597+10
30	icekit	0005_remove_layout_key	2017-06-05 14:54:10.276381+10
31	icekit	0006_auto_20150911_0744	2017-06-05 14:54:10.365343+10
32	sites	0001_initial	2017-06-05 14:54:10.389549+10
33	fluent_pages	0001_initial	2017-06-05 14:54:11.042863+10
34	eventlistingfordate	0001_initial	2017-06-05 14:54:11.166273+10
35	eventlistingfordate	0002_auto_20161018_1113	2017-06-05 14:54:11.276624+10
36	eventlistingfordate	0003_auto_20161019_1906	2017-06-05 14:54:11.373569+10
37	eventlistingfordate	0004_auto_20161115_1118	2017-06-05 14:54:11.679561+10
38	eventlistingfordate	0005_auto_20161130_1109	2017-06-05 14:54:11.838305+10
39	eventlistingfordate	0006_auto_20170519_1345	2017-06-05 14:54:12.061836+10
40	fluentpage	0001_initial	2017-06-05 14:54:12.195252+10
41	forms	0001_initial	2017-06-05 14:54:12.740174+10
42	forms	0002_auto_20160418_0120	2017-06-05 14:54:12.890715+10
43	icekit	0007_auto_20170310_1220	2017-06-05 14:54:13.032411+10
44	icekit_article	0001_initial	2017-06-05 14:54:13.77558+10
45	icekit_article	0002_auto_20161019_1906	2017-06-05 14:54:13.949266+10
46	icekit_article	0003_auto_20161110_1125	2017-06-05 14:54:14.529299+10
47	icekit_article	0004_article_hero_image	2017-06-05 14:54:14.722264+10
48	icekit_article	0005_add_hero	2017-06-05 14:54:15.24393+10
49	icekit_article	0006_auto_20161117_1800	2017-06-05 14:54:15.595689+10
50	icekit_article	0007_auto_20161130_1109	2017-06-05 14:54:16.027941+10
51	icekit_article	0008_auto_20170518_1629	2017-06-05 14:54:16.763544+10
52	icekit_plugins_image	0010_auto_20170307_1458	2017-06-05 14:54:18.929524+10
53	icekit_plugins_image	0011_auto_20170310_1853	2017-06-05 14:54:19.386533+10
54	icekit_plugins_image	0012_imagerepurposeconfig_is_cropping_allowed	2017-06-05 14:54:19.424689+10
55	icekit_plugins_image	0013_image_is_cropping_allowed	2017-06-05 14:54:19.655003+10
56	icekit_plugins_image	0014_image_external_ref	2017-06-05 14:54:19.873644+10
57	icekit_plugins_image	0015_auto_20170310_2004	2017-06-05 14:54:20.42637+10
58	icekit_plugins_image	0016_auto_20170314_1306	2017-06-05 14:54:20.461342+10
59	icekit_plugins_image	0017_auto_20170314_1352	2017-06-05 14:54:20.50871+10
60	icekit_plugins_image	0018_auto_20170314_1401	2017-06-05 14:54:20.513778+10
61	icekit_plugins_image	0016_auto_20170316_2021	2017-06-05 14:54:20.517878+10
62	icekit_plugins_image	0019_merge	2017-06-05 14:54:20.521778+10
63	icekit_plugins_image	0020_auto_20170317_1655	2017-06-05 14:54:20.556749+10
64	icekit_authors	0001_initial	2017-06-05 14:54:20.982961+10
65	icekit_authors	0002_auto_20161011_1522	2017-06-05 14:54:21.361144+10
66	icekit_authors	0003_auto_20161115_1118	2017-06-05 14:54:21.955195+10
67	icekit_authors	0004_auto_20161117_1201	2017-06-05 14:54:22.384211+10
68	icekit_authors	0005_auto_20161117_1824	2017-06-05 14:54:22.57879+10
69	icekit_authors	0006_auto_20161117_1825	2017-06-05 14:54:22.787174+10
70	icekit_authors	0007_auto_20161125_1720	2017-06-05 14:54:23.163947+10
71	icekit_authors	0008_auto_20161128_1049	2017-06-05 14:54:23.663191+10
72	icekit_authors	0009_auto_20170317_1655	2017-06-05 14:54:24.095264+10
73	icekit_authors	0010_auto_20170317_1656	2017-06-05 14:54:24.355286+10
74	icekit_authors	0011_auto_20170518_1629	2017-06-05 14:54:25.278614+10
109	icekit_plugins_child_pages	0001_initial	2017-06-05 14:54:36.56685+10
110	icekit_plugins_child_pages	0002_auto_20160821_2140	2017-06-05 14:54:36.794667+10
111	icekit_plugins_child_pages	0003_auto_20161123_1827	2017-06-05 14:54:37.020314+10
112	icekit_plugins_contact_person	0001_initial	2017-06-05 14:54:37.380715+10
113	icekit_plugins_contact_person	0002_auto_20161110_1531	2017-06-05 14:54:37.63045+10
114	icekit_plugins_contact_person	0003_auto_20170605_1109	2017-06-05 14:54:38.338521+10
115	icekit_plugins_content_listing	0001_initial	2017-06-05 14:54:38.602417+10
116	icekit_plugins_content_listing	0002_contentlistingitem_limit	2017-06-05 14:54:38.868987+10
117	icekit_plugins_content_listing	0003_contentlistingitem_no_items_message	2017-06-05 14:54:39.124939+10
118	icekit_plugins_faq	0001_initial	2017-06-05 14:54:39.378011+10
119	icekit_plugins_faq	0002_auto_20151013_1330	2017-06-05 14:54:39.872608+10
120	icekit_plugins_faq	0003_auto_20160821_2140	2017-06-05 14:54:40.151581+10
121	icekit_plugins_file	0001_initial	2017-06-05 14:54:40.671454+10
122	icekit_plugins_file	0002_auto_20160821_2140	2017-06-05 14:54:41.587206+10
123	icekit_plugins_horizontal_rule	0001_initial	2017-06-05 14:54:41.881986+10
124	icekit_plugins_horizontal_rule	0002_auto_20160821_2140	2017-06-05 14:54:42.217552+10
125	icekit_plugins_image	0011_auto_20170310_1220	2017-06-05 14:54:42.766676+10
126	icekit_plugins_image	0021_merge	2017-06-05 14:54:43.319542+10
127	icekit_plugins_instagram_embed	0001_initial	2017-06-05 14:54:43.617863+10
128	icekit_plugins_instagram_embed	0002_auto_20150723_1939	2017-06-05 14:54:43.90961+10
129	icekit_plugins_instagram_embed	0003_auto_20150724_0213	2017-06-05 14:54:47.112988+10
130	icekit_plugins_instagram_embed	0004_auto_20160821_2140	2017-06-05 14:54:47.356274+10
131	icekit_plugins_map	0001_initial	2017-06-05 14:54:47.594156+10
132	icekit_plugins_map	0002_auto_20160821_2140	2017-06-05 14:54:47.868889+10
133	icekit_plugins_map	0003_auto_20170531_1359	2017-06-05 14:54:48.543054+10
134	icekit_plugins_map	0004_auto_20170604_2148	2017-06-05 14:54:48.86408+10
135	icekit_plugins_oembed_with_caption	0001_initial	2017-06-05 14:54:49.193816+10
136	icekit_plugins_oembed_with_caption	0002_auto_20160821_2140	2017-06-05 14:54:49.457566+10
137	icekit_plugins_oembed_with_caption	0003_oembedwithcaptionitem_is_16by9	2017-06-05 14:54:49.739828+10
138	icekit_plugins_oembed_with_caption	0004_auto_20160919_2008	2017-06-05 14:54:50.016331+10
139	icekit_plugins_oembed_with_caption	0005_auto_20161027_1711	2017-06-05 14:54:50.294767+10
140	icekit_plugins_oembed_with_caption	0006_auto_20161027_2330	2017-06-05 14:54:50.847971+10
141	icekit_plugins_oembed_with_caption	0007_auto_20161110_1513	2017-06-05 14:54:51.128816+10
142	icekit_plugins_page_anchor	0001_initial	2017-06-05 14:54:51.420139+10
143	icekit_plugins_page_anchor	0002_auto_20160821_2140	2017-06-05 14:54:51.724731+10
144	icekit_plugins_page_anchor	0003_auto_20161125_1538	2017-06-05 14:54:52.012408+10
145	icekit_plugins_page_anchor	0004_auto_20161130_0741	2017-06-05 14:54:52.296958+10
146	icekit_plugins_page_anchor_list	0001_initial	2017-06-05 14:54:52.594488+10
147	icekit_plugins_page_anchor_list	0002_auto_20160821_2140	2017-06-05 14:54:52.915241+10
148	icekit_plugins_quote	0001_initial	2017-06-05 14:54:53.222114+10
149	icekit_plugins_quote	0002_auto_20160821_2140	2017-06-05 14:54:53.543062+10
150	icekit_plugins_quote	0003_auto_20160912_2218	2017-06-05 14:54:54.093274+10
151	icekit_plugins_quote	0004_auto_20161027_1717	2017-06-05 14:54:54.667495+10
152	icekit_plugins_reusable_form	0001_initial	2017-06-05 14:54:54.981371+10
153	icekit_plugins_reusable_form	0002_auto_20160821_2140	2017-06-05 14:54:55.299021+10
154	icekit_plugins_slideshow	0001_initial	2017-06-05 14:54:55.635973+10
155	icekit_plugins_slideshow	0002_auto_20150623_0115	2017-06-05 14:54:55.955695+10
156	icekit_plugins_slideshow	0003_auto_20160404_0118	2017-06-05 14:54:57.177799+10
157	icekit_plugins_slideshow	0004_auto_20160821_2140	2017-06-05 14:54:57.924767+10
158	icekit_plugins_slideshow	0005_auto_20160927_2305	2017-06-05 14:54:58.568469+10
159	icekit_plugins_slideshow	0006_auto_20170518_1629	2017-06-05 14:54:59.198592+10
160	icekit_plugins_twitter_embed	0001_initial	2017-06-05 14:54:59.542887+10
161	icekit_plugins_twitter_embed	0002_auto_20150724_0213	2017-06-05 14:55:00.183474+10
162	icekit_plugins_twitter_embed	0003_auto_20160821_2140	2017-06-05 14:55:00.637052+10
163	icekit_workflow	0001_initial	2017-06-05 14:55:01.005748+10
164	icekit_workflow	0002_auto_20161128_1105	2017-06-05 14:55:01.365629+10
165	icekit_workflow	0003_auto_20161130_0741	2017-06-05 14:55:01.698655+10
166	icekit_workflow	0004_auto_20170130_1146	2017-06-05 14:55:02.055229+10
167	icekit_workflow	0005_auto_20170208_1146	2017-06-05 14:55:02.433935+10
168	icekit_workflow	0006_auto_20170308_2044	2017-06-05 14:55:03.092686+10
169	iframe	0001_initial	2017-06-05 14:55:03.431524+10
170	ik_event_listing	0001_initial	2017-06-05 14:55:03.795315+10
175	ik_links	0001_initial	2017-06-05 14:55:09.943404+10
176	ik_links	0002_auto_20161117_1221	2017-06-05 14:55:10.987212+10
177	ik_links	0003_auto_20161117_1810	2017-06-05 14:55:12.062238+10
178	ik_links	0004_auto_20170314_1401	2017-06-05 14:55:13.099231+10
179	ik_links	0004_auto_20170306_1529	2017-06-05 14:55:14.146886+10
180	ik_links	0005_auto_20170511_1909	2017-06-05 14:55:15.201566+10
181	ik_links	0006_authorlink_exclude_from_contributions	2017-06-05 14:55:15.580818+10
182	image_gallery	0001_initial	2017-06-05 14:55:15.951126+10
183	image_gallery	0002_auto_20160927_2305	2017-06-05 14:55:16.390023+10
184	kombu_transport_django	0001_initial	2017-06-05 14:55:16.538037+10
185	layout_page	0001_initial	2017-06-05 14:55:16.946567+10
186	layout_page	0002_auto_20160419_2209	2017-06-05 14:55:18.440961+10
187	layout_page	0003_auto_20160810_1856	2017-06-05 14:55:18.826777+10
188	layout_page	0004_auto_20161110_1737	2017-06-05 14:55:20.024052+10
189	layout_page	0005_auto_20161125_1709	2017-06-05 14:55:20.429533+10
190	layout_page	0006_auto_20161130_1109	2017-06-05 14:55:20.866066+10
191	layout_page	0007_auto_20170509_1148	2017-06-05 14:55:21.248367+10
192	layout_page	0008_auto_20170518_1629	2017-06-05 14:55:22.029198+10
193	model_settings	0001_initial	2017-06-05 14:55:24.894408+10
194	model_settings	0002_auto_20150810_1620	2017-06-05 14:55:25.292311+10
195	notifications	0001_initial	2017-06-05 14:55:27.902608+10
196	notifications	0002_auto_20150901_2126	2017-06-05 14:55:28.877239+10
197	oembeditem	0001_initial	2017-06-05 14:55:29.358518+10
198	polymorphic_auth	0002_auto_20160725_2124	2017-06-05 14:55:30.380877+10
199	polymorphic_auth_email	0001_initial	2017-06-05 14:55:30.853112+10
200	post_office	0001_initial	2017-06-05 14:55:31.166366+10
201	post_office	0002_add_i18n_and_backend_alias	2017-06-05 14:55:32.135342+10
202	post_office	0003_longer_subject	2017-06-05 14:55:32.287189+10
203	post_office	0004_auto_20160607_0901	2017-06-05 14:55:33.771457+10
204	rawhtml	0001_initial	2017-06-05 14:55:34.267678+10
205	redirectnode	0001_initial	2017-06-05 14:55:35.681726+10
206	redirects	0001_initial	2017-06-05 14:55:36.180872+10
207	response_pages	0001_initial	2017-06-05 14:55:36.237227+10
208	reversion	0001_initial	2017-06-05 14:55:37.302322+10
209	reversion	0002_auto_20141216_1509	2017-06-05 14:55:37.882918+10
210	search_page	0001_initial	2017-06-05 14:55:38.413757+10
211	search_page	0002_auto_20160420_0029	2017-06-05 14:55:42.057061+10
212	search_page	0003_auto_20160810_1856	2017-06-05 14:55:42.559162+10
213	search_page	0004_auto_20161122_2121	2017-06-05 14:55:43.626768+10
214	search_page	0005_auto_20161125_1720	2017-06-05 14:55:44.631637+10
215	search_page	0006_searchpage_default_search_type	2017-06-05 14:55:45.181416+10
216	search_page	0007_auto_20170518_1629	2017-06-05 14:55:46.189525+10
217	sessions	0001_initial	2017-06-05 14:55:46.252574+10
218	sharedcontent	0001_initial	2017-06-05 14:55:49.113183+10
219	tests	0001_initial	2017-06-05 14:55:50.947052+10
220	tests	0002_unpublishablelayoutpage	2017-06-05 14:55:51.529541+10
221	tests	0003_auto_20160810_2054	2017-06-05 14:55:52.776326+10
222	tests	0004_auto_20160925_0758	2017-06-05 14:55:54.022025+10
223	tests	0005_auto_20161027_1428	2017-06-05 14:55:54.353994+10
224	tests	0006_auto_20161115_1219	2017-06-05 14:55:58.233807+10
225	tests	0007_auto_20161118_1044	2017-06-05 14:56:01.297152+10
226	tests	0008_auto_20161204_1456	2017-06-05 14:56:03.219368+10
227	tests	0009_auto_20170519_1232	2017-06-05 14:56:05.585588+10
228	tests	0010_auto_20170522_1600	2017-06-05 14:56:07.001775+10
229	text	0001_initial	2017-06-05 14:56:07.61005+10
230	text	0002_textitem_style	2017-06-05 14:56:08.256801+10
231	textfile	0001_initial	2017-06-05 14:56:08.835471+10
232	textfile	0002_add_translation_model	2017-06-05 14:56:10.035825+10
233	textfile	0003_migrate_translatable_fields	2017-06-05 14:56:10.090849+10
234	textfile	0004_remove_untranslated_fields	2017-06-05 14:56:10.768456+10
235	icekit_events	0001_initial	2017-06-05 16:01:42.572645+10
236	icekit_events	0002_recurrence_rules	2017-06-05 16:01:42.627627+10
237	icekit_events	0003_auto_20161021_1658	2017-06-05 16:01:42.767139+10
238	icekit_events	0004_eventbase_part_of	2017-06-05 16:01:42.919972+10
239	icekit_events	0005_auto_20161024_1742	2017-06-05 16:01:43.249996+10
240	icekit_events	0006_auto_20161107_1747	2017-06-05 16:01:43.777606+10
241	icekit_events	0007_type_fixtures	2017-06-05 16:01:43.804937+10
242	icekit_events	0008_occurrence_external_ref	2017-06-05 16:01:43.93986+10
243	icekit_events	0009_auto_20161125_1538	2017-06-05 16:01:44.211871+10
244	icekit_events	0010_eventbase_is_drop_in	2017-06-05 16:01:44.365739+10
245	icekit_events	0011_auto_20161128_1049	2017-06-05 16:01:45.197848+10
246	icekit_events	0012_occurrence_status	2017-06-05 16:01:45.327592+10
247	icekit_events	0012_eventtype_title_plural	2017-06-05 16:01:45.469336+10
248	icekit_events	0013_merge	2017-06-05 16:01:45.47485+10
249	icekit_events	0014_eventbase_human_times	2017-06-05 16:01:45.861171+10
250	icekit_events	0015_auto_20161208_0029	2017-06-05 16:01:45.993082+10
251	icekit_events	0016_auto_20161208_0030	2017-06-05 16:01:46.128853+10
252	icekit_events	0017_eventtype_color	2017-06-05 16:01:46.262329+10
253	icekit_events	0018_auto_20170307_1458	2017-06-05 16:01:46.389485+10
254	icekit_events	0019_auto_20170310_1220	2017-06-05 16:01:46.932228+10
255	icekit_events	0020_auto_20170317_1341	2017-06-05 16:01:47.164513+10
256	icekit_events	0018_auto_20170314_1401	2017-06-05 16:01:47.305418+10
257	icekit_events	0021_merge	2017-06-05 16:01:47.309229+10
258	icekit_events	0022_auto_20170320_1807	2017-06-05 16:01:47.781612+10
259	icekit_events	0023_auto_20170320_1820	2017-06-05 16:01:48.273053+10
260	icekit_events	0024_auto_20170320_1824	2017-06-05 16:01:48.39526+10
261	icekit_events	0025_auto_20170519_1327	2017-06-05 16:01:48.690324+10
262	icekit_event_types_simple	0001_initial	2017-06-05 16:04:32.822898+10
263	icekit_event_types_simple	0002_simpleevent_layout	2017-06-05 16:04:32.992105+10
264	icekit_event_types_simple	0003_auto_20161125_1701	2017-06-05 16:04:33.172207+10
265	icekit_events_links	0001_initial	2017-06-05 16:04:33.330768+10
266	icekit_events_links	0002_auto_20170314_1401	2017-06-05 16:04:33.4836+10
267	icekit_events_links	0003_auto_20170511_1909	2017-06-05 16:04:33.641878+10
268	icekit_events_links	0004_eventlink_include_even_when_finished	2017-06-05 16:04:33.805564+10
269	ik_event_listing	0002_auto_20170222_1136	2017-06-05 16:04:35.004682+10
270	ik_event_listing	0003_eventcontentlistingitem_no_items_message	2017-06-05 16:04:35.232442+10
271	ik_events_todays_occurrences	0001_initial	2017-06-05 16:04:35.487443+10
272	ik_events_todays_occurrences	0002_auto_20161207_1928	2017-06-05 16:04:35.939139+10
273	gk_collections_work_creator	0001_initial	2017-06-08 10:29:30.647526+10
274	gk_collections_work_creator	0002_workbase_department	2017-06-08 10:29:30.794464+10
275	gk_collections_work_creator	0003_auto_20161026_1606	2017-06-08 10:29:31.029523+10
276	gk_collections_work_creator	0004_auto_20161026_1828	2017-06-08 10:29:32.242528+10
277	gk_collections_work_creator	0005_workbase_images	2017-06-08 10:29:32.367009+10
278	gk_collections_work_creator	0006_auto_20161026_2259	2017-06-08 10:29:32.637415+10
279	gk_collections_work_creator	0007_auto_20161028_1904	2017-06-08 10:29:32.764507+10
280	gk_collections_work_creator	0008_auto_20161114_1240	2017-06-08 10:29:32.992307+10
281	gk_collections_links	0001_initial	2017-06-08 10:29:33.26062+10
282	gk_collections_links	0002_auto_20161117_1810	2017-06-08 10:29:33.523343+10
283	glamkit_collections	0001_initial	2017-06-08 10:29:33.594231+10
284	glamkit_collections	0002_auto_20170412_1520	2017-06-08 10:29:34.078788+10
285	glamkit_collections	0003_auto_20170412_1742	2017-06-08 10:29:34.151333+10
286	gk_collections_work_creator	0009_auto_20161117_1757	2017-06-08 10:29:34.284459+10
287	gk_collections_work_creator	0010_auto_20161128_1049	2017-06-08 10:29:34.772216+10
288	gk_collections_work_creator	0011_role_title_plural	2017-06-08 10:29:34.914764+10
289	gk_collections_work_creator	0012_auto_20170412_1744	2017-06-08 10:29:35.127713+10
290	gk_collections_work_creator	0013_auto_20170412_1724	2017-06-08 10:29:35.152561+10
291	gk_collections_work_creator	0014_auto_20170412_1745	2017-06-08 10:29:35.947213+10
292	gk_collections_work_creator	0015_auto_20170412_1816	2017-06-08 10:29:36.108685+10
293	gk_collections_work_creator	0016_auto_20170412_2338	2017-06-08 10:29:36.247483+10
294	gk_collections_work_creator	0017_workbase_origin_locations	2017-06-08 10:29:36.391996+10
295	gk_collections_work_creator	0018_workbase_external_ref	2017-06-08 10:29:36.539734+10
296	gk_collections_work_creator	0019_auto_20170515_2004	2017-06-08 10:29:36.683537+10
297	gk_collections_work_creator	0020_auto_20170518_2017	2017-06-08 10:29:38.004383+10
298	gk_collections_work_creator	0021_auto_20170518_2023	2017-06-08 10:29:39.27241+10
299	gk_collections_work_creator	0022_auto_20170518_2034	2017-06-08 10:29:41.060553+10
300	gk_collections_work_creator	0023_auto_20170522_1508	2017-06-08 10:29:41.943718+10
301	gk_collections_work_creator	0024_auto_20170502_2209	2017-06-08 10:29:42.211059+10
302	gk_collections_work_creator	0025_creatorbase_name_full	2017-06-08 10:29:42.375091+10
303	gk_collections_work_creator	0026_auto_20170516_1518	2017-06-08 10:29:43.279519+10
304	gk_collections_work_creator	0027_auto_20170518_1611	2017-06-08 10:29:43.436025+10
305	gk_collections_work_creator	0028_auto_20170523_1141	2017-06-08 10:29:43.583452+10
306	gk_collections_work_creator	0029_auto_20170523_1149	2017-06-08 10:29:43.858526+10
307	gk_collections_work_creator	0030_auto_20170523_1243	2017-06-08 10:29:45.025567+10
308	gk_collections_work_creator	0031_auto_20170606_1126	2017-06-08 10:29:50.142338+10
309	glamkit_collections	0004_geographiclocation_slug	2017-06-08 10:29:50.898466+10
310	glamkit_sponsors	0001_initial	2017-06-08 10:29:51.060392+10
311	glamkit_sponsors	0002_beginsponsorblockitem_endsponsorblockitem_sponsorpromoitem	2017-06-08 10:29:51.519477+10
312	icekit_press_releases	0001_initial	2017-06-08 10:29:53.228903+10
313	icekit_press_releases	0002_auto_20160810_1832	2017-06-08 10:29:54.495312+10
314	icekit_press_releases	0003_auto_20160810_1856	2017-06-08 10:29:55.995924+10
315	icekit_press_releases	0004_auto_20160926_2341	2017-06-08 10:29:56.297935+10
316	icekit_press_releases	0005_auto_20161110_1531	2017-06-08 10:29:56.991755+10
317	icekit_press_releases	0006_auto_20161115_1118	2017-06-08 10:29:57.934558+10
318	icekit_press_releases	0007_auto_20161117_1201	2017-06-08 10:29:58.546565+10
319	icekit_press_releases	0008_auto_20161128_1049	2017-06-08 10:29:58.869652+10
320	icekit_press_releases	0009_auto_20170519_1308	2017-06-08 10:29:59.5589+10
\.


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_migrations_id_seq', 320, true);


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

SELECT pg_catalog.setval('easy_thumbnails_source_id_seq', 2, true);


--
-- Data for Name: easy_thumbnails_thumbnail; Type: TABLE DATA; Schema: public; Owner: -
--

COPY easy_thumbnails_thumbnail (id, storage_hash, name, modified, source_id) FROM stdin;
\.


--
-- Name: easy_thumbnails_thumbnail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('easy_thumbnails_thumbnail_id_seq', 4, true);


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

SELECT pg_catalog.setval('file_file_id_seq', 12, true);


--
-- Data for Name: fluent_contents_contentitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_contents_contentitem (id, parent_id, language_code, sort_order, parent_type_id, placeholder_id, polymorphic_ctype_id) FROM stdin;
\.


--
-- Name: fluent_contents_contentitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_contents_contentitem_id_seq', 370, true);


--
-- Data for Name: fluent_contents_placeholder; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_contents_placeholder (id, slot, role, parent_id, title, parent_type_id) FROM stdin;
\.


--
-- Name: fluent_contents_placeholder_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_contents_placeholder_id_seq', 180, true);


--
-- Data for Name: fluent_pages_htmlpage_translation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_pages_htmlpage_translation (id, language_code, meta_keywords, meta_description, meta_title, master_id) FROM stdin;
\.


--
-- Name: fluent_pages_htmlpage_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_pages_htmlpage_translation_id_seq', 316, true);


--
-- Data for Name: fluent_pages_pagelayout; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_pages_pagelayout (id, key, title, template_path) FROM stdin;
\.


--
-- Name: fluent_pages_pagelayout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_pages_pagelayout_id_seq', 28, true);


--
-- Data for Name: fluent_pages_urlnode; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_pages_urlnode (id, lft, rght, tree_id, level, status, publication_date, publication_end_date, in_navigation, in_sitemaps, key, creation_date, modification_date, author_id, parent_id, parent_site_id, polymorphic_ctype_id) FROM stdin;
\.


--
-- Name: fluent_pages_urlnode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_pages_urlnode_id_seq', 362, true);


--
-- Data for Name: fluent_pages_urlnode_translation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_pages_urlnode_translation (id, language_code, title, slug, override_url, _cached_url, master_id) FROM stdin;
\.


--
-- Name: fluent_pages_urlnode_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_pages_urlnode_translation_id_seq', 340, true);


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

SELECT pg_catalog.setval('forms_form_id_seq', 18, true);


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
-- Data for Name: gk_collections_work_creator_creatorbase; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gk_collections_work_creator_creatorbase (id, list_image, boosted_search_terms, publishing_is_draft, publishing_modified_at, publishing_published_at, name_display, slug, alt_slug, website, wikipedia_link, admin_notes, name_sort, layout_id, polymorphic_ctype_id, portrait_id, publishing_linked_id, name_full, dt_created, dt_modified, external_ref, brief, end_date_display, end_date_earliest, end_date_edtf, end_date_latest, end_date_sort_ascending, end_date_sort_descending, start_date_display, start_date_earliest, start_date_edtf, start_date_latest, start_date_sort_ascending, start_date_sort_descending) FROM stdin;
\.


--
-- Name: gk_collections_work_creator_creatorbase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gk_collections_work_creator_creatorbase_id_seq', 1, false);


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

SELECT pg_catalog.setval('icekit_article_article_id_seq', 6, true);


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

SELECT pg_catalog.setval('icekit_authors_author_id_seq', 8, true);


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

SELECT pg_catalog.setval('icekit_events_eventbase_id_seq', 40, true);


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

SELECT pg_catalog.setval('icekit_events_eventrepeatsgenerator_id_seq', 23, true);


--
-- Data for Name: icekit_events_eventtype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_events_eventtype (id, title, slug, is_public, title_plural, color) FROM stdin;
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

SELECT pg_catalog.setval('icekit_events_occurrence_id_seq', 1578, true);


--
-- Data for Name: icekit_events_recurrencerule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_events_recurrencerule (id, created, modified, description, recurrence_rule) FROM stdin;
\.


--
-- Name: icekit_events_recurrencerule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_events_recurrencerule_id_seq', 7, true);


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

SELECT pg_catalog.setval('icekit_layout_content_types_id_seq', 131, true);


--
-- Name: icekit_layout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_layout_id_seq', 159, true);


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

SELECT pg_catalog.setval('icekit_mediacategory_id_seq', 8, true);


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
-- Data for Name: icekit_press_releases_pressrelease; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_press_releases_pressrelease (id, publishing_is_draft, publishing_modified_at, publishing_published_at, title, slug, print_version, created, modified, released, category_id, layout_id, publishing_linked_id, boosted_search_terms, list_image) FROM stdin;
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

SELECT pg_catalog.setval('image_image_id_seq', 68, true);


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

SELECT pg_catalog.setval('model_settings_setting_id_seq', 22, true);


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
\.


--
-- Name: notifications_notificationsetting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifications_notificationsetting_id_seq', 277, true);


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
\.


--
-- Data for Name: polymorphic_auth_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY polymorphic_auth_user (id, password, last_login, is_superuser, is_staff, is_active, first_name, last_name, created, polymorphic_ctype_id) FROM stdin;
\.


--
-- Data for Name: polymorphic_auth_user_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY polymorphic_auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Name: polymorphic_auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('polymorphic_auth_user_groups_id_seq', 20, true);


--
-- Name: polymorphic_auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('polymorphic_auth_user_id_seq', 459, true);


--
-- Data for Name: polymorphic_auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY polymorphic_auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Name: polymorphic_auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('polymorphic_auth_user_user_permissions_id_seq', 38, true);


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

SELECT pg_catalog.setval('response_pages_responsepage_id_seq', 16, true);


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

SELECT pg_catalog.setval('slideshow_slideshow_id_seq', 104, true);


--
-- Data for Name: test_article; Type: TABLE DATA; Schema: public; Owner: -
--

COPY test_article (id, publishing_is_draft, publishing_modified_at, publishing_published_at, title, slug, layout_id, publishing_linked_id, parent_id, boosted_search_terms, list_image) FROM stdin;
\.


--
-- Name: test_article_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('test_article_id_seq', 42, true);


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

SELECT pg_catalog.setval('test_layoutpage_with_related_related_pages_id_seq', 2, true);


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

SELECT pg_catalog.setval('tests_basemodel_id_seq', 2, true);


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

SELECT pg_catalog.setval('tests_imagetest_id_seq', 4, true);


--
-- Data for Name: tests_publishingm2mmodela; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_publishingm2mmodela (id, publishing_is_draft, publishing_modified_at, publishing_published_at, publishing_linked_id) FROM stdin;
\.


--
-- Name: tests_publishingm2mmodela_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_publishingm2mmodela_id_seq', 8, true);


--
-- Data for Name: tests_publishingm2mmodelb; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_publishingm2mmodelb (id, publishing_is_draft, publishing_modified_at, publishing_published_at, publishing_linked_id) FROM stdin;
\.


--
-- Name: tests_publishingm2mmodelb_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_publishingm2mmodelb_id_seq', 4, true);


--
-- Data for Name: tests_publishingm2mmodelb_related_a_models; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_publishingm2mmodelb_related_a_models (id, publishingm2mmodelb_id, publishingm2mmodela_id) FROM stdin;
\.


--
-- Name: tests_publishingm2mmodelb_related_a_models_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_publishingm2mmodelb_related_a_models_id_seq', 10, true);


--
-- Data for Name: tests_publishingm2mthroughtable; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_publishingm2mthroughtable (id, a_model_id, b_model_id) FROM stdin;
\.


--
-- Name: tests_publishingm2mthroughtable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_publishingm2mthroughtable_id_seq', 8, true);


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

SELECT pg_catalog.setval('workflow_workflowstate_id_seq', 24, true);


--
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions_group_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_key UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission_content_type_id_codename_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_key UNIQUE (content_type_id, codename);


--
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: authtoken_token_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY authtoken_token
    ADD CONSTRAINT authtoken_token_pkey PRIMARY KEY (key);


--
-- Name: authtoken_token_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_key UNIQUE (user_id);


--
-- Name: celery_taskmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_taskmeta
    ADD CONSTRAINT celery_taskmeta_pkey PRIMARY KEY (id);


--
-- Name: celery_taskmeta_task_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_taskmeta
    ADD CONSTRAINT celery_taskmeta_task_id_key UNIQUE (task_id);


--
-- Name: celery_tasksetmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_tasksetmeta
    ADD CONSTRAINT celery_tasksetmeta_pkey PRIMARY KEY (id);


--
-- Name: celery_tasksetmeta_taskset_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_tasksetmeta
    ADD CONSTRAINT celery_tasksetmeta_taskset_id_key UNIQUE (taskset_id);


--
-- Name: contentitem_child_pages_childpageitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_child_pages_childpageitem
    ADD CONSTRAINT contentitem_child_pages_childpageitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_faq_faqitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_faq_faqitem
    ADD CONSTRAINT contentitem_faq_faqitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_file_fileitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_file_fileitem
    ADD CONSTRAINT contentitem_file_fileitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_gk_collections_links_creatorlink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_gk_collections_links_creatorlink
    ADD CONSTRAINT contentitem_gk_collections_links_creatorlink_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_gk_collections_links_worklink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_gk_collections_links_worklink
    ADD CONSTRAINT contentitem_gk_collections_links_worklink_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_glamkit_sponsors_beginsponsorblockitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_beginsponsorblockitem
    ADD CONSTRAINT contentitem_glamkit_sponsors_beginsponsorblockitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_glamkit_sponsors_endsponsorblockitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_endsponsorblockitem
    ADD CONSTRAINT contentitem_glamkit_sponsors_endsponsorblockitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_glamkit_sponsors_sponsorpromoitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_sponsorpromoitem
    ADD CONSTRAINT contentitem_glamkit_sponsors_sponsorpromoitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_horizontal_rule_horizontalruleitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_horizontal_rule_horizontalruleitem
    ADD CONSTRAINT contentitem_horizontal_rule_horizontalruleitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_events_links_eventlink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_events_links_eventlink
    ADD CONSTRAINT contentitem_icekit_events_links_eventlink_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_contact_person_contactpersonite_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_contact_person_contactpersonitem
    ADD CONSTRAINT contentitem_icekit_plugins_contact_person_contactpersonite_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_icekit_plugins_content_listing_contentlistingi_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_content_listing_contentlistingitem
    ADD CONSTRAINT contentitem_icekit_plugins_content_listing_contentlistingi_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_iframe_iframeitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_iframe_iframeitem
    ADD CONSTRAINT contentitem_iframe_iframeitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_ik_event_listing_eventcontentlistingitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_event_listing_eventcontentlistingitem
    ADD CONSTRAINT contentitem_ik_event_listing_eventcontentlistingitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_ik_events_todays_occurrences_todaysoccurrences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_events_todays_occurrences_todaysoccurrences
    ADD CONSTRAINT contentitem_ik_events_todays_occurrences_todaysoccurrences_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_ik_links_articlelink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_articlelink
    ADD CONSTRAINT contentitem_ik_links_articlelink_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_ik_links_authorlink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_authorlink
    ADD CONSTRAINT contentitem_ik_links_authorlink_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_ik_links_pagelink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_pagelink
    ADD CONSTRAINT contentitem_ik_links_pagelink_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_image_gallery_imagegalleryshowitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_image_gallery_imagegalleryshowitem
    ADD CONSTRAINT contentitem_image_gallery_imagegalleryshowitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_image_imageitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_image_imageitem
    ADD CONSTRAINT contentitem_image_imageitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_instagram_embed_instagramembeditem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_instagram_embed_instagramembeditem
    ADD CONSTRAINT contentitem_instagram_embed_instagramembeditem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_map_mapitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_map_mapitem
    ADD CONSTRAINT contentitem_map_mapitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_oembed_with_caption_oembedwithcaptionitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_oembed_with_caption_item
    ADD CONSTRAINT contentitem_oembed_with_caption_oembedwithcaptionitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_oembeditem_oembeditem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_oembeditem_oembeditem
    ADD CONSTRAINT contentitem_oembeditem_oembeditem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_page_anchor_list_pageanchorlistitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem
    ADD CONSTRAINT contentitem_page_anchor_list_pageanchorlistitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_page_anchor_pageanchoritem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_page_anchor_pageanchoritem
    ADD CONSTRAINT contentitem_page_anchor_pageanchoritem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_quote_quoteitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_quote_quoteitem
    ADD CONSTRAINT contentitem_quote_quoteitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_rawhtml_rawhtmlitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_rawhtml_rawhtmlitem
    ADD CONSTRAINT contentitem_rawhtml_rawhtmlitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_reusable_form_formitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_reusable_form_formitem
    ADD CONSTRAINT contentitem_reusable_form_formitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_sharedcontent_sharedcontentitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_sharedcontent_sharedcontentitem
    ADD CONSTRAINT contentitem_sharedcontent_sharedcontentitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_slideshow_slideshowitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_slideshow_slideshowitem
    ADD CONSTRAINT contentitem_slideshow_slideshowitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_text_textitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_text_textitem
    ADD CONSTRAINT contentitem_text_textitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: contentitem_twitter_embed_twitterembeditem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_twitter_embed_twitterembeditem
    ADD CONSTRAINT contentitem_twitter_embed_twitterembeditem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- Name: django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type_app_label_2ca6b82262765616_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_2ca6b82262765616_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_redirect_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_redirect
    ADD CONSTRAINT django_redirect_pkey PRIMARY KEY (id);


--
-- Name: django_redirect_site_id_old_path_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_redirect
    ADD CONSTRAINT django_redirect_site_id_old_path_key UNIQUE (site_id, old_path);


--
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: djcelery_crontabschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_crontabschedule
    ADD CONSTRAINT djcelery_crontabschedule_pkey PRIMARY KEY (id);


--
-- Name: djcelery_intervalschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_intervalschedule
    ADD CONSTRAINT djcelery_intervalschedule_pkey PRIMARY KEY (id);


--
-- Name: djcelery_periodictask_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT djcelery_periodictask_name_key UNIQUE (name);


--
-- Name: djcelery_periodictask_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT djcelery_periodictask_pkey PRIMARY KEY (id);


--
-- Name: djcelery_periodictasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictasks
    ADD CONSTRAINT djcelery_periodictasks_pkey PRIMARY KEY (ident);


--
-- Name: djcelery_taskstate_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_taskstate
    ADD CONSTRAINT djcelery_taskstate_pkey PRIMARY KEY (id);


--
-- Name: djcelery_taskstate_task_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_taskstate
    ADD CONSTRAINT djcelery_taskstate_task_id_key UNIQUE (task_id);


--
-- Name: djcelery_workerstate_hostname_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_workerstate
    ADD CONSTRAINT djcelery_workerstate_hostname_key UNIQUE (hostname);


--
-- Name: djcelery_workerstate_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_workerstate
    ADD CONSTRAINT djcelery_workerstate_pkey PRIMARY KEY (id);


--
-- Name: djkombu_message_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_message
    ADD CONSTRAINT djkombu_message_pkey PRIMARY KEY (id);


--
-- Name: djkombu_queue_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_queue
    ADD CONSTRAINT djkombu_queue_name_key UNIQUE (name);


--
-- Name: djkombu_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_queue
    ADD CONSTRAINT djkombu_queue_pkey PRIMARY KEY (id);


--
-- Name: easy_thumbnails_source_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_source
    ADD CONSTRAINT easy_thumbnails_source_pkey PRIMARY KEY (id);


--
-- Name: easy_thumbnails_source_storage_hash_7bd609ca10204665_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_source
    ADD CONSTRAINT easy_thumbnails_source_storage_hash_7bd609ca10204665_uniq UNIQUE (storage_hash, name);


--
-- Name: easy_thumbnails_thumbnail_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnail
    ADD CONSTRAINT easy_thumbnails_thumbnail_pkey PRIMARY KEY (id);


--
-- Name: easy_thumbnails_thumbnail_storage_hash_7bdb30671e8cf370_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnail
    ADD CONSTRAINT easy_thumbnails_thumbnail_storage_hash_7bdb30671e8cf370_uniq UNIQUE (storage_hash, name, source_id);


--
-- Name: easy_thumbnails_thumbnaildimensions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnaildimensions
    ADD CONSTRAINT easy_thumbnails_thumbnaildimensions_pkey PRIMARY KEY (id);


--
-- Name: easy_thumbnails_thumbnaildimensions_thumbnail_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnaildimensions
    ADD CONSTRAINT easy_thumbnails_thumbnaildimensions_thumbnail_id_key UNIQUE (thumbnail_id);


--
-- Name: file_file_categories_file_id_mediacategory_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories
    ADD CONSTRAINT file_file_categories_file_id_mediacategory_id_key UNIQUE (file_id, mediacategory_id);


--
-- Name: file_file_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories
    ADD CONSTRAINT file_file_categories_pkey PRIMARY KEY (id);


--
-- Name: file_file_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file
    ADD CONSTRAINT file_file_pkey PRIMARY KEY (id);


--
-- Name: fluent_contents_contentitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem
    ADD CONSTRAINT fluent_contents_contentitem_pkey PRIMARY KEY (id);


--
-- Name: fluent_contents_placeholde_parent_type_id_240ea1f478ca3e6b_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_placeholder
    ADD CONSTRAINT fluent_contents_placeholde_parent_type_id_240ea1f478ca3e6b_uniq UNIQUE (parent_type_id, parent_id, slot);


--
-- Name: fluent_contents_placeholder_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_placeholder
    ADD CONSTRAINT fluent_contents_placeholder_pkey PRIMARY KEY (id);


--
-- Name: fluent_pages_htmlpage_trans_language_code_131e0dc167dc6f87_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_htmlpage_translation
    ADD CONSTRAINT fluent_pages_htmlpage_trans_language_code_131e0dc167dc6f87_uniq UNIQUE (language_code, master_id);


--
-- Name: fluent_pages_htmlpage_translation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_htmlpage_translation
    ADD CONSTRAINT fluent_pages_htmlpage_translation_pkey PRIMARY KEY (id);


--
-- Name: fluent_pages_pagelayout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_pagelayout
    ADD CONSTRAINT fluent_pages_pagelayout_pkey PRIMARY KEY (id);


--
-- Name: fluent_pages_urlnode_parent_site_id_4c49e5100e5e7157_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_pages_urlnode_parent_site_id_4c49e5100e5e7157_uniq UNIQUE (parent_site_id, key);


--
-- Name: fluent_pages_urlnode_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_pages_urlnode_pkey PRIMARY KEY (id);


--
-- Name: fluent_pages_urlnode_transl_language_code_53a0fa1d022b99a5_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode_translation
    ADD CONSTRAINT fluent_pages_urlnode_transl_language_code_53a0fa1d022b99a5_uniq UNIQUE (language_code, master_id);


--
-- Name: fluent_pages_urlnode_translation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode_translation
    ADD CONSTRAINT fluent_pages_urlnode_translation_pkey PRIMARY KEY (id);


--
-- Name: forms_field_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_field
    ADD CONSTRAINT forms_field_pkey PRIMARY KEY (id);


--
-- Name: forms_fieldentry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_fieldentry
    ADD CONSTRAINT forms_fieldentry_pkey PRIMARY KEY (id);


--
-- Name: forms_form_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form
    ADD CONSTRAINT forms_form_pkey PRIMARY KEY (id);


--
-- Name: forms_form_sites_form_id_site_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites
    ADD CONSTRAINT forms_form_sites_form_id_site_id_key UNIQUE (form_id, site_id);


--
-- Name: forms_form_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites
    ADD CONSTRAINT forms_form_sites_pkey PRIMARY KEY (id);


--
-- Name: forms_form_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form
    ADD CONSTRAINT forms_form_slug_key UNIQUE (slug);


--
-- Name: forms_formentry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_formentry
    ADD CONSTRAINT forms_formentry_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_work_creator_creatorb_slug_7a6d855197c5c186_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_creatorbase
    ADD CONSTRAINT gk_collections_work_creator_creatorb_slug_7a6d855197c5c186_uniq UNIQUE (slug, publishing_is_draft);


--
-- Name: gk_collections_work_creator_creatorbas_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_creatorbase
    ADD CONSTRAINT gk_collections_work_creator_creatorbas_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: gk_collections_work_creator_creatorbase_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_creatorbase
    ADD CONSTRAINT gk_collections_work_creator_creatorbase_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_work_creator_role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_role
    ADD CONSTRAINT gk_collections_work_creator_role_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_work_creator_wo_creator_id_6dfd87e0fc297eb8_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workcreator
    ADD CONSTRAINT gk_collections_work_creator_wo_creator_id_6dfd87e0fc297eb8_uniq UNIQUE (creator_id, work_id, role_id);


--
-- Name: gk_collections_work_creator_workbase_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workbase
    ADD CONSTRAINT gk_collections_work_creator_workbase_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_work_creator_workbase_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workbase
    ADD CONSTRAINT gk_collections_work_creator_workbase_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: gk_collections_work_creator_workbase_slug_39e0629f4594a876_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workbase
    ADD CONSTRAINT gk_collections_work_creator_workbase_slug_39e0629f4594a876_uniq UNIQUE (slug, publishing_is_draft);


--
-- Name: gk_collections_work_creator_workcreator_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workcreator
    ADD CONSTRAINT gk_collections_work_creator_workcreator_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_work_creator_workimage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workimage
    ADD CONSTRAINT gk_collections_work_creator_workimage_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_work_creator_workimagetype_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workimagetype
    ADD CONSTRAINT gk_collections_work_creator_workimagetype_pkey PRIMARY KEY (id);


--
-- Name: gk_collections_work_creator_workorigin_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workorigin
    ADD CONSTRAINT gk_collections_work_creator_workorigin_pkey PRIMARY KEY (id);


--
-- Name: glamkit_collections_country_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_collections_country
    ADD CONSTRAINT glamkit_collections_country_pkey PRIMARY KEY (id);


--
-- Name: glamkit_collections_geographiclocation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_collections_geographiclocation
    ADD CONSTRAINT glamkit_collections_geographiclocation_pkey PRIMARY KEY (id);


--
-- Name: glamkit_sponsors_sponsor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_sponsors_sponsor
    ADD CONSTRAINT glamkit_sponsors_sponsor_pkey PRIMARY KEY (id);


--
-- Name: icekit_article_article_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT icekit_article_article_pkey PRIMARY KEY (id);


--
-- Name: icekit_article_article_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT icekit_article_article_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: icekit_article_article_slug_25a9422bfa087bcf_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT icekit_article_article_slug_25a9422bfa087bcf_uniq UNIQUE (slug, parent_id, publishing_linked_id);


--
-- Name: icekit_authors_author_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author
    ADD CONSTRAINT icekit_authors_author_pkey PRIMARY KEY (id);


--
-- Name: icekit_authors_author_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author
    ADD CONSTRAINT icekit_authors_author_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: icekit_event_types_simple_simpleevent_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_event_types_simple_simpleevent
    ADD CONSTRAINT icekit_event_types_simple_simpleevent_pkey PRIMARY KEY (eventbase_ptr_id);


--
-- Name: icekit_events_eventbase_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT icekit_events_eventbase_pkey PRIMARY KEY (id);


--
-- Name: icekit_events_eventbase_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT icekit_events_eventbase_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: icekit_events_eventbase_secondary_eventbase_id_eventtype_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types
    ADD CONSTRAINT icekit_events_eventbase_secondary_eventbase_id_eventtype_id_key UNIQUE (eventbase_id, eventtype_id);


--
-- Name: icekit_events_eventbase_secondary_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types
    ADD CONSTRAINT icekit_events_eventbase_secondary_types_pkey PRIMARY KEY (id);


--
-- Name: icekit_events_eventrepeatsgenerator_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventrepeatsgenerator
    ADD CONSTRAINT icekit_events_eventrepeatsgenerator_pkey PRIMARY KEY (id);


--
-- Name: icekit_events_eventtype_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventtype
    ADD CONSTRAINT icekit_events_eventtype_pkey PRIMARY KEY (id);


--
-- Name: icekit_events_occurrence_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_occurrence
    ADD CONSTRAINT icekit_events_occurrence_pkey PRIMARY KEY (id);


--
-- Name: icekit_events_recurrencerule_description_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_recurrencerule
    ADD CONSTRAINT icekit_events_recurrencerule_description_key UNIQUE (description);


--
-- Name: icekit_events_recurrencerule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_recurrencerule
    ADD CONSTRAINT icekit_events_recurrencerule_pkey PRIMARY KEY (id);


--
-- Name: icekit_events_recurrencerule_recurrence_rule_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_recurrencerule
    ADD CONSTRAINT icekit_events_recurrencerule_recurrence_rule_key UNIQUE (recurrence_rule);


--
-- Name: icekit_layout_content_types_layout_id_contenttype_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types
    ADD CONSTRAINT icekit_layout_content_types_layout_id_contenttype_id_key UNIQUE (layout_id, contenttype_id);


--
-- Name: icekit_layout_content_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types
    ADD CONSTRAINT icekit_layout_content_types_pkey PRIMARY KEY (id);


--
-- Name: icekit_layout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout
    ADD CONSTRAINT icekit_layout_pkey PRIMARY KEY (id);


--
-- Name: icekit_layout_template_name_51ca5bdce3b0e013_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout
    ADD CONSTRAINT icekit_layout_template_name_51ca5bdce3b0e013_uniq UNIQUE (template_name);


--
-- Name: icekit_mediacategory_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_mediacategory
    ADD CONSTRAINT icekit_mediacategory_name_key UNIQUE (name);


--
-- Name: icekit_mediacategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_mediacategory
    ADD CONSTRAINT icekit_mediacategory_pkey PRIMARY KEY (id);


--
-- Name: icekit_plugins_contact_person_contactperson_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_contact_person_contactperson
    ADD CONSTRAINT icekit_plugins_contact_person_contactperson_pkey PRIMARY KEY (id);


--
-- Name: icekit_plugins_image_imagerepurposeconfig_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_imagerepurposeconfig
    ADD CONSTRAINT icekit_plugins_image_imagerepurposeconfig_pkey PRIMARY KEY (id);


--
-- Name: icekit_press_releases_pressrelease_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease
    ADD CONSTRAINT icekit_press_releases_pressrelease_pkey PRIMARY KEY (id);


--
-- Name: icekit_press_releases_pressrelease_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease
    ADD CONSTRAINT icekit_press_releases_pressrelease_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: icekit_press_releases_pressreleasecategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressreleasecategory
    ADD CONSTRAINT icekit_press_releases_pressreleasecategory_pkey PRIMARY KEY (id);


--
-- Name: ik_event_listing_types_eventcontentlistingitem_id_eventtype_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types
    ADD CONSTRAINT ik_event_listing_types_eventcontentlistingitem_id_eventtype_key UNIQUE (eventcontentlistingitem_id, eventtype_id);


--
-- Name: ik_event_listing_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types
    ADD CONSTRAINT ik_event_listing_types_pkey PRIMARY KEY (id);


--
-- Name: ik_todays_occurrences_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types
    ADD CONSTRAINT ik_todays_occurrences_types_pkey PRIMARY KEY (id);


--
-- Name: ik_todays_occurrences_types_todaysoccurrences_id_eventtype__key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types
    ADD CONSTRAINT ik_todays_occurrences_types_todaysoccurrences_id_eventtype__key UNIQUE (todaysoccurrences_id, eventtype_id);


--
-- Name: image_image_categories_image_id_mediacategory_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories
    ADD CONSTRAINT image_image_categories_image_id_mediacategory_id_key UNIQUE (image_id, mediacategory_id);


--
-- Name: image_image_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories
    ADD CONSTRAINT image_image_categories_pkey PRIMARY KEY (id);


--
-- Name: image_image_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image
    ADD CONSTRAINT image_image_pkey PRIMARY KEY (id);


--
-- Name: model_settings_boolean_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_boolean
    ADD CONSTRAINT model_settings_boolean_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_date_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_date
    ADD CONSTRAINT model_settings_date_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_datetime_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_datetime
    ADD CONSTRAINT model_settings_datetime_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_decimal_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_decimal
    ADD CONSTRAINT model_settings_decimal_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_file_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_file
    ADD CONSTRAINT model_settings_file_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_float_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_float
    ADD CONSTRAINT model_settings_float_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_image_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_image
    ADD CONSTRAINT model_settings_image_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_integer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_integer
    ADD CONSTRAINT model_settings_integer_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_setting_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_setting
    ADD CONSTRAINT model_settings_setting_name_key UNIQUE (name);


--
-- Name: model_settings_setting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_setting
    ADD CONSTRAINT model_settings_setting_pkey PRIMARY KEY (id);


--
-- Name: model_settings_text_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_text
    ADD CONSTRAINT model_settings_text_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: model_settings_time_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_time
    ADD CONSTRAINT model_settings_time_pkey PRIMARY KEY (setting_ptr_id);


--
-- Name: notifications_followerinf_content_type_id_34dbf2ba40daaec7_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation
    ADD CONSTRAINT notifications_followerinf_content_type_id_34dbf2ba40daaec7_uniq UNIQUE (content_type_id, object_id);


--
-- Name: notifications_followerinforma_followerinformation_id_group__key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers
    ADD CONSTRAINT notifications_followerinforma_followerinformation_id_group__key UNIQUE (followerinformation_id, group_id);


--
-- Name: notifications_followerinforma_followerinformation_id_user_i_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers
    ADD CONSTRAINT notifications_followerinforma_followerinformation_id_user_i_key UNIQUE (followerinformation_id, user_id);


--
-- Name: notifications_followerinformation_followers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers
    ADD CONSTRAINT notifications_followerinformation_followers_pkey PRIMARY KEY (id);


--
-- Name: notifications_followerinformation_group_followers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers
    ADD CONSTRAINT notifications_followerinformation_group_followers_pkey PRIMARY KEY (id);


--
-- Name: notifications_followerinformation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation
    ADD CONSTRAINT notifications_followerinformation_pkey PRIMARY KEY (id);


--
-- Name: notifications_hasreadmessage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_hasreadmessage
    ADD CONSTRAINT notifications_hasreadmessage_pkey PRIMARY KEY (id);


--
-- Name: notifications_notification_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notification
    ADD CONSTRAINT notifications_notification_pkey PRIMARY KEY (id);


--
-- Name: notifications_notificationsetting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notificationsetting
    ADD CONSTRAINT notifications_notificationsetting_pkey PRIMARY KEY (id);


--
-- Name: notifications_notificationsetting_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notificationsetting
    ADD CONSTRAINT notifications_notificationsetting_user_id_key UNIQUE (user_id);


--
-- Name: pagetype_eventlistingfordate_eventlist_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT pagetype_eventlistingfordate_eventlist_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: pagetype_eventlistingfordate_eventlistingpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT pagetype_eventlistingfordate_eventlistingpage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: pagetype_fluentpage_fluentpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_fluentpage_fluentpage
    ADD CONSTRAINT pagetype_fluentpage_fluentpage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: pagetype_icekit_article_articlecategor_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT pagetype_icekit_article_articlecategor_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: pagetype_icekit_article_articlecategorypage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT pagetype_icekit_article_articlecategorypage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: pagetype_icekit_authors_authorlisting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT pagetype_icekit_authors_authorlisting_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: pagetype_icekit_authors_authorlisting_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT pagetype_icekit_authors_authorlisting_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: pagetype_icekit_press_releases_pressre_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT pagetype_icekit_press_releases_pressre_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: pagetype_icekit_press_releases_pressreleaselisting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT pagetype_icekit_press_releases_pressreleaselisting_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: pagetype_layout_page_layoutpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT pagetype_layout_page_layoutpage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: pagetype_layout_page_layoutpage_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT pagetype_layout_page_layoutpage_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: pagetype_redirectnode_redirectnode_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_redirectnode_redirectnode
    ADD CONSTRAINT pagetype_redirectnode_redirectnode_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: pagetype_search_page_searchpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_searchpage
    ADD CONSTRAINT pagetype_search_page_searchpage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: pagetype_search_page_searchpage_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_searchpage
    ADD CONSTRAINT pagetype_search_page_searchpage_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: pagetype_textfile_textfile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_textfile_textfile
    ADD CONSTRAINT pagetype_textfile_textfile_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: polymorphic_auth_email_emailuser_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_email_emailuser
    ADD CONSTRAINT polymorphic_auth_email_emailuser_email_key UNIQUE (email);


--
-- Name: polymorphic_auth_email_emailuser_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_email_emailuser
    ADD CONSTRAINT polymorphic_auth_email_emailuser_pkey PRIMARY KEY (user_ptr_id);


--
-- Name: polymorphic_auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups
    ADD CONSTRAINT polymorphic_auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: polymorphic_auth_user_groups_user_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups
    ADD CONSTRAINT polymorphic_auth_user_groups_user_id_group_id_key UNIQUE (user_id, group_id);


--
-- Name: polymorphic_auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user
    ADD CONSTRAINT polymorphic_auth_user_pkey PRIMARY KEY (id);


--
-- Name: polymorphic_auth_user_user_permission_user_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions
    ADD CONSTRAINT polymorphic_auth_user_user_permission_user_id_permission_id_key UNIQUE (user_id, permission_id);


--
-- Name: polymorphic_auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions
    ADD CONSTRAINT polymorphic_auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: post_office_attachment_emails_attachment_id_email_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails
    ADD CONSTRAINT post_office_attachment_emails_attachment_id_email_id_key UNIQUE (attachment_id, email_id);


--
-- Name: post_office_attachment_emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails
    ADD CONSTRAINT post_office_attachment_emails_pkey PRIMARY KEY (id);


--
-- Name: post_office_attachment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment
    ADD CONSTRAINT post_office_attachment_pkey PRIMARY KEY (id);


--
-- Name: post_office_email_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_email
    ADD CONSTRAINT post_office_email_pkey PRIMARY KEY (id);


--
-- Name: post_office_emailtemplate_language_7b42158785987104_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_emailtemplate
    ADD CONSTRAINT post_office_emailtemplate_language_7b42158785987104_uniq UNIQUE (language, default_template_id);


--
-- Name: post_office_emailtemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_emailtemplate
    ADD CONSTRAINT post_office_emailtemplate_pkey PRIMARY KEY (id);


--
-- Name: post_office_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_log
    ADD CONSTRAINT post_office_log_pkey PRIMARY KEY (id);


--
-- Name: redirectnode_redirectnode_t_language_code_3a6e074f90d1d0da_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirectnode_redirectnode_translation
    ADD CONSTRAINT redirectnode_redirectnode_t_language_code_3a6e074f90d1d0da_uniq UNIQUE (language_code, master_id);


--
-- Name: redirectnode_redirectnode_translation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirectnode_redirectnode_translation
    ADD CONSTRAINT redirectnode_redirectnode_translation_pkey PRIMARY KEY (id);


--
-- Name: response_pages_responsepage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY response_pages_responsepage
    ADD CONSTRAINT response_pages_responsepage_pkey PRIMARY KEY (id);


--
-- Name: response_pages_responsepage_type_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY response_pages_responsepage
    ADD CONSTRAINT response_pages_responsepage_type_key UNIQUE (type);


--
-- Name: reversion_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_revision
    ADD CONSTRAINT reversion_revision_pkey PRIMARY KEY (id);


--
-- Name: reversion_version_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_version
    ADD CONSTRAINT reversion_version_pkey PRIMARY KEY (id);


--
-- Name: sharedcontent_sharedconten_parent_site_id_594439596c0ef877_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent
    ADD CONSTRAINT sharedcontent_sharedconten_parent_site_id_594439596c0ef877_uniq UNIQUE (parent_site_id, slug);


--
-- Name: sharedcontent_sharedcontent_language_code_232e6d20b958ebaa_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent_translation
    ADD CONSTRAINT sharedcontent_sharedcontent_language_code_232e6d20b958ebaa_uniq UNIQUE (language_code, master_id);


--
-- Name: sharedcontent_sharedcontent_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent
    ADD CONSTRAINT sharedcontent_sharedcontent_pkey PRIMARY KEY (id);


--
-- Name: sharedcontent_sharedcontent_translation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent_translation
    ADD CONSTRAINT sharedcontent_sharedcontent_translation_pkey PRIMARY KEY (id);


--
-- Name: slideshow_slideshow_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_slideshow_slideshow
    ADD CONSTRAINT slideshow_slideshow_pkey PRIMARY KEY (id);


--
-- Name: slideshow_slideshow_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_slideshow_slideshow
    ADD CONSTRAINT slideshow_slideshow_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: test_article_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT test_article_pkey PRIMARY KEY (id);


--
-- Name: test_article_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT test_article_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: test_articlelisting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT test_articlelisting_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: test_articlelisting_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT test_articlelisting_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: test_layoutpage_with_related__layoutpagewithrelatedpages_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages
    ADD CONSTRAINT test_layoutpage_with_related__layoutpagewithrelatedpages_id_key UNIQUE (layoutpagewithrelatedpages_id, page_id);


--
-- Name: test_layoutpage_with_related_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT test_layoutpage_with_related_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- Name: test_layoutpage_with_related_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT test_layoutpage_with_related_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: test_layoutpage_with_related_related_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages
    ADD CONSTRAINT test_layoutpage_with_related_related_pages_pkey PRIMARY KEY (id);


--
-- Name: tests_barwithlayout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_barwithlayout
    ADD CONSTRAINT tests_barwithlayout_pkey PRIMARY KEY (id);


--
-- Name: tests_basemodel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_basemodel
    ADD CONSTRAINT tests_basemodel_pkey PRIMARY KEY (id);


--
-- Name: tests_bazwithlayout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_bazwithlayout
    ADD CONSTRAINT tests_bazwithlayout_pkey PRIMARY KEY (id);


--
-- Name: tests_foowithlayout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_foowithlayout
    ADD CONSTRAINT tests_foowithlayout_pkey PRIMARY KEY (id);


--
-- Name: tests_imagetest_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_imagetest
    ADD CONSTRAINT tests_imagetest_pkey PRIMARY KEY (id);


--
-- Name: tests_publishingm2mmodela_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodela
    ADD CONSTRAINT tests_publishingm2mmodela_pkey PRIMARY KEY (id);


--
-- Name: tests_publishingm2mmodela_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodela
    ADD CONSTRAINT tests_publishingm2mmodela_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: tests_publishingm2mmodelb_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb
    ADD CONSTRAINT tests_publishingm2mmodelb_pkey PRIMARY KEY (id);


--
-- Name: tests_publishingm2mmodelb_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb
    ADD CONSTRAINT tests_publishingm2mmodelb_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- Name: tests_publishingm2mmodelb_rel_publishingm2mmodelb_id_publis_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models
    ADD CONSTRAINT tests_publishingm2mmodelb_rel_publishingm2mmodelb_id_publis_key UNIQUE (publishingm2mmodelb_id, publishingm2mmodela_id);


--
-- Name: tests_publishingm2mmodelb_related_a_models_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models
    ADD CONSTRAINT tests_publishingm2mmodelb_related_a_models_pkey PRIMARY KEY (id);


--
-- Name: tests_publishingm2mthroughtable_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mthroughtable
    ADD CONSTRAINT tests_publishingm2mthroughtable_pkey PRIMARY KEY (id);


--
-- Name: textfile_textfile_translati_language_code_7ab87386314d474c_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY textfile_textfile_translation
    ADD CONSTRAINT textfile_textfile_translati_language_code_7ab87386314d474c_uniq UNIQUE (language_code, master_id);


--
-- Name: textfile_textfile_translation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY textfile_textfile_translation
    ADD CONSTRAINT textfile_textfile_translation_pkey PRIMARY KEY (id);


--
-- Name: workflow_workflowstate_pkey; Type: CONSTRAINT; Schema: public; Owner: -
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
-- Name: gk_collections_work_creator_crea_alt_slug_48f4b7115becb078_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_crea_alt_slug_48f4b7115becb078_like ON gk_collections_work_creator_creatorbase USING btree (alt_slug varchar_pattern_ops);


--
-- Name: gk_collections_work_creator_creatorb_slug_6b4faebe612f3108_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_creatorb_slug_6b4faebe612f3108_like ON gk_collections_work_creator_creatorbase USING btree (slug varchar_pattern_ops);


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
-- Name: gk_collections_work_creator_role_slug_52311d82940a97b8_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_role_slug_52311d82940a97b8_like ON gk_collections_work_creator_role USING btree (slug varchar_pattern_ops);


--
-- Name: gk_collections_work_creator_work_alt_slug_17794962a436558c_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_work_alt_slug_17794962a436558c_like ON gk_collections_work_creator_workbase USING btree (alt_slug varchar_pattern_ops);


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
-- Name: gk_collections_work_creator_workbase_slug_fa550f6d9edca7c_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workbase_slug_fa550f6d9edca7c_like ON gk_collections_work_creator_workbase USING btree (slug varchar_pattern_ops);


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
-- Name: gk_collections_work_creator_workimag_slug_729d8417398b2c57_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gk_collections_work_creator_workimag_slug_729d8417398b2c57_like ON gk_collections_work_creator_workimagetype USING btree (slug varchar_pattern_ops);


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
-- Name: glamkit_collections_country_slug_519e9d90ee285081_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX glamkit_collections_country_slug_519e9d90ee285081_like ON glamkit_collections_country USING btree (slug varchar_pattern_ops);


--
-- Name: glamkit_collections_geographiclocati_slug_74f0f11905736454_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX glamkit_collections_geographiclocati_slug_74f0f11905736454_like ON glamkit_collections_geographiclocation USING btree (slug varchar_pattern_ops);


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
-- Name: icekit_press_releases_pressrelease_slug_54e8dcc0ca99dd89_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_slug_54e8dcc0ca99dd89_like ON icekit_press_releases_pressrelease USING btree (slug varchar_pattern_ops);


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
-- Name: D0245fb6fed75b5ab189d00502bf89ab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_child_pages_childpageitem
    ADD CONSTRAINT "D0245fb6fed75b5ab189d00502bf89ab" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D0e168d2cdff7d8319d1eecf33653cea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_occurrence
    ADD CONSTRAINT "D0e168d2cdff7d8319d1eecf33653cea" FOREIGN KEY (generator_id) REFERENCES icekit_events_eventrepeatsgenerator(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D1139f6178e9a5bbe8622cb6c3ff5501; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodela
    ADD CONSTRAINT "D1139f6178e9a5bbe8622cb6c3ff5501" FOREIGN KEY (publishing_linked_id) REFERENCES tests_publishingm2mmodela(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D12477a2f0a0d5cc8473b59aa423c01d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_reusable_form_formitem
    ADD CONSTRAINT "D12477a2f0a0d5cc8473b59aa423c01d" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D1390adc07c948fcb4036694056c43f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author
    ADD CONSTRAINT "D1390adc07c948fcb4036694056c43f8" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D1541a0280d83da8ca58c891ed3bdc09; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_sponsorpromoitem
    ADD CONSTRAINT "D1541a0280d83da8ca58c891ed3bdc09" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D161be8d0a2b3a53f31a02f70c77008d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workcreator
    ADD CONSTRAINT "D161be8d0a2b3a53f31a02f70c77008d" FOREIGN KEY (work_id) REFERENCES gk_collections_work_creator_workbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D1ae133b4d1ee103373721a30d99eb8f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT "D1ae133b4d1ee103373721a30d99eb8f" FOREIGN KEY (publishing_linked_id) REFERENCES pagetype_icekit_press_releases_pressreleaselisting(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D1dfdccf49b14e32c5d32357705fa2b9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workbase
    ADD CONSTRAINT "D1dfdccf49b14e32c5d32357705fa2b9" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D1e267042378ced9fb59eab349c0f15f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirectnode_redirectnode_translation
    ADD CONSTRAINT "D1e267042378ced9fb59eab349c0f15f" FOREIGN KEY (master_id) REFERENCES pagetype_redirectnode_redirectnode(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D213cad7dfd479d7419701a826fc1aec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_events_links_eventlink
    ADD CONSTRAINT "D213cad7dfd479d7419701a826fc1aec" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D2557a361662f5aad422a1fbfbf08942; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT "D2557a361662f5aad422a1fbfbf08942" FOREIGN KEY (publishing_linked_id) REFERENCES pagetype_eventlistingfordate_eventlistingpage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D29f75d8d503c908cb3e4107e4c26fed; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT "D29f75d8d503c908cb3e4107e4c26fed" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D2b591764c90eb8df816b78297d8dcd5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT "D2b591764c90eb8df816b78297d8dcd5" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D2c8564c420ecd1850b5d24dd6ed2be3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_page_anchor_pageanchoritem
    ADD CONSTRAINT "D2c8564c420ecd1850b5d24dd6ed2be3" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D2fd5f4741354fede69a82729219d231; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types
    ADD CONSTRAINT "D2fd5f4741354fede69a82729219d231" FOREIGN KEY (todaysoccurrences_id) REFERENCES contentitem_ik_events_todays_occurrences_todaysoccurrences(contentitem_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D3458cb454f1cf8e9cdc9b4bc892d82f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_gk_collections_links_creatorlink
    ADD CONSTRAINT "D3458cb454f1cf8e9cdc9b4bc892d82f" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D359c6762c45e1a4e978b00663944036; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT "D359c6762c45e1a4e978b00663944036" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_articlecategorypage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D3b8e1e090c44d9f870f3b66caca5ae9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT "D3b8e1e090c44d9f870f3b66caca5ae9" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D3c2d44564dd7f568e73116a1fafb482; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_event_types_simple_simpleevent
    ADD CONSTRAINT "D3c2d44564dd7f568e73116a1fafb482" FOREIGN KEY (eventbase_ptr_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D3f72b36b8354fcc55813da655df821d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT "D3f72b36b8354fcc55813da655df821d" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_authorlisting(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D4ddbc0310c6e345ada2b0699aa3b7e1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_gk_collections_links_worklink
    ADD CONSTRAINT "D4ddbc0310c6e345ada2b0699aa3b7e1" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D534fa81577cb27c90194c8eb8707cfe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types
    ADD CONSTRAINT "D534fa81577cb27c90194c8eb8707cfe" FOREIGN KEY (eventcontentlistingitem_id) REFERENCES contentitem_ik_event_listing_eventcontentlistingitem(contentitem_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D56f259b60847c71a6bf5c3fcfa42f66; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT "D56f259b60847c71a6bf5c3fcfa42f66" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D58fce3347c4bdfcab927c538a74c793; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY textfile_textfile_translation
    ADD CONSTRAINT "D58fce3347c4bdfcab927c538a74c793" FOREIGN KEY (master_id) REFERENCES pagetype_textfile_textfile(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D59fe44fe9e5aefe1054bf0b2b4e5862; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_slideshow_slideshowitem
    ADD CONSTRAINT "D59fe44fe9e5aefe1054bf0b2b4e5862" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D5c546756a7658292dba09397398aae9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workbase
    ADD CONSTRAINT "D5c546756a7658292dba09397398aae9" FOREIGN KEY (publishing_linked_id) REFERENCES gk_collections_work_creator_workbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D5ce9d01712873a19b40ba7c73274f82; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models
    ADD CONSTRAINT "D5ce9d01712873a19b40ba7c73274f82" FOREIGN KEY (publishingm2mmodelb_id) REFERENCES tests_publishingm2mmodelb(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D5e1f2542df3427c4259a5b9f94dc3a9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_image_imageitem
    ADD CONSTRAINT "D5e1f2542df3427c4259a5b9f94dc3a9" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D5e858b3c722a8b31447cb62696c4c98; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workcreator
    ADD CONSTRAINT "D5e858b3c722a8b31447cb62696c4c98" FOREIGN KEY (role_id) REFERENCES gk_collections_work_creator_role(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D62dd130fe963777318ef625b65e3587; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models
    ADD CONSTRAINT "D62dd130fe963777318ef625b65e3587" FOREIGN KEY (publishingm2mmodela_id) REFERENCES tests_publishingm2mmodela(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D648d90c316ad733a485d8dd04d22a96; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers
    ADD CONSTRAINT "D648d90c316ad733a485d8dd04d22a96" FOREIGN KEY (followerinformation_id) REFERENCES notifications_followerinformation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D656c93cfd181fd1df9e1fe7b2f1a7d1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_image_gallery_imagegalleryshowitem
    ADD CONSTRAINT "D656c93cfd181fd1df9e1fe7b2f1a7d1" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D668b920129450e2c896f576f0890769; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT "D668b920129450e2c896f576f0890769" FOREIGN KEY (publishing_linked_id) REFERENCES test_articlelisting(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D674cbf2aea8bebe7a5c3ee1b2a543bb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_oembed_with_caption_item
    ADD CONSTRAINT "D674cbf2aea8bebe7a5c3ee1b2a543bb" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D6917805e321253c9bb22f0d61a5d38f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers
    ADD CONSTRAINT "D6917805e321253c9bb22f0d61a5d38f" FOREIGN KEY (followerinformation_id) REFERENCES notifications_followerinformation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D69b752fae4b023166a9972d5d0d8c69; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT "D69b752fae4b023166a9972d5d0d8c69" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D6a33e4c59c4a031e13f92afc3e129fd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_events_todays_occurrences_todaysoccurrences
    ADD CONSTRAINT "D6a33e4c59c4a031e13f92afc3e129fd" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D6a43d513db9d24d96c7c21dabcf84f5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem
    ADD CONSTRAINT "D6a43d513db9d24d96c7c21dabcf84f5" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D6b3902cf9671b92c8203e23d49e4f3a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author
    ADD CONSTRAINT "D6b3902cf9671b92c8203e23d49e4f3a" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_authors_author(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D6c4c0d55b1296eafbe99fede3685e89; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT "D6c4c0d55b1296eafbe99fede3685e89" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D6d5ecb19efe9b26ef92eb5a19ccb895; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_endsponsorblockitem
    ADD CONSTRAINT "D6d5ecb19efe9b26ef92eb5a19ccb895" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D72b3192f934d3cf0249ab6bd6b07f03; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_pagelink
    ADD CONSTRAINT "D72b3192f934d3cf0249ab6bd6b07f03" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D746928cdc079e1b9e31b78b58158e65; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_horizontal_rule_horizontalruleitem
    ADD CONSTRAINT "D746928cdc079e1b9e31b78b58158e65" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D74c9c4cb5e857b02daf0a5f9afca621; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workorigin
    ADD CONSTRAINT "D74c9c4cb5e857b02daf0a5f9afca621" FOREIGN KEY (geographic_location_id) REFERENCES glamkit_collections_geographiclocation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D74ff5fd75b2702b5c73aa81b62f58ef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT "D74ff5fd75b2702b5c73aa81b62f58ef" FOREIGN KEY (publishing_linked_id) REFERENCES test_layoutpage_with_related(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D7a61198c03a809e52d177a4a32077d7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_file_fileitem
    ADD CONSTRAINT "D7a61198c03a809e52d177a4a32077d7" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D7d2a9b5365df4e58c84ecdad482fe4c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT "D7d2a9b5365df4e58c84ecdad482fe4c" FOREIGN KEY (parent_id) REFERENCES test_articlelisting(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D7d9421c0dee31db03ad49b802f1d943; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation
    ADD CONSTRAINT "D7d9421c0dee31db03ad49b802f1d943" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D7f8167aa9d0d2b028bedcfe5ed3e32c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT "D7f8167aa9d0d2b028bedcfe5ed3e32c" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_layoutpage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D8228d3eacb2b5095420947ae3d00f00; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT "D8228d3eacb2b5095420947ae3d00f00" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_article_article(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D892b3ae82379c196d74d17cb7b26b14; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_instagram_embed_instagramembeditem
    ADD CONSTRAINT "D892b3ae82379c196d74d17cb7b26b14" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D8ad5f23ed00d30b6ae7068ae725adc1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_authorlink
    ADD CONSTRAINT "D8ad5f23ed00d30b6ae7068ae725adc1" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D8d69b5b30fc71aed00ddf236779316b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT "D8d69b5b30fc71aed00ddf236779316b" FOREIGN KEY (parent_id) REFERENCES icekit_articlecategorypage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D8f5ee3002ff7f3e40b3084e79bb8f04; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_gk_collections_links_creatorlink
    ADD CONSTRAINT "D8f5ee3002ff7f3e40b3084e79bb8f04" FOREIGN KEY (item_id) REFERENCES gk_collections_work_creator_creatorbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D9120a5e8b6cf31cc03b38401d0b829b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem
    ADD CONSTRAINT "D9120a5e8b6cf31cc03b38401d0b829b" FOREIGN KEY (placeholder_id) REFERENCES fluent_contents_placeholder(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D94c2a91a5b49eb6a1669eb622770dd8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT "D94c2a91a5b49eb6a1669eb622770dd8" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D957f8660832069fe187675418642e75; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workimage
    ADD CONSTRAINT "D957f8660832069fe187675418642e75" FOREIGN KEY (work_id) REFERENCES gk_collections_work_creator_workbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D963bf23cc2bbb2541437049b04a9490; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_text_textitem
    ADD CONSTRAINT "D963bf23cc2bbb2541437049b04a9490" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D9dffe0c8cd92e52bad901d12fb6cb94; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_contact_person_contactpersonitem
    ADD CONSTRAINT "D9dffe0c8cd92e52bad901d12fb6cb94" FOREIGN KEY (contact_id) REFERENCES icekit_plugins_contact_person_contactperson(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D9f984f753e097b3afe2f76fed8819e5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease
    ADD CONSTRAINT "D9f984f753e097b3afe2f76fed8819e5" FOREIGN KEY (category_id) REFERENCES icekit_press_releases_pressreleasecategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: a7539e14050c2599ab3275919189a4fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_gk_collections_links_worklink
    ADD CONSTRAINT a7539e14050c2599ab3275919189a4fc FOREIGN KEY (item_id) REFERENCES gk_collections_work_creator_workbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: a7ad0f3ab9eece5f10263ee1e751354f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_content_listing_contentlistingitem
    ADD CONSTRAINT a7ad0f3ab9eece5f10263ee1e751354f FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: a8a3c84526b5bb62ec7381f1b24c7fb5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_image_gallery_imagegalleryshowitem
    ADD CONSTRAINT a8a3c84526b5bb62ec7381f1b24c7fb5 FOREIGN KEY (slide_show_id) REFERENCES icekit_plugins_slideshow_slideshow(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: a93398867908b6bc8af6be979ef18c85; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_creatorbase
    ADD CONSTRAINT a93398867908b6bc8af6be979ef18c85 FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ab563fdec8e3292c5558f933e5d5f7bd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_emailtemplate
    ADD CONSTRAINT ab563fdec8e3292c5558f933e5d5f7bd FOREIGN KEY (default_template_id) REFERENCES post_office_emailtemplate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: acb7b587835487702e85d5a43ea3830e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_oembeditem_oembeditem
    ADD CONSTRAINT acb7b587835487702e85d5a43ea3830e FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: acfc3144c21804f82af5821cbf278457; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_articlelink
    ADD CONSTRAINT acfc3144c21804f82af5821cbf278457 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: af7eff6d97aa6682ccb619ce20e073cd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_slideshow_slideshow
    ADD CONSTRAINT af7eff6d97aa6682ccb619ce20e073cd FOREIGN KEY (publishing_linked_id) REFERENCES icekit_plugins_slideshow_slideshow(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth__content_type_id_a28c4ab1069e97b_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth__content_type_id_a28c4ab1069e97b_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissio_group_id_1b80906b4e9a50c9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_group_id_1b80906b4e9a50c9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permission_id_65c3c59c45b0da02_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permission_id_65c3c59c45b0da02_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: authtoken__user_id_3a70355ce1a875dd_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY authtoken_token
    ADD CONSTRAINT authtoken__user_id_3a70355ce1a875dd_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: b57d035c68cd3f3d512e48e3f2dedea8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT b57d035c68cd3f3d512e48e3f2dedea8 FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: bb02428515ded559e9cc6be4b4ed226c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_quote_quoteitem
    ADD CONSTRAINT bb02428515ded559e9cc6be4b4ed226c FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: bfb7ed18891f160b6ddb82b332873a77; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_iframe_iframeitem
    ADD CONSTRAINT bfb7ed18891f160b6ddb82b332873a77 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: c19d7af78aeab18181e6d1c24185ca4f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workimage
    ADD CONSTRAINT c19d7af78aeab18181e6d1c24185ca4f FOREIGN KEY (type_id) REFERENCES gk_collections_work_creator_workimagetype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: c2c288ab70dcc6f54ffee48b5bb4a431; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_twitter_embed_twitterembeditem
    ADD CONSTRAINT c2c288ab70dcc6f54ffee48b5bb4a431 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: c3cbe36e2a2afbfc1aff35ebf2827ec4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem
    ADD CONSTRAINT c3cbe36e2a2afbfc1aff35ebf2827ec4 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: c43b6e1c444043d045ec6d700824d3d0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_event_listing_eventcontentlistingitem
    ADD CONSTRAINT c43b6e1c444043d045ec6d700824d3d0 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: cde74934885e04bdd3fa4703a96ddbfe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT cde74934885e04bdd3fa4703a96ddbfe FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: cont_content_type_id_4b84cbdeee587f42_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_event_listing_eventcontentlistingitem
    ADD CONSTRAINT cont_content_type_id_4b84cbdeee587f42_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: cont_content_type_id_5c4212e7b55da8d0_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_content_listing_contentlistingitem
    ADD CONSTRAINT cont_content_type_id_5c4212e7b55da8d0_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: cont_sponsor_id_5b5d29e415858619_fk_glamkit_sponsors_sponsor_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_sponsorpromoitem
    ADD CONSTRAINT cont_sponsor_id_5b5d29e415858619_fk_glamkit_sponsors_sponsor_id FOREIGN KEY (sponsor_id) REFERENCES glamkit_sponsors_sponsor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contenti_item_id_3ecd38d2c1024b09_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_events_links_eventlink
    ADD CONSTRAINT contenti_item_id_3ecd38d2c1024b09_fk_icekit_events_eventbase_id FOREIGN KEY (item_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentit_item_id_6902f837a26ce9c3_fk_icekit_article_article_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_articlelink
    ADD CONSTRAINT contentit_item_id_6902f837a26ce9c3_fk_icekit_article_article_id FOREIGN KEY (item_id) REFERENCES icekit_article_article(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentite_item_id_166cbb8078c57e7f_fk_icekit_authors_author_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_authorlink
    ADD CONSTRAINT contentite_item_id_166cbb8078c57e7f_fk_icekit_authors_author_id FOREIGN KEY (item_id) REFERENCES icekit_authors_author(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_file_fileit_file_id_d5b107ada6f8076_fk_file_file_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_file_fileitem
    ADD CONSTRAINT contentitem_file_fileit_file_id_d5b107ada6f8076_fk_file_file_id FOREIGN KEY (file_id) REFERENCES icekit_plugins_file_file(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_image_i_image_id_3d419aab9ff251b6_fk_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_image_imageitem
    ADD CONSTRAINT contentitem_image_i_image_id_3d419aab9ff251b6_fk_image_image_id FOREIGN KEY (image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_item_id_6ba466c7a00d0435_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_pagelink
    ADD CONSTRAINT contentitem_item_id_6ba466c7a00d0435_fk_fluent_pages_urlnode_id FOREIGN KEY (item_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contentitem_reusable__form_id_24bfa0a3b7c27b5b_fk_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_reusable_form_formitem
    ADD CONSTRAINT contentitem_reusable__form_id_24bfa0a3b7c27b5b_fk_forms_form_id FOREIGN KEY (form_id) REFERENCES forms_form(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: d8e57ced674e62b1fadaba9eaf593817; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_beginsponsorblockitem
    ADD CONSTRAINT d8e57ced674e62b1fadaba9eaf593817 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: d9dcc4e71b0d5362aa6ecd61c4ab447b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_creatorbase
    ADD CONSTRAINT d9dcc4e71b0d5362aa6ecd61c4ab447b FOREIGN KEY (publishing_linked_id) REFERENCES gk_collections_work_creator_creatorbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: dc94ec01eade3071557808468f97a5ee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_faq_faqitem
    ADD CONSTRAINT dc94ec01eade3071557808468f97a5ee FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: derived_from_id_5c02da1134f17c16_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT derived_from_id_5c02da1134f17c16_fk_icekit_events_eventbase_id FOREIGN KEY (derived_from_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: dfe949fbe177f7fb98826c17d44659b0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_map_mapitem
    ADD CONSTRAINT dfe949fbe177f7fb98826c17d44659b0 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: dfec62abb9fdccad6e5b490fe735e043; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_sharedcontent_sharedcontentitem
    ADD CONSTRAINT dfec62abb9fdccad6e5b490fe735e043 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: dj_interval_id_1e059af646f49561_fk_djcelery_intervalschedule_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT dj_interval_id_1e059af646f49561_fk_djcelery_intervalschedule_id FOREIGN KEY (interval_id) REFERENCES djcelery_intervalschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djan_content_type_id_2ca7e25efca8933c_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT djan_content_type_id_2ca7e25efca8933c_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_adm_user_id_18f270e65b0de43f_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_adm_user_id_18f270e65b0de43f_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_redirect_site_id_2fd85d7e03155322_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_redirect
    ADD CONSTRAINT django_redirect_site_id_2fd85d7e03155322_fk_django_site_id FOREIGN KEY (site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djce_crontab_id_78b22ce49259bc58_fk_djcelery_crontabschedule_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT djce_crontab_id_78b22ce49259bc58_fk_djcelery_crontabschedule_id FOREIGN KEY (crontab_id) REFERENCES djcelery_crontabschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djcelery__worker_id_7de9d217baa22059_fk_djcelery_workerstate_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_taskstate
    ADD CONSTRAINT djcelery__worker_id_7de9d217baa22059_fk_djcelery_workerstate_id FOREIGN KEY (worker_id) REFERENCES djcelery_workerstate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djkombu_message_queue_id_39d8365252f2f8ad_fk_djkombu_queue_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_message
    ADD CONSTRAINT djkombu_message_queue_id_39d8365252f2f8ad_fk_djkombu_queue_id FOREIGN KEY (queue_id) REFERENCES djkombu_queue(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: e0049c351b059eb36c39b42ee05a4cc9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb
    ADD CONSTRAINT e0049c351b059eb36c39b42ee05a4cc9 FOREIGN KEY (publishing_linked_id) REFERENCES tests_publishingm2mmodelb(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: e0ea193554811083919f25b35b61e582; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workorigin
    ADD CONSTRAINT e0ea193554811083919f25b35b61e582 FOREIGN KEY (work_id) REFERENCES gk_collections_work_creator_workbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: e_thumbnail_id_329715e45dd2e01a_fk_easy_thumbnails_thumbnail_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnaildimensions
    ADD CONSTRAINT e_thumbnail_id_329715e45dd2e01a_fk_easy_thumbnails_thumbnail_id FOREIGN KEY (thumbnail_id) REFERENCES easy_thumbnails_thumbnail(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ea5e6c5d8f51f9affb146c4beb49c329; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_slideshow_slideshowitem
    ADD CONSTRAINT ea5e6c5d8f51f9affb146c4beb49c329 FOREIGN KEY (slide_show_id) REFERENCES icekit_plugins_slideshow_slideshow(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: easy_th_source_id_584430c2d61eb0c5_fk_easy_thumbnails_source_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnail
    ADD CONSTRAINT easy_th_source_id_584430c2d61eb0c5_fk_easy_thumbnails_source_id FOREIGN KEY (source_id) REFERENCES easy_thumbnails_source(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ec7c10d960fccba9451d31dcd783ef04; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages
    ADD CONSTRAINT ec7c10d960fccba9451d31dcd783ef04 FOREIGN KEY (layoutpagewithrelatedpages_id) REFERENCES test_layoutpage_with_related(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ef5fd15154aae33dfbe199a59be185ef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workcreator
    ADD CONSTRAINT ef5fd15154aae33dfbe199a59be185ef FOREIGN KEY (creator_id) REFERENCES gk_collections_work_creator_creatorbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: efd03fd7ec02fb27d20d77b5921f2d14; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_contact_person_contactpersonitem
    ADD CONSTRAINT efd03fd7ec02fb27d20d77b5921f2d14 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: f10d285205dd02ef874b92dedea80a53; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT f10d285205dd02ef874b92dedea80a53 FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: f2323acad92abde7bd66315f7b79bd7b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease
    ADD CONSTRAINT f2323acad92abde7bd66315f7b79bd7b FOREIGN KEY (publishing_linked_id) REFERENCES icekit_press_releases_pressrelease(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: f6405575945e2e3d8a56ef9c7b5406cf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_rawhtml_rawhtmlitem
    ADD CONSTRAINT f6405575945e2e3d8a56ef9c7b5406cf FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: f8ab1bffe888d6f7bd62f3ec57257cf8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_setting
    ADD CONSTRAINT f8ab1bffe888d6f7bd62f3ec57257cf8 FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: f9e7d70c6343c742213c5e0cc5593bad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_sharedcontent_sharedcontentitem
    ADD CONSTRAINT f9e7d70c6343c742213c5e0cc5593bad FOREIGN KEY (shared_content_id) REFERENCES sharedcontent_sharedcontent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fbd8a006e177de81b99f68b52fcbf5dc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_searchpage
    ADD CONSTRAINT fbd8a006e177de81b99f68b52fcbf5dc FOREIGN KEY (publishing_linked_id) REFERENCES icekit_searchpage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fil_mediacategory_id_865783e5d23d365_fk_icekit_mediacategory_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories
    ADD CONSTRAINT fil_mediacategory_id_865783e5d23d365_fk_icekit_mediacategory_id FOREIGN KEY (mediacategory_id) REFERENCES icekit_mediacategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: file_file_categories_file_id_6a258773adece998_fk_file_file_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories
    ADD CONSTRAINT file_file_categories_file_id_6a258773adece998_fk_file_file_id FOREIGN KEY (file_id) REFERENCES icekit_plugins_file_file(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluen_parent_type_id_6af048a6406f5c81_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem
    ADD CONSTRAINT fluen_parent_type_id_6af048a6406f5c81_fk_django_content_type_id FOREIGN KEY (parent_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluen_parent_type_id_7a4e056027c5655a_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_placeholder
    ADD CONSTRAINT fluen_parent_type_id_7a4e056027c5655a_fk_django_content_type_id FOREIGN KEY (parent_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_p_author_id_32d23b3a9980ed76_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_p_author_id_32d23b3a9980ed76_fk_polymorphic_auth_user_id FOREIGN KEY (author_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_pa_master_id_28f9a5bcea4a4f93_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode_translation
    ADD CONSTRAINT fluent_pa_master_id_28f9a5bcea4a4f93_fk_fluent_pages_urlnode_id FOREIGN KEY (master_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_pa_master_id_3748913884cbde81_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_htmlpage_translation
    ADD CONSTRAINT fluent_pa_master_id_3748913884cbde81_fk_fluent_pages_urlnode_id FOREIGN KEY (master_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_pa_parent_id_3f0fb02f3c868405_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_pa_parent_id_3f0fb02f3c868405_fk_fluent_pages_urlnode_id FOREIGN KEY (parent_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fluent_pages_u_parent_site_id_858c8cfc1c06214_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_pages_u_parent_site_id_858c8cfc1c06214_fk_django_site_id FOREIGN KEY (parent_site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: forms_field_form_id_537de51c5672aae9_fk_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_field
    ADD CONSTRAINT forms_field_form_id_537de51c5672aae9_fk_forms_form_id FOREIGN KEY (form_id) REFERENCES forms_form(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: forms_fieldentr_entry_id_7493975110141081_fk_forms_formentry_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_fieldentry
    ADD CONSTRAINT forms_fieldentr_entry_id_7493975110141081_fk_forms_formentry_id FOREIGN KEY (entry_id) REFERENCES forms_formentry(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: forms_form_sites_form_id_56607289ba1beeb3_fk_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites
    ADD CONSTRAINT forms_form_sites_form_id_56607289ba1beeb3_fk_forms_form_id FOREIGN KEY (form_id) REFERENCES forms_form(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: forms_form_sites_site_id_2e2d33cdfa579ec6_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites
    ADD CONSTRAINT forms_form_sites_site_id_2e2d33cdfa579ec6_fk_django_site_id FOREIGN KEY (site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: forms_formentry_form_id_362c34b9cb448095_fk_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_formentry
    ADD CONSTRAINT forms_formentry_form_id_362c34b9cb448095_fk_forms_form_id FOREIGN KEY (form_id) REFERENCES forms_form(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: g_country_id_553ec213896c0857_fk_glamkit_collections_country_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_collections_geographiclocation
    ADD CONSTRAINT g_country_id_553ec213896c0857_fk_glamkit_collections_country_id FOREIGN KEY (country_id) REFERENCES glamkit_collections_country(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_c_image_id_2dafe41b213ad6b1_fk_icekit_plugins_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workimage
    ADD CONSTRAINT gk_c_image_id_2dafe41b213ad6b1_fk_icekit_plugins_image_image_id FOREIGN KEY (image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_w_layout_id_7144b6cc5f8bd9ea_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_workbase
    ADD CONSTRAINT gk_collections_w_layout_id_7144b6cc5f8bd9ea_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_collections_w_layout_id_79bb555514544efa_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_creatorbase
    ADD CONSTRAINT gk_collections_w_layout_id_79bb555514544efa_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gk_portrait_id_d02e42522cd6d49_fk_icekit_plugins_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gk_collections_work_creator_creatorbase
    ADD CONSTRAINT gk_portrait_id_d02e42522cd6d49_fk_icekit_plugins_image_image_id FOREIGN KEY (portrait_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: glamk_logo_id_1e64e24af5cacd4b_fk_icekit_plugins_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_sponsors_sponsor
    ADD CONSTRAINT glamk_logo_id_1e64e24af5cacd4b_fk_icekit_plugins_image_image_id FOREIGN KEY (logo_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: hero_image_id_283a60179dd88f7_fk_icekit_plugins_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT hero_image_id_283a60179dd88f7_fk_icekit_plugins_image_image_id FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ice_assigned_to_id_11e83c2cc7585a34_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_workflow_workflowstate
    ADD CONSTRAINT ice_assigned_to_id_11e83c2cc7585a34_fk_polymorphic_auth_user_id FOREIGN KEY (assigned_to_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ice_eventbase_id_1644608096866a53_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types
    ADD CONSTRAINT ice_eventbase_id_1644608096866a53_fk_icekit_events_eventbase_id FOREIGN KEY (eventbase_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ice_eventtype_id_28150fccc0fe3490_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types
    ADD CONSTRAINT ice_eventtype_id_28150fccc0fe3490_fk_icekit_events_eventtype_id FOREIGN KEY (eventtype_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: iceki_contenttype_id_2dc535d16c6b1523_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types
    ADD CONSTRAINT iceki_contenttype_id_2dc535d16c6b1523_fk_django_content_type_id FOREIGN KEY (contenttype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: iceki_part_of_id_54b010b207bc18aa_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT iceki_part_of_id_54b010b207bc18aa_fk_icekit_events_eventbase_id FOREIGN KEY (part_of_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit__event_id_52acf2456feaaa96_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_occurrence
    ADD CONSTRAINT icekit__event_id_52acf2456feaaa96_fk_icekit_events_eventbase_id FOREIGN KEY (event_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_article_a_layout_id_5a5bea523c7d3faf_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT icekit_article_a_layout_id_5a5bea523c7d3faf_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_e_event_id_2e9900bae08dc8d_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventrepeatsgenerator
    ADD CONSTRAINT icekit_e_event_id_2e9900bae08dc8d_fk_icekit_events_eventbase_id FOREIGN KEY (event_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_event_typ_layout_id_2657fd1d7ee7ef61_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_event_types_simple_simpleevent
    ADD CONSTRAINT icekit_event_typ_layout_id_2657fd1d7ee7ef61_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_layout_co_layout_id_706624d375bb5f39_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types
    ADD CONSTRAINT icekit_layout_co_layout_id_706624d375bb5f39_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: icekit_press_rel_layout_id_7f7024369628143b_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease
    ADD CONSTRAINT icekit_press_rel_layout_id_7f7024369628143b_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ik__eventtype_id_3af887d92b2d6951_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types
    ADD CONSTRAINT ik__eventtype_id_3af887d92b2d6951_fk_icekit_events_eventtype_id FOREIGN KEY (eventtype_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ik_t_eventtype_id_4a770759a799f18_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types
    ADD CONSTRAINT ik_t_eventtype_id_4a770759a799f18_fk_icekit_events_eventtype_id FOREIGN KEY (eventtype_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: im_mediacategory_id_794fd88978b44d3d_fk_icekit_mediacategory_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories
    ADD CONSTRAINT im_mediacategory_id_794fd88978b44d3d_fk_icekit_mediacategory_id FOREIGN KEY (mediacategory_id) REFERENCES icekit_mediacategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: image_image_categor_image_id_44d822caadd9755c_fk_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories
    ADD CONSTRAINT image_image_categor_image_id_44d822caadd9755c_fk_image_image_id FOREIGN KEY (image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: mo_setting_ptr_id_14d706ba177074c5_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_date
    ADD CONSTRAINT mo_setting_ptr_id_14d706ba177074c5_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: mo_setting_ptr_id_22aa74d0801598ff_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_image
    ADD CONSTRAINT mo_setting_ptr_id_22aa74d0801598ff_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: mo_setting_ptr_id_231fc7f8eee415e6_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_text
    ADD CONSTRAINT mo_setting_ptr_id_231fc7f8eee415e6_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: mo_setting_ptr_id_4a155e59ffcfc870_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_time
    ADD CONSTRAINT mo_setting_ptr_id_4a155e59ffcfc870_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: mo_setting_ptr_id_4ddfa74cebf53e3a_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_float
    ADD CONSTRAINT mo_setting_ptr_id_4ddfa74cebf53e3a_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: mo_setting_ptr_id_6c3217230fdc8b58_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_integer
    ADD CONSTRAINT mo_setting_ptr_id_6c3217230fdc8b58_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: mo_setting_ptr_id_74fa35fe22baaeed_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_file
    ADD CONSTRAINT mo_setting_ptr_id_74fa35fe22baaeed_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: mo_setting_ptr_id_79b50faeb0433e91_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_decimal
    ADD CONSTRAINT mo_setting_ptr_id_79b50faeb0433e91_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: mo_setting_ptr_id_7a5572d8aff4dc72_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_boolean
    ADD CONSTRAINT mo_setting_ptr_id_7a5572d8aff4dc72_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: mod_setting_ptr_id_aad8956f5afba40_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_datetime
    ADD CONSTRAINT mod_setting_ptr_id_aad8956f5afba40_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: no_message_id_1972d14a6c39bdfc_fk_notifications_notification_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_hasreadmessage
    ADD CONSTRAINT no_message_id_1972d14a6c39bdfc_fk_notifications_notification_id FOREIGN KEY (message_id) REFERENCES notifications_notification(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: noti_content_type_id_6e2f52401d6ded8a_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation
    ADD CONSTRAINT noti_content_type_id_6e2f52401d6ded8a_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifica_person_id_2e45a28707d9a12b_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_hasreadmessage
    ADD CONSTRAINT notifica_person_id_2e45a28707d9a12b_fk_polymorphic_auth_user_id FOREIGN KEY (person_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notificati_user_id_2bfa1ca26dbc1b05_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notification
    ADD CONSTRAINT notificati_user_id_2bfa1ca26dbc1b05_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notificati_user_id_3dfb012e22083e1a_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notificationsetting
    ADD CONSTRAINT notificati_user_id_3dfb012e22083e1a_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notificati_user_id_4b74ed93f7727133_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers
    ADD CONSTRAINT notificati_user_id_4b74ed93f7727133_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications_follow_group_id_6150e9b99f6b1928_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers
    ADD CONSTRAINT notifications_follow_group_id_6150e9b99f6b1928_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: page_urlnode_ptr_id_29daf354bb5aa9c0_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_searchpage
    ADD CONSTRAINT page_urlnode_ptr_id_29daf354bb5aa9c0_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: page_urlnode_ptr_id_4609f474221c9746_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT page_urlnode_ptr_id_4609f474221c9746_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: page_urlnode_ptr_id_472ceffe40b31372_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_redirectnode_redirectnode
    ADD CONSTRAINT page_urlnode_ptr_id_472ceffe40b31372_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: page_urlnode_ptr_id_4aee60e4d7d9a760_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_fluentpage_fluentpage
    ADD CONSTRAINT page_urlnode_ptr_id_4aee60e4d7d9a760_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: page_urlnode_ptr_id_52fd7d5be9a40704_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_textfile_textfile
    ADD CONSTRAINT page_urlnode_ptr_id_52fd7d5be9a40704_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: page_urlnode_ptr_id_534f2802de6d5478_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT page_urlnode_ptr_id_534f2802de6d5478_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: page_urlnode_ptr_id_5bed3793e6bf6eaf_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT page_urlnode_ptr_id_5bed3793e6bf6eaf_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: page_urlnode_ptr_id_6829f0a117bed67a_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT page_urlnode_ptr_id_6829f0a117bed67a_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: page_urlnode_ptr_id_7b20151bb8e89cc6_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT page_urlnode_ptr_id_7b20151bb8e89cc6_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetyp_layout_id_2836cc41f327e8d_fk_fluent_pages_pagelayout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_fluentpage_fluentpage
    ADD CONSTRAINT pagetyp_layout_id_2836cc41f327e8d_fk_fluent_pages_pagelayout_id FOREIGN KEY (layout_id) REFERENCES fluent_pages_pagelayout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_eventli_layout_id_537a04fe7d60797c_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT pagetype_eventli_layout_id_537a04fe7d60797c_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_icekit__layout_id_327251f99f1d5dd9_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT pagetype_icekit__layout_id_327251f99f1d5dd9_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_icekit__layout_id_6ad44ce83ed48759_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT pagetype_icekit__layout_id_6ad44ce83ed48759_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_icekit_a_layout_id_579f2925b72c7f3_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT pagetype_icekit_a_layout_id_579f2925b72c7f3_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagetype_layout__layout_id_383a0d79e7f4eecb_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT pagetype_layout__layout_id_383a0d79e7f4eecb_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: po_template_id_2235a2220887a14d_fk_post_office_emailtemplate_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_email
    ADD CONSTRAINT po_template_id_2235a2220887a14d_fk_post_office_emailtemplate_id FOREIGN KEY (template_id) REFERENCES post_office_emailtemplate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymo_user_ptr_id_6a8caf8215fa215a_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_email_emailuser
    ADD CONSTRAINT polymo_user_ptr_id_6a8caf8215fa215a_fk_polymorphic_auth_user_id FOREIGN KEY (user_ptr_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphi_permission_id_36de5f52f29bcced_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions
    ADD CONSTRAINT polymorphi_permission_id_36de5f52f29bcced_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphi_user_id_70007f039c5af827_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups
    ADD CONSTRAINT polymorphi_user_id_70007f039c5af827_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphic_auth_use_group_id_45442508aa2549f0_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups
    ADD CONSTRAINT polymorphic_auth_use_group_id_45442508aa2549f0_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphic_ctype_id_3c51ab6f5715609_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user
    ADD CONSTRAINT polymorphic_ctype_id_3c51ab6f5715609_fk_django_content_type_id FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: polymorphic_user_id_c16c15b51d75529_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions
    ADD CONSTRAINT polymorphic_user_id_c16c15b51d75529_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pos_attachment_id_5a5c523010d54e09_fk_post_office_attachment_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails
    ADD CONSTRAINT pos_attachment_id_5a5c523010d54e09_fk_post_office_attachment_id FOREIGN KEY (attachment_id) REFERENCES post_office_attachment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: post_office_a_email_id_104aca12e136a983_fk_post_office_email_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails
    ADD CONSTRAINT post_office_a_email_id_104aca12e136a983_fk_post_office_email_id FOREIGN KEY (email_id) REFERENCES post_office_email(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: post_office_l_email_id_3aca67ab61c8afc4_fk_post_office_email_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_log
    ADD CONSTRAINT post_office_l_email_id_3aca67ab61c8afc4_fk_post_office_email_id FOREIGN KEY (email_id) REFERENCES post_office_email(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: primary_type_id_490cb646066da147_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT primary_type_id_490cb646066da147_fk_icekit_events_eventtype_id FOREIGN KEY (primary_type_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reve_content_type_id_238aa26c9d058501_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_version
    ADD CONSTRAINT reve_content_type_id_238aa26c9d058501_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reversion__user_id_29c60f0af1f08184_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_revision
    ADD CONSTRAINT reversion__user_id_29c60f0af1f08184_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reversion_revision_id_2a7e1dbaccb99362_fk_reversion_revision_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_version
    ADD CONSTRAINT reversion_revision_id_2a7e1dbaccb99362_fk_reversion_revision_id FOREIGN KEY (revision_id) REFERENCES reversion_revision(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: sh_master_id_5a5dbb4cc1beb25e_fk_sharedcontent_sharedcontent_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent_translation
    ADD CONSTRAINT sh_master_id_5a5dbb4cc1beb25e_fk_sharedcontent_sharedcontent_id FOREIGN KEY (master_id) REFERENCES sharedcontent_sharedcontent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: sharedcontent_parent_site_id_5041fde35c20f8e5_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent
    ADD CONSTRAINT sharedcontent_parent_site_id_5041fde35c20f8e5_fk_django_site_id FOREIGN KEY (parent_site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tes_a_model_id_345a955ca0abca61_fk_tests_publishingm2mmodela_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mthroughtable
    ADD CONSTRAINT tes_a_model_id_345a955ca0abca61_fk_tests_publishingm2mmodela_id FOREIGN KEY (a_model_id) REFERENCES tests_publishingm2mmodela(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tes_b_model_id_3692289f81c86798_fk_tests_publishingm2mmodelb_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mthroughtable
    ADD CONSTRAINT tes_b_model_id_3692289f81c86798_fk_tests_publishingm2mmodelb_id FOREIGN KEY (b_model_id) REFERENCES tests_publishingm2mmodelb(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_a_publishing_linked_id_385d0c31c9e4bc37_fk_test_article_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT test_a_publishing_linked_id_385d0c31c9e4bc37_fk_test_article_id FOREIGN KEY (publishing_linked_id) REFERENCES test_article(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_article_layout_id_10d9d3adf777cfe1_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT test_article_layout_id_10d9d3adf777cfe1_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_articlelist_layout_id_6b1323ac3164fc12_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT test_articlelist_layout_id_6b1323ac3164fc12_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_layout_page_id_32cfd027c0ba39c9_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages
    ADD CONSTRAINT test_layout_page_id_32cfd027c0ba39c9_fk_fluent_pages_urlnode_id FOREIGN KEY (page_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_layoutpage__layout_id_756762b157cacb59_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT test_layoutpage__layout_id_756762b157cacb59_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_urlnode_ptr_id_3038986819ea3a7f_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT test_urlnode_ptr_id_3038986819ea3a7f_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_urlnode_ptr_id_4c0be4710c8865ac_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT test_urlnode_ptr_id_4c0be4710c8865ac_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_barwithlay_layout_id_777458b9d8368e9c_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_barwithlayout
    ADD CONSTRAINT tests_barwithlay_layout_id_777458b9d8368e9c_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_bazwithlay_layout_id_61f850373d403e6c_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_bazwithlayout
    ADD CONSTRAINT tests_bazwithlay_layout_id_61f850373d403e6c_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests_foowithlay_layout_id_2796868910770293_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_foowithlayout
    ADD CONSTRAINT tests_foowithlay_layout_id_2796868910770293_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: workf_content_type_id_f9926f5b5bf1f70_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_workflow_workflowstate
    ADD CONSTRAINT workf_content_type_id_f9926f5b5bf1f70_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

