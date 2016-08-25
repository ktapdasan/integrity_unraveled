--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: chrs; Tablespace: 
--

CREATE TABLE accounts (
    employee_id text,
    password text DEFAULT md5('chrs123456'::text)
);


ALTER TABLE public.accounts OWNER TO chrs;

--
-- Name: departments; Type: TABLE; Schema: public; Owner: chrs; Tablespace: 
--

CREATE TABLE departments (
    pk integer NOT NULL,
    department text NOT NULL,
    code text NOT NULL,
    archived boolean DEFAULT false
);


ALTER TABLE public.departments OWNER TO chrs;

--
-- Name: departments_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE departments_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.departments_pk_seq OWNER TO chrs;

--
-- Name: departments_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE departments_pk_seq OWNED BY departments.pk;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: chrs; Tablespace: 
--

CREATE TABLE employees (
    pk integer NOT NULL,
    employee_id text NOT NULL,
    first_name text NOT NULL,
    middle_name text NOT NULL,
    last_name text NOT NULL,
    email_address text NOT NULL,
    archived boolean DEFAULT false,
    date_created timestamp with time zone DEFAULT now(),
    business_email_address text,
    "position" text,
    level text,
    department integer[]
);


ALTER TABLE public.employees OWNER TO chrs;

--
-- Name: employees_logs; Type: TABLE; Schema: public; Owner: chrs; Tablespace: 
--

CREATE TABLE employees_logs (
    employees_pk integer,
    log text NOT NULL,
    created_by integer,
    date_created timestamp with time zone DEFAULT now()
);


ALTER TABLE public.employees_logs OWNER TO chrs;

--
-- Name: employees_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE employees_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_pk_seq OWNER TO chrs;

--
-- Name: employees_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE employees_pk_seq OWNED BY employees.pk;


--
-- Name: employees_titles; Type: TABLE; Schema: public; Owner: chrs; Tablespace: 
--

CREATE TABLE employees_titles (
    employees_pk integer,
    title_pk integer,
    created_by integer,
    date_created timestamp with time zone DEFAULT now()
);


ALTER TABLE public.employees_titles OWNER TO chrs;

--
-- Name: groupings; Type: TABLE; Schema: public; Owner: chrs; Tablespace: 
--

CREATE TABLE groupings (
    employees_pk integer,
    supervisor_pk integer
);


ALTER TABLE public.groupings OWNER TO chrs;

--
-- Name: time_log; Type: TABLE; Schema: public; Owner: chrs; Tablespace: 
--

CREATE TABLE time_log (
    employees_pk integer,
    type text DEFAULT 'In'::text NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    time_log timestamp with time zone DEFAULT now()
);


ALTER TABLE public.time_log OWNER TO chrs;

--
-- Name: titles; Type: TABLE; Schema: public; Owner: chrs; Tablespace: 
--

CREATE TABLE titles (
    pk integer NOT NULL,
    title text NOT NULL,
    created_by integer,
    date_created timestamp with time zone DEFAULT now()
);


ALTER TABLE public.titles OWNER TO chrs;

--
-- Name: titles_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE titles_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.titles_pk_seq OWNER TO chrs;

