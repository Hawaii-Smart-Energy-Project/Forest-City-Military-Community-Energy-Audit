--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: energy_autoload_new; Type: TABLE; Schema: public; Owner: sepgroup; Tablespace: 
--

CREATE TABLE energy_autoload_new (
    house_id integer NOT NULL,
    datetime timestamp without time zone NOT NULL,
    use_kw double precision,
    gen_kw double precision,
    grid_kw double precision,
    ac_kw double precision,
    fan_kw double precision,
    dhw_kw double precision,
    stove_kw double precision,
    dryer_kw double precision,
    clotheswasher_kw double precision,
    dishwasher_kw double precision,
    solarpump_kw double precision,
    upload_date timestamp without time zone,
    microwave_kw double precision,
    acplus_kw double precision
);


ALTER TABLE public.energy_autoload_new OWNER TO sepgroup;

--
-- Name: energy_autoload_copy_pkey; Type: CONSTRAINT; Schema: public; Owner: sepgroup; Tablespace: 
--

ALTER TABLE ONLY energy_autoload_new
    ADD CONSTRAINT energy_autoload_copy_pkey PRIMARY KEY (house_id, datetime);


--
-- Name: idx_primary_key; Type: INDEX; Schema: public; Owner: sepgroup; Tablespace: 
--

CREATE INDEX idx_primary_key ON energy_autoload_new USING btree (house_id, datetime);


--
-- Name: energy_autoload_new; Type: ACL; Schema: public; Owner: sepgroup
--

REVOKE ALL ON TABLE energy_autoload_new FROM PUBLIC;
REVOKE ALL ON TABLE energy_autoload_new FROM sepgroup;
GRANT ALL ON TABLE energy_autoload_new TO sepgroup;


--
-- PostgreSQL database dump complete
--

