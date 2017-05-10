--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.11
-- Dumped by pg_dump version 9.5.6

-- Started on 2017-05-10 00:45:18 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 11858)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 4063 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 173 (class 1259 OID 33108)
-- Name: auth_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


--
-- TOC entry 174 (class 1259 OID 33111)
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4064 (class 0 OID 0)
-- Dependencies: 174
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;


--
-- TOC entry 175 (class 1259 OID 33113)
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- TOC entry 176 (class 1259 OID 33116)
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4065 (class 0 OID 0)
-- Dependencies: 176
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;


--
-- TOC entry 177 (class 1259 OID 33118)
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


--
-- TOC entry 178 (class 1259 OID 33121)
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4066 (class 0 OID 0)
-- Dependencies: 178
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;


--
-- TOC entry 347 (class 1259 OID 34821)
-- Name: authtoken_token; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE authtoken_token (
    key character varying(40) NOT NULL,
    created timestamp with time zone NOT NULL,
    user_id integer NOT NULL
);


--
-- TOC entry 179 (class 1259 OID 33123)
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
-- TOC entry 180 (class 1259 OID 33129)
-- Name: celery_taskmeta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE celery_taskmeta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4067 (class 0 OID 0)
-- Dependencies: 180
-- Name: celery_taskmeta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE celery_taskmeta_id_seq OWNED BY celery_taskmeta.id;


--
-- TOC entry 181 (class 1259 OID 33131)
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
-- TOC entry 182 (class 1259 OID 33137)
-- Name: celery_tasksetmeta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE celery_tasksetmeta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4068 (class 0 OID 0)
-- Dependencies: 182
-- Name: celery_tasksetmeta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE celery_tasksetmeta_id_seq OWNED BY celery_tasksetmeta.id;


--
-- TOC entry 355 (class 1259 OID 34974)
-- Name: contentitem_glamkit_sponsors_beginsponsorblockitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_glamkit_sponsors_beginsponsorblockitem (
    contentitem_ptr_id integer NOT NULL,
    text text NOT NULL
);


--
-- TOC entry 356 (class 1259 OID 34982)
-- Name: contentitem_glamkit_sponsors_endsponsorblockitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_glamkit_sponsors_endsponsorblockitem (
    contentitem_ptr_id integer NOT NULL,
    text text NOT NULL
);


--
-- TOC entry 357 (class 1259 OID 34990)
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
-- TOC entry 379 (class 1259 OID 35738)
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
    item_id integer NOT NULL
);


--
-- TOC entry 183 (class 1259 OID 33139)
-- Name: contentitem_icekit_plugins_child_pages_childpageitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_child_pages_childpageitem (
    contentitem_ptr_id integer NOT NULL
);


--
-- TOC entry 382 (class 1259 OID 35768)
-- Name: contentitem_icekit_plugins_contact_person_contactpersonitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_contact_person_contactpersonitem (
    contentitem_ptr_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- TOC entry 383 (class 1259 OID 35784)
-- Name: contentitem_icekit_plugins_content_listing_contentlistingitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_content_listing_contentlistingitem (
    contentitem_ptr_id integer NOT NULL,
    content_type_id integer NOT NULL,
    "limit" integer,
    no_items_message character varying(255)
);


--
-- TOC entry 184 (class 1259 OID 33142)
-- Name: contentitem_icekit_plugins_faq_faqitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_faq_faqitem (
    contentitem_ptr_id integer NOT NULL,
    question text NOT NULL,
    answer text NOT NULL,
    load_open boolean NOT NULL
);


--
-- TOC entry 185 (class 1259 OID 33148)
-- Name: contentitem_icekit_plugins_file_fileitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_file_fileitem (
    contentitem_ptr_id integer NOT NULL,
    file_id integer NOT NULL
);


--
-- TOC entry 186 (class 1259 OID 33151)
-- Name: contentitem_icekit_plugins_horizontal_rule_horizontalruleitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_horizontal_rule_horizontalruleitem (
    contentitem_ptr_id integer NOT NULL
);


--
-- TOC entry 187 (class 1259 OID 33154)
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
-- TOC entry 188 (class 1259 OID 33160)
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
-- TOC entry 189 (class 1259 OID 33171)
-- Name: contentitem_icekit_plugins_map_mapitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_map_mapitem (
    contentitem_ptr_id integer NOT NULL,
    share_url character varying(500) NOT NULL
);


--
-- TOC entry 190 (class 1259 OID 33174)
-- Name: contentitem_icekit_plugins_map_with_text_mapwithtextitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_map_with_text_mapwithtextitem (
    contentitem_ptr_id integer NOT NULL,
    share_url character varying(500) NOT NULL,
    text text NOT NULL,
    map_on_right boolean NOT NULL
);


--
-- TOC entry 192 (class 1259 OID 33188)
-- Name: contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem (
    contentitem_ptr_id integer NOT NULL
);


--
-- TOC entry 193 (class 1259 OID 33191)
-- Name: contentitem_icekit_plugins_page_anchor_pageanchoritem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_page_anchor_pageanchoritem (
    contentitem_ptr_id integer NOT NULL,
    anchor_name character varying(60) NOT NULL
);


--
-- TOC entry 194 (class 1259 OID 33194)
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
-- TOC entry 195 (class 1259 OID 33200)
-- Name: contentitem_icekit_plugins_reusable_form_formitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_reusable_form_formitem (
    contentitem_ptr_id integer NOT NULL,
    form_id integer NOT NULL
);


--
-- TOC entry 196 (class 1259 OID 33203)
-- Name: contentitem_icekit_plugins_slideshow_slideshowitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_icekit_plugins_slideshow_slideshowitem (
    contentitem_ptr_id integer NOT NULL,
    slide_show_id integer NOT NULL
);


--
-- TOC entry 197 (class 1259 OID 33206)
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
-- TOC entry 198 (class 1259 OID 33214)
-- Name: contentitem_iframe_iframeitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_iframe_iframeitem (
    contentitem_ptr_id integer NOT NULL,
    src character varying(200) NOT NULL,
    width character varying(10) NOT NULL,
    height character varying(10) NOT NULL
);


--
-- TOC entry 391 (class 1259 OID 36063)
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
-- TOC entry 394 (class 1259 OID 36101)
-- Name: contentitem_ik_events_todays_occurrences_todaysoccurrences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_ik_events_todays_occurrences_todaysoccurrences (
    contentitem_ptr_id integer NOT NULL,
    include_finished boolean NOT NULL,
    fall_back_to_next_day boolean NOT NULL,
    title character varying(255) NOT NULL
);


--
-- TOC entry 397 (class 1259 OID 36143)
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
-- TOC entry 398 (class 1259 OID 36151)
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
    oneliner_override character varying(255) NOT NULL
);


--
-- TOC entry 399 (class 1259 OID 36159)
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
-- TOC entry 400 (class 1259 OID 36254)
-- Name: contentitem_image_gallery_imagegalleryshowitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_image_gallery_imagegalleryshowitem (
    contentitem_ptr_id integer NOT NULL,
    slide_show_id integer NOT NULL
);


--
-- TOC entry 191 (class 1259 OID 33180)
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
-- TOC entry 199 (class 1259 OID 33217)
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
-- TOC entry 200 (class 1259 OID 33225)
-- Name: contentitem_picture_pictureitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_picture_pictureitem (
    contentitem_ptr_id integer NOT NULL,
    image character varying(100) NOT NULL,
    caption text NOT NULL,
    align character varying(10) NOT NULL,
    url character varying(300) NOT NULL,
    in_new_window boolean NOT NULL
);


--
-- TOC entry 201 (class 1259 OID 33231)
-- Name: contentitem_rawhtml_rawhtmlitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_rawhtml_rawhtmlitem (
    contentitem_ptr_id integer NOT NULL,
    html text NOT NULL
);


--
-- TOC entry 202 (class 1259 OID 33237)
-- Name: contentitem_sharedcontent_sharedcontentitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_sharedcontent_sharedcontentitem (
    contentitem_ptr_id integer NOT NULL,
    shared_content_id integer NOT NULL
);


--
-- TOC entry 203 (class 1259 OID 33240)
-- Name: contentitem_text_textitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contentitem_text_textitem (
    contentitem_ptr_id integer NOT NULL,
    text text NOT NULL,
    text_final text,
    style character varying(255) NOT NULL
);


--
-- TOC entry 204 (class 1259 OID 33246)
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
-- TOC entry 205 (class 1259 OID 33253)
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4069 (class 0 OID 0)
-- Dependencies: 205
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE django_admin_log_id_seq OWNED BY django_admin_log.id;


--
-- TOC entry 206 (class 1259 OID 33255)
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


--
-- TOC entry 207 (class 1259 OID 33258)
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4070 (class 0 OID 0)
-- Dependencies: 207
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;


--
-- TOC entry 208 (class 1259 OID 33260)
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


--
-- TOC entry 209 (class 1259 OID 33266)
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4071 (class 0 OID 0)
-- Dependencies: 209
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE django_migrations_id_seq OWNED BY django_migrations.id;


--
-- TOC entry 210 (class 1259 OID 33268)
-- Name: django_redirect; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE django_redirect (
    id integer NOT NULL,
    site_id integer NOT NULL,
    old_path character varying(200) NOT NULL,
    new_path character varying(200) NOT NULL
);


--
-- TOC entry 211 (class 1259 OID 33271)
-- Name: django_redirect_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE django_redirect_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4072 (class 0 OID 0)
-- Dependencies: 211
-- Name: django_redirect_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE django_redirect_id_seq OWNED BY django_redirect.id;


--
-- TOC entry 212 (class 1259 OID 33273)
-- Name: django_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


--
-- TOC entry 213 (class 1259 OID 33279)
-- Name: django_site; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


--
-- TOC entry 214 (class 1259 OID 33282)
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE django_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4073 (class 0 OID 0)
-- Dependencies: 214
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE django_site_id_seq OWNED BY django_site.id;


--
-- TOC entry 215 (class 1259 OID 33284)
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
-- TOC entry 216 (class 1259 OID 33287)
-- Name: djcelery_crontabschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE djcelery_crontabschedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4074 (class 0 OID 0)
-- Dependencies: 216
-- Name: djcelery_crontabschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE djcelery_crontabschedule_id_seq OWNED BY djcelery_crontabschedule.id;


--
-- TOC entry 217 (class 1259 OID 33289)
-- Name: djcelery_intervalschedule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE djcelery_intervalschedule (
    id integer NOT NULL,
    every integer NOT NULL,
    period character varying(24) NOT NULL
);


--
-- TOC entry 218 (class 1259 OID 33292)
-- Name: djcelery_intervalschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE djcelery_intervalschedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4075 (class 0 OID 0)
-- Dependencies: 218
-- Name: djcelery_intervalschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE djcelery_intervalschedule_id_seq OWNED BY djcelery_intervalschedule.id;


--
-- TOC entry 219 (class 1259 OID 33294)
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
-- TOC entry 220 (class 1259 OID 33301)
-- Name: djcelery_periodictask_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE djcelery_periodictask_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4076 (class 0 OID 0)
-- Dependencies: 220
-- Name: djcelery_periodictask_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE djcelery_periodictask_id_seq OWNED BY djcelery_periodictask.id;


--
-- TOC entry 221 (class 1259 OID 33303)
-- Name: djcelery_periodictasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE djcelery_periodictasks (
    ident smallint NOT NULL,
    last_update timestamp with time zone NOT NULL
);


--
-- TOC entry 222 (class 1259 OID 33306)
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
-- TOC entry 223 (class 1259 OID 33312)
-- Name: djcelery_taskstate_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE djcelery_taskstate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4077 (class 0 OID 0)
-- Dependencies: 223
-- Name: djcelery_taskstate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE djcelery_taskstate_id_seq OWNED BY djcelery_taskstate.id;


--
-- TOC entry 224 (class 1259 OID 33314)
-- Name: djcelery_workerstate; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE djcelery_workerstate (
    id integer NOT NULL,
    hostname character varying(255) NOT NULL,
    last_heartbeat timestamp with time zone
);


--
-- TOC entry 225 (class 1259 OID 33317)
-- Name: djcelery_workerstate_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE djcelery_workerstate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4078 (class 0 OID 0)
-- Dependencies: 225
-- Name: djcelery_workerstate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE djcelery_workerstate_id_seq OWNED BY djcelery_workerstate.id;


--
-- TOC entry 226 (class 1259 OID 33319)
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
-- TOC entry 227 (class 1259 OID 33325)
-- Name: djkombu_message_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE djkombu_message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4079 (class 0 OID 0)
-- Dependencies: 227
-- Name: djkombu_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE djkombu_message_id_seq OWNED BY djkombu_message.id;


--
-- TOC entry 228 (class 1259 OID 33327)
-- Name: djkombu_queue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE djkombu_queue (
    id integer NOT NULL,
    name character varying(200) NOT NULL
);


--
-- TOC entry 229 (class 1259 OID 33330)
-- Name: djkombu_queue_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE djkombu_queue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4080 (class 0 OID 0)
-- Dependencies: 229
-- Name: djkombu_queue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE djkombu_queue_id_seq OWNED BY djkombu_queue.id;


--
-- TOC entry 230 (class 1259 OID 33332)
-- Name: easy_thumbnails_source; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE easy_thumbnails_source (
    id integer NOT NULL,
    storage_hash character varying(40) NOT NULL,
    name character varying(255) NOT NULL,
    modified timestamp with time zone NOT NULL
);


--
-- TOC entry 231 (class 1259 OID 33335)
-- Name: easy_thumbnails_source_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE easy_thumbnails_source_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4081 (class 0 OID 0)
-- Dependencies: 231
-- Name: easy_thumbnails_source_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE easy_thumbnails_source_id_seq OWNED BY easy_thumbnails_source.id;


--
-- TOC entry 232 (class 1259 OID 33337)
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
-- TOC entry 233 (class 1259 OID 33340)
-- Name: easy_thumbnails_thumbnail_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE easy_thumbnails_thumbnail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4082 (class 0 OID 0)
-- Dependencies: 233
-- Name: easy_thumbnails_thumbnail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE easy_thumbnails_thumbnail_id_seq OWNED BY easy_thumbnails_thumbnail.id;


--
-- TOC entry 234 (class 1259 OID 33342)
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
-- TOC entry 235 (class 1259 OID 33347)
-- Name: easy_thumbnails_thumbnaildimensions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE easy_thumbnails_thumbnaildimensions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4083 (class 0 OID 0)
-- Dependencies: 235
-- Name: easy_thumbnails_thumbnaildimensions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE easy_thumbnails_thumbnaildimensions_id_seq OWNED BY easy_thumbnails_thumbnaildimensions.id;


--
-- TOC entry 236 (class 1259 OID 33349)
-- Name: icekit_plugins_file_file_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_plugins_file_file_categories (
    id integer NOT NULL,
    file_id integer NOT NULL,
    mediacategory_id integer NOT NULL
);


--
-- TOC entry 237 (class 1259 OID 33352)
-- Name: file_file_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE file_file_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4084 (class 0 OID 0)
-- Dependencies: 237
-- Name: file_file_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE file_file_categories_id_seq OWNED BY icekit_plugins_file_file_categories.id;


--
-- TOC entry 238 (class 1259 OID 33354)
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
-- TOC entry 239 (class 1259 OID 33360)
-- Name: file_file_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE file_file_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4085 (class 0 OID 0)
-- Dependencies: 239
-- Name: file_file_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE file_file_id_seq OWNED BY icekit_plugins_file_file.id;


--
-- TOC entry 240 (class 1259 OID 33362)
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
-- TOC entry 241 (class 1259 OID 33365)
-- Name: fluent_contents_contentitem_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fluent_contents_contentitem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4086 (class 0 OID 0)
-- Dependencies: 241
-- Name: fluent_contents_contentitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fluent_contents_contentitem_id_seq OWNED BY fluent_contents_contentitem.id;


--
-- TOC entry 242 (class 1259 OID 33367)
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
-- TOC entry 243 (class 1259 OID 33370)
-- Name: fluent_contents_placeholder_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fluent_contents_placeholder_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4087 (class 0 OID 0)
-- Dependencies: 243
-- Name: fluent_contents_placeholder_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fluent_contents_placeholder_id_seq OWNED BY fluent_contents_placeholder.id;


--
-- TOC entry 244 (class 1259 OID 33372)
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
-- TOC entry 245 (class 1259 OID 33378)
-- Name: fluent_pages_htmlpage_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fluent_pages_htmlpage_translation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4088 (class 0 OID 0)
-- Dependencies: 245
-- Name: fluent_pages_htmlpage_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fluent_pages_htmlpage_translation_id_seq OWNED BY fluent_pages_htmlpage_translation.id;


--
-- TOC entry 246 (class 1259 OID 33380)
-- Name: fluent_pages_pagelayout; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fluent_pages_pagelayout (
    id integer NOT NULL,
    key character varying(50) NOT NULL,
    title character varying(255) NOT NULL,
    template_path character varying(100) NOT NULL
);


--
-- TOC entry 247 (class 1259 OID 33383)
-- Name: fluent_pages_pagelayout_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fluent_pages_pagelayout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4089 (class 0 OID 0)
-- Dependencies: 247
-- Name: fluent_pages_pagelayout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fluent_pages_pagelayout_id_seq OWNED BY fluent_pages_pagelayout.id;


--
-- TOC entry 248 (class 1259 OID 33385)
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
-- TOC entry 249 (class 1259 OID 33392)
-- Name: fluent_pages_urlnode_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fluent_pages_urlnode_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4090 (class 0 OID 0)
-- Dependencies: 249
-- Name: fluent_pages_urlnode_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fluent_pages_urlnode_id_seq OWNED BY fluent_pages_urlnode.id;


--
-- TOC entry 250 (class 1259 OID 33394)
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
-- TOC entry 251 (class 1259 OID 33400)
-- Name: fluent_pages_urlnode_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fluent_pages_urlnode_translation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4091 (class 0 OID 0)
-- Dependencies: 251
-- Name: fluent_pages_urlnode_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fluent_pages_urlnode_translation_id_seq OWNED BY fluent_pages_urlnode_translation.id;


--
-- TOC entry 252 (class 1259 OID 33402)
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
-- TOC entry 253 (class 1259 OID 33408)
-- Name: forms_field_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forms_field_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4092 (class 0 OID 0)
-- Dependencies: 253
-- Name: forms_field_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forms_field_id_seq OWNED BY forms_field.id;


--
-- TOC entry 254 (class 1259 OID 33410)
-- Name: forms_fieldentry; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE forms_fieldentry (
    id integer NOT NULL,
    field_id integer NOT NULL,
    value character varying(2000),
    entry_id integer NOT NULL
);


--
-- TOC entry 255 (class 1259 OID 33416)
-- Name: forms_fieldentry_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forms_fieldentry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4093 (class 0 OID 0)
-- Dependencies: 255
-- Name: forms_fieldentry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forms_fieldentry_id_seq OWNED BY forms_fieldentry.id;


--
-- TOC entry 256 (class 1259 OID 33418)
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
-- TOC entry 257 (class 1259 OID 33424)
-- Name: forms_form_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forms_form_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4094 (class 0 OID 0)
-- Dependencies: 257
-- Name: forms_form_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forms_form_id_seq OWNED BY forms_form.id;


--
-- TOC entry 258 (class 1259 OID 33426)
-- Name: forms_form_sites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE forms_form_sites (
    id integer NOT NULL,
    form_id integer NOT NULL,
    site_id integer NOT NULL
);


--
-- TOC entry 259 (class 1259 OID 33429)
-- Name: forms_form_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forms_form_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4095 (class 0 OID 0)
-- Dependencies: 259
-- Name: forms_form_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forms_form_sites_id_seq OWNED BY forms_form_sites.id;


--
-- TOC entry 260 (class 1259 OID 33431)
-- Name: forms_formentry; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE forms_formentry (
    id integer NOT NULL,
    entry_time timestamp with time zone NOT NULL,
    form_id integer NOT NULL
);


--
-- TOC entry 261 (class 1259 OID 33434)
-- Name: forms_formentry_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forms_formentry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4096 (class 0 OID 0)
-- Dependencies: 261
-- Name: forms_formentry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forms_formentry_id_seq OWNED BY forms_formentry.id;


--
-- TOC entry 350 (class 1259 OID 34929)
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
-- TOC entry 349 (class 1259 OID 34927)
-- Name: glamkit_collections_country_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE glamkit_collections_country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4097 (class 0 OID 0)
-- Dependencies: 349
-- Name: glamkit_collections_country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE glamkit_collections_country_id_seq OWNED BY glamkit_collections_country.id;


--
-- TOC entry 352 (class 1259 OID 34940)
-- Name: glamkit_collections_geographiclocation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE glamkit_collections_geographiclocation (
    id integer NOT NULL,
    state_province character varying(255) NOT NULL,
    city character varying(255) NOT NULL,
    neighborhood character varying(255) NOT NULL,
    colloquial_historical character varying(255) NOT NULL,
    country_id integer
);


--
-- TOC entry 351 (class 1259 OID 34938)
-- Name: glamkit_collections_geographiclocation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE glamkit_collections_geographiclocation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4098 (class 0 OID 0)
-- Dependencies: 351
-- Name: glamkit_collections_geographiclocation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE glamkit_collections_geographiclocation_id_seq OWNED BY glamkit_collections_geographiclocation.id;


--
-- TOC entry 354 (class 1259 OID 34959)
-- Name: glamkit_sponsors_sponsor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE glamkit_sponsors_sponsor (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    logo_id integer NOT NULL
);


--
-- TOC entry 353 (class 1259 OID 34957)
-- Name: glamkit_sponsors_sponsor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE glamkit_sponsors_sponsor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4099 (class 0 OID 0)
-- Dependencies: 353
-- Name: glamkit_sponsors_sponsor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE glamkit_sponsors_sponsor_id_seq OWNED BY glamkit_sponsors_sponsor.id;


--
-- TOC entry 359 (class 1259 OID 35018)
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
    hero_image_id integer
);


--
-- TOC entry 358 (class 1259 OID 35016)
-- Name: icekit_article_article_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_article_article_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4100 (class 0 OID 0)
-- Dependencies: 358
-- Name: icekit_article_article_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_article_article_id_seq OWNED BY icekit_article_article.id;


--
-- TOC entry 360 (class 1259 OID 35027)
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
    list_image character varying(100) NOT NULL
);


--
-- TOC entry 365 (class 1259 OID 35271)
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
    list_image character varying(100) NOT NULL
);


--
-- TOC entry 364 (class 1259 OID 35260)
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
    list_image character varying(100) NOT NULL
);


--
-- TOC entry 363 (class 1259 OID 35258)
-- Name: icekit_authors_author_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_authors_author_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4101 (class 0 OID 0)
-- Dependencies: 363
-- Name: icekit_authors_author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_authors_author_id_seq OWNED BY icekit_authors_author.id;


--
-- TOC entry 374 (class 1259 OID 35501)
-- Name: icekit_event_types_simple_simpleevent; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_event_types_simple_simpleevent (
    eventbase_ptr_id integer NOT NULL,
    layout_id integer
);


--
-- TOC entry 367 (class 1259 OID 35401)
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
    human_times character varying(255) NOT NULL
);


--
-- TOC entry 366 (class 1259 OID 35399)
-- Name: icekit_events_eventbase_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_events_eventbase_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4102 (class 0 OID 0)
-- Dependencies: 366
-- Name: icekit_events_eventbase_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_events_eventbase_id_seq OWNED BY icekit_events_eventbase.id;


--
-- TOC entry 378 (class 1259 OID 35573)
-- Name: icekit_events_eventbase_secondary_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_events_eventbase_secondary_types (
    id integer NOT NULL,
    eventbase_id integer NOT NULL,
    eventtype_id integer NOT NULL
);


--
-- TOC entry 377 (class 1259 OID 35571)
-- Name: icekit_events_eventbase_secondary_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_events_eventbase_secondary_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4103 (class 0 OID 0)
-- Dependencies: 377
-- Name: icekit_events_eventbase_secondary_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_events_eventbase_secondary_types_id_seq OWNED BY icekit_events_eventbase_secondary_types.id;


--
-- TOC entry 369 (class 1259 OID 35414)
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
-- TOC entry 368 (class 1259 OID 35412)
-- Name: icekit_events_eventrepeatsgenerator_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_events_eventrepeatsgenerator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4104 (class 0 OID 0)
-- Dependencies: 368
-- Name: icekit_events_eventrepeatsgenerator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_events_eventrepeatsgenerator_id_seq OWNED BY icekit_events_eventrepeatsgenerator.id;


--
-- TOC entry 376 (class 1259 OID 35562)
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
-- TOC entry 375 (class 1259 OID 35560)
-- Name: icekit_events_eventtype_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_events_eventtype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4105 (class 0 OID 0)
-- Dependencies: 375
-- Name: icekit_events_eventtype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_events_eventtype_id_seq OWNED BY icekit_events_eventtype.id;


--
-- TOC entry 371 (class 1259 OID 35425)
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
-- TOC entry 370 (class 1259 OID 35423)
-- Name: icekit_events_occurrence_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_events_occurrence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4106 (class 0 OID 0)
-- Dependencies: 370
-- Name: icekit_events_occurrence_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_events_occurrence_id_seq OWNED BY icekit_events_occurrence.id;


--
-- TOC entry 373 (class 1259 OID 35433)
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
-- TOC entry 372 (class 1259 OID 35431)
-- Name: icekit_events_recurrencerule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_events_recurrencerule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4107 (class 0 OID 0)
-- Dependencies: 372
-- Name: icekit_events_recurrencerule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_events_recurrencerule_id_seq OWNED BY icekit_events_recurrencerule.id;


--
-- TOC entry 262 (class 1259 OID 33436)
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
-- TOC entry 263 (class 1259 OID 33442)
-- Name: icekit_layout_content_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_layout_content_types (
    id integer NOT NULL,
    layout_id integer NOT NULL,
    contenttype_id integer NOT NULL
);


--
-- TOC entry 264 (class 1259 OID 33445)
-- Name: icekit_layout_content_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_layout_content_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4108 (class 0 OID 0)
-- Dependencies: 264
-- Name: icekit_layout_content_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_layout_content_types_id_seq OWNED BY icekit_layout_content_types.id;


--
-- TOC entry 265 (class 1259 OID 33447)
-- Name: icekit_layout_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_layout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4109 (class 0 OID 0)
-- Dependencies: 265
-- Name: icekit_layout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_layout_id_seq OWNED BY icekit_layout.id;


--
-- TOC entry 299 (class 1259 OID 33544)
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
    list_image character varying(100) NOT NULL
);


--
-- TOC entry 266 (class 1259 OID 33449)
-- Name: icekit_mediacategory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_mediacategory (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL
);


--
-- TOC entry 267 (class 1259 OID 33452)
-- Name: icekit_mediacategory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_mediacategory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4110 (class 0 OID 0)
-- Dependencies: 267
-- Name: icekit_mediacategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_mediacategory_id_seq OWNED BY icekit_mediacategory.id;


--
-- TOC entry 381 (class 1259 OID 35759)
-- Name: icekit_plugins_contact_person_contactperson; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_plugins_contact_person_contactperson (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    phone character varying(255) NOT NULL,
    email character varying(255) NOT NULL
);


--
-- TOC entry 380 (class 1259 OID 35757)
-- Name: icekit_plugins_contact_person_contactperson_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_plugins_contact_person_contactperson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4111 (class 0 OID 0)
-- Dependencies: 380
-- Name: icekit_plugins_contact_person_contactperson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_plugins_contact_person_contactperson_id_seq OWNED BY icekit_plugins_contact_person_contactperson.id;


--
-- TOC entry 268 (class 1259 OID 33454)
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
    CONSTRAINT icekit_plugins_i_maximum_dimension_pixels_89d83a8e1ddecb0_check CHECK ((maximum_dimension_pixels >= 0)),
    CONSTRAINT icekit_plugins_image_image_height_check CHECK ((height >= 0)),
    CONSTRAINT icekit_plugins_image_image_width_check CHECK ((width >= 0))
);


--
-- TOC entry 269 (class 1259 OID 33460)
-- Name: icekit_plugins_image_image_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_plugins_image_image_categories (
    id integer NOT NULL,
    image_id integer NOT NULL,
    mediacategory_id integer NOT NULL
);


--
-- TOC entry 362 (class 1259 OID 35218)
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
-- TOC entry 361 (class 1259 OID 35216)
-- Name: icekit_plugins_image_imagerepurposeconfig_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_plugins_image_imagerepurposeconfig_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4112 (class 0 OID 0)
-- Dependencies: 361
-- Name: icekit_plugins_image_imagerepurposeconfig_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_plugins_image_imagerepurposeconfig_id_seq OWNED BY icekit_plugins_image_imagerepurposeconfig.id;


--
-- TOC entry 270 (class 1259 OID 33463)
-- Name: icekit_plugins_slideshow_slideshow; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_plugins_slideshow_slideshow (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    show_title boolean NOT NULL,
    publishing_is_draft boolean NOT NULL,
    publishing_linked_id integer,
    publishing_modified_at timestamp with time zone NOT NULL,
    publishing_published_at timestamp with time zone
);


--
-- TOC entry 271 (class 1259 OID 33466)
-- Name: icekit_plugins_slideshow_slideshow_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_plugins_slideshow_slideshow_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4113 (class 0 OID 0)
-- Dependencies: 271
-- Name: icekit_plugins_slideshow_slideshow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_plugins_slideshow_slideshow_id_seq OWNED BY icekit_plugins_slideshow_slideshow.id;


--
-- TOC entry 385 (class 1259 OID 35850)
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
-- TOC entry 384 (class 1259 OID 35848)
-- Name: icekit_press_releases_pressrelease_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_press_releases_pressrelease_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4114 (class 0 OID 0)
-- Dependencies: 384
-- Name: icekit_press_releases_pressrelease_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_press_releases_pressrelease_id_seq OWNED BY icekit_press_releases_pressrelease.id;


--
-- TOC entry 387 (class 1259 OID 35861)
-- Name: icekit_press_releases_pressreleasecategory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE icekit_press_releases_pressreleasecategory (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- TOC entry 386 (class 1259 OID 35859)
-- Name: icekit_press_releases_pressreleasecategory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icekit_press_releases_pressreleasecategory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4115 (class 0 OID 0)
-- Dependencies: 386
-- Name: icekit_press_releases_pressreleasecategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icekit_press_releases_pressreleasecategory_id_seq OWNED BY icekit_press_releases_pressreleasecategory.id;


--
-- TOC entry 301 (class 1259 OID 33550)
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
    default_search_type character varying(255) NOT NULL
);


--
-- TOC entry 390 (class 1259 OID 36026)
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
-- TOC entry 393 (class 1259 OID 36081)
-- Name: ik_event_listing_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ik_event_listing_types (
    id integer NOT NULL,
    eventcontentlistingitem_id integer NOT NULL,
    eventtype_id integer NOT NULL
);


--
-- TOC entry 392 (class 1259 OID 36079)
-- Name: ik_event_listing_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ik_event_listing_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4116 (class 0 OID 0)
-- Dependencies: 392
-- Name: ik_event_listing_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ik_event_listing_types_id_seq OWNED BY ik_event_listing_types.id;


--
-- TOC entry 396 (class 1259 OID 36108)
-- Name: ik_todays_occurrences_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ik_todays_occurrences_types (
    id integer NOT NULL,
    todaysoccurrences_id integer NOT NULL,
    eventtype_id integer NOT NULL
);


--
-- TOC entry 395 (class 1259 OID 36106)
-- Name: ik_todays_occurrences_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ik_todays_occurrences_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4117 (class 0 OID 0)
-- Dependencies: 395
-- Name: ik_todays_occurrences_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ik_todays_occurrences_types_id_seq OWNED BY ik_todays_occurrences_types.id;


--
-- TOC entry 272 (class 1259 OID 33468)
-- Name: image_image_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE image_image_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4118 (class 0 OID 0)
-- Dependencies: 272
-- Name: image_image_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE image_image_categories_id_seq OWNED BY icekit_plugins_image_image_categories.id;


--
-- TOC entry 273 (class 1259 OID 33470)
-- Name: image_image_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE image_image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4119 (class 0 OID 0)
-- Dependencies: 273
-- Name: image_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE image_image_id_seq OWNED BY icekit_plugins_image_image.id;


--
-- TOC entry 274 (class 1259 OID 33472)
-- Name: model_settings_boolean; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_boolean (
    setting_ptr_id integer NOT NULL,
    value boolean NOT NULL
);


--
-- TOC entry 275 (class 1259 OID 33475)
-- Name: model_settings_date; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_date (
    setting_ptr_id integer NOT NULL,
    value date NOT NULL
);


--
-- TOC entry 276 (class 1259 OID 33478)
-- Name: model_settings_datetime; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_datetime (
    setting_ptr_id integer NOT NULL,
    value timestamp with time zone NOT NULL
);


--
-- TOC entry 277 (class 1259 OID 33481)
-- Name: model_settings_decimal; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_decimal (
    setting_ptr_id integer NOT NULL,
    value numeric(20,10) NOT NULL
);


--
-- TOC entry 278 (class 1259 OID 33484)
-- Name: model_settings_file; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_file (
    setting_ptr_id integer NOT NULL,
    value character varying(100) NOT NULL
);


--
-- TOC entry 279 (class 1259 OID 33487)
-- Name: model_settings_float; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_float (
    setting_ptr_id integer NOT NULL,
    value double precision NOT NULL
);


--
-- TOC entry 280 (class 1259 OID 33490)
-- Name: model_settings_image; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_image (
    setting_ptr_id integer NOT NULL,
    value character varying(100) NOT NULL
);


--
-- TOC entry 281 (class 1259 OID 33493)
-- Name: model_settings_integer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_integer (
    setting_ptr_id integer NOT NULL,
    value integer NOT NULL
);


--
-- TOC entry 282 (class 1259 OID 33496)
-- Name: model_settings_setting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_setting (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    polymorphic_ctype_id integer
);


--
-- TOC entry 283 (class 1259 OID 33499)
-- Name: model_settings_setting_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE model_settings_setting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4120 (class 0 OID 0)
-- Dependencies: 283
-- Name: model_settings_setting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE model_settings_setting_id_seq OWNED BY model_settings_setting.id;


--
-- TOC entry 284 (class 1259 OID 33501)
-- Name: model_settings_text; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_text (
    setting_ptr_id integer NOT NULL,
    value character varying(255) NOT NULL
);


--
-- TOC entry 285 (class 1259 OID 33504)
-- Name: model_settings_time; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE model_settings_time (
    setting_ptr_id integer NOT NULL,
    value time without time zone NOT NULL
);


--
-- TOC entry 286 (class 1259 OID 33507)
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
-- TOC entry 287 (class 1259 OID 33511)
-- Name: notifications_followerinformation_followers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications_followerinformation_followers (
    id integer NOT NULL,
    followerinformation_id integer NOT NULL,
    user_id integer NOT NULL
);


--
-- TOC entry 288 (class 1259 OID 33514)
-- Name: notifications_followerinformation_followers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_followerinformation_followers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4121 (class 0 OID 0)
-- Dependencies: 288
-- Name: notifications_followerinformation_followers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_followerinformation_followers_id_seq OWNED BY notifications_followerinformation_followers.id;


--
-- TOC entry 289 (class 1259 OID 33516)
-- Name: notifications_followerinformation_group_followers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications_followerinformation_group_followers (
    id integer NOT NULL,
    followerinformation_id integer NOT NULL,
    group_id integer NOT NULL
);


--
-- TOC entry 290 (class 1259 OID 33519)
-- Name: notifications_followerinformation_group_followers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_followerinformation_group_followers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4122 (class 0 OID 0)
-- Dependencies: 290
-- Name: notifications_followerinformation_group_followers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_followerinformation_group_followers_id_seq OWNED BY notifications_followerinformation_group_followers.id;


--
-- TOC entry 291 (class 1259 OID 33521)
-- Name: notifications_followerinformation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_followerinformation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4123 (class 0 OID 0)
-- Dependencies: 291
-- Name: notifications_followerinformation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_followerinformation_id_seq OWNED BY notifications_followerinformation.id;


--
-- TOC entry 292 (class 1259 OID 33523)
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
-- TOC entry 293 (class 1259 OID 33526)
-- Name: notifications_hasreadmessage_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_hasreadmessage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4124 (class 0 OID 0)
-- Dependencies: 293
-- Name: notifications_hasreadmessage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_hasreadmessage_id_seq OWNED BY notifications_hasreadmessage.id;


--
-- TOC entry 294 (class 1259 OID 33528)
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
-- TOC entry 295 (class 1259 OID 33534)
-- Name: notifications_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4125 (class 0 OID 0)
-- Dependencies: 295
-- Name: notifications_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_notification_id_seq OWNED BY notifications_notification.id;


--
-- TOC entry 296 (class 1259 OID 33536)
-- Name: notifications_notificationsetting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications_notificationsetting (
    id integer NOT NULL,
    notification_type character varying(20) NOT NULL,
    user_id integer NOT NULL
);


--
-- TOC entry 297 (class 1259 OID 33539)
-- Name: notifications_notificationsetting_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_notificationsetting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4126 (class 0 OID 0)
-- Dependencies: 297
-- Name: notifications_notificationsetting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_notificationsetting_id_seq OWNED BY notifications_notificationsetting.id;


--
-- TOC entry 348 (class 1259 OID 34867)
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
    list_image character varying(100) NOT NULL
);


--
-- TOC entry 298 (class 1259 OID 33541)
-- Name: pagetype_fluentpage_fluentpage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pagetype_fluentpage_fluentpage (
    urlnode_ptr_id integer NOT NULL,
    layout_id integer
);


--
-- TOC entry 388 (class 1259 OID 35930)
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
    list_image character varying(100) NOT NULL
);


--
-- TOC entry 300 (class 1259 OID 33547)
-- Name: pagetype_redirectnode_redirectnode; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pagetype_redirectnode_redirectnode (
    urlnode_ptr_id integer NOT NULL
);


--
-- TOC entry 302 (class 1259 OID 33553)
-- Name: pagetype_tests_unpublishablelayoutpage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pagetype_tests_unpublishablelayoutpage (
    urlnode_ptr_id integer NOT NULL,
    layout_id integer
);


--
-- TOC entry 303 (class 1259 OID 33556)
-- Name: polymorphic_auth_email_emailuser; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE polymorphic_auth_email_emailuser (
    user_ptr_id integer NOT NULL,
    email character varying(254) NOT NULL
);


--
-- TOC entry 304 (class 1259 OID 33559)
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
-- TOC entry 305 (class 1259 OID 33565)
-- Name: polymorphic_auth_user_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE polymorphic_auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


--
-- TOC entry 306 (class 1259 OID 33568)
-- Name: polymorphic_auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE polymorphic_auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4127 (class 0 OID 0)
-- Dependencies: 306
-- Name: polymorphic_auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE polymorphic_auth_user_groups_id_seq OWNED BY polymorphic_auth_user_groups.id;


--
-- TOC entry 307 (class 1259 OID 33570)
-- Name: polymorphic_auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE polymorphic_auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4128 (class 0 OID 0)
-- Dependencies: 307
-- Name: polymorphic_auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE polymorphic_auth_user_id_seq OWNED BY polymorphic_auth_user.id;


--
-- TOC entry 308 (class 1259 OID 33572)
-- Name: polymorphic_auth_user_user_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE polymorphic_auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- TOC entry 309 (class 1259 OID 33575)
-- Name: polymorphic_auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE polymorphic_auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4129 (class 0 OID 0)
-- Dependencies: 309
-- Name: polymorphic_auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE polymorphic_auth_user_user_permissions_id_seq OWNED BY polymorphic_auth_user_user_permissions.id;


--
-- TOC entry 310 (class 1259 OID 33577)
-- Name: post_office_attachment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE post_office_attachment (
    id integer NOT NULL,
    file character varying(100) NOT NULL,
    name character varying(255) NOT NULL
);


--
-- TOC entry 311 (class 1259 OID 33580)
-- Name: post_office_attachment_emails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE post_office_attachment_emails (
    id integer NOT NULL,
    attachment_id integer NOT NULL,
    email_id integer NOT NULL
);


--
-- TOC entry 312 (class 1259 OID 33583)
-- Name: post_office_attachment_emails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE post_office_attachment_emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4130 (class 0 OID 0)
-- Dependencies: 312
-- Name: post_office_attachment_emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE post_office_attachment_emails_id_seq OWNED BY post_office_attachment_emails.id;


--
-- TOC entry 313 (class 1259 OID 33585)
-- Name: post_office_attachment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE post_office_attachment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4131 (class 0 OID 0)
-- Dependencies: 313
-- Name: post_office_attachment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE post_office_attachment_id_seq OWNED BY post_office_attachment.id;


--
-- TOC entry 314 (class 1259 OID 33587)
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
-- TOC entry 315 (class 1259 OID 33595)
-- Name: post_office_email_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE post_office_email_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4132 (class 0 OID 0)
-- Dependencies: 315
-- Name: post_office_email_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE post_office_email_id_seq OWNED BY post_office_email.id;


--
-- TOC entry 316 (class 1259 OID 33597)
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
-- TOC entry 317 (class 1259 OID 33603)
-- Name: post_office_emailtemplate_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE post_office_emailtemplate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4133 (class 0 OID 0)
-- Dependencies: 317
-- Name: post_office_emailtemplate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE post_office_emailtemplate_id_seq OWNED BY post_office_emailtemplate.id;


--
-- TOC entry 318 (class 1259 OID 33605)
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
-- TOC entry 319 (class 1259 OID 33612)
-- Name: post_office_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE post_office_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4134 (class 0 OID 0)
-- Dependencies: 319
-- Name: post_office_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE post_office_log_id_seq OWNED BY post_office_log.id;


--
-- TOC entry 320 (class 1259 OID 33614)
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
-- TOC entry 321 (class 1259 OID 33617)
-- Name: redirectnode_redirectnode_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE redirectnode_redirectnode_translation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4135 (class 0 OID 0)
-- Dependencies: 321
-- Name: redirectnode_redirectnode_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE redirectnode_redirectnode_translation_id_seq OWNED BY redirectnode_redirectnode_translation.id;


--
-- TOC entry 322 (class 1259 OID 33619)
-- Name: response_pages_responsepage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE response_pages_responsepage (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    type character varying(5) NOT NULL,
    is_active boolean NOT NULL
);


--
-- TOC entry 323 (class 1259 OID 33622)
-- Name: response_pages_responsepage_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE response_pages_responsepage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4136 (class 0 OID 0)
-- Dependencies: 323
-- Name: response_pages_responsepage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE response_pages_responsepage_id_seq OWNED BY response_pages_responsepage.id;


--
-- TOC entry 324 (class 1259 OID 33624)
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
-- TOC entry 325 (class 1259 OID 33630)
-- Name: reversion_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reversion_revision_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4137 (class 0 OID 0)
-- Dependencies: 325
-- Name: reversion_revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reversion_revision_id_seq OWNED BY reversion_revision.id;


--
-- TOC entry 326 (class 1259 OID 33632)
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
-- TOC entry 327 (class 1259 OID 33638)
-- Name: reversion_version_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reversion_version_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4138 (class 0 OID 0)
-- Dependencies: 327
-- Name: reversion_version_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reversion_version_id_seq OWNED BY reversion_version.id;


--
-- TOC entry 328 (class 1259 OID 33640)
-- Name: sharedcontent_sharedcontent; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sharedcontent_sharedcontent (
    id integer NOT NULL,
    slug character varying(50) NOT NULL,
    is_cross_site boolean NOT NULL,
    parent_site_id integer NOT NULL
);


--
-- TOC entry 329 (class 1259 OID 33643)
-- Name: sharedcontent_sharedcontent_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sharedcontent_sharedcontent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4139 (class 0 OID 0)
-- Dependencies: 329
-- Name: sharedcontent_sharedcontent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sharedcontent_sharedcontent_id_seq OWNED BY sharedcontent_sharedcontent.id;


--
-- TOC entry 330 (class 1259 OID 33645)
-- Name: sharedcontent_sharedcontent_translation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sharedcontent_sharedcontent_translation (
    id integer NOT NULL,
    language_code character varying(15) NOT NULL,
    title character varying(200) NOT NULL,
    master_id integer
);


--
-- TOC entry 331 (class 1259 OID 33648)
-- Name: sharedcontent_sharedcontent_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sharedcontent_sharedcontent_translation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4140 (class 0 OID 0)
-- Dependencies: 331
-- Name: sharedcontent_sharedcontent_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sharedcontent_sharedcontent_translation_id_seq OWNED BY sharedcontent_sharedcontent_translation.id;


--
-- TOC entry 332 (class 1259 OID 33650)
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
-- TOC entry 333 (class 1259 OID 33656)
-- Name: test_article_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE test_article_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4141 (class 0 OID 0)
-- Dependencies: 333
-- Name: test_article_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE test_article_id_seq OWNED BY test_article.id;


--
-- TOC entry 401 (class 1259 OID 36369)
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
    list_image character varying(100) NOT NULL
);


--
-- TOC entry 334 (class 1259 OID 33658)
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
    list_image character varying(100) NOT NULL
);


--
-- TOC entry 335 (class 1259 OID 33661)
-- Name: test_layoutpage_with_related_related_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE test_layoutpage_with_related_related_pages (
    id integer NOT NULL,
    layoutpagewithrelatedpages_id integer NOT NULL,
    page_id integer NOT NULL
);


--
-- TOC entry 336 (class 1259 OID 33664)
-- Name: test_layoutpage_with_related_related_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE test_layoutpage_with_related_related_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4142 (class 0 OID 0)
-- Dependencies: 336
-- Name: test_layoutpage_with_related_related_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE test_layoutpage_with_related_related_pages_id_seq OWNED BY test_layoutpage_with_related_related_pages.id;


--
-- TOC entry 337 (class 1259 OID 33666)
-- Name: tests_barwithlayout; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tests_barwithlayout (
    id integer NOT NULL,
    layout_id integer
);


--
-- TOC entry 338 (class 1259 OID 33669)
-- Name: tests_barwithlayout_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_barwithlayout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4143 (class 0 OID 0)
-- Dependencies: 338
-- Name: tests_barwithlayout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_barwithlayout_id_seq OWNED BY tests_barwithlayout.id;


--
-- TOC entry 339 (class 1259 OID 33671)
-- Name: tests_basemodel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tests_basemodel (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL
);


--
-- TOC entry 340 (class 1259 OID 33674)
-- Name: tests_basemodel_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_basemodel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4144 (class 0 OID 0)
-- Dependencies: 340
-- Name: tests_basemodel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_basemodel_id_seq OWNED BY tests_basemodel.id;


--
-- TOC entry 341 (class 1259 OID 33676)
-- Name: tests_bazwithlayout; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tests_bazwithlayout (
    id integer NOT NULL,
    layout_id integer
);


--
-- TOC entry 342 (class 1259 OID 33679)
-- Name: tests_bazwithlayout_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_bazwithlayout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4145 (class 0 OID 0)
-- Dependencies: 342
-- Name: tests_bazwithlayout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_bazwithlayout_id_seq OWNED BY tests_bazwithlayout.id;


--
-- TOC entry 343 (class 1259 OID 33681)
-- Name: tests_foowithlayout; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tests_foowithlayout (
    id integer NOT NULL,
    layout_id integer
);


--
-- TOC entry 344 (class 1259 OID 33684)
-- Name: tests_foowithlayout_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_foowithlayout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4146 (class 0 OID 0)
-- Dependencies: 344
-- Name: tests_foowithlayout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_foowithlayout_id_seq OWNED BY tests_foowithlayout.id;


--
-- TOC entry 345 (class 1259 OID 33686)
-- Name: tests_imagetest; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tests_imagetest (
    id integer NOT NULL,
    image character varying(100) NOT NULL
);


--
-- TOC entry 346 (class 1259 OID 33689)
-- Name: tests_imagetest_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_imagetest_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4147 (class 0 OID 0)
-- Dependencies: 346
-- Name: tests_imagetest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_imagetest_id_seq OWNED BY tests_imagetest.id;


--
-- TOC entry 403 (class 1259 OID 36414)
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
-- TOC entry 402 (class 1259 OID 36412)
-- Name: tests_publishingm2mmodela_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_publishingm2mmodela_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4148 (class 0 OID 0)
-- Dependencies: 402
-- Name: tests_publishingm2mmodela_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_publishingm2mmodela_id_seq OWNED BY tests_publishingm2mmodela.id;


--
-- TOC entry 405 (class 1259 OID 36424)
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
-- TOC entry 404 (class 1259 OID 36422)
-- Name: tests_publishingm2mmodelb_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_publishingm2mmodelb_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4149 (class 0 OID 0)
-- Dependencies: 404
-- Name: tests_publishingm2mmodelb_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_publishingm2mmodelb_id_seq OWNED BY tests_publishingm2mmodelb.id;


--
-- TOC entry 407 (class 1259 OID 36434)
-- Name: tests_publishingm2mmodelb_related_a_models; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tests_publishingm2mmodelb_related_a_models (
    id integer NOT NULL,
    publishingm2mmodelb_id integer NOT NULL,
    publishingm2mmodela_id integer NOT NULL
);


--
-- TOC entry 406 (class 1259 OID 36432)
-- Name: tests_publishingm2mmodelb_related_a_models_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_publishingm2mmodelb_related_a_models_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4150 (class 0 OID 0)
-- Dependencies: 406
-- Name: tests_publishingm2mmodelb_related_a_models_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_publishingm2mmodelb_related_a_models_id_seq OWNED BY tests_publishingm2mmodelb_related_a_models.id;


--
-- TOC entry 409 (class 1259 OID 36444)
-- Name: tests_publishingm2mthroughtable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tests_publishingm2mthroughtable (
    id integer NOT NULL,
    a_model_id integer NOT NULL,
    b_model_id integer NOT NULL
);


--
-- TOC entry 408 (class 1259 OID 36442)
-- Name: tests_publishingm2mthroughtable_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tests_publishingm2mthroughtable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4151 (class 0 OID 0)
-- Dependencies: 408
-- Name: tests_publishingm2mthroughtable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tests_publishingm2mthroughtable_id_seq OWNED BY tests_publishingm2mthroughtable.id;


--
-- TOC entry 389 (class 1259 OID 36024)
-- Name: workflow_workflowstate_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE workflow_workflowstate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4152 (class 0 OID 0)
-- Dependencies: 389
-- Name: workflow_workflowstate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE workflow_workflowstate_id_seq OWNED BY icekit_workflow_workflowstate.id;


--
-- TOC entry 2708 (class 2604 OID 33691)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- TOC entry 2709 (class 2604 OID 33692)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- TOC entry 2710 (class 2604 OID 33693)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- TOC entry 2711 (class 2604 OID 33694)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_taskmeta ALTER COLUMN id SET DEFAULT nextval('celery_taskmeta_id_seq'::regclass);


--
-- TOC entry 2712 (class 2604 OID 33695)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_tasksetmeta ALTER COLUMN id SET DEFAULT nextval('celery_tasksetmeta_id_seq'::regclass);


--
-- TOC entry 2724 (class 2604 OID 33696)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_admin_log ALTER COLUMN id SET DEFAULT nextval('django_admin_log_id_seq'::regclass);


--
-- TOC entry 2726 (class 2604 OID 33697)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- TOC entry 2727 (class 2604 OID 33698)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_migrations ALTER COLUMN id SET DEFAULT nextval('django_migrations_id_seq'::regclass);


--
-- TOC entry 2728 (class 2604 OID 33699)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_redirect ALTER COLUMN id SET DEFAULT nextval('django_redirect_id_seq'::regclass);


--
-- TOC entry 2729 (class 2604 OID 33700)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_site ALTER COLUMN id SET DEFAULT nextval('django_site_id_seq'::regclass);


--
-- TOC entry 2730 (class 2604 OID 33701)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_crontabschedule ALTER COLUMN id SET DEFAULT nextval('djcelery_crontabschedule_id_seq'::regclass);


--
-- TOC entry 2731 (class 2604 OID 33702)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_intervalschedule ALTER COLUMN id SET DEFAULT nextval('djcelery_intervalschedule_id_seq'::regclass);


--
-- TOC entry 2732 (class 2604 OID 33703)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask ALTER COLUMN id SET DEFAULT nextval('djcelery_periodictask_id_seq'::regclass);


--
-- TOC entry 2734 (class 2604 OID 33704)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_taskstate ALTER COLUMN id SET DEFAULT nextval('djcelery_taskstate_id_seq'::regclass);


--
-- TOC entry 2735 (class 2604 OID 33705)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_workerstate ALTER COLUMN id SET DEFAULT nextval('djcelery_workerstate_id_seq'::regclass);


--
-- TOC entry 2736 (class 2604 OID 33706)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_message ALTER COLUMN id SET DEFAULT nextval('djkombu_message_id_seq'::regclass);


--
-- TOC entry 2737 (class 2604 OID 33707)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_queue ALTER COLUMN id SET DEFAULT nextval('djkombu_queue_id_seq'::regclass);


--
-- TOC entry 2738 (class 2604 OID 33708)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_source ALTER COLUMN id SET DEFAULT nextval('easy_thumbnails_source_id_seq'::regclass);


--
-- TOC entry 2739 (class 2604 OID 33709)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnail ALTER COLUMN id SET DEFAULT nextval('easy_thumbnails_thumbnail_id_seq'::regclass);


--
-- TOC entry 2740 (class 2604 OID 33710)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnaildimensions ALTER COLUMN id SET DEFAULT nextval('easy_thumbnails_thumbnaildimensions_id_seq'::regclass);


--
-- TOC entry 2745 (class 2604 OID 33711)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem ALTER COLUMN id SET DEFAULT nextval('fluent_contents_contentitem_id_seq'::regclass);


--
-- TOC entry 2746 (class 2604 OID 33712)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_placeholder ALTER COLUMN id SET DEFAULT nextval('fluent_contents_placeholder_id_seq'::regclass);


--
-- TOC entry 2747 (class 2604 OID 33713)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_htmlpage_translation ALTER COLUMN id SET DEFAULT nextval('fluent_pages_htmlpage_translation_id_seq'::regclass);


--
-- TOC entry 2748 (class 2604 OID 33714)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_pagelayout ALTER COLUMN id SET DEFAULT nextval('fluent_pages_pagelayout_id_seq'::regclass);


--
-- TOC entry 2749 (class 2604 OID 33715)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode ALTER COLUMN id SET DEFAULT nextval('fluent_pages_urlnode_id_seq'::regclass);


--
-- TOC entry 2754 (class 2604 OID 33716)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode_translation ALTER COLUMN id SET DEFAULT nextval('fluent_pages_urlnode_translation_id_seq'::regclass);


--
-- TOC entry 2755 (class 2604 OID 33717)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_field ALTER COLUMN id SET DEFAULT nextval('forms_field_id_seq'::regclass);


--
-- TOC entry 2756 (class 2604 OID 33718)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_fieldentry ALTER COLUMN id SET DEFAULT nextval('forms_fieldentry_id_seq'::regclass);


--
-- TOC entry 2757 (class 2604 OID 33719)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form ALTER COLUMN id SET DEFAULT nextval('forms_form_id_seq'::regclass);


--
-- TOC entry 2758 (class 2604 OID 33720)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites ALTER COLUMN id SET DEFAULT nextval('forms_form_sites_id_seq'::regclass);


--
-- TOC entry 2759 (class 2604 OID 33721)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_formentry ALTER COLUMN id SET DEFAULT nextval('forms_formentry_id_seq'::regclass);


--
-- TOC entry 2801 (class 2604 OID 34932)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_collections_country ALTER COLUMN id SET DEFAULT nextval('glamkit_collections_country_id_seq'::regclass);


--
-- TOC entry 2802 (class 2604 OID 34943)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_collections_geographiclocation ALTER COLUMN id SET DEFAULT nextval('glamkit_collections_geographiclocation_id_seq'::regclass);


--
-- TOC entry 2803 (class 2604 OID 34962)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_sponsors_sponsor ALTER COLUMN id SET DEFAULT nextval('glamkit_sponsors_sponsor_id_seq'::regclass);


--
-- TOC entry 2804 (class 2604 OID 35021)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article ALTER COLUMN id SET DEFAULT nextval('icekit_article_article_id_seq'::regclass);


--
-- TOC entry 2808 (class 2604 OID 35263)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author ALTER COLUMN id SET DEFAULT nextval('icekit_authors_author_id_seq'::regclass);


--
-- TOC entry 2809 (class 2604 OID 35404)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase ALTER COLUMN id SET DEFAULT nextval('icekit_events_eventbase_id_seq'::regclass);


--
-- TOC entry 2814 (class 2604 OID 35576)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types ALTER COLUMN id SET DEFAULT nextval('icekit_events_eventbase_secondary_types_id_seq'::regclass);


--
-- TOC entry 2810 (class 2604 OID 35417)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventrepeatsgenerator ALTER COLUMN id SET DEFAULT nextval('icekit_events_eventrepeatsgenerator_id_seq'::regclass);


--
-- TOC entry 2813 (class 2604 OID 35565)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventtype ALTER COLUMN id SET DEFAULT nextval('icekit_events_eventtype_id_seq'::regclass);


--
-- TOC entry 2811 (class 2604 OID 35428)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_occurrence ALTER COLUMN id SET DEFAULT nextval('icekit_events_occurrence_id_seq'::regclass);


--
-- TOC entry 2812 (class 2604 OID 35436)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_recurrencerule ALTER COLUMN id SET DEFAULT nextval('icekit_events_recurrencerule_id_seq'::regclass);


--
-- TOC entry 2760 (class 2604 OID 33722)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout ALTER COLUMN id SET DEFAULT nextval('icekit_layout_id_seq'::regclass);


--
-- TOC entry 2761 (class 2604 OID 33723)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types ALTER COLUMN id SET DEFAULT nextval('icekit_layout_content_types_id_seq'::regclass);


--
-- TOC entry 2762 (class 2604 OID 33724)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_mediacategory ALTER COLUMN id SET DEFAULT nextval('icekit_mediacategory_id_seq'::regclass);


--
-- TOC entry 2815 (class 2604 OID 35762)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_contact_person_contactperson ALTER COLUMN id SET DEFAULT nextval('icekit_plugins_contact_person_contactperson_id_seq'::regclass);


--
-- TOC entry 2744 (class 2604 OID 33725)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file ALTER COLUMN id SET DEFAULT nextval('file_file_id_seq'::regclass);


--
-- TOC entry 2743 (class 2604 OID 33726)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories ALTER COLUMN id SET DEFAULT nextval('file_file_categories_id_seq'::regclass);


--
-- TOC entry 2763 (class 2604 OID 33727)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image ALTER COLUMN id SET DEFAULT nextval('image_image_id_seq'::regclass);


--
-- TOC entry 2767 (class 2604 OID 33728)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories ALTER COLUMN id SET DEFAULT nextval('image_image_categories_id_seq'::regclass);


--
-- TOC entry 2805 (class 2604 OID 35221)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_imagerepurposeconfig ALTER COLUMN id SET DEFAULT nextval('icekit_plugins_image_imagerepurposeconfig_id_seq'::regclass);


--
-- TOC entry 2768 (class 2604 OID 33729)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_slideshow_slideshow ALTER COLUMN id SET DEFAULT nextval('icekit_plugins_slideshow_slideshow_id_seq'::regclass);


--
-- TOC entry 2816 (class 2604 OID 35853)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease ALTER COLUMN id SET DEFAULT nextval('icekit_press_releases_pressrelease_id_seq'::regclass);


--
-- TOC entry 2817 (class 2604 OID 35864)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressreleasecategory ALTER COLUMN id SET DEFAULT nextval('icekit_press_releases_pressreleasecategory_id_seq'::regclass);


--
-- TOC entry 2818 (class 2604 OID 36029)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_workflow_workflowstate ALTER COLUMN id SET DEFAULT nextval('workflow_workflowstate_id_seq'::regclass);


--
-- TOC entry 2820 (class 2604 OID 36084)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types ALTER COLUMN id SET DEFAULT nextval('ik_event_listing_types_id_seq'::regclass);


--
-- TOC entry 2821 (class 2604 OID 36111)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types ALTER COLUMN id SET DEFAULT nextval('ik_todays_occurrences_types_id_seq'::regclass);


--
-- TOC entry 2769 (class 2604 OID 33730)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_setting ALTER COLUMN id SET DEFAULT nextval('model_settings_setting_id_seq'::regclass);


--
-- TOC entry 2770 (class 2604 OID 33731)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation ALTER COLUMN id SET DEFAULT nextval('notifications_followerinformation_id_seq'::regclass);


--
-- TOC entry 2772 (class 2604 OID 33732)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers ALTER COLUMN id SET DEFAULT nextval('notifications_followerinformation_followers_id_seq'::regclass);


--
-- TOC entry 2773 (class 2604 OID 33733)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers ALTER COLUMN id SET DEFAULT nextval('notifications_followerinformation_group_followers_id_seq'::regclass);


--
-- TOC entry 2774 (class 2604 OID 33734)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_hasreadmessage ALTER COLUMN id SET DEFAULT nextval('notifications_hasreadmessage_id_seq'::regclass);


--
-- TOC entry 2775 (class 2604 OID 33735)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notification ALTER COLUMN id SET DEFAULT nextval('notifications_notification_id_seq'::regclass);


--
-- TOC entry 2776 (class 2604 OID 33736)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notificationsetting ALTER COLUMN id SET DEFAULT nextval('notifications_notificationsetting_id_seq'::regclass);


--
-- TOC entry 2777 (class 2604 OID 33737)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user ALTER COLUMN id SET DEFAULT nextval('polymorphic_auth_user_id_seq'::regclass);


--
-- TOC entry 2778 (class 2604 OID 33738)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups ALTER COLUMN id SET DEFAULT nextval('polymorphic_auth_user_groups_id_seq'::regclass);


--
-- TOC entry 2779 (class 2604 OID 33739)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('polymorphic_auth_user_user_permissions_id_seq'::regclass);


--
-- TOC entry 2780 (class 2604 OID 33740)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment ALTER COLUMN id SET DEFAULT nextval('post_office_attachment_id_seq'::regclass);


--
-- TOC entry 2781 (class 2604 OID 33741)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails ALTER COLUMN id SET DEFAULT nextval('post_office_attachment_emails_id_seq'::regclass);


--
-- TOC entry 2782 (class 2604 OID 33742)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_email ALTER COLUMN id SET DEFAULT nextval('post_office_email_id_seq'::regclass);


--
-- TOC entry 2785 (class 2604 OID 33743)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_emailtemplate ALTER COLUMN id SET DEFAULT nextval('post_office_emailtemplate_id_seq'::regclass);


--
-- TOC entry 2786 (class 2604 OID 33744)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_log ALTER COLUMN id SET DEFAULT nextval('post_office_log_id_seq'::regclass);


--
-- TOC entry 2788 (class 2604 OID 33745)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirectnode_redirectnode_translation ALTER COLUMN id SET DEFAULT nextval('redirectnode_redirectnode_translation_id_seq'::regclass);


--
-- TOC entry 2789 (class 2604 OID 33746)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY response_pages_responsepage ALTER COLUMN id SET DEFAULT nextval('response_pages_responsepage_id_seq'::regclass);


--
-- TOC entry 2790 (class 2604 OID 33747)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_revision ALTER COLUMN id SET DEFAULT nextval('reversion_revision_id_seq'::regclass);


--
-- TOC entry 2791 (class 2604 OID 33748)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_version ALTER COLUMN id SET DEFAULT nextval('reversion_version_id_seq'::regclass);


--
-- TOC entry 2792 (class 2604 OID 33749)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent ALTER COLUMN id SET DEFAULT nextval('sharedcontent_sharedcontent_id_seq'::regclass);


--
-- TOC entry 2793 (class 2604 OID 33750)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent_translation ALTER COLUMN id SET DEFAULT nextval('sharedcontent_sharedcontent_translation_id_seq'::regclass);


--
-- TOC entry 2794 (class 2604 OID 33751)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article ALTER COLUMN id SET DEFAULT nextval('test_article_id_seq'::regclass);


--
-- TOC entry 2795 (class 2604 OID 33752)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages ALTER COLUMN id SET DEFAULT nextval('test_layoutpage_with_related_related_pages_id_seq'::regclass);


--
-- TOC entry 2796 (class 2604 OID 33753)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_barwithlayout ALTER COLUMN id SET DEFAULT nextval('tests_barwithlayout_id_seq'::regclass);


--
-- TOC entry 2797 (class 2604 OID 33754)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_basemodel ALTER COLUMN id SET DEFAULT nextval('tests_basemodel_id_seq'::regclass);


--
-- TOC entry 2798 (class 2604 OID 33755)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_bazwithlayout ALTER COLUMN id SET DEFAULT nextval('tests_bazwithlayout_id_seq'::regclass);


--
-- TOC entry 2799 (class 2604 OID 33756)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_foowithlayout ALTER COLUMN id SET DEFAULT nextval('tests_foowithlayout_id_seq'::regclass);


--
-- TOC entry 2800 (class 2604 OID 33757)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_imagetest ALTER COLUMN id SET DEFAULT nextval('tests_imagetest_id_seq'::regclass);


--
-- TOC entry 2822 (class 2604 OID 36417)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodela ALTER COLUMN id SET DEFAULT nextval('tests_publishingm2mmodela_id_seq'::regclass);


--
-- TOC entry 2823 (class 2604 OID 36427)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb ALTER COLUMN id SET DEFAULT nextval('tests_publishingm2mmodelb_id_seq'::regclass);


--
-- TOC entry 2824 (class 2604 OID 36437)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models ALTER COLUMN id SET DEFAULT nextval('tests_publishingm2mmodelb_related_a_models_id_seq'::regclass);


--
-- TOC entry 2825 (class 2604 OID 36447)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mthroughtable ALTER COLUMN id SET DEFAULT nextval('tests_publishingm2mthroughtable_id_seq'::regclass);


--
-- TOC entry 3820 (class 0 OID 33108)
-- Dependencies: 173
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: -
--

COPY auth_group (id, name) FROM stdin;
\.


--
-- TOC entry 4153 (class 0 OID 0)
-- Dependencies: 174
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('auth_group_id_seq', 1, false);


--
-- TOC entry 3822 (class 0 OID 33113)
-- Dependencies: 175
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- TOC entry 4154 (class 0 OID 0)
-- Dependencies: 176
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('auth_group_permissions_id_seq', 1, false);


--
-- TOC entry 3824 (class 0 OID 33118)
-- Dependencies: 177
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add layout	1	add_layout
2	Can change layout	1	change_layout
3	Can delete layout	1	delete_layout
4	Can add media category	2	add_mediacategory
5	Can change media category	2	change_mediacategory
6	Can delete media category	2	delete_mediacategory
7	Can add Form entry	3	add_formentry
8	Can change Form entry	3	change_formentry
9	Can delete Form entry	3	delete_formentry
10	Can add Form field entry	4	add_fieldentry
11	Can change Form field entry	4	change_fieldentry
12	Can delete Form field entry	4	delete_fieldentry
13	Can add Form	5	add_form
14	Can change Form	5	change_form
15	Can delete Form	5	delete_form
16	Can add Field	6	add_field
17	Can change Field	6	change_field
18	Can delete Field	6	delete_field
19	Can add revision	7	add_revision
20	Can change revision	7	change_revision
21	Can delete revision	7	delete_revision
22	Can add version	8	add_version
23	Can change version	8	change_version
24	Can delete version	8	delete_version
25	Can add log entry	9	add_logentry
26	Can change log entry	9	change_logentry
27	Can delete log entry	9	delete_logentry
28	Can add permission	10	add_permission
29	Can change permission	10	change_permission
30	Can delete permission	10	delete_permission
31	Can add group	11	add_group
32	Can change group	11	change_group
33	Can delete group	11	delete_group
34	Can add content type	12	add_contenttype
35	Can change content type	12	change_contenttype
36	Can delete content type	12	delete_contenttype
37	Can add session	13	add_session
38	Can change session	13	change_session
39	Can delete session	13	delete_session
40	Can add redirect	14	add_redirect
41	Can change redirect	14	change_redirect
42	Can delete redirect	14	delete_redirect
43	Can add site	15	add_site
44	Can change site	15	change_site
45	Can delete site	15	delete_site
46	Can add task state	16	add_taskmeta
47	Can change task state	16	change_taskmeta
48	Can delete task state	16	delete_taskmeta
49	Can add saved group result	17	add_tasksetmeta
50	Can change saved group result	17	change_tasksetmeta
51	Can delete saved group result	17	delete_tasksetmeta
52	Can add interval	18	add_intervalschedule
53	Can change interval	18	change_intervalschedule
54	Can delete interval	18	delete_intervalschedule
55	Can add crontab	19	add_crontabschedule
56	Can change crontab	19	change_crontabschedule
57	Can delete crontab	19	delete_crontabschedule
58	Can add periodic tasks	20	add_periodictasks
59	Can change periodic tasks	20	change_periodictasks
60	Can delete periodic tasks	20	delete_periodictasks
61	Can add periodic task	21	add_periodictask
62	Can change periodic task	21	change_periodictask
63	Can delete periodic task	21	delete_periodictask
64	Can add worker	22	add_workerstate
65	Can change worker	22	change_workerstate
66	Can delete worker	22	delete_workerstate
67	Can add task	23	add_taskstate
68	Can change task	23	change_taskstate
69	Can delete task	23	delete_taskstate
70	Can add queue	24	add_queue
71	Can change queue	24	change_queue
72	Can delete queue	24	delete_queue
73	Can add message	25	add_message
74	Can change message	25	change_message
75	Can delete message	25	delete_message
76	Can add source	26	add_source
77	Can change source	26	change_source
78	Can delete source	26	delete_source
79	Can add thumbnail	27	add_thumbnail
80	Can change thumbnail	27	change_thumbnail
81	Can delete thumbnail	27	delete_thumbnail
82	Can add thumbnail dimensions	28	add_thumbnaildimensions
83	Can change thumbnail dimensions	28	change_thumbnaildimensions
84	Can delete thumbnail dimensions	28	delete_thumbnaildimensions
85	Can add Placeholder	29	add_placeholder
86	Can change Placeholder	29	change_placeholder
87	Can delete Placeholder	29	delete_placeholder
88	Can add Contentitem link	30	add_contentitem
89	Can change Contentitem link	30	change_contentitem
90	Can delete Contentitem link	30	delete_contentitem
91	Can add URL Node	31	add_urlnode
92	Can change URL Node	31	change_urlnode
93	Can delete URL Node	31	delete_urlnode
94	Can change Shared fields	31	change_shared_fields_urlnode
95	Can change Override URL field	31	change_override_url_urlnode
96	Can add URL Node translation	32	add_urlnode_translation
97	Can change URL Node translation	32	change_urlnode_translation
98	Can delete URL Node translation	32	delete_urlnode_translation
99	Can add Page	31	add_page
100	Can change Page	31	change_page
101	Can delete Page	31	delete_page
102	Can add html page	31	add_htmlpage
103	Can change html page	31	change_htmlpage
104	Can delete html page	31	delete_htmlpage
105	Can add Layout	34	add_pagelayout
106	Can change Layout	34	change_pagelayout
107	Can delete Layout	34	delete_pagelayout
108	Can add Redirect	38	add_redirectnode
109	Can change Redirect	38	change_redirectnode
110	Can delete Redirect	38	delete_redirectnode
111	Can add Iframe	39	add_iframeitem
112	Can change Iframe	39	change_iframeitem
113	Can delete Iframe	39	delete_iframeitem
114	Can add Online media	40	add_oembeditem
115	Can change Online media	40	change_oembeditem
116	Can delete Online media	40	delete_oembeditem
117	Can add Picture	41	add_pictureitem
118	Can change Picture	41	change_pictureitem
119	Can delete Picture	41	delete_pictureitem
120	Can add HTML code	42	add_rawhtmlitem
121	Can change HTML code	42	change_rawhtmlitem
122	Can delete HTML code	42	delete_rawhtmlitem
123	Can add Shared content	44	add_sharedcontent
124	Can change Shared content	44	change_sharedcontent
125	Can delete Shared content	44	delete_sharedcontent
126	Can add Shared content	45	add_sharedcontentitem
127	Can change Shared content	45	change_sharedcontentitem
128	Can delete Shared content	45	delete_sharedcontentitem
129	Can add Text	46	add_textitem
130	Can change Text	46	change_textitem
131	Can delete Text	46	delete_textitem
132	Can add response page	47	add_responsepage
133	Can change response page	47	change_responsepage
134	Can delete response page	47	delete_responsepage
135	Can add notification setting	48	add_notificationsetting
136	Can change notification setting	48	change_notificationsetting
137	Can delete notification setting	48	delete_notificationsetting
138	Can add has read message	49	add_hasreadmessage
139	Can change has read message	49	change_hasreadmessage
140	Can delete has read message	49	delete_hasreadmessage
141	Can add notification	50	add_notification
142	Can change notification	50	change_notification
143	Can delete notification	50	delete_notification
144	Can add follower information	51	add_followerinformation
145	Can change follower information	51	change_followerinformation
146	Can delete follower information	51	delete_followerinformation
147	Can Publish LayoutPage	52	can_publish
148	Can add Layout page	52	add_layoutpage
149	Can change Layout page	52	change_layoutpage
150	Can delete Layout page	52	delete_layoutpage
151	Can Publish SearchPage	53	can_publish
152	Can add Search page	53	add_searchpage
153	Can change Search page	53	change_searchpage
154	Can delete Search page	53	delete_searchpage
155	Can add Child Page	54	add_childpageitem
156	Can change Child Page	54	change_childpageitem
157	Can delete Child Page	54	delete_childpageitem
158	Can add FAQ	55	add_faqitem
159	Can change FAQ	55	change_faqitem
160	Can delete FAQ	55	delete_faqitem
161	Can add file	56	add_file
162	Can change file	56	change_file
163	Can delete file	56	delete_file
164	Can add File	57	add_fileitem
165	Can change File	57	change_fileitem
166	Can delete File	57	delete_fileitem
167	Can add Horizontal Rule	58	add_horizontalruleitem
168	Can change Horizontal Rule	58	change_horizontalruleitem
169	Can delete Horizontal Rule	58	delete_horizontalruleitem
170	Can add image	59	add_image
171	Can change image	59	change_image
172	Can delete image	59	delete_image
173	Can add Image	60	add_imageitem
174	Can change Image	60	change_imageitem
175	Can delete Image	60	delete_imageitem
176	Can add Instagram Embed	61	add_instagramembeditem
177	Can change Instagram Embed	61	change_instagramembeditem
178	Can delete Instagram Embed	61	delete_instagramembeditem
179	Can add Google Map	62	add_mapitem
180	Can change Google Map	62	change_mapitem
181	Can delete Google Map	62	delete_mapitem
182	Can add Google Map with Text	63	add_mapwithtextitem
183	Can change Google Map with Text	63	change_mapwithtextitem
184	Can delete Google Map with Text	63	delete_mapwithtextitem
185	Can add Online Media with Caption	64	add_oembedwithcaptionitem
186	Can change Online Media with Caption	64	change_oembedwithcaptionitem
187	Can delete Online Media with Caption	64	delete_oembedwithcaptionitem
188	Can add Page Anchor	65	add_pageanchoritem
189	Can change Page Anchor	65	change_pageanchoritem
190	Can delete Page Anchor	65	delete_pageanchoritem
191	Can add Page Anchor List	66	add_pageanchorlistitem
192	Can change Page Anchor List	66	change_pageanchorlistitem
193	Can delete Page Anchor List	66	delete_pageanchorlistitem
194	Can add Quote	67	add_quoteitem
195	Can change Quote	67	change_quoteitem
196	Can delete Quote	67	delete_quoteitem
197	Can add Form	68	add_formitem
198	Can change Form	68	change_formitem
199	Can delete Form	68	delete_formitem
200	Can Publish SlideShow	69	can_publish
201	Can add slide show	69	add_slideshow
202	Can change slide show	69	change_slideshow
203	Can delete slide show	69	delete_slideshow
204	Can add Slide show	70	add_slideshowitem
205	Can change Slide show	70	change_slideshowitem
206	Can delete Slide show	70	delete_slideshowitem
207	Can add Twitter Embed	71	add_twitterembeditem
208	Can change Twitter Embed	71	change_twitterembeditem
209	Can delete Twitter Embed	71	delete_twitterembeditem
210	Can add setting	72	add_setting
211	Can change setting	72	change_setting
212	Can delete setting	72	delete_setting
213	Can add boolean	73	add_boolean
214	Can change boolean	73	change_boolean
215	Can delete boolean	73	delete_boolean
216	Can add date	74	add_date
217	Can change date	74	change_date
218	Can delete date	74	delete_date
219	Can add date time	75	add_datetime
220	Can change date time	75	change_datetime
221	Can delete date time	75	delete_datetime
222	Can add decimal	76	add_decimal
223	Can change decimal	76	change_decimal
224	Can delete decimal	76	delete_decimal
225	Can add file	77	add_file
226	Can change file	77	change_file
227	Can delete file	77	delete_file
228	Can add float	78	add_float
229	Can change float	78	change_float
230	Can delete float	78	delete_float
231	Can add image	79	add_image
232	Can change image	79	change_image
233	Can delete image	79	delete_image
234	Can add integer	80	add_integer
235	Can change integer	80	change_integer
236	Can delete integer	80	delete_integer
237	Can add text	81	add_text
238	Can change text	81	change_text
239	Can delete text	81	delete_text
240	Can add time	82	add_time
241	Can change time	82	change_time
242	Can delete time	82	delete_time
243	Can add user	83	add_user
244	Can change user	83	change_user
245	Can delete user	83	delete_user
246	Can add user with email login	84	add_emailuser
247	Can change user with email login	84	change_emailuser
248	Can delete user with email login	84	delete_emailuser
249	Can add email	85	add_email
250	Can change email	85	change_email
251	Can delete email	85	delete_email
252	Can add log	86	add_log
253	Can change log	86	change_log
254	Can delete log	86	delete_log
255	Can add Email Template	87	add_emailtemplate
256	Can change Email Template	87	change_emailtemplate
257	Can delete Email Template	87	delete_emailtemplate
258	Can add attachment	88	add_attachment
259	Can change attachment	88	change_attachment
260	Can delete attachment	88	delete_attachment
261	Can add Page	89	add_fluentpage
262	Can change Page	89	change_fluentpage
263	Can delete Page	89	delete_fluentpage
264	Can change Page layout	89	change_page_layout
265	Can Publish Article	90	can_publish
266	Can Publish LayoutPageWithRelatedPages	91	can_publish
267	Can add base model	92	add_basemodel
268	Can change base model	92	change_basemodel
269	Can delete base model	92	delete_basemodel
270	Can add foo with layout	93	add_foowithlayout
271	Can change foo with layout	93	change_foowithlayout
272	Can delete foo with layout	93	delete_foowithlayout
273	Can add bar with layout	94	add_barwithlayout
274	Can change bar with layout	94	change_barwithlayout
275	Can delete bar with layout	94	delete_barwithlayout
276	Can add baz with layout	95	add_bazwithlayout
277	Can change baz with layout	95	change_bazwithlayout
278	Can delete baz with layout	95	delete_bazwithlayout
279	Can add image test	96	add_imagetest
280	Can change image test	96	change_imagetest
281	Can delete image test	96	delete_imagetest
282	Can add article	90	add_article
283	Can change article	90	change_article
284	Can delete article	90	delete_article
285	Can add layout page with related pages	91	add_layoutpagewithrelatedpages
286	Can change layout page with related pages	91	change_layoutpagewithrelatedpages
287	Can delete layout page with related pages	91	delete_layoutpagewithrelatedpages
288	Can add unpublishable layout page	97	add_unpublishablelayoutpage
289	Can change unpublishable layout page	97	change_unpublishablelayoutpage
290	Can delete unpublishable layout page	97	delete_unpublishablelayoutpage
291	Can Use IIIF Image API	83	can_use_iiif_image_api
292	Can add workflow state	98	add_workflowstate
293	Can change workflow state	98	change_workflowstate
294	Can delete workflow state	98	delete_workflowstate
295	Can Publish Article	99	can_publish
296	Can Republish Article	99	can_republish
297	Can Publish ArticleCategoryPage	100	can_publish
298	Can Republish ArticleCategoryPage	100	can_republish
299	Can add article	99	add_article
300	Can change article	99	change_article
301	Can delete article	99	delete_article
302	Can add article category page	100	add_articlecategorypage
303	Can change article category page	100	change_articlecategorypage
304	Can delete article category page	100	delete_articlecategorypage
305	Can Publish AuthorListing	101	can_publish
306	Can Republish AuthorListing	101	can_republish
307	Can Publish Author	102	can_publish
308	Can Republish Author	102	can_republish
309	Can add author listing	101	add_authorlisting
310	Can change author listing	101	change_authorlisting
311	Can delete author listing	101	delete_authorlisting
312	Can add author	102	add_author
313	Can change author	102	change_author
314	Can delete author	102	delete_author
315	Can Republish LayoutPage	52	can_republish
316	Can Republish SearchPage	53	can_republish
317	Can add contact person	103	add_contactperson
318	Can change contact person	103	change_contactperson
319	Can delete contact person	103	delete_contactperson
320	Can add Contact Person	104	add_contactpersonitem
321	Can change Contact Person	104	change_contactpersonitem
322	Can delete Contact Person	104	delete_contactpersonitem
323	Can add Content Listing	105	add_contentlistingitem
324	Can change Content Listing	105	change_contentlistingitem
325	Can delete Content Listing	105	delete_contentlistingitem
326	Can add Image derivative	106	add_imagerepurposeconfig
327	Can change Image derivative	106	change_imagerepurposeconfig
328	Can delete Image derivative	106	delete_imagerepurposeconfig
329	Can add Page link	107	add_pagelink
330	Can change Page link	107	change_pagelink
331	Can delete Page link	107	delete_pagelink
332	Can add Article link	108	add_articlelink
333	Can change Article link	108	change_articlelink
334	Can delete Article link	108	delete_articlelink
335	Can add Author link	109	add_authorlink
336	Can change Author link	109	change_authorlink
337	Can delete Author link	109	delete_authorlink
338	Can Republish SlideShow	69	can_republish
339	Can add Image Gallery	110	add_imagegalleryshowitem
340	Can change Image Gallery	110	change_imagegalleryshowitem
341	Can delete Image Gallery	110	delete_imagegalleryshowitem
342	Can Publish ArticleListing	111	can_publish
343	Can Republish ArticleListing	111	can_republish
344	Can Republish Article	90	can_republish
345	Can Republish LayoutPageWithRelatedPages	91	can_republish
346	Can Publish PublishingM2MModelA	112	can_publish
347	Can Republish PublishingM2MModelA	112	can_republish
348	Can Publish PublishingM2MModelB	113	can_publish
349	Can Republish PublishingM2MModelB	113	can_republish
350	Can add article listing	111	add_articlelisting
351	Can change article listing	111	change_articlelisting
352	Can delete article listing	111	delete_articlelisting
353	Can add publishing m2m model a	112	add_publishingm2mmodela
354	Can change publishing m2m model a	112	change_publishingm2mmodela
355	Can delete publishing m2m model a	112	delete_publishingm2mmodela
356	Can add publishing m2m model b	113	add_publishingm2mmodelb
357	Can change publishing m2m model b	113	change_publishingm2mmodelb
358	Can delete publishing m2m model b	113	delete_publishingm2mmodelb
359	Can add publishing m2m through table	114	add_publishingm2mthroughtable
360	Can change publishing m2m through table	114	change_publishingm2mthroughtable
361	Can delete publishing m2m through table	114	delete_publishingm2mthroughtable
362	Can add sponsor	115	add_sponsor
363	Can change sponsor	115	change_sponsor
364	Can delete sponsor	115	delete_sponsor
365	Can add Begin Sponsor Block	116	add_beginsponsorblockitem
366	Can change Begin Sponsor Block	116	change_beginsponsorblockitem
367	Can delete Begin Sponsor Block	116	delete_beginsponsorblockitem
368	Can add End sponsor block	117	add_endsponsorblockitem
369	Can change End sponsor block	117	change_endsponsorblockitem
370	Can delete End sponsor block	117	delete_endsponsorblockitem
371	Can add Sponsor promo	118	add_sponsorpromoitem
372	Can change Sponsor promo	118	change_sponsorpromoitem
373	Can delete Sponsor promo	118	delete_sponsorpromoitem
374	Can Publish PressReleaseListing	119	can_publish
375	Can Republish PressReleaseListing	119	can_republish
376	Can Publish PressRelease	120	can_publish
377	Can Republish PressRelease	120	can_republish
378	Can add Press release listing	119	add_pressreleaselisting
379	Can change Press release listing	119	change_pressreleaselisting
380	Can delete Press release listing	119	delete_pressreleaselisting
381	Can add press release category	121	add_pressreleasecategory
382	Can change press release category	121	change_pressreleasecategory
383	Can delete press release category	121	delete_pressreleasecategory
384	Can add press release	120	add_pressrelease
385	Can change press release	120	change_pressrelease
386	Can delete press release	120	delete_pressrelease
387	Can add Token	122	add_token
388	Can change Token	122	change_token
389	Can delete Token	122	delete_token
390	Can Publish EventBase	123	can_publish
391	Can Republish EventBase	123	can_republish
392	Can add recurrence rule	124	add_recurrencerule
393	Can change recurrence rule	124	change_recurrencerule
394	Can delete recurrence rule	124	delete_recurrencerule
395	Can add Event category	125	add_eventtype
396	Can change Event category	125	change_eventtype
397	Can delete Event category	125	delete_eventtype
398	Can add Event	123	add_eventbase
399	Can change Event	123	change_eventbase
400	Can delete Event	123	delete_eventbase
401	Can add event repeats generator	126	add_eventrepeatsgenerator
402	Can change event repeats generator	126	change_eventrepeatsgenerator
403	Can delete event repeats generator	126	delete_eventrepeatsgenerator
404	Can add occurrence	127	add_occurrence
405	Can change occurrence	127	change_occurrence
406	Can delete occurrence	127	delete_occurrence
407	Can Publish SimpleEvent	128	can_publish
408	Can Republish SimpleEvent	128	can_republish
409	Can add Simple event	128	add_simpleevent
410	Can change Simple event	128	change_simpleevent
411	Can delete Simple event	128	delete_simpleevent
412	Can add Event Content Listing	129	add_eventcontentlistingitem
413	Can change Event Content Listing	129	change_eventcontentlistingitem
414	Can delete Event Content Listing	129	delete_eventcontentlistingitem
415	Can add Event link	130	add_eventlink
416	Can change Event link	130	change_eventlink
417	Can delete Event link	130	delete_eventlink
418	Can add Today's events	131	add_todaysoccurrences
419	Can change Today's events	131	change_todaysoccurrences
420	Can delete Today's events	131	delete_todaysoccurrences
421	Can Publish EventListingPage	132	can_publish
422	Can Republish EventListingPage	132	can_republish
423	Can add Event listing for date	132	add_eventlistingpage
424	Can change Event listing for date	132	change_eventlistingpage
425	Can delete Event listing for date	132	delete_eventlistingpage
426	Can add country	133	add_country
427	Can change country	133	change_country
428	Can delete country	133	delete_country
429	Can add geographic location	134	add_geographiclocation
430	Can change geographic location	134	change_geographiclocation
431	Can delete geographic location	134	delete_geographiclocation
\.


--
-- TOC entry 4155 (class 0 OID 0)
-- Dependencies: 178
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('auth_permission_id_seq', 431, true);


--
-- TOC entry 3994 (class 0 OID 34821)
-- Dependencies: 347
-- Data for Name: authtoken_token; Type: TABLE DATA; Schema: public; Owner: -
--

COPY authtoken_token (key, created, user_id) FROM stdin;
\.


--
-- TOC entry 3826 (class 0 OID 33123)
-- Dependencies: 179
-- Data for Name: celery_taskmeta; Type: TABLE DATA; Schema: public; Owner: -
--

COPY celery_taskmeta (id, task_id, status, result, date_done, traceback, hidden, meta) FROM stdin;
\.


--
-- TOC entry 4156 (class 0 OID 0)
-- Dependencies: 180
-- Name: celery_taskmeta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('celery_taskmeta_id_seq', 1, false);


--
-- TOC entry 3828 (class 0 OID 33131)
-- Dependencies: 181
-- Data for Name: celery_tasksetmeta; Type: TABLE DATA; Schema: public; Owner: -
--

COPY celery_tasksetmeta (id, taskset_id, result, date_done, hidden) FROM stdin;
\.


--
-- TOC entry 4157 (class 0 OID 0)
-- Dependencies: 182
-- Name: celery_tasksetmeta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('celery_tasksetmeta_id_seq', 1, false);


--
-- TOC entry 4002 (class 0 OID 34974)
-- Dependencies: 355
-- Data for Name: contentitem_glamkit_sponsors_beginsponsorblockitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_glamkit_sponsors_beginsponsorblockitem (contentitem_ptr_id, text) FROM stdin;
\.


--
-- TOC entry 4003 (class 0 OID 34982)
-- Dependencies: 356
-- Data for Name: contentitem_glamkit_sponsors_endsponsorblockitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_glamkit_sponsors_endsponsorblockitem (contentitem_ptr_id, text) FROM stdin;
\.


--
-- TOC entry 4004 (class 0 OID 34990)
-- Dependencies: 357
-- Data for Name: contentitem_glamkit_sponsors_sponsorpromoitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_glamkit_sponsors_sponsorpromoitem (contentitem_ptr_id, title, width, quality, sponsor_id) FROM stdin;
\.


--
-- TOC entry 4026 (class 0 OID 35738)
-- Dependencies: 379
-- Data for Name: contentitem_icekit_events_links_eventlink; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_events_links_eventlink (contentitem_ptr_id, style, type_override, title_override, oneliner_override, url_override, image_override, item_id) FROM stdin;
\.


--
-- TOC entry 3830 (class 0 OID 33139)
-- Dependencies: 183
-- Data for Name: contentitem_icekit_plugins_child_pages_childpageitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_child_pages_childpageitem (contentitem_ptr_id) FROM stdin;
\.


--
-- TOC entry 4029 (class 0 OID 35768)
-- Dependencies: 382
-- Data for Name: contentitem_icekit_plugins_contact_person_contactpersonitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_contact_person_contactpersonitem (contentitem_ptr_id, contact_id) FROM stdin;
\.


--
-- TOC entry 4030 (class 0 OID 35784)
-- Dependencies: 383
-- Data for Name: contentitem_icekit_plugins_content_listing_contentlistingitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_content_listing_contentlistingitem (contentitem_ptr_id, content_type_id, "limit", no_items_message) FROM stdin;
\.


--
-- TOC entry 3831 (class 0 OID 33142)
-- Dependencies: 184
-- Data for Name: contentitem_icekit_plugins_faq_faqitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_faq_faqitem (contentitem_ptr_id, question, answer, load_open) FROM stdin;
\.


--
-- TOC entry 3832 (class 0 OID 33148)
-- Dependencies: 185
-- Data for Name: contentitem_icekit_plugins_file_fileitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_file_fileitem (contentitem_ptr_id, file_id) FROM stdin;
\.


--
-- TOC entry 3833 (class 0 OID 33151)
-- Dependencies: 186
-- Data for Name: contentitem_icekit_plugins_horizontal_rule_horizontalruleitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_horizontal_rule_horizontalruleitem (contentitem_ptr_id) FROM stdin;
\.


--
-- TOC entry 3834 (class 0 OID 33154)
-- Dependencies: 187
-- Data for Name: contentitem_icekit_plugins_image_imageitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_image_imageitem (contentitem_ptr_id, image_id, caption_override, show_caption, show_title, title_override) FROM stdin;
\.


--
-- TOC entry 3835 (class 0 OID 33160)
-- Dependencies: 188
-- Data for Name: contentitem_icekit_plugins_instagram_embed_instagramembeditem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_instagram_embed_instagramembeditem (contentitem_ptr_id, url, provider_url, media_id, author_name, height, width, thumbnail_url, thumbnail_width, thumbnail_height, provider_name, title, html, version, author_url, author_id, type) FROM stdin;
\.


--
-- TOC entry 3836 (class 0 OID 33171)
-- Dependencies: 189
-- Data for Name: contentitem_icekit_plugins_map_mapitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_map_mapitem (contentitem_ptr_id, share_url) FROM stdin;
\.


--
-- TOC entry 3837 (class 0 OID 33174)
-- Dependencies: 190
-- Data for Name: contentitem_icekit_plugins_map_with_text_mapwithtextitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_map_with_text_mapwithtextitem (contentitem_ptr_id, share_url, text, map_on_right) FROM stdin;
\.


--
-- TOC entry 3839 (class 0 OID 33188)
-- Dependencies: 192
-- Data for Name: contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem (contentitem_ptr_id) FROM stdin;
\.


--
-- TOC entry 3840 (class 0 OID 33191)
-- Dependencies: 193
-- Data for Name: contentitem_icekit_plugins_page_anchor_pageanchoritem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_page_anchor_pageanchoritem (contentitem_ptr_id, anchor_name) FROM stdin;
\.


--
-- TOC entry 3841 (class 0 OID 33194)
-- Dependencies: 194
-- Data for Name: contentitem_icekit_plugins_quote_quoteitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_quote_quoteitem (contentitem_ptr_id, quote, attribution, organisation, url) FROM stdin;
\.


--
-- TOC entry 3842 (class 0 OID 33200)
-- Dependencies: 195
-- Data for Name: contentitem_icekit_plugins_reusable_form_formitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_reusable_form_formitem (contentitem_ptr_id, form_id) FROM stdin;
\.


--
-- TOC entry 3843 (class 0 OID 33203)
-- Dependencies: 196
-- Data for Name: contentitem_icekit_plugins_slideshow_slideshowitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_slideshow_slideshowitem (contentitem_ptr_id, slide_show_id) FROM stdin;
\.


--
-- TOC entry 3844 (class 0 OID 33206)
-- Dependencies: 197
-- Data for Name: contentitem_icekit_plugins_twitter_embed_twitterembeditem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_icekit_plugins_twitter_embed_twitterembeditem (contentitem_ptr_id, twitter_url, url, provider_url, cache_age, author_name, height, width, provider_name, version, author_url, type, html) FROM stdin;
\.


--
-- TOC entry 3845 (class 0 OID 33214)
-- Dependencies: 198
-- Data for Name: contentitem_iframe_iframeitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_iframe_iframeitem (contentitem_ptr_id, src, width, height) FROM stdin;
\.


--
-- TOC entry 4038 (class 0 OID 36063)
-- Dependencies: 391
-- Data for Name: contentitem_ik_event_listing_eventcontentlistingitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_ik_event_listing_eventcontentlistingitem (contentitem_ptr_id, "limit", content_type_id, from_date, from_days_ago, to_date, to_days_ahead, no_items_message) FROM stdin;
\.


--
-- TOC entry 4041 (class 0 OID 36101)
-- Dependencies: 394
-- Data for Name: contentitem_ik_events_todays_occurrences_todaysoccurrences; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_ik_events_todays_occurrences_todaysoccurrences (contentitem_ptr_id, include_finished, fall_back_to_next_day, title) FROM stdin;
\.


--
-- TOC entry 4044 (class 0 OID 36143)
-- Dependencies: 397
-- Data for Name: contentitem_ik_links_articlelink; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_ik_links_articlelink (contentitem_ptr_id, style, type_override, title_override, image_override, item_id, url_override, oneliner_override) FROM stdin;
\.


--
-- TOC entry 4045 (class 0 OID 36151)
-- Dependencies: 398
-- Data for Name: contentitem_ik_links_authorlink; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_ik_links_authorlink (contentitem_ptr_id, style, type_override, title_override, image_override, item_id, url_override, oneliner_override) FROM stdin;
\.


--
-- TOC entry 4046 (class 0 OID 36159)
-- Dependencies: 399
-- Data for Name: contentitem_ik_links_pagelink; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_ik_links_pagelink (contentitem_ptr_id, style, type_override, title_override, image_override, item_id, url_override, oneliner_override) FROM stdin;
\.


--
-- TOC entry 4047 (class 0 OID 36254)
-- Dependencies: 400
-- Data for Name: contentitem_image_gallery_imagegalleryshowitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_image_gallery_imagegalleryshowitem (contentitem_ptr_id, slide_show_id) FROM stdin;
\.


--
-- TOC entry 3838 (class 0 OID 33180)
-- Dependencies: 191
-- Data for Name: contentitem_oembed_with_caption_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_oembed_with_caption_item (contentitem_ptr_id, embed_url, embed_max_width, embed_max_height, type, url, title, description, author_name, author_url, provider_name, provider_url, thumbnail_url, thumbnail_height, thumbnail_width, height, width, html, caption, is_16by9) FROM stdin;
\.


--
-- TOC entry 3846 (class 0 OID 33217)
-- Dependencies: 199
-- Data for Name: contentitem_oembeditem_oembeditem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_oembeditem_oembeditem (contentitem_ptr_id, embed_url, embed_max_width, embed_max_height, type, url, title, description, author_name, author_url, provider_name, provider_url, thumbnail_url, thumbnail_height, thumbnail_width, height, width, html) FROM stdin;
\.


--
-- TOC entry 3847 (class 0 OID 33225)
-- Dependencies: 200
-- Data for Name: contentitem_picture_pictureitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_picture_pictureitem (contentitem_ptr_id, image, caption, align, url, in_new_window) FROM stdin;
\.


--
-- TOC entry 3848 (class 0 OID 33231)
-- Dependencies: 201
-- Data for Name: contentitem_rawhtml_rawhtmlitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_rawhtml_rawhtmlitem (contentitem_ptr_id, html) FROM stdin;
\.


--
-- TOC entry 3849 (class 0 OID 33237)
-- Dependencies: 202
-- Data for Name: contentitem_sharedcontent_sharedcontentitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_sharedcontent_sharedcontentitem (contentitem_ptr_id, shared_content_id) FROM stdin;
\.


--
-- TOC entry 3850 (class 0 OID 33240)
-- Dependencies: 203
-- Data for Name: contentitem_text_textitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contentitem_text_textitem (contentitem_ptr_id, text, text_final, style) FROM stdin;
\.


--
-- TOC entry 3851 (class 0 OID 33246)
-- Dependencies: 204
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- TOC entry 4158 (class 0 OID 0)
-- Dependencies: 205
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 1, false);


--
-- TOC entry 3853 (class 0 OID 33255)
-- Dependencies: 206
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_content_type (id, app_label, model) FROM stdin;
1	icekit	layout
2	icekit	mediacategory
3	forms	formentry
4	forms	fieldentry
5	forms	form
6	forms	field
7	reversion	revision
8	reversion	version
9	admin	logentry
10	auth	permission
11	auth	group
12	contenttypes	contenttype
13	sessions	session
14	redirects	redirect
15	sites	site
16	djcelery	taskmeta
17	djcelery	tasksetmeta
18	djcelery	intervalschedule
19	djcelery	crontabschedule
20	djcelery	periodictasks
21	djcelery	periodictask
22	djcelery	workerstate
23	djcelery	taskstate
24	kombu_transport_django	queue
25	kombu_transport_django	message
26	easy_thumbnails	source
27	easy_thumbnails	thumbnail
28	easy_thumbnails	thumbnaildimensions
29	fluent_contents	placeholder
30	fluent_contents	contentitem
31	fluent_pages	urlnode
32	fluent_pages	urlnode_translation
33	fluent_pages	htmlpagetranslation
34	fluent_pages	pagelayout
35	fluent_pages	page
36	fluent_pages	htmlpage
37	redirectnode	redirectnodetranslation
38	redirectnode	redirectnode
39	iframe	iframeitem
40	oembeditem	oembeditem
41	picture	pictureitem
42	rawhtml	rawhtmlitem
43	sharedcontent	sharedcontenttranslation
44	sharedcontent	sharedcontent
45	sharedcontent	sharedcontentitem
46	text	textitem
47	response_pages	responsepage
48	notifications	notificationsetting
49	notifications	hasreadmessage
50	notifications	notification
51	notifications	followerinformation
52	layout_page	layoutpage
53	search_page	searchpage
54	icekit_plugins_child_pages	childpageitem
55	icekit_plugins_faq	faqitem
56	icekit_plugins_file	file
57	icekit_plugins_file	fileitem
58	icekit_plugins_horizontal_rule	horizontalruleitem
59	icekit_plugins_image	image
60	icekit_plugins_image	imageitem
61	icekit_plugins_instagram_embed	instagramembeditem
62	icekit_plugins_map	mapitem
63	icekit_plugins_map_with_text	mapwithtextitem
64	icekit_plugins_oembed_with_caption	oembedwithcaptionitem
65	icekit_plugins_page_anchor	pageanchoritem
66	icekit_plugins_page_anchor_list	pageanchorlistitem
67	icekit_plugins_quote	quoteitem
68	icekit_plugins_reusable_form	formitem
69	icekit_plugins_slideshow	slideshow
70	icekit_plugins_slideshow	slideshowitem
71	icekit_plugins_twitter_embed	twitterembeditem
72	model_settings	setting
73	model_settings	boolean
74	model_settings	date
75	model_settings	datetime
76	model_settings	decimal
77	model_settings	file
78	model_settings	float
79	model_settings	image
80	model_settings	integer
81	model_settings	text
82	model_settings	time
83	polymorphic_auth	user
84	polymorphic_auth_email	emailuser
85	post_office	email
86	post_office	log
87	post_office	emailtemplate
88	post_office	attachment
89	fluentpage	fluentpage
90	tests	article
91	tests	layoutpagewithrelatedpages
92	tests	basemodel
93	tests	foowithlayout
94	tests	barwithlayout
95	tests	bazwithlayout
96	tests	imagetest
97	tests	unpublishablelayoutpage
98	icekit_workflow	workflowstate
99	icekit_article	article
100	icekit_article	articlecategorypage
101	icekit_authors	authorlisting
102	icekit_authors	author
103	icekit_plugins_contact_person	contactperson
104	icekit_plugins_contact_person	contactpersonitem
105	icekit_plugins_content_listing	contentlistingitem
106	icekit_plugins_image	imagerepurposeconfig
107	ik_links	pagelink
108	ik_links	articlelink
109	ik_links	authorlink
110	image_gallery	imagegalleryshowitem
111	tests	articlelisting
112	tests	publishingm2mmodela
113	tests	publishingm2mmodelb
114	tests	publishingm2mthroughtable
115	glamkit_sponsors	sponsor
116	glamkit_sponsors	beginsponsorblockitem
117	glamkit_sponsors	endsponsorblockitem
118	glamkit_sponsors	sponsorpromoitem
119	icekit_press_releases	pressreleaselisting
120	icekit_press_releases	pressrelease
121	icekit_press_releases	pressreleasecategory
122	authtoken	token
123	icekit_events	eventbase
124	icekit_events	recurrencerule
125	icekit_events	eventtype
126	icekit_events	eventrepeatsgenerator
127	icekit_events	occurrence
128	icekit_event_types_simple	simpleevent
129	ik_event_listing	eventcontentlistingitem
130	icekit_events_links	eventlink
131	ik_events_todays_occurrences	todaysoccurrences
132	eventlistingfordate	eventlistingpage
133	glamkit_collections	country
134	glamkit_collections	geographiclocation
\.


--
-- TOC entry 4159 (class 0 OID 0)
-- Dependencies: 207
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_content_type_id_seq', 134, true);


--
-- TOC entry 3855 (class 0 OID 33260)
-- Dependencies: 208
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2016-08-24 02:13:25.855879+00
2	auth	0001_initial	2016-08-24 02:13:25.976812+00
3	polymorphic_auth	0001_initial	2016-08-24 02:13:26.077695+00
4	admin	0001_initial	2016-08-24 02:13:26.139444+00
5	contenttypes	0002_remove_content_type_name	2016-08-24 02:13:26.219714+00
6	auth	0002_alter_permission_name_max_length	2016-08-24 02:13:26.248789+00
7	auth	0003_alter_user_email_max_length	2016-08-24 02:13:26.278645+00
8	auth	0004_alter_user_username_opts	2016-08-24 02:13:26.310077+00
9	auth	0005_alter_user_last_login_null	2016-08-24 02:13:26.340966+00
10	auth	0006_require_contenttypes_0002	2016-08-24 02:13:26.346269+00
11	djcelery	0001_initial	2016-08-24 02:13:26.664734+00
12	easy_thumbnails	0001_initial	2016-08-24 02:13:26.800746+00
13	easy_thumbnails	0002_thumbnaildimensions	2016-08-24 02:13:26.831434+00
14	fluent_contents	0001_initial	2016-08-24 02:13:27.089096+00
15	sites	0001_initial	2016-08-24 02:13:27.126215+00
16	fluent_pages	0001_initial	2016-08-24 02:13:27.571205+00
17	fluentpage	0001_initial	2016-08-24 02:13:27.632115+00
18	forms	0001_initial	2016-08-24 02:13:27.98093+00
19	forms	0002_auto_20160418_0120	2016-08-24 02:13:28.061196+00
20	icekit	0001_initial	2016-08-24 02:13:28.108213+00
21	icekit	0002_layout	2016-08-24 02:13:28.161937+00
22	icekit	0003_layout_content_types	2016-08-24 02:13:28.266605+00
23	icekit	0004_auto_20150611_2044	2016-08-24 02:13:28.378128+00
24	icekit	0005_remove_layout_key	2016-08-24 02:13:28.464237+00
25	icekit	0006_auto_20150911_0744	2016-08-24 02:13:28.568653+00
26	icekit_plugins_child_pages	0001_initial	2016-08-24 02:13:28.661512+00
27	icekit_plugins_child_pages	0002_auto_20160821_2140	2016-08-24 02:13:28.757305+00
28	icekit_plugins_faq	0001_initial	2016-08-24 02:13:28.86761+00
29	icekit_plugins_faq	0002_auto_20151013_1330	2016-08-24 02:13:29.034543+00
30	icekit_plugins_faq	0003_auto_20160821_2140	2016-08-24 02:13:29.145711+00
31	icekit_plugins_file	0001_initial	2016-08-24 02:13:29.358014+00
32	icekit_plugins_file	0002_auto_20160821_2140	2016-08-24 02:13:29.781114+00
33	icekit_plugins_horizontal_rule	0001_initial	2016-08-24 02:13:29.892225+00
34	icekit_plugins_horizontal_rule	0002_auto_20160821_2140	2016-08-24 02:13:30.003057+00
35	icekit_plugins_image	0001_initial	2016-08-24 02:13:30.290686+00
36	icekit_plugins_image	0002_auto_20150527_0022	2016-08-24 02:13:30.407792+00
37	icekit_plugins_image	0003_auto_20150623_0115	2016-08-24 02:13:30.527101+00
38	icekit_plugins_image	0004_auto_20151001_2023	2016-08-24 02:13:30.748381+00
39	icekit_plugins_image	0005_imageitem_caption_override	2016-08-24 02:13:30.887522+00
40	icekit_plugins_image	0006_auto_20160309_0453	2016-08-24 02:13:31.236529+00
41	icekit_plugins_instagram_embed	0001_initial	2016-08-24 02:13:31.360022+00
42	icekit_plugins_instagram_embed	0002_auto_20150723_1939	2016-08-24 02:13:31.475373+00
43	icekit_plugins_instagram_embed	0003_auto_20150724_0213	2016-08-24 02:13:32.441303+00
44	icekit_plugins_instagram_embed	0004_auto_20160821_2140	2016-08-24 02:13:32.560972+00
45	icekit_plugins_map	0001_initial	2016-08-24 02:13:32.679764+00
46	icekit_plugins_map	0002_auto_20160821_2140	2016-08-24 02:13:32.792527+00
47	icekit_plugins_map_with_text	0001_initial	2016-08-24 02:13:32.916016+00
48	icekit_plugins_map_with_text	0002_auto_20150906_2301	2016-08-24 02:13:32.92387+00
49	icekit_plugins_map_with_text	0003_mapwithtextitem	2016-08-24 02:13:32.928406+00
50	icekit_plugins_map_with_text	0002_auto_20160821_2140	2016-08-24 02:13:33.053894+00
51	icekit_plugins_oembed_with_caption	0001_initial	2016-08-24 02:13:33.196298+00
52	icekit_plugins_oembed_with_caption	0002_auto_20160821_2140	2016-08-24 02:13:33.315721+00
53	icekit_plugins_page_anchor	0001_initial	2016-08-24 02:13:33.458282+00
54	icekit_plugins_page_anchor	0002_auto_20160821_2140	2016-08-24 02:13:33.595086+00
55	icekit_plugins_page_anchor_list	0001_initial	2016-08-24 02:13:33.744497+00
56	icekit_plugins_page_anchor_list	0002_auto_20160821_2140	2016-08-24 02:13:33.889574+00
57	icekit_plugins_quote	0001_initial	2016-08-24 02:13:34.027904+00
58	icekit_plugins_quote	0002_auto_20160821_2140	2016-08-24 02:13:34.171296+00
59	icekit_plugins_reusable_form	0001_initial	2016-08-24 02:13:34.311973+00
60	icekit_plugins_reusable_form	0002_auto_20160821_2140	2016-08-24 02:13:34.458913+00
61	icekit_plugins_slideshow	0001_initial	2016-08-24 02:13:34.626889+00
62	icekit_plugins_slideshow	0002_auto_20150623_0115	2016-08-24 02:13:34.75606+00
63	icekit_plugins_slideshow	0003_auto_20160404_0118	2016-08-24 02:13:35.351541+00
64	icekit_plugins_slideshow	0004_auto_20160821_2140	2016-08-24 02:13:35.660761+00
65	icekit_plugins_twitter_embed	0001_initial	2016-08-24 02:13:35.821296+00
66	icekit_plugins_twitter_embed	0002_auto_20150724_0213	2016-08-24 02:13:36.105563+00
67	icekit_plugins_twitter_embed	0003_auto_20160821_2140	2016-08-24 02:13:36.798497+00
68	iframe	0001_initial	2016-08-24 02:13:36.943476+00
69	kombu_transport_django	0001_initial	2016-08-24 02:13:37.063531+00
70	layout_page	0001_initial	2016-08-24 02:13:37.248755+00
71	layout_page	0002_auto_20160419_2209	2016-08-24 02:13:37.862614+00
72	layout_page	0003_auto_20160810_1856	2016-08-24 02:13:38.014018+00
73	model_settings	0001_initial	2016-08-24 02:13:38.665621+00
74	model_settings	0002_auto_20150810_1620	2016-08-24 02:13:38.891372+00
75	notifications	0001_initial	2016-08-24 02:13:40.162508+00
76	notifications	0002_auto_20150901_2126	2016-08-24 02:13:40.664569+00
77	oembeditem	0001_initial	2016-08-24 02:13:40.889073+00
78	picture	0001_initial	2016-08-24 02:13:41.605344+00
79	polymorphic_auth	0002_auto_20160725_2124	2016-08-24 02:13:42.054264+00
80	polymorphic_auth_email	0001_initial	2016-08-24 02:13:42.286797+00
81	post_office	0001_initial	2016-08-24 02:13:42.557035+00
82	post_office	0002_add_i18n_and_backend_alias	2016-08-24 02:13:43.182327+00
83	post_office	0003_longer_subject	2016-08-24 02:13:43.284124+00
84	rawhtml	0001_initial	2016-08-24 02:13:43.531924+00
85	redirectnode	0001_initial	2016-08-24 02:13:44.233527+00
86	redirects	0001_initial	2016-08-24 02:13:44.543284+00
87	response_pages	0001_initial	2016-08-24 02:13:44.598859+00
88	reversion	0001_initial	2016-08-24 02:13:45.181979+00
89	reversion	0002_auto_20141216_1509	2016-08-24 02:13:45.486124+00
90	search_page	0001_initial	2016-08-24 02:13:45.753789+00
91	search_page	0002_auto_20160420_0029	2016-08-24 02:13:47.224593+00
92	search_page	0003_auto_20160810_1856	2016-08-24 02:13:47.448045+00
93	sessions	0001_initial	2016-08-24 02:13:47.499672+00
94	sharedcontent	0001_initial	2016-08-24 02:13:48.815187+00
95	tests	0001_initial	2016-08-24 02:13:49.684215+00
96	tests	0002_unpublishablelayoutpage	2016-08-24 02:13:49.974465+00
97	tests	0003_auto_20160810_2054	2016-08-24 02:13:51.195847+00
98	text	0001_initial	2016-08-24 02:13:51.520361+00
99	text	0002_textitem_text_final	2016-08-24 02:13:51.800886+00
100	icekit_plugins_map_with_text	0001_squashed_0003_mapwithtextitem	2016-08-24 02:13:51.810887+00
101	authtoken	0001_initial	2017-05-10 00:40:16.851871+00
102	authtoken	0002_auto_20160226_1747	2017-05-10 00:40:17.345906+00
103	icekit_plugins_image	0007_auto_20160920_1626	2017-05-10 00:40:18.305288+00
104	icekit_plugins_image	0008_auto_20160920_2114	2017-05-10 00:40:18.603483+00
105	icekit_plugins_image	0009_auto_20161026_2044	2017-05-10 00:40:18.850142+00
106	eventlistingfordate	0001_initial	2017-05-10 00:40:19.214273+00
107	eventlistingfordate	0002_auto_20161018_1113	2017-05-10 00:40:19.452656+00
108	eventlistingfordate	0003_auto_20161019_1906	2017-05-10 00:40:19.606711+00
109	eventlistingfordate	0004_auto_20161115_1118	2017-05-10 00:40:20.607608+00
110	eventlistingfordate	0005_auto_20161130_1109	2017-05-10 00:40:20.869274+00
111	glamkit_collections	0001_initial	2017-05-10 00:40:21.303486+00
112	glamkit_collections	0002_auto_20170412_1520	2017-05-10 00:40:22.393526+00
113	glamkit_collections	0003_auto_20170412_1742	2017-05-10 00:40:22.565371+00
114	glamkit_sponsors	0001_initial	2017-05-10 00:40:22.951379+00
115	glamkit_sponsors	0002_beginsponsorblockitem_endsponsorblockitem_sponsorpromoitem	2017-05-10 00:40:23.868199+00
116	icekit	0007_auto_20170310_1220	2017-05-10 00:40:24.119247+00
117	icekit_article	0001_initial	2017-05-10 00:40:27.257098+00
118	icekit_article	0002_auto_20161019_1906	2017-05-10 00:40:27.472365+00
119	icekit_article	0003_auto_20161110_1125	2017-05-10 00:40:28.961421+00
120	icekit_article	0004_article_hero_image	2017-05-10 00:40:29.352402+00
121	icekit_article	0005_add_hero	2017-05-10 00:40:30.549851+00
122	icekit_article	0006_auto_20161117_1800	2017-05-10 00:40:30.966673+00
123	icekit_article	0007_auto_20161130_1109	2017-05-10 00:40:31.485928+00
124	icekit_plugins_image	0010_auto_20170307_1458	2017-05-10 00:40:34.584734+00
125	icekit_plugins_image	0011_auto_20170310_1853	2017-05-10 00:40:35.251962+00
126	icekit_plugins_image	0012_imagerepurposeconfig_is_cropping_allowed	2017-05-10 00:40:35.484192+00
127	icekit_plugins_image	0013_image_is_cropping_allowed	2017-05-10 00:40:35.811548+00
128	icekit_plugins_image	0014_image_external_ref	2017-05-10 00:40:36.235144+00
129	icekit_plugins_image	0015_auto_20170310_2004	2017-05-10 00:40:37.037099+00
130	icekit_plugins_image	0016_auto_20170314_1306	2017-05-10 00:40:37.140902+00
131	icekit_plugins_image	0017_auto_20170314_1352	2017-05-10 00:40:37.208628+00
132	icekit_plugins_image	0018_auto_20170314_1401	2017-05-10 00:40:37.237176+00
133	icekit_plugins_image	0016_auto_20170316_2021	2017-05-10 00:40:37.265066+00
134	icekit_plugins_image	0019_merge	2017-05-10 00:40:37.288776+00
135	icekit_plugins_image	0020_auto_20170317_1655	2017-05-10 00:40:37.335232+00
136	icekit_authors	0001_initial	2017-05-10 00:40:38.489545+00
137	icekit_authors	0002_auto_20161011_1522	2017-05-10 00:40:39.134306+00
138	icekit_authors	0003_auto_20161115_1118	2017-05-10 00:40:40.491718+00
139	icekit_authors	0004_auto_20161117_1201	2017-05-10 00:40:41.671519+00
140	icekit_authors	0005_auto_20161117_1824	2017-05-10 00:40:42.023945+00
141	icekit_authors	0006_auto_20161117_1825	2017-05-10 00:40:42.614779+00
142	icekit_authors	0007_auto_20161125_1720	2017-05-10 00:40:43.41667+00
143	icekit_authors	0008_auto_20161128_1049	2017-05-10 00:40:44.088293+00
144	icekit_authors	0009_auto_20170317_1655	2017-05-10 00:40:44.852356+00
145	icekit_authors	0010_auto_20170317_1656	2017-05-10 00:40:45.544185+00
146	icekit_events	0001_initial	2017-05-10 00:40:47.890864+00
147	icekit_event_types_simple	0001_initial	2017-05-10 00:40:50.217702+00
148	icekit_event_types_simple	0002_simpleevent_layout	2017-05-10 00:40:50.597807+00
149	icekit_event_types_simple	0003_auto_20161125_1701	2017-05-10 00:40:50.940855+00
150	icekit_events	0002_recurrence_rules	2017-05-10 00:40:51.219429+00
151	icekit_events	0003_auto_20161021_1658	2017-05-10 00:40:51.959548+00
152	icekit_events	0004_eventbase_part_of	2017-05-10 00:40:52.334441+00
153	icekit_events	0005_auto_20161024_1742	2017-05-10 00:40:53.369741+00
154	icekit_events	0006_auto_20161107_1747	2017-05-10 00:40:54.336371+00
155	icekit_events	0007_type_fixtures	2017-05-10 00:40:54.436599+00
156	icekit_events	0008_occurrence_external_ref	2017-05-10 00:40:54.80418+00
157	icekit_events	0009_auto_20161125_1538	2017-05-10 00:40:55.85733+00
158	icekit_events	0010_eventbase_is_drop_in	2017-05-10 00:40:56.7477+00
159	icekit_events	0011_auto_20161128_1049	2017-05-10 00:40:58.754147+00
160	icekit_events	0012_occurrence_status	2017-05-10 00:40:59.092657+00
161	icekit_events	0012_eventtype_title_plural	2017-05-10 00:40:59.856624+00
162	icekit_events	0013_merge	2017-05-10 00:40:59.886293+00
163	icekit_events	0014_eventbase_human_times	2017-05-10 00:41:00.825406+00
164	icekit_events	0015_auto_20161208_0029	2017-05-10 00:41:01.258932+00
165	icekit_events	0016_auto_20161208_0030	2017-05-10 00:41:01.76094+00
166	icekit_events	0017_eventtype_color	2017-05-10 00:41:02.484136+00
167	icekit_events	0018_auto_20170307_1458	2017-05-10 00:41:02.920123+00
168	icekit_events	0019_auto_20170310_1220	2017-05-10 00:41:04.116957+00
169	icekit_events	0020_auto_20170317_1341	2017-05-10 00:41:04.642085+00
170	icekit_events	0018_auto_20170314_1401	2017-05-10 00:41:05.144244+00
171	icekit_events	0021_merge	2017-05-10 00:41:05.210912+00
172	icekit_events	0022_auto_20170320_1807	2017-05-10 00:41:06.422571+00
173	icekit_events	0023_auto_20170320_1820	2017-05-10 00:41:07.263282+00
174	icekit_events	0024_auto_20170320_1824	2017-05-10 00:41:07.810216+00
175	icekit_events_links	0001_initial	2017-05-10 00:41:08.666084+00
176	icekit_events_links	0002_auto_20170314_1401	2017-05-10 00:41:09.158638+00
177	icekit_plugins_child_pages	0003_auto_20161123_1827	2017-05-10 00:41:09.566554+00
178	icekit_plugins_contact_person	0001_initial	2017-05-10 00:41:10.859047+00
179	icekit_plugins_contact_person	0002_auto_20161110_1531	2017-05-10 00:41:11.289911+00
180	icekit_plugins_content_listing	0001_initial	2017-05-10 00:41:11.825066+00
181	icekit_plugins_content_listing	0002_contentlistingitem_limit	2017-05-10 00:41:12.286075+00
182	icekit_plugins_content_listing	0003_contentlistingitem_no_items_message	2017-05-10 00:41:12.742676+00
183	icekit_plugins_image	0011_auto_20170310_1220	2017-05-10 00:41:13.700614+00
184	icekit_plugins_image	0021_merge	2017-05-10 00:41:16.280457+00
185	icekit_plugins_oembed_with_caption	0003_oembedwithcaptionitem_is_16by9	2017-05-10 00:41:16.886205+00
186	icekit_plugins_oembed_with_caption	0004_auto_20160919_2008	2017-05-10 00:41:17.269081+00
187	icekit_plugins_oembed_with_caption	0005_auto_20161027_1711	2017-05-10 00:41:17.63946+00
188	icekit_plugins_oembed_with_caption	0006_auto_20161027_2330	2017-05-10 00:41:18.475936+00
189	icekit_plugins_oembed_with_caption	0007_auto_20161110_1513	2017-05-10 00:41:18.872968+00
190	icekit_plugins_page_anchor	0003_auto_20161125_1538	2017-05-10 00:41:19.293815+00
191	icekit_plugins_page_anchor	0004_auto_20161130_0741	2017-05-10 00:41:19.791379+00
192	icekit_plugins_quote	0003_auto_20160912_2218	2017-05-10 00:41:20.777202+00
193	icekit_plugins_quote	0004_auto_20161027_1717	2017-05-10 00:41:21.698721+00
194	icekit_plugins_slideshow	0005_auto_20160927_2305	2017-05-10 00:41:22.656353+00
195	icekit_press_releases	0001_initial	2017-05-10 00:41:26.331595+00
196	icekit_press_releases	0002_auto_20160810_1832	2017-05-10 00:41:28.435143+00
197	icekit_press_releases	0003_auto_20160810_1856	2017-05-10 00:41:30.456006+00
198	icekit_press_releases	0004_auto_20160926_2341	2017-05-10 00:41:31.200202+00
199	icekit_press_releases	0005_auto_20161110_1531	2017-05-10 00:41:34.336444+00
200	icekit_press_releases	0006_auto_20161115_1118	2017-05-10 00:41:36.221167+00
201	icekit_press_releases	0007_auto_20161117_1201	2017-05-10 00:41:38.07047+00
202	icekit_press_releases	0008_auto_20161128_1049	2017-05-10 00:41:38.803225+00
203	icekit_workflow	0001_initial	2017-05-10 00:41:39.474015+00
204	icekit_workflow	0002_auto_20161128_1105	2017-05-10 00:41:40.019994+00
205	icekit_workflow	0003_auto_20161130_0741	2017-05-10 00:41:40.508415+00
206	icekit_workflow	0004_auto_20170130_1146	2017-05-10 00:41:41.103552+00
207	icekit_workflow	0005_auto_20170208_1146	2017-05-10 00:41:41.686143+00
208	icekit_workflow	0006_auto_20170308_2044	2017-05-10 00:41:43.043061+00
209	ik_event_listing	0001_initial	2017-05-10 00:41:43.638409+00
210	ik_event_listing	0002_auto_20170222_1136	2017-05-10 00:41:46.656738+00
211	ik_event_listing	0003_eventcontentlistingitem_no_items_message	2017-05-10 00:41:47.20814+00
212	ik_events_todays_occurrences	0001_initial	2017-05-10 00:41:47.94939+00
213	ik_events_todays_occurrences	0002_auto_20161207_1928	2017-05-10 00:41:49.283743+00
214	ik_links	0001_initial	2017-05-10 00:41:51.393148+00
215	ik_links	0002_auto_20161117_1221	2017-05-10 00:41:55.19228+00
216	ik_links	0003_auto_20161117_1810	2017-05-10 00:41:57.13011+00
217	ik_links	0004_auto_20170314_1401	2017-05-10 00:41:58.787543+00
218	image_gallery	0001_initial	2017-05-10 00:41:59.404667+00
219	image_gallery	0002_auto_20160927_2305	2017-05-10 00:42:00.154501+00
220	layout_page	0004_auto_20161110_1737	2017-05-10 00:42:02.85787+00
221	layout_page	0005_auto_20161125_1709	2017-05-10 00:42:03.672533+00
222	layout_page	0006_auto_20161130_1109	2017-05-10 00:42:04.57773+00
223	post_office	0004_auto_20160607_0901	2017-05-10 00:42:07.318785+00
224	search_page	0004_auto_20161122_2121	2017-05-10 00:42:09.606614+00
225	search_page	0005_auto_20161125_1720	2017-05-10 00:42:11.298691+00
226	search_page	0006_searchpage_default_search_type	2017-05-10 00:42:12.341154+00
227	tests	0004_auto_20160925_0758	2017-05-10 00:42:16.467225+00
228	tests	0005_auto_20161027_1428	2017-05-10 00:42:17.303392+00
229	tests	0006_auto_20161115_1219	2017-05-10 00:42:25.030392+00
230	tests	0007_auto_20161118_1044	2017-05-10 00:42:28.275749+00
231	tests	0008_auto_20161204_1456	2017-05-10 00:42:32.284165+00
232	text	0002_textitem_style	2017-05-10 00:42:33.621479+00
\.


--
-- TOC entry 4160 (class 0 OID 0)
-- Dependencies: 209
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_migrations_id_seq', 232, true);


--
-- TOC entry 3857 (class 0 OID 33268)
-- Dependencies: 210
-- Data for Name: django_redirect; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_redirect (id, site_id, old_path, new_path) FROM stdin;
\.


--
-- TOC entry 4161 (class 0 OID 0)
-- Dependencies: 211
-- Name: django_redirect_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_redirect_id_seq', 1, false);


--
-- TOC entry 3859 (class 0 OID 33273)
-- Dependencies: 212
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- TOC entry 3860 (class 0 OID 33279)
-- Dependencies: 213
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_site (id, domain, name) FROM stdin;
1	project-template.lvh.me	project_template
\.


--
-- TOC entry 4162 (class 0 OID 0)
-- Dependencies: 214
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_site_id_seq', 1, true);


--
-- TOC entry 3862 (class 0 OID 33284)
-- Dependencies: 215
-- Data for Name: djcelery_crontabschedule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY djcelery_crontabschedule (id, minute, hour, day_of_week, day_of_month, month_of_year) FROM stdin;
\.


--
-- TOC entry 4163 (class 0 OID 0)
-- Dependencies: 216
-- Name: djcelery_crontabschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('djcelery_crontabschedule_id_seq', 1, false);


--
-- TOC entry 3864 (class 0 OID 33289)
-- Dependencies: 217
-- Data for Name: djcelery_intervalschedule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY djcelery_intervalschedule (id, every, period) FROM stdin;
\.


--
-- TOC entry 4164 (class 0 OID 0)
-- Dependencies: 218
-- Name: djcelery_intervalschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('djcelery_intervalschedule_id_seq', 1, false);


--
-- TOC entry 3866 (class 0 OID 33294)
-- Dependencies: 219
-- Data for Name: djcelery_periodictask; Type: TABLE DATA; Schema: public; Owner: -
--

COPY djcelery_periodictask (id, name, task, args, kwargs, queue, exchange, routing_key, expires, enabled, last_run_at, total_run_count, date_changed, description, crontab_id, interval_id) FROM stdin;
\.


--
-- TOC entry 4165 (class 0 OID 0)
-- Dependencies: 220
-- Name: djcelery_periodictask_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('djcelery_periodictask_id_seq', 1, false);


--
-- TOC entry 3868 (class 0 OID 33303)
-- Dependencies: 221
-- Data for Name: djcelery_periodictasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY djcelery_periodictasks (ident, last_update) FROM stdin;
\.


--
-- TOC entry 3869 (class 0 OID 33306)
-- Dependencies: 222
-- Data for Name: djcelery_taskstate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY djcelery_taskstate (id, state, task_id, name, tstamp, args, kwargs, eta, expires, result, traceback, runtime, retries, hidden, worker_id) FROM stdin;
\.


--
-- TOC entry 4166 (class 0 OID 0)
-- Dependencies: 223
-- Name: djcelery_taskstate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('djcelery_taskstate_id_seq', 1, false);


--
-- TOC entry 3871 (class 0 OID 33314)
-- Dependencies: 224
-- Data for Name: djcelery_workerstate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY djcelery_workerstate (id, hostname, last_heartbeat) FROM stdin;
\.


--
-- TOC entry 4167 (class 0 OID 0)
-- Dependencies: 225
-- Name: djcelery_workerstate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('djcelery_workerstate_id_seq', 1, false);


--
-- TOC entry 3873 (class 0 OID 33319)
-- Dependencies: 226
-- Data for Name: djkombu_message; Type: TABLE DATA; Schema: public; Owner: -
--

COPY djkombu_message (id, visible, sent_at, payload, queue_id) FROM stdin;
\.


--
-- TOC entry 4168 (class 0 OID 0)
-- Dependencies: 227
-- Name: djkombu_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('djkombu_message_id_seq', 1, false);


--
-- TOC entry 3875 (class 0 OID 33327)
-- Dependencies: 228
-- Data for Name: djkombu_queue; Type: TABLE DATA; Schema: public; Owner: -
--

COPY djkombu_queue (id, name) FROM stdin;
\.


--
-- TOC entry 4169 (class 0 OID 0)
-- Dependencies: 229
-- Name: djkombu_queue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('djkombu_queue_id_seq', 1, false);


--
-- TOC entry 3877 (class 0 OID 33332)
-- Dependencies: 230
-- Data for Name: easy_thumbnails_source; Type: TABLE DATA; Schema: public; Owner: -
--

COPY easy_thumbnails_source (id, storage_hash, name, modified) FROM stdin;
\.


--
-- TOC entry 4170 (class 0 OID 0)
-- Dependencies: 231
-- Name: easy_thumbnails_source_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('easy_thumbnails_source_id_seq', 1, false);


--
-- TOC entry 3879 (class 0 OID 33337)
-- Dependencies: 232
-- Data for Name: easy_thumbnails_thumbnail; Type: TABLE DATA; Schema: public; Owner: -
--

COPY easy_thumbnails_thumbnail (id, storage_hash, name, modified, source_id) FROM stdin;
\.


--
-- TOC entry 4171 (class 0 OID 0)
-- Dependencies: 233
-- Name: easy_thumbnails_thumbnail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('easy_thumbnails_thumbnail_id_seq', 1, false);


--
-- TOC entry 3881 (class 0 OID 33342)
-- Dependencies: 234
-- Data for Name: easy_thumbnails_thumbnaildimensions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY easy_thumbnails_thumbnaildimensions (id, thumbnail_id, width, height) FROM stdin;
\.


--
-- TOC entry 4172 (class 0 OID 0)
-- Dependencies: 235
-- Name: easy_thumbnails_thumbnaildimensions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('easy_thumbnails_thumbnaildimensions_id_seq', 1, false);


--
-- TOC entry 4173 (class 0 OID 0)
-- Dependencies: 237
-- Name: file_file_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('file_file_categories_id_seq', 1, false);


--
-- TOC entry 4174 (class 0 OID 0)
-- Dependencies: 239
-- Name: file_file_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('file_file_id_seq', 1, false);


--
-- TOC entry 3887 (class 0 OID 33362)
-- Dependencies: 240
-- Data for Name: fluent_contents_contentitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_contents_contentitem (id, parent_id, language_code, sort_order, parent_type_id, placeholder_id, polymorphic_ctype_id) FROM stdin;
\.


--
-- TOC entry 4175 (class 0 OID 0)
-- Dependencies: 241
-- Name: fluent_contents_contentitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_contents_contentitem_id_seq', 1, false);


--
-- TOC entry 3889 (class 0 OID 33367)
-- Dependencies: 242
-- Data for Name: fluent_contents_placeholder; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_contents_placeholder (id, slot, role, parent_id, title, parent_type_id) FROM stdin;
\.


--
-- TOC entry 4176 (class 0 OID 0)
-- Dependencies: 243
-- Name: fluent_contents_placeholder_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_contents_placeholder_id_seq', 1, false);


--
-- TOC entry 3891 (class 0 OID 33372)
-- Dependencies: 244
-- Data for Name: fluent_pages_htmlpage_translation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_pages_htmlpage_translation (id, language_code, meta_keywords, meta_description, meta_title, master_id) FROM stdin;
\.


--
-- TOC entry 4177 (class 0 OID 0)
-- Dependencies: 245
-- Name: fluent_pages_htmlpage_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_pages_htmlpage_translation_id_seq', 1, false);


--
-- TOC entry 3893 (class 0 OID 33380)
-- Dependencies: 246
-- Data for Name: fluent_pages_pagelayout; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_pages_pagelayout (id, key, title, template_path) FROM stdin;
\.


--
-- TOC entry 4178 (class 0 OID 0)
-- Dependencies: 247
-- Name: fluent_pages_pagelayout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_pages_pagelayout_id_seq', 1, false);


--
-- TOC entry 3895 (class 0 OID 33385)
-- Dependencies: 248
-- Data for Name: fluent_pages_urlnode; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_pages_urlnode (id, lft, rght, tree_id, level, status, publication_date, publication_end_date, in_navigation, in_sitemaps, key, creation_date, modification_date, author_id, parent_id, parent_site_id, polymorphic_ctype_id) FROM stdin;
\.


--
-- TOC entry 4179 (class 0 OID 0)
-- Dependencies: 249
-- Name: fluent_pages_urlnode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_pages_urlnode_id_seq', 1, false);


--
-- TOC entry 3897 (class 0 OID 33394)
-- Dependencies: 250
-- Data for Name: fluent_pages_urlnode_translation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fluent_pages_urlnode_translation (id, language_code, title, slug, override_url, _cached_url, master_id) FROM stdin;
\.


--
-- TOC entry 4180 (class 0 OID 0)
-- Dependencies: 251
-- Name: fluent_pages_urlnode_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fluent_pages_urlnode_translation_id_seq', 1, false);


--
-- TOC entry 3899 (class 0 OID 33402)
-- Dependencies: 252
-- Data for Name: forms_field; Type: TABLE DATA; Schema: public; Owner: -
--

COPY forms_field (id, label, slug, field_type, required, visible, choices, "default", placeholder_text, help_text, "order", form_id) FROM stdin;
\.


--
-- TOC entry 4181 (class 0 OID 0)
-- Dependencies: 253
-- Name: forms_field_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('forms_field_id_seq', 1, false);


--
-- TOC entry 3901 (class 0 OID 33410)
-- Dependencies: 254
-- Data for Name: forms_fieldentry; Type: TABLE DATA; Schema: public; Owner: -
--

COPY forms_fieldentry (id, field_id, value, entry_id) FROM stdin;
\.


--
-- TOC entry 4182 (class 0 OID 0)
-- Dependencies: 255
-- Name: forms_fieldentry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('forms_fieldentry_id_seq', 1, false);


--
-- TOC entry 3903 (class 0 OID 33418)
-- Dependencies: 256
-- Data for Name: forms_form; Type: TABLE DATA; Schema: public; Owner: -
--

COPY forms_form (id, title, slug, intro, button_text, response, redirect_url, status, publish_date, expiry_date, login_required, send_email, email_from, email_copies, email_subject, email_message) FROM stdin;
\.


--
-- TOC entry 4183 (class 0 OID 0)
-- Dependencies: 257
-- Name: forms_form_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('forms_form_id_seq', 1, false);


--
-- TOC entry 3905 (class 0 OID 33426)
-- Dependencies: 258
-- Data for Name: forms_form_sites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY forms_form_sites (id, form_id, site_id) FROM stdin;
\.


--
-- TOC entry 4184 (class 0 OID 0)
-- Dependencies: 259
-- Name: forms_form_sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('forms_form_sites_id_seq', 1, false);


--
-- TOC entry 3907 (class 0 OID 33431)
-- Dependencies: 260
-- Data for Name: forms_formentry; Type: TABLE DATA; Schema: public; Owner: -
--

COPY forms_formentry (id, entry_time, form_id) FROM stdin;
\.


--
-- TOC entry 4185 (class 0 OID 0)
-- Dependencies: 261
-- Name: forms_formentry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('forms_formentry_id_seq', 1, false);


--
-- TOC entry 3997 (class 0 OID 34929)
-- Dependencies: 350
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
-- TOC entry 4186 (class 0 OID 0)
-- Dependencies: 349
-- Name: glamkit_collections_country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('glamkit_collections_country_id_seq', 249, true);


--
-- TOC entry 3999 (class 0 OID 34940)
-- Dependencies: 352
-- Data for Name: glamkit_collections_geographiclocation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY glamkit_collections_geographiclocation (id, state_province, city, neighborhood, colloquial_historical, country_id) FROM stdin;
\.


--
-- TOC entry 4187 (class 0 OID 0)
-- Dependencies: 351
-- Name: glamkit_collections_geographiclocation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('glamkit_collections_geographiclocation_id_seq', 1, false);


--
-- TOC entry 4001 (class 0 OID 34959)
-- Dependencies: 354
-- Data for Name: glamkit_sponsors_sponsor; Type: TABLE DATA; Schema: public; Owner: -
--

COPY glamkit_sponsors_sponsor (id, name, url, logo_id) FROM stdin;
\.


--
-- TOC entry 4188 (class 0 OID 0)
-- Dependencies: 353
-- Name: glamkit_sponsors_sponsor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('glamkit_sponsors_sponsor_id_seq', 1, false);


--
-- TOC entry 4006 (class 0 OID 35018)
-- Dependencies: 359
-- Data for Name: icekit_article_article; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_article_article (id, publishing_is_draft, publishing_modified_at, publishing_published_at, title, slug, layout_id, parent_id, publishing_linked_id, boosted_search_terms, list_image, hero_image_id) FROM stdin;
\.


--
-- TOC entry 4189 (class 0 OID 0)
-- Dependencies: 358
-- Name: icekit_article_article_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_article_article_id_seq', 1, false);


--
-- TOC entry 4007 (class 0 OID 35027)
-- Dependencies: 360
-- Data for Name: icekit_articlecategorypage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_articlecategorypage (urlnode_ptr_id, publishing_is_draft, publishing_modified_at, publishing_published_at, layout_id, publishing_linked_id, boosted_search_terms, hero_image_id, list_image) FROM stdin;
\.


--
-- TOC entry 4012 (class 0 OID 35271)
-- Dependencies: 365
-- Data for Name: icekit_authorlisting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_authorlisting (urlnode_ptr_id, publishing_is_draft, publishing_modified_at, publishing_published_at, layout_id, publishing_linked_id, boosted_search_terms, hero_image_id, list_image) FROM stdin;
\.


--
-- TOC entry 4011 (class 0 OID 35260)
-- Dependencies: 364
-- Data for Name: icekit_authors_author; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_authors_author (id, publishing_is_draft, publishing_modified_at, publishing_published_at, given_names, family_name, slug, url, oneliner, hero_image_id, publishing_linked_id, boosted_search_terms, list_image) FROM stdin;
\.


--
-- TOC entry 4190 (class 0 OID 0)
-- Dependencies: 363
-- Name: icekit_authors_author_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_authors_author_id_seq', 1, false);


--
-- TOC entry 4021 (class 0 OID 35501)
-- Dependencies: 374
-- Data for Name: icekit_event_types_simple_simpleevent; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_event_types_simple_simpleevent (eventbase_ptr_id, layout_id) FROM stdin;
\.


--
-- TOC entry 4014 (class 0 OID 35401)
-- Dependencies: 367
-- Data for Name: icekit_events_eventbase; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_events_eventbase (id, publishing_is_draft, publishing_modified_at, publishing_published_at, title, slug, created, modified, show_in_calendar, human_dates, special_instructions, cta_text, cta_url, derived_from_id, polymorphic_ctype_id, publishing_linked_id, part_of_id, price_line, primary_type_id, external_ref, has_tickets_available, is_drop_in, human_times) FROM stdin;
\.


--
-- TOC entry 4191 (class 0 OID 0)
-- Dependencies: 366
-- Name: icekit_events_eventbase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_events_eventbase_id_seq', 1, false);


--
-- TOC entry 4025 (class 0 OID 35573)
-- Dependencies: 378
-- Data for Name: icekit_events_eventbase_secondary_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_events_eventbase_secondary_types (id, eventbase_id, eventtype_id) FROM stdin;
\.


--
-- TOC entry 4192 (class 0 OID 0)
-- Dependencies: 377
-- Name: icekit_events_eventbase_secondary_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_events_eventbase_secondary_types_id_seq', 1, false);


--
-- TOC entry 4016 (class 0 OID 35414)
-- Dependencies: 369
-- Data for Name: icekit_events_eventrepeatsgenerator; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_events_eventrepeatsgenerator (id, created, modified, recurrence_rule, start, "end", is_all_day, repeat_end, event_id) FROM stdin;
\.


--
-- TOC entry 4193 (class 0 OID 0)
-- Dependencies: 368
-- Name: icekit_events_eventrepeatsgenerator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_events_eventrepeatsgenerator_id_seq', 1, false);


--
-- TOC entry 4023 (class 0 OID 35562)
-- Dependencies: 376
-- Data for Name: icekit_events_eventtype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_events_eventtype (id, title, slug, is_public, title_plural, color) FROM stdin;
1	Education	education	f		#cccccc
2	Members	members	f		#cccccc
\.


--
-- TOC entry 4194 (class 0 OID 0)
-- Dependencies: 375
-- Name: icekit_events_eventtype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_events_eventtype_id_seq', 2, true);


--
-- TOC entry 4018 (class 0 OID 35425)
-- Dependencies: 371
-- Data for Name: icekit_events_occurrence; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_events_occurrence (id, created, modified, start, "end", is_all_day, is_protected_from_regeneration, is_cancelled, is_hidden, cancel_reason, original_start, original_end, event_id, generator_id, external_ref, status) FROM stdin;
\.


--
-- TOC entry 4195 (class 0 OID 0)
-- Dependencies: 370
-- Name: icekit_events_occurrence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_events_occurrence_id_seq', 1, false);


--
-- TOC entry 4020 (class 0 OID 35433)
-- Dependencies: 373
-- Data for Name: icekit_events_recurrencerule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_events_recurrencerule (id, created, modified, description, recurrence_rule) FROM stdin;
1	2017-05-10 00:40:50.985171+00	2017-05-10 00:40:51.155521+00	Daily	RRULE:FREQ=DAILY
2	2017-05-10 00:40:51.16156+00	2017-05-10 00:40:51.161768+00	Daily, Weekdays	RRULE:FREQ=DAILY;BYDAY=MO,TU,WE,TH,FR
3	2017-05-10 00:40:51.167856+00	2017-05-10 00:40:51.167941+00	Daily, Weekends	RRULE:FREQ=DAILY;BYDAY=SA,SU
4	2017-05-10 00:40:51.170917+00	2017-05-10 00:40:51.170994+00	Weekly	RRULE:FREQ=WEEKLY
5	2017-05-10 00:40:51.185152+00	2017-05-10 00:40:51.188311+00	Monthly	RRULE:FREQ=MONTHLY
6	2017-05-10 00:40:51.195377+00	2017-05-10 00:40:51.195477+00	Yearly	RRULE:FREQ=YEARLY
\.


--
-- TOC entry 4196 (class 0 OID 0)
-- Dependencies: 372
-- Name: icekit_events_recurrencerule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_events_recurrencerule_id_seq', 6, true);


--
-- TOC entry 3909 (class 0 OID 33436)
-- Dependencies: 262
-- Data for Name: icekit_layout; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_layout (id, created, modified, title, template_name) FROM stdin;
\.


--
-- TOC entry 3910 (class 0 OID 33442)
-- Dependencies: 263
-- Data for Name: icekit_layout_content_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_layout_content_types (id, layout_id, contenttype_id) FROM stdin;
\.


--
-- TOC entry 4197 (class 0 OID 0)
-- Dependencies: 264
-- Name: icekit_layout_content_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_layout_content_types_id_seq', 1, false);


--
-- TOC entry 4198 (class 0 OID 0)
-- Dependencies: 265
-- Name: icekit_layout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_layout_id_seq', 1, false);


--
-- TOC entry 3946 (class 0 OID 33544)
-- Dependencies: 299
-- Data for Name: icekit_layoutpage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_layoutpage (urlnode_ptr_id, layout_id, publishing_is_draft, publishing_linked_id, publishing_modified_at, publishing_published_at, boosted_search_terms, hero_image_id, list_image) FROM stdin;
\.


--
-- TOC entry 3913 (class 0 OID 33449)
-- Dependencies: 266
-- Data for Name: icekit_mediacategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_mediacategory (id, created, modified, name) FROM stdin;
\.


--
-- TOC entry 4199 (class 0 OID 0)
-- Dependencies: 267
-- Name: icekit_mediacategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_mediacategory_id_seq', 1, false);


--
-- TOC entry 4028 (class 0 OID 35759)
-- Dependencies: 381
-- Data for Name: icekit_plugins_contact_person_contactperson; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_plugins_contact_person_contactperson (id, name, title, phone, email) FROM stdin;
\.


--
-- TOC entry 4200 (class 0 OID 0)
-- Dependencies: 380
-- Name: icekit_plugins_contact_person_contactperson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_plugins_contact_person_contactperson_id_seq', 1, false);


--
-- TOC entry 3885 (class 0 OID 33354)
-- Dependencies: 238
-- Data for Name: icekit_plugins_file_file; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_plugins_file_file (id, file, title, is_active, admin_notes) FROM stdin;
\.


--
-- TOC entry 3883 (class 0 OID 33349)
-- Dependencies: 236
-- Data for Name: icekit_plugins_file_file_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_plugins_file_file_categories (id, file_id, mediacategory_id) FROM stdin;
\.


--
-- TOC entry 3915 (class 0 OID 33454)
-- Dependencies: 268
-- Data for Name: icekit_plugins_image_image; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_plugins_image_image (id, image, alt_text, title, caption, is_ok_for_web, notes, credit, date_created, date_modified, height, license, maximum_dimension_pixels, source, width, is_cropping_allowed, external_ref) FROM stdin;
\.


--
-- TOC entry 3916 (class 0 OID 33460)
-- Dependencies: 269
-- Data for Name: icekit_plugins_image_image_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_plugins_image_image_categories (id, image_id, mediacategory_id) FROM stdin;
\.


--
-- TOC entry 4009 (class 0 OID 35218)
-- Dependencies: 362
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
-- TOC entry 4201 (class 0 OID 0)
-- Dependencies: 361
-- Name: icekit_plugins_image_imagerepurposeconfig_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_plugins_image_imagerepurposeconfig_id_seq', 6, true);


--
-- TOC entry 3917 (class 0 OID 33463)
-- Dependencies: 270
-- Data for Name: icekit_plugins_slideshow_slideshow; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_plugins_slideshow_slideshow (id, title, show_title, publishing_is_draft, publishing_linked_id, publishing_modified_at, publishing_published_at) FROM stdin;
\.


--
-- TOC entry 4202 (class 0 OID 0)
-- Dependencies: 271
-- Name: icekit_plugins_slideshow_slideshow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_plugins_slideshow_slideshow_id_seq', 1, false);


--
-- TOC entry 4032 (class 0 OID 35850)
-- Dependencies: 385
-- Data for Name: icekit_press_releases_pressrelease; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_press_releases_pressrelease (id, publishing_is_draft, publishing_modified_at, publishing_published_at, title, slug, print_version, created, modified, released, category_id, layout_id, publishing_linked_id, boosted_search_terms, list_image) FROM stdin;
\.


--
-- TOC entry 4203 (class 0 OID 0)
-- Dependencies: 384
-- Name: icekit_press_releases_pressrelease_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_press_releases_pressrelease_id_seq', 1, false);


--
-- TOC entry 4034 (class 0 OID 35861)
-- Dependencies: 387
-- Data for Name: icekit_press_releases_pressreleasecategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_press_releases_pressreleasecategory (id, name) FROM stdin;
\.


--
-- TOC entry 4204 (class 0 OID 0)
-- Dependencies: 386
-- Name: icekit_press_releases_pressreleasecategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('icekit_press_releases_pressreleasecategory_id_seq', 1, false);


--
-- TOC entry 3948 (class 0 OID 33550)
-- Dependencies: 301
-- Data for Name: icekit_searchpage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_searchpage (urlnode_ptr_id, publishing_is_draft, publishing_linked_id, publishing_modified_at, publishing_published_at, boosted_search_terms, list_image, default_search_type) FROM stdin;
\.


--
-- TOC entry 4037 (class 0 OID 36026)
-- Dependencies: 390
-- Data for Name: icekit_workflow_workflowstate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY icekit_workflow_workflowstate (id, object_id, status, assigned_to_id, content_type_id, datetime_modified) FROM stdin;
\.


--
-- TOC entry 4040 (class 0 OID 36081)
-- Dependencies: 393
-- Data for Name: ik_event_listing_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ik_event_listing_types (id, eventcontentlistingitem_id, eventtype_id) FROM stdin;
\.


--
-- TOC entry 4205 (class 0 OID 0)
-- Dependencies: 392
-- Name: ik_event_listing_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('ik_event_listing_types_id_seq', 1, false);


--
-- TOC entry 4043 (class 0 OID 36108)
-- Dependencies: 396
-- Data for Name: ik_todays_occurrences_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ik_todays_occurrences_types (id, todaysoccurrences_id, eventtype_id) FROM stdin;
\.


--
-- TOC entry 4206 (class 0 OID 0)
-- Dependencies: 395
-- Name: ik_todays_occurrences_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('ik_todays_occurrences_types_id_seq', 1, false);


--
-- TOC entry 4207 (class 0 OID 0)
-- Dependencies: 272
-- Name: image_image_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('image_image_categories_id_seq', 1, false);


--
-- TOC entry 4208 (class 0 OID 0)
-- Dependencies: 273
-- Name: image_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('image_image_id_seq', 1, false);


--
-- TOC entry 3921 (class 0 OID 33472)
-- Dependencies: 274
-- Data for Name: model_settings_boolean; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_boolean (setting_ptr_id, value) FROM stdin;
\.


--
-- TOC entry 3922 (class 0 OID 33475)
-- Dependencies: 275
-- Data for Name: model_settings_date; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_date (setting_ptr_id, value) FROM stdin;
\.


--
-- TOC entry 3923 (class 0 OID 33478)
-- Dependencies: 276
-- Data for Name: model_settings_datetime; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_datetime (setting_ptr_id, value) FROM stdin;
\.


--
-- TOC entry 3924 (class 0 OID 33481)
-- Dependencies: 277
-- Data for Name: model_settings_decimal; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_decimal (setting_ptr_id, value) FROM stdin;
\.


--
-- TOC entry 3925 (class 0 OID 33484)
-- Dependencies: 278
-- Data for Name: model_settings_file; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_file (setting_ptr_id, value) FROM stdin;
\.


--
-- TOC entry 3926 (class 0 OID 33487)
-- Dependencies: 279
-- Data for Name: model_settings_float; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_float (setting_ptr_id, value) FROM stdin;
\.


--
-- TOC entry 3927 (class 0 OID 33490)
-- Dependencies: 280
-- Data for Name: model_settings_image; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_image (setting_ptr_id, value) FROM stdin;
\.


--
-- TOC entry 3928 (class 0 OID 33493)
-- Dependencies: 281
-- Data for Name: model_settings_integer; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_integer (setting_ptr_id, value) FROM stdin;
\.


--
-- TOC entry 3929 (class 0 OID 33496)
-- Dependencies: 282
-- Data for Name: model_settings_setting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_setting (id, name, polymorphic_ctype_id) FROM stdin;
\.


--
-- TOC entry 4209 (class 0 OID 0)
-- Dependencies: 283
-- Name: model_settings_setting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('model_settings_setting_id_seq', 1, false);


--
-- TOC entry 3931 (class 0 OID 33501)
-- Dependencies: 284
-- Data for Name: model_settings_text; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_text (setting_ptr_id, value) FROM stdin;
\.


--
-- TOC entry 3932 (class 0 OID 33504)
-- Dependencies: 285
-- Data for Name: model_settings_time; Type: TABLE DATA; Schema: public; Owner: -
--

COPY model_settings_time (setting_ptr_id, value) FROM stdin;
\.


--
-- TOC entry 3933 (class 0 OID 33507)
-- Dependencies: 286
-- Data for Name: notifications_followerinformation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifications_followerinformation (id, object_id, content_type_id, polymorphic_ctype_id) FROM stdin;
\.


--
-- TOC entry 3934 (class 0 OID 33511)
-- Dependencies: 287
-- Data for Name: notifications_followerinformation_followers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifications_followerinformation_followers (id, followerinformation_id, user_id) FROM stdin;
\.


--
-- TOC entry 4210 (class 0 OID 0)
-- Dependencies: 288
-- Name: notifications_followerinformation_followers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifications_followerinformation_followers_id_seq', 1, false);


--
-- TOC entry 3936 (class 0 OID 33516)
-- Dependencies: 289
-- Data for Name: notifications_followerinformation_group_followers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifications_followerinformation_group_followers (id, followerinformation_id, group_id) FROM stdin;
\.


--
-- TOC entry 4211 (class 0 OID 0)
-- Dependencies: 290
-- Name: notifications_followerinformation_group_followers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifications_followerinformation_group_followers_id_seq', 1, false);


--
-- TOC entry 4212 (class 0 OID 0)
-- Dependencies: 291
-- Name: notifications_followerinformation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifications_followerinformation_id_seq', 1, false);


--
-- TOC entry 3939 (class 0 OID 33523)
-- Dependencies: 292
-- Data for Name: notifications_hasreadmessage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifications_hasreadmessage (id, is_read, "time", is_removed, notification_setting, email_sent, message_id, person_id) FROM stdin;
\.


--
-- TOC entry 4213 (class 0 OID 0)
-- Dependencies: 293
-- Name: notifications_hasreadmessage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifications_hasreadmessage_id_seq', 1, false);


--
-- TOC entry 3941 (class 0 OID 33528)
-- Dependencies: 294
-- Data for Name: notifications_notification; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifications_notification (id, created, modified, title, notification, is_removed, user_id) FROM stdin;
\.


--
-- TOC entry 4214 (class 0 OID 0)
-- Dependencies: 295
-- Name: notifications_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifications_notification_id_seq', 1, false);


--
-- TOC entry 3943 (class 0 OID 33536)
-- Dependencies: 296
-- Data for Name: notifications_notificationsetting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifications_notificationsetting (id, notification_type, user_id) FROM stdin;
1	ALL	2
\.


--
-- TOC entry 4215 (class 0 OID 0)
-- Dependencies: 297
-- Name: notifications_notificationsetting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifications_notificationsetting_id_seq', 1, true);


--
-- TOC entry 3995 (class 0 OID 34867)
-- Dependencies: 348
-- Data for Name: pagetype_eventlistingfordate_eventlistingpage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pagetype_eventlistingfordate_eventlistingpage (urlnode_ptr_id, publishing_is_draft, publishing_modified_at, publishing_published_at, layout_id, publishing_linked_id, boosted_search_terms, hero_image_id, list_image) FROM stdin;
\.


--
-- TOC entry 3945 (class 0 OID 33541)
-- Dependencies: 298
-- Data for Name: pagetype_fluentpage_fluentpage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pagetype_fluentpage_fluentpage (urlnode_ptr_id, layout_id) FROM stdin;
\.


--
-- TOC entry 4035 (class 0 OID 35930)
-- Dependencies: 388
-- Data for Name: pagetype_icekit_press_releases_pressreleaselisting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pagetype_icekit_press_releases_pressreleaselisting (urlnode_ptr_id, publishing_is_draft, publishing_modified_at, publishing_published_at, layout_id, publishing_linked_id, boosted_search_terms, hero_image_id, list_image) FROM stdin;
\.


--
-- TOC entry 3947 (class 0 OID 33547)
-- Dependencies: 300
-- Data for Name: pagetype_redirectnode_redirectnode; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pagetype_redirectnode_redirectnode (urlnode_ptr_id) FROM stdin;
\.


--
-- TOC entry 3949 (class 0 OID 33553)
-- Dependencies: 302
-- Data for Name: pagetype_tests_unpublishablelayoutpage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pagetype_tests_unpublishablelayoutpage (urlnode_ptr_id, layout_id) FROM stdin;
\.


--
-- TOC entry 3950 (class 0 OID 33556)
-- Dependencies: 303
-- Data for Name: polymorphic_auth_email_emailuser; Type: TABLE DATA; Schema: public; Owner: -
--

COPY polymorphic_auth_email_emailuser (user_ptr_id, email) FROM stdin;
1	admin@icekit.lvh.me
2	admin@project-template.lvh.me
\.


--
-- TOC entry 3951 (class 0 OID 33559)
-- Dependencies: 304
-- Data for Name: polymorphic_auth_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY polymorphic_auth_user (id, password, last_login, is_superuser, is_staff, is_active, first_name, last_name, created, polymorphic_ctype_id) FROM stdin;
1	pbkdf2_sha256$20000$aWXZbSyC5ZCn$02VQwX/qpJYJeUzHufMpiKu5rmKm9SWp0qVIjRxhvsE=	\N	t	t	t	Admin		2016-08-24 02:13:52.672435+00	84
2	pbkdf2_sha256$20000$bu4PKJLq9ncW$wYqGjRrLdW/STqz/VgD17gWuNz8Q0j7g7RAFvPyMIhk=	\N	t	t	t	Admin		2017-05-10 00:42:33.83225+00	84
\.


--
-- TOC entry 3952 (class 0 OID 33565)
-- Dependencies: 305
-- Data for Name: polymorphic_auth_user_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY polymorphic_auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- TOC entry 4216 (class 0 OID 0)
-- Dependencies: 306
-- Name: polymorphic_auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('polymorphic_auth_user_groups_id_seq', 1, false);


--
-- TOC entry 4217 (class 0 OID 0)
-- Dependencies: 307
-- Name: polymorphic_auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('polymorphic_auth_user_id_seq', 2, true);


--
-- TOC entry 3955 (class 0 OID 33572)
-- Dependencies: 308
-- Data for Name: polymorphic_auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY polymorphic_auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- TOC entry 4218 (class 0 OID 0)
-- Dependencies: 309
-- Name: polymorphic_auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('polymorphic_auth_user_user_permissions_id_seq', 1, false);


--
-- TOC entry 3957 (class 0 OID 33577)
-- Dependencies: 310
-- Data for Name: post_office_attachment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY post_office_attachment (id, file, name) FROM stdin;
\.


--
-- TOC entry 3958 (class 0 OID 33580)
-- Dependencies: 311
-- Data for Name: post_office_attachment_emails; Type: TABLE DATA; Schema: public; Owner: -
--

COPY post_office_attachment_emails (id, attachment_id, email_id) FROM stdin;
\.


--
-- TOC entry 4219 (class 0 OID 0)
-- Dependencies: 312
-- Name: post_office_attachment_emails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('post_office_attachment_emails_id_seq', 1, false);


--
-- TOC entry 4220 (class 0 OID 0)
-- Dependencies: 313
-- Name: post_office_attachment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('post_office_attachment_id_seq', 1, false);


--
-- TOC entry 3961 (class 0 OID 33587)
-- Dependencies: 314
-- Data for Name: post_office_email; Type: TABLE DATA; Schema: public; Owner: -
--

COPY post_office_email (id, from_email, "to", cc, bcc, subject, message, html_message, status, priority, created, last_updated, scheduled_time, headers, context, template_id, backend_alias) FROM stdin;
\.


--
-- TOC entry 4221 (class 0 OID 0)
-- Dependencies: 315
-- Name: post_office_email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('post_office_email_id_seq', 1, false);


--
-- TOC entry 3963 (class 0 OID 33597)
-- Dependencies: 316
-- Data for Name: post_office_emailtemplate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY post_office_emailtemplate (id, name, description, subject, content, html_content, created, last_updated, default_template_id, language) FROM stdin;
\.


--
-- TOC entry 4222 (class 0 OID 0)
-- Dependencies: 317
-- Name: post_office_emailtemplate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('post_office_emailtemplate_id_seq', 1, false);


--
-- TOC entry 3965 (class 0 OID 33605)
-- Dependencies: 318
-- Data for Name: post_office_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY post_office_log (id, date, status, exception_type, message, email_id) FROM stdin;
\.


--
-- TOC entry 4223 (class 0 OID 0)
-- Dependencies: 319
-- Name: post_office_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('post_office_log_id_seq', 1, false);


--
-- TOC entry 3967 (class 0 OID 33614)
-- Dependencies: 320
-- Data for Name: redirectnode_redirectnode_translation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY redirectnode_redirectnode_translation (id, language_code, new_url, redirect_type, master_id) FROM stdin;
\.


--
-- TOC entry 4224 (class 0 OID 0)
-- Dependencies: 321
-- Name: redirectnode_redirectnode_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('redirectnode_redirectnode_translation_id_seq', 1, false);


--
-- TOC entry 3969 (class 0 OID 33619)
-- Dependencies: 322
-- Data for Name: response_pages_responsepage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY response_pages_responsepage (id, title, type, is_active) FROM stdin;
\.


--
-- TOC entry 4225 (class 0 OID 0)
-- Dependencies: 323
-- Name: response_pages_responsepage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('response_pages_responsepage_id_seq', 1, false);


--
-- TOC entry 3971 (class 0 OID 33624)
-- Dependencies: 324
-- Data for Name: reversion_revision; Type: TABLE DATA; Schema: public; Owner: -
--

COPY reversion_revision (id, manager_slug, date_created, comment, user_id) FROM stdin;
\.


--
-- TOC entry 4226 (class 0 OID 0)
-- Dependencies: 325
-- Name: reversion_revision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('reversion_revision_id_seq', 1, false);


--
-- TOC entry 3973 (class 0 OID 33632)
-- Dependencies: 326
-- Data for Name: reversion_version; Type: TABLE DATA; Schema: public; Owner: -
--

COPY reversion_version (id, object_id, object_id_int, format, serialized_data, object_repr, content_type_id, revision_id) FROM stdin;
\.


--
-- TOC entry 4227 (class 0 OID 0)
-- Dependencies: 327
-- Name: reversion_version_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('reversion_version_id_seq', 1, false);


--
-- TOC entry 3975 (class 0 OID 33640)
-- Dependencies: 328
-- Data for Name: sharedcontent_sharedcontent; Type: TABLE DATA; Schema: public; Owner: -
--

COPY sharedcontent_sharedcontent (id, slug, is_cross_site, parent_site_id) FROM stdin;
\.


--
-- TOC entry 4228 (class 0 OID 0)
-- Dependencies: 329
-- Name: sharedcontent_sharedcontent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sharedcontent_sharedcontent_id_seq', 1, false);


--
-- TOC entry 3977 (class 0 OID 33645)
-- Dependencies: 330
-- Data for Name: sharedcontent_sharedcontent_translation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY sharedcontent_sharedcontent_translation (id, language_code, title, master_id) FROM stdin;
\.


--
-- TOC entry 4229 (class 0 OID 0)
-- Dependencies: 331
-- Name: sharedcontent_sharedcontent_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sharedcontent_sharedcontent_translation_id_seq', 1, false);


--
-- TOC entry 3979 (class 0 OID 33650)
-- Dependencies: 332
-- Data for Name: test_article; Type: TABLE DATA; Schema: public; Owner: -
--

COPY test_article (id, publishing_is_draft, publishing_modified_at, publishing_published_at, title, slug, layout_id, publishing_linked_id, parent_id, boosted_search_terms, list_image) FROM stdin;
\.


--
-- TOC entry 4230 (class 0 OID 0)
-- Dependencies: 333
-- Name: test_article_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('test_article_id_seq', 1, false);


--
-- TOC entry 4048 (class 0 OID 36369)
-- Dependencies: 401
-- Data for Name: test_articlelisting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY test_articlelisting (urlnode_ptr_id, publishing_is_draft, publishing_modified_at, publishing_published_at, layout_id, publishing_linked_id, boosted_search_terms, hero_image_id, list_image) FROM stdin;
\.


--
-- TOC entry 3981 (class 0 OID 33658)
-- Dependencies: 334
-- Data for Name: test_layoutpage_with_related; Type: TABLE DATA; Schema: public; Owner: -
--

COPY test_layoutpage_with_related (urlnode_ptr_id, publishing_is_draft, publishing_modified_at, publishing_published_at, layout_id, publishing_linked_id, boosted_search_terms, hero_image_id, list_image) FROM stdin;
\.


--
-- TOC entry 3982 (class 0 OID 33661)
-- Dependencies: 335
-- Data for Name: test_layoutpage_with_related_related_pages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY test_layoutpage_with_related_related_pages (id, layoutpagewithrelatedpages_id, page_id) FROM stdin;
\.


--
-- TOC entry 4231 (class 0 OID 0)
-- Dependencies: 336
-- Name: test_layoutpage_with_related_related_pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('test_layoutpage_with_related_related_pages_id_seq', 1, false);


--
-- TOC entry 3984 (class 0 OID 33666)
-- Dependencies: 337
-- Data for Name: tests_barwithlayout; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_barwithlayout (id, layout_id) FROM stdin;
\.


--
-- TOC entry 4232 (class 0 OID 0)
-- Dependencies: 338
-- Name: tests_barwithlayout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_barwithlayout_id_seq', 1, false);


--
-- TOC entry 3986 (class 0 OID 33671)
-- Dependencies: 339
-- Data for Name: tests_basemodel; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_basemodel (id, created, modified) FROM stdin;
\.


--
-- TOC entry 4233 (class 0 OID 0)
-- Dependencies: 340
-- Name: tests_basemodel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_basemodel_id_seq', 1, false);


--
-- TOC entry 3988 (class 0 OID 33676)
-- Dependencies: 341
-- Data for Name: tests_bazwithlayout; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_bazwithlayout (id, layout_id) FROM stdin;
\.


--
-- TOC entry 4234 (class 0 OID 0)
-- Dependencies: 342
-- Name: tests_bazwithlayout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_bazwithlayout_id_seq', 1, false);


--
-- TOC entry 3990 (class 0 OID 33681)
-- Dependencies: 343
-- Data for Name: tests_foowithlayout; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_foowithlayout (id, layout_id) FROM stdin;
\.


--
-- TOC entry 4235 (class 0 OID 0)
-- Dependencies: 344
-- Name: tests_foowithlayout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_foowithlayout_id_seq', 1, false);


--
-- TOC entry 3992 (class 0 OID 33686)
-- Dependencies: 345
-- Data for Name: tests_imagetest; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_imagetest (id, image) FROM stdin;
\.


--
-- TOC entry 4236 (class 0 OID 0)
-- Dependencies: 346
-- Name: tests_imagetest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_imagetest_id_seq', 1, false);


--
-- TOC entry 4050 (class 0 OID 36414)
-- Dependencies: 403
-- Data for Name: tests_publishingm2mmodela; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_publishingm2mmodela (id, publishing_is_draft, publishing_modified_at, publishing_published_at, publishing_linked_id) FROM stdin;
\.


--
-- TOC entry 4237 (class 0 OID 0)
-- Dependencies: 402
-- Name: tests_publishingm2mmodela_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_publishingm2mmodela_id_seq', 1, false);


--
-- TOC entry 4052 (class 0 OID 36424)
-- Dependencies: 405
-- Data for Name: tests_publishingm2mmodelb; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_publishingm2mmodelb (id, publishing_is_draft, publishing_modified_at, publishing_published_at, publishing_linked_id) FROM stdin;
\.


--
-- TOC entry 4238 (class 0 OID 0)
-- Dependencies: 404
-- Name: tests_publishingm2mmodelb_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_publishingm2mmodelb_id_seq', 1, false);


--
-- TOC entry 4054 (class 0 OID 36434)
-- Dependencies: 407
-- Data for Name: tests_publishingm2mmodelb_related_a_models; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_publishingm2mmodelb_related_a_models (id, publishingm2mmodelb_id, publishingm2mmodela_id) FROM stdin;
\.


--
-- TOC entry 4239 (class 0 OID 0)
-- Dependencies: 406
-- Name: tests_publishingm2mmodelb_related_a_models_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_publishingm2mmodelb_related_a_models_id_seq', 1, false);


--
-- TOC entry 4056 (class 0 OID 36444)
-- Dependencies: 409
-- Data for Name: tests_publishingm2mthroughtable; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tests_publishingm2mthroughtable (id, a_model_id, b_model_id) FROM stdin;
\.


--
-- TOC entry 4240 (class 0 OID 0)
-- Dependencies: 408
-- Name: tests_publishingm2mthroughtable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tests_publishingm2mthroughtable_id_seq', 1, false);


--
-- TOC entry 4241 (class 0 OID 0)
-- Dependencies: 389
-- Name: workflow_workflowstate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('workflow_workflowstate_id_seq', 1, false);


--
-- TOC entry 2828 (class 2606 OID 33759)
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- TOC entry 2834 (class 2606 OID 33761)
-- Name: auth_group_permissions_group_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_key UNIQUE (group_id, permission_id);


--
-- TOC entry 2836 (class 2606 OID 33763)
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 2830 (class 2606 OID 33765)
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- TOC entry 2839 (class 2606 OID 33767)
-- Name: auth_permission_content_type_id_codename_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_key UNIQUE (content_type_id, codename);


--
-- TOC entry 2841 (class 2606 OID 33769)
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 3302 (class 2606 OID 34825)
-- Name: authtoken_token_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY authtoken_token
    ADD CONSTRAINT authtoken_token_pkey PRIMARY KEY (key);


--
-- TOC entry 3304 (class 2606 OID 34827)
-- Name: authtoken_token_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_key UNIQUE (user_id);


--
-- TOC entry 2844 (class 2606 OID 33771)
-- Name: celery_taskmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_taskmeta
    ADD CONSTRAINT celery_taskmeta_pkey PRIMARY KEY (id);


--
-- TOC entry 2847 (class 2606 OID 33773)
-- Name: celery_taskmeta_task_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_taskmeta
    ADD CONSTRAINT celery_taskmeta_task_id_key UNIQUE (task_id);


--
-- TOC entry 2850 (class 2606 OID 33775)
-- Name: celery_tasksetmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_tasksetmeta
    ADD CONSTRAINT celery_tasksetmeta_pkey PRIMARY KEY (id);


--
-- TOC entry 2853 (class 2606 OID 33777)
-- Name: celery_tasksetmeta_taskset_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY celery_tasksetmeta
    ADD CONSTRAINT celery_tasksetmeta_taskset_id_key UNIQUE (taskset_id);


--
-- TOC entry 2855 (class 2606 OID 33779)
-- Name: contentitem_child_pages_childpageitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_child_pages_childpageitem
    ADD CONSTRAINT contentitem_child_pages_childpageitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2857 (class 2606 OID 33781)
-- Name: contentitem_faq_faqitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_faq_faqitem
    ADD CONSTRAINT contentitem_faq_faqitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2860 (class 2606 OID 33783)
-- Name: contentitem_file_fileitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_file_fileitem
    ADD CONSTRAINT contentitem_file_fileitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 3323 (class 2606 OID 34981)
-- Name: contentitem_glamkit_sponsors_beginsponsorblockitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_beginsponsorblockitem
    ADD CONSTRAINT contentitem_glamkit_sponsors_beginsponsorblockitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 3325 (class 2606 OID 34989)
-- Name: contentitem_glamkit_sponsors_endsponsorblockitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_endsponsorblockitem
    ADD CONSTRAINT contentitem_glamkit_sponsors_endsponsorblockitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 3328 (class 2606 OID 34994)
-- Name: contentitem_glamkit_sponsors_sponsorpromoitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_sponsorpromoitem
    ADD CONSTRAINT contentitem_glamkit_sponsors_sponsorpromoitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2862 (class 2606 OID 33785)
-- Name: contentitem_horizontal_rule_horizontalruleitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_horizontal_rule_horizontalruleitem
    ADD CONSTRAINT contentitem_horizontal_rule_horizontalruleitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 3423 (class 2606 OID 35745)
-- Name: contentitem_icekit_events_links_eventlink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_events_links_eventlink
    ADD CONSTRAINT contentitem_icekit_events_links_eventlink_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 3427 (class 2606 OID 35772)
-- Name: contentitem_icekit_plugins_contact_person_contactpersonite_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_contact_person_contactpersonitem
    ADD CONSTRAINT contentitem_icekit_plugins_contact_person_contactpersonite_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 3430 (class 2606 OID 35788)
-- Name: contentitem_icekit_plugins_content_listing_contentlistingi_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_content_listing_contentlistingitem
    ADD CONSTRAINT contentitem_icekit_plugins_content_listing_contentlistingi_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2889 (class 2606 OID 33787)
-- Name: contentitem_iframe_iframeitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_iframe_iframeitem
    ADD CONSTRAINT contentitem_iframe_iframeitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 3459 (class 2606 OID 36067)
-- Name: contentitem_ik_event_listing_eventcontentlistingitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_event_listing_eventcontentlistingitem
    ADD CONSTRAINT contentitem_ik_event_listing_eventcontentlistingitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 3467 (class 2606 OID 36105)
-- Name: contentitem_ik_events_todays_occurrences_todaysoccurrences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_events_todays_occurrences_todaysoccurrences
    ADD CONSTRAINT contentitem_ik_events_todays_occurrences_todaysoccurrences_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 3476 (class 2606 OID 36150)
-- Name: contentitem_ik_links_articlelink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_articlelink
    ADD CONSTRAINT contentitem_ik_links_articlelink_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 3479 (class 2606 OID 36158)
-- Name: contentitem_ik_links_authorlink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_authorlink
    ADD CONSTRAINT contentitem_ik_links_authorlink_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 3482 (class 2606 OID 36166)
-- Name: contentitem_ik_links_pagelink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_pagelink
    ADD CONSTRAINT contentitem_ik_links_pagelink_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 3485 (class 2606 OID 36258)
-- Name: contentitem_image_gallery_imagegalleryshowitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_image_gallery_imagegalleryshowitem
    ADD CONSTRAINT contentitem_image_gallery_imagegalleryshowitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2865 (class 2606 OID 33789)
-- Name: contentitem_image_imageitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_image_imageitem
    ADD CONSTRAINT contentitem_image_imageitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2867 (class 2606 OID 33791)
-- Name: contentitem_instagram_embed_instagramembeditem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_instagram_embed_instagramembeditem
    ADD CONSTRAINT contentitem_instagram_embed_instagramembeditem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2869 (class 2606 OID 33793)
-- Name: contentitem_map_mapitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_map_mapitem
    ADD CONSTRAINT contentitem_map_mapitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2871 (class 2606 OID 33795)
-- Name: contentitem_map_with_text_mapwithtextitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_map_with_text_mapwithtextitem
    ADD CONSTRAINT contentitem_map_with_text_mapwithtextitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2873 (class 2606 OID 33797)
-- Name: contentitem_oembed_with_caption_oembedwithcaptionitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_oembed_with_caption_item
    ADD CONSTRAINT contentitem_oembed_with_caption_oembedwithcaptionitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2891 (class 2606 OID 33799)
-- Name: contentitem_oembeditem_oembeditem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_oembeditem_oembeditem
    ADD CONSTRAINT contentitem_oembeditem_oembeditem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2875 (class 2606 OID 33801)
-- Name: contentitem_page_anchor_list_pageanchorlistitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem
    ADD CONSTRAINT contentitem_page_anchor_list_pageanchorlistitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2877 (class 2606 OID 33803)
-- Name: contentitem_page_anchor_pageanchoritem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_page_anchor_pageanchoritem
    ADD CONSTRAINT contentitem_page_anchor_pageanchoritem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2893 (class 2606 OID 33805)
-- Name: contentitem_picture_pictureitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_picture_pictureitem
    ADD CONSTRAINT contentitem_picture_pictureitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2879 (class 2606 OID 33807)
-- Name: contentitem_quote_quoteitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_quote_quoteitem
    ADD CONSTRAINT contentitem_quote_quoteitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2895 (class 2606 OID 33809)
-- Name: contentitem_rawhtml_rawhtmlitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_rawhtml_rawhtmlitem
    ADD CONSTRAINT contentitem_rawhtml_rawhtmlitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2882 (class 2606 OID 33811)
-- Name: contentitem_reusable_form_formitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_reusable_form_formitem
    ADD CONSTRAINT contentitem_reusable_form_formitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2898 (class 2606 OID 33813)
-- Name: contentitem_sharedcontent_sharedcontentitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_sharedcontent_sharedcontentitem
    ADD CONSTRAINT contentitem_sharedcontent_sharedcontentitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2885 (class 2606 OID 33815)
-- Name: contentitem_slideshow_slideshowitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_slideshow_slideshowitem
    ADD CONSTRAINT contentitem_slideshow_slideshowitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2900 (class 2606 OID 33817)
-- Name: contentitem_text_textitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_text_textitem
    ADD CONSTRAINT contentitem_text_textitem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2887 (class 2606 OID 33819)
-- Name: contentitem_twitter_embed_twitterembeditem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_twitter_embed_twitterembeditem
    ADD CONSTRAINT contentitem_twitter_embed_twitterembeditem_pkey PRIMARY KEY (contentitem_ptr_id);


--
-- TOC entry 2904 (class 2606 OID 33821)
-- Name: django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- TOC entry 2906 (class 2606 OID 33823)
-- Name: django_content_type_app_label_38aec202fd7962aa_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_38aec202fd7962aa_uniq UNIQUE (app_label, model);


--
-- TOC entry 2908 (class 2606 OID 33825)
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- TOC entry 2910 (class 2606 OID 33827)
-- Name: django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 2915 (class 2606 OID 33829)
-- Name: django_redirect_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_redirect
    ADD CONSTRAINT django_redirect_pkey PRIMARY KEY (id);


--
-- TOC entry 2917 (class 2606 OID 33831)
-- Name: django_redirect_site_id_old_path_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_redirect
    ADD CONSTRAINT django_redirect_site_id_old_path_key UNIQUE (site_id, old_path);


--
-- TOC entry 2920 (class 2606 OID 33833)
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- TOC entry 2923 (class 2606 OID 33835)
-- Name: django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- TOC entry 2925 (class 2606 OID 33837)
-- Name: djcelery_crontabschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_crontabschedule
    ADD CONSTRAINT djcelery_crontabschedule_pkey PRIMARY KEY (id);


--
-- TOC entry 2927 (class 2606 OID 33839)
-- Name: djcelery_intervalschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_intervalschedule
    ADD CONSTRAINT djcelery_intervalschedule_pkey PRIMARY KEY (id);


--
-- TOC entry 2932 (class 2606 OID 33841)
-- Name: djcelery_periodictask_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT djcelery_periodictask_name_key UNIQUE (name);


--
-- TOC entry 2934 (class 2606 OID 33843)
-- Name: djcelery_periodictask_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT djcelery_periodictask_pkey PRIMARY KEY (id);


--
-- TOC entry 2936 (class 2606 OID 33845)
-- Name: djcelery_periodictasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictasks
    ADD CONSTRAINT djcelery_periodictasks_pkey PRIMARY KEY (ident);


--
-- TOC entry 2944 (class 2606 OID 33847)
-- Name: djcelery_taskstate_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_taskstate
    ADD CONSTRAINT djcelery_taskstate_pkey PRIMARY KEY (id);


--
-- TOC entry 2948 (class 2606 OID 33849)
-- Name: djcelery_taskstate_task_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_taskstate
    ADD CONSTRAINT djcelery_taskstate_task_id_key UNIQUE (task_id);


--
-- TOC entry 2952 (class 2606 OID 33851)
-- Name: djcelery_workerstate_hostname_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_workerstate
    ADD CONSTRAINT djcelery_workerstate_hostname_key UNIQUE (hostname);


--
-- TOC entry 2954 (class 2606 OID 33853)
-- Name: djcelery_workerstate_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_workerstate
    ADD CONSTRAINT djcelery_workerstate_pkey PRIMARY KEY (id);


--
-- TOC entry 2959 (class 2606 OID 33855)
-- Name: djkombu_message_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_message
    ADD CONSTRAINT djkombu_message_pkey PRIMARY KEY (id);


--
-- TOC entry 2962 (class 2606 OID 33857)
-- Name: djkombu_queue_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_queue
    ADD CONSTRAINT djkombu_queue_name_key UNIQUE (name);


--
-- TOC entry 2964 (class 2606 OID 33859)
-- Name: djkombu_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_queue
    ADD CONSTRAINT djkombu_queue_pkey PRIMARY KEY (id);


--
-- TOC entry 2969 (class 2606 OID 33861)
-- Name: easy_thumbnails_source_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_source
    ADD CONSTRAINT easy_thumbnails_source_pkey PRIMARY KEY (id);


--
-- TOC entry 2972 (class 2606 OID 33863)
-- Name: easy_thumbnails_source_storage_hash_5fa2ea0350b6f6d5_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_source
    ADD CONSTRAINT easy_thumbnails_source_storage_hash_5fa2ea0350b6f6d5_uniq UNIQUE (storage_hash, name);


--
-- TOC entry 2978 (class 2606 OID 33865)
-- Name: easy_thumbnails_thumbnail_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnail
    ADD CONSTRAINT easy_thumbnails_thumbnail_pkey PRIMARY KEY (id);


--
-- TOC entry 2980 (class 2606 OID 33867)
-- Name: easy_thumbnails_thumbnail_storage_hash_43ea9cf8ca6bd404_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnail
    ADD CONSTRAINT easy_thumbnails_thumbnail_storage_hash_43ea9cf8ca6bd404_uniq UNIQUE (storage_hash, name, source_id);


--
-- TOC entry 2983 (class 2606 OID 33869)
-- Name: easy_thumbnails_thumbnaildimensions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnaildimensions
    ADD CONSTRAINT easy_thumbnails_thumbnaildimensions_pkey PRIMARY KEY (id);


--
-- TOC entry 2985 (class 2606 OID 33871)
-- Name: easy_thumbnails_thumbnaildimensions_thumbnail_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnaildimensions
    ADD CONSTRAINT easy_thumbnails_thumbnaildimensions_thumbnail_id_key UNIQUE (thumbnail_id);


--
-- TOC entry 2989 (class 2606 OID 33873)
-- Name: file_file_categories_file_id_mediacategory_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories
    ADD CONSTRAINT file_file_categories_file_id_mediacategory_id_key UNIQUE (file_id, mediacategory_id);


--
-- TOC entry 2991 (class 2606 OID 33875)
-- Name: file_file_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories
    ADD CONSTRAINT file_file_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 2993 (class 2606 OID 33877)
-- Name: file_file_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file
    ADD CONSTRAINT file_file_pkey PRIMARY KEY (id);


--
-- TOC entry 3001 (class 2606 OID 33879)
-- Name: fluent_contents_contentitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem
    ADD CONSTRAINT fluent_contents_contentitem_pkey PRIMARY KEY (id);


--
-- TOC entry 3003 (class 2606 OID 33881)
-- Name: fluent_contents_placeholde_parent_type_id_1efb15ac2f068b1b_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_placeholder
    ADD CONSTRAINT fluent_contents_placeholde_parent_type_id_1efb15ac2f068b1b_uniq UNIQUE (parent_type_id, parent_id, slot);


--
-- TOC entry 3007 (class 2606 OID 33883)
-- Name: fluent_contents_placeholder_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_placeholder
    ADD CONSTRAINT fluent_contents_placeholder_pkey PRIMARY KEY (id);


--
-- TOC entry 3011 (class 2606 OID 33885)
-- Name: fluent_pages_htmlpage_trans_language_code_4ccf45c830a09bd5_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_htmlpage_translation
    ADD CONSTRAINT fluent_pages_htmlpage_trans_language_code_4ccf45c830a09bd5_uniq UNIQUE (language_code, master_id);


--
-- TOC entry 3015 (class 2606 OID 33887)
-- Name: fluent_pages_htmlpage_translation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_htmlpage_translation
    ADD CONSTRAINT fluent_pages_htmlpage_translation_pkey PRIMARY KEY (id);


--
-- TOC entry 3019 (class 2606 OID 33889)
-- Name: fluent_pages_pagelayout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_pagelayout
    ADD CONSTRAINT fluent_pages_pagelayout_pkey PRIMARY KEY (id);


--
-- TOC entry 3036 (class 2606 OID 33891)
-- Name: fluent_pages_urlnode_parent_site_id_70134ee070648a25_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_pages_urlnode_parent_site_id_70134ee070648a25_uniq UNIQUE (parent_site_id, key);


--
-- TOC entry 3038 (class 2606 OID 33893)
-- Name: fluent_pages_urlnode_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_pages_urlnode_pkey PRIMARY KEY (id);


--
-- TOC entry 3041 (class 2606 OID 33895)
-- Name: fluent_pages_urlnode_transl_language_code_6d676836ef15c6d5_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode_translation
    ADD CONSTRAINT fluent_pages_urlnode_transl_language_code_6d676836ef15c6d5_uniq UNIQUE (language_code, master_id);


--
-- TOC entry 3049 (class 2606 OID 33897)
-- Name: fluent_pages_urlnode_translation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode_translation
    ADD CONSTRAINT fluent_pages_urlnode_translation_pkey PRIMARY KEY (id);


--
-- TOC entry 3054 (class 2606 OID 33899)
-- Name: forms_field_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_field
    ADD CONSTRAINT forms_field_pkey PRIMARY KEY (id);


--
-- TOC entry 3058 (class 2606 OID 33901)
-- Name: forms_fieldentry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_fieldentry
    ADD CONSTRAINT forms_fieldentry_pkey PRIMARY KEY (id);


--
-- TOC entry 3060 (class 2606 OID 33903)
-- Name: forms_form_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form
    ADD CONSTRAINT forms_form_pkey PRIMARY KEY (id);


--
-- TOC entry 3067 (class 2606 OID 33905)
-- Name: forms_form_sites_form_id_site_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites
    ADD CONSTRAINT forms_form_sites_form_id_site_id_key UNIQUE (form_id, site_id);


--
-- TOC entry 3069 (class 2606 OID 33907)
-- Name: forms_form_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites
    ADD CONSTRAINT forms_form_sites_pkey PRIMARY KEY (id);


--
-- TOC entry 3063 (class 2606 OID 33909)
-- Name: forms_form_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form
    ADD CONSTRAINT forms_form_slug_key UNIQUE (slug);


--
-- TOC entry 3072 (class 2606 OID 33911)
-- Name: forms_formentry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_formentry
    ADD CONSTRAINT forms_formentry_pkey PRIMARY KEY (id);


--
-- TOC entry 3314 (class 2606 OID 34937)
-- Name: glamkit_collections_country_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_collections_country
    ADD CONSTRAINT glamkit_collections_country_pkey PRIMARY KEY (id);


--
-- TOC entry 3318 (class 2606 OID 34948)
-- Name: glamkit_collections_geographiclocation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_collections_geographiclocation
    ADD CONSTRAINT glamkit_collections_geographiclocation_pkey PRIMARY KEY (id);


--
-- TOC entry 3321 (class 2606 OID 34967)
-- Name: glamkit_sponsors_sponsor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_sponsors_sponsor
    ADD CONSTRAINT glamkit_sponsors_sponsor_pkey PRIMARY KEY (id);


--
-- TOC entry 3335 (class 2606 OID 35026)
-- Name: icekit_article_article_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT icekit_article_article_pkey PRIMARY KEY (id);


--
-- TOC entry 3337 (class 2606 OID 35035)
-- Name: icekit_article_article_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT icekit_article_article_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- TOC entry 3339 (class 2606 OID 35037)
-- Name: icekit_article_article_slug_567971c7bd1ac003_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT icekit_article_article_slug_567971c7bd1ac003_uniq UNIQUE (slug, parent_id, publishing_linked_id);


--
-- TOC entry 3356 (class 2606 OID 35268)
-- Name: icekit_authors_author_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author
    ADD CONSTRAINT icekit_authors_author_pkey PRIMARY KEY (id);


--
-- TOC entry 3358 (class 2606 OID 35270)
-- Name: icekit_authors_author_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author
    ADD CONSTRAINT icekit_authors_author_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- TOC entry 3410 (class 2606 OID 35505)
-- Name: icekit_event_types_simple_simpleevent_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_event_types_simple_simpleevent
    ADD CONSTRAINT icekit_event_types_simple_simpleevent_pkey PRIMARY KEY (eventbase_ptr_id);


--
-- TOC entry 3376 (class 2606 OID 35409)
-- Name: icekit_events_eventbase_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT icekit_events_eventbase_pkey PRIMARY KEY (id);


--
-- TOC entry 3378 (class 2606 OID 35411)
-- Name: icekit_events_eventbase_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT icekit_events_eventbase_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- TOC entry 3416 (class 2606 OID 35580)
-- Name: icekit_events_eventbase_secondary_eventbase_id_eventtype_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types
    ADD CONSTRAINT icekit_events_eventbase_secondary_eventbase_id_eventtype_id_key UNIQUE (eventbase_id, eventtype_id);


--
-- TOC entry 3420 (class 2606 OID 35578)
-- Name: icekit_events_eventbase_secondary_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types
    ADD CONSTRAINT icekit_events_eventbase_secondary_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3387 (class 2606 OID 35422)
-- Name: icekit_events_eventrepeatsgenerator_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventrepeatsgenerator
    ADD CONSTRAINT icekit_events_eventrepeatsgenerator_pkey PRIMARY KEY (id);


--
-- TOC entry 3413 (class 2606 OID 35570)
-- Name: icekit_events_eventtype_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventtype
    ADD CONSTRAINT icekit_events_eventtype_pkey PRIMARY KEY (id);


--
-- TOC entry 3397 (class 2606 OID 35430)
-- Name: icekit_events_occurrence_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_occurrence
    ADD CONSTRAINT icekit_events_occurrence_pkey PRIMARY KEY (id);


--
-- TOC entry 3402 (class 2606 OID 35443)
-- Name: icekit_events_recurrencerule_description_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_recurrencerule
    ADD CONSTRAINT icekit_events_recurrencerule_description_key UNIQUE (description);


--
-- TOC entry 3405 (class 2606 OID 35441)
-- Name: icekit_events_recurrencerule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_recurrencerule
    ADD CONSTRAINT icekit_events_recurrencerule_pkey PRIMARY KEY (id);


--
-- TOC entry 3407 (class 2606 OID 35445)
-- Name: icekit_events_recurrencerule_recurrence_rule_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_recurrencerule
    ADD CONSTRAINT icekit_events_recurrencerule_recurrence_rule_key UNIQUE (recurrence_rule);


--
-- TOC entry 3083 (class 2606 OID 33913)
-- Name: icekit_layout_content_types_layout_id_contenttype_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types
    ADD CONSTRAINT icekit_layout_content_types_layout_id_contenttype_id_key UNIQUE (layout_id, contenttype_id);


--
-- TOC entry 3085 (class 2606 OID 33915)
-- Name: icekit_layout_content_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types
    ADD CONSTRAINT icekit_layout_content_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3076 (class 2606 OID 33917)
-- Name: icekit_layout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout
    ADD CONSTRAINT icekit_layout_pkey PRIMARY KEY (id);


--
-- TOC entry 3079 (class 2606 OID 33919)
-- Name: icekit_layout_template_name_1b178bcb3332c00d_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout
    ADD CONSTRAINT icekit_layout_template_name_1b178bcb3332c00d_uniq UNIQUE (template_name);


--
-- TOC entry 3090 (class 2606 OID 33921)
-- Name: icekit_mediacategory_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_mediacategory
    ADD CONSTRAINT icekit_mediacategory_name_key UNIQUE (name);


--
-- TOC entry 3092 (class 2606 OID 33923)
-- Name: icekit_mediacategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_mediacategory
    ADD CONSTRAINT icekit_mediacategory_pkey PRIMARY KEY (id);


--
-- TOC entry 3425 (class 2606 OID 35767)
-- Name: icekit_plugins_contact_person_contactperson_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_contact_person_contactperson
    ADD CONSTRAINT icekit_plugins_contact_person_contactperson_pkey PRIMARY KEY (id);


--
-- TOC entry 3351 (class 2606 OID 35228)
-- Name: icekit_plugins_image_imagerepurposeconfig_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_imagerepurposeconfig
    ADD CONSTRAINT icekit_plugins_image_imagerepurposeconfig_pkey PRIMARY KEY (id);


--
-- TOC entry 3103 (class 2606 OID 33925)
-- Name: icekit_plugins_slideshow_slideshow_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_slideshow_slideshow
    ADD CONSTRAINT icekit_plugins_slideshow_slideshow_pkey PRIMARY KEY (id);


--
-- TOC entry 3105 (class 2606 OID 33927)
-- Name: icekit_plugins_slideshow_slideshow_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_slideshow_slideshow
    ADD CONSTRAINT icekit_plugins_slideshow_slideshow_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- TOC entry 3440 (class 2606 OID 35858)
-- Name: icekit_press_releases_pressrelease_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease
    ADD CONSTRAINT icekit_press_releases_pressrelease_pkey PRIMARY KEY (id);


--
-- TOC entry 3442 (class 2606 OID 35875)
-- Name: icekit_press_releases_pressrelease_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease
    ADD CONSTRAINT icekit_press_releases_pressrelease_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- TOC entry 3445 (class 2606 OID 35866)
-- Name: icekit_press_releases_pressreleasecategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressreleasecategory
    ADD CONSTRAINT icekit_press_releases_pressreleasecategory_pkey PRIMARY KEY (id);


--
-- TOC entry 3462 (class 2606 OID 36088)
-- Name: ik_event_listing_types_eventcontentlistingitem_id_eventtype_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types
    ADD CONSTRAINT ik_event_listing_types_eventcontentlistingitem_id_eventtype_key UNIQUE (eventcontentlistingitem_id, eventtype_id);


--
-- TOC entry 3465 (class 2606 OID 36086)
-- Name: ik_event_listing_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types
    ADD CONSTRAINT ik_event_listing_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3471 (class 2606 OID 36113)
-- Name: ik_todays_occurrences_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types
    ADD CONSTRAINT ik_todays_occurrences_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3473 (class 2606 OID 36115)
-- Name: ik_todays_occurrences_types_todaysoccurrences_id_eventtype__key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types
    ADD CONSTRAINT ik_todays_occurrences_types_todaysoccurrences_id_eventtype__key UNIQUE (todaysoccurrences_id, eventtype_id);


--
-- TOC entry 3098 (class 2606 OID 33929)
-- Name: image_image_categories_image_id_mediacategory_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories
    ADD CONSTRAINT image_image_categories_image_id_mediacategory_id_key UNIQUE (image_id, mediacategory_id);


--
-- TOC entry 3100 (class 2606 OID 33931)
-- Name: image_image_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories
    ADD CONSTRAINT image_image_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 3094 (class 2606 OID 33933)
-- Name: image_image_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image
    ADD CONSTRAINT image_image_pkey PRIMARY KEY (id);


--
-- TOC entry 3107 (class 2606 OID 33935)
-- Name: model_settings_boolean_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_boolean
    ADD CONSTRAINT model_settings_boolean_pkey PRIMARY KEY (setting_ptr_id);


--
-- TOC entry 3109 (class 2606 OID 33937)
-- Name: model_settings_date_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_date
    ADD CONSTRAINT model_settings_date_pkey PRIMARY KEY (setting_ptr_id);


--
-- TOC entry 3111 (class 2606 OID 33939)
-- Name: model_settings_datetime_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_datetime
    ADD CONSTRAINT model_settings_datetime_pkey PRIMARY KEY (setting_ptr_id);


--
-- TOC entry 3113 (class 2606 OID 33941)
-- Name: model_settings_decimal_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_decimal
    ADD CONSTRAINT model_settings_decimal_pkey PRIMARY KEY (setting_ptr_id);


--
-- TOC entry 3115 (class 2606 OID 33943)
-- Name: model_settings_file_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_file
    ADD CONSTRAINT model_settings_file_pkey PRIMARY KEY (setting_ptr_id);


--
-- TOC entry 3117 (class 2606 OID 33945)
-- Name: model_settings_float_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_float
    ADD CONSTRAINT model_settings_float_pkey PRIMARY KEY (setting_ptr_id);


--
-- TOC entry 3119 (class 2606 OID 33947)
-- Name: model_settings_image_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_image
    ADD CONSTRAINT model_settings_image_pkey PRIMARY KEY (setting_ptr_id);


--
-- TOC entry 3121 (class 2606 OID 33949)
-- Name: model_settings_integer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_integer
    ADD CONSTRAINT model_settings_integer_pkey PRIMARY KEY (setting_ptr_id);


--
-- TOC entry 3125 (class 2606 OID 33951)
-- Name: model_settings_setting_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_setting
    ADD CONSTRAINT model_settings_setting_name_key UNIQUE (name);


--
-- TOC entry 3127 (class 2606 OID 33953)
-- Name: model_settings_setting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_setting
    ADD CONSTRAINT model_settings_setting_pkey PRIMARY KEY (id);


--
-- TOC entry 3129 (class 2606 OID 33955)
-- Name: model_settings_text_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_text
    ADD CONSTRAINT model_settings_text_pkey PRIMARY KEY (setting_ptr_id);


--
-- TOC entry 3131 (class 2606 OID 33957)
-- Name: model_settings_time_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_time
    ADD CONSTRAINT model_settings_time_pkey PRIMARY KEY (setting_ptr_id);


--
-- TOC entry 3133 (class 2606 OID 33959)
-- Name: notifications_followerinf_content_type_id_31a4111c525e059b_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation
    ADD CONSTRAINT notifications_followerinf_content_type_id_31a4111c525e059b_uniq UNIQUE (content_type_id, object_id);


--
-- TOC entry 3145 (class 2606 OID 33961)
-- Name: notifications_followerinforma_followerinformation_id_group__key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers
    ADD CONSTRAINT notifications_followerinforma_followerinformation_id_group__key UNIQUE (followerinformation_id, group_id);


--
-- TOC entry 3139 (class 2606 OID 33963)
-- Name: notifications_followerinforma_followerinformation_id_user_i_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers
    ADD CONSTRAINT notifications_followerinforma_followerinformation_id_user_i_key UNIQUE (followerinformation_id, user_id);


--
-- TOC entry 3143 (class 2606 OID 33965)
-- Name: notifications_followerinformation_followers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers
    ADD CONSTRAINT notifications_followerinformation_followers_pkey PRIMARY KEY (id);


--
-- TOC entry 3149 (class 2606 OID 33967)
-- Name: notifications_followerinformation_group_followers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers
    ADD CONSTRAINT notifications_followerinformation_group_followers_pkey PRIMARY KEY (id);


--
-- TOC entry 3137 (class 2606 OID 33969)
-- Name: notifications_followerinformation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation
    ADD CONSTRAINT notifications_followerinformation_pkey PRIMARY KEY (id);


--
-- TOC entry 3153 (class 2606 OID 33971)
-- Name: notifications_hasreadmessage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_hasreadmessage
    ADD CONSTRAINT notifications_hasreadmessage_pkey PRIMARY KEY (id);


--
-- TOC entry 3158 (class 2606 OID 33973)
-- Name: notifications_notification_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notification
    ADD CONSTRAINT notifications_notification_pkey PRIMARY KEY (id);


--
-- TOC entry 3160 (class 2606 OID 33975)
-- Name: notifications_notificationsetting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notificationsetting
    ADD CONSTRAINT notifications_notificationsetting_pkey PRIMARY KEY (id);


--
-- TOC entry 3162 (class 2606 OID 33977)
-- Name: notifications_notificationsetting_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notificationsetting
    ADD CONSTRAINT notifications_notificationsetting_user_id_key UNIQUE (user_id);


--
-- TOC entry 3306 (class 2606 OID 34873)
-- Name: pagetype_eventlistingfordate_eventlist_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT pagetype_eventlistingfordate_eventlist_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- TOC entry 3311 (class 2606 OID 34871)
-- Name: pagetype_eventlistingfordate_eventlistingpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT pagetype_eventlistingfordate_eventlistingpage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- TOC entry 3165 (class 2606 OID 33979)
-- Name: pagetype_fluentpage_fluentpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_fluentpage_fluentpage
    ADD CONSTRAINT pagetype_fluentpage_fluentpage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- TOC entry 3342 (class 2606 OID 35033)
-- Name: pagetype_icekit_article_articlecategor_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT pagetype_icekit_article_articlecategor_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- TOC entry 3347 (class 2606 OID 35031)
-- Name: pagetype_icekit_article_articlecategorypage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT pagetype_icekit_article_articlecategorypage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- TOC entry 3364 (class 2606 OID 35275)
-- Name: pagetype_icekit_authors_authorlisting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT pagetype_icekit_authors_authorlisting_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- TOC entry 3366 (class 2606 OID 35277)
-- Name: pagetype_icekit_authors_authorlisting_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT pagetype_icekit_authors_authorlisting_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- TOC entry 3447 (class 2606 OID 35936)
-- Name: pagetype_icekit_press_releases_pressre_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT pagetype_icekit_press_releases_pressre_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- TOC entry 3452 (class 2606 OID 35934)
-- Name: pagetype_icekit_press_releases_pressreleaselisting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT pagetype_icekit_press_releases_pressreleaselisting_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- TOC entry 3170 (class 2606 OID 33981)
-- Name: pagetype_layout_page_layoutpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT pagetype_layout_page_layoutpage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- TOC entry 3172 (class 2606 OID 33983)
-- Name: pagetype_layout_page_layoutpage_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT pagetype_layout_page_layoutpage_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- TOC entry 3174 (class 2606 OID 33985)
-- Name: pagetype_redirectnode_redirectnode_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_redirectnode_redirectnode
    ADD CONSTRAINT pagetype_redirectnode_redirectnode_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- TOC entry 3177 (class 2606 OID 33987)
-- Name: pagetype_search_page_searchpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_searchpage
    ADD CONSTRAINT pagetype_search_page_searchpage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- TOC entry 3179 (class 2606 OID 33989)
-- Name: pagetype_search_page_searchpage_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_searchpage
    ADD CONSTRAINT pagetype_search_page_searchpage_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- TOC entry 3182 (class 2606 OID 33991)
-- Name: pagetype_tests_unpublishablelayoutpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_tests_unpublishablelayoutpage
    ADD CONSTRAINT pagetype_tests_unpublishablelayoutpage_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- TOC entry 3185 (class 2606 OID 33993)
-- Name: polymorphic_auth_email_emailuser_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_email_emailuser
    ADD CONSTRAINT polymorphic_auth_email_emailuser_email_key UNIQUE (email);


--
-- TOC entry 3187 (class 2606 OID 33995)
-- Name: polymorphic_auth_email_emailuser_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_email_emailuser
    ADD CONSTRAINT polymorphic_auth_email_emailuser_pkey PRIMARY KEY (user_ptr_id);


--
-- TOC entry 3194 (class 2606 OID 33997)
-- Name: polymorphic_auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups
    ADD CONSTRAINT polymorphic_auth_user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 3196 (class 2606 OID 33999)
-- Name: polymorphic_auth_user_groups_user_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups
    ADD CONSTRAINT polymorphic_auth_user_groups_user_id_group_id_key UNIQUE (user_id, group_id);


--
-- TOC entry 3190 (class 2606 OID 34001)
-- Name: polymorphic_auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user
    ADD CONSTRAINT polymorphic_auth_user_pkey PRIMARY KEY (id);


--
-- TOC entry 3198 (class 2606 OID 34003)
-- Name: polymorphic_auth_user_user_permission_user_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions
    ADD CONSTRAINT polymorphic_auth_user_user_permission_user_id_permission_id_key UNIQUE (user_id, permission_id);


--
-- TOC entry 3202 (class 2606 OID 34005)
-- Name: polymorphic_auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions
    ADD CONSTRAINT polymorphic_auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3207 (class 2606 OID 34007)
-- Name: post_office_attachment_emails_attachment_id_email_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails
    ADD CONSTRAINT post_office_attachment_emails_attachment_id_email_id_key UNIQUE (attachment_id, email_id);


--
-- TOC entry 3210 (class 2606 OID 34009)
-- Name: post_office_attachment_emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails
    ADD CONSTRAINT post_office_attachment_emails_pkey PRIMARY KEY (id);


--
-- TOC entry 3204 (class 2606 OID 34011)
-- Name: post_office_attachment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment
    ADD CONSTRAINT post_office_attachment_pkey PRIMARY KEY (id);


--
-- TOC entry 3217 (class 2606 OID 34013)
-- Name: post_office_email_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_email
    ADD CONSTRAINT post_office_email_pkey PRIMARY KEY (id);


--
-- TOC entry 3220 (class 2606 OID 34015)
-- Name: post_office_emailtemplate_language_10f2b61322b48cb2_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_emailtemplate
    ADD CONSTRAINT post_office_emailtemplate_language_10f2b61322b48cb2_uniq UNIQUE (language, default_template_id);


--
-- TOC entry 3222 (class 2606 OID 34017)
-- Name: post_office_emailtemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_emailtemplate
    ADD CONSTRAINT post_office_emailtemplate_pkey PRIMARY KEY (id);


--
-- TOC entry 3225 (class 2606 OID 34019)
-- Name: post_office_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_log
    ADD CONSTRAINT post_office_log_pkey PRIMARY KEY (id);


--
-- TOC entry 3227 (class 2606 OID 34021)
-- Name: redirectnode_redirectnode_t_language_code_2371652d48e2263a_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirectnode_redirectnode_translation
    ADD CONSTRAINT redirectnode_redirectnode_t_language_code_2371652d48e2263a_uniq UNIQUE (language_code, master_id);


--
-- TOC entry 3232 (class 2606 OID 34023)
-- Name: redirectnode_redirectnode_translation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirectnode_redirectnode_translation
    ADD CONSTRAINT redirectnode_redirectnode_translation_pkey PRIMARY KEY (id);


--
-- TOC entry 3234 (class 2606 OID 34025)
-- Name: response_pages_responsepage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY response_pages_responsepage
    ADD CONSTRAINT response_pages_responsepage_pkey PRIMARY KEY (id);


--
-- TOC entry 3237 (class 2606 OID 34027)
-- Name: response_pages_responsepage_type_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY response_pages_responsepage
    ADD CONSTRAINT response_pages_responsepage_type_key UNIQUE (type);


--
-- TOC entry 3243 (class 2606 OID 34029)
-- Name: reversion_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_revision
    ADD CONSTRAINT reversion_revision_pkey PRIMARY KEY (id);


--
-- TOC entry 3248 (class 2606 OID 34031)
-- Name: reversion_version_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_version
    ADD CONSTRAINT reversion_version_pkey PRIMARY KEY (id);


--
-- TOC entry 3258 (class 2606 OID 34033)
-- Name: sharedcontent_sharedcontent_language_code_79f8cd7649850926_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent_translation
    ADD CONSTRAINT sharedcontent_sharedcontent_language_code_79f8cd7649850926_uniq UNIQUE (language_code, master_id);


--
-- TOC entry 3252 (class 2606 OID 34035)
-- Name: sharedcontent_sharedcontent_parent_site_id_d714ccadde43c75_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent
    ADD CONSTRAINT sharedcontent_sharedcontent_parent_site_id_d714ccadde43c75_uniq UNIQUE (parent_site_id, slug);


--
-- TOC entry 3254 (class 2606 OID 34037)
-- Name: sharedcontent_sharedcontent_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent
    ADD CONSTRAINT sharedcontent_sharedcontent_pkey PRIMARY KEY (id);


--
-- TOC entry 3262 (class 2606 OID 34039)
-- Name: sharedcontent_sharedcontent_translation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent_translation
    ADD CONSTRAINT sharedcontent_sharedcontent_translation_pkey PRIMARY KEY (id);


--
-- TOC entry 3268 (class 2606 OID 34041)
-- Name: test_article_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT test_article_pkey PRIMARY KEY (id);


--
-- TOC entry 3270 (class 2606 OID 34043)
-- Name: test_article_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT test_article_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- TOC entry 3490 (class 2606 OID 36373)
-- Name: test_articlelisting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT test_articlelisting_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- TOC entry 3492 (class 2606 OID 36375)
-- Name: test_articlelisting_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT test_articlelisting_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- TOC entry 3280 (class 2606 OID 34045)
-- Name: test_layoutpage_with_related__layoutpagewithrelatedpages_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages
    ADD CONSTRAINT test_layoutpage_with_related__layoutpagewithrelatedpages_id_key UNIQUE (layoutpagewithrelatedpages_id, page_id);


--
-- TOC entry 3276 (class 2606 OID 34047)
-- Name: test_layoutpage_with_related_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT test_layoutpage_with_related_pkey PRIMARY KEY (urlnode_ptr_id);


--
-- TOC entry 3278 (class 2606 OID 34049)
-- Name: test_layoutpage_with_related_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT test_layoutpage_with_related_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- TOC entry 3284 (class 2606 OID 34051)
-- Name: test_layoutpage_with_related_related_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages
    ADD CONSTRAINT test_layoutpage_with_related_related_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 3287 (class 2606 OID 34053)
-- Name: tests_barwithlayout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_barwithlayout
    ADD CONSTRAINT tests_barwithlayout_pkey PRIMARY KEY (id);


--
-- TOC entry 3291 (class 2606 OID 34055)
-- Name: tests_basemodel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_basemodel
    ADD CONSTRAINT tests_basemodel_pkey PRIMARY KEY (id);


--
-- TOC entry 3294 (class 2606 OID 34057)
-- Name: tests_bazwithlayout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_bazwithlayout
    ADD CONSTRAINT tests_bazwithlayout_pkey PRIMARY KEY (id);


--
-- TOC entry 3297 (class 2606 OID 34059)
-- Name: tests_foowithlayout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_foowithlayout
    ADD CONSTRAINT tests_foowithlayout_pkey PRIMARY KEY (id);


--
-- TOC entry 3299 (class 2606 OID 34061)
-- Name: tests_imagetest_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_imagetest
    ADD CONSTRAINT tests_imagetest_pkey PRIMARY KEY (id);


--
-- TOC entry 3495 (class 2606 OID 36419)
-- Name: tests_publishingm2mmodela_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodela
    ADD CONSTRAINT tests_publishingm2mmodela_pkey PRIMARY KEY (id);


--
-- TOC entry 3497 (class 2606 OID 36421)
-- Name: tests_publishingm2mmodela_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodela
    ADD CONSTRAINT tests_publishingm2mmodela_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- TOC entry 3500 (class 2606 OID 36429)
-- Name: tests_publishingm2mmodelb_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb
    ADD CONSTRAINT tests_publishingm2mmodelb_pkey PRIMARY KEY (id);


--
-- TOC entry 3502 (class 2606 OID 36431)
-- Name: tests_publishingm2mmodelb_publishing_linked_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb
    ADD CONSTRAINT tests_publishingm2mmodelb_publishing_linked_id_key UNIQUE (publishing_linked_id);


--
-- TOC entry 3504 (class 2606 OID 36441)
-- Name: tests_publishingm2mmodelb_rel_publishingm2mmodelb_id_publis_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models
    ADD CONSTRAINT tests_publishingm2mmodelb_rel_publishingm2mmodelb_id_publis_key UNIQUE (publishingm2mmodelb_id, publishingm2mmodela_id);


--
-- TOC entry 3508 (class 2606 OID 36439)
-- Name: tests_publishingm2mmodelb_related_a_models_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models
    ADD CONSTRAINT tests_publishingm2mmodelb_related_a_models_pkey PRIMARY KEY (id);


--
-- TOC entry 3512 (class 2606 OID 36449)
-- Name: tests_publishingm2mthroughtable_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mthroughtable
    ADD CONSTRAINT tests_publishingm2mthroughtable_pkey PRIMARY KEY (id);


--
-- TOC entry 3456 (class 2606 OID 36032)
-- Name: workflow_workflowstate_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_workflow_workflowstate
    ADD CONSTRAINT workflow_workflowstate_pkey PRIMARY KEY (id);


--
-- TOC entry 2826 (class 1259 OID 34062)
-- Name: auth_group_name_1172b5263c14af72_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_name_1172b5263c14af72_like ON auth_group USING btree (name varchar_pattern_ops);


--
-- TOC entry 2831 (class 1259 OID 34063)
-- Name: auth_group_permissions_0e939a4f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_0e939a4f ON auth_group_permissions USING btree (group_id);


--
-- TOC entry 2832 (class 1259 OID 34064)
-- Name: auth_group_permissions_8373b171; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_8373b171 ON auth_group_permissions USING btree (permission_id);


--
-- TOC entry 2837 (class 1259 OID 34065)
-- Name: auth_permission_417f1b1c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_permission_417f1b1c ON auth_permission USING btree (content_type_id);


--
-- TOC entry 3300 (class 1259 OID 34833)
-- Name: authtoken_token_key_3fa23395519841bf_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX authtoken_token_key_3fa23395519841bf_like ON authtoken_token USING btree (key varchar_pattern_ops);


--
-- TOC entry 2842 (class 1259 OID 34066)
-- Name: celery_taskmeta_662f707d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX celery_taskmeta_662f707d ON celery_taskmeta USING btree (hidden);


--
-- TOC entry 2845 (class 1259 OID 34067)
-- Name: celery_taskmeta_task_id_6b91bc0b19e47bd3_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX celery_taskmeta_task_id_6b91bc0b19e47bd3_like ON celery_taskmeta USING btree (task_id varchar_pattern_ops);


--
-- TOC entry 2848 (class 1259 OID 34068)
-- Name: celery_tasksetmeta_662f707d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX celery_tasksetmeta_662f707d ON celery_tasksetmeta USING btree (hidden);


--
-- TOC entry 2851 (class 1259 OID 34069)
-- Name: celery_tasksetmeta_taskset_id_1f94bbe10aab6861_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX celery_tasksetmeta_taskset_id_1f94bbe10aab6861_like ON celery_tasksetmeta USING btree (taskset_id varchar_pattern_ops);


--
-- TOC entry 2858 (class 1259 OID 34070)
-- Name: contentitem_file_fileitem_814552b9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_file_fileitem_814552b9 ON contentitem_icekit_plugins_file_fileitem USING btree (file_id);


--
-- TOC entry 3326 (class 1259 OID 35015)
-- Name: contentitem_glamkit_sponsors_sponsorpromoitem_42545d36; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_glamkit_sponsors_sponsorpromoitem_42545d36 ON contentitem_glamkit_sponsors_sponsorpromoitem USING btree (sponsor_id);


--
-- TOC entry 3421 (class 1259 OID 35756)
-- Name: contentitem_icekit_events_links_eventlink_82bfda79; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_icekit_events_links_eventlink_82bfda79 ON contentitem_icekit_events_links_eventlink USING btree (item_id);


--
-- TOC entry 3428 (class 1259 OID 35783)
-- Name: contentitem_icekit_plugins_contact_person_contactpersonitemff5b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_icekit_plugins_contact_person_contactpersonitemff5b ON contentitem_icekit_plugins_contact_person_contactpersonitem USING btree (contact_id);


--
-- TOC entry 3431 (class 1259 OID 35799)
-- Name: contentitem_icekit_plugins_content_listing_contentlistingit9442; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_icekit_plugins_content_listing_contentlistingit9442 ON contentitem_icekit_plugins_content_listing_contentlistingitem USING btree (content_type_id);


--
-- TOC entry 3457 (class 1259 OID 36078)
-- Name: contentitem_ik_event_listing_eventcontentlistingitem_417f1b1c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_ik_event_listing_eventcontentlistingitem_417f1b1c ON contentitem_ik_event_listing_eventcontentlistingitem USING btree (content_type_id);


--
-- TOC entry 3474 (class 1259 OID 36177)
-- Name: contentitem_ik_links_articlelink_82bfda79; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_ik_links_articlelink_82bfda79 ON contentitem_ik_links_articlelink USING btree (item_id);


--
-- TOC entry 3477 (class 1259 OID 36188)
-- Name: contentitem_ik_links_authorlink_82bfda79; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_ik_links_authorlink_82bfda79 ON contentitem_ik_links_authorlink USING btree (item_id);


--
-- TOC entry 3480 (class 1259 OID 36199)
-- Name: contentitem_ik_links_pagelink_82bfda79; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_ik_links_pagelink_82bfda79 ON contentitem_ik_links_pagelink USING btree (item_id);


--
-- TOC entry 3483 (class 1259 OID 36269)
-- Name: contentitem_image_gallery_imagegalleryshowitem_e2c5ae20; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_image_gallery_imagegalleryshowitem_e2c5ae20 ON contentitem_image_gallery_imagegalleryshowitem USING btree (slide_show_id);


--
-- TOC entry 2863 (class 1259 OID 34071)
-- Name: contentitem_image_imageitem_f33175e6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_image_imageitem_f33175e6 ON contentitem_icekit_plugins_image_imageitem USING btree (image_id);


--
-- TOC entry 2880 (class 1259 OID 34072)
-- Name: contentitem_reusable_form_formitem_d6cba1ad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_reusable_form_formitem_d6cba1ad ON contentitem_icekit_plugins_reusable_form_formitem USING btree (form_id);


--
-- TOC entry 2896 (class 1259 OID 34073)
-- Name: contentitem_sharedcontent_sharedcontentitem_9855ad04; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_sharedcontent_sharedcontentitem_9855ad04 ON contentitem_sharedcontent_sharedcontentitem USING btree (shared_content_id);


--
-- TOC entry 2883 (class 1259 OID 34074)
-- Name: contentitem_slideshow_slideshowitem_e2c5ae20; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contentitem_slideshow_slideshowitem_e2c5ae20 ON contentitem_icekit_plugins_slideshow_slideshowitem USING btree (slide_show_id);


--
-- TOC entry 2901 (class 1259 OID 34075)
-- Name: django_admin_log_417f1b1c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_417f1b1c ON django_admin_log USING btree (content_type_id);


--
-- TOC entry 2902 (class 1259 OID 34076)
-- Name: django_admin_log_e8701ad4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_e8701ad4 ON django_admin_log USING btree (user_id);


--
-- TOC entry 2911 (class 1259 OID 34077)
-- Name: django_redirect_91a0b591; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_redirect_91a0b591 ON django_redirect USING btree (old_path);


--
-- TOC entry 2912 (class 1259 OID 34078)
-- Name: django_redirect_9365d6e7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_redirect_9365d6e7 ON django_redirect USING btree (site_id);


--
-- TOC entry 2913 (class 1259 OID 34079)
-- Name: django_redirect_old_path_181d5db44e795f1b_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_redirect_old_path_181d5db44e795f1b_like ON django_redirect USING btree (old_path varchar_pattern_ops);


--
-- TOC entry 2918 (class 1259 OID 34080)
-- Name: django_session_de54fa62; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_de54fa62 ON django_session USING btree (expire_date);


--
-- TOC entry 2921 (class 1259 OID 34081)
-- Name: django_session_session_key_1d0324f13f857f0c_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_session_key_1d0324f13f857f0c_like ON django_session USING btree (session_key varchar_pattern_ops);


--
-- TOC entry 2928 (class 1259 OID 34082)
-- Name: djcelery_periodictask_1dcd7040; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_periodictask_1dcd7040 ON djcelery_periodictask USING btree (interval_id);


--
-- TOC entry 2929 (class 1259 OID 34083)
-- Name: djcelery_periodictask_f3f0d72a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_periodictask_f3f0d72a ON djcelery_periodictask USING btree (crontab_id);


--
-- TOC entry 2930 (class 1259 OID 34084)
-- Name: djcelery_periodictask_name_22a0bf5a7f846642_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_periodictask_name_22a0bf5a7f846642_like ON djcelery_periodictask USING btree (name varchar_pattern_ops);


--
-- TOC entry 2937 (class 1259 OID 34085)
-- Name: djcelery_taskstate_662f707d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_662f707d ON djcelery_taskstate USING btree (hidden);


--
-- TOC entry 2938 (class 1259 OID 34086)
-- Name: djcelery_taskstate_863bb2ee; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_863bb2ee ON djcelery_taskstate USING btree (tstamp);


--
-- TOC entry 2939 (class 1259 OID 34087)
-- Name: djcelery_taskstate_9ed39e2e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_9ed39e2e ON djcelery_taskstate USING btree (state);


--
-- TOC entry 2940 (class 1259 OID 34088)
-- Name: djcelery_taskstate_b068931c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_b068931c ON djcelery_taskstate USING btree (name);


--
-- TOC entry 2941 (class 1259 OID 34089)
-- Name: djcelery_taskstate_ce77e6ef; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_ce77e6ef ON djcelery_taskstate USING btree (worker_id);


--
-- TOC entry 2942 (class 1259 OID 34090)
-- Name: djcelery_taskstate_name_5eafb6f7d1f61c57_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_name_5eafb6f7d1f61c57_like ON djcelery_taskstate USING btree (name varchar_pattern_ops);


--
-- TOC entry 2945 (class 1259 OID 34091)
-- Name: djcelery_taskstate_state_370f3ca0758743bc_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_state_370f3ca0758743bc_like ON djcelery_taskstate USING btree (state varchar_pattern_ops);


--
-- TOC entry 2946 (class 1259 OID 34092)
-- Name: djcelery_taskstate_task_id_57cbbe2b0a0f54b0_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_taskstate_task_id_57cbbe2b0a0f54b0_like ON djcelery_taskstate USING btree (task_id varchar_pattern_ops);


--
-- TOC entry 2949 (class 1259 OID 34093)
-- Name: djcelery_workerstate_f129901a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_workerstate_f129901a ON djcelery_workerstate USING btree (last_heartbeat);


--
-- TOC entry 2950 (class 1259 OID 34094)
-- Name: djcelery_workerstate_hostname_5b80edb25af4bda0_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djcelery_workerstate_hostname_5b80edb25af4bda0_like ON djcelery_workerstate USING btree (hostname varchar_pattern_ops);


--
-- TOC entry 2955 (class 1259 OID 34095)
-- Name: djkombu_message_46cf0e59; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djkombu_message_46cf0e59 ON djkombu_message USING btree (visible);


--
-- TOC entry 2956 (class 1259 OID 34096)
-- Name: djkombu_message_75249aa1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djkombu_message_75249aa1 ON djkombu_message USING btree (queue_id);


--
-- TOC entry 2957 (class 1259 OID 34097)
-- Name: djkombu_message_df2f2974; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djkombu_message_df2f2974 ON djkombu_message USING btree (sent_at);


--
-- TOC entry 2960 (class 1259 OID 34098)
-- Name: djkombu_queue_name_612340776a86999f_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX djkombu_queue_name_612340776a86999f_like ON djkombu_queue USING btree (name varchar_pattern_ops);


--
-- TOC entry 2965 (class 1259 OID 34099)
-- Name: easy_thumbnails_source_b068931c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_source_b068931c ON easy_thumbnails_source USING btree (name);


--
-- TOC entry 2966 (class 1259 OID 34100)
-- Name: easy_thumbnails_source_b454e115; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_source_b454e115 ON easy_thumbnails_source USING btree (storage_hash);


--
-- TOC entry 2967 (class 1259 OID 34101)
-- Name: easy_thumbnails_source_name_64cbfaeec7d864e_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_source_name_64cbfaeec7d864e_like ON easy_thumbnails_source USING btree (name varchar_pattern_ops);


--
-- TOC entry 2970 (class 1259 OID 34102)
-- Name: easy_thumbnails_source_storage_hash_4095a857034bdf69_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_source_storage_hash_4095a857034bdf69_like ON easy_thumbnails_source USING btree (storage_hash varchar_pattern_ops);


--
-- TOC entry 2973 (class 1259 OID 34103)
-- Name: easy_thumbnails_thumbnail_0afd9202; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_thumbnail_0afd9202 ON easy_thumbnails_thumbnail USING btree (source_id);


--
-- TOC entry 2974 (class 1259 OID 34104)
-- Name: easy_thumbnails_thumbnail_b068931c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_thumbnail_b068931c ON easy_thumbnails_thumbnail USING btree (name);


--
-- TOC entry 2975 (class 1259 OID 34105)
-- Name: easy_thumbnails_thumbnail_b454e115; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_thumbnail_b454e115 ON easy_thumbnails_thumbnail USING btree (storage_hash);


--
-- TOC entry 2976 (class 1259 OID 34106)
-- Name: easy_thumbnails_thumbnail_name_3d09f2222d55456a_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_thumbnail_name_3d09f2222d55456a_like ON easy_thumbnails_thumbnail USING btree (name varchar_pattern_ops);


--
-- TOC entry 2981 (class 1259 OID 34107)
-- Name: easy_thumbnails_thumbnail_storage_hash_71db05c63376833_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX easy_thumbnails_thumbnail_storage_hash_71db05c63376833_like ON easy_thumbnails_thumbnail USING btree (storage_hash varchar_pattern_ops);


--
-- TOC entry 2986 (class 1259 OID 34108)
-- Name: file_file_categories_814552b9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX file_file_categories_814552b9 ON icekit_plugins_file_file_categories USING btree (file_id);


--
-- TOC entry 2987 (class 1259 OID 34109)
-- Name: file_file_categories_a1a67fb1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX file_file_categories_a1a67fb1 ON icekit_plugins_file_file_categories USING btree (mediacategory_id);


--
-- TOC entry 2994 (class 1259 OID 34110)
-- Name: fluent_contents_contentitem_2e3c0484; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_contentitem_2e3c0484 ON fluent_contents_contentitem USING btree (parent_type_id);


--
-- TOC entry 2995 (class 1259 OID 34111)
-- Name: fluent_contents_contentitem_60716c2f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_contentitem_60716c2f ON fluent_contents_contentitem USING btree (language_code);


--
-- TOC entry 2996 (class 1259 OID 34112)
-- Name: fluent_contents_contentitem_667a6151; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_contentitem_667a6151 ON fluent_contents_contentitem USING btree (placeholder_id);


--
-- TOC entry 2997 (class 1259 OID 34113)
-- Name: fluent_contents_contentitem_a73f1f77; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_contentitem_a73f1f77 ON fluent_contents_contentitem USING btree (sort_order);


--
-- TOC entry 2998 (class 1259 OID 34114)
-- Name: fluent_contents_contentitem_d3e32c49; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_contentitem_d3e32c49 ON fluent_contents_contentitem USING btree (polymorphic_ctype_id);


--
-- TOC entry 2999 (class 1259 OID 34115)
-- Name: fluent_contents_contentitem_language_code_76a23282cc857519_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_contentitem_language_code_76a23282cc857519_like ON fluent_contents_contentitem USING btree (language_code varchar_pattern_ops);


--
-- TOC entry 3004 (class 1259 OID 34116)
-- Name: fluent_contents_placeholder_2e3c0484; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_placeholder_2e3c0484 ON fluent_contents_placeholder USING btree (parent_type_id);


--
-- TOC entry 3005 (class 1259 OID 34117)
-- Name: fluent_contents_placeholder_5e97994e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_placeholder_5e97994e ON fluent_contents_placeholder USING btree (slot);


--
-- TOC entry 3008 (class 1259 OID 34118)
-- Name: fluent_contents_placeholder_slot_25dbe8a2e622313f_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_contents_placeholder_slot_25dbe8a2e622313f_like ON fluent_contents_placeholder USING btree (slot varchar_pattern_ops);


--
-- TOC entry 3009 (class 1259 OID 34119)
-- Name: fluent_pages_htmlpage_trans_language_code_36ea79a688496b13_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_htmlpage_trans_language_code_36ea79a688496b13_like ON fluent_pages_htmlpage_translation USING btree (language_code varchar_pattern_ops);


--
-- TOC entry 3012 (class 1259 OID 34120)
-- Name: fluent_pages_htmlpage_translation_60716c2f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_htmlpage_translation_60716c2f ON fluent_pages_htmlpage_translation USING btree (language_code);


--
-- TOC entry 3013 (class 1259 OID 34121)
-- Name: fluent_pages_htmlpage_translation_90349b61; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_htmlpage_translation_90349b61 ON fluent_pages_htmlpage_translation USING btree (master_id);


--
-- TOC entry 3016 (class 1259 OID 34122)
-- Name: fluent_pages_pagelayout_3c6e0b8a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_pagelayout_3c6e0b8a ON fluent_pages_pagelayout USING btree (key);


--
-- TOC entry 3017 (class 1259 OID 34123)
-- Name: fluent_pages_pagelayout_key_46908e2040ef5271_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_pagelayout_key_46908e2040ef5271_like ON fluent_pages_pagelayout USING btree (key varchar_pattern_ops);


--
-- TOC entry 3020 (class 1259 OID 34124)
-- Name: fluent_pages_urlnode_0b39ac3a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_0b39ac3a ON fluent_pages_urlnode USING btree (in_sitemaps);


--
-- TOC entry 3021 (class 1259 OID 34125)
-- Name: fluent_pages_urlnode_2247c5f0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_2247c5f0 ON fluent_pages_urlnode USING btree (publication_end_date);


--
-- TOC entry 3022 (class 1259 OID 34126)
-- Name: fluent_pages_urlnode_3c6e0b8a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_3c6e0b8a ON fluent_pages_urlnode USING btree (key);


--
-- TOC entry 3023 (class 1259 OID 34127)
-- Name: fluent_pages_urlnode_3cfbd988; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_3cfbd988 ON fluent_pages_urlnode USING btree (rght);


--
-- TOC entry 3024 (class 1259 OID 34128)
-- Name: fluent_pages_urlnode_4e147804; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_4e147804 ON fluent_pages_urlnode USING btree (parent_site_id);


--
-- TOC entry 3025 (class 1259 OID 34129)
-- Name: fluent_pages_urlnode_4f331e2f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_4f331e2f ON fluent_pages_urlnode USING btree (author_id);


--
-- TOC entry 3026 (class 1259 OID 34130)
-- Name: fluent_pages_urlnode_656442a0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_656442a0 ON fluent_pages_urlnode USING btree (tree_id);


--
-- TOC entry 3027 (class 1259 OID 34131)
-- Name: fluent_pages_urlnode_6be37982; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_6be37982 ON fluent_pages_urlnode USING btree (parent_id);


--
-- TOC entry 3028 (class 1259 OID 34132)
-- Name: fluent_pages_urlnode_93b83098; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_93b83098 ON fluent_pages_urlnode USING btree (publication_date);


--
-- TOC entry 3029 (class 1259 OID 34133)
-- Name: fluent_pages_urlnode_9acb4454; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_9acb4454 ON fluent_pages_urlnode USING btree (status);


--
-- TOC entry 3030 (class 1259 OID 34134)
-- Name: fluent_pages_urlnode_c9e9a848; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_c9e9a848 ON fluent_pages_urlnode USING btree (level);


--
-- TOC entry 3031 (class 1259 OID 34135)
-- Name: fluent_pages_urlnode_caf7cc51; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_caf7cc51 ON fluent_pages_urlnode USING btree (lft);


--
-- TOC entry 3032 (class 1259 OID 34136)
-- Name: fluent_pages_urlnode_d3e32c49; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_d3e32c49 ON fluent_pages_urlnode USING btree (polymorphic_ctype_id);


--
-- TOC entry 3033 (class 1259 OID 34137)
-- Name: fluent_pages_urlnode_db3eb53f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_db3eb53f ON fluent_pages_urlnode USING btree (in_navigation);


--
-- TOC entry 3034 (class 1259 OID 34138)
-- Name: fluent_pages_urlnode_key_4aaa2ca81cd3c720_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_key_4aaa2ca81cd3c720_like ON fluent_pages_urlnode USING btree (key varchar_pattern_ops);


--
-- TOC entry 3039 (class 1259 OID 34139)
-- Name: fluent_pages_urlnode_status_35afe259615cc8fc_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_status_35afe259615cc8fc_like ON fluent_pages_urlnode USING btree (status varchar_pattern_ops);


--
-- TOC entry 3042 (class 1259 OID 34140)
-- Name: fluent_pages_urlnode_transl_language_code_6fd22d552eed92a3_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_transl_language_code_6fd22d552eed92a3_like ON fluent_pages_urlnode_translation USING btree (language_code varchar_pattern_ops);


--
-- TOC entry 3043 (class 1259 OID 34141)
-- Name: fluent_pages_urlnode_translat__cached_url_4edf25eb6217d636_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_translat__cached_url_4edf25eb6217d636_like ON fluent_pages_urlnode_translation USING btree (_cached_url varchar_pattern_ops);


--
-- TOC entry 3044 (class 1259 OID 34142)
-- Name: fluent_pages_urlnode_translation_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_translation_2dbcba41 ON fluent_pages_urlnode_translation USING btree (slug);


--
-- TOC entry 3045 (class 1259 OID 34143)
-- Name: fluent_pages_urlnode_translation_60716c2f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_translation_60716c2f ON fluent_pages_urlnode_translation USING btree (language_code);


--
-- TOC entry 3046 (class 1259 OID 34144)
-- Name: fluent_pages_urlnode_translation_90349b61; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_translation_90349b61 ON fluent_pages_urlnode_translation USING btree (master_id);


--
-- TOC entry 3047 (class 1259 OID 34145)
-- Name: fluent_pages_urlnode_translation_f2efa396; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_translation_f2efa396 ON fluent_pages_urlnode_translation USING btree (_cached_url);


--
-- TOC entry 3050 (class 1259 OID 34146)
-- Name: fluent_pages_urlnode_translation_slug_7d32623ac23895b3_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fluent_pages_urlnode_translation_slug_7d32623ac23895b3_like ON fluent_pages_urlnode_translation USING btree (slug varchar_pattern_ops);


--
-- TOC entry 3051 (class 1259 OID 34147)
-- Name: forms_field_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_field_2dbcba41 ON forms_field USING btree (slug);


--
-- TOC entry 3052 (class 1259 OID 34148)
-- Name: forms_field_d6cba1ad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_field_d6cba1ad ON forms_field USING btree (form_id);


--
-- TOC entry 3055 (class 1259 OID 34149)
-- Name: forms_field_slug_c05572b5ffee537_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_field_slug_c05572b5ffee537_like ON forms_field USING btree (slug varchar_pattern_ops);


--
-- TOC entry 3056 (class 1259 OID 34150)
-- Name: forms_fieldentry_b64a62ea; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_fieldentry_b64a62ea ON forms_fieldentry USING btree (entry_id);


--
-- TOC entry 3064 (class 1259 OID 34151)
-- Name: forms_form_sites_9365d6e7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_form_sites_9365d6e7 ON forms_form_sites USING btree (site_id);


--
-- TOC entry 3065 (class 1259 OID 34152)
-- Name: forms_form_sites_d6cba1ad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_form_sites_d6cba1ad ON forms_form_sites USING btree (form_id);


--
-- TOC entry 3061 (class 1259 OID 34153)
-- Name: forms_form_slug_6d924c15a127787e_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_form_slug_6d924c15a127787e_like ON forms_form USING btree (slug varchar_pattern_ops);


--
-- TOC entry 3070 (class 1259 OID 34154)
-- Name: forms_formentry_d6cba1ad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX forms_formentry_d6cba1ad ON forms_formentry USING btree (form_id);


--
-- TOC entry 3312 (class 1259 OID 34949)
-- Name: glamkit_collections_country_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX glamkit_collections_country_2dbcba41 ON glamkit_collections_country USING btree (slug);


--
-- TOC entry 3315 (class 1259 OID 34950)
-- Name: glamkit_collections_country_slug_19dd251344cbecd3_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX glamkit_collections_country_slug_19dd251344cbecd3_like ON glamkit_collections_country USING btree (slug varchar_pattern_ops);


--
-- TOC entry 3316 (class 1259 OID 34956)
-- Name: glamkit_collections_geographiclocation_93bfec8a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX glamkit_collections_geographiclocation_93bfec8a ON glamkit_collections_geographiclocation USING btree (country_id);


--
-- TOC entry 3319 (class 1259 OID 34973)
-- Name: glamkit_sponsors_sponsor_8c0ff365; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX glamkit_sponsors_sponsor_8c0ff365 ON glamkit_sponsors_sponsor USING btree (logo_id);


--
-- TOC entry 3329 (class 1259 OID 35044)
-- Name: icekit_article_article_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_article_article_2dbcba41 ON icekit_article_article USING btree (slug);


--
-- TOC entry 3330 (class 1259 OID 35110)
-- Name: icekit_article_article_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_article_article_441a5015 ON icekit_article_article USING btree (hero_image_id);


--
-- TOC entry 3331 (class 1259 OID 35064)
-- Name: icekit_article_article_6be37982; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_article_article_6be37982 ON icekit_article_article USING btree (parent_id);


--
-- TOC entry 3332 (class 1259 OID 35045)
-- Name: icekit_article_article_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_article_article_72bc1be0 ON icekit_article_article USING btree (layout_id);


--
-- TOC entry 3333 (class 1259 OID 35043)
-- Name: icekit_article_article_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_article_article_b667876a ON icekit_article_article USING btree (publishing_is_draft);


--
-- TOC entry 3340 (class 1259 OID 35046)
-- Name: icekit_article_article_slug_b2859d6f4a93ae9_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_article_article_slug_b2859d6f4a93ae9_like ON icekit_article_article USING btree (slug varchar_pattern_ops);


--
-- TOC entry 3352 (class 1259 OID 35289)
-- Name: icekit_authors_author_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_authors_author_2dbcba41 ON icekit_authors_author USING btree (slug);


--
-- TOC entry 3353 (class 1259 OID 35290)
-- Name: icekit_authors_author_6968df0c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_authors_author_6968df0c ON icekit_authors_author USING btree (hero_image_id);


--
-- TOC entry 3354 (class 1259 OID 35288)
-- Name: icekit_authors_author_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_authors_author_b667876a ON icekit_authors_author USING btree (publishing_is_draft);


--
-- TOC entry 3359 (class 1259 OID 35291)
-- Name: icekit_authors_author_slug_dc26027f0341645_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_authors_author_slug_dc26027f0341645_like ON icekit_authors_author USING btree (slug varchar_pattern_ops);


--
-- TOC entry 3408 (class 1259 OID 35511)
-- Name: icekit_event_types_simple_simpleevent_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_event_types_simple_simpleevent_72bc1be0 ON icekit_event_types_simple_simpleevent USING btree (layout_id);


--
-- TOC entry 3367 (class 1259 OID 35462)
-- Name: icekit_events_eventbase_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_2dbcba41 ON icekit_events_eventbase USING btree (slug);


--
-- TOC entry 3368 (class 1259 OID 35532)
-- Name: icekit_events_eventbase_6cad1465; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_6cad1465 ON icekit_events_eventbase USING btree (part_of_id);


--
-- TOC entry 3369 (class 1259 OID 35583)
-- Name: icekit_events_eventbase_7af97c1b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_7af97c1b ON icekit_events_eventbase USING btree (primary_type_id);


--
-- TOC entry 3370 (class 1259 OID 35465)
-- Name: icekit_events_eventbase_7fa10fbf; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_7fa10fbf ON icekit_events_eventbase USING btree (derived_from_id);


--
-- TOC entry 3371 (class 1259 OID 35464)
-- Name: icekit_events_eventbase_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_9ae73c65 ON icekit_events_eventbase USING btree (modified);


--
-- TOC entry 3372 (class 1259 OID 35461)
-- Name: icekit_events_eventbase_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_b667876a ON icekit_events_eventbase USING btree (publishing_is_draft);


--
-- TOC entry 3373 (class 1259 OID 35466)
-- Name: icekit_events_eventbase_d3e32c49; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_d3e32c49 ON icekit_events_eventbase USING btree (polymorphic_ctype_id);


--
-- TOC entry 3374 (class 1259 OID 35463)
-- Name: icekit_events_eventbase_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_e2fa5388 ON icekit_events_eventbase USING btree (created);


--
-- TOC entry 3417 (class 1259 OID 35599)
-- Name: icekit_events_eventbase_secondary_types_09b50619; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_secondary_types_09b50619 ON icekit_events_eventbase_secondary_types USING btree (eventbase_id);


--
-- TOC entry 3418 (class 1259 OID 35600)
-- Name: icekit_events_eventbase_secondary_types_79752242; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_secondary_types_79752242 ON icekit_events_eventbase_secondary_types USING btree (eventtype_id);


--
-- TOC entry 3379 (class 1259 OID 35467)
-- Name: icekit_events_eventbase_slug_460a2914186e20d0_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventbase_slug_460a2914186e20d0_like ON icekit_events_eventbase USING btree (slug varchar_pattern_ops);


--
-- TOC entry 3380 (class 1259 OID 35477)
-- Name: icekit_events_eventrepeatsgenerator_32f63e2e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventrepeatsgenerator_32f63e2e ON icekit_events_eventrepeatsgenerator USING btree (is_all_day);


--
-- TOC entry 3381 (class 1259 OID 35478)
-- Name: icekit_events_eventrepeatsgenerator_4437cfac; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventrepeatsgenerator_4437cfac ON icekit_events_eventrepeatsgenerator USING btree (event_id);


--
-- TOC entry 3382 (class 1259 OID 35476)
-- Name: icekit_events_eventrepeatsgenerator_7f021a14; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventrepeatsgenerator_7f021a14 ON icekit_events_eventrepeatsgenerator USING btree ("end");


--
-- TOC entry 3383 (class 1259 OID 35474)
-- Name: icekit_events_eventrepeatsgenerator_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventrepeatsgenerator_9ae73c65 ON icekit_events_eventrepeatsgenerator USING btree (modified);


--
-- TOC entry 3384 (class 1259 OID 35473)
-- Name: icekit_events_eventrepeatsgenerator_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventrepeatsgenerator_e2fa5388 ON icekit_events_eventrepeatsgenerator USING btree (created);


--
-- TOC entry 3385 (class 1259 OID 35475)
-- Name: icekit_events_eventrepeatsgenerator_ea2b2676; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventrepeatsgenerator_ea2b2676 ON icekit_events_eventrepeatsgenerator USING btree (start);


--
-- TOC entry 3411 (class 1259 OID 35581)
-- Name: icekit_events_eventtype_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventtype_2dbcba41 ON icekit_events_eventtype USING btree (slug);


--
-- TOC entry 3414 (class 1259 OID 35582)
-- Name: icekit_events_eventtype_slug_18b5b3ec88778f2b_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_eventtype_slug_18b5b3ec88778f2b_like ON icekit_events_eventtype USING btree (slug varchar_pattern_ops);


--
-- TOC entry 3388 (class 1259 OID 35494)
-- Name: icekit_events_occurrence_213f2807; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_occurrence_213f2807 ON icekit_events_occurrence USING btree (is_protected_from_regeneration);


--
-- TOC entry 3389 (class 1259 OID 35493)
-- Name: icekit_events_occurrence_32f63e2e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_occurrence_32f63e2e ON icekit_events_occurrence USING btree (is_all_day);


--
-- TOC entry 3390 (class 1259 OID 35495)
-- Name: icekit_events_occurrence_4437cfac; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_occurrence_4437cfac ON icekit_events_occurrence USING btree (event_id);


--
-- TOC entry 3391 (class 1259 OID 35496)
-- Name: icekit_events_occurrence_5a9e8819; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_occurrence_5a9e8819 ON icekit_events_occurrence USING btree (generator_id);


--
-- TOC entry 3392 (class 1259 OID 35492)
-- Name: icekit_events_occurrence_7f021a14; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_occurrence_7f021a14 ON icekit_events_occurrence USING btree ("end");


--
-- TOC entry 3393 (class 1259 OID 35490)
-- Name: icekit_events_occurrence_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_occurrence_9ae73c65 ON icekit_events_occurrence USING btree (modified);


--
-- TOC entry 3394 (class 1259 OID 35489)
-- Name: icekit_events_occurrence_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_occurrence_e2fa5388 ON icekit_events_occurrence USING btree (created);


--
-- TOC entry 3395 (class 1259 OID 35491)
-- Name: icekit_events_occurrence_ea2b2676; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_occurrence_ea2b2676 ON icekit_events_occurrence USING btree (start);


--
-- TOC entry 3398 (class 1259 OID 35500)
-- Name: icekit_events_recurrencer_recurrence_rule_133d55ac9ccf45e7_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_recurrencer_recurrence_rule_133d55ac9ccf45e7_like ON icekit_events_recurrencerule USING btree (recurrence_rule text_pattern_ops);


--
-- TOC entry 3399 (class 1259 OID 35498)
-- Name: icekit_events_recurrencerule_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_recurrencerule_9ae73c65 ON icekit_events_recurrencerule USING btree (modified);


--
-- TOC entry 3400 (class 1259 OID 35499)
-- Name: icekit_events_recurrencerule_description_73fd70367b7880fc_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_recurrencerule_description_73fd70367b7880fc_like ON icekit_events_recurrencerule USING btree (description text_pattern_ops);


--
-- TOC entry 3403 (class 1259 OID 35497)
-- Name: icekit_events_recurrencerule_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_events_recurrencerule_e2fa5388 ON icekit_events_recurrencerule USING btree (created);


--
-- TOC entry 3073 (class 1259 OID 34155)
-- Name: icekit_layout_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_layout_9ae73c65 ON icekit_layout USING btree (modified);


--
-- TOC entry 3080 (class 1259 OID 34156)
-- Name: icekit_layout_content_types_17321e91; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_layout_content_types_17321e91 ON icekit_layout_content_types USING btree (contenttype_id);


--
-- TOC entry 3081 (class 1259 OID 34157)
-- Name: icekit_layout_content_types_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_layout_content_types_72bc1be0 ON icekit_layout_content_types USING btree (layout_id);


--
-- TOC entry 3074 (class 1259 OID 34158)
-- Name: icekit_layout_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_layout_e2fa5388 ON icekit_layout USING btree (created);


--
-- TOC entry 3077 (class 1259 OID 34159)
-- Name: icekit_layout_template_name_1b178bcb3332c00d_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_layout_template_name_1b178bcb3332c00d_like ON icekit_layout USING btree (template_name varchar_pattern_ops);


--
-- TOC entry 3086 (class 1259 OID 34160)
-- Name: icekit_mediacategory_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_mediacategory_9ae73c65 ON icekit_mediacategory USING btree (modified);


--
-- TOC entry 3087 (class 1259 OID 34161)
-- Name: icekit_mediacategory_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_mediacategory_e2fa5388 ON icekit_mediacategory USING btree (created);


--
-- TOC entry 3088 (class 1259 OID 34162)
-- Name: icekit_mediacategory_name_5e7712ef4d5765d8_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_mediacategory_name_5e7712ef4d5765d8_like ON icekit_mediacategory USING btree (name varchar_pattern_ops);


--
-- TOC entry 3348 (class 1259 OID 35230)
-- Name: icekit_plugins_image_imagerepurposec_slug_345f80d7ce642102_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_plugins_image_imagerepurposec_slug_345f80d7ce642102_like ON icekit_plugins_image_imagerepurposeconfig USING btree (slug varchar_pattern_ops);


--
-- TOC entry 3349 (class 1259 OID 35229)
-- Name: icekit_plugins_image_imagerepurposeconfig_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_plugins_image_imagerepurposeconfig_2dbcba41 ON icekit_plugins_image_imagerepurposeconfig USING btree (slug);


--
-- TOC entry 3101 (class 1259 OID 34163)
-- Name: icekit_plugins_slideshow_slideshow_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_plugins_slideshow_slideshow_b667876a ON icekit_plugins_slideshow_slideshow USING btree (publishing_is_draft);


--
-- TOC entry 3432 (class 1259 OID 35885)
-- Name: icekit_press_releases_pressrelease_23690fd7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_23690fd7 ON icekit_press_releases_pressrelease USING btree (released);


--
-- TOC entry 3433 (class 1259 OID 35882)
-- Name: icekit_press_releases_pressrelease_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_2dbcba41 ON icekit_press_releases_pressrelease USING btree (slug);


--
-- TOC entry 3434 (class 1259 OID 35910)
-- Name: icekit_press_releases_pressrelease_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_72bc1be0 ON icekit_press_releases_pressrelease USING btree (layout_id);


--
-- TOC entry 3435 (class 1259 OID 35884)
-- Name: icekit_press_releases_pressrelease_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_9ae73c65 ON icekit_press_releases_pressrelease USING btree (modified);


--
-- TOC entry 3436 (class 1259 OID 35904)
-- Name: icekit_press_releases_pressrelease_b583a629; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_b583a629 ON icekit_press_releases_pressrelease USING btree (category_id);


--
-- TOC entry 3437 (class 1259 OID 35881)
-- Name: icekit_press_releases_pressrelease_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_b667876a ON icekit_press_releases_pressrelease USING btree (publishing_is_draft);


--
-- TOC entry 3438 (class 1259 OID 35883)
-- Name: icekit_press_releases_pressrelease_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_e2fa5388 ON icekit_press_releases_pressrelease USING btree (created);


--
-- TOC entry 3443 (class 1259 OID 35886)
-- Name: icekit_press_releases_pressrelease_slug_613c0b054af80abd_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX icekit_press_releases_pressrelease_slug_613c0b054af80abd_like ON icekit_press_releases_pressrelease USING btree (slug varchar_pattern_ops);


--
-- TOC entry 3460 (class 1259 OID 36100)
-- Name: ik_event_listing_types_79752242; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ik_event_listing_types_79752242 ON ik_event_listing_types USING btree (eventtype_id);


--
-- TOC entry 3463 (class 1259 OID 36099)
-- Name: ik_event_listing_types_fed6ef54; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ik_event_listing_types_fed6ef54 ON ik_event_listing_types USING btree (eventcontentlistingitem_id);


--
-- TOC entry 3468 (class 1259 OID 36131)
-- Name: ik_todays_occurrences_types_70a97ca9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ik_todays_occurrences_types_70a97ca9 ON ik_todays_occurrences_types USING btree (todaysoccurrences_id);


--
-- TOC entry 3469 (class 1259 OID 36132)
-- Name: ik_todays_occurrences_types_79752242; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ik_todays_occurrences_types_79752242 ON ik_todays_occurrences_types USING btree (eventtype_id);


--
-- TOC entry 3095 (class 1259 OID 34164)
-- Name: image_image_categories_a1a67fb1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX image_image_categories_a1a67fb1 ON icekit_plugins_image_image_categories USING btree (mediacategory_id);


--
-- TOC entry 3096 (class 1259 OID 34165)
-- Name: image_image_categories_f33175e6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX image_image_categories_f33175e6 ON icekit_plugins_image_image_categories USING btree (image_id);


--
-- TOC entry 3122 (class 1259 OID 34166)
-- Name: model_settings_setting_d3e32c49; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX model_settings_setting_d3e32c49 ON model_settings_setting USING btree (polymorphic_ctype_id);


--
-- TOC entry 3123 (class 1259 OID 34167)
-- Name: model_settings_setting_name_585c45131907f454_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX model_settings_setting_name_585c45131907f454_like ON model_settings_setting USING btree (name varchar_pattern_ops);


--
-- TOC entry 3134 (class 1259 OID 34168)
-- Name: notifications_followerinformation_417f1b1c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_followerinformation_417f1b1c ON notifications_followerinformation USING btree (content_type_id);


--
-- TOC entry 3135 (class 1259 OID 34169)
-- Name: notifications_followerinformation_d3e32c49; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_followerinformation_d3e32c49 ON notifications_followerinformation USING btree (polymorphic_ctype_id);


--
-- TOC entry 3140 (class 1259 OID 34170)
-- Name: notifications_followerinformation_followers_e8701ad4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_followerinformation_followers_e8701ad4 ON notifications_followerinformation_followers USING btree (user_id);


--
-- TOC entry 3141 (class 1259 OID 34171)
-- Name: notifications_followerinformation_followers_ed2a121f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_followerinformation_followers_ed2a121f ON notifications_followerinformation_followers USING btree (followerinformation_id);


--
-- TOC entry 3146 (class 1259 OID 34172)
-- Name: notifications_followerinformation_group_followers_0e939a4f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_followerinformation_group_followers_0e939a4f ON notifications_followerinformation_group_followers USING btree (group_id);


--
-- TOC entry 3147 (class 1259 OID 34173)
-- Name: notifications_followerinformation_group_followers_ed2a121f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_followerinformation_group_followers_ed2a121f ON notifications_followerinformation_group_followers USING btree (followerinformation_id);


--
-- TOC entry 3150 (class 1259 OID 34174)
-- Name: notifications_hasreadmessage_4ccaa172; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_hasreadmessage_4ccaa172 ON notifications_hasreadmessage USING btree (message_id);


--
-- TOC entry 3151 (class 1259 OID 34175)
-- Name: notifications_hasreadmessage_a8452ca7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_hasreadmessage_a8452ca7 ON notifications_hasreadmessage USING btree (person_id);


--
-- TOC entry 3154 (class 1259 OID 34176)
-- Name: notifications_notification_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_notification_9ae73c65 ON notifications_notification USING btree (modified);


--
-- TOC entry 3155 (class 1259 OID 34177)
-- Name: notifications_notification_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_notification_e2fa5388 ON notifications_notification USING btree (created);


--
-- TOC entry 3156 (class 1259 OID 34178)
-- Name: notifications_notification_e8701ad4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_notification_e8701ad4 ON notifications_notification USING btree (user_id);


--
-- TOC entry 3307 (class 1259 OID 34916)
-- Name: pagetype_eventlistingfordate_eventlistingpage_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_eventlistingfordate_eventlistingpage_441a5015 ON pagetype_eventlistingfordate_eventlistingpage USING btree (hero_image_id);


--
-- TOC entry 3308 (class 1259 OID 34890)
-- Name: pagetype_eventlistingfordate_eventlistingpage_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_eventlistingfordate_eventlistingpage_72bc1be0 ON pagetype_eventlistingfordate_eventlistingpage USING btree (layout_id);


--
-- TOC entry 3309 (class 1259 OID 34889)
-- Name: pagetype_eventlistingfordate_eventlistingpage_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_eventlistingfordate_eventlistingpage_b667876a ON pagetype_eventlistingfordate_eventlistingpage USING btree (publishing_is_draft);


--
-- TOC entry 3163 (class 1259 OID 34179)
-- Name: pagetype_fluentpage_fluentpage_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_fluentpage_fluentpage_72bc1be0 ON pagetype_fluentpage_fluentpage USING btree (layout_id);


--
-- TOC entry 3343 (class 1259 OID 35141)
-- Name: pagetype_icekit_article_articlecategorypage_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_article_articlecategorypage_441a5015 ON icekit_articlecategorypage USING btree (hero_image_id);


--
-- TOC entry 3344 (class 1259 OID 35063)
-- Name: pagetype_icekit_article_articlecategorypage_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_article_articlecategorypage_72bc1be0 ON icekit_articlecategorypage USING btree (layout_id);


--
-- TOC entry 3345 (class 1259 OID 35062)
-- Name: pagetype_icekit_article_articlecategorypage_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_article_articlecategorypage_b667876a ON icekit_articlecategorypage USING btree (publishing_is_draft);


--
-- TOC entry 3360 (class 1259 OID 35334)
-- Name: pagetype_icekit_authors_authorlisting_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_authors_authorlisting_441a5015 ON icekit_authorlisting USING btree (hero_image_id);


--
-- TOC entry 3361 (class 1259 OID 35308)
-- Name: pagetype_icekit_authors_authorlisting_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_authors_authorlisting_72bc1be0 ON icekit_authorlisting USING btree (layout_id);


--
-- TOC entry 3362 (class 1259 OID 35307)
-- Name: pagetype_icekit_authors_authorlisting_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_authors_authorlisting_b667876a ON icekit_authorlisting USING btree (publishing_is_draft);


--
-- TOC entry 3448 (class 1259 OID 35979)
-- Name: pagetype_icekit_press_releases_pressreleaselisting_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_press_releases_pressreleaselisting_441a5015 ON pagetype_icekit_press_releases_pressreleaselisting USING btree (hero_image_id);


--
-- TOC entry 3449 (class 1259 OID 35953)
-- Name: pagetype_icekit_press_releases_pressreleaselisting_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_press_releases_pressreleaselisting_72bc1be0 ON pagetype_icekit_press_releases_pressreleaselisting USING btree (layout_id);


--
-- TOC entry 3450 (class 1259 OID 35952)
-- Name: pagetype_icekit_press_releases_pressreleaselisting_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_icekit_press_releases_pressreleaselisting_b667876a ON pagetype_icekit_press_releases_pressreleaselisting USING btree (publishing_is_draft);


--
-- TOC entry 3166 (class 1259 OID 36300)
-- Name: pagetype_layout_page_layoutpage_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_layout_page_layoutpage_441a5015 ON icekit_layoutpage USING btree (hero_image_id);


--
-- TOC entry 3167 (class 1259 OID 34180)
-- Name: pagetype_layout_page_layoutpage_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_layout_page_layoutpage_72bc1be0 ON icekit_layoutpage USING btree (layout_id);


--
-- TOC entry 3168 (class 1259 OID 34181)
-- Name: pagetype_layout_page_layoutpage_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_layout_page_layoutpage_b667876a ON icekit_layoutpage USING btree (publishing_is_draft);


--
-- TOC entry 3175 (class 1259 OID 34182)
-- Name: pagetype_search_page_searchpage_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_search_page_searchpage_b667876a ON icekit_searchpage USING btree (publishing_is_draft);


--
-- TOC entry 3180 (class 1259 OID 34183)
-- Name: pagetype_tests_unpublishablelayoutpage_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pagetype_tests_unpublishablelayoutpage_72bc1be0 ON pagetype_tests_unpublishablelayoutpage USING btree (layout_id);


--
-- TOC entry 3183 (class 1259 OID 34184)
-- Name: polymorphic_auth_email_emailuser_email_7f6931e7c4b39df0_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX polymorphic_auth_email_emailuser_email_7f6931e7c4b39df0_like ON polymorphic_auth_email_emailuser USING btree (email varchar_pattern_ops);


--
-- TOC entry 3188 (class 1259 OID 34185)
-- Name: polymorphic_auth_user_d3e32c49; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX polymorphic_auth_user_d3e32c49 ON polymorphic_auth_user USING btree (polymorphic_ctype_id);


--
-- TOC entry 3191 (class 1259 OID 34186)
-- Name: polymorphic_auth_user_groups_0e939a4f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX polymorphic_auth_user_groups_0e939a4f ON polymorphic_auth_user_groups USING btree (group_id);


--
-- TOC entry 3192 (class 1259 OID 34187)
-- Name: polymorphic_auth_user_groups_e8701ad4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX polymorphic_auth_user_groups_e8701ad4 ON polymorphic_auth_user_groups USING btree (user_id);


--
-- TOC entry 3199 (class 1259 OID 34188)
-- Name: polymorphic_auth_user_user_permissions_8373b171; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX polymorphic_auth_user_user_permissions_8373b171 ON polymorphic_auth_user_user_permissions USING btree (permission_id);


--
-- TOC entry 3200 (class 1259 OID 34189)
-- Name: polymorphic_auth_user_user_permissions_e8701ad4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX polymorphic_auth_user_user_permissions_e8701ad4 ON polymorphic_auth_user_user_permissions USING btree (user_id);


--
-- TOC entry 3205 (class 1259 OID 34190)
-- Name: post_office_attachment_emails_07ba63f5; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_attachment_emails_07ba63f5 ON post_office_attachment_emails USING btree (attachment_id);


--
-- TOC entry 3208 (class 1259 OID 34191)
-- Name: post_office_attachment_emails_fdfd0ebf; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_attachment_emails_fdfd0ebf ON post_office_attachment_emails USING btree (email_id);


--
-- TOC entry 3211 (class 1259 OID 34192)
-- Name: post_office_email_3acc0b7a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_email_3acc0b7a ON post_office_email USING btree (last_updated);


--
-- TOC entry 3212 (class 1259 OID 34193)
-- Name: post_office_email_74f53564; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_email_74f53564 ON post_office_email USING btree (template_id);


--
-- TOC entry 3213 (class 1259 OID 34194)
-- Name: post_office_email_9acb4454; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_email_9acb4454 ON post_office_email USING btree (status);


--
-- TOC entry 3214 (class 1259 OID 34195)
-- Name: post_office_email_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_email_e2fa5388 ON post_office_email USING btree (created);


--
-- TOC entry 3215 (class 1259 OID 34196)
-- Name: post_office_email_ed24d584; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_email_ed24d584 ON post_office_email USING btree (scheduled_time);


--
-- TOC entry 3218 (class 1259 OID 34197)
-- Name: post_office_emailtemplate_dea6f63e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_emailtemplate_dea6f63e ON post_office_emailtemplate USING btree (default_template_id);


--
-- TOC entry 3223 (class 1259 OID 34198)
-- Name: post_office_log_fdfd0ebf; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_office_log_fdfd0ebf ON post_office_log USING btree (email_id);


--
-- TOC entry 3228 (class 1259 OID 34199)
-- Name: redirectnode_redirectnode_t_language_code_394c98b0b10c8f3e_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX redirectnode_redirectnode_t_language_code_394c98b0b10c8f3e_like ON redirectnode_redirectnode_translation USING btree (language_code varchar_pattern_ops);


--
-- TOC entry 3229 (class 1259 OID 34200)
-- Name: redirectnode_redirectnode_translation_60716c2f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX redirectnode_redirectnode_translation_60716c2f ON redirectnode_redirectnode_translation USING btree (language_code);


--
-- TOC entry 3230 (class 1259 OID 34201)
-- Name: redirectnode_redirectnode_translation_90349b61; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX redirectnode_redirectnode_translation_90349b61 ON redirectnode_redirectnode_translation USING btree (master_id);


--
-- TOC entry 3235 (class 1259 OID 34202)
-- Name: response_pages_responsepage_type_43a5ea09d4b56be3_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX response_pages_responsepage_type_43a5ea09d4b56be3_like ON response_pages_responsepage USING btree (type varchar_pattern_ops);


--
-- TOC entry 3238 (class 1259 OID 34203)
-- Name: reversion_revision_b16b0f06; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reversion_revision_b16b0f06 ON reversion_revision USING btree (manager_slug);


--
-- TOC entry 3239 (class 1259 OID 34204)
-- Name: reversion_revision_c69e55a4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reversion_revision_c69e55a4 ON reversion_revision USING btree (date_created);


--
-- TOC entry 3240 (class 1259 OID 34205)
-- Name: reversion_revision_e8701ad4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reversion_revision_e8701ad4 ON reversion_revision USING btree (user_id);


--
-- TOC entry 3241 (class 1259 OID 34206)
-- Name: reversion_revision_manager_slug_31853293d56615f1_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reversion_revision_manager_slug_31853293d56615f1_like ON reversion_revision USING btree (manager_slug varchar_pattern_ops);


--
-- TOC entry 3244 (class 1259 OID 34207)
-- Name: reversion_version_0c9ba3a3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reversion_version_0c9ba3a3 ON reversion_version USING btree (object_id_int);


--
-- TOC entry 3245 (class 1259 OID 34208)
-- Name: reversion_version_417f1b1c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reversion_version_417f1b1c ON reversion_version USING btree (content_type_id);


--
-- TOC entry 3246 (class 1259 OID 34209)
-- Name: reversion_version_5de09a8d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reversion_version_5de09a8d ON reversion_version USING btree (revision_id);


--
-- TOC entry 3249 (class 1259 OID 34210)
-- Name: sharedcontent_sharedcontent_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sharedcontent_sharedcontent_2dbcba41 ON sharedcontent_sharedcontent USING btree (slug);


--
-- TOC entry 3250 (class 1259 OID 34211)
-- Name: sharedcontent_sharedcontent_4e147804; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sharedcontent_sharedcontent_4e147804 ON sharedcontent_sharedcontent USING btree (parent_site_id);


--
-- TOC entry 3256 (class 1259 OID 34212)
-- Name: sharedcontent_sharedcontent_language_code_32da6829004639c2_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sharedcontent_sharedcontent_language_code_32da6829004639c2_like ON sharedcontent_sharedcontent_translation USING btree (language_code varchar_pattern_ops);


--
-- TOC entry 3255 (class 1259 OID 34213)
-- Name: sharedcontent_sharedcontent_slug_86123b34419fbb2_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sharedcontent_sharedcontent_slug_86123b34419fbb2_like ON sharedcontent_sharedcontent USING btree (slug varchar_pattern_ops);


--
-- TOC entry 3259 (class 1259 OID 34214)
-- Name: sharedcontent_sharedcontent_translation_60716c2f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sharedcontent_sharedcontent_translation_60716c2f ON sharedcontent_sharedcontent_translation USING btree (language_code);


--
-- TOC entry 3260 (class 1259 OID 34215)
-- Name: sharedcontent_sharedcontent_translation_90349b61; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sharedcontent_sharedcontent_translation_90349b61 ON sharedcontent_sharedcontent_translation USING btree (master_id);


--
-- TOC entry 3263 (class 1259 OID 34216)
-- Name: test_article_2dbcba41; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_article_2dbcba41 ON test_article USING btree (slug);


--
-- TOC entry 3264 (class 1259 OID 36406)
-- Name: test_article_6be37982; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_article_6be37982 ON test_article USING btree (parent_id);


--
-- TOC entry 3265 (class 1259 OID 34217)
-- Name: test_article_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_article_72bc1be0 ON test_article USING btree (layout_id);


--
-- TOC entry 3266 (class 1259 OID 34218)
-- Name: test_article_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_article_b667876a ON test_article USING btree (publishing_is_draft);


--
-- TOC entry 3271 (class 1259 OID 34220)
-- Name: test_article_slug_39fed44f815cfbfd_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_article_slug_39fed44f815cfbfd_like ON test_article USING btree (slug varchar_pattern_ops);


--
-- TOC entry 3486 (class 1259 OID 36539)
-- Name: test_articlelisting_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_articlelisting_441a5015 ON test_articlelisting USING btree (hero_image_id);


--
-- TOC entry 3487 (class 1259 OID 36405)
-- Name: test_articlelisting_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_articlelisting_72bc1be0 ON test_articlelisting USING btree (layout_id);


--
-- TOC entry 3488 (class 1259 OID 36404)
-- Name: test_articlelisting_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_articlelisting_b667876a ON test_articlelisting USING btree (publishing_is_draft);


--
-- TOC entry 3272 (class 1259 OID 36545)
-- Name: test_layoutpage_with_related_441a5015; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_layoutpage_with_related_441a5015 ON test_layoutpage_with_related USING btree (hero_image_id);


--
-- TOC entry 3273 (class 1259 OID 34221)
-- Name: test_layoutpage_with_related_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_layoutpage_with_related_72bc1be0 ON test_layoutpage_with_related USING btree (layout_id);


--
-- TOC entry 3274 (class 1259 OID 34222)
-- Name: test_layoutpage_with_related_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_layoutpage_with_related_b667876a ON test_layoutpage_with_related USING btree (publishing_is_draft);


--
-- TOC entry 3281 (class 1259 OID 34223)
-- Name: test_layoutpage_with_related_related_pages_1a63c800; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_layoutpage_with_related_related_pages_1a63c800 ON test_layoutpage_with_related_related_pages USING btree (page_id);


--
-- TOC entry 3282 (class 1259 OID 34224)
-- Name: test_layoutpage_with_related_related_pages_9ee295f2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX test_layoutpage_with_related_related_pages_9ee295f2 ON test_layoutpage_with_related_related_pages USING btree (layoutpagewithrelatedpages_id);


--
-- TOC entry 3285 (class 1259 OID 34225)
-- Name: tests_barwithlayout_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_barwithlayout_72bc1be0 ON tests_barwithlayout USING btree (layout_id);


--
-- TOC entry 3288 (class 1259 OID 34226)
-- Name: tests_basemodel_9ae73c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_basemodel_9ae73c65 ON tests_basemodel USING btree (modified);


--
-- TOC entry 3289 (class 1259 OID 34227)
-- Name: tests_basemodel_e2fa5388; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_basemodel_e2fa5388 ON tests_basemodel USING btree (created);


--
-- TOC entry 3292 (class 1259 OID 34228)
-- Name: tests_bazwithlayout_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_bazwithlayout_72bc1be0 ON tests_bazwithlayout USING btree (layout_id);


--
-- TOC entry 3295 (class 1259 OID 34229)
-- Name: tests_foowithlayout_72bc1be0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_foowithlayout_72bc1be0 ON tests_foowithlayout USING btree (layout_id);


--
-- TOC entry 3493 (class 1259 OID 36455)
-- Name: tests_publishingm2mmodela_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_publishingm2mmodela_b667876a ON tests_publishingm2mmodela USING btree (publishing_is_draft);


--
-- TOC entry 3498 (class 1259 OID 36461)
-- Name: tests_publishingm2mmodelb_b667876a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_publishingm2mmodelb_b667876a ON tests_publishingm2mmodelb USING btree (publishing_is_draft);


--
-- TOC entry 3505 (class 1259 OID 36473)
-- Name: tests_publishingm2mmodelb_related_a_models_7c583a2c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_publishingm2mmodelb_related_a_models_7c583a2c ON tests_publishingm2mmodelb_related_a_models USING btree (publishingm2mmodela_id);


--
-- TOC entry 3506 (class 1259 OID 36472)
-- Name: tests_publishingm2mmodelb_related_a_models_b6e38a3a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_publishingm2mmodelb_related_a_models_b6e38a3a ON tests_publishingm2mmodelb_related_a_models USING btree (publishingm2mmodelb_id);


--
-- TOC entry 3509 (class 1259 OID 36484)
-- Name: tests_publishingm2mthroughtable_0b893a6c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_publishingm2mthroughtable_0b893a6c ON tests_publishingm2mthroughtable USING btree (a_model_id);


--
-- TOC entry 3510 (class 1259 OID 36485)
-- Name: tests_publishingm2mthroughtable_684652a4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tests_publishingm2mthroughtable_684652a4 ON tests_publishingm2mthroughtable USING btree (b_model_id);


--
-- TOC entry 3453 (class 1259 OID 36043)
-- Name: workflow_workflowstate_02c1725c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workflow_workflowstate_02c1725c ON icekit_workflow_workflowstate USING btree (assigned_to_id);


--
-- TOC entry 3454 (class 1259 OID 36044)
-- Name: workflow_workflowstate_417f1b1c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workflow_workflowstate_417f1b1c ON icekit_workflow_workflowstate USING btree (content_type_id);


--
-- TOC entry 3540 (class 2606 OID 34230)
-- Name: D018639bcbbe5ac37a95b2f63304e705; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_sharedcontent_sharedcontentitem
    ADD CONSTRAINT "D018639bcbbe5ac37a95b2f63304e705" FOREIGN KEY (shared_content_id) REFERENCES sharedcontent_sharedcontent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3555 (class 2606 OID 34235)
-- Name: D040858edb471de82f3e4ed4a952fe86; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem
    ADD CONSTRAINT "D040858edb471de82f3e4ed4a952fe86" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3539 (class 2606 OID 34240)
-- Name: D0452bb432ea90d95f4ed2a184dbcfd8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_sharedcontent_sharedcontentitem
    ADD CONSTRAINT "D0452bb432ea90d95f4ed2a184dbcfd8" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3681 (class 2606 OID 35947)
-- Name: D0b409d95786302e70f4c7442a035ea6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT "D0b409d95786302e70f4c7442a035ea6" FOREIGN KEY (publishing_linked_id) REFERENCES pagetype_icekit_press_releases_pressreleaselisting(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3589 (class 2606 OID 34245)
-- Name: D0de842418cd0e6f2f64ca5053dcd864; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers
    ADD CONSTRAINT "D0de842418cd0e6f2f64ca5053dcd864" FOREIGN KEY (followerinformation_id) REFERENCES notifications_followerinformation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3679 (class 2606 OID 35905)
-- Name: D0df44713e1f214c1306a26c4af52e96; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease
    ADD CONSTRAINT "D0df44713e1f214c1306a26c4af52e96" FOREIGN KEY (category_id) REFERENCES icekit_press_releases_pressreleasecategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3674 (class 2606 OID 35773)
-- Name: D10ae2b7a59be313e875f78e19f2bfab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_contact_person_contactpersonitem
    ADD CONSTRAINT "D10ae2b7a59be313e875f78e19f2bfab" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3698 (class 2606 OID 36189)
-- Name: D1530924ac4d416f26e44c1eda57da74; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_pagelink
    ADD CONSTRAINT "D1530924ac4d416f26e44c1eda57da74" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3625 (class 2606 OID 36589)
-- Name: D1baf428761c54e7de21b421efdece90; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT "D1baf428761c54e7de21b421efdece90" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3655 (class 2606 OID 35384)
-- Name: D1c666d5a69734600fa0282a9a232332; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT "D1c666d5a69734600fa0282a9a232332" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3529 (class 2606 OID 34250)
-- Name: D1e4036bb2c4aed61973198321822e62; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_quote_quoteitem
    ADD CONSTRAINT "D1e4036bb2c4aed61973198321822e62" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3646 (class 2606 OID 35105)
-- Name: D21c67b8ac1feddb565502c170671137; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT "D21c67b8ac1feddb565502c170671137" FOREIGN KEY (parent_id) REFERENCES icekit_articlecategorypage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3692 (class 2606 OID 36121)
-- Name: D287983bc1e079652cdaee88cdd7ba48; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types
    ADD CONSTRAINT "D287983bc1e079652cdaee88cdd7ba48" FOREIGN KEY (todaysoccurrences_id) REFERENCES contentitem_ik_events_todays_occurrences_todaysoccurrences(contentitem_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3696 (class 2606 OID 36178)
-- Name: D2b6f6b92fe88df1c48d72707cb3315c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_authorlink
    ADD CONSTRAINT "D2b6f6b92fe88df1c48d72707cb3315c" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3616 (class 2606 OID 34255)
-- Name: D2d6ebedd88b18fbf08839d8e92bdbc5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirectnode_redirectnode_translation
    ADD CONSTRAINT "D2d6ebedd88b18fbf08839d8e92bdbc5" FOREIGN KEY (master_id) REFERENCES pagetype_redirectnode_redirectnode(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3701 (class 2606 OID 36584)
-- Name: D2e684a954377fb0b66c3e46297549e0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT "D2e684a954377fb0b66c3e46297549e0" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3702 (class 2606 OID 36399)
-- Name: D2eebed14c6077e5af89d6809400c826; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT "D2eebed14c6077e5af89d6809400c826" FOREIGN KEY (publishing_linked_id) REFERENCES test_articlelisting(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3554 (class 2606 OID 34260)
-- Name: D31711321a04cbbfec2557350bd9ea29; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem
    ADD CONSTRAINT "D31711321a04cbbfec2557350bd9ea29" FOREIGN KEY (placeholder_id) REFERENCES fluent_contents_placeholder(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3673 (class 2606 OID 35778)
-- Name: D320b84e71c52f8999f518c8cc89a22b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_contact_person_contactpersonitem
    ADD CONSTRAINT "D320b84e71c52f8999f518c8cc89a22b" FOREIGN KEY (contact_id) REFERENCES icekit_plugins_contact_person_contactperson(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3561 (class 2606 OID 34265)
-- Name: D33d570786aa43fec559f3a5128bf63e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT "D33d570786aa43fec559f3a5128bf63e" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3536 (class 2606 OID 34270)
-- Name: D3548c226dff84b0f0dd0520b48dd517; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_oembeditem_oembeditem
    ADD CONSTRAINT "D3548c226dff84b0f0dd0520b48dd517" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3517 (class 2606 OID 34275)
-- Name: D38d5deba3b3a46916ab8b7d678e9bf4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_faq_faqitem
    ADD CONSTRAINT "D38d5deba3b3a46916ab8b7d678e9bf4" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3707 (class 2606 OID 36467)
-- Name: D3cbc8dba015c422912f598d5f3a757f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models
    ADD CONSTRAINT "D3cbc8dba015c422912f598d5f3a757f" FOREIGN KEY (publishingm2mmodela_id) REFERENCES tests_publishingm2mmodela(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3572 (class 2606 OID 34280)
-- Name: D3e5fbca27367ab9e6c9331713fe4c65; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_slideshow_slideshow
    ADD CONSTRAINT "D3e5fbca27367ab9e6c9331713fe4c65" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_plugins_slideshow_slideshow(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3523 (class 2606 OID 34285)
-- Name: D3eb010e1f707242b7150ad007036eb9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_instagram_embed_instagramembeditem
    ADD CONSTRAINT "D3eb010e1f707242b7150ad007036eb9" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3606 (class 2606 OID 34290)
-- Name: D43affcece35102795aa3ffeb5059ad0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user
    ADD CONSTRAINT "D43affcece35102795aa3ffeb5059ad0" FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3699 (class 2606 OID 36270)
-- Name: D45b0955e327064a7dd5b54ea15efbb8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_image_gallery_imagegalleryshowitem
    ADD CONSTRAINT "D45b0955e327064a7dd5b54ea15efbb8" FOREIGN KEY (slide_show_id) REFERENCES icekit_plugins_slideshow_slideshow(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3690 (class 2606 OID 36116)
-- Name: D484cb7125fc9f35f9d4a117d1616d9f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_events_todays_occurrences_todaysoccurrences
    ADD CONSTRAINT "D484cb7125fc9f35f9d4a117d1616d9f" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3528 (class 2606 OID 34295)
-- Name: D4aeb7155f0377917add937e6f78b4d8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_page_anchor_pageanchoritem
    ADD CONSTRAINT "D4aeb7155f0377917add937e6f78b4d8" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3642 (class 2606 OID 35000)
-- Name: D526b130bd19ad3bf879f487b2dde53f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_endsponsorblockitem
    ADD CONSTRAINT "D526b130bd19ad3bf879f487b2dde53f" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3525 (class 2606 OID 34300)
-- Name: D52a8dee591a238cb5c355be76816747; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_map_with_text_mapwithtextitem
    ADD CONSTRAINT "D52a8dee591a238cb5c355be76816747" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3596 (class 2606 OID 36306)
-- Name: D58b1c3f31eecf1be86511433f6e2a59; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT "D58b1c3f31eecf1be86511433f6e2a59" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3672 (class 2606 OID 35746)
-- Name: D5af7e4bf1d5349f2fdbacaaa96d5e91; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_events_links_eventlink
    ADD CONSTRAINT "D5af7e4bf1d5349f2fdbacaaa96d5e91" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3522 (class 2606 OID 34305)
-- Name: D5ec9b05aa7c16fd0e84be34b47dd545; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_image_imageitem
    ADD CONSTRAINT "D5ec9b05aa7c16fd0e84be34b47dd545" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3533 (class 2606 OID 34310)
-- Name: D607c793dc9b0d3596510c2db4fa66f3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_slideshow_slideshowitem
    ADD CONSTRAINT "D607c793dc9b0d3596510c2db4fa66f3" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3537 (class 2606 OID 34315)
-- Name: D60bd4354b0b16dc0114d19765562b76; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_picture_pictureitem
    ADD CONSTRAINT "D60bd4354b0b16dc0114d19765562b76" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3587 (class 2606 OID 34320)
-- Name: D65377761311ee175aecee4290ceb09b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers
    ADD CONSTRAINT "D65377761311ee175aecee4290ceb09b" FOREIGN KEY (followerinformation_id) REFERENCES notifications_followerinformation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3662 (class 2606 OID 35456)
-- Name: D686830d19f7550ebfe38f616b6b3e21; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT "D686830d19f7550ebfe38f616b6b3e21" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3650 (class 2606 OID 35057)
-- Name: D6c98b01a5f9a0ef1d02ddfa510ce6e8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT "D6c98b01a5f9a0ef1d02ddfa510ce6e8" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_articlecategorypage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3668 (class 2606 OID 35506)
-- Name: D6ff16717b0b80b715b38864db1835b8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_event_types_simple_simpleevent
    ADD CONSTRAINT "D6ff16717b0b80b715b38864db1835b8" FOREIGN KEY (eventbase_ptr_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3641 (class 2606 OID 34995)
-- Name: D726ce4112cfa5023e35dd7090113db7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_beginsponsorblockitem
    ADD CONSTRAINT "D726ce4112cfa5023e35dd7090113db7" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3680 (class 2606 OID 36019)
-- Name: D84479db2b69e45b5b08fd37970cf08e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT "D84479db2b69e45b5b08fd37970cf08e" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3665 (class 2606 OID 35655)
-- Name: D866a4bd96713bd836d9ec491de03e16; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_occurrence
    ADD CONSTRAINT "D866a4bd96713bd836d9ec491de03e16" FOREIGN KEY (generator_id) REFERENCES icekit_events_eventrepeatsgenerator(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3645 (class 2606 OID 35147)
-- Name: D8da1738816744d3b4f60acea6108e1e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT "D8da1738816744d3b4f60acea6108e1e" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3705 (class 2606 OID 36450)
-- Name: D9004817aaf839e52098ef681e6d3e80; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodela
    ADD CONSTRAINT "D9004817aaf839e52098ef681e6d3e80" FOREIGN KEY (publishing_linked_id) REFERENCES tests_publishingm2mmodela(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3649 (class 2606 OID 35152)
-- Name: D9035a474132fab202f77c53f6dd12db; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT "D9035a474132fab202f77c53f6dd12db" FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3534 (class 2606 OID 34330)
-- Name: D922f3a15578c986f6f839b409123e62; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_twitter_embed_twitterembeditem
    ADD CONSTRAINT "D922f3a15578c986f6f839b409123e62" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3654 (class 2606 OID 35283)
-- Name: D9859a71fd51832d68b9cea5b38ac8e3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author
    ADD CONSTRAINT "D9859a71fd51832d68b9cea5b38ac8e3" FOREIGN KEY (publishing_linked_id) REFERENCES icekit_authors_author(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3614 (class 2606 OID 36326)
-- Name: D9a2b85425f36606589cd65efc7499e5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_emailtemplate
    ADD CONSTRAINT "D9a2b85425f36606589cd65efc7499e5" FOREIGN KEY (default_template_id) REFERENCES post_office_emailtemplate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3687 (class 2606 OID 36068)
-- Name: D9b490326ec73150f0237258be7107e9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_event_listing_eventcontentlistingitem
    ADD CONSTRAINT "D9b490326ec73150f0237258be7107e9" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3527 (class 2606 OID 34335)
-- Name: D9b57bd5f5f76a7df1caa9a860ba2bae; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_page_anchor_list_pageanchorlistitem
    ADD CONSTRAINT "D9b57bd5f5f76a7df1caa9a860ba2bae" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3628 (class 2606 OID 34340)
-- Name: D9c13bbb5df3b19d652b3d5bb3bacb07; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT "D9c13bbb5df3b19d652b3d5bb3bacb07" FOREIGN KEY (publishing_linked_id) REFERENCES test_layoutpage_with_related(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3526 (class 2606 OID 34345)
-- Name: D9c73d30eb4082527fc21de8e4205fca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_oembed_with_caption_item
    ADD CONSTRAINT "D9c73d30eb4082527fc21de8e4205fca" FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3520 (class 2606 OID 34350)
-- Name: a328248fc36bbf1cacf5c428f8b958a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_horizontal_rule_horizontalruleitem
    ADD CONSTRAINT a328248fc36bbf1cacf5c428f8b958a6 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3663 (class 2606 OID 35451)
-- Name: a5c70817b5e2338f19c4d6224d2bf86e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT a5c70817b5e2338f19c4d6224d2bf86e FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3524 (class 2606 OID 34355)
-- Name: a82c21c6a3457d59b10ae198d83a269e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_map_mapitem
    ADD CONSTRAINT a82c21c6a3457d59b10ae198d83a269e FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3689 (class 2606 OID 36089)
-- Name: a890399058b56d50bf1828f4e6188f74; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types
    ADD CONSTRAINT a890399058b56d50bf1828f4e6188f74 FOREIGN KEY (eventcontentlistingitem_id) REFERENCES contentitem_ik_event_listing_eventcontentlistingitem(contentitem_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3644 (class 2606 OID 35005)
-- Name: aa1399321b7164a744c58279773341c9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_sponsorpromoitem
    ADD CONSTRAINT aa1399321b7164a744c58279773341c9 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3602 (class 2606 OID 34360)
-- Name: aaee880b213107a10bc41af1dab274f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_searchpage
    ADD CONSTRAINT aaee880b213107a10bc41af1dab274f7 FOREIGN KEY (publishing_linked_id) REFERENCES icekit_searchpage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3515 (class 2606 OID 34365)
-- Name: auth_content_type_id_5b4e0785859126c3_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_content_type_id_5b4e0785859126c3_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3514 (class 2606 OID 34370)
-- Name: auth_group_permissio_group_id_14d0e46d62b5792d_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_group_id_14d0e46d62b5792d_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3513 (class 2606 OID 34375)
-- Name: auth_group_permission_id_639e33f36dba7a1c_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permission_id_639e33f36dba7a1c_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3634 (class 2606 OID 34834)
-- Name: authtoken__user_id_1d323719fd2a9bcd_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY authtoken_token
    ADD CONSTRAINT authtoken__user_id_1d323719fd2a9bcd_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3538 (class 2606 OID 34380)
-- Name: b6cafcad26e73dca1039a712a6162119; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_rawhtml_rawhtmlitem
    ADD CONSTRAINT b6cafcad26e73dca1039a712a6162119 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3676 (class 2606 OID 35789)
-- Name: b781281df5972780ea9587ae246aec2b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_content_listing_contentlistingitem
    ADD CONSTRAINT b781281df5972780ea9587ae246aec2b FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3647 (class 2606 OID 35070)
-- Name: bcfb87f31f7d20826b7e6791aed4df58; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT bcfb87f31f7d20826b7e6791aed4df58 FOREIGN KEY (publishing_linked_id) REFERENCES icekit_article_article(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3532 (class 2606 OID 35827)
-- Name: bd17c2062689f9016affbb22760c9373; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_slideshow_slideshowitem
    ADD CONSTRAINT bd17c2062689f9016affbb22760c9373 FOREIGN KEY (slide_show_id) REFERENCES icekit_plugins_slideshow_slideshow(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3653 (class 2606 OID 35394)
-- Name: c0ba614437ec8302f282ef70cb5cf885; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authors_author
    ADD CONSTRAINT c0ba614437ec8302f282ef70cb5cf885 FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3541 (class 2606 OID 34385)
-- Name: c145930329b66e36578c5b44b2787373; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_text_textitem
    ADD CONSTRAINT c145930329b66e36578c5b44b2787373 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3531 (class 2606 OID 34390)
-- Name: c41f6486ecde97bed66b8577b3346418; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_reusable_form_formitem
    ADD CONSTRAINT c41f6486ecde97bed66b8577b3346418 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3630 (class 2606 OID 34395)
-- Name: c79af9d7583e55b74f3b5727bb1cffe5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages
    ADD CONSTRAINT c79af9d7583e55b74f3b5727bb1cffe5 FOREIGN KEY (layoutpagewithrelatedpages_id) REFERENCES test_layoutpage_with_related(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3694 (class 2606 OID 36167)
-- Name: c997d49fa650ef3a017aa20fc3eead5f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_articlelink
    ADD CONSTRAINT c997d49fa650ef3a017aa20fc3eead5f FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3686 (class 2606 OID 36073)
-- Name: cont_content_type_id_1f9333513e578144_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_event_listing_eventcontentlistingitem
    ADD CONSTRAINT cont_content_type_id_1f9333513e578144_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3675 (class 2606 OID 35794)
-- Name: cont_content_type_id_4e7753395a8604b6_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_content_listing_contentlistingitem
    ADD CONSTRAINT cont_content_type_id_4e7753395a8604b6_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3643 (class 2606 OID 35010)
-- Name: cont_sponsor_id_56100c08c47a0731_fk_glamkit_sponsors_sponsor_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_glamkit_sponsors_sponsorpromoitem
    ADD CONSTRAINT cont_sponsor_id_56100c08c47a0731_fk_glamkit_sponsors_sponsor_id FOREIGN KEY (sponsor_id) REFERENCES glamkit_sponsors_sponsor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3671 (class 2606 OID 35751)
-- Name: contentit_item_id_2dc7fcb19ede325_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_events_links_eventlink
    ADD CONSTRAINT contentit_item_id_2dc7fcb19ede325_fk_icekit_events_eventbase_id FOREIGN KEY (item_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3693 (class 2606 OID 36172)
-- Name: contentit_item_id_5de2eb4049c6f2cd_fk_icekit_article_article_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_articlelink
    ADD CONSTRAINT contentit_item_id_5de2eb4049c6f2cd_fk_icekit_article_article_id FOREIGN KEY (item_id) REFERENCES icekit_article_article(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3695 (class 2606 OID 36183)
-- Name: contentite_item_id_1189b988914701c9_fk_icekit_authors_author_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_authorlink
    ADD CONSTRAINT contentite_item_id_1189b988914701c9_fk_icekit_authors_author_id FOREIGN KEY (item_id) REFERENCES icekit_authors_author(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3697 (class 2606 OID 36194)
-- Name: contentitem__item_id_2b92363944c4085_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_ik_links_pagelink
    ADD CONSTRAINT contentitem__item_id_2b92363944c4085_fk_fluent_pages_urlnode_id FOREIGN KEY (item_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3519 (class 2606 OID 34400)
-- Name: contentitem_file_filei_file_id_21bb8cfc95fdfcf6_fk_file_file_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_file_fileitem
    ADD CONSTRAINT contentitem_file_filei_file_id_21bb8cfc95fdfcf6_fk_file_file_id FOREIGN KEY (file_id) REFERENCES icekit_plugins_file_file(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3521 (class 2606 OID 34405)
-- Name: contentitem_image_i_image_id_7f3476f8c6aa5c0c_fk_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_image_imageitem
    ADD CONSTRAINT contentitem_image_i_image_id_7f3476f8c6aa5c0c_fk_image_image_id FOREIGN KEY (image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3530 (class 2606 OID 34410)
-- Name: contentitem_reusable_f_form_id_f9b546726c2779f_fk_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_reusable_form_formitem
    ADD CONSTRAINT contentitem_reusable_f_form_id_f9b546726c2779f_fk_forms_form_id FOREIGN KEY (form_id) REFERENCES forms_form(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3706 (class 2606 OID 36456)
-- Name: d0f2a71629bc3b314c3549fbad05d79e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb
    ADD CONSTRAINT d0f2a71629bc3b314c3549fbad05d79e FOREIGN KEY (publishing_linked_id) REFERENCES tests_publishingm2mmodelb(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3516 (class 2606 OID 34415)
-- Name: d3eb21789e405b8e81e4e73b8b635668; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_child_pages_childpageitem
    ADD CONSTRAINT d3eb21789e405b8e81e4e73b8b635668 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3635 (class 2606 OID 34922)
-- Name: d52db5082f48be9d14d90c5edcfbe3aa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT d52db5082f48be9d14d90c5edcfbe3aa FOREIGN KEY (hero_image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3661 (class 2606 OID 35640)
-- Name: derived_from_id_1024cfc24261bd74_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT derived_from_id_1024cfc24261bd74_fk_icekit_events_eventbase_id FOREIGN KEY (derived_from_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3636 (class 2606 OID 34884)
-- Name: df2d4975bd54b1449c49d07308978441; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT df2d4975bd54b1449c49d07308978441 FOREIGN KEY (publishing_linked_id) REFERENCES pagetype_eventlistingfordate_eventlistingpage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3546 (class 2606 OID 34425)
-- Name: dj_interval_id_4b651f563593f839_fk_djcelery_intervalschedule_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT dj_interval_id_4b651f563593f839_fk_djcelery_intervalschedule_id FOREIGN KEY (interval_id) REFERENCES djcelery_intervalschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3543 (class 2606 OID 34430)
-- Name: djan_content_type_id_2f8bf1415c03c17a_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT djan_content_type_id_2f8bf1415c03c17a_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3542 (class 2606 OID 34435)
-- Name: django_adm_user_id_12e29ea88bcc1677_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_adm_user_id_12e29ea88bcc1677_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3544 (class 2606 OID 34440)
-- Name: django_redirect_site_id_2645347c0a0cd6aa_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_redirect
    ADD CONSTRAINT django_redirect_site_id_2645347c0a0cd6aa_fk_django_site_id FOREIGN KEY (site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3545 (class 2606 OID 34445)
-- Name: djce_crontab_id_792b9675c055bfb6_fk_djcelery_crontabschedule_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_periodictask
    ADD CONSTRAINT djce_crontab_id_792b9675c055bfb6_fk_djcelery_crontabschedule_id FOREIGN KEY (crontab_id) REFERENCES djcelery_crontabschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3547 (class 2606 OID 34450)
-- Name: djcelery__worker_id_65f2e840c8f1a3bf_fk_djcelery_workerstate_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djcelery_taskstate
    ADD CONSTRAINT djcelery__worker_id_65f2e840c8f1a3bf_fk_djcelery_workerstate_id FOREIGN KEY (worker_id) REFERENCES djcelery_workerstate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3548 (class 2606 OID 34455)
-- Name: djkombu_message_queue_id_2e46bdf39a353e23_fk_djkombu_queue_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY djkombu_message
    ADD CONSTRAINT djkombu_message_queue_id_2e46bdf39a353e23_fk_djkombu_queue_id FOREIGN KEY (queue_id) REFERENCES djkombu_queue(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3622 (class 2606 OID 36579)
-- Name: e321d285513d55740aa582e4df547443; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT e321d285513d55740aa582e4df547443 FOREIGN KEY (parent_id) REFERENCES test_articlelisting(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3581 (class 2606 OID 34460)
-- Name: e37946bae0f9532cb076f3aadeee742c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_setting
    ADD CONSTRAINT e37946bae0f9532cb076f3aadeee742c FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3535 (class 2606 OID 34465)
-- Name: e47b7dda5c6ac104a62163cd899f4c6f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_iframe_iframeitem
    ADD CONSTRAINT e47b7dda5c6ac104a62163cd899f4c6f FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3550 (class 2606 OID 34470)
-- Name: e_thumbnail_id_2ed5e1ce3712f0d0_fk_easy_thumbnails_thumbnail_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnaildimensions
    ADD CONSTRAINT e_thumbnail_id_2ed5e1ce3712f0d0_fk_easy_thumbnails_thumbnail_id FOREIGN KEY (thumbnail_id) REFERENCES easy_thumbnails_thumbnail(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3549 (class 2606 OID 34475)
-- Name: easy_th_source_id_251253ee991fd6f9_fk_easy_thumbnails_source_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY easy_thumbnails_thumbnail
    ADD CONSTRAINT easy_th_source_id_251253ee991fd6f9_fk_easy_thumbnails_source_id FOREIGN KEY (source_id) REFERENCES easy_thumbnails_source(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3708 (class 2606 OID 36462)
-- Name: ec3451ef7cc530c64fc4c181af47cc46; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mmodelb_related_a_models
    ADD CONSTRAINT ec3451ef7cc530c64fc4c181af47cc46 FOREIGN KEY (publishingm2mmodelb_id) REFERENCES tests_publishingm2mmodelb(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3656 (class 2606 OID 35302)
-- Name: f1a702b7fd5e824892bc267afd5eaddf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT f1a702b7fd5e824892bc267afd5eaddf FOREIGN KEY (publishing_linked_id) REFERENCES icekit_authorlisting(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3677 (class 2606 OID 35916)
-- Name: f4460ab6e5167914cea94360711dab2e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease
    ADD CONSTRAINT f4460ab6e5167914cea94360711dab2e FOREIGN KEY (publishing_linked_id) REFERENCES icekit_press_releases_pressrelease(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3599 (class 2606 OID 34480)
-- Name: f8831a9a7f9bb31d8acedc5f2a399830; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT f8831a9a7f9bb31d8acedc5f2a399830 FOREIGN KEY (publishing_linked_id) REFERENCES icekit_layoutpage(urlnode_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3518 (class 2606 OID 34485)
-- Name: f95a96aa5a44470e57084c6421af2764; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_icekit_plugins_file_fileitem
    ADD CONSTRAINT f95a96aa5a44470e57084c6421af2764 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3700 (class 2606 OID 36259)
-- Name: fb13d8297a9f3d77752565a1e2001864; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contentitem_image_gallery_imagegalleryshowitem
    ADD CONSTRAINT fb13d8297a9f3d77752565a1e2001864 FOREIGN KEY (contentitem_ptr_id) REFERENCES fluent_contents_contentitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3552 (class 2606 OID 34490)
-- Name: fi_mediacategory_id_395a044ad9f3f27d_fk_icekit_mediacategory_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories
    ADD CONSTRAINT fi_mediacategory_id_395a044ad9f3f27d_fk_icekit_mediacategory_id FOREIGN KEY (mediacategory_id) REFERENCES icekit_mediacategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3551 (class 2606 OID 34495)
-- Name: file_file_categories_file_id_4ca185b763cdd9c6_fk_file_file_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_file_file_categories
    ADD CONSTRAINT file_file_categories_file_id_4ca185b763cdd9c6_fk_file_file_id FOREIGN KEY (file_id) REFERENCES icekit_plugins_file_file(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3553 (class 2606 OID 34500)
-- Name: fluen_parent_type_id_1c067c827df0ce69_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_contentitem
    ADD CONSTRAINT fluen_parent_type_id_1c067c827df0ce69_fk_django_content_type_id FOREIGN KEY (parent_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3560 (class 2606 OID 34505)
-- Name: fluent_p_author_id_169b2181518785a4_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_p_author_id_169b2181518785a4_fk_polymorphic_auth_user_id FOREIGN KEY (author_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3557 (class 2606 OID 34510)
-- Name: fluent_pa_master_id_187da72301c6c5b9_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_htmlpage_translation
    ADD CONSTRAINT fluent_pa_master_id_187da72301c6c5b9_fk_fluent_pages_urlnode_id FOREIGN KEY (master_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3562 (class 2606 OID 34515)
-- Name: fluent_pa_master_id_6054238105ab0cef_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode_translation
    ADD CONSTRAINT fluent_pa_master_id_6054238105ab0cef_fk_fluent_pages_urlnode_id FOREIGN KEY (master_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3559 (class 2606 OID 34520)
-- Name: fluent_pa_parent_id_5244471828a9b497_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_pa_parent_id_5244471828a9b497_fk_fluent_pages_urlnode_id FOREIGN KEY (parent_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3558 (class 2606 OID 34525)
-- Name: fluent_pages__parent_site_id_783d53d64d81ef90_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_pages_urlnode
    ADD CONSTRAINT fluent_pages__parent_site_id_783d53d64d81ef90_fk_django_site_id FOREIGN KEY (parent_site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3556 (class 2606 OID 34530)
-- Name: fluent_parent_type_id_97ca065586124ec_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluent_contents_placeholder
    ADD CONSTRAINT fluent_parent_type_id_97ca065586124ec_fk_django_content_type_id FOREIGN KEY (parent_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3563 (class 2606 OID 34535)
-- Name: forms_field_form_id_1ed97bdc2a7a841b_fk_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_field
    ADD CONSTRAINT forms_field_form_id_1ed97bdc2a7a841b_fk_forms_form_id FOREIGN KEY (form_id) REFERENCES forms_form(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3564 (class 2606 OID 34540)
-- Name: forms_fieldentr_entry_id_614215bbb3fef2e1_fk_forms_formentry_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_fieldentry
    ADD CONSTRAINT forms_fieldentr_entry_id_614215bbb3fef2e1_fk_forms_formentry_id FOREIGN KEY (entry_id) REFERENCES forms_formentry(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3566 (class 2606 OID 34545)
-- Name: forms_form_sites_form_id_332bacd0008a73ab_fk_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites
    ADD CONSTRAINT forms_form_sites_form_id_332bacd0008a73ab_fk_forms_form_id FOREIGN KEY (form_id) REFERENCES forms_form(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3565 (class 2606 OID 34550)
-- Name: forms_form_sites_site_id_135c995c1bce5ae4_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_form_sites
    ADD CONSTRAINT forms_form_sites_site_id_135c995c1bce5ae4_fk_django_site_id FOREIGN KEY (site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3567 (class 2606 OID 34555)
-- Name: forms_formentry_form_id_47d064a473e86f11_fk_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms_formentry
    ADD CONSTRAINT forms_formentry_form_id_47d064a473e86f11_fk_forms_form_id FOREIGN KEY (form_id) REFERENCES forms_form(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3639 (class 2606 OID 34951)
-- Name: g_country_id_2fb2ee02e4b5aac1_fk_glamkit_collections_country_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_collections_geographiclocation
    ADD CONSTRAINT g_country_id_2fb2ee02e4b5aac1_fk_glamkit_collections_country_id FOREIGN KEY (country_id) REFERENCES glamkit_collections_country(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3640 (class 2606 OID 34968)
-- Name: glamk_logo_id_2319e73ec975208d_fk_icekit_plugins_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY glamkit_sponsors_sponsor
    ADD CONSTRAINT glamk_logo_id_2319e73ec975208d_fk_icekit_plugins_image_image_id FOREIGN KEY (logo_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3669 (class 2606 OID 35733)
-- Name: ice_eventbase_id_4afef5afc865a117_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types
    ADD CONSTRAINT ice_eventbase_id_4afef5afc865a117_fk_icekit_events_eventbase_id FOREIGN KEY (eventbase_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3670 (class 2606 OID 35728)
-- Name: ice_eventtype_id_66c3176fb92c292e_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase_secondary_types
    ADD CONSTRAINT ice_eventtype_id_66c3176fb92c292e_fk_icekit_events_eventtype_id FOREIGN KEY (eventtype_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3684 (class 2606 OID 36051)
-- Name: icek_assigned_to_id_bf2dd677c06737a_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_workflow_workflowstate
    ADD CONSTRAINT icek_assigned_to_id_bf2dd677c06737a_fk_polymorphic_auth_user_id FOREIGN KEY (assigned_to_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3569 (class 2606 OID 34560)
-- Name: iceki_contenttype_id_790f687a9ef1accd_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types
    ADD CONSTRAINT iceki_contenttype_id_790f687a9ef1accd_fk_django_content_type_id FOREIGN KEY (contenttype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3660 (class 2606 OID 35645)
-- Name: iceki_part_of_id_62f84f608b3b0460_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT iceki_part_of_id_62f84f608b3b0460_fk_icekit_events_eventbase_id FOREIGN KEY (part_of_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3664 (class 2606 OID 35468)
-- Name: icekit__event_id_40a38b1af9446091_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventrepeatsgenerator
    ADD CONSTRAINT icekit__event_id_40a38b1af9446091_fk_icekit_events_eventbase_id FOREIGN KEY (event_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3666 (class 2606 OID 35479)
-- Name: icekit__event_id_5feab3b4c7e20a8c_fk_icekit_events_eventbase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_occurrence
    ADD CONSTRAINT icekit__event_id_5feab3b4c7e20a8c_fk_icekit_events_eventbase_id FOREIGN KEY (event_id) REFERENCES icekit_events_eventbase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3648 (class 2606 OID 35038)
-- Name: icekit_article_a_layout_id_458fb8f14a9591eb_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_article_article
    ADD CONSTRAINT icekit_article_a_layout_id_458fb8f14a9591eb_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3667 (class 2606 OID 35512)
-- Name: icekit_event_typ_layout_id_198c104d92b90bdb_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_event_types_simple_simpleevent
    ADD CONSTRAINT icekit_event_typ_layout_id_198c104d92b90bdb_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3568 (class 2606 OID 34565)
-- Name: icekit_layout_con_layout_id_50c427ff519c30f_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layout_content_types
    ADD CONSTRAINT icekit_layout_con_layout_id_50c427ff519c30f_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3678 (class 2606 OID 35911)
-- Name: icekit_press_rel_layout_id_391fd7550f072e19_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_press_releases_pressrelease
    ADD CONSTRAINT icekit_press_rel_layout_id_391fd7550f072e19_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3688 (class 2606 OID 36094)
-- Name: ik__eventtype_id_218f8e1fa664dea9_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_event_listing_types
    ADD CONSTRAINT ik__eventtype_id_218f8e1fa664dea9_fk_icekit_events_eventtype_id FOREIGN KEY (eventtype_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3691 (class 2606 OID 36126)
-- Name: ik__eventtype_id_64023c6b513b833c_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ik_todays_occurrences_types
    ADD CONSTRAINT ik__eventtype_id_64023c6b513b833c_fk_icekit_events_eventtype_id FOREIGN KEY (eventtype_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3571 (class 2606 OID 34570)
-- Name: im_mediacategory_id_1094e6583211d183_fk_icekit_mediacategory_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories
    ADD CONSTRAINT im_mediacategory_id_1094e6583211d183_fk_icekit_mediacategory_id FOREIGN KEY (mediacategory_id) REFERENCES icekit_mediacategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3570 (class 2606 OID 34575)
-- Name: image_image_categor_image_id_32402209306ca4f8_fk_image_image_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_plugins_image_image_categories
    ADD CONSTRAINT image_image_categor_image_id_32402209306ca4f8_fk_image_image_id FOREIGN KEY (image_id) REFERENCES icekit_plugins_image_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3575 (class 2606 OID 34580)
-- Name: mo_setting_ptr_id_11570258951ae0de_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_datetime
    ADD CONSTRAINT mo_setting_ptr_id_11570258951ae0de_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3578 (class 2606 OID 34585)
-- Name: mo_setting_ptr_id_22444ee81d6a741a_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_float
    ADD CONSTRAINT mo_setting_ptr_id_22444ee81d6a741a_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3579 (class 2606 OID 34590)
-- Name: mo_setting_ptr_id_274bb46f0343256d_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_image
    ADD CONSTRAINT mo_setting_ptr_id_274bb46f0343256d_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3574 (class 2606 OID 34595)
-- Name: mo_setting_ptr_id_50be2feaab84b011_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_date
    ADD CONSTRAINT mo_setting_ptr_id_50be2feaab84b011_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3582 (class 2606 OID 34600)
-- Name: mo_setting_ptr_id_51cc776affb9132c_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_text
    ADD CONSTRAINT mo_setting_ptr_id_51cc776affb9132c_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3583 (class 2606 OID 34605)
-- Name: mo_setting_ptr_id_69355a5a79f14786_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_time
    ADD CONSTRAINT mo_setting_ptr_id_69355a5a79f14786_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3580 (class 2606 OID 34610)
-- Name: mo_setting_ptr_id_780b3070043a9774_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_integer
    ADD CONSTRAINT mo_setting_ptr_id_780b3070043a9774_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3576 (class 2606 OID 34615)
-- Name: mo_setting_ptr_id_7dd5585d51cacbf7_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_decimal
    ADD CONSTRAINT mo_setting_ptr_id_7dd5585d51cacbf7_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3577 (class 2606 OID 34620)
-- Name: mod_setting_ptr_id_ab23363e2a91543_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_file
    ADD CONSTRAINT mod_setting_ptr_id_ab23363e2a91543_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3573 (class 2606 OID 34625)
-- Name: mode_setting_ptr_id_1f798d9d47e426_fk_model_settings_setting_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_settings_boolean
    ADD CONSTRAINT mode_setting_ptr_id_1f798d9d47e426_fk_model_settings_setting_id FOREIGN KEY (setting_ptr_id) REFERENCES model_settings_setting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3591 (class 2606 OID 34630)
-- Name: no_message_id_5986ccfad55ea6f8_fk_notifications_notification_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_hasreadmessage
    ADD CONSTRAINT no_message_id_5986ccfad55ea6f8_fk_notifications_notification_id FOREIGN KEY (message_id) REFERENCES notifications_notification(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3585 (class 2606 OID 34635)
-- Name: noti_content_type_id_69bb476edb80a222_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation
    ADD CONSTRAINT noti_content_type_id_69bb476edb80a222_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3590 (class 2606 OID 34640)
-- Name: notificat_person_id_70143304aeb9a0f_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_hasreadmessage
    ADD CONSTRAINT notificat_person_id_70143304aeb9a0f_fk_polymorphic_auth_user_id FOREIGN KEY (person_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3593 (class 2606 OID 34645)
-- Name: notificati_user_id_2762188a9c46cdb2_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notificationsetting
    ADD CONSTRAINT notificati_user_id_2762188a9c46cdb2_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3592 (class 2606 OID 34650)
-- Name: notificati_user_id_52be9655b000bc11_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_notification
    ADD CONSTRAINT notificati_user_id_52be9655b000bc11_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3586 (class 2606 OID 34655)
-- Name: notificati_user_id_69214b37932a2679_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_followers
    ADD CONSTRAINT notificati_user_id_69214b37932a2679_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3588 (class 2606 OID 34660)
-- Name: notifications_followe_group_id_fbed9ca79c0ccd2_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation_group_followers
    ADD CONSTRAINT notifications_followe_group_id_fbed9ca79c0ccd2_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3604 (class 2606 OID 34665)
-- Name: page_urlnode_ptr_id_123b56e124fe2cf6_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_tests_unpublishablelayoutpage
    ADD CONSTRAINT page_urlnode_ptr_id_123b56e124fe2cf6_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3601 (class 2606 OID 34670)
-- Name: page_urlnode_ptr_id_37ead914bd0591d6_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_searchpage
    ADD CONSTRAINT page_urlnode_ptr_id_37ead914bd0591d6_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3638 (class 2606 OID 34874)
-- Name: page_urlnode_ptr_id_444a8859c4414d49_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT page_urlnode_ptr_id_444a8859c4414d49_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3652 (class 2606 OID 35047)
-- Name: page_urlnode_ptr_id_49670473c6f56308_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT page_urlnode_ptr_id_49670473c6f56308_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3600 (class 2606 OID 34675)
-- Name: page_urlnode_ptr_id_535bdb1756f695be_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_redirectnode_redirectnode
    ADD CONSTRAINT page_urlnode_ptr_id_535bdb1756f695be_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3683 (class 2606 OID 35937)
-- Name: page_urlnode_ptr_id_5552266fdfed6efa_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT page_urlnode_ptr_id_5552266fdfed6efa_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3598 (class 2606 OID 34680)
-- Name: page_urlnode_ptr_id_56feb2a66852b642_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT page_urlnode_ptr_id_56feb2a66852b642_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3658 (class 2606 OID 35292)
-- Name: page_urlnode_ptr_id_5fa37b523128c634_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT page_urlnode_ptr_id_5fa37b523128c634_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3595 (class 2606 OID 34685)
-- Name: page_urlnode_ptr_id_6951a4515babee6c_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_fluentpage_fluentpage
    ADD CONSTRAINT page_urlnode_ptr_id_6951a4515babee6c_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3594 (class 2606 OID 34690)
-- Name: pagety_layout_id_4e188a422c4839af_fk_fluent_pages_pagelayout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_fluentpage_fluentpage
    ADD CONSTRAINT pagety_layout_id_4e188a422c4839af_fk_fluent_pages_pagelayout_id FOREIGN KEY (layout_id) REFERENCES fluent_pages_pagelayout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3637 (class 2606 OID 34879)
-- Name: pagetype_eventli_layout_id_2686f6784b68631a_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_eventlistingfordate_eventlistingpage
    ADD CONSTRAINT pagetype_eventli_layout_id_2686f6784b68631a_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3682 (class 2606 OID 35942)
-- Name: pagetype_icekit__layout_id_73196017020b1f5d_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_icekit_press_releases_pressreleaselisting
    ADD CONSTRAINT pagetype_icekit__layout_id_73196017020b1f5d_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3651 (class 2606 OID 35052)
-- Name: pagetype_icekit_a_layout_id_3069747bd3ab2a5_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_articlecategorypage
    ADD CONSTRAINT pagetype_icekit_a_layout_id_3069747bd3ab2a5_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3657 (class 2606 OID 35297)
-- Name: pagetype_icekit_a_layout_id_e1f4da12f1c8969_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_authorlisting
    ADD CONSTRAINT pagetype_icekit_a_layout_id_e1f4da12f1c8969_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3597 (class 2606 OID 34695)
-- Name: pagetype_layout__layout_id_22f2339fcfa61839_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_layoutpage
    ADD CONSTRAINT pagetype_layout__layout_id_22f2339fcfa61839_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3603 (class 2606 OID 34700)
-- Name: pagetype_tests_u_layout_id_2893eebed44c24bf_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pagetype_tests_unpublishablelayoutpage
    ADD CONSTRAINT pagetype_tests_u_layout_id_2893eebed44c24bf_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3613 (class 2606 OID 36321)
-- Name: po_template_id_37ae7c44dba79145_fk_post_office_emailtemplate_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_email
    ADD CONSTRAINT po_template_id_37ae7c44dba79145_fk_post_office_emailtemplate_id FOREIGN KEY (template_id) REFERENCES post_office_emailtemplate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3605 (class 2606 OID 34710)
-- Name: polymo_user_ptr_id_46a16c20fe09fb10_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_email_emailuser
    ADD CONSTRAINT polymo_user_ptr_id_46a16c20fe09fb10_fk_polymorphic_auth_user_id FOREIGN KEY (user_ptr_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3610 (class 2606 OID 34715)
-- Name: polymorphi_permission_id_29ebd5f6814159d1_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions
    ADD CONSTRAINT polymorphi_permission_id_29ebd5f6814159d1_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3608 (class 2606 OID 34720)
-- Name: polymorphi_user_id_674f42344261c21d_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups
    ADD CONSTRAINT polymorphi_user_id_674f42344261c21d_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3609 (class 2606 OID 34725)
-- Name: polymorphi_user_id_7aae9a842628b6d1_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_user_permissions
    ADD CONSTRAINT polymorphi_user_id_7aae9a842628b6d1_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3607 (class 2606 OID 34730)
-- Name: polymorphic_auth_user_group_id_cb0eb647a711674_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polymorphic_auth_user_groups
    ADD CONSTRAINT polymorphic_auth_user_group_id_cb0eb647a711674_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3584 (class 2606 OID 34735)
-- Name: polymorphic_ctype_id_faaaa4f53570f2d_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications_followerinformation
    ADD CONSTRAINT polymorphic_ctype_id_faaaa4f53570f2d_fk_django_content_type_id FOREIGN KEY (polymorphic_ctype_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3611 (class 2606 OID 36316)
-- Name: pos_attachment_id_7a27d9c849c8217d_fk_post_office_attachment_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails
    ADD CONSTRAINT pos_attachment_id_7a27d9c849c8217d_fk_post_office_attachment_id FOREIGN KEY (attachment_id) REFERENCES post_office_attachment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3612 (class 2606 OID 36311)
-- Name: post_office_at_email_id_a00f8013d181cfd_fk_post_office_email_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_attachment_emails
    ADD CONSTRAINT post_office_at_email_id_a00f8013d181cfd_fk_post_office_email_id FOREIGN KEY (email_id) REFERENCES post_office_email(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3615 (class 2606 OID 36331)
-- Name: post_office_l_email_id_148db7a5e20e1072_fk_post_office_email_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_office_log
    ADD CONSTRAINT post_office_l_email_id_148db7a5e20e1072_fk_post_office_email_id FOREIGN KEY (email_id) REFERENCES post_office_email(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3659 (class 2606 OID 35723)
-- Name: primary_type_id_2dc5d034b5efba53_fk_icekit_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_events_eventbase
    ADD CONSTRAINT primary_type_id_2dc5d034b5efba53_fk_icekit_events_eventtype_id FOREIGN KEY (primary_type_id) REFERENCES icekit_events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3619 (class 2606 OID 34755)
-- Name: reve_content_type_id_41287223bc9a6dd9_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_version
    ADD CONSTRAINT reve_content_type_id_41287223bc9a6dd9_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3618 (class 2606 OID 34760)
-- Name: reversion__revision_id_24d1df8e34a1006_fk_reversion_revision_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_version
    ADD CONSTRAINT reversion__revision_id_24d1df8e34a1006_fk_reversion_revision_id FOREIGN KEY (revision_id) REFERENCES reversion_revision(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3617 (class 2606 OID 34765)
-- Name: reversion__user_id_2f6a4c5b83c3ef3a_fk_polymorphic_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reversion_revision
    ADD CONSTRAINT reversion__user_id_2f6a4c5b83c3ef3a_fk_polymorphic_auth_user_id FOREIGN KEY (user_id) REFERENCES polymorphic_auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3621 (class 2606 OID 34770)
-- Name: sh_master_id_66633fbf28ae4ba2_fk_sharedcontent_sharedcontent_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent_translation
    ADD CONSTRAINT sh_master_id_66633fbf28ae4ba2_fk_sharedcontent_sharedcontent_id FOREIGN KEY (master_id) REFERENCES sharedcontent_sharedcontent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3620 (class 2606 OID 34775)
-- Name: sharedcontent_parent_site_id_203a57eb3e034c07_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharedcontent_sharedcontent
    ADD CONSTRAINT sharedcontent_parent_site_id_203a57eb3e034c07_fk_django_site_id FOREIGN KEY (parent_site_id) REFERENCES django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3710 (class 2606 OID 36474)
-- Name: tes_a_model_id_6c7567eb8e35c72b_fk_tests_publishingm2mmodela_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mthroughtable
    ADD CONSTRAINT tes_a_model_id_6c7567eb8e35c72b_fk_tests_publishingm2mmodela_id FOREIGN KEY (a_model_id) REFERENCES tests_publishingm2mmodela(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3624 (class 2606 OID 34780)
-- Name: test_a_publishing_linked_id_3d2537f6c6baa66b_fk_test_article_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT test_a_publishing_linked_id_3d2537f6c6baa66b_fk_test_article_id FOREIGN KEY (publishing_linked_id) REFERENCES test_article(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3623 (class 2606 OID 34785)
-- Name: test_article_layout_id_4efdd6e120c3ff8d_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_article
    ADD CONSTRAINT test_article_layout_id_4efdd6e120c3ff8d_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3703 (class 2606 OID 36394)
-- Name: test_articlelist_layout_id_7793144471b50fc8_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT test_articlelist_layout_id_7793144471b50fc8_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3709 (class 2606 OID 36479)
-- Name: test_b_model_id_8ba04e0929687ce_fk_tests_publishingm2mmodelb_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_publishingm2mthroughtable
    ADD CONSTRAINT test_b_model_id_8ba04e0929687ce_fk_tests_publishingm2mmodelb_id FOREIGN KEY (b_model_id) REFERENCES tests_publishingm2mmodelb(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3629 (class 2606 OID 34790)
-- Name: test_layout_page_id_4b74af5f4cd63371_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related_related_pages
    ADD CONSTRAINT test_layout_page_id_4b74af5f4cd63371_fk_fluent_pages_urlnode_id FOREIGN KEY (page_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3627 (class 2606 OID 34795)
-- Name: test_layoutpage__layout_id_3224e5428cf02125_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT test_layoutpage__layout_id_3224e5428cf02125_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3626 (class 2606 OID 34800)
-- Name: test_urlnode_ptr_id_3c5ed7a939f58458_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_layoutpage_with_related
    ADD CONSTRAINT test_urlnode_ptr_id_3c5ed7a939f58458_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3704 (class 2606 OID 36389)
-- Name: test_urlnode_ptr_id_6b8b278b262dc965_fk_fluent_pages_urlnode_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY test_articlelisting
    ADD CONSTRAINT test_urlnode_ptr_id_6b8b278b262dc965_fk_fluent_pages_urlnode_id FOREIGN KEY (urlnode_ptr_id) REFERENCES fluent_pages_urlnode(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3631 (class 2606 OID 34805)
-- Name: tests_barwithlay_layout_id_190dba3925fc244c_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_barwithlayout
    ADD CONSTRAINT tests_barwithlay_layout_id_190dba3925fc244c_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3632 (class 2606 OID 34810)
-- Name: tests_bazwithlay_layout_id_5b81198284f1c2ec_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_bazwithlayout
    ADD CONSTRAINT tests_bazwithlay_layout_id_5b81198284f1c2ec_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3633 (class 2606 OID 34815)
-- Name: tests_foowithlay_layout_id_30d1fecbf1a77e9d_fk_icekit_layout_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tests_foowithlayout
    ADD CONSTRAINT tests_foowithlay_layout_id_30d1fecbf1a77e9d_fk_icekit_layout_id FOREIGN KEY (layout_id) REFERENCES icekit_layout(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3685 (class 2606 OID 36038)
-- Name: work_content_type_id_350c9e95b1ceb5b2_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY icekit_workflow_workflowstate
    ADD CONSTRAINT work_content_type_id_350c9e95b1ceb5b2_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


-- Completed on 2017-05-10 00:45:22 UTC

--
-- PostgreSQL database dump complete
--