--
-- Name: titles_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE titles_pk_seq OWNED BY titles.pk;


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY departments ALTER COLUMN pk SET DEFAULT nextval('departments_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY employees ALTER COLUMN pk SET DEFAULT nextval('employees_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY titles ALTER COLUMN pk SET DEFAULT nextval('titles_pk_seq'::regclass);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY accounts (employee_id, password) FROM stdin;
201000001	4da49c16db42ca04538d629ef0533fe8
201400066	4da49c16db42ca04538d629ef0533fe8
201400072	4da49c16db42ca04538d629ef0533fe8
201400078	4da49c16db42ca04538d629ef0533fe8
201400081	4da49c16db42ca04538d629ef0533fe8
201400087	4da49c16db42ca04538d629ef0533fe8
201400084	4da49c16db42ca04538d629ef0533fe8
201400088	4da49c16db42ca04538d629ef0533fe8
201400059	4da49c16db42ca04538d629ef0533fe8
201300004	4da49c16db42ca04538d629ef0533fe8
201400089	4da49c16db42ca04538d629ef0533fe8
201400097	4da49c16db42ca04538d629ef0533fe8
201400098	4da49c16db42ca04538d629ef0533fe8
201400100	4da49c16db42ca04538d629ef0533fe8
201400102	4da49c16db42ca04538d629ef0533fe8
201400058	4da49c16db42ca04538d629ef0533fe8
201400103	4da49c16db42ca04538d629ef0533fe8
201400104	4da49c16db42ca04538d629ef0533fe8
201400105	4da49c16db42ca04538d629ef0533fe8
201400106	4da49c16db42ca04538d629ef0533fe8
201400107	4da49c16db42ca04538d629ef0533fe8
201400108	4da49c16db42ca04538d629ef0533fe8
201400109	4da49c16db42ca04538d629ef0533fe8
201400110	4da49c16db42ca04538d629ef0533fe8
201400111	4da49c16db42ca04538d629ef0533fe8
201400112	4da49c16db42ca04538d629ef0533fe8
201400113	4da49c16db42ca04538d629ef0533fe8
201400114	4da49c16db42ca04538d629ef0533fe8
201400115	4da49c16db42ca04538d629ef0533fe8
201400117	4da49c16db42ca04538d629ef0533fe8
201400118	4da49c16db42ca04538d629ef0533fe8
201400119	4da49c16db42ca04538d629ef0533fe8
201400120	4da49c16db42ca04538d629ef0533fe8
201400121	4da49c16db42ca04538d629ef0533fe8
201400122	4da49c16db42ca04538d629ef0533fe8
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY departments (pk, department, code, archived) FROM stdin;
20	EXECOM	EXECOM	f
21	VRT	VRT	f
22	BRT	BRT	f
23	F&A	F&A	f
24	HRPC	HRPC	f
25	CQT	CQT	f
26	IIT	IIT	f
27	TRT	TRT	f
28	NVRT	NVRT	f
29	CSRT	CSRT	f
\.


--
-- Name: departments_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('departments_pk_seq', 29, true);


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY employees (pk, employee_id, first_name, middle_name, last_name, email_address, archived, date_created, business_email_address, "position", level, department) FROM stdin;
20	201400089	Ma. Fe	Pariscal	Bolinas	mfbolinas.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	mafe.bolinas@gmail.com	Business Development Associate	Associate	\N
24	201400102	John Erasmus Mari	Regado	Fernandez	N/A	f	2016-02-14 23:42:40.014678+08	johnerasmusmarif@gmail.com	HR Associate	Associate	\N
10	201000001	Rheyan	Feliciano	Lipardo	waynelipardo.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	wayne.lipardo@gmail.com 	Owner & Managing Director	C-Level	{20}
26	201400103	Gerlie	Pagaduan	Andres	gerlie.andres@chrsglobal.com	f	2016-02-14 23:42:40.014678+08	gerlieandres0201@gmail.com	HR Associate	Intern	{24}
18	201400059	Marilyn May	Villano	Bolocon	mbolocon.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	bolocon.marilynmay@yahoo.com	Talent Acquisition Associate	Associate	{21}
17	201400088	Arjev	Price	De Los Reyes	adlreyes.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	arjevdelosreyes@gmail.com	Asst HR Manager	Asst Manager	{24}
13	201400078	Lita	Llanera	Elejido	lelejido.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	lhitaelejido@gmail.com	Talent Acquisition Associate	Associate	{28}
23	201400100	Rolando	Carillo	Fabi	rolly.fabi@chrsglobal.com	f	2016-02-14 23:42:40.014678+08	rollyfabi_23@yahoo.com	Accounting Supervisor	Supervisor	{23}
16	201400084	Michelle	Balasta	Gongura	mgongura.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	N/A	HR Associate	Intern	{21}
19	201300004	Mary Grace	Soriano 	Lacerna	gracesoriano.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	N/A	Client & Recruitment Supervisor	Supervisor	{22,29}
25	201400058	Rodette Joyce	Magaway	Laurio	jlaurio.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	N/A	HR Associate	Associate	{28}
22	201400098	Rolando	Garfin	Lipardo	N/A	f	2016-02-14 23:42:40.014678+08	N/A	Liason Associate	Associate	{23}
27	201400104	Eliza	Alcaraz	Mandique	eliza.mandique@chrsglobal.com	f	2016-02-14 23:42:40.014678+08	eliza.mandique@yahoo.com	Corporate Quality Supervisor	Supervisor	{25}
15	201400087	Faya Lou	Mahinay	Parenas	fparenas.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	N/A	Asst Recruitment & Client Specialist	Specialist	{27}
28	201400105	Rafael	Aurelio	Pascual	rafael.pascual@chrsglobal.com	f	2016-02-14 23:42:40.014678+08	rpascual0812@gmail.com	Project IT Manager	Manager	{26}
14	201400081	Vincent	Yturralde	Ramil	vramil.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	N/A	Asst Client & Recruitment Supervisor	Supervisor	{21}
11	201400066	Judy Ann	Lantican	Reginaldo	jreginaldo.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	N/A	Asst Client and Recruitment Manager	Manager	{28}
21	201400097	Ariel	Dela Cruz	Solis	N/A	f	2016-02-14 23:42:40.014678+08	acsolis10@yahoo.com 	Accounting Consultant	Associate	{23}
12	201400072	Ken	Villanueva	Tapdasan	ktapdasan.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	bluraven20@gmail.com	HR and Admin Associate	Associate	{27}
32	201400109	Angelica	Barredo	Abaleta	aabelata.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	a.abaleta@yahoo.com	HR Associate Intern	Associate	\N
36	201400113	Aprilil Mae	Denalo	Nefulda	Aprilil.nefulda@chrsglobal.com	f	2016-02-14 23:42:40.014678+08	Aprililmaenefulda@ymail.com	HR Associate Intern	Associate	\N
29	201400106	Eralyn May	Bayot	Adino	emadino.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	jinra25@gmail.com	HR Associate Intern	Associate	{27}
31	201400108	Irone John	Mendoza	Amor	ijamor.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	ironejohn@gmail.com	HR Associate Intern	Associate	{27}
38	201400115	Jennifer	Araneta	Balucay	jbalucay.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	jennbalucay93@gmail.com	Cashier/Skin Care Advisor	Associate	{29}
34	201400111	Angelyn	Daguro	Cuevas	acuevas.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	angelyn.cuevas1017@gmail.com	HR Associate Intern	Associate	{21}
37	201400114	Karen	Medo	Esmeralda	kesmeraldo@gmail.com	f	2016-02-14 23:42:40.014678+08	kesmeraldo.chrs@gmail.com	Cashier/Skin Care Advisor	Associate	{29}
30	201400107	Ana Margarita	Hernandez	Galero	amgalero.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	anamgalero@gmail.com	HR Associate Intern	Associate	{27}
35	201400112	Alween Orange	Ceredon	Gemao	aogemao.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	orangegemao@yahoo.com	HR Associate Intern	Associate	{21}
40	201400118	Cristina	Tulayan	Ibanez	cibanez.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	tina_041481@yahoo.com	HR Associate Intern	Associate	{22,29}
42	201400120	Aimee	Gaborni	Legaspi	alegaspi.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	aimeelgsp@icloud.com	HR Associate Intern	Associate	{22,29}
33	201400110	Shena Mae	Jardinel	Nava	shena.nava@chrsglobal.com	f	2016-02-14 23:42:40.014678+08	shenamaenavacalma@yahoo.com	HR Associate Intern	Associate	{21}
39	201400117	Arlene	Diama	Obasa	aobasa.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	obasa_arlene@yahoo.com	Cashier/Skin Care Advisor	Associate	{29}
43	201400121	Kathleen Kay	Macalino	Ongcal	kkongcal.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	kathleen.ongcal@chrsglobal.com	Clinic Consultant	Associate	{29}
41	201400119	Alyssa	Iligan	Panaguiton	apanaguiton.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	panaguitonalyssaend121@gmail.com	HR Associate Intern	Associate	{24}
44	201400122	Marry Jeane	Genteroy	Sadsad	mjsadsad.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	marry.sadsad@chrsglobal.com	Clinic Consultant	Associate	{29}
45	201400126	Michelle	Tan	De Guzman	mdeguzman.chrs@gmail.com	f	2016-03-04 16:14:08.15679+08	michelle.deguzman@chrsglobal.com 	Assistant Client and Recruitment Manager	Manager	{27}
\.


--
-- Data for Name: employees_logs; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY employees_logs (employees_pk, log, created_by, date_created) FROM stdin;
\.


--
-- Name: employees_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('employees_pk_seq', 45, true);


--
-- Data for Name: employees_titles; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY employees_titles (employees_pk, title_pk, created_by, date_created) FROM stdin;
\.


--
-- Data for Name: groupings; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY groupings (employees_pk, supervisor_pk) FROM stdin;
\.


--
-- Data for Name: time_log; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY time_log (employees_pk, type, date_created, time_log) FROM stdin;
28	In	2016-02-01 22:30:09+08	2016-02-01 22:30:09+08
28	Out	2016-02-02 00:03:07.623129+08	2016-02-02 00:03:07.623129+08
28	In	2016-02-02 14:27:28.178119+08	2016-02-02 14:27:28.178119+08
28	Out	2016-02-02 14:28:32.649029+08	2016-02-02 14:28:32.649029+08
28	In	2016-02-02 15:12:16.863032+08	2016-02-02 15:12:16.863032+08
28	Out	2016-02-02 15:12:46.976283+08	2016-02-02 15:12:46.976283+08
28	In	2016-02-04 06:49:45.120377+08	2016-02-04 06:49:45.120377+08
27	In	2016-03-04 11:09:19.691636+08	2016-03-04 11:09:19.691636+08
27	Out	2016-03-04 11:45:35.411395+08	2016-03-04 11:45:35.411395+08
27	In	2016-03-04 11:48:11.829994+08	2016-03-04 11:48:11.829994+08
27	Out	2016-03-04 11:48:20.639199+08	2016-03-04 11:48:20.639199+08
17	In	2016-03-04 15:29:11.533568+08	2016-03-04 15:29:11.533568+08
27	In	2016-03-04 15:29:40.573771+08	2016-03-04 15:29:40.573771+08
27	Out	2016-03-04 15:30:05.849851+08	2016-03-04 15:30:05.849851+08
10	In	2016-03-04 15:43:57.195602+08	2016-03-04 15:43:57.195602+08
10	Out	2016-03-04 15:49:48.399146+08	2016-03-04 15:49:48.399146+08
10	In	2016-03-04 15:50:18.920806+08	2016-03-04 15:50:18.920806+08
10	Out	2016-03-04 15:51:03.057488+08	2016-03-04 15:51:03.057488+08
10	In	2016-03-04 16:02:00.623231+08	2016-03-04 16:02:00.623231+08
27	In	2016-03-04 16:32:18.395+08	2016-03-04 16:32:18.395+08
27	Out	2016-03-04 16:33:12.517749+08	2016-03-04 16:33:12.517749+08
11	In	2016-03-04 16:38:38.941215+08	2016-03-04 16:38:38.941215+08
11	Out	2016-03-04 16:38:57.183955+08	2016-03-04 16:38:57.183955+08
28	Out	2016-03-04 20:59:19.714266+08	2016-03-04 20:59:19.714266+08
28	In	2016-03-04 20:59:36.803988+08	2016-03-04 20:59:36.803988+08
28	Out	2016-03-04 20:59:45.266403+08	2016-03-04 20:59:45.266403+08
28	In	2016-03-06 07:01:30.125776+08	2016-03-06 07:01:30.125776+08
28	Out	2016-03-06 07:01:55.897063+08	2016-03-06 07:01:55.897063+08
28	In	2016-03-06 07:02:11.471145+08	2016-03-06 07:02:11.471145+08
28	Out	2016-03-06 07:10:02.094909+08	2016-03-06 07:10:02.094909+08
28	In	2016-03-06 07:10:22.807082+08	2016-03-06 07:10:22.807082+08
28	Out	2016-03-06 07:10:33.556007+08	2016-03-06 07:10:33.556007+08
\.


--
-- Data for Name: titles; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY titles (pk, title, created_by, date_created) FROM stdin;
\.


--
-- Name: titles_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('titles_pk_seq', 1, false);


--
-- Name: departments_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs; Tablespace: 
--

ALTER TABLE ONLY departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (pk);


--
-- Name: employees_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs; Tablespace: 
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (pk);


--
-- Name: titles_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs; Tablespace: 
--

ALTER TABLE ONLY titles
    ADD CONSTRAINT titles_pkey PRIMARY KEY (pk);


--
-- Name: code_unique_idx; Type: INDEX; Schema: public; Owner: chrs; Tablespace: 
--

CREATE UNIQUE INDEX code_unique_idx ON departments USING btree (code);


--
-- Name: department_unique_idx; Type: INDEX; Schema: public; Owner: chrs; Tablespace: 
--

CREATE UNIQUE INDEX department_unique_idx ON departments USING btree (department);


--
-- Name: employee_id_idx; Type: INDEX; Schema: public; Owner: chrs; Tablespace: 
--

CREATE INDEX employee_id_idx ON employees USING btree (employee_id);


--
-- Name: employee_id_unique_idx; Type: INDEX; Schema: public; Owner: chrs; Tablespace: 
--

CREATE UNIQUE INDEX employee_id_unique_idx ON employees USING btree (employee_id);


--
-- Name: first_name_idx; Type: INDEX; Schema: public; Owner: chrs; Tablespace: 
--

CREATE INDEX first_name_idx ON employees USING btree (first_name);


--
-- Name: groupings_unique_idx; Type: INDEX; Schema: public; Owner: chrs; Tablespace: 
--

CREATE UNIQUE INDEX groupings_unique_idx ON groupings USING btree (employees_pk, supervisor_pk);


--
-- Name: last_name_idx; Type: INDEX; Schema: public; Owner: chrs; Tablespace: 
--

CREATE INDEX last_name_idx ON employees USING btree (last_name);


--
-- Name: middle_name_idx; Type: INDEX; Schema: public; Owner: chrs; Tablespace: 
--

CREATE INDEX middle_name_idx ON employees USING btree (middle_name);


--
-- Name: employees_logs_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY employees_logs
    ADD CONSTRAINT employees_logs_created_by_fkey FOREIGN KEY (created_by) REFERENCES employees(pk);


--
-- Name: employees_logs_employees_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY employees_logs
    ADD CONSTRAINT employees_logs_employees_pk_fkey FOREIGN KEY (employees_pk) REFERENCES employees(pk);


--
-- Name: employees_titles_title_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY employees_titles
    ADD CONSTRAINT employees_titles_title_pk_fkey FOREIGN KEY (title_pk) REFERENCES titles(pk);


--
-- Name: groupings_employees_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY groupings
    ADD CONSTRAINT groupings_employees_pk_fkey FOREIGN KEY (employees_pk) REFERENCES employees(pk);


--
-- Name: groupings_supervisor_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY groupings
    ADD CONSTRAINT groupings_supervisor_pk_fkey FOREIGN KEY (supervisor_pk) REFERENCES employees(pk);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

