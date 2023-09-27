
-- Table: public.rss1_outlets

-- DROP TABLE IF EXISTS public.rss1_outlets;

CREATE TABLE IF NOT EXISTS public.rss1_outlets
(
    id integer NOT NULL DEFAULT nextval('rss1_outlets_id_seq'::regclass),
    outlet text COLLATE pg_catalog."default" NOT NULL,
    country text COLLATE pg_catalog."default" NOT NULL DEFAULT 'in'::text,
    language text COLLATE pg_catalog."default" NOT NULL DEFAULT 'en'::text,
    rss_reliability integer NOT NULL DEFAULT 0,
    logo_url text COLLATE pg_catalog."default",
    outlet_display text COLLATE pg_catalog."default" NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT rss1_outlets_pkey PRIMARY KEY (id),
    CONSTRAINT rss1_outlets_outlet_display_key UNIQUE (outlet_display),
    CONSTRAINT rss1_outlets_outlet_key UNIQUE (outlet)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.rss1_outlets
    OWNER to hasuraha;

 -- Table: public.rss1_links

-- DROP TABLE IF EXISTS public.rss1_links;

CREATE TABLE IF NOT EXISTS public.rss1_links
(
    id integer NOT NULL DEFAULT nextval('rss1_links_id_seq'::regclass),
    outlet text COLLATE pg_catalog."default" NOT NULL,
    rss1_link text COLLATE pg_catalog."default" NOT NULL,
    rss1_link_type integer NOT NULL DEFAULT 99,
    rss1_link_reliability integer NOT NULL DEFAULT 0,
    rss1_link_name text COLLATE pg_catalog."default" NOT NULL DEFAULT 'na'::text,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT rss1_links_pkey PRIMARY KEY (id),
    CONSTRAINT rss1_links_rss1_link_key UNIQUE (rss1_link),
    CONSTRAINT rss1_links_outlet_fkey FOREIGN KEY (outlet)
        REFERENCES public.rss1_outlets (outlet) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.rss1_links
    OWNER to hasuraha;

-- Trigger: set_public_rss1_links_updated_at

-- DROP TRIGGER IF EXISTS set_public_rss1_links_updated_at ON public.rss1_links;

CREATE OR REPLACE TRIGGER set_public_rss1_links_updated_at
    BEFORE UPDATE 
    ON public.rss1_links
    FOR EACH ROW
    EXECUTE FUNCTION public.set_current_timestamp_updated_at();

COMMENT ON TRIGGER set_public_rss1_links_updated_at ON public.rss1_links
    IS 'trigger to set value of column "updated_at" to current timestamp on row update';

    -- Table: public.rss1_articals

-- DROP TABLE IF EXISTS public.rss1_articals;

CREATE TABLE IF NOT EXISTS public.rss1_articals
(
    id bigint NOT NULL DEFAULT nextval('rss1_articals_id_seq'::regclass),
    rss1_link text COLLATE pg_catalog."default" NOT NULL,
    post_link text COLLATE pg_catalog."default" NOT NULL,
    title text COLLATE pg_catalog."default" NOT NULL,
    summary text COLLATE pg_catalog."default" NOT NULL,
    image_link text COLLATE pg_catalog."default" NOT NULL,
    post_published timestamp without time zone NOT NULL,
    author text COLLATE pg_catalog."default" NOT NULL,
    is_default_image integer NOT NULL DEFAULT 0,
    is_in_detail integer NOT NULL DEFAULT 0,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT rss1_articals_pkey PRIMARY KEY (id),
    CONSTRAINT rss1_articals_post_link_key UNIQUE (post_link),
    CONSTRAINT rss1_articals_rss1_link_fkey FOREIGN KEY (rss1_link)
        REFERENCES public.rss1_links (rss1_link) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.rss1_articals
    OWNER to hasuraha;

-- Trigger: set_public_rss1_articals_updated_at

-- DROP TRIGGER IF EXISTS set_public_rss1_articals_updated_at ON public.rss1_articals;

CREATE OR REPLACE TRIGGER set_public_rss1_articals_updated_at
    BEFORE UPDATE 
    ON public.rss1_articals
    FOR EACH ROW
    EXECUTE FUNCTION public.set_current_timestamp_updated_at();

COMMENT ON TRIGGER set_public_rss1_articals_updated_at ON public.rss1_articals
    IS 'trigger to set value of column "updated_at" to current timestamp on row update';

    -- Table: public.rss1_articles_detail

-- DROP TABLE IF EXISTS public.rss1_articles_detail;

CREATE TABLE IF NOT EXISTS public.rss1_articles_detail
(
    id integer NOT NULL DEFAULT nextval('rss1_articles_detail_id_seq'::regclass),
    article_id bigint NOT NULL,
    title text COLLATE pg_catalog."default" NOT NULL,
    summary text COLLATE pg_catalog."default" NOT NULL,
    description text[] COLLATE pg_catalog."default" NOT NULL,
    tags text[] COLLATE pg_catalog."default",
    image_link text[] COLLATE pg_catalog."default" NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT rss1_articles_detail_pkey PRIMARY KEY (id),
    CONSTRAINT rss1_articles_detail_article_id_fkey FOREIGN KEY (article_id)
        REFERENCES public.rss1_articals (id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.rss1_articles_detail
    OWNER to hasuraha;

-- Trigger: set_public_rss1_articles_detail_updated_at

-- DROP TRIGGER IF EXISTS set_public_rss1_articles_detail_updated_at ON public.rss1_articles_detail;

CREATE OR REPLACE TRIGGER set_public_rss1_articles_detail_updated_at
    BEFORE UPDATE 
    ON public.rss1_articles_detail
    FOR EACH ROW
    EXECUTE FUNCTION public.set_current_timestamp_updated_at();

COMMENT ON TRIGGER set_public_rss1_articles_detail_updated_at ON public.rss1_articles_detail
    IS 'trigger to set value of column "updated_at" to current timestamp on row update';
    
-- Trigger: set_public_rss1_outlets_updated_at

-- DROP TRIGGER IF EXISTS set_public_rss1_outlets_updated_at ON public.rss1_outlets;

CREATE OR REPLACE TRIGGER set_public_rss1_outlets_updated_at
    BEFORE UPDATE 
    ON public.rss1_outlets
    FOR EACH ROW
    EXECUTE FUNCTION public.set_current_timestamp_updated_at();

COMMENT ON TRIGGER set_public_rss1_outlets_updated_at ON public.rss1_outlets
    IS 'trigger to set value of column "updated_at" to current timestamp on row update';
-- Table: public.articles_vector1

-- DROP TABLE IF EXISTS public.articles_vector1;

CREATE TABLE IF NOT EXISTS public.articles_vector1
(
    id bigint NOT NULL DEFAULT nextval('articles_vector1_id_seq'::regclass),
    article_id bigint NOT NULL,
    vector1 vector NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT articles_vector1_pkey PRIMARY KEY (id),
    CONSTRAINT articles_vector1_article_id_key UNIQUE (article_id),
    CONSTRAINT articles_vector1_article_id_fkey FOREIGN KEY (article_id)
        REFERENCES public.rss1_articals (id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.articles_vector1
    OWNER to hasuraha;

-- Trigger: set_public_articles_vector1_updated_at

-- DROP TRIGGER IF EXISTS set_public_articles_vector1_updated_at ON public.articles_vector1;

CREATE OR REPLACE TRIGGER set_public_articles_vector1_updated_at
    BEFORE UPDATE 
    ON public.articles_vector1
    FOR EACH ROW
    EXECUTE FUNCTION public.set_current_timestamp_updated_at();

COMMENT ON TRIGGER set_public_articles_vector1_updated_at ON public.articles_vector1
    IS 'trigger to set value of column "updated_at" to current timestamp on row update';