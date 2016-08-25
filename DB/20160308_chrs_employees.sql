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
201400081	4da49c16db42ca04538d629ef0533fe8
201400087	4da49c16db42ca04538d629ef0533fe8
201400084	4da49c16db42ca04538d629ef0533fe8
201400059	4da49c16db42ca04538d629ef0533fe8
201300004	4da49c16db42ca04538d629ef0533fe8
201400089	4da49c16db42ca04538d629ef0533fe8
201400097	4da49c16db42ca04538d629ef0533fe8
201400098	4da49c16db42ca04538d629ef0533fe8
201400100	4da49c16db42ca04538d629ef0533fe8
201400102	4da49c16db42ca04538d629ef0533fe8
201400103	4da49c16db42ca04538d629ef0533fe8
201400106	4da49c16db42ca04538d629ef0533fe8
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
201400126	4da49c16db42ca04538d629ef0533fe8
201400128	4da49c16db42ca04538d629ef0533fe8
201400107	ad42c83ac4d3b86de14f207c46a0df0e
201400104	c20ad4d76fe97759aa27a0c99bff6710
201400078	bef6ba7a1d5f4e2154b7a3438eca13a8
201400132	5ee50dcda48f303a1f55773d1b3b10aa
201400088	eb9ad4bf48f9a70536f47c0248a85231
201400072	bef6ba7a1d5f4e2154b7a3438eca13a8
201400124	4da49c16db42ca04538d629ef0533fe8
201400058	0f539bb9125b0b68bfe7ea055361b1e1
201400066	f12d545e83acf361a25c654ab230d59c
201400105	f25a2fc72690b780b2a14e140ef6a9e0
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
30	BD	BD	f
\.


--
-- Name: departments_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('departments_pk_seq', 30, true);


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
47	201400128	Aleine Leilanie	Braza	Oro	aloro.chrs@gmail.com	f	2016-03-07 12:16:40.262446+08	aleine.oro@chrsglobal.com	Business Development Officer	Officer	{30}
48	201400132	Maria Eliza	Querido	De Mesa	medemesa.chrs@gmail.com	f	2016-03-07 16:21:37.202235+08	maria.demesa@chrsglobal.com	Talent Acquisition Associate	Associate	{22}
49	201400124	Renz	Santiago	Feliciano	rfeliciano.chrs@gmail.com	f	2016-03-08 09:05:10.063741+08	renz.feliciano@chrsglobal.com	HR Associate	Associate	{22}
\.


--
-- Data for Name: employees_logs; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY employees_logs (employees_pk, log, created_by, date_created) FROM stdin;
\.


