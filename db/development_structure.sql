--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bj_config; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bj_config (
    bj_config_id integer NOT NULL,
    hostname text,
    key text,
    value text,
    "cast" text
);


--
-- Name: bj_job; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bj_job (
    bj_job_id integer NOT NULL,
    command text,
    state text,
    priority integer,
    tag text,
    is_restartable integer,
    submitter text,
    runner text,
    pid integer,
    submitted_at timestamp without time zone,
    started_at timestamp without time zone,
    finished_at timestamp without time zone,
    env text,
    stdin text,
    stdout text,
    stderr text,
    exit_status integer
);


--
-- Name: bj_job_archive; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bj_job_archive (
    bj_job_archive_id integer NOT NULL,
    command text,
    state text,
    priority integer,
    tag text,
    is_restartable integer,
    submitter text,
    runner text,
    pid integer,
    submitted_at timestamp without time zone,
    started_at timestamp without time zone,
    finished_at timestamp without time zone,
    archived_at timestamp without time zone,
    env text,
    stdin text,
    stdout text,
    stderr text,
    exit_status integer
);


--
-- Name: captions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE captions (
    id integer NOT NULL,
    photo_id integer,
    caption text,
    user_id integer,
    votes_count integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    user_id integer,
    comment text,
    caption_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: photos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE photos (
    id integer NOT NULL,
    flickr_id character varying(255) NOT NULL,
    square text,
    thumbnail text,
    small text,
    medium text,
    large text,
    original text,
    state character varying(255) DEFAULT NULL::character varying,
    author text,
    photostream text,
    captioned_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sessions (
    id integer NOT NULL,
    session_id character varying(255) NOT NULL,
    data text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    site_id integer,
    site_user_id bigint,
    session_key character varying(255) DEFAULT NULL::character varying,
    username character varying(255) DEFAULT NULL::character varying,
    email character varying(255) DEFAULT NULL::character varying,
    profile_url character varying(255) DEFAULT NULL::character varying,
    profile_image_url character varying(255) DEFAULT NULL::character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE votes (
    id integer NOT NULL,
    user_id integer,
    caption_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bj_config_bj_config_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bj_config_bj_config_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: bj_config_bj_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bj_config_bj_config_id_seq OWNED BY bj_config.bj_config_id;


--
-- Name: bj_job_archive_bj_job_archive_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bj_job_archive_bj_job_archive_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: bj_job_archive_bj_job_archive_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bj_job_archive_bj_job_archive_id_seq OWNED BY bj_job_archive.bj_job_archive_id;


--
-- Name: bj_job_bj_job_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bj_job_bj_job_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: bj_job_bj_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bj_job_bj_job_id_seq OWNED BY bj_job.bj_job_id;


--
-- Name: captions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE captions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: captions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE captions_id_seq OWNED BY captions.id;


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: photos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE photos_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE photos_id_seq OWNED BY photos.id;


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sessions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sessions_id_seq OWNED BY sessions.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE votes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE votes_id_seq OWNED BY votes.id;


--
-- Name: bj_config_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE bj_config ALTER COLUMN bj_config_id SET DEFAULT nextval('bj_config_bj_config_id_seq'::regclass);


--
-- Name: bj_job_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE bj_job ALTER COLUMN bj_job_id SET DEFAULT nextval('bj_job_bj_job_id_seq'::regclass);


--
-- Name: bj_job_archive_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE bj_job_archive ALTER COLUMN bj_job_archive_id SET DEFAULT nextval('bj_job_archive_bj_job_archive_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE captions ALTER COLUMN id SET DEFAULT nextval('captions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE photos ALTER COLUMN id SET DEFAULT nextval('photos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE sessions ALTER COLUMN id SET DEFAULT nextval('sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE votes ALTER COLUMN id SET DEFAULT nextval('votes_id_seq'::regclass);


--
-- Name: bj_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bj_config
    ADD CONSTRAINT bj_config_pkey PRIMARY KEY (bj_config_id);


--
-- Name: bj_job_archive_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bj_job_archive
    ADD CONSTRAINT bj_job_archive_pkey PRIMARY KEY (bj_job_archive_id);


--
-- Name: bj_job_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bj_job
    ADD CONSTRAINT bj_job_pkey PRIMARY KEY (bj_job_id);


--
-- Name: captions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY captions
    ADD CONSTRAINT captions_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: photos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: index_bj_config_on_hostname_and_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_bj_config_on_hostname_and_key ON bj_config USING btree (hostname, key);


--
-- Name: index_captions_on_photo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_captions_on_photo_id ON captions USING btree (photo_id);


--
-- Name: index_captions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_captions_on_user_id ON captions USING btree (user_id);


--
-- Name: index_captions_on_votes_count; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_captions_on_votes_count ON captions USING btree (votes_count);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sessions_on_session_id ON sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sessions_on_updated_at ON sessions USING btree (updated_at);


--
-- Name: index_users_on_session_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_session_key ON users USING btree (session_key);


--
-- Name: index_users_on_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_site_id ON users USING btree (site_id);


--
-- Name: index_users_on_site_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_site_user_id ON users USING btree (site_user_id);


--
-- Name: index_votes_on_caption_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_caption_id ON votes USING btree (caption_id);


--
-- Name: index_votes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_user_id ON votes USING btree (user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20080509233216');

INSERT INTO schema_migrations (version) VALUES ('20080523212805');

INSERT INTO schema_migrations (version) VALUES ('20080523213943');

INSERT INTO schema_migrations (version) VALUES ('20080524003405');

INSERT INTO schema_migrations (version) VALUES ('20080530215253');

INSERT INTO schema_migrations (version) VALUES ('20080531002147');

INSERT INTO schema_migrations (version) VALUES ('20080610175358');