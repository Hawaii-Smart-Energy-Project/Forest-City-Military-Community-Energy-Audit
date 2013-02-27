--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: energy_autoload_new_dates; Type: VIEW; Schema: public; Owner: sepgroup
--

CREATE VIEW energy_autoload_new_dates AS
    SELECT energy_autoload_new.house_id, min(energy_autoload_new.datetime) AS "E Start Date", max(energy_autoload_new.datetime) AS "E Latest Date", ((count(*) / 60) / 24) AS "Days of Data" FROM energy_autoload_new GROUP BY energy_autoload_new.house_id ORDER BY energy_autoload_new.house_id;


ALTER TABLE public.energy_autoload_new_dates OWNER TO sepgroup;

--
-- Name: energy_autoload_new_dates; Type: ACL; Schema: public; Owner: sepgroup
--

REVOKE ALL ON TABLE energy_autoload_new_dates FROM PUBLIC;
REVOKE ALL ON TABLE energy_autoload_new_dates FROM sepgroup;
GRANT ALL ON TABLE energy_autoload_new_dates TO sepgroup;


--
-- PostgreSQL database dump complete
--