--
-- Name: employees_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('employees_pk_seq', 49, true);


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
27	In	2016-03-07 11:06:21.192923+08	2016-03-07 11:06:21.192923+08
28	In	2016-03-07 11:06:56.305992+08	2016-03-07 11:06:56.305992+08
26	In	2016-03-07 11:11:49.474127+08	2016-03-07 11:11:49.474127+08
12	In	2016-03-07 11:11:50.438158+08	2016-03-07 11:11:50.438158+08
23	In	2016-03-07 11:19:41.435441+08	2016-03-07 11:19:41.435441+08
45	In	2016-03-07 11:27:21.389282+08	2016-03-07 11:27:21.389282+08
14	In	2016-03-07 11:28:46.282855+08	2016-03-07 11:28:46.282855+08
31	In	2016-03-07 11:29:32.976929+08	2016-03-07 11:29:32.976929+08
18	In	2016-03-07 11:29:49.825062+08	2016-03-07 11:29:49.825062+08
29	In	2016-03-07 11:30:13.419541+08	2016-03-07 11:30:13.419541+08
30	In	2016-03-07 11:40:05.831914+08	2016-03-07 11:40:05.831914+08
47	In	2016-03-07 12:20:45.91341+08	2016-03-07 12:20:45.91341+08
17	In	2016-03-07 12:34:02.969568+08	2016-03-07 12:34:02.969568+08
11	In	2016-03-07 13:07:55.739427+08	2016-03-07 13:07:55.739427+08
25	In	2016-03-07 13:08:58.074692+08	2016-03-07 13:08:58.074692+08
13	In	2016-03-07 13:10:01.174937+08	2016-03-07 13:10:01.174937+08
41	In	2016-03-07 14:26:51.77572+08	2016-03-07 14:26:51.77572+08
26	Out	2016-03-07 16:07:02.161364+08	2016-03-07 16:07:02.161364+08
48	In	2016-03-07 16:37:53.745243+08	2016-03-07 16:37:53.745243+08
48	Out	2016-03-07 18:00:21.373753+08	2016-03-07 18:00:21.373753+08
27	Out	2016-03-07 18:00:25.109912+08	2016-03-07 18:00:25.109912+08
17	Out	2016-03-07 18:00:31.828868+08	2016-03-07 18:00:31.828868+08
41	Out	2016-03-07 18:01:17.261243+08	2016-03-07 18:01:17.261243+08
25	Out	2016-03-07 18:01:25.309+08	2016-03-07 18:01:25.309+08
23	Out	2016-03-07 18:01:45.404678+08	2016-03-07 18:01:45.404678+08
12	Out	2016-03-07 18:02:01.981262+08	2016-03-07 18:02:01.981262+08
28	Out	2016-03-07 18:02:22.807699+08	2016-03-07 18:02:22.807699+08
13	Out	2016-03-07 18:05:21.932566+08	2016-03-07 18:05:21.932566+08
30	Out	2016-03-07 18:06:34.525406+08	2016-03-07 18:06:34.525406+08
31	Out	2016-03-07 13:03:24.803197+08	2016-03-07 13:03:24.803197+08
29	Out	2016-03-07 13:03:37.382413+08	2016-03-07 13:03:37.382413+08
47	Out	2016-03-07 18:11:43.105179+08	2016-03-07 18:11:43.105179+08
18	Out	2016-03-07 18:12:01.778656+08	2016-03-07 18:12:01.778656+08
14	Out	2016-03-07 18:18:08.462828+08	2016-03-07 18:18:08.462828+08
45	Out	2016-03-07 18:19:27.196977+08	2016-03-07 18:19:27.196977+08
11	Out	2016-03-07 18:22:00.168102+08	2016-03-07 18:22:00.168102+08
41	In	2016-03-08 08:24:18.483061+08	2016-03-08 08:24:18.483061+08
28	In	2016-03-08 08:26:59.845928+08	2016-03-08 08:26:59.845928+08
23	In	2016-03-08 08:27:29.703135+08	2016-03-08 08:27:29.703135+08
26	In	2016-03-08 08:28:04.809894+08	2016-03-08 08:28:04.809894+08
12	In	2016-03-08 08:29:07.939125+08	2016-03-08 08:29:07.939125+08
30	In	2016-03-08 08:31:14.681182+08	2016-03-08 08:31:14.681182+08
17	In	2016-03-08 08:32:29.127312+08	2016-03-08 08:32:29.127312+08
48	In	2016-03-08 08:34:15.348835+08	2016-03-08 08:34:15.348835+08
25	In	2016-03-08 08:43:25.87703+08	2016-03-08 08:43:25.87703+08
18	In	2016-03-08 08:45:32.594354+08	2016-03-08 08:45:32.594354+08
31	In	2016-03-08 08:46:28.091295+08	2016-03-08 08:46:28.091295+08
27	In	2016-03-08 08:48:09.875441+08	2016-03-08 08:48:09.875441+08
45	In	2016-03-08 08:49:16.181366+08	2016-03-08 08:49:16.181366+08
13	In	2016-03-08 08:53:31.389269+08	2016-03-08 08:53:31.389269+08
14	In	2016-03-08 08:57:08.970241+08	2016-03-08 08:57:08.970241+08
11	In	2016-03-08 09:02:07.736326+08	2016-03-08 09:02:07.736326+08
49	In	2016-03-08 09:06:46.782774+08	2016-03-08 09:06:46.782774+08
26	Out	2016-03-08 16:03:54.760259+08	2016-03-08 16:03:54.760259+08
48	Out	2016-03-08 17:59:05.774623+08	2016-03-08 17:59:05.774623+08
11	Out	2016-03-08 18:00:08.779787+08	2016-03-08 18:00:08.779787+08
31	Out	2016-03-08 18:00:12.747056+08	2016-03-08 18:00:12.747056+08
41	Out	2016-03-08 18:00:37.470899+08	2016-03-08 18:00:37.470899+08
25	Out	2016-03-08 18:00:51.388258+08	2016-03-08 18:00:51.388258+08
49	Out	2016-03-08 18:01:48.095596+08	2016-03-08 18:01:48.095596+08
18	Out	2016-03-08 18:01:48.937727+08	2016-03-08 18:01:48.937727+08
13	Out	2016-03-08 18:02:17.141509+08	2016-03-08 18:02:17.141509+08
27	Out	2016-03-08 18:02:56.677464+08	2016-03-08 18:02:56.677464+08
23	Out	2016-03-08 18:03:03.634168+08	2016-03-08 18:03:03.634168+08
30	Out	2016-03-08 18:03:20.848599+08	2016-03-08 18:03:20.848599+08
12	Out	2016-03-08 18:03:24.680777+08	2016-03-08 18:03:24.680777+08
28	Out	2016-03-08 18:03:37.395662+08	2016-03-08 18:03:37.395662+08
14	Out	2016-03-08 18:04:54.933987+08	2016-03-08 18:04:54.933987+08
45	Out	2016-03-08 18:07:08.754122+08	2016-03-08 18:07:08.754122+08
17	Out	2016-03-08 18:16:22.471313+08	2016-03-08 18:16:22.471313+08
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

