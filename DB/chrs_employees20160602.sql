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
    titles_pk integer,
    level text,
    department integer[],
    levels_pk integer
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
    titles_pk integer,
    created_by integer,
    date_created timestamp with time zone DEFAULT now()
);


ALTER TABLE public.employees_titles OWNER TO chrs;

--
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: chrs; Tablespace: 
--

CREATE TABLE feedbacks (
    pk integer NOT NULL,
    feedback text NOT NULL,
    tool text NOT NULL,
    date_created timestamp with time zone DEFAULT now()
);


ALTER TABLE public.feedbacks OWNER TO chrs;

--
-- Name: feedbacks_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE feedbacks_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.feedbacks_pk_seq OWNER TO chrs;

--
-- Name: feedbacks_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE feedbacks_pk_seq OWNED BY feedbacks.pk;


--
-- Name: groupings; Type: TABLE; Schema: public; Owner: chrs; Tablespace: 
--

CREATE TABLE groupings (
    employees_pk integer,
    supervisor_pk integer
);


ALTER TABLE public.groupings OWNER TO chrs;

--
-- Name: levels; Type: TABLE; Schema: public; Owner: chrs; Tablespace: 
--

CREATE TABLE levels (
    pk integer NOT NULL,
    level_title character varying NOT NULL,
    archived boolean DEFAULT false
);


ALTER TABLE public.levels OWNER TO chrs;

--
-- Name: levels_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE levels_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.levels_pk_seq OWNER TO chrs;

--
-- Name: levels_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE levels_pk_seq OWNED BY levels.pk;


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

ALTER TABLE ONLY feedbacks ALTER COLUMN pk SET DEFAULT nextval('feedbacks_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY levels ALTER COLUMN pk SET DEFAULT nextval('levels_pk_seq'::regclass);


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
201400088	eb9ad4bf48f9a70536f47c0248a85231
201400124	4da49c16db42ca04538d629ef0533fe8
201400058	0f539bb9125b0b68bfe7ea055361b1e1
201400066	f12d545e83acf361a25c654ab230d59c
201400106	ad42c83ac4d3b86de14f207c46a0df0e
201400134	4da49c16db42ca04538d629ef0533fe8
201400136	4da49c16db42ca04538d629ef0533fe8
201400135	a30b5c858285661ce4d16da773e2f252
201400105	c20ad4d76fe97759aa27a0c99bff6710
201400132	4da49c16db42ca04538d629ef0533fe8
201400138	4da49c16db42ca04538d629ef0533fe8
201400140	4da49c16db42ca04538d629ef0533fe8
201400141	4da49c16db42ca04538d629ef0533fe8
201400142	4da49c16db42ca04538d629ef0533fe8
201400143	4da49c16db42ca04538d629ef0533fe8
201400145	467a7a97450140b9cbbd994bda4c20e1
201400144	5610ab033ce8ee7d9abaa00ecb9c09c4
201400139	71a7b76bfb4051a81e312bd9ba911d3b
201400137	d1a3dacfdf45d44616ea58bb8c817ee5
201400078	7e696371179cff5e61c5c0dafda404b2
201400150	02a165b5018fa959b5c9018a487203e7
201400151	4da49c16db42ca04538d629ef0533fe8
201400154	4da49c16db42ca04538d629ef0533fe8
201400125	4da49c16db42ca04538d629ef0533fe8
201400123	4da49c16db42ca04538d629ef0533fe8
201400155	4da49c16db42ca04538d629ef0533fe8
201400156	4da49c16db42ca04538d629ef0533fe8
201400157	4da49c16db42ca04538d629ef0533fe8
201400158	4da49c16db42ca04538d629ef0533fe8
201400152	e10c85476fdfbaa51d77a535d24a9f78
201400159	4da49c16db42ca04538d629ef0533fe8
201400160	4da49c16db42ca04538d629ef0533fe8
201400161	4da49c16db42ca04538d629ef0533fe8
201400072	d3ce41680f4dcb1e999c01a503421a7c
201400162	4da49c16db42ca04538d629ef0533fe8
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
31	Sourcing Recruitment Team	SRT	f
32	Strategic Recruitment Project Management	SRPM	f
\.


--
-- Name: departments_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('departments_pk_seq', 32, true);


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY employees (pk, employee_id, first_name, middle_name, last_name, email_address, archived, date_created, business_email_address, titles_pk, level, department, levels_pk) FROM stdin;
51	201400135	John Gregory	Ducay	Funtera	jgfuntera.chrs@gmail.com	f	2016-04-12 16:08:41.478974+08	john.funtera@chrsglobal.com	\N	Associate	{26}	7
52	201400134	Blu Raven	Lipardo	Villanueva	brvillanueva.chrs@gmail.com	f	2016-04-12 16:08:41.478974+08	blu.villanueva@chrsglobal.com	\N	Associate	{31}	7
53	201400136	Kazylynn	Razo	Catacutan	kcatacutan.chrs@gmail.com	f	2016-04-12 16:08:41.478974+08	kazylynn.catacutan@chrsglobal.com	\N	Associate	{31}	7
54	201400137	Arbie	Castillo	Honra	ahonra.chrs@gmail.com	f	2016-04-22 14:36:12.162891+08	arbie.honra@chrsglobal.com	\N	Associate	{31}	7
55	201400138	Jhon Michel	Alcaide	Lalis	jmlalis.chrs@gmail.com	f	2016-04-22 14:36:12.162891+08	jhon.lalis@chrsglobal.com	\N	Associate	{31}	7
56	201400139	Romarie Joy	Bulawit	Silva	rsilva.chrs@gmail.com	f	2016-04-25 16:56:37.76254+08	romarie.silva@chrsglobal.com	\N	Associate	{32}	7
57	201400140	Lovely	De Leon	Larracas	llarracas.chrs@gmail.com	f	2016-04-25 16:56:37.76254+08	lovely.larracas@chrsglobal.com	\N	Associate	{32}	7
58	201400141	Rochelle Ann	Bellita	Laquinon	ralaquinon.chrs@gmail.com	f	2016-04-25 16:56:37.76254+08	rochelle.laquinon@chrsglobal.com	\N	Associate	{32}	7
59	201400142	Mariam Hazel	Sango	Pugoy	mhpugoy.chrs@gmail.com	f	2016-04-25 16:56:37.76254+08	mariam.pugoy@chrsglobal.com	\N	Associate	{32}	7
60	201400143	John Patrick	Escosio	Purugganan	jppurugganan.chrs@gmail.com	f	2016-04-25 16:56:37.76254+08	john.purugganan@chrsglobal.com	\N	Associate	{30}	7
61	201400144	Romnick	Bedonia	Ilag	rilag.chrs@gmail.com	f	2016-04-25 16:56:37.76254+08	romnick.ilag@chrsglobal.com	\N	Associate	{25}	7
62	201400145	Claire Receli	Morales	Renosa	crrenosa.chrs@gmail.com	f	2016-04-25 16:56:37.76254+08	claire.renosa@chrsglobal.com	\N	Associate	{26}	7
63	201400150	Hannah Lou	Cailing	Apolinar	hlapolimar.chrs@gmail.com	f	2016-05-20 11:34:40.871902+08	hannah.apolinar@chrsglobal.com	21	Associate	{26}	7
71	201400154	Reenalyn	Fediles	Ortilano	rortilano.chrs@gmail.com	f	2016-05-20 11:55:14.912758+08	rennalyn.ortilano@chrsglobal.com	21	Associate	{26}	7
74	201400125	Raquel	Villocino	Trasmonte	rtrasmonte.chrs@gmail.com	f	2016-05-23 12:50:58.383123+08	raquel.trasmonte@chrsglobal.com	17	Associate	{32}	7
76	201400123	Kristia Marie		Velasco	kmvelasco.chrs@gmail.com	f	2016-05-23 12:58:46.584679+08	kristia.velasco@chrsglobal.com	17	Associate	{32}	7
77	201400155	Ken	Espera	Gelisanga	kgelisanga.chrs@gmail.com	f	2016-05-25 11:06:25.026458+08	ken.gelisanga@chrsglobal.com	12	Associate	{32}	7
79	201400157	Frances Therese	Yamongan	Garay	ftgaray.chrs@gmail.com	f	2016-05-25 11:08:33.958727+08	frances.garay@chrsglobal.com	23	Associate	{30}	7
81	201400159	Maria Quiara	Flor	Valenzona	mqvalenzona.chrs@gmail.com	f	2016-05-30 11:53:45.637891+08	maria.valenzona@chrsglobal.com	13	Associate	{26}	7
83	201400161	Jomarie	Dela Cruz	Baun	jbaun.chrs@gmail.com	f	2016-05-30 11:55:47.879323+08	joemarie.baun@chrsglobal.com	13	Associate	{32}	7
22	201400098	Rolando	Garfin	Lipardo	N/A	f	2016-02-14 23:42:40.014678+08	N/A	16	Associate	{23}	7
84	201400162	Girome	Roque	Fernandez	gfernandez.chrs@gmail.com	f	2016-06-02 10:44:04.950151+08	girome.fernandez@chrsglobal.com	13	Associate	{32}	7
10	201000001	Rheyan	Feliciano	Lipardo	waynelipardo.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	wayne.lipardo@gmail.com 	1	C-Level	{20}	1
11	201400066	Judy Ann	Lantican	Reginaldo	jreginaldo.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	N/A	9	Manager	{28}	4
12	201400072	Ken	Villanueva	Tapdasan	ktapdasan.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	bluraven20@gmail.com	18	Associate	{27}	7
13	201400078	Lita	Llanera	Elejido	lelejido.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	lhitaelejido@gmail.com	17	Associate	{28}	7
14	201400081	Vincent	Yturralde	Ramil	vramil.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	N/A	8	Supervisor	{21}	8
15	201400087	Faya Lou	Mahinay	Parenas	fparenas.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	N/A	5	Specialist	{27}	2
16	201400084	Michelle	Balasta	Gongura	mgongura.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	N/A	17	Intern	{21}	3
17	201400088	Arjev	Price	De Los Reyes	adlreyes.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	arjevdelosreyes@gmail.com	4	Asst Manager	{24}	\N
18	201400059	Marilyn May	Villano	Bolocon	mbolocon.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	bolocon.marilynmay@yahoo.com	17	Associate	{21}	7
19	201300004	Mary Grace	Soriano 	Lacerna	gracesoriano.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	N/A	8	Supervisor	{22,29}	8
20	201400089	Ma. Fe	Pariscal	Bolinas	mfbolinas.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	mafe.bolinas@gmail.com	6	Associate	\N	7
21	201400097	Ariel	Dela Cruz	Solis	N/A	f	2016-02-14 23:42:40.014678+08	acsolis10@yahoo.com 	2	Associate	{23}	7
23	201400100	Rolando	Carillo	Fabi	rolly.fabi@chrsglobal.com	f	2016-02-14 23:42:40.014678+08	rollyfabi_23@yahoo.com	3	Supervisor	{23}	8
24	201400102	John Erasmus Mari	Regado	Fernandez	N/A	f	2016-02-14 23:42:40.014678+08	johnerasmusmarif@gmail.com	12	Associate	\N	7
25	201400058	Rodette Joyce	Magaway	Laurio	jlaurio.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	N/A	12	Associate	{28}	7
26	201400103	Gerlie	Pagaduan	Andres	gerlie.andres@chrsglobal.com	f	2016-02-14 23:42:40.014678+08	gerlieandres0201@gmail.com	12	Intern	{24}	3
27	201400104	Eliza	Alcaraz	Mandique	eliza.mandique@chrsglobal.com	f	2016-02-14 23:42:40.014678+08	eliza.mandique@yahoo.com	11	Supervisor	{25}	8
28	201400105	Rafael	Aurelio	Pascual	rafael.pascual@chrsglobal.com	f	2016-02-14 23:42:40.014678+08	rpascual0812@gmail.com	15	Manager	{26}	4
29	201400106	Eralyn May	Bayot	Adino	emadino.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	jinra25@gmail.com	13	Associate	{27}	7
30	201400107	Ana Margarita	Hernandez	Galero	amgalero.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	anamgalero@gmail.com	13	Associate	{27}	7
31	201400108	Irone John	Mendoza	Amor	ijamor.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	ironejohn@gmail.com	13	Associate	{27}	7
32	201400109	Angelica	Barredo	Abaleta	aabelata.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	a.abaleta@yahoo.com	13	Associate	\N	7
33	201400110	Shena Mae	Jardinel	Nava	shena.nava@chrsglobal.com	f	2016-02-14 23:42:40.014678+08	shenamaenavacalma@yahoo.com	13	Associate	{21}	7
34	201400111	Angelyn	Daguro	Cuevas	acuevas.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	angelyn.cuevas1017@gmail.com	13	Associate	{21}	7
35	201400112	Alween Orange	Ceredon	Gemao	aogemao.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	orangegemao@yahoo.com	13	Associate	{21}	7
36	201400113	Aprilil Mae	Denalo	Nefulda	Aprilil.nefulda@chrsglobal.com	f	2016-02-14 23:42:40.014678+08	Aprililmaenefulda@ymail.com	13	Associate	\N	7
37	201400114	Karen	Medo	Esmeralda	kesmeraldo@gmail.com	f	2016-02-14 23:42:40.014678+08	kesmeraldo.chrs@gmail.com	7	Associate	{29}	7
38	201400115	Jennifer	Araneta	Balucay	jbalucay.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	jennbalucay93@gmail.com	7	Associate	{29}	7
39	201400117	Arlene	Diama	Obasa	aobasa.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	obasa_arlene@yahoo.com	7	Associate	{29}	7
40	201400118	Cristina	Tulayan	Ibanez	cibanez.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	tina_041481@yahoo.com	13	Associate	{22,29}	7
41	201400119	Alyssa	Iligan	Panaguiton	apanaguiton.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	panaguitonalyssaend121@gmail.com	13	Associate	{24}	7
42	201400120	Aimee	Gaborni	Legaspi	alegaspi.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	aimeelgsp@icloud.com	13	Associate	{22,29}	7
43	201400121	Kathleen Kay	Macalino	Ongcal	kkongcal.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	kathleen.ongcal@chrsglobal.com	10	Associate	{29}	7
44	201400122	Marry Jeane	Genteroy	Sadsad	mjsadsad.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	marry.sadsad@chrsglobal.com	10	Associate	{29}	7
45	201400126	Michelle	Tan	De Guzman	mdeguzman.chrs@gmail.com	f	2016-03-04 16:14:08.15679+08	michelle.deguzman@chrsglobal.com 	19	Manager	{27}	4
47	201400128	Aleine Leilanie	Braza	Oro	aloro.chrs@gmail.com	f	2016-03-07 12:16:40.262446+08	aleine.oro@chrsglobal.com	20	Officer	{30}	5
48	201400132	Maria Eliza	Querido	De Mesa	medemesa.chrs@gmail.com	f	2016-03-07 16:21:37.202235+08	maria.demesa@chrsglobal.com	17	Associate	{22}	7
49	201400124	Renz	Santiago	Feliciano	rfeliciano.chrs@gmail.com	f	2016-03-08 09:05:10.063741+08	renz.feliciano@chrsglobal.com	12	Associate	{22}	7
64	201400151	Ma. Maxine Estrelle	Mercado	Soliven	mmesoliven.chrs@gmail.com	f	2016-05-20 11:48:09.95915+08	maxine.soliven@chrsglobal.com	23	one	{30}	\N
70	201400152	Grace Lene	Dela Cruz	Bigay	glbigay.chrs@gmail.com	f	2016-05-20 11:53:34.089181+08	grace.bigay@chrsglobal.com	21	Associate	{26}	7
78	201400156	Margaret Stefanie Arielle	Catindig	Gecana	msagecana.chrs@gmail.com	f	2016-05-25 11:07:34.704259+08	margaret.gecana@chrsglobal.com	17	Associate	{32}	7
80	201400158	Roxanne Alyssa	Miel	Chua	rachua.chrs@gmail.com	f	2016-05-25 11:09:11.150361+08	roxanne.chua@chrsglobal.com	23	Associate	{30}	7
82	201400160	Jedaiah Shekinah	Rondilla	Magno	jsmagno.chrs@gmail.com	f	2016-05-30 11:54:51.956072+08	jedaiah.magno@chrsglobal.com	13	Associate	{32}	7
\.


--
-- Data for Name: employees_logs; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY employees_logs (employees_pk, log, created_by, date_created) FROM stdin;
\.


--
-- Name: employees_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('employees_pk_seq', 84, true);


--
-- Data for Name: employees_titles; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY employees_titles (employees_pk, titles_pk, created_by, date_created) FROM stdin;
10	1	28	2016-04-01 10:47:37.613835+08
11	9	28	2016-04-01 10:47:37.613835+08
12	18	28	2016-04-01 10:47:37.613835+08
12	14	28	2016-04-01 10:47:37.613835+08
13	17	28	2016-04-01 10:47:37.613835+08
14	8	28	2016-04-01 10:47:37.613835+08
15	5	28	2016-04-01 10:47:37.613835+08
16	17	28	2016-04-01 10:47:37.613835+08
17	4	28	2016-04-01 10:47:37.613835+08
18	17	28	2016-04-01 10:47:37.613835+08
19	8	28	2016-04-01 10:47:37.613835+08
20	6	28	2016-04-01 10:47:37.613835+08
21	2	28	2016-04-01 10:47:37.613835+08
22	16	28	2016-04-01 10:47:37.613835+08
23	3	28	2016-04-01 10:47:37.613835+08
24	12	28	2016-04-01 10:47:37.613835+08
25	12	28	2016-04-01 10:47:37.613835+08
26	12	28	2016-04-01 10:47:37.613835+08
27	11	28	2016-04-01 10:47:37.613835+08
28	15	28	2016-04-01 10:47:37.613835+08
29	13	28	2016-04-01 10:47:37.613835+08
30	13	28	2016-04-01 10:47:37.613835+08
31	13	28	2016-04-01 10:47:37.613835+08
32	13	28	2016-04-01 10:47:37.613835+08
33	13	28	2016-04-01 10:47:37.613835+08
34	13	28	2016-04-01 10:47:37.613835+08
35	13	28	2016-04-01 10:47:37.613835+08
36	13	28	2016-04-01 10:47:37.613835+08
37	7	28	2016-04-01 10:47:37.613835+08
38	7	28	2016-04-01 10:47:37.613835+08
39	7	28	2016-04-01 10:47:37.613835+08
40	13	28	2016-04-01 10:47:37.613835+08
41	13	28	2016-04-01 10:47:37.613835+08
42	13	28	2016-04-01 10:47:37.613835+08
43	10	28	2016-04-01 10:47:37.613835+08
44	10	28	2016-04-01 10:47:37.613835+08
51	21	28	2016-04-12 16:08:41.478974+08
52	12	28	2016-04-12 16:08:41.478974+08
53	12	28	2016-04-12 16:08:41.478974+08
54	13	28	2016-04-22 14:36:12.162891+08
55	13	28	2016-04-22 14:36:12.162891+08
56	22	28	2016-04-25 16:56:37.76254+08
57	13	28	2016-04-25 16:56:37.76254+08
58	13	28	2016-04-25 16:56:37.76254+08
59	13	28	2016-04-25 16:56:37.76254+08
60	23	28	2016-04-25 16:56:37.76254+08
61	24	28	2016-04-25 16:56:37.76254+08
62	21	28	2016-04-25 16:56:37.76254+08
\.


--
-- Data for Name: feedbacks; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY feedbacks (pk, feedback, tool, date_created) FROM stdin;
1	Thank you Sir Raffy and Ken!	Integrity	2016-03-14 16:42:08.810302+08
2	test	Integrity	2016-03-14 16:42:19.29554+08
3	testing 1, 2, 3.... thank you!	Integrity	2016-03-14 16:42:42.366992+08
4	Hi IIT,\n\nIs it possible if after we put the Employee ID and Password, once we hit enter it will redirect to Log in/ Log out page. It will be easy if that happens. Today, what we are doing is fill up the EID and Password then click LOG IN. It's a bit easy for us if we just click enter..Thank you in Advance.	Integrity	2016-03-14 16:44:18.359596+08
5	This is noted sir Raffy and sir Ken. Thanks ^^	Integrity	2016-03-14 16:44:30.219141+08
6	Hi IIT,\n\nIS it possible if you just put comment box instead of the clicking randomly the arrow . It will be easy if we will just comment on a comment box then send than your  email / website admin. Thank you!	Integrity	2016-03-14 16:47:37.63648+08
7	Test	Integrity	2016-03-14 16:49:42.539907+08
8	HI IIT,\n\nKen told us that the time that will be tagged as accurate is the server's time. So is it possible if we just all have the same time so that nobody is confuse if they LOG iN / OUT on time.\n\nThank you.	Integrity	2016-03-14 16:53:10.605274+08
9	Hi IIT,\n\nIs it ok if you also put confirmation etc.. once you received the comments so that we are aware that you are on it.\n\nThank you!	Integrity	2016-03-14 17:02:49.828353+08
10	TEST KEN PO ITO	Integrity	2016-03-14 17:05:12.564535+08
11	Test IT	Integrity	2016-03-14 17:19:44.52022+08
12	h	Integrity	2016-03-14 18:04:05.267826+08
13	h	Integrity	2016-03-14 18:04:05.861784+08
14	h	Integrity	2016-03-14 18:04:06.647967+08
15	ang galing nito =)	Integrity	2016-03-15 08:33:35.625108+08
16	Hi IIT,\n\nI saw the updates but after while, it has disappeared. It is possible if you just put/add updates button or link so that we can view the latest updates?\n\nThank you!	Integrity	2016-03-15 08:37:26.212678+08
17	Test IT	Integrity	2016-03-15 10:56:49.334222+08
18	Invalid Date by Ken ahhhahaa	Integrity	2016-03-15 12:32:33.799145+08
19	Auto hide comment box when in time sheet	Integrity	2016-03-29 12:51:44.854234+08
20	Sana sabihin din nya yung name nung staff. haha.	Integrity	2016-04-05 09:02:12.80897+08
21	Ken is hiding from my screen.	Integrity	2016-04-06 17:50:47.91428+08
22	Ken is still hiding.	Integrity	2016-04-07 17:57:23.753706+08
23	HELLO IIT	Integrity	2016-04-21 17:59:57.85154+08
24	HI IIT	Integrity	2016-05-04 08:33:53.30328+08
25	I LOVE IIT	Integrity	2016-05-16 15:35:51.612029+08
\.


--
-- Name: feedbacks_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('feedbacks_pk_seq', 25, true);


--
-- Data for Name: groupings; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY groupings (employees_pk, supervisor_pk) FROM stdin;
32	11
29	45
31	45
26	17
20	10
18	14
34	14
45	11
17	10
48	19
13	11
23	10
49	19
24	19
30	45
35	14
16	14
40	19
19	10
25	11
42	19
22	10
27	10
33	14
36	11
47	10
41	17
15	10
28	10
14	45
11	10
21	10
12	28
\.


--
-- Data for Name: levels; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY levels (pk, level_title, archived) FROM stdin;
1	C-Level	f
2	Specialist	f
3	Intern	f
4	Manager	f
5	Officer	f
6	Assistant Manager	f
7	Associate	f
8	Supervisor	f
\.


--
-- Name: levels_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('levels_pk_seq', 8, true);


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
12	In	2016-03-09 08:06:46.079569+08	2016-03-09 08:06:46.079569+08
17	In	2016-03-09 08:06:53.660195+08	2016-03-09 08:06:53.660195+08
28	In	2016-03-09 08:08:44.78807+08	2016-03-09 08:08:44.78807+08
23	In	2016-03-09 08:21:20.347626+08	2016-03-09 08:21:20.347626+08
31	In	2016-03-09 08:29:36.219485+08	2016-03-09 08:29:36.219485+08
30	In	2016-03-09 08:30:12.965671+08	2016-03-09 08:30:12.965671+08
48	In	2016-03-09 08:31:39.121183+08	2016-03-09 08:31:39.121183+08
29	In	2016-03-09 08:31:55.125098+08	2016-03-09 08:31:55.125098+08
26	In	2016-03-09 08:37:16.919228+08	2016-03-09 08:37:16.919228+08
41	In	2016-03-09 08:38:09.344533+08	2016-03-09 08:38:09.344533+08
13	In	2016-03-09 08:42:18.405864+08	2016-03-09 08:42:18.405864+08
49	In	2016-03-09 08:46:45.819279+08	2016-03-09 08:46:45.819279+08
45	In	2016-03-09 08:49:11.374376+08	2016-03-09 08:49:11.374376+08
11	In	2016-03-09 08:49:23.881355+08	2016-03-09 08:49:23.881355+08
27	In	2016-03-09 08:54:20.063233+08	2016-03-09 08:54:20.063233+08
25	In	2016-03-09 08:57:19.024815+08	2016-03-09 08:57:19.024815+08
47	In	2016-03-09 09:27:19.913748+08	2016-03-09 09:27:19.913748+08
26	Out	2016-03-09 12:02:59.806342+08	2016-03-09 12:02:59.806342+08
31	Out	2016-03-09 12:32:22.383675+08	2016-03-09 12:32:22.383675+08
11	Out	2016-03-09 18:01:07.625127+08	2016-03-09 18:01:07.625127+08
13	Out	2016-03-09 18:01:12.751326+08	2016-03-09 18:01:12.751326+08
25	Out	2016-03-09 18:01:25.902944+08	2016-03-09 18:01:25.902944+08
29	Out	2016-03-09 18:01:27.118232+08	2016-03-09 18:01:27.118232+08
48	Out	2016-03-09 18:01:45.868335+08	2016-03-09 18:01:45.868335+08
45	Out	2016-03-09 18:01:46.108938+08	2016-03-09 18:01:46.108938+08
30	Out	2016-03-09 18:02:12.242193+08	2016-03-09 18:02:12.242193+08
12	Out	2016-03-09 18:02:17.309037+08	2016-03-09 18:02:17.309037+08
27	Out	2016-03-09 18:02:48.83869+08	2016-03-09 18:02:48.83869+08
49	Out	2016-03-09 18:03:24.581094+08	2016-03-09 18:03:24.581094+08
41	Out	2016-03-09 18:03:32.045939+08	2016-03-09 18:03:32.045939+08
28	Out	2016-03-09 18:05:04.015258+08	2016-03-09 18:05:04.015258+08
23	Out	2016-03-09 18:08:21.60687+08	2016-03-09 18:08:21.60687+08
17	Out	2016-03-09 18:09:48.744238+08	2016-03-09 18:09:48.744238+08
47	Out	2016-03-09 18:14:50.421847+08	2016-03-09 18:14:50.421847+08
12	In	2016-03-10 08:08:21.286732+08	2016-03-10 08:08:21.286732+08
48	In	2016-03-10 08:14:53.8154+08	2016-03-10 08:14:53.8154+08
23	In	2016-03-10 08:15:31.732057+08	2016-03-10 08:15:31.732057+08
45	In	2016-03-10 08:39:17.902291+08	2016-03-10 08:39:17.902291+08
41	In	2016-03-10 08:41:43.452194+08	2016-03-10 08:41:43.452194+08
27	In	2016-03-10 08:47:17.799341+08	2016-03-10 08:47:17.799341+08
13	In	2016-03-10 08:52:30.926099+08	2016-03-10 08:52:30.926099+08
31	In	2016-03-10 08:55:01.836529+08	2016-03-10 08:55:01.836529+08
25	In	2016-03-10 08:55:23.542947+08	2016-03-10 08:55:23.542947+08
49	In	2016-03-10 08:56:16.191523+08	2016-03-10 08:56:16.191523+08
18	In	2016-03-10 08:57:01.95203+08	2016-03-10 08:57:01.95203+08
11	In	2016-03-10 08:57:28.853825+08	2016-03-10 08:57:28.853825+08
47	In	2016-03-10 09:03:07.179996+08	2016-03-10 09:03:07.179996+08
30	In	2016-03-10 09:10:03.817918+08	2016-03-10 09:10:03.817918+08
28	In	2016-03-10 09:26:29.396469+08	2016-03-10 09:26:29.396469+08
45	Out	2016-03-10 18:01:07.835067+08	2016-03-10 18:01:07.835067+08
25	Out	2016-03-10 18:01:10.059256+08	2016-03-10 18:01:10.059256+08
27	Out	2016-03-10 18:01:13.064483+08	2016-03-10 18:01:13.064483+08
13	Out	2016-03-10 18:01:19.835705+08	2016-03-10 18:01:19.835705+08
18	Out	2016-03-10 18:01:58.583646+08	2016-03-10 18:01:58.583646+08
30	Out	2016-03-10 18:02:02.34444+08	2016-03-10 18:02:02.34444+08
11	Out	2016-03-10 18:02:25.257013+08	2016-03-10 18:02:25.257013+08
49	Out	2016-03-10 18:02:45.623767+08	2016-03-10 18:02:45.623767+08
48	Out	2016-03-10 18:02:49.249402+08	2016-03-10 18:02:49.249402+08
31	Out	2016-03-10 18:02:54.355785+08	2016-03-10 18:02:54.355785+08
12	Out	2016-03-10 18:03:18.650026+08	2016-03-10 18:03:18.650026+08
41	Out	2016-03-10 18:03:51.642928+08	2016-03-10 18:03:51.642928+08
47	Out	2016-03-10 18:04:29.971105+08	2016-03-10 18:04:29.971105+08
23	Out	2016-03-10 18:05:03.441096+08	2016-03-10 18:05:03.441096+08
28	Out	2016-03-10 18:07:12.429724+08	2016-03-10 18:07:12.429724+08
12	In	2016-03-11 08:12:34.201064+08	2016-03-11 08:12:34.201064+08
23	In	2016-03-11 08:19:10.012559+08	2016-03-11 08:19:10.012559+08
41	In	2016-03-11 08:22:35.568642+08	2016-03-11 08:22:35.568642+08
13	In	2016-03-11 08:36:14.65055+08	2016-03-11 08:36:14.65055+08
48	In	2016-03-11 08:37:09.385816+08	2016-03-11 08:37:09.385816+08
31	In	2016-03-11 08:38:00.314793+08	2016-03-11 08:38:00.314793+08
30	In	2016-03-11 08:39:46.383491+08	2016-03-11 08:39:46.383491+08
25	In	2016-03-11 08:39:56.023258+08	2016-03-11 08:39:56.023258+08
29	In	2016-03-11 08:42:37.739374+08	2016-03-11 08:42:37.739374+08
18	In	2016-03-11 08:44:44.469666+08	2016-03-11 08:44:44.469666+08
27	In	2016-03-11 08:49:47.017686+08	2016-03-11 08:49:47.017686+08
17	In	2016-03-11 08:50:13.212604+08	2016-03-11 08:50:13.212604+08
26	In	2016-03-11 08:51:26.883888+08	2016-03-11 08:51:26.883888+08
49	In	2016-03-11 08:51:42.463487+08	2016-03-11 08:51:42.463487+08
47	In	2016-03-11 09:57:54.666476+08	2016-03-11 09:57:54.666476+08
28	In	2016-03-11 10:13:22.117739+08	2016-03-11 10:13:22.117739+08
31	Out	2016-03-11 12:00:26.315334+08	2016-03-11 12:00:26.315334+08
26	Out	2016-03-11 15:04:31.230723+08	2016-03-11 15:04:31.230723+08
12	Out	2016-03-11 18:01:06.553253+08	2016-03-11 18:01:06.553253+08
18	Out	2016-03-11 18:01:15.617209+08	2016-03-11 18:01:15.617209+08
25	Out	2016-03-11 18:01:18.279081+08	2016-03-11 18:01:18.279081+08
49	Out	2016-03-11 18:01:32.63643+08	2016-03-11 18:01:32.63643+08
30	Out	2016-03-11 18:02:06.350798+08	2016-03-11 18:02:06.350798+08
29	Out	2016-03-11 18:02:06.503671+08	2016-03-11 18:02:06.503671+08
13	Out	2016-03-11 18:02:15.631252+08	2016-03-11 18:02:15.631252+08
48	Out	2016-03-11 18:03:00.74648+08	2016-03-11 18:03:00.74648+08
23	Out	2016-03-11 18:06:53.532476+08	2016-03-11 18:06:53.532476+08
41	Out	2016-03-11 18:08:45.589858+08	2016-03-11 18:08:45.589858+08
28	Out	2016-03-11 18:10:33.144677+08	2016-03-11 18:10:33.144677+08
27	Out	2016-03-11 18:27:05.701007+08	2016-03-11 18:27:05.701007+08
17	Out	2016-03-11 18:28:54.887335+08	2016-03-11 18:28:54.887335+08
47	Out	2016-03-11 18:40:04.006515+08	2016-03-11 18:40:04.006515+08
17	In	2016-03-14 08:11:46.989462+08	2016-03-14 08:11:46.989462+08
13	In	2016-03-14 08:17:58.163837+08	2016-03-14 08:17:58.163837+08
48	In	2016-03-14 08:27:40.628915+08	2016-03-14 08:27:40.628915+08
47	In	2016-03-14 08:32:52.258614+08	2016-03-14 08:32:52.258614+08
12	In	2016-03-14 08:33:27.665949+08	2016-03-14 08:33:27.665949+08
23	In	2016-03-14 08:35:07.450826+08	2016-03-14 08:35:07.450826+08
26	In	2016-03-14 08:37:19.051809+08	2016-03-14 08:37:19.051809+08
11	In	2016-03-14 08:47:46.942627+08	2016-03-14 08:47:46.942627+08
31	In	2016-03-14 08:49:33.913787+08	2016-03-14 08:49:33.913787+08
49	In	2016-03-14 08:54:20.967259+08	2016-03-14 08:54:20.967259+08
25	In	2016-03-14 08:57:32.294901+08	2016-03-14 08:57:32.294901+08
18	In	2016-03-14 08:57:33.020417+08	2016-03-14 08:57:33.020417+08
41	In	2016-03-14 09:03:07.951858+08	2016-03-14 09:03:07.951858+08
45	In	2016-03-14 09:05:55.284703+08	2016-03-14 09:05:55.284703+08
29	In	2016-03-14 09:26:31.957886+08	2016-03-14 09:26:31.957886+08
28	In	2016-03-14 10:34:22.742001+08	2016-03-14 10:34:22.742001+08
41	Out	2016-03-14 14:02:58.384643+08	2016-03-14 14:02:58.384643+08
31	Out	2016-03-14 15:00:38.460235+08	2016-03-14 15:00:38.460235+08
26	Out	2016-03-14 15:15:22.570651+08	2016-03-14 15:15:22.570651+08
18	Out	2016-03-14 18:00:31.56844+08	2016-03-14 18:00:31.56844+08
14	In	2016-03-14 18:01:07.652447+08	2016-03-14 18:01:07.652447+08
14	Out	2016-03-14 18:01:19.325624+08	2016-03-14 18:01:19.325624+08
29	Out	2016-03-14 18:01:26.689293+08	2016-03-14 18:01:26.689293+08
25	Out	2016-03-14 18:01:47.076519+08	2016-03-14 18:01:47.076519+08
45	Out	2016-03-14 18:02:24.257926+08	2016-03-14 18:02:24.257926+08
48	Out	2016-03-14 18:03:01.604868+08	2016-03-14 18:03:01.604868+08
49	Out	2016-03-14 18:03:06.618855+08	2016-03-14 18:03:06.618855+08
12	Out	2016-03-14 18:03:30.986371+08	2016-03-14 18:03:30.986371+08
23	Out	2016-03-14 18:04:45.277494+08	2016-03-14 18:04:45.277494+08
13	Out	2016-03-14 18:05:14.421847+08	2016-03-14 18:05:14.421847+08
47	Out	2016-03-14 18:11:41.012984+08	2016-03-14 18:11:41.012984+08
28	Out	2016-03-14 18:17:33.66347+08	2016-03-14 18:17:33.66347+08
17	Out	2016-03-14 18:18:33.413642+08	2016-03-14 18:18:33.413642+08
11	Out	2016-03-14 18:27:43.432264+08	2016-03-14 18:27:43.432264+08
12	In	2016-03-15 08:29:51.406623+08	2016-03-15 08:29:51.406623+08
23	In	2016-03-15 08:32:40.878887+08	2016-03-15 08:32:40.878887+08
17	In	2016-03-15 08:33:09.102709+08	2016-03-15 08:33:09.102709+08
30	In	2016-03-15 08:33:55.797125+08	2016-03-15 08:33:55.797125+08
13	In	2016-03-15 08:34:39.162213+08	2016-03-15 08:34:39.162213+08
26	In	2016-03-15 08:34:45.345139+08	2016-03-15 08:34:45.345139+08
11	In	2016-03-15 08:35:54.207922+08	2016-03-15 08:35:54.207922+08
45	In	2016-03-15 08:43:38.779372+08	2016-03-15 08:43:38.779372+08
48	In	2016-03-15 08:45:45.934358+08	2016-03-15 08:45:45.934358+08
49	In	2016-03-15 08:45:54.354628+08	2016-03-15 08:45:54.354628+08
25	In	2016-03-15 08:55:22.442989+08	2016-03-15 08:55:22.442989+08
28	In	2016-03-15 08:58:21.552821+08	2016-03-15 08:58:21.552821+08
18	In	2016-03-15 08:58:21.788711+08	2016-03-15 08:58:21.788711+08
47	In	2016-03-15 08:59:47.454525+08	2016-03-15 08:59:47.454525+08
27	In	2016-03-15 09:00:06.081569+08	2016-03-15 09:00:06.081569+08
31	In	2016-03-15 09:16:11.397366+08	2016-03-15 09:16:11.397366+08
14	In	2016-03-15 10:22:39.32245+08	2016-03-15 10:22:39.32245+08
41	In	2016-03-15 12:20:02.74709+08	2016-03-15 12:20:02.74709+08
14	Out	2016-03-15 18:00:10.238044+08	2016-03-15 18:00:10.238044+08
18	Out	2016-03-15 18:00:28.246801+08	2016-03-15 18:00:28.246801+08
26	Out	2016-03-15 18:00:39.566658+08	2016-03-15 18:00:39.566658+08
11	Out	2016-03-15 18:00:50.558513+08	2016-03-15 18:00:50.558513+08
13	Out	2016-03-15 18:01:23.769035+08	2016-03-15 18:01:23.769035+08
25	Out	2016-03-15 18:01:31.284877+08	2016-03-15 18:01:31.284877+08
48	Out	2016-03-15 18:02:17.533463+08	2016-03-15 18:02:17.533463+08
49	Out	2016-03-15 18:02:21.973899+08	2016-03-15 18:02:21.973899+08
45	Out	2016-03-15 18:02:27.922423+08	2016-03-15 18:02:27.922423+08
27	Out	2016-03-15 18:03:07.622815+08	2016-03-15 18:03:07.622815+08
30	Out	2016-03-15 18:03:29.915366+08	2016-03-15 18:03:29.915366+08
28	Out	2016-03-15 18:04:16.949017+08	2016-03-15 18:04:16.949017+08
41	Out	2016-03-15 18:06:39.423104+08	2016-03-15 18:06:39.423104+08
47	Out	2016-03-15 18:07:04.913142+08	2016-03-15 18:07:04.913142+08
23	Out	2016-03-15 18:09:52.849111+08	2016-03-15 18:09:52.849111+08
12	Out	2016-03-15 18:13:28.967216+08	2016-03-15 18:13:28.967216+08
17	Out	2016-03-15 18:15:21.933326+08	2016-03-15 18:15:21.933326+08
23	In	2016-03-16 08:29:42.377445+08	2016-03-16 08:29:42.377445+08
49	In	2016-03-16 08:29:49.812563+08	2016-03-16 08:29:49.812563+08
13	In	2016-03-16 08:30:43.779505+08	2016-03-16 08:30:43.779505+08
17	In	2016-03-16 08:31:11.57996+08	2016-03-16 08:31:11.57996+08
12	In	2016-03-16 08:33:13.823473+08	2016-03-16 08:33:13.823473+08
28	In	2016-03-16 08:35:26.89744+08	2016-03-16 08:35:26.89744+08
26	In	2016-03-16 08:38:32.320586+08	2016-03-16 08:38:32.320586+08
30	In	2016-03-16 08:40:12.553996+08	2016-03-16 08:40:12.553996+08
27	In	2016-03-16 08:44:02.022982+08	2016-03-16 08:44:02.022982+08
45	In	2016-03-16 08:45:11.997272+08	2016-03-16 08:45:11.997272+08
48	In	2016-03-16 08:45:40.583839+08	2016-03-16 08:45:40.583839+08
25	In	2016-03-16 08:53:13.981247+08	2016-03-16 08:53:13.981247+08
31	In	2016-03-16 08:58:55.471389+08	2016-03-16 08:58:55.471389+08
29	In	2016-03-16 08:59:22.356928+08	2016-03-16 08:59:22.356928+08
18	In	2016-03-16 09:00:05.085766+08	2016-03-16 09:00:05.085766+08
47	In	2016-03-16 09:00:06.254507+08	2016-03-16 09:00:06.254507+08
14	In	2016-03-16 09:00:06.304911+08	2016-03-16 09:00:06.304911+08
11	In	2016-03-16 09:36:08.433434+08	2016-03-16 09:36:08.433434+08
28	Out	2016-03-16 18:00:11.348497+08	2016-03-16 18:00:11.348497+08
14	Out	2016-03-16 18:00:28.314771+08	2016-03-16 18:00:28.314771+08
18	Out	2016-03-16 18:00:50.167063+08	2016-03-16 18:00:50.167063+08
13	Out	2016-03-16 18:01:08.177691+08	2016-03-16 18:01:08.177691+08
29	Out	2016-03-16 18:01:12.497318+08	2016-03-16 18:01:12.497318+08
45	Out	2016-03-16 18:01:12.815341+08	2016-03-16 18:01:12.815341+08
25	Out	2016-03-16 18:01:19.991618+08	2016-03-16 18:01:19.991618+08
48	Out	2016-03-16 18:01:20.214023+08	2016-03-16 18:01:20.214023+08
27	Out	2016-03-16 18:01:21.363691+08	2016-03-16 18:01:21.363691+08
31	Out	2016-03-16 18:01:22.613237+08	2016-03-16 18:01:22.613237+08
23	Out	2016-03-16 18:01:52.158886+08	2016-03-16 18:01:52.158886+08
11	Out	2016-03-16 18:01:53.315769+08	2016-03-16 18:01:53.315769+08
49	Out	2016-03-16 18:02:07.769811+08	2016-03-16 18:02:07.769811+08
30	Out	2016-03-16 18:02:36.339319+08	2016-03-16 18:02:36.339319+08
12	Out	2016-03-16 18:05:29.121666+08	2016-03-16 18:05:29.121666+08
26	Out	2016-03-16 18:05:48.65759+08	2016-03-16 18:05:48.65759+08
47	Out	2016-03-16 18:09:14.474942+08	2016-03-16 18:09:14.474942+08
17	Out	2016-03-16 18:10:04.157684+08	2016-03-16 18:10:04.157684+08
17	In	2016-03-17 07:54:45.502067+08	2016-03-17 07:54:45.502067+08
23	In	2016-03-17 08:02:43.727526+08	2016-03-17 08:02:43.727526+08
41	In	2016-03-17 08:15:33.328362+08	2016-03-17 08:15:33.328362+08
30	In	2016-03-17 08:16:08.796353+08	2016-03-17 08:16:08.796353+08
49	In	2016-03-17 08:17:38.629033+08	2016-03-17 08:17:38.629033+08
48	In	2016-03-17 08:22:18.413523+08	2016-03-17 08:22:18.413523+08
31	In	2016-03-17 08:23:09.646281+08	2016-03-17 08:23:09.646281+08
13	In	2016-03-17 08:30:40.162144+08	2016-03-17 08:30:40.162144+08
14	In	2016-03-17 08:36:16.97132+08	2016-03-17 08:36:16.97132+08
45	In	2016-03-17 08:38:49.910028+08	2016-03-17 08:38:49.910028+08
11	In	2016-03-17 08:44:27.808084+08	2016-03-17 08:44:27.808084+08
26	In	2016-03-17 08:48:53.971595+08	2016-03-17 08:48:53.971595+08
25	In	2016-03-17 08:55:11.582442+08	2016-03-17 08:55:11.582442+08
27	In	2016-03-17 08:58:02.690499+08	2016-03-17 08:58:02.690499+08
47	In	2016-03-17 09:05:16.946346+08	2016-03-17 09:05:16.946346+08
12	In	2016-03-17 10:10:56.814548+08	2016-03-17 10:10:56.814548+08
14	Out	2016-03-17 18:00:24.938962+08	2016-03-17 18:00:24.938962+08
13	Out	2016-03-17 18:01:04.68181+08	2016-03-17 18:01:04.68181+08
12	Out	2016-03-17 18:01:06.227494+08	2016-03-17 18:01:06.227494+08
25	Out	2016-03-17 18:01:14.691661+08	2016-03-17 18:01:14.691661+08
49	Out	2016-03-17 18:01:17.381683+08	2016-03-17 18:01:17.381683+08
11	Out	2016-03-17 18:01:30.034393+08	2016-03-17 18:01:30.034393+08
26	Out	2016-03-17 18:01:32.569852+08	2016-03-17 18:01:32.569852+08
41	Out	2016-03-17 18:01:32.881601+08	2016-03-17 18:01:32.881601+08
48	Out	2016-03-17 18:01:44.431572+08	2016-03-17 18:01:44.431572+08
27	Out	2016-03-17 18:01:44.998679+08	2016-03-17 18:01:44.998679+08
45	Out	2016-03-17 18:02:08.989686+08	2016-03-17 18:02:08.989686+08
17	Out	2016-03-17 18:02:17.290473+08	2016-03-17 18:02:17.290473+08
30	Out	2016-03-17 18:02:21.736939+08	2016-03-17 18:02:21.736939+08
23	Out	2016-03-17 18:03:10.269585+08	2016-03-17 18:03:10.269585+08
47	Out	2016-03-17 18:11:00.579275+08	2016-03-17 18:11:00.579275+08
17	In	2016-03-18 07:55:48.012607+08	2016-03-18 07:55:48.012607+08
41	In	2016-03-18 07:58:12.276298+08	2016-03-18 07:58:12.276298+08
12	In	2016-03-18 07:58:13.925684+08	2016-03-18 07:58:13.925684+08
23	In	2016-03-18 07:58:55.570176+08	2016-03-18 07:58:55.570176+08
48	In	2016-03-18 08:03:04.738518+08	2016-03-18 08:03:04.738518+08
11	In	2016-03-18 08:29:01.815908+08	2016-03-18 08:29:01.815908+08
13	In	2016-03-18 08:29:13.322317+08	2016-03-18 08:29:13.322317+08
27	In	2016-03-18 08:43:29.208813+08	2016-03-18 08:43:29.208813+08
31	In	2016-03-18 08:52:47.370684+08	2016-03-18 08:52:47.370684+08
47	In	2016-03-18 08:55:38.313968+08	2016-03-18 08:55:38.313968+08
49	In	2016-03-18 08:58:06.000613+08	2016-03-18 08:58:06.000613+08
45	In	2016-03-18 09:01:17.877661+08	2016-03-18 09:01:17.877661+08
29	In	2016-03-18 09:04:13.250613+08	2016-03-18 09:04:13.250613+08
41	Out	2016-03-18 13:01:12.090359+08	2016-03-18 13:01:12.090359+08
26	In	2016-03-18 13:12:31.536511+08	2016-03-18 13:12:31.536511+08
31	Out	2016-03-18 18:00:21.351515+08	2016-03-18 18:00:21.351515+08
45	Out	2016-03-18 18:01:04.354215+08	2016-03-18 18:01:04.354215+08
27	Out	2016-03-18 18:01:04.879793+08	2016-03-18 18:01:04.879793+08
17	Out	2016-03-18 18:01:15.004679+08	2016-03-18 18:01:15.004679+08
26	Out	2016-03-18 18:01:16.728555+08	2016-03-18 18:01:16.728555+08
49	Out	2016-03-18 18:01:26.298157+08	2016-03-18 18:01:26.298157+08
48	Out	2016-03-18 18:01:27.861004+08	2016-03-18 18:01:27.861004+08
13	Out	2016-03-18 18:01:30.266776+08	2016-03-18 18:01:30.266776+08
29	Out	2016-03-18 18:01:56.249297+08	2016-03-18 18:01:56.249297+08
47	Out	2016-03-18 18:02:03.919263+08	2016-03-18 18:02:03.919263+08
23	Out	2016-03-18 18:02:12.069032+08	2016-03-18 18:02:12.069032+08
11	Out	2016-03-18 18:03:55.741329+08	2016-03-18 18:03:55.741329+08
12	Out	2016-03-18 18:05:26.719028+08	2016-03-18 18:05:26.719028+08
17	In	2016-03-21 08:20:00.377247+08	2016-03-21 08:20:00.377247+08
23	In	2016-03-21 08:21:18.184735+08	2016-03-21 08:21:18.184735+08
12	In	2016-03-21 08:21:25.295973+08	2016-03-21 08:21:25.295973+08
48	In	2016-03-21 08:28:45.48815+08	2016-03-21 08:28:45.48815+08
18	In	2016-03-21 08:31:22.421313+08	2016-03-21 08:31:22.421313+08
45	In	2016-03-21 08:33:34.825433+08	2016-03-21 08:33:34.825433+08
31	In	2016-03-21 08:34:40.657143+08	2016-03-21 08:34:40.657143+08
13	In	2016-03-21 08:36:58.891765+08	2016-03-21 08:36:58.891765+08
49	In	2016-03-21 08:37:26.811842+08	2016-03-21 08:37:26.811842+08
14	In	2016-03-21 08:40:58.688181+08	2016-03-21 08:40:58.688181+08
25	In	2016-03-21 08:41:37.851606+08	2016-03-21 08:41:37.851606+08
11	In	2016-03-21 08:45:40.85635+08	2016-03-21 08:45:40.85635+08
47	In	2016-03-21 08:53:15.071893+08	2016-03-21 08:53:15.071893+08
28	In	2016-03-21 09:47:50.892338+08	2016-03-21 09:47:50.892338+08
30	In	2016-03-21 09:53:43.366085+08	2016-03-21 09:53:43.366085+08
31	Out	2016-03-21 12:05:47.714627+08	2016-03-21 12:05:47.714627+08
27	In	2016-03-21 12:53:20.012747+08	2016-03-21 12:53:20.012747+08
14	Out	2016-03-21 18:00:18.77605+08	2016-03-21 18:00:18.77605+08
27	Out	2016-03-21 18:00:41.124066+08	2016-03-21 18:00:41.124066+08
47	Out	2016-03-21 18:00:41.855236+08	2016-03-21 18:00:41.855236+08
45	Out	2016-03-21 18:01:14.783806+08	2016-03-21 18:01:14.783806+08
18	Out	2016-03-21 18:01:23.743311+08	2016-03-21 18:01:23.743311+08
30	Out	2016-03-21 18:01:47.703159+08	2016-03-21 18:01:47.703159+08
25	Out	2016-03-21 18:01:49.434722+08	2016-03-21 18:01:49.434722+08
48	Out	2016-03-21 18:01:54.293603+08	2016-03-21 18:01:54.293603+08
12	Out	2016-03-21 18:01:54.865378+08	2016-03-21 18:01:54.865378+08
49	Out	2016-03-21 18:02:08.066764+08	2016-03-21 18:02:08.066764+08
17	Out	2016-03-21 18:02:43.915758+08	2016-03-21 18:02:43.915758+08
23	Out	2016-03-21 18:03:10.753245+08	2016-03-21 18:03:10.753245+08
13	Out	2016-03-21 18:03:23.840138+08	2016-03-21 18:03:23.840138+08
11	Out	2016-03-21 18:03:48.952572+08	2016-03-21 18:03:48.952572+08
28	Out	2016-03-21 18:05:40.971076+08	2016-03-21 18:05:40.971076+08
12	In	2016-03-22 07:58:17.490387+08	2016-03-22 07:58:17.490387+08
23	In	2016-03-22 07:59:54.023102+08	2016-03-22 07:59:54.023102+08
17	In	2016-03-22 08:02:01.823022+08	2016-03-22 08:02:01.823022+08
48	In	2016-03-22 08:15:58.43541+08	2016-03-22 08:15:58.43541+08
45	In	2016-03-22 08:28:53.877342+08	2016-03-22 08:28:53.877342+08
13	In	2016-03-22 08:36:09.544879+08	2016-03-22 08:36:09.544879+08
11	In	2016-03-22 08:36:54.94274+08	2016-03-22 08:36:54.94274+08
27	In	2016-03-22 08:39:55.649857+08	2016-03-22 08:39:55.649857+08
25	In	2016-03-22 08:49:33.61894+08	2016-03-22 08:49:33.61894+08
18	In	2016-03-22 08:52:05.830761+08	2016-03-22 08:52:05.830761+08
14	In	2016-03-22 08:53:56.707886+08	2016-03-22 08:53:56.707886+08
49	In	2016-03-22 08:56:18.474501+08	2016-03-22 08:56:18.474501+08
26	In	2016-03-22 08:57:52.365145+08	2016-03-22 08:57:52.365145+08
47	In	2016-03-22 09:02:30.611779+08	2016-03-22 09:02:30.611779+08
28	In	2016-03-22 09:33:08.131855+08	2016-03-22 09:33:08.131855+08
17	Out	2016-03-22 13:29:27.321507+08	2016-03-22 13:29:27.321507+08
31	In	2016-03-22 13:36:07.23018+08	2016-03-22 13:36:07.23018+08
31	Out	2016-03-22 18:00:08.907256+08	2016-03-22 18:00:08.907256+08
45	Out	2016-03-22 18:00:20.643339+08	2016-03-22 18:00:20.643339+08
25	Out	2016-03-22 18:00:21.058708+08	2016-03-22 18:00:21.058708+08
14	Out	2016-03-22 18:00:28.452802+08	2016-03-22 18:00:28.452802+08
26	Out	2016-03-22 18:00:28.542456+08	2016-03-22 18:00:28.542456+08
12	Out	2016-03-22 18:00:55.964212+08	2016-03-22 18:00:55.964212+08
48	Out	2016-03-22 18:01:05.768889+08	2016-03-22 18:01:05.768889+08
49	Out	2016-03-22 18:01:17.969207+08	2016-03-22 18:01:17.969207+08
18	Out	2016-03-22 18:01:18.811147+08	2016-03-22 18:01:18.811147+08
13	Out	2016-03-22 18:01:19.274346+08	2016-03-22 18:01:19.274346+08
23	Out	2016-03-22 18:02:24.948129+08	2016-03-22 18:02:24.948129+08
27	Out	2016-03-22 18:03:26.325755+08	2016-03-22 18:03:26.325755+08
28	Out	2016-03-22 18:05:07.420633+08	2016-03-22 18:05:07.420633+08
30	In	2016-03-23 08:23:18.449139+08	2016-03-23 08:23:18.449139+08
17	In	2016-03-23 08:23:33.02576+08	2016-03-23 08:23:33.02576+08
48	In	2016-03-23 08:23:36.55518+08	2016-03-23 08:23:36.55518+08
12	In	2016-03-23 08:24:06.408397+08	2016-03-23 08:24:06.408397+08
23	In	2016-03-23 08:24:53.94733+08	2016-03-23 08:24:53.94733+08
49	In	2016-03-23 08:26:31.312089+08	2016-03-23 08:26:31.312089+08
13	In	2016-03-23 08:27:54.92993+08	2016-03-23 08:27:54.92993+08
27	In	2016-03-23 08:30:53.686434+08	2016-03-23 08:30:53.686434+08
26	In	2016-03-23 08:40:41.60001+08	2016-03-23 08:40:41.60001+08
14	In	2016-03-23 08:41:04.670844+08	2016-03-23 08:41:04.670844+08
31	In	2016-03-23 08:43:35.485877+08	2016-03-23 08:43:35.485877+08
29	In	2016-03-23 08:45:03.524762+08	2016-03-23 08:45:03.524762+08
11	In	2016-03-23 08:45:45.113015+08	2016-03-23 08:45:45.113015+08
45	In	2016-03-23 08:45:59.29487+08	2016-03-23 08:45:59.29487+08
25	In	2016-03-23 08:46:28.561961+08	2016-03-23 08:46:28.561961+08
18	In	2016-03-23 08:46:30.264886+08	2016-03-23 08:46:30.264886+08
47	In	2016-03-23 08:54:20.228153+08	2016-03-23 08:54:20.228153+08
41	In	2016-03-23 13:01:21.012395+08	2016-03-23 13:01:21.012395+08
31	Out	2016-03-23 13:01:28.936932+08	2016-03-23 13:01:28.936932+08
26	Out	2016-03-23 15:01:10.31802+08	2016-03-23 15:01:10.31802+08
49	Out	2016-03-23 18:01:02.127895+08	2016-03-23 18:01:02.127895+08
27	Out	2016-03-23 18:01:04.907005+08	2016-03-23 18:01:04.907005+08
11	Out	2016-03-23 18:01:07.450669+08	2016-03-23 18:01:07.450669+08
13	Out	2016-03-23 18:01:07.870955+08	2016-03-23 18:01:07.870955+08
48	Out	2016-03-23 18:01:09.159641+08	2016-03-23 18:01:09.159641+08
18	Out	2016-03-23 18:01:09.494944+08	2016-03-23 18:01:09.494944+08
14	Out	2016-03-23 18:01:10.360098+08	2016-03-23 18:01:10.360098+08
45	Out	2016-03-23 18:01:10.698482+08	2016-03-23 18:01:10.698482+08
17	Out	2016-03-23 18:01:11.533431+08	2016-03-23 18:01:11.533431+08
25	Out	2016-03-23 18:01:12.337612+08	2016-03-23 18:01:12.337612+08
47	Out	2016-03-23 18:01:25.431615+08	2016-03-23 18:01:25.431615+08
30	Out	2016-03-23 18:01:43.167232+08	2016-03-23 18:01:43.167232+08
29	Out	2016-03-23 18:01:47.693428+08	2016-03-23 18:01:47.693428+08
41	Out	2016-03-23 18:02:44.061224+08	2016-03-23 18:02:44.061224+08
12	Out	2016-03-23 18:09:59.444376+08	2016-03-23 18:09:59.444376+08
23	Out	2016-03-23 18:28:24.861303+08	2016-03-23 18:28:24.861303+08
48	In	2016-03-28 08:39:07.574243+08	2016-03-28 08:39:07.574243+08
30	In	2016-03-28 08:39:58.512646+08	2016-03-28 08:39:58.512646+08
17	In	2016-03-28 08:40:14.445855+08	2016-03-28 08:40:14.445855+08
41	In	2016-03-28 08:40:18.800533+08	2016-03-28 08:40:18.800533+08
26	In	2016-03-28 08:40:27.743634+08	2016-03-28 08:40:27.743634+08
12	In	2016-03-28 08:40:35.274689+08	2016-03-28 08:40:35.274689+08
45	In	2016-03-28 08:41:00.644272+08	2016-03-28 08:41:00.644272+08
13	In	2016-03-28 08:41:06.050035+08	2016-03-28 08:41:06.050035+08
23	In	2016-03-28 08:41:24.119466+08	2016-03-28 08:41:24.119466+08
27	In	2016-03-28 08:41:44.985252+08	2016-03-28 08:41:44.985252+08
31	In	2016-03-28 08:41:59.102317+08	2016-03-28 08:41:59.102317+08
25	In	2016-03-28 08:42:13.751949+08	2016-03-28 08:42:13.751949+08
11	In	2016-03-28 08:49:41.76499+08	2016-03-28 08:49:41.76499+08
18	In	2016-03-28 08:59:24.979855+08	2016-03-28 08:59:24.979855+08
28	In	2016-03-28 09:10:04.437554+08	2016-03-28 09:10:04.437554+08
31	Out	2016-03-28 12:02:59.028542+08	2016-03-28 12:02:59.028542+08
30	Out	2016-03-28 16:14:27.251886+08	2016-03-28 16:14:27.251886+08
41	Out	2016-03-28 16:19:57.370332+08	2016-03-28 16:19:57.370332+08
48	Out	2016-03-28 18:01:08.034397+08	2016-03-28 18:01:08.034397+08
45	Out	2016-03-28 18:01:17.678427+08	2016-03-28 18:01:17.678427+08
11	Out	2016-03-28 18:01:19.380506+08	2016-03-28 18:01:19.380506+08
26	Out	2016-03-28 18:01:21.620525+08	2016-03-28 18:01:21.620525+08
25	Out	2016-03-28 18:01:26.680329+08	2016-03-28 18:01:26.680329+08
18	Out	2016-03-28 18:01:38.649515+08	2016-03-28 18:01:38.649515+08
27	Out	2016-03-28 18:02:17.384212+08	2016-03-28 18:02:17.384212+08
12	Out	2016-03-28 18:03:07.261785+08	2016-03-28 18:03:07.261785+08
13	Out	2016-03-28 18:08:30.11081+08	2016-03-28 18:08:30.11081+08
17	Out	2016-03-28 18:09:06.773815+08	2016-03-28 18:09:06.773815+08
23	Out	2016-03-28 18:09:18.805478+08	2016-03-28 18:09:18.805478+08
28	Out	2016-03-28 18:10:04.491975+08	2016-03-28 18:10:04.491975+08
13	In	2016-03-29 08:39:10.490672+08	2016-03-29 08:39:10.490672+08
25	In	2016-03-29 08:39:45.847594+08	2016-03-29 08:39:45.847594+08
17	In	2016-03-29 08:41:48.418132+08	2016-03-29 08:41:48.418132+08
41	In	2016-03-29 08:42:49.229509+08	2016-03-29 08:42:49.229509+08
30	In	2016-03-29 08:43:47.756597+08	2016-03-29 08:43:47.756597+08
31	In	2016-03-29 08:44:29.768772+08	2016-03-29 08:44:29.768772+08
27	In	2016-03-29 08:44:43.658647+08	2016-03-29 08:44:43.658647+08
47	In	2016-03-29 08:45:05.643298+08	2016-03-29 08:45:05.643298+08
48	In	2016-03-29 08:45:06.577243+08	2016-03-29 08:45:06.577243+08
45	In	2016-03-29 08:45:19.104228+08	2016-03-29 08:45:19.104228+08
12	In	2016-03-29 08:45:49.255321+08	2016-03-29 08:45:49.255321+08
23	In	2016-03-29 08:47:49.904857+08	2016-03-29 08:47:49.904857+08
14	In	2016-03-29 08:49:52.86883+08	2016-03-29 08:49:52.86883+08
18	In	2016-03-29 08:50:40.449466+08	2016-03-29 08:50:40.449466+08
29	In	2016-03-29 08:53:15.253727+08	2016-03-29 08:53:15.253727+08
49	In	2016-03-29 08:56:33.171971+08	2016-03-29 08:56:33.171971+08
28	In	2016-03-29 09:07:01.967679+08	2016-03-29 09:07:01.967679+08
27	Out	2016-03-29 18:00:09.902771+08	2016-03-29 18:00:09.902771+08
14	Out	2016-03-29 18:00:14.080312+08	2016-03-29 18:00:14.080312+08
25	Out	2016-03-29 18:00:17.190362+08	2016-03-29 18:00:17.190362+08
31	Out	2016-03-29 18:00:17.557927+08	2016-03-29 18:00:17.557927+08
18	Out	2016-03-29 18:00:20.048868+08	2016-03-29 18:00:20.048868+08
48	Out	2016-03-29 18:00:26.132491+08	2016-03-29 18:00:26.132491+08
28	Out	2016-03-29 18:00:40.290564+08	2016-03-29 18:00:40.290564+08
45	Out	2016-03-29 18:00:44.507281+08	2016-03-29 18:00:44.507281+08
29	Out	2016-03-29 18:01:21.490673+08	2016-03-29 18:01:21.490673+08
13	Out	2016-03-29 18:01:23.278151+08	2016-03-29 18:01:23.278151+08
30	Out	2016-03-29 18:01:45.169027+08	2016-03-29 18:01:45.169027+08
49	Out	2016-03-29 18:01:46.75525+08	2016-03-29 18:01:46.75525+08
41	Out	2016-03-29 18:03:13.264556+08	2016-03-29 18:03:13.264556+08
12	Out	2016-03-29 18:03:20.486659+08	2016-03-29 18:03:20.486659+08
47	Out	2016-03-29 18:05:16.535458+08	2016-03-29 18:05:16.535458+08
23	Out	2016-03-29 18:14:33.167848+08	2016-03-29 18:14:33.167848+08
12	In	2016-03-30 08:23:08.417356+08	2016-03-30 08:23:08.417356+08
41	In	2016-03-30 08:23:13.401027+08	2016-03-30 08:23:13.401027+08
23	In	2016-03-30 08:23:15.506503+08	2016-03-30 08:23:15.506503+08
13	In	2016-03-30 08:27:06.813921+08	2016-03-30 08:27:06.813921+08
17	In	2016-03-30 08:27:27.748236+08	2016-03-30 08:27:27.748236+08
49	In	2016-03-30 08:27:41.775584+08	2016-03-30 08:27:41.775584+08
48	In	2016-03-30 08:32:42.933272+08	2016-03-30 08:32:42.933272+08
45	In	2016-03-30 08:40:18.395466+08	2016-03-30 08:40:18.395466+08
30	In	2016-03-30 08:43:20.751301+08	2016-03-30 08:43:20.751301+08
18	In	2016-03-30 08:46:32.966993+08	2016-03-30 08:46:32.966993+08
27	In	2016-03-30 08:46:39.802022+08	2016-03-30 08:46:39.802022+08
31	In	2016-03-30 08:50:18.249962+08	2016-03-30 08:50:18.249962+08
25	In	2016-03-30 08:56:58.030724+08	2016-03-30 08:56:58.030724+08
28	In	2016-03-30 08:57:24.863917+08	2016-03-30 08:57:24.863917+08
29	In	2016-03-30 08:58:24.311442+08	2016-03-30 08:58:24.311442+08
14	In	2016-03-30 08:58:39.399855+08	2016-03-30 08:58:39.399855+08
47	In	2016-03-30 08:59:51.882382+08	2016-03-30 08:59:51.882382+08
31	Out	2016-03-30 13:00:16.339687+08	2016-03-30 13:00:16.339687+08
27	Out	2016-03-30 18:00:06.446103+08	2016-03-30 18:00:06.446103+08
14	Out	2016-03-30 18:00:08.321738+08	2016-03-30 18:00:08.321738+08
18	Out	2016-03-30 18:00:15.29938+08	2016-03-30 18:00:15.29938+08
48	Out	2016-03-30 18:00:15.642004+08	2016-03-30 18:00:15.642004+08
49	Out	2016-03-30 18:00:16.023817+08	2016-03-30 18:00:16.023817+08
25	Out	2016-03-30 18:00:18.566374+08	2016-03-30 18:00:18.566374+08
45	Out	2016-03-30 18:00:29.442768+08	2016-03-30 18:00:29.442768+08
13	Out	2016-03-30 18:00:58.170621+08	2016-03-30 18:00:58.170621+08
28	Out	2016-03-30 18:01:05.874521+08	2016-03-30 18:01:05.874521+08
17	Out	2016-03-30 18:01:07.991659+08	2016-03-30 18:01:07.991659+08
29	Out	2016-03-30 18:01:10.914677+08	2016-03-30 18:01:10.914677+08
30	Out	2016-03-30 18:01:12.018694+08	2016-03-30 18:01:12.018694+08
23	Out	2016-03-30 18:01:18.958239+08	2016-03-30 18:01:18.958239+08
47	Out	2016-03-30 18:02:13.737156+08	2016-03-30 18:02:13.737156+08
41	Out	2016-03-30 18:03:00.387256+08	2016-03-30 18:03:00.387256+08
12	Out	2016-03-30 18:03:17.606603+08	2016-03-30 18:03:17.606603+08
12	In	2016-03-31 08:24:17.069783+08	2016-03-31 08:24:17.069783+08
13	In	2016-03-31 08:24:50.216045+08	2016-03-31 08:24:50.216045+08
23	In	2016-03-31 08:28:02.221073+08	2016-03-31 08:28:02.221073+08
48	In	2016-03-31 08:28:54.121003+08	2016-03-31 08:28:54.121003+08
27	In	2016-03-31 08:45:45.636369+08	2016-03-31 08:45:45.636369+08
11	In	2016-03-31 08:52:45.025353+08	2016-03-31 08:52:45.025353+08
45	In	2016-03-31 08:55:20.784375+08	2016-03-31 08:55:20.784375+08
26	In	2016-03-31 08:55:50.52547+08	2016-03-31 08:55:50.52547+08
47	In	2016-03-31 08:57:11.826201+08	2016-03-31 08:57:11.826201+08
14	In	2016-03-31 09:00:41.522602+08	2016-03-31 09:00:41.522602+08
25	In	2016-03-31 09:06:04.282407+08	2016-03-31 09:06:04.282407+08
18	In	2016-03-31 09:15:10.746167+08	2016-03-31 09:15:10.746167+08
28	In	2016-03-31 09:23:01.421421+08	2016-03-31 09:23:01.421421+08
28	Out	2016-03-31 18:00:11.539622+08	2016-03-31 18:00:11.539622+08
48	Out	2016-03-31 18:00:17.495912+08	2016-03-31 18:00:17.495912+08
18	Out	2016-03-31 18:00:22.187777+08	2016-03-31 18:00:22.187777+08
14	Out	2016-03-31 18:00:23.11433+08	2016-03-31 18:00:23.11433+08
25	Out	2016-03-31 18:00:27.394546+08	2016-03-31 18:00:27.394546+08
27	Out	2016-03-31 18:00:34.42646+08	2016-03-31 18:00:34.42646+08
45	Out	2016-03-31 18:00:47.093812+08	2016-03-31 18:00:47.093812+08
26	Out	2016-03-31 18:01:15.83739+08	2016-03-31 18:01:15.83739+08
13	Out	2016-03-31 18:01:26.082851+08	2016-03-31 18:01:26.082851+08
23	Out	2016-03-31 18:01:44.368795+08	2016-03-31 18:01:44.368795+08
47	Out	2016-03-31 18:03:22.12716+08	2016-03-31 18:03:22.12716+08
12	Out	2016-03-31 18:05:48.6339+08	2016-03-31 18:05:48.6339+08
11	Out	2016-03-31 18:07:07.778049+08	2016-03-31 18:07:07.778049+08
23	In	2016-04-01 08:25:10.773497+08	2016-04-01 08:25:10.773497+08
12	In	2016-04-01 08:27:50.466562+08	2016-04-01 08:27:50.466562+08
31	In	2016-04-01 08:28:27.070616+08	2016-04-01 08:28:27.070616+08
25	In	2016-04-01 08:30:03.685915+08	2016-04-01 08:30:03.685915+08
14	In	2016-04-01 08:33:04.778439+08	2016-04-01 08:33:04.778439+08
41	In	2016-04-01 08:33:08.162468+08	2016-04-01 08:33:08.162468+08
13	In	2016-04-01 08:33:16.825792+08	2016-04-01 08:33:16.825792+08
48	In	2016-04-01 08:33:26.708546+08	2016-04-01 08:33:26.708546+08
49	In	2016-04-01 08:33:40.092354+08	2016-04-01 08:33:40.092354+08
30	In	2016-04-01 08:38:13.014189+08	2016-04-01 08:38:13.014189+08
28	In	2016-04-01 08:42:13.05819+08	2016-04-01 08:42:13.05819+08
18	In	2016-04-01 08:48:00.825826+08	2016-04-01 08:48:00.825826+08
27	In	2016-04-01 08:50:41.24395+08	2016-04-01 08:50:41.24395+08
11	In	2016-04-01 08:51:25.229879+08	2016-04-01 08:51:25.229879+08
29	In	2016-04-01 08:56:21.668914+08	2016-04-01 08:56:21.668914+08
47	In	2016-04-01 08:59:23.258748+08	2016-04-01 08:59:23.258748+08
31	Out	2016-04-01 18:00:15.965152+08	2016-04-01 18:00:15.965152+08
14	Out	2016-04-01 18:00:34.564903+08	2016-04-01 18:00:34.564903+08
48	Out	2016-04-01 18:00:54.920897+08	2016-04-01 18:00:54.920897+08
18	Out	2016-04-01 18:00:57.452293+08	2016-04-01 18:00:57.452293+08
29	Out	2016-04-01 18:01:18.482608+08	2016-04-01 18:01:18.482608+08
25	Out	2016-04-01 18:01:23.138229+08	2016-04-01 18:01:23.138229+08
49	Out	2016-04-01 18:01:24.114502+08	2016-04-01 18:01:24.114502+08
13	Out	2016-04-01 18:02:42.248405+08	2016-04-01 18:02:42.248405+08
30	Out	2016-04-01 18:03:12.289244+08	2016-04-01 18:03:12.289244+08
11	Out	2016-04-01 18:05:19.836731+08	2016-04-01 18:05:19.836731+08
23	Out	2016-04-01 18:20:02.578994+08	2016-04-01 18:20:02.578994+08
12	Out	2016-04-01 18:23:40.156882+08	2016-04-01 18:23:40.156882+08
27	Out	2016-04-01 18:24:46.462262+08	2016-04-01 18:24:46.462262+08
28	Out	2016-04-01 18:30:14.180516+08	2016-04-01 18:30:14.180516+08
47	Out	2016-04-01 18:33:42.347767+08	2016-04-01 18:33:42.347767+08
41	Out	2016-04-01 19:21:56.492524+08	2016-04-01 19:21:56.492524+08
48	In	2016-04-04 08:17:52.971251+08	2016-04-04 08:17:52.971251+08
17	In	2016-04-04 08:19:44.229331+08	2016-04-04 08:19:44.229331+08
49	In	2016-04-04 08:20:10.888307+08	2016-04-04 08:20:10.888307+08
13	In	2016-04-04 08:20:15.46976+08	2016-04-04 08:20:15.46976+08
23	In	2016-04-04 08:20:53.745977+08	2016-04-04 08:20:53.745977+08
12	In	2016-04-04 08:28:05.324301+08	2016-04-04 08:28:05.324301+08
11	In	2016-04-04 08:28:38.753724+08	2016-04-04 08:28:38.753724+08
26	In	2016-04-04 08:30:48.958355+08	2016-04-04 08:30:48.958355+08
14	In	2016-04-04 08:44:13.956104+08	2016-04-04 08:44:13.956104+08
19	In	2016-04-04 08:56:31.153607+08	2016-04-04 08:56:31.153607+08
47	In	2016-04-04 08:57:05.015505+08	2016-04-04 08:57:05.015505+08
27	In	2016-04-04 09:04:41.840422+08	2016-04-04 09:04:41.840422+08
28	In	2016-04-04 10:06:24.592985+08	2016-04-04 10:06:24.592985+08
14	Out	2016-04-04 18:00:16.331426+08	2016-04-04 18:00:16.331426+08
26	Out	2016-04-04 18:02:31.276995+08	2016-04-04 18:02:31.276995+08
11	Out	2016-04-04 18:04:32.058612+08	2016-04-04 18:04:32.058612+08
13	Out	2016-04-04 18:05:30.081845+08	2016-04-04 18:05:30.081845+08
27	Out	2016-04-04 18:05:37.475643+08	2016-04-04 18:05:37.475643+08
48	Out	2016-04-04 18:06:13.669124+08	2016-04-04 18:06:13.669124+08
28	Out	2016-04-04 18:06:26.097211+08	2016-04-04 18:06:26.097211+08
19	Out	2016-04-04 18:07:02.551107+08	2016-04-04 18:07:02.551107+08
49	Out	2016-04-04 18:13:46.256056+08	2016-04-04 18:13:46.256056+08
17	Out	2016-04-04 18:15:31.001359+08	2016-04-04 18:15:31.001359+08
12	Out	2016-04-04 18:19:25.546762+08	2016-04-04 18:19:25.546762+08
47	Out	2016-04-04 18:29:42.145634+08	2016-04-04 18:29:42.145634+08
23	Out	2016-04-04 18:32:12.193529+08	2016-04-04 18:32:12.193529+08
48	In	2016-04-05 08:20:44.177468+08	2016-04-05 08:20:44.177468+08
49	In	2016-04-05 08:21:07.748918+08	2016-04-05 08:21:07.748918+08
31	In	2016-04-05 08:21:23.120224+08	2016-04-05 08:21:23.120224+08
41	In	2016-04-05 08:23:38.305314+08	2016-04-05 08:23:38.305314+08
30	In	2016-04-05 08:25:16.924025+08	2016-04-05 08:25:16.924025+08
12	In	2016-04-05 08:28:40.895368+08	2016-04-05 08:28:40.895368+08
17	In	2016-04-05 08:30:13.153708+08	2016-04-05 08:30:13.153708+08
26	In	2016-04-05 08:37:21.098871+08	2016-04-05 08:37:21.098871+08
23	In	2016-04-05 08:37:40.054346+08	2016-04-05 08:37:40.054346+08
14	In	2016-04-05 08:43:48.386827+08	2016-04-05 08:43:48.386827+08
11	In	2016-04-05 08:47:00.339906+08	2016-04-05 08:47:00.339906+08
45	In	2016-04-05 08:51:16.125946+08	2016-04-05 08:51:16.125946+08
47	In	2016-04-05 08:57:43.353225+08	2016-04-05 08:57:43.353225+08
29	In	2016-04-05 08:59:22.840171+08	2016-04-05 08:59:22.840171+08
27	In	2016-04-05 09:01:36.684582+08	2016-04-05 09:01:36.684582+08
28	In	2016-04-05 10:10:47.388206+08	2016-04-05 10:10:47.388206+08
31	Out	2016-04-05 18:00:12.572939+08	2016-04-05 18:00:12.572939+08
48	Out	2016-04-05 18:01:07.832659+08	2016-04-05 18:01:07.832659+08
45	Out	2016-04-05 18:01:20.122808+08	2016-04-05 18:01:20.122808+08
26	Out	2016-04-05 18:01:25.779589+08	2016-04-05 18:01:25.779589+08
17	Out	2016-04-05 18:01:55.662711+08	2016-04-05 18:01:55.662711+08
27	Out	2016-04-05 18:02:02.844003+08	2016-04-05 18:02:02.844003+08
28	Out	2016-04-05 18:02:44.565375+08	2016-04-05 18:02:44.565375+08
14	Out	2016-04-05 18:02:47.826743+08	2016-04-05 18:02:47.826743+08
23	Out	2016-04-05 18:02:54.483743+08	2016-04-05 18:02:54.483743+08
12	Out	2016-04-05 18:03:02.159968+08	2016-04-05 18:03:02.159968+08
47	Out	2016-04-05 18:06:10.897843+08	2016-04-05 18:06:10.897843+08
41	Out	2016-04-05 18:15:50.109956+08	2016-04-05 18:15:50.109956+08
49	Out	2016-04-05 18:16:47.582544+08	2016-04-05 18:16:47.582544+08
29	Out	2016-04-05 18:16:51.019654+08	2016-04-05 18:16:51.019654+08
30	Out	2016-04-05 18:17:06.5865+08	2016-04-05 18:17:06.5865+08
11	Out	2016-04-05 18:23:55.422748+08	2016-04-05 18:23:55.422748+08
48	In	2016-04-06 08:28:48.476196+08	2016-04-06 08:28:48.476196+08
12	In	2016-04-06 08:30:06.632162+08	2016-04-06 08:30:06.632162+08
23	In	2016-04-06 08:30:22.874907+08	2016-04-06 08:30:22.874907+08
13	In	2016-04-06 08:30:34.885352+08	2016-04-06 08:30:34.885352+08
17	In	2016-04-06 08:35:41.732164+08	2016-04-06 08:35:41.732164+08
11	In	2016-04-06 08:39:01.346724+08	2016-04-06 08:39:01.346724+08
49	In	2016-04-06 08:39:16.640985+08	2016-04-06 08:39:16.640985+08
45	In	2016-04-06 08:39:37.308515+08	2016-04-06 08:39:37.308515+08
27	In	2016-04-06 08:41:57.439617+08	2016-04-06 08:41:57.439617+08
14	In	2016-04-06 08:57:00.55306+08	2016-04-06 08:57:00.55306+08
28	In	2016-04-06 09:30:33.655315+08	2016-04-06 09:30:33.655315+08
14	Out	2016-04-06 18:00:16.559568+08	2016-04-06 18:00:16.559568+08
49	Out	2016-04-06 18:00:17.886291+08	2016-04-06 18:00:17.886291+08
45	Out	2016-04-06 18:00:19.660247+08	2016-04-06 18:00:19.660247+08
13	Out	2016-04-06 18:01:03.219603+08	2016-04-06 18:01:03.219603+08
11	Out	2016-04-06 18:01:20.134608+08	2016-04-06 18:01:20.134608+08
47	Out	2016-04-06 18:01:50.500825+08	2016-04-06 18:01:50.500825+08
17	Out	2016-04-06 18:03:03.919103+08	2016-04-06 18:03:03.919103+08
27	Out	2016-04-06 18:04:23.999558+08	2016-04-06 18:04:23.999558+08
12	Out	2016-04-06 18:04:46.550018+08	2016-04-06 18:04:46.550018+08
23	Out	2016-04-06 18:04:54.402616+08	2016-04-06 18:04:54.402616+08
28	Out	2016-04-06 18:05:49.199434+08	2016-04-06 18:05:49.199434+08
48	Out	2016-04-06 19:36:44.79636+08	2016-04-06 19:36:44.79636+08
41	In	2016-04-07 08:15:43.891896+08	2016-04-07 08:15:43.891896+08
48	In	2016-04-07 08:16:12.96285+08	2016-04-07 08:16:12.96285+08
13	In	2016-04-07 08:16:45.503779+08	2016-04-07 08:16:45.503779+08
17	In	2016-04-07 08:16:56.216905+08	2016-04-07 08:16:56.216905+08
12	In	2016-04-07 08:16:57.106861+08	2016-04-07 08:16:57.106861+08
23	In	2016-04-07 08:23:08.870606+08	2016-04-07 08:23:08.870606+08
31	In	2016-04-07 08:34:38.886003+08	2016-04-07 08:34:38.886003+08
27	In	2016-04-07 08:35:32.168978+08	2016-04-07 08:35:32.168978+08
47	In	2016-04-07 08:37:09.064699+08	2016-04-07 08:37:09.064699+08
26	In	2016-04-07 08:39:36.070551+08	2016-04-07 08:39:36.070551+08
14	In	2016-04-07 08:46:56.586444+08	2016-04-07 08:46:56.586444+08
11	In	2016-04-07 08:47:52.654365+08	2016-04-07 08:47:52.654365+08
29	In	2016-04-07 08:50:19.206797+08	2016-04-07 08:50:19.206797+08
45	In	2016-04-07 08:57:02.962829+08	2016-04-07 08:57:02.962829+08
30	In	2016-04-07 09:34:37.379987+08	2016-04-07 09:34:37.379987+08
28	In	2016-04-07 09:53:00.118177+08	2016-04-07 09:53:00.118177+08
26	Out	2016-04-07 12:22:22.231438+08	2016-04-07 12:22:22.231438+08
14	Out	2016-04-07 18:00:29.469154+08	2016-04-07 18:00:29.469154+08
48	Out	2016-04-07 18:00:36.490009+08	2016-04-07 18:00:36.490009+08
11	Out	2016-04-07 18:01:04.775119+08	2016-04-07 18:01:04.775119+08
13	Out	2016-04-07 18:01:11.504215+08	2016-04-07 18:01:11.504215+08
28	Out	2016-04-07 18:01:36.987859+08	2016-04-07 18:01:36.987859+08
17	Out	2016-04-07 18:01:38.229112+08	2016-04-07 18:01:38.229112+08
27	Out	2016-04-07 18:01:58.699427+08	2016-04-07 18:01:58.699427+08
12	Out	2016-04-07 18:02:20.668826+08	2016-04-07 18:02:20.668826+08
45	Out	2016-04-07 18:02:40.52244+08	2016-04-07 18:02:40.52244+08
47	Out	2016-04-07 18:03:12.970869+08	2016-04-07 18:03:12.970869+08
23	Out	2016-04-07 18:05:50.285818+08	2016-04-07 18:05:50.285818+08
31	Out	2016-04-07 18:10:48.134075+08	2016-04-07 18:10:48.134075+08
30	Out	2016-04-07 19:05:08.557937+08	2016-04-07 19:05:08.557937+08
41	Out	2016-04-07 19:08:19.550719+08	2016-04-07 19:08:19.550719+08
29	Out	2016-04-07 19:09:15.891244+08	2016-04-07 19:09:15.891244+08
17	In	2016-04-08 08:27:06.180599+08	2016-04-08 08:27:06.180599+08
23	In	2016-04-08 08:27:40.258915+08	2016-04-08 08:27:40.258915+08
12	In	2016-04-08 08:27:45.859298+08	2016-04-08 08:27:45.859298+08
41	In	2016-04-08 08:28:42.062241+08	2016-04-08 08:28:42.062241+08
13	In	2016-04-08 08:29:20.249028+08	2016-04-08 08:29:20.249028+08
48	In	2016-04-08 08:29:53.544001+08	2016-04-08 08:29:53.544001+08
45	In	2016-04-08 08:30:00.506179+08	2016-04-08 08:30:00.506179+08
11	In	2016-04-08 08:30:07.07174+08	2016-04-08 08:30:07.07174+08
49	In	2016-04-08 08:30:17.91167+08	2016-04-08 08:30:17.91167+08
14	In	2016-04-08 08:37:23.089538+08	2016-04-08 08:37:23.089538+08
30	In	2016-04-08 08:48:51.380284+08	2016-04-08 08:48:51.380284+08
31	In	2016-04-08 08:53:24.614166+08	2016-04-08 08:53:24.614166+08
27	In	2016-04-08 08:53:37.287376+08	2016-04-08 08:53:37.287376+08
47	In	2016-04-08 08:53:52.96882+08	2016-04-08 08:53:52.96882+08
29	In	2016-04-08 09:23:42.051134+08	2016-04-08 09:23:42.051134+08
28	In	2016-04-08 09:55:51.215262+08	2016-04-08 09:55:51.215262+08
47	Out	2016-04-08 18:00:39.292588+08	2016-04-08 18:00:39.292588+08
27	Out	2016-04-08 18:01:10.013126+08	2016-04-08 18:01:10.013126+08
13	Out	2016-04-08 18:01:10.913109+08	2016-04-08 18:01:10.913109+08
14	Out	2016-04-08 18:01:14.359815+08	2016-04-08 18:01:14.359815+08
12	Out	2016-04-08 18:01:22.401575+08	2016-04-08 18:01:22.401575+08
28	Out	2016-04-08 18:01:38.464052+08	2016-04-08 18:01:38.464052+08
48	Out	2016-04-08 18:01:40.084904+08	2016-04-08 18:01:40.084904+08
31	Out	2016-04-08 18:01:54.285606+08	2016-04-08 18:01:54.285606+08
45	Out	2016-04-08 18:02:22.191217+08	2016-04-08 18:02:22.191217+08
11	Out	2016-04-08 18:03:35.735371+08	2016-04-08 18:03:35.735371+08
49	Out	2016-04-08 18:03:42.920472+08	2016-04-08 18:03:42.920472+08
29	Out	2016-04-08 18:05:50.11498+08	2016-04-08 18:05:50.11498+08
30	Out	2016-04-08 18:06:01.424697+08	2016-04-08 18:06:01.424697+08
30	Out	2016-04-08 18:06:23.491884+08	2016-04-08 18:06:23.491884+08
23	Out	2016-04-08 18:07:08.678933+08	2016-04-08 18:07:08.678933+08
41	Out	2016-04-08 18:10:00.159522+08	2016-04-08 18:10:00.159522+08
17	Out	2016-04-08 18:10:23.273299+08	2016-04-08 18:10:23.273299+08
47	In	2016-04-11 08:33:30.881306+08	2016-04-11 08:33:30.881306+08
17	In	2016-04-11 08:33:59.685901+08	2016-04-11 08:33:59.685901+08
12	In	2016-04-11 08:34:40.080517+08	2016-04-11 08:34:40.080517+08
23	In	2016-04-11 08:34:56.5728+08	2016-04-11 08:34:56.5728+08
30	In	2016-04-11 08:36:21.523531+08	2016-04-11 08:36:21.523531+08
11	In	2016-04-11 08:36:25.040107+08	2016-04-11 08:36:25.040107+08
41	In	2016-04-11 08:37:53.469184+08	2016-04-11 08:37:53.469184+08
48	In	2016-04-11 08:40:30.519525+08	2016-04-11 08:40:30.519525+08
13	In	2016-04-11 08:45:58.254191+08	2016-04-11 08:45:58.254191+08
26	In	2016-04-11 08:49:30.296132+08	2016-04-11 08:49:30.296132+08
27	In	2016-04-11 08:49:56.455594+08	2016-04-11 08:49:56.455594+08
45	In	2016-04-11 08:51:46.198218+08	2016-04-11 08:51:46.198218+08
31	In	2016-04-11 09:05:27.333552+08	2016-04-11 09:05:27.333552+08
29	In	2016-04-11 09:34:04.991614+08	2016-04-11 09:34:04.991614+08
28	In	2016-04-11 09:34:38.097698+08	2016-04-11 09:34:38.097698+08
45	Out	2016-04-11 14:00:25.33514+08	2016-04-11 14:00:25.33514+08
13	Out	2016-04-11 14:01:24.518678+08	2016-04-11 14:01:24.518678+08
12	Out	2016-04-11 14:04:48.562948+08	2016-04-11 14:04:48.562948+08
48	Out	2016-04-11 14:04:54.694544+08	2016-04-11 14:04:54.694544+08
47	Out	2016-04-11 15:09:22.862583+08	2016-04-11 15:09:22.862583+08
11	Out	2016-04-11 15:19:43.563109+08	2016-04-11 15:19:43.563109+08
27	Out	2016-04-11 15:33:22.032497+08	2016-04-11 15:33:22.032497+08
17	Out	2016-04-11 15:43:12.213258+08	2016-04-11 15:43:12.213258+08
28	Out	2016-04-11 17:13:11.978385+08	2016-04-11 17:13:11.978385+08
26	Out	2016-04-11 18:00:25.517209+08	2016-04-11 18:00:25.517209+08
31	Out	2016-04-11 18:00:27.832755+08	2016-04-11 18:00:27.832755+08
23	Out	2016-04-11 18:01:56.536363+08	2016-04-11 18:01:56.536363+08
41	Out	2016-04-11 18:09:24.504809+08	2016-04-11 18:09:24.504809+08
30	Out	2016-04-11 18:09:28.616754+08	2016-04-11 18:09:28.616754+08
29	Out	2016-04-11 18:12:15.209879+08	2016-04-11 18:12:15.209879+08
17	In	2016-04-12 08:25:49.802152+08	2016-04-12 08:25:49.802152+08
30	In	2016-04-12 08:26:13.252704+08	2016-04-12 08:26:13.252704+08
41	In	2016-04-12 08:26:15.375966+08	2016-04-12 08:26:15.375966+08
48	In	2016-04-12 08:29:32.642176+08	2016-04-12 08:29:32.642176+08
49	In	2016-04-12 08:30:02.531236+08	2016-04-12 08:30:02.531236+08
23	In	2016-04-12 08:32:51.764383+08	2016-04-12 08:32:51.764383+08
12	In	2016-04-12 08:33:04.7992+08	2016-04-12 08:33:04.7992+08
11	In	2016-04-12 08:37:37.920297+08	2016-04-12 08:37:37.920297+08
31	In	2016-04-12 08:47:19.255076+08	2016-04-12 08:47:19.255076+08
26	In	2016-04-12 08:49:12.345185+08	2016-04-12 08:49:12.345185+08
47	In	2016-04-12 08:49:37.059318+08	2016-04-12 08:49:37.059318+08
27	In	2016-04-12 08:49:51.328525+08	2016-04-12 08:49:51.328525+08
45	In	2016-04-12 08:53:08.23796+08	2016-04-12 08:53:08.23796+08
13	In	2016-04-12 08:57:33.025677+08	2016-04-12 08:57:33.025677+08
29	In	2016-04-12 09:24:53.175188+08	2016-04-12 09:24:53.175188+08
28	In	2016-04-12 13:56:15.295501+08	2016-04-12 13:56:15.295501+08
26	Out	2016-04-12 14:01:12.57469+08	2016-04-12 14:01:12.57469+08
27	Out	2016-04-12 14:02:25.016352+08	2016-04-12 14:02:25.016352+08
47	Out	2016-04-12 14:08:13.186663+08	2016-04-12 14:08:13.186663+08
13	Out	2016-04-12 14:13:52.728269+08	2016-04-12 14:13:52.728269+08
45	Out	2016-04-12 14:14:25.215476+08	2016-04-12 14:14:25.215476+08
12	Out	2016-04-12 14:19:43.26639+08	2016-04-12 14:19:43.26639+08
48	Out	2016-04-12 14:30:58.473022+08	2016-04-12 14:30:58.473022+08
17	Out	2016-04-12 14:34:26.184368+08	2016-04-12 14:34:26.184368+08
28	Out	2016-04-12 17:25:44.659098+08	2016-04-12 17:25:44.659098+08
31	Out	2016-04-12 18:00:07.520903+08	2016-04-12 18:00:07.520903+08
53	Out	2016-04-12 18:00:38.861649+08	2016-04-12 18:00:38.861649+08
49	Out	2016-04-12 18:01:05.233725+08	2016-04-12 18:01:05.233725+08
53	Out	2016-04-12 18:01:20.164635+08	2016-04-12 18:01:20.164635+08
51	Out	2016-04-12 18:01:20.88343+08	2016-04-12 18:01:20.88343+08
23	Out	2016-04-12 18:01:37.154139+08	2016-04-12 18:01:37.154139+08
30	Out	2016-04-12 18:03:00.875391+08	2016-04-12 18:03:00.875391+08
41	Out	2016-04-12 18:08:32.759386+08	2016-04-12 18:08:32.759386+08
29	Out	2016-04-12 18:08:34.309301+08	2016-04-12 18:08:34.309301+08
52	Out	2016-04-12 18:15:10.109643+08	2016-04-12 18:15:10.109643+08
17	In	2016-04-13 08:30:49.431204+08	2016-04-13 08:30:49.431204+08
12	In	2016-04-13 08:31:09.492549+08	2016-04-13 08:31:09.492549+08
41	In	2016-04-13 08:31:56.270924+08	2016-04-13 08:31:56.270924+08
23	In	2016-04-13 08:32:35.511451+08	2016-04-13 08:32:35.511451+08
52	In	2016-04-13 08:33:11.418199+08	2016-04-13 08:33:11.418199+08
48	In	2016-04-13 08:33:12.678774+08	2016-04-13 08:33:12.678774+08
51	In	2016-04-13 08:34:11.752735+08	2016-04-13 08:34:11.752735+08
13	In	2016-04-13 08:36:05.518578+08	2016-04-13 08:36:05.518578+08
49	In	2016-04-13 08:37:50.780181+08	2016-04-13 08:37:50.780181+08
45	In	2016-04-13 08:43:23.998562+08	2016-04-13 08:43:23.998562+08
30	In	2016-04-13 08:47:28.993973+08	2016-04-13 08:47:28.993973+08
29	In	2016-04-13 08:51:11.761041+08	2016-04-13 08:51:11.761041+08
31	In	2016-04-13 08:51:18.488977+08	2016-04-13 08:51:18.488977+08
14	In	2016-04-13 08:51:30.13986+08	2016-04-13 08:51:30.13986+08
53	In	2016-04-13 08:51:38.945626+08	2016-04-13 08:51:38.945626+08
47	In	2016-04-13 08:54:41.919424+08	2016-04-13 08:54:41.919424+08
27	In	2016-04-13 08:56:19.064349+08	2016-04-13 08:56:19.064349+08
11	In	2016-04-13 08:58:20.602585+08	2016-04-13 08:58:20.602585+08
28	In	2016-04-13 10:15:54.024024+08	2016-04-13 10:15:54.024024+08
27	Out	2016-04-13 14:04:43.346297+08	2016-04-13 14:04:43.346297+08
45	Out	2016-04-13 14:23:42.24732+08	2016-04-13 14:23:42.24732+08
13	Out	2016-04-13 14:24:52.590205+08	2016-04-13 14:24:52.590205+08
47	Out	2016-04-13 14:25:20.278122+08	2016-04-13 14:25:20.278122+08
14	Out	2016-04-13 14:30:05.692436+08	2016-04-13 14:30:05.692436+08
17	Out	2016-04-13 14:33:14.866534+08	2016-04-13 14:33:14.866534+08
48	Out	2016-04-13 14:44:58.385084+08	2016-04-13 14:44:58.385084+08
28	Out	2016-04-13 16:04:26.270153+08	2016-04-13 16:04:26.270153+08
12	Out	2016-04-13 18:00:27.035313+08	2016-04-13 18:00:27.035313+08
51	Out	2016-04-13 18:01:04.057704+08	2016-04-13 18:01:04.057704+08
23	Out	2016-04-13 18:01:38.511965+08	2016-04-13 18:01:38.511965+08
31	Out	2016-04-13 18:01:54.31555+08	2016-04-13 18:01:54.31555+08
49	Out	2016-04-13 18:04:15.727987+08	2016-04-13 18:04:15.727987+08
53	Out	2016-04-13 18:05:35.631596+08	2016-04-13 18:05:35.631596+08
29	Out	2016-04-13 18:16:00.729923+08	2016-04-13 18:16:00.729923+08
41	Out	2016-04-13 18:16:23.533775+08	2016-04-13 18:16:23.533775+08
30	Out	2016-04-13 18:16:27.057098+08	2016-04-13 18:16:27.057098+08
23	In	2016-04-14 08:29:57.169257+08	2016-04-14 08:29:57.169257+08
17	In	2016-04-14 08:29:58.383964+08	2016-04-14 08:29:58.383964+08
51	In	2016-04-14 08:31:47.062745+08	2016-04-14 08:31:47.062745+08
48	In	2016-04-14 08:35:53.972518+08	2016-04-14 08:35:53.972518+08
27	In	2016-04-14 08:36:43.6938+08	2016-04-14 08:36:43.6938+08
13	In	2016-04-14 08:36:44.180863+08	2016-04-14 08:36:44.180863+08
11	In	2016-04-14 08:36:47.430069+08	2016-04-14 08:36:47.430069+08
41	In	2016-04-14 08:43:06.165113+08	2016-04-14 08:43:06.165113+08
30	In	2016-04-14 08:43:45.9271+08	2016-04-14 08:43:45.9271+08
49	In	2016-04-14 08:46:18.649939+08	2016-04-14 08:46:18.649939+08
45	In	2016-04-14 08:46:47.597099+08	2016-04-14 08:46:47.597099+08
31	In	2016-04-14 08:46:52.774808+08	2016-04-14 08:46:52.774808+08
53	In	2016-04-14 08:47:07.40125+08	2016-04-14 08:47:07.40125+08
47	In	2016-04-14 08:52:26.741095+08	2016-04-14 08:52:26.741095+08
12	In	2016-04-14 08:52:39.065177+08	2016-04-14 08:52:39.065177+08
29	In	2016-04-14 08:53:34.383375+08	2016-04-14 08:53:34.383375+08
14	In	2016-04-14 08:59:25.190734+08	2016-04-14 08:59:25.190734+08
28	In	2016-04-14 11:18:39.175535+08	2016-04-14 11:18:39.175535+08
12	Out	2016-04-14 14:02:58.430798+08	2016-04-14 14:02:58.430798+08
13	Out	2016-04-14 14:04:03.681611+08	2016-04-14 14:04:03.681611+08
27	Out	2016-04-14 14:04:30.600851+08	2016-04-14 14:04:30.600851+08
14	Out	2016-04-14 14:12:10.592478+08	2016-04-14 14:12:10.592478+08
11	Out	2016-04-14 14:24:06.563798+08	2016-04-14 14:24:06.563798+08
47	Out	2016-04-14 14:37:33.851884+08	2016-04-14 14:37:33.851884+08
45	Out	2016-04-14 14:39:45.188729+08	2016-04-14 14:39:45.188729+08
17	Out	2016-04-14 14:51:49.93815+08	2016-04-14 14:51:49.93815+08
51	Out	2016-04-14 15:07:04.934695+08	2016-04-14 15:07:04.934695+08
48	Out	2016-04-14 15:09:26.444993+08	2016-04-14 15:09:26.444993+08
28	Out	2016-04-14 16:20:21.226525+08	2016-04-14 16:20:21.226525+08
31	Out	2016-04-14 18:01:52.119506+08	2016-04-14 18:01:52.119506+08
49	Out	2016-04-14 18:06:11.213919+08	2016-04-14 18:06:11.213919+08
30	Out	2016-04-14 18:06:28.123888+08	2016-04-14 18:06:28.123888+08
29	Out	2016-04-14 18:06:29.439104+08	2016-04-14 18:06:29.439104+08
41	Out	2016-04-14 18:06:35.536093+08	2016-04-14 18:06:35.536093+08
23	Out	2016-04-14 18:09:32.824779+08	2016-04-14 18:09:32.824779+08
53	Out	2016-04-14 18:10:17.659105+08	2016-04-14 18:10:17.659105+08
17	In	2016-04-15 08:30:59.16119+08	2016-04-15 08:30:59.16119+08
48	In	2016-04-15 08:32:05.54094+08	2016-04-15 08:32:05.54094+08
49	In	2016-04-15 08:32:31.554688+08	2016-04-15 08:32:31.554688+08
49	Out	2016-04-15 08:32:39.37943+08	2016-04-15 08:32:39.37943+08
13	In	2016-04-15 08:32:56.936466+08	2016-04-15 08:32:56.936466+08
41	In	2016-04-15 08:33:21.155947+08	2016-04-15 08:33:21.155947+08
30	In	2016-04-15 08:33:23.292054+08	2016-04-15 08:33:23.292054+08
31	In	2016-04-15 08:33:35.526253+08	2016-04-15 08:33:35.526253+08
53	In	2016-04-15 08:34:51.035145+08	2016-04-15 08:34:51.035145+08
11	In	2016-04-15 08:36:38.443728+08	2016-04-15 08:36:38.443728+08
52	In	2016-04-15 08:37:15.589247+08	2016-04-15 08:37:15.589247+08
27	In	2016-04-15 08:37:56.252801+08	2016-04-15 08:37:56.252801+08
23	In	2016-04-15 08:43:56.282447+08	2016-04-15 08:43:56.282447+08
14	In	2016-04-15 08:44:53.20952+08	2016-04-15 08:44:53.20952+08
45	In	2016-04-15 08:49:48.852573+08	2016-04-15 08:49:48.852573+08
51	In	2016-04-15 08:53:09.289611+08	2016-04-15 08:53:09.289611+08
47	In	2016-04-15 09:03:50.143899+08	2016-04-15 09:03:50.143899+08
28	In	2016-04-15 11:52:01.906601+08	2016-04-15 11:52:01.906601+08
27	Out	2016-04-15 14:01:37.053412+08	2016-04-15 14:01:37.053412+08
12	Out	2016-04-15 14:03:08.60457+08	2016-04-15 14:03:08.60457+08
14	Out	2016-04-15 14:04:07.618085+08	2016-04-15 14:04:07.618085+08
48	Out	2016-04-15 14:23:14.496622+08	2016-04-15 14:23:14.496622+08
11	Out	2016-04-15 14:24:08.046747+08	2016-04-15 14:24:08.046747+08
13	Out	2016-04-15 14:27:40.257553+08	2016-04-15 14:27:40.257553+08
47	Out	2016-04-15 15:24:04.796339+08	2016-04-15 15:24:04.796339+08
17	In	2016-04-15 16:34:47.299253+08	2016-04-15 16:34:47.299253+08
17	Out	2016-04-15 16:35:02.610328+08	2016-04-15 16:35:02.610328+08
28	Out	2016-04-15 17:04:20.691315+08	2016-04-15 17:04:20.691315+08
51	Out	2016-04-15 18:00:38.745982+08	2016-04-15 18:00:38.745982+08
31	Out	2016-04-15 18:01:36.944431+08	2016-04-15 18:01:36.944431+08
30	Out	2016-04-15 18:02:08.50051+08	2016-04-15 18:02:08.50051+08
53	Out	2016-04-15 18:02:12.949148+08	2016-04-15 18:02:12.949148+08
23	Out	2016-04-15 18:02:25.757637+08	2016-04-15 18:02:25.757637+08
41	Out	2016-04-15 18:02:59.670202+08	2016-04-15 18:02:59.670202+08
31	In	2016-04-18 08:29:32.009784+08	2016-04-18 08:29:32.009784+08
41	In	2016-04-18 08:30:00.328552+08	2016-04-18 08:30:00.328552+08
17	In	2016-04-18 08:31:42.148331+08	2016-04-18 08:31:42.148331+08
48	In	2016-04-18 08:32:03.835185+08	2016-04-18 08:32:03.835185+08
49	In	2016-04-18 08:32:31.515344+08	2016-04-18 08:32:31.515344+08
13	In	2016-04-18 08:33:16.772739+08	2016-04-18 08:33:16.772739+08
30	In	2016-04-18 08:33:38.464454+08	2016-04-18 08:33:38.464454+08
23	In	2016-04-18 08:33:42.858705+08	2016-04-18 08:33:42.858705+08
12	In	2016-04-18 08:34:41.643048+08	2016-04-18 08:34:41.643048+08
51	In	2016-04-18 08:35:25.610008+08	2016-04-18 08:35:25.610008+08
47	In	2016-04-18 08:37:41.634433+08	2016-04-18 08:37:41.634433+08
45	In	2016-04-18 08:41:50.942765+08	2016-04-18 08:41:50.942765+08
11	In	2016-04-18 08:49:52.821684+08	2016-04-18 08:49:52.821684+08
28	In	2016-04-18 08:50:20.237115+08	2016-04-18 08:50:20.237115+08
27	In	2016-04-18 08:55:56.76872+08	2016-04-18 08:55:56.76872+08
14	In	2016-04-18 08:58:24.125212+08	2016-04-18 08:58:24.125212+08
29	In	2016-04-18 09:31:51.515943+08	2016-04-18 09:31:51.515943+08
13	Out	2016-04-18 14:03:03.678282+08	2016-04-18 14:03:03.678282+08
14	Out	2016-04-18 14:03:37.765149+08	2016-04-18 14:03:37.765149+08
12	Out	2016-04-18 14:05:29.604416+08	2016-04-18 14:05:29.604416+08
45	Out	2016-04-18 14:07:41.433207+08	2016-04-18 14:07:41.433207+08
48	Out	2016-04-18 14:39:16.604603+08	2016-04-18 14:39:16.604603+08
27	Out	2016-04-18 14:59:26.725999+08	2016-04-18 14:59:26.725999+08
47	Out	2016-04-18 15:59:58.534559+08	2016-04-18 15:59:58.534559+08
28	Out	2016-04-18 16:36:04.352159+08	2016-04-18 16:36:04.352159+08
17	Out	2016-04-18 17:13:53.57085+08	2016-04-18 17:13:53.57085+08
11	Out	2016-04-18 17:50:04.627001+08	2016-04-18 17:50:04.627001+08
31	Out	2016-04-18 18:00:18.275108+08	2016-04-18 18:00:18.275108+08
51	Out	2016-04-18 18:00:49.978635+08	2016-04-18 18:00:49.978635+08
23	Out	2016-04-18 18:01:37.173495+08	2016-04-18 18:01:37.173495+08
49	Out	2016-04-18 18:03:58.011535+08	2016-04-18 18:03:58.011535+08
30	Out	2016-04-18 18:08:06.868622+08	2016-04-18 18:08:06.868622+08
29	Out	2016-04-18 18:10:02.726678+08	2016-04-18 18:10:02.726678+08
41	Out	2016-04-18 18:10:18.879427+08	2016-04-18 18:10:18.879427+08
23	In	2016-04-19 08:04:06.876685+08	2016-04-19 08:04:06.876685+08
51	In	2016-04-19 08:04:16.039546+08	2016-04-19 08:04:16.039546+08
12	In	2016-04-19 08:04:23.04823+08	2016-04-19 08:04:23.04823+08
30	In	2016-04-19 08:05:52.25779+08	2016-04-19 08:05:52.25779+08
41	In	2016-04-19 08:08:24.492645+08	2016-04-19 08:08:24.492645+08
48	In	2016-04-19 08:09:00.538129+08	2016-04-19 08:09:00.538129+08
17	In	2016-04-19 08:09:53.413579+08	2016-04-19 08:09:53.413579+08
49	In	2016-04-19 08:14:40.954974+08	2016-04-19 08:14:40.954974+08
13	In	2016-04-19 08:15:19.193102+08	2016-04-19 08:15:19.193102+08
45	In	2016-04-19 08:31:33.73571+08	2016-04-19 08:31:33.73571+08
53	In	2016-04-19 08:31:36.06541+08	2016-04-19 08:31:36.06541+08
14	In	2016-04-19 08:43:53.370141+08	2016-04-19 08:43:53.370141+08
31	In	2016-04-19 08:49:14.231924+08	2016-04-19 08:49:14.231924+08
29	In	2016-04-19 08:50:47.809103+08	2016-04-19 08:50:47.809103+08
27	In	2016-04-19 08:53:01.981493+08	2016-04-19 08:53:01.981493+08
47	In	2016-04-19 08:53:38.004305+08	2016-04-19 08:53:38.004305+08
28	In	2016-04-19 09:47:06.88526+08	2016-04-19 09:47:06.88526+08
29	Out	2016-04-19 13:05:26.171374+08	2016-04-19 13:05:26.171374+08
27	Out	2016-04-19 14:05:42.54816+08	2016-04-19 14:05:42.54816+08
12	Out	2016-04-19 14:10:19.952031+08	2016-04-19 14:10:19.952031+08
17	Out	2016-04-19 14:52:01.935426+08	2016-04-19 14:52:01.935426+08
47	Out	2016-04-19 14:53:48.707569+08	2016-04-19 14:53:48.707569+08
14	Out	2016-04-19 15:03:37.395406+08	2016-04-19 15:03:37.395406+08
45	Out	2016-04-19 15:04:53.738271+08	2016-04-19 15:04:53.738271+08
13	Out	2016-04-19 15:09:36.892088+08	2016-04-19 15:09:36.892088+08
48	Out	2016-04-19 15:13:26.642955+08	2016-04-19 15:13:26.642955+08
28	Out	2016-04-19 15:56:40.035318+08	2016-04-19 15:56:40.035318+08
51	Out	2016-04-19 16:14:57.247727+08	2016-04-19 16:14:57.247727+08
23	Out	2016-04-19 18:02:01.529417+08	2016-04-19 18:02:01.529417+08
53	Out	2016-04-19 18:03:57.029597+08	2016-04-19 18:03:57.029597+08
41	Out	2016-04-19 18:04:18.282146+08	2016-04-19 18:04:18.282146+08
30	Out	2016-04-19 18:06:14.433905+08	2016-04-19 18:06:14.433905+08
31	Out	2016-04-19 18:11:56.253366+08	2016-04-19 18:11:56.253366+08
49	Out	2016-04-19 18:18:07.539181+08	2016-04-19 18:18:07.539181+08
11	In	2016-04-20 08:00:17.473524+08	2016-04-20 08:00:17.473524+08
12	In	2016-04-20 08:13:28.308564+08	2016-04-20 08:13:28.308564+08
51	In	2016-04-20 08:14:00.76975+08	2016-04-20 08:14:00.76975+08
41	In	2016-04-20 08:14:44.292354+08	2016-04-20 08:14:44.292354+08
30	In	2016-04-20 08:16:19.809794+08	2016-04-20 08:16:19.809794+08
23	In	2016-04-20 08:17:11.387931+08	2016-04-20 08:17:11.387931+08
13	In	2016-04-20 08:29:37.421123+08	2016-04-20 08:29:37.421123+08
45	In	2016-04-20 08:31:43.689536+08	2016-04-20 08:31:43.689536+08
17	In	2016-04-20 08:36:22.560568+08	2016-04-20 08:36:22.560568+08
27	In	2016-04-20 08:39:45.769286+08	2016-04-20 08:39:45.769286+08
48	In	2016-04-20 08:45:18.408088+08	2016-04-20 08:45:18.408088+08
47	In	2016-04-20 08:48:50.480097+08	2016-04-20 08:48:50.480097+08
53	In	2016-04-20 08:51:12.528535+08	2016-04-20 08:51:12.528535+08
31	In	2016-04-20 08:54:17.062332+08	2016-04-20 08:54:17.062332+08
14	In	2016-04-20 08:57:15.526067+08	2016-04-20 08:57:15.526067+08
28	In	2016-04-20 09:52:03.733317+08	2016-04-20 09:52:03.733317+08
29	In	2016-04-20 13:44:38.939789+08	2016-04-20 13:44:38.939789+08
12	Out	2016-04-20 14:02:56.412203+08	2016-04-20 14:02:56.412203+08
27	Out	2016-04-20 14:06:24.160004+08	2016-04-20 14:06:24.160004+08
13	Out	2016-04-20 14:32:02.45503+08	2016-04-20 14:32:02.45503+08
11	Out	2016-04-20 14:33:56.184472+08	2016-04-20 14:33:56.184472+08
48	Out	2016-04-20 14:34:55.389829+08	2016-04-20 14:34:55.389829+08
45	Out	2016-04-20 14:36:24.977451+08	2016-04-20 14:36:24.977451+08
14	Out	2016-04-20 14:49:29.488678+08	2016-04-20 14:49:29.488678+08
47	Out	2016-04-20 15:51:50.273226+08	2016-04-20 15:51:50.273226+08
53	Out	2016-04-20 18:00:41.694909+08	2016-04-20 18:00:41.694909+08
51	Out	2016-04-20 18:01:08.291927+08	2016-04-20 18:01:08.291927+08
23	Out	2016-04-20 18:01:28.362894+08	2016-04-20 18:01:28.362894+08
31	Out	2016-04-20 18:01:36.814239+08	2016-04-20 18:01:36.814239+08
41	Out	2016-04-20 18:03:50.212836+08	2016-04-20 18:03:50.212836+08
30	Out	2016-04-20 18:04:45.327733+08	2016-04-20 18:04:45.327733+08
29	Out	2016-04-20 18:07:03.111943+08	2016-04-20 18:07:03.111943+08
12	In	2016-04-21 08:05:17.765189+08	2016-04-21 08:05:17.765189+08
51	In	2016-04-21 08:05:31.976401+08	2016-04-21 08:05:31.976401+08
23	In	2016-04-21 08:06:13.069863+08	2016-04-21 08:06:13.069863+08
48	In	2016-04-21 08:08:45.163373+08	2016-04-21 08:08:45.163373+08
11	In	2016-04-21 08:12:54.943625+08	2016-04-21 08:12:54.943625+08
17	In	2016-04-21 08:13:16.692979+08	2016-04-21 08:13:16.692979+08
30	In	2016-04-21 08:13:46.079427+08	2016-04-21 08:13:46.079427+08
27	In	2016-04-21 08:37:27.086455+08	2016-04-21 08:37:27.086455+08
41	In	2016-04-21 08:38:01.103302+08	2016-04-21 08:38:01.103302+08
49	In	2016-04-21 08:38:03.769349+08	2016-04-21 08:38:03.769349+08
13	In	2016-04-21 08:38:05.263673+08	2016-04-21 08:38:05.263673+08
45	In	2016-04-21 08:39:56.492609+08	2016-04-21 08:39:56.492609+08
31	In	2016-04-21 08:41:47.711004+08	2016-04-21 08:41:47.711004+08
53	In	2016-04-21 08:49:06.700117+08	2016-04-21 08:49:06.700117+08
47	In	2016-04-21 08:56:12.682551+08	2016-04-21 08:56:12.682551+08
14	In	2016-04-21 08:57:33.017644+08	2016-04-21 08:57:33.017644+08
28	In	2016-04-21 10:11:16.740213+08	2016-04-21 10:11:16.740213+08
29	In	2016-04-21 13:24:54.323767+08	2016-04-21 13:24:54.323767+08
45	Out	2016-04-21 14:05:42.295651+08	2016-04-21 14:05:42.295651+08
14	Out	2016-04-21 14:06:10.102494+08	2016-04-21 14:06:10.102494+08
27	Out	2016-04-21 14:08:13.486144+08	2016-04-21 14:08:13.486144+08
13	Out	2016-04-21 14:08:32.982567+08	2016-04-21 14:08:32.982567+08
11	Out	2016-04-21 14:18:13.711624+08	2016-04-21 14:18:13.711624+08
48	Out	2016-04-21 14:32:49.016972+08	2016-04-21 14:32:49.016972+08
12	Out	2016-04-21 15:45:15.56218+08	2016-04-21 15:45:15.56218+08
17	Out	2016-04-21 16:47:31.576236+08	2016-04-21 16:47:31.576236+08
28	Out	2016-04-21 17:03:17.29095+08	2016-04-21 17:03:17.29095+08
47	Out	2016-04-21 17:03:33.637636+08	2016-04-21 17:03:33.637636+08
51	Out	2016-04-21 18:00:24.480995+08	2016-04-21 18:00:24.480995+08
31	Out	2016-04-21 18:00:27.151278+08	2016-04-21 18:00:27.151278+08
23	Out	2016-04-21 18:01:23.230471+08	2016-04-21 18:01:23.230471+08
53	Out	2016-04-21 18:01:41.301701+08	2016-04-21 18:01:41.301701+08
30	Out	2016-04-21 18:04:26.519505+08	2016-04-21 18:04:26.519505+08
49	Out	2016-04-21 18:08:58.162672+08	2016-04-21 18:08:58.162672+08
41	Out	2016-04-21 18:09:17.017136+08	2016-04-21 18:09:17.017136+08
29	Out	2016-04-21 18:12:26.04917+08	2016-04-21 18:12:26.04917+08
17	In	2016-04-22 08:14:17.77629+08	2016-04-22 08:14:17.77629+08
12	In	2016-04-22 08:16:24.614433+08	2016-04-22 08:16:24.614433+08
51	In	2016-04-22 08:17:21.059431+08	2016-04-22 08:17:21.059431+08
23	In	2016-04-22 08:27:04.375816+08	2016-04-22 08:27:04.375816+08
48	In	2016-04-22 08:30:36.09179+08	2016-04-22 08:30:36.09179+08
41	In	2016-04-22 08:30:47.27682+08	2016-04-22 08:30:47.27682+08
30	In	2016-04-22 08:36:52.094002+08	2016-04-22 08:36:52.094002+08
45	In	2016-04-22 08:36:52.509665+08	2016-04-22 08:36:52.509665+08
13	In	2016-04-22 08:37:54.275298+08	2016-04-22 08:37:54.275298+08
31	In	2016-04-22 08:39:45.294957+08	2016-04-22 08:39:45.294957+08
11	In	2016-04-22 08:43:33.280788+08	2016-04-22 08:43:33.280788+08
14	In	2016-04-22 08:52:59.520169+08	2016-04-22 08:52:59.520169+08
53	In	2016-04-22 08:54:10.891607+08	2016-04-22 08:54:10.891607+08
27	In	2016-04-22 09:01:41.970204+08	2016-04-22 09:01:41.970204+08
47	In	2016-04-22 09:02:21.286823+08	2016-04-22 09:02:21.286823+08
28	In	2016-04-22 09:40:41.303992+08	2016-04-22 09:40:41.303992+08
47	Out	2016-04-22 13:04:32.011209+08	2016-04-22 13:04:32.011209+08
45	Out	2016-04-22 14:03:45.304242+08	2016-04-22 14:03:45.304242+08
14	Out	2016-04-22 14:04:03.494082+08	2016-04-22 14:04:03.494082+08
48	Out	2016-04-22 14:04:14.415303+08	2016-04-22 14:04:14.415303+08
12	Out	2016-04-22 14:07:07.286226+08	2016-04-22 14:07:07.286226+08
11	Out	2016-04-22 14:08:52.485151+08	2016-04-22 14:08:52.485151+08
13	Out	2016-04-22 14:20:25.950258+08	2016-04-22 14:20:25.950258+08
28	Out	2016-04-22 16:06:52.322324+08	2016-04-22 16:06:52.322324+08
17	Out	2016-04-22 16:19:19.881335+08	2016-04-22 16:19:19.881335+08
51	Out	2016-04-22 18:01:08.342192+08	2016-04-22 18:01:08.342192+08
31	Out	2016-04-22 18:01:19.801216+08	2016-04-22 18:01:19.801216+08
30	Out	2016-04-22 18:02:40.013262+08	2016-04-22 18:02:40.013262+08
23	Out	2016-04-22 18:04:00.892552+08	2016-04-22 18:04:00.892552+08
41	Out	2016-04-22 18:06:38.339303+08	2016-04-22 18:06:38.339303+08
28	In	2016-04-25 08:40:49.911384+08	2016-04-25 08:40:49.911384+08
23	In	2016-04-25 08:41:13.704341+08	2016-04-25 08:41:13.704341+08
12	In	2016-04-25 08:41:31.712721+08	2016-04-25 08:41:31.712721+08
17	In	2016-04-25 08:42:13.546889+08	2016-04-25 08:42:13.546889+08
47	In	2016-04-25 08:44:23.481088+08	2016-04-25 08:44:23.481088+08
27	In	2016-04-25 08:48:35.8417+08	2016-04-25 08:48:35.8417+08
41	In	2016-04-25 08:49:16.097985+08	2016-04-25 08:49:16.097985+08
30	In	2016-04-25 08:50:19.71634+08	2016-04-25 08:50:19.71634+08
29	In	2016-04-25 08:50:39.983132+08	2016-04-25 08:50:39.983132+08
11	In	2016-04-25 08:51:04.448435+08	2016-04-25 08:51:04.448435+08
51	In	2016-04-25 08:53:03.442342+08	2016-04-25 08:53:03.442342+08
31	In	2016-04-25 08:55:16.18937+08	2016-04-25 08:55:16.18937+08
45	In	2016-04-25 08:55:46.543783+08	2016-04-25 08:55:46.543783+08
48	In	2016-04-25 08:55:48.645398+08	2016-04-25 08:55:48.645398+08
53	In	2016-04-25 08:56:21.164889+08	2016-04-25 08:56:21.164889+08
14	In	2016-04-25 08:56:37.24013+08	2016-04-25 08:56:37.24013+08
13	In	2016-04-25 09:27:56.617747+08	2016-04-25 09:27:56.617747+08
49	In	2016-04-25 12:52:38.669416+08	2016-04-25 12:52:38.669416+08
12	Out	2016-04-25 14:12:42.435709+08	2016-04-25 14:12:42.435709+08
47	Out	2016-04-25 16:02:34.899161+08	2016-04-25 16:02:34.899161+08
27	Out	2016-04-25 16:19:02.123638+08	2016-04-25 16:19:02.123638+08
13	Out	2016-04-25 16:42:14.925248+08	2016-04-25 16:42:14.925248+08
11	Out	2016-04-25 17:06:40.22575+08	2016-04-25 17:06:40.22575+08
14	Out	2016-04-25 18:01:03.506746+08	2016-04-25 18:01:03.506746+08
53	Out	2016-04-25 18:01:03.653685+08	2016-04-25 18:01:03.653685+08
61	Out	2016-04-25 18:01:06.922924+08	2016-04-25 18:01:06.922924+08
31	Out	2016-04-25 18:01:42.619431+08	2016-04-25 18:01:42.619431+08
49	Out	2016-04-25 18:02:15.985041+08	2016-04-25 18:02:15.985041+08
30	Out	2016-04-25 18:02:57.592938+08	2016-04-25 18:02:57.592938+08
41	Out	2016-04-25 18:03:16.802483+08	2016-04-25 18:03:16.802483+08
29	Out	2016-04-25 18:03:17.581383+08	2016-04-25 18:03:17.581383+08
48	Out	2016-04-25 18:08:53.762218+08	2016-04-25 18:08:53.762218+08
51	Out	2016-04-25 18:11:36.354517+08	2016-04-25 18:11:36.354517+08
28	Out	2016-04-25 18:16:51.729942+08	2016-04-25 18:16:51.729942+08
45	Out	2016-04-25 18:17:14.686754+08	2016-04-25 18:17:14.686754+08
17	Out	2016-04-25 18:25:17.574674+08	2016-04-25 18:25:17.574674+08
23	Out	2016-04-25 18:33:51.63577+08	2016-04-25 18:33:51.63577+08
17	In	2016-04-26 08:20:16.778447+08	2016-04-26 08:20:16.778447+08
41	In	2016-04-26 08:24:31.957329+08	2016-04-26 08:24:31.957329+08
30	In	2016-04-26 08:29:19.459334+08	2016-04-26 08:29:19.459334+08
13	In	2016-04-26 08:29:42.594916+08	2016-04-26 08:29:42.594916+08
59	In	2016-04-26 08:31:45.923468+08	2016-04-26 08:31:45.923468+08
55	In	2016-04-26 08:32:20.911639+08	2016-04-26 08:32:20.911639+08
58	In	2016-04-26 08:32:24.613312+08	2016-04-26 08:32:24.613312+08
12	In	2016-04-26 08:35:03.496862+08	2016-04-26 08:35:03.496862+08
23	In	2016-04-26 08:40:04.244572+08	2016-04-26 08:40:04.244572+08
54	In	2016-04-26 08:40:32.675869+08	2016-04-26 08:40:32.675869+08
47	In	2016-04-26 08:42:05.69466+08	2016-04-26 08:42:05.69466+08
51	In	2016-04-26 08:45:13.202318+08	2016-04-26 08:45:13.202318+08
62	In	2016-04-26 08:50:51.68625+08	2016-04-26 08:50:51.68625+08
29	In	2016-04-26 08:58:19.447925+08	2016-04-26 08:58:19.447925+08
36	In	2016-04-26 09:00:08.539633+08	2016-04-26 09:00:08.539633+08
60	In	2016-04-26 09:03:21.028188+08	2016-04-26 09:03:21.028188+08
31	In	2016-04-26 09:08:17.470316+08	2016-04-26 09:08:17.470316+08
53	In	2016-04-26 09:09:36.323954+08	2016-04-26 09:09:36.323954+08
56	In	2016-04-26 09:21:50.641071+08	2016-04-26 09:21:50.641071+08
28	In	2016-04-26 11:54:19.763352+08	2016-04-26 11:54:19.763352+08
49	In	2016-04-26 13:00:44.394943+08	2016-04-26 13:00:44.394943+08
57	In	2016-04-26 13:05:58.992231+08	2016-04-26 13:05:58.992231+08
27	In	2016-04-26 13:58:15.708662+08	2016-04-26 13:58:15.708662+08
12	Out	2016-04-26 14:17:42.658662+08	2016-04-26 14:17:42.658662+08
13	Out	2016-04-26 14:36:16.487097+08	2016-04-26 14:36:16.487097+08
17	Out	2016-04-26 16:30:32.609016+08	2016-04-26 16:30:32.609016+08
47	Out	2016-04-26 16:34:38.066929+08	2016-04-26 16:34:38.066929+08
28	Out	2016-04-26 16:53:05.496249+08	2016-04-26 16:53:05.496249+08
60	Out	2016-04-26 18:00:09.204857+08	2016-04-26 18:00:09.204857+08
27	Out	2016-04-26 18:00:47.211363+08	2016-04-26 18:00:47.211363+08
53	Out	2016-04-26 18:01:48.398144+08	2016-04-26 18:01:48.398144+08
49	Out	2016-04-26 18:02:21.396687+08	2016-04-26 18:02:21.396687+08
62	Out	2016-04-26 18:02:26.108485+08	2016-04-26 18:02:26.108485+08
61	Out	2016-04-26 18:02:59.699153+08	2016-04-26 18:02:59.699153+08
31	Out	2016-04-26 18:04:09.226406+08	2016-04-26 18:04:09.226406+08
51	Out	2016-04-26 18:05:04.549277+08	2016-04-26 18:05:04.549277+08
30	Out	2016-04-26 18:05:17.457805+08	2016-04-26 18:05:17.457805+08
29	Out	2016-04-26 18:05:32.080811+08	2016-04-26 18:05:32.080811+08
55	Out	2016-04-26 18:06:14.128951+08	2016-04-26 18:06:14.128951+08
23	Out	2016-04-26 18:06:35.49583+08	2016-04-26 18:06:35.49583+08
56	Out	2016-04-26 18:06:37.151567+08	2016-04-26 18:06:37.151567+08
58	Out	2016-04-26 18:10:00.121439+08	2016-04-26 18:10:00.121439+08
59	Out	2016-04-26 18:10:41.241086+08	2016-04-26 18:10:41.241086+08
54	Out	2016-04-26 18:11:13.229581+08	2016-04-26 18:11:13.229581+08
57	Out	2016-04-26 18:11:50.462863+08	2016-04-26 18:11:50.462863+08
62	In	2016-04-27 08:24:11.317967+08	2016-04-27 08:24:11.317967+08
17	In	2016-04-27 08:24:19.193593+08	2016-04-27 08:24:19.193593+08
61	In	2016-04-27 08:25:11.3097+08	2016-04-27 08:25:11.3097+08
30	In	2016-04-27 08:25:27.609572+08	2016-04-27 08:25:27.609572+08
13	In	2016-04-27 08:26:29.81412+08	2016-04-27 08:26:29.81412+08
55	In	2016-04-27 08:27:05.823959+08	2016-04-27 08:27:05.823959+08
56	In	2016-04-27 08:27:18.0465+08	2016-04-27 08:27:18.0465+08
59	In	2016-04-27 08:28:09.534734+08	2016-04-27 08:28:09.534734+08
23	In	2016-04-27 08:28:29.214999+08	2016-04-27 08:28:29.214999+08
58	In	2016-04-27 08:28:49.241351+08	2016-04-27 08:28:49.241351+08
12	In	2016-04-27 08:29:11.88815+08	2016-04-27 08:29:11.88815+08
41	In	2016-04-27 08:29:13.723016+08	2016-04-27 08:29:13.723016+08
31	In	2016-04-27 08:36:12.536775+08	2016-04-27 08:36:12.536775+08
54	In	2016-04-27 08:36:52.700609+08	2016-04-27 08:36:52.700609+08
27	In	2016-04-27 08:46:13.699325+08	2016-04-27 08:46:13.699325+08
29	In	2016-04-27 08:50:33.34739+08	2016-04-27 08:50:33.34739+08
53	In	2016-04-27 08:53:03.273148+08	2016-04-27 08:53:03.273148+08
57	In	2016-04-27 09:15:54.544293+08	2016-04-27 09:15:54.544293+08
28	In	2016-04-27 10:55:56.546748+08	2016-04-27 10:55:56.546748+08
47	In	2016-04-27 10:58:46.370281+08	2016-04-27 10:58:46.370281+08
49	In	2016-04-27 13:45:34.990615+08	2016-04-27 13:45:34.990615+08
12	Out	2016-04-27 14:00:19.794185+08	2016-04-27 14:00:19.794185+08
27	Out	2016-04-27 14:55:37.433724+08	2016-04-27 14:55:37.433724+08
17	Out	2016-04-27 15:16:58.211286+08	2016-04-27 15:16:58.211286+08
47	Out	2016-04-27 16:00:27.898276+08	2016-04-27 16:00:27.898276+08
53	Out	2016-04-27 17:57:10.346007+08	2016-04-27 17:57:10.346007+08
31	Out	2016-04-27 18:00:17.90106+08	2016-04-27 18:00:17.90106+08
23	Out	2016-04-27 18:03:01.181707+08	2016-04-27 18:03:01.181707+08
41	Out	2016-04-27 18:04:00.829197+08	2016-04-27 18:04:00.829197+08
30	Out	2016-04-27 18:05:36.486832+08	2016-04-27 18:05:36.486832+08
62	Out	2016-04-27 18:05:46.804534+08	2016-04-27 18:05:46.804534+08
49	Out	2016-04-27 18:06:09.110067+08	2016-04-27 18:06:09.110067+08
28	Out	2016-04-27 18:08:16.11675+08	2016-04-27 18:08:16.11675+08
61	Out	2016-04-27 18:09:41.645002+08	2016-04-27 18:09:41.645002+08
29	Out	2016-04-27 18:13:06.841325+08	2016-04-27 18:13:06.841325+08
57	Out	2016-04-27 18:31:57.064589+08	2016-04-27 18:31:57.064589+08
59	Out	2016-04-27 18:35:04.365154+08	2016-04-27 18:35:04.365154+08
56	Out	2016-04-27 18:36:30.376736+08	2016-04-27 18:36:30.376736+08
58	Out	2016-04-27 18:38:26.808561+08	2016-04-27 18:38:26.808561+08
55	Out	2016-04-27 18:41:11.587747+08	2016-04-27 18:41:11.587747+08
54	Out	2016-04-27 18:45:50.121475+08	2016-04-27 18:45:50.121475+08
12	In	2016-04-28 07:49:42.996569+08	2016-04-28 07:49:42.996569+08
17	In	2016-04-28 07:50:04.85199+08	2016-04-28 07:50:04.85199+08
51	In	2016-04-28 07:50:21.955072+08	2016-04-28 07:50:21.955072+08
23	In	2016-04-28 07:51:44.619562+08	2016-04-28 07:51:44.619562+08
41	In	2016-04-28 08:10:27.526843+08	2016-04-28 08:10:27.526843+08
30	In	2016-04-28 08:10:29.85421+08	2016-04-28 08:10:29.85421+08
58	In	2016-04-28 08:17:03.217213+08	2016-04-28 08:17:03.217213+08
49	In	2016-04-28 08:19:24.459467+08	2016-04-28 08:19:24.459467+08
59	In	2016-04-28 08:20:50.333302+08	2016-04-28 08:20:50.333302+08
55	In	2016-04-28 08:21:36.520014+08	2016-04-28 08:21:36.520014+08
13	In	2016-04-28 08:28:12.637052+08	2016-04-28 08:28:12.637052+08
53	In	2016-04-28 08:29:05.856103+08	2016-04-28 08:29:05.856103+08
62	In	2016-04-28 08:41:48.929816+08	2016-04-28 08:41:48.929816+08
57	In	2016-04-28 08:42:38.405059+08	2016-04-28 08:42:38.405059+08
29	In	2016-04-28 08:45:21.462874+08	2016-04-28 08:45:21.462874+08
61	In	2016-04-28 08:53:03.867744+08	2016-04-28 08:53:03.867744+08
54	In	2016-04-28 08:59:01.986844+08	2016-04-28 08:59:01.986844+08
31	In	2016-04-28 08:59:34.908109+08	2016-04-28 08:59:34.908109+08
56	In	2016-04-28 09:01:09.823988+08	2016-04-28 09:01:09.823988+08
28	In	2016-04-28 10:28:01.376361+08	2016-04-28 10:28:01.376361+08
47	In	2016-04-28 10:32:49.142386+08	2016-04-28 10:32:49.142386+08
27	In	2016-04-28 12:56:34.081094+08	2016-04-28 12:56:34.081094+08
12	Out	2016-04-28 14:07:11.154857+08	2016-04-28 14:07:11.154857+08
49	Out	2016-04-28 14:08:47.063263+08	2016-04-28 14:08:47.063263+08
17	Out	2016-04-28 15:00:24.289539+08	2016-04-28 15:00:24.289539+08
28	Out	2016-04-28 16:51:39.074802+08	2016-04-28 16:51:39.074802+08
53	Out	2016-04-28 18:00:23.236822+08	2016-04-28 18:00:23.236822+08
51	Out	2016-04-28 18:01:17.562716+08	2016-04-28 18:01:17.562716+08
31	Out	2016-04-28 18:01:47.39189+08	2016-04-28 18:01:47.39189+08
27	Out	2016-04-28 18:01:53.905188+08	2016-04-28 18:01:53.905188+08
23	Out	2016-04-28 18:02:46.700617+08	2016-04-28 18:02:46.700617+08
61	Out	2016-04-28 18:03:02.106523+08	2016-04-28 18:03:02.106523+08
55	Out	2016-04-28 18:03:24.480561+08	2016-04-28 18:03:24.480561+08
62	Out	2016-04-28 18:04:20.916316+08	2016-04-28 18:04:20.916316+08
30	Out	2016-04-28 18:05:11.297428+08	2016-04-28 18:05:11.297428+08
41	Out	2016-04-28 18:05:53.121671+08	2016-04-28 18:05:53.121671+08
29	Out	2016-04-28 18:06:05.911413+08	2016-04-28 18:06:05.911413+08
56	Out	2016-04-28 18:11:44.122199+08	2016-04-28 18:11:44.122199+08
58	Out	2016-04-28 18:13:02.210185+08	2016-04-28 18:13:02.210185+08
59	Out	2016-04-28 18:14:03.679607+08	2016-04-28 18:14:03.679607+08
57	Out	2016-04-28 18:16:11.126944+08	2016-04-28 18:16:11.126944+08
13	Out	2016-04-28 18:59:46.112635+08	2016-04-28 18:59:46.112635+08
54	Out	2016-04-28 19:11:37.977561+08	2016-04-28 19:11:37.977561+08
23	In	2016-04-29 07:53:22.823123+08	2016-04-29 07:53:22.823123+08
17	In	2016-04-29 07:54:49.637936+08	2016-04-29 07:54:49.637936+08
12	In	2016-04-29 07:56:42.207009+08	2016-04-29 07:56:42.207009+08
51	In	2016-04-29 07:58:26.652461+08	2016-04-29 07:58:26.652461+08
41	In	2016-04-29 08:23:41.797995+08	2016-04-29 08:23:41.797995+08
58	In	2016-04-29 08:28:50.190477+08	2016-04-29 08:28:50.190477+08
59	In	2016-04-29 08:29:41.719487+08	2016-04-29 08:29:41.719487+08
61	In	2016-04-29 08:33:18.734467+08	2016-04-29 08:33:18.734467+08
62	In	2016-04-29 08:44:23.805663+08	2016-04-29 08:44:23.805663+08
53	In	2016-04-29 08:50:58.103049+08	2016-04-29 08:50:58.103049+08
27	In	2016-04-29 08:57:53.139694+08	2016-04-29 08:57:53.139694+08
29	In	2016-04-29 08:58:01.537696+08	2016-04-29 08:58:01.537696+08
28	In	2016-04-29 09:10:26.279215+08	2016-04-29 09:10:26.279215+08
60	In	2016-04-29 09:38:40.9189+08	2016-04-29 09:38:40.9189+08
57	In	2016-04-29 09:46:18.153736+08	2016-04-29 09:46:18.153736+08
47	In	2016-04-29 10:56:41.064405+08	2016-04-29 10:56:41.064405+08
12	Out	2016-04-29 14:19:28.69733+08	2016-04-29 14:19:28.69733+08
17	Out	2016-04-29 15:23:55.046197+08	2016-04-29 15:23:55.046197+08
58	Out	2016-04-29 16:23:04.751028+08	2016-04-29 16:23:04.751028+08
59	Out	2016-04-29 16:23:49.486684+08	2016-04-29 16:23:49.486684+08
27	Out	2016-04-29 17:10:57.019169+08	2016-04-29 17:10:57.019169+08
47	Out	2016-04-29 17:15:33.355703+08	2016-04-29 17:15:33.355703+08
28	Out	2016-04-29 17:50:37.6604+08	2016-04-29 17:50:37.6604+08
61	Out	2016-04-29 18:00:07.036893+08	2016-04-29 18:00:07.036893+08
62	Out	2016-04-29 18:01:02.766596+08	2016-04-29 18:01:02.766596+08
60	Out	2016-04-29 18:02:46.818461+08	2016-04-29 18:02:46.818461+08
51	Out	2016-04-29 18:03:55.107442+08	2016-04-29 18:03:55.107442+08
53	Out	2016-04-29 18:05:19.670053+08	2016-04-29 18:05:19.670053+08
29	Out	2016-04-29 18:06:35.277007+08	2016-04-29 18:06:35.277007+08
41	Out	2016-04-29 18:06:58.35213+08	2016-04-29 18:06:58.35213+08
57	Out	2016-04-29 18:07:15.515065+08	2016-04-29 18:07:15.515065+08
23	Out	2016-04-29 18:15:06.784629+08	2016-04-29 18:15:06.784629+08
23	In	2016-05-02 08:12:26.313654+08	2016-05-02 08:12:26.313654+08
12	In	2016-05-02 08:13:07.361471+08	2016-05-02 08:13:07.361471+08
17	In	2016-05-02 08:13:20.355859+08	2016-05-02 08:13:20.355859+08
62	In	2016-05-02 08:17:08.424608+08	2016-05-02 08:17:08.424608+08
28	In	2016-05-02 08:21:22.052952+08	2016-05-02 08:21:22.052952+08
53	In	2016-05-02 08:34:08.255687+08	2016-05-02 08:34:08.255687+08
41	In	2016-05-02 08:36:45.548022+08	2016-05-02 08:36:45.548022+08
57	In	2016-05-02 08:36:54.414612+08	2016-05-02 08:36:54.414612+08
55	In	2016-05-02 08:37:17.010826+08	2016-05-02 08:37:17.010826+08
54	In	2016-05-02 08:37:27.722534+08	2016-05-02 08:37:27.722534+08
31	In	2016-05-02 08:37:35.021863+08	2016-05-02 08:37:35.021863+08
30	In	2016-05-02 08:37:41.509633+08	2016-05-02 08:37:41.509633+08
56	In	2016-05-02 08:37:46.140458+08	2016-05-02 08:37:46.140458+08
58	In	2016-05-02 08:38:21.610762+08	2016-05-02 08:38:21.610762+08
59	In	2016-05-02 08:39:53.454413+08	2016-05-02 08:39:53.454413+08
27	In	2016-05-02 08:40:10.169878+08	2016-05-02 08:40:10.169878+08
29	In	2016-05-02 08:57:24.436361+08	2016-05-02 08:57:24.436361+08
51	In	2016-05-02 08:57:40.773903+08	2016-05-02 08:57:40.773903+08
61	In	2016-05-02 08:59:20.800553+08	2016-05-02 08:59:20.800553+08
47	In	2016-05-02 09:10:16.882488+08	2016-05-02 09:10:16.882488+08
60	In	2016-05-02 10:28:07.775117+08	2016-05-02 10:28:07.775117+08
47	Out	2016-05-02 17:05:38.663552+08	2016-05-02 17:05:38.663552+08
31	Out	2016-05-02 18:01:04.615188+08	2016-05-02 18:01:04.615188+08
60	Out	2016-05-02 18:01:15.372921+08	2016-05-02 18:01:15.372921+08
23	Out	2016-05-02 18:02:38.764446+08	2016-05-02 18:02:38.764446+08
12	Out	2016-05-02 18:02:45.650862+08	2016-05-02 18:02:45.650862+08
51	Out	2016-05-02 18:04:55.856426+08	2016-05-02 18:04:55.856426+08
61	Out	2016-05-02 18:06:41.860495+08	2016-05-02 18:06:41.860495+08
27	Out	2016-05-02 18:06:47.559663+08	2016-05-02 18:06:47.559663+08
17	Out	2016-05-02 18:06:50.299171+08	2016-05-02 18:06:50.299171+08
11	Out	2016-05-02 18:07:23.443233+08	2016-05-02 18:07:23.443233+08
62	Out	2016-05-02 18:09:04.829664+08	2016-05-02 18:09:04.829664+08
53	Out	2016-05-02 18:09:20.012264+08	2016-05-02 18:09:20.012264+08
55	Out	2016-05-02 18:09:51.386624+08	2016-05-02 18:09:51.386624+08
59	Out	2016-05-02 18:10:14.379141+08	2016-05-02 18:10:14.379141+08
29	Out	2016-05-02 18:11:25.975499+08	2016-05-02 18:11:25.975499+08
41	Out	2016-05-02 18:11:33.426531+08	2016-05-02 18:11:33.426531+08
28	Out	2016-05-02 18:13:16.727538+08	2016-05-02 18:13:16.727538+08
30	Out	2016-05-02 18:14:10.017736+08	2016-05-02 18:14:10.017736+08
54	Out	2016-05-02 18:16:33.708445+08	2016-05-02 18:16:33.708445+08
56	Out	2016-05-02 18:17:38.4667+08	2016-05-02 18:17:38.4667+08
58	Out	2016-05-02 18:20:07.337164+08	2016-05-02 18:20:07.337164+08
57	Out	2016-05-02 18:21:27.314656+08	2016-05-02 18:21:27.314656+08
12	In	2016-05-03 07:38:30.771988+08	2016-05-03 07:38:30.771988+08
23	In	2016-05-03 07:41:04.485448+08	2016-05-03 07:41:04.485448+08
17	In	2016-05-03 07:49:20.265136+08	2016-05-03 07:49:20.265136+08
56	In	2016-05-03 07:56:18.582202+08	2016-05-03 07:56:18.582202+08
61	In	2016-05-03 07:58:05.258715+08	2016-05-03 07:58:05.258715+08
51	In	2016-05-03 08:00:04.538272+08	2016-05-03 08:00:04.538272+08
62	In	2016-05-03 08:10:34.653562+08	2016-05-03 08:10:34.653562+08
30	In	2016-05-03 08:14:58.754161+08	2016-05-03 08:14:58.754161+08
41	In	2016-05-03 08:23:42.747554+08	2016-05-03 08:23:42.747554+08
11	In	2016-05-03 08:24:43.891445+08	2016-05-03 08:24:43.891445+08
31	In	2016-05-03 08:29:48.367025+08	2016-05-03 08:29:48.367025+08
45	In	2016-05-03 08:30:03.787529+08	2016-05-03 08:30:03.787529+08
59	In	2016-05-03 08:30:21.182989+08	2016-05-03 08:30:21.182989+08
53	In	2016-05-03 08:33:35.303984+08	2016-05-03 08:33:35.303984+08
29	In	2016-05-03 09:20:52.919674+08	2016-05-03 09:20:52.919674+08
60	In	2016-05-03 09:51:30.39731+08	2016-05-03 09:51:30.39731+08
28	In	2016-05-03 10:30:50.855149+08	2016-05-03 10:30:50.855149+08
13	In	2016-05-03 10:43:15.937772+08	2016-05-03 10:43:15.937772+08
27	In	2016-05-03 10:48:26.860588+08	2016-05-03 10:48:26.860588+08
47	In	2016-05-03 11:45:46.090586+08	2016-05-03 11:45:46.090586+08
61	Out	2016-05-03 12:01:20.211183+08	2016-05-03 12:01:20.211183+08
57	In	2016-05-03 12:48:41.270855+08	2016-05-03 12:48:41.270855+08
45	Out	2016-05-03 14:05:53.266728+08	2016-05-03 14:05:53.266728+08
11	Out	2016-05-03 14:13:34.203927+08	2016-05-03 14:13:34.203927+08
12	Out	2016-05-03 15:18:09.450667+08	2016-05-03 15:18:09.450667+08
17	Out	2016-05-03 15:19:01.281189+08	2016-05-03 15:19:01.281189+08
27	Out	2016-05-03 16:00:35.473591+08	2016-05-03 16:00:35.473591+08
13	Out	2016-05-03 16:32:02.224626+08	2016-05-03 16:32:02.224626+08
23	Out	2016-05-03 17:12:32.502234+08	2016-05-03 17:12:32.502234+08
62	Out	2016-05-03 17:14:30.603541+08	2016-05-03 17:14:30.603541+08
47	Out	2016-05-03 17:15:52.08151+08	2016-05-03 17:15:52.08151+08
56	Out	2016-05-03 17:25:24.487935+08	2016-05-03 17:25:24.487935+08
28	Out	2016-05-03 17:28:56.760856+08	2016-05-03 17:28:56.760856+08
51	Out	2016-05-03 17:59:14.883437+08	2016-05-03 17:59:14.883437+08
31	Out	2016-05-03 18:00:26.707555+08	2016-05-03 18:00:26.707555+08
60	Out	2016-05-03 18:00:35.780243+08	2016-05-03 18:00:35.780243+08
59	Out	2016-05-03 18:00:36.412034+08	2016-05-03 18:00:36.412034+08
30	Out	2016-05-03 18:01:30.393585+08	2016-05-03 18:01:30.393585+08
41	Out	2016-05-03 18:02:49.430325+08	2016-05-03 18:02:49.430325+08
53	Out	2016-05-03 18:02:51.904718+08	2016-05-03 18:02:51.904718+08
29	Out	2016-05-03 18:04:12.911486+08	2016-05-03 18:04:12.911486+08
57	Out	2016-05-03 18:05:06.663871+08	2016-05-03 18:05:06.663871+08
31	In	2016-05-04 07:37:21.699256+08	2016-05-04 07:37:21.699256+08
12	In	2016-05-04 07:40:57.215395+08	2016-05-04 07:40:57.215395+08
41	In	2016-05-04 07:40:57.821057+08	2016-05-04 07:40:57.821057+08
59	In	2016-05-04 07:41:30.934865+08	2016-05-04 07:41:30.934865+08
30	In	2016-05-04 07:41:36.511774+08	2016-05-04 07:41:36.511774+08
23	In	2016-05-04 07:41:57.866733+08	2016-05-04 07:41:57.866733+08
29	In	2016-05-04 07:49:34.233248+08	2016-05-04 07:49:34.233248+08
62	In	2016-05-04 08:14:49.865072+08	2016-05-04 08:14:49.865072+08
56	In	2016-05-04 08:22:03.000275+08	2016-05-04 08:22:03.000275+08
51	In	2016-05-04 08:33:04.147012+08	2016-05-04 08:33:04.147012+08
53	In	2016-05-04 08:35:22.708248+08	2016-05-04 08:35:22.708248+08
45	In	2016-05-04 08:47:52.428919+08	2016-05-04 08:47:52.428919+08
17	In	2016-05-04 09:45:23.831192+08	2016-05-04 09:45:23.831192+08
57	In	2016-05-04 10:04:50.11911+08	2016-05-04 10:04:50.11911+08
27	In	2016-05-04 10:37:08.700258+08	2016-05-04 10:37:08.700258+08
47	In	2016-05-04 11:45:24.918043+08	2016-05-04 11:45:24.918043+08
12	Out	2016-05-04 13:00:29.86055+08	2016-05-04 13:00:29.86055+08
58	In	2016-05-04 13:38:15.54731+08	2016-05-04 13:38:15.54731+08
45	Out	2016-05-04 14:03:00.79846+08	2016-05-04 14:03:00.79846+08
62	Out	2016-05-04 15:15:49.972635+08	2016-05-04 15:15:49.972635+08
56	Out	2016-05-04 15:21:41.958552+08	2016-05-04 15:21:41.958552+08
27	Out	2016-05-04 16:00:54.258638+08	2016-05-04 16:00:54.258638+08
17	Out	2016-05-04 16:13:05.916983+08	2016-05-04 16:13:05.916983+08
31	Out	2016-05-04 17:00:39.899183+08	2016-05-04 17:00:39.899183+08
41	Out	2016-05-04 17:03:32.748348+08	2016-05-04 17:03:32.748348+08
30	Out	2016-05-04 17:05:52.83259+08	2016-05-04 17:05:52.83259+08
29	Out	2016-05-04 17:07:48.646416+08	2016-05-04 17:07:48.646416+08
23	Out	2016-05-04 17:18:52.339022+08	2016-05-04 17:18:52.339022+08
51	Out	2016-05-04 18:00:15.544543+08	2016-05-04 18:00:15.544543+08
47	Out	2016-05-04 18:06:38.290739+08	2016-05-04 18:06:38.290739+08
53	Out	2016-05-04 18:14:14.289185+08	2016-05-04 18:14:14.289185+08
58	Out	2016-05-04 18:25:29.209172+08	2016-05-04 18:25:29.209172+08
59	Out	2016-05-04 18:26:49.527954+08	2016-05-04 18:26:49.527954+08
57	Out	2016-05-04 19:12:13.180613+08	2016-05-04 19:12:13.180613+08
12	In	2016-05-05 07:17:06.728972+08	2016-05-05 07:17:06.728972+08
23	In	2016-05-05 07:19:44.951689+08	2016-05-05 07:19:44.951689+08
17	In	2016-05-05 07:33:52.867653+08	2016-05-05 07:33:52.867653+08
62	In	2016-05-05 07:51:23.435527+08	2016-05-05 07:51:23.435527+08
41	In	2016-05-05 07:53:14.69095+08	2016-05-05 07:53:14.69095+08
53	In	2016-05-05 07:53:27.673515+08	2016-05-05 07:53:27.673515+08
59	In	2016-05-05 07:53:57.792458+08	2016-05-05 07:53:57.792458+08
30	In	2016-05-05 07:54:24.035486+08	2016-05-05 07:54:24.035486+08
56	In	2016-05-05 08:02:38.447866+08	2016-05-05 08:02:38.447866+08
61	In	2016-05-05 08:04:50.942091+08	2016-05-05 08:04:50.942091+08
31	In	2016-05-05 08:07:58.057283+08	2016-05-05 08:07:58.057283+08
45	In	2016-05-05 08:44:37.204903+08	2016-05-05 08:44:37.204903+08
29	In	2016-05-05 08:58:49.34369+08	2016-05-05 08:58:49.34369+08
48	In	2016-05-05 09:11:05.54188+08	2016-05-05 09:11:05.54188+08
60	In	2016-05-05 09:27:07.065648+08	2016-05-05 09:27:07.065648+08
48	Out	2016-05-05 10:12:14.698402+08	2016-05-05 10:12:14.698402+08
28	In	2016-05-05 10:14:41.670069+08	2016-05-05 10:14:41.670069+08
47	In	2016-05-05 11:28:43.191044+08	2016-05-05 11:28:43.191044+08
27	In	2016-05-05 11:42:34.152593+08	2016-05-05 11:42:34.152593+08
11	In	2016-05-05 12:05:20.835636+08	2016-05-05 12:05:20.835636+08
13	In	2016-05-05 12:39:50.098708+08	2016-05-05 12:39:50.098708+08
57	In	2016-05-05 12:49:52.353169+08	2016-05-05 12:49:52.353169+08
12	Out	2016-05-05 14:00:32.244624+08	2016-05-05 14:00:32.244624+08
45	Out	2016-05-05 14:18:21.516941+08	2016-05-05 14:18:21.516941+08
17	Out	2016-05-05 15:39:57.646953+08	2016-05-05 15:39:57.646953+08
23	Out	2016-05-05 17:00:49.044002+08	2016-05-05 17:00:49.044002+08
27	Out	2016-05-05 17:02:56.447965+08	2016-05-05 17:02:56.447965+08
41	Out	2016-05-05 17:03:43.862916+08	2016-05-05 17:03:43.862916+08
30	Out	2016-05-05 17:04:20.969837+08	2016-05-05 17:04:20.969837+08
61	Out	2016-05-05 17:07:21.003015+08	2016-05-05 17:07:21.003015+08
53	Out	2016-05-05 17:45:15.525421+08	2016-05-05 17:45:15.525421+08
62	Out	2016-05-05 18:02:55.088335+08	2016-05-05 18:02:55.088335+08
60	Out	2016-05-05 18:03:11.832825+08	2016-05-05 18:03:11.832825+08
31	Out	2016-05-05 18:14:20.525027+08	2016-05-05 18:14:20.525027+08
29	Out	2016-05-05 18:14:37.156756+08	2016-05-05 18:14:37.156756+08
56	Out	2016-05-05 18:15:02.022841+08	2016-05-05 18:15:02.022841+08
47	Out	2016-05-05 18:16:55.870582+08	2016-05-05 18:16:55.870582+08
11	Out	2016-05-05 18:29:19.677581+08	2016-05-05 18:29:19.677581+08
59	Out	2016-05-05 18:35:14.00864+08	2016-05-05 18:35:14.00864+08
57	Out	2016-05-05 18:37:12.472393+08	2016-05-05 18:37:12.472393+08
28	Out	2016-05-05 18:55:21.826093+08	2016-05-05 18:55:21.826093+08
13	Out	2016-05-05 19:06:49.94981+08	2016-05-05 19:06:49.94981+08
61	In	2016-05-06 07:46:24.150421+08	2016-05-06 07:46:24.150421+08
11	In	2016-05-06 07:47:52.625378+08	2016-05-06 07:47:52.625378+08
23	In	2016-05-06 07:48:31.104313+08	2016-05-06 07:48:31.104313+08
30	In	2016-05-06 07:51:46.792374+08	2016-05-06 07:51:46.792374+08
53	In	2016-05-06 07:54:37.058673+08	2016-05-06 07:54:37.058673+08
41	In	2016-05-06 07:54:51.845996+08	2016-05-06 07:54:51.845996+08
58	In	2016-05-06 07:56:58.624281+08	2016-05-06 07:56:58.624281+08
55	In	2016-05-06 07:57:00.526432+08	2016-05-06 07:57:00.526432+08
54	In	2016-05-06 07:58:58.993286+08	2016-05-06 07:58:58.993286+08
51	In	2016-05-06 08:03:48.226558+08	2016-05-06 08:03:48.226558+08
59	In	2016-05-06 08:11:33.615569+08	2016-05-06 08:11:33.615569+08
12	In	2016-05-06 08:15:40.501339+08	2016-05-06 08:15:40.501339+08
45	In	2016-05-06 08:32:06.478134+08	2016-05-06 08:32:06.478134+08
31	In	2016-05-06 08:53:15.022191+08	2016-05-06 08:53:15.022191+08
17	In	2016-05-06 09:27:46.859045+08	2016-05-06 09:27:46.859045+08
60	In	2016-05-06 10:12:34.99929+08	2016-05-06 10:12:34.99929+08
28	In	2016-05-06 10:15:53.386434+08	2016-05-06 10:15:53.386434+08
47	In	2016-05-06 10:30:01.730784+08	2016-05-06 10:30:01.730784+08
57	In	2016-05-06 11:15:35.342912+08	2016-05-06 11:15:35.342912+08
27	In	2016-05-06 13:02:56.376356+08	2016-05-06 13:02:56.376356+08
45	Out	2016-05-06 14:03:10.861344+08	2016-05-06 14:03:10.861344+08
12	Out	2016-05-06 14:16:38.291593+08	2016-05-06 14:16:38.291593+08
11	Out	2016-05-06 14:46:10.954646+08	2016-05-06 14:46:10.954646+08
17	Out	2016-05-06 16:30:24.264675+08	2016-05-06 16:30:24.264675+08
57	Out	2016-05-06 16:54:05.606254+08	2016-05-06 16:54:05.606254+08
53	Out	2016-05-06 17:00:35.963343+08	2016-05-06 17:00:35.963343+08
28	Out	2016-05-06 17:01:52.687046+08	2016-05-06 17:01:52.687046+08
61	Out	2016-05-06 17:02:21.246918+08	2016-05-06 17:02:21.246918+08
41	Out	2016-05-06 17:02:48.511746+08	2016-05-06 17:02:48.511746+08
30	Out	2016-05-06 17:06:37.430764+08	2016-05-06 17:06:37.430764+08
47	Out	2016-05-06 17:34:10.122713+08	2016-05-06 17:34:10.122713+08
23	Out	2016-05-06 17:48:55.213752+08	2016-05-06 17:48:55.213752+08
27	Out	2016-05-06 18:00:13.326738+08	2016-05-06 18:00:13.326738+08
51	Out	2016-05-06 18:04:22.303706+08	2016-05-06 18:04:22.303706+08
31	Out	2016-05-06 18:04:33.734716+08	2016-05-06 18:04:33.734716+08
60	Out	2016-05-06 18:04:59.29493+08	2016-05-06 18:04:59.29493+08
55	Out	2016-05-06 18:09:14.867539+08	2016-05-06 18:09:14.867539+08
59	Out	2016-05-06 18:22:46.316495+08	2016-05-06 18:22:46.316495+08
58	Out	2016-05-06 18:23:23.562763+08	2016-05-06 18:23:23.562763+08
54	Out	2016-05-06 18:32:54.770646+08	2016-05-06 18:32:54.770646+08
28	In	2016-05-10 07:47:42.035116+08	2016-05-10 07:47:42.035116+08
23	In	2016-05-10 07:48:06.705034+08	2016-05-10 07:48:06.705034+08
12	In	2016-05-10 07:48:25.598881+08	2016-05-10 07:48:25.598881+08
51	In	2016-05-10 07:48:36.968376+08	2016-05-10 07:48:36.968376+08
41	In	2016-05-10 07:49:02.174707+08	2016-05-10 07:49:02.174707+08
58	In	2016-05-10 07:51:24.620465+08	2016-05-10 07:51:24.620465+08
59	In	2016-05-10 07:51:47.729258+08	2016-05-10 07:51:47.729258+08
30	In	2016-05-10 07:57:28.754284+08	2016-05-10 07:57:28.754284+08
53	In	2016-05-10 08:00:28.368304+08	2016-05-10 08:00:28.368304+08
13	In	2016-05-10 08:15:57.743575+08	2016-05-10 08:15:57.743575+08
31	In	2016-05-10 08:36:07.900635+08	2016-05-10 08:36:07.900635+08
57	In	2016-05-10 08:37:23.724065+08	2016-05-10 08:37:23.724065+08
54	In	2016-05-10 08:45:30.750544+08	2016-05-10 08:45:30.750544+08
27	In	2016-05-10 09:28:12.971837+08	2016-05-10 09:28:12.971837+08
47	In	2016-05-10 09:32:11.437985+08	2016-05-10 09:32:11.437985+08
29	In	2016-05-10 09:44:09.693723+08	2016-05-10 09:44:09.693723+08
60	In	2016-05-10 11:42:56.480996+08	2016-05-10 11:42:56.480996+08
11	In	2016-05-10 13:04:54.591461+08	2016-05-10 13:04:54.591461+08
12	Out	2016-05-10 14:02:53.627802+08	2016-05-10 14:02:53.627802+08
13	Out	2016-05-10 14:04:07.873934+08	2016-05-10 14:04:07.873934+08
27	Out	2016-05-10 15:02:25.492911+08	2016-05-10 15:02:25.492911+08
47	Out	2016-05-10 16:46:41.680567+08	2016-05-10 16:46:41.680567+08
58	Out	2016-05-10 17:00:23.191955+08	2016-05-10 17:00:23.191955+08
59	Out	2016-05-10 17:00:55.692354+08	2016-05-10 17:00:55.692354+08
17	Out	2016-05-10 17:25:10.386786+08	2016-05-10 17:25:10.386786+08
28	Out	2016-05-10 17:45:40.622515+08	2016-05-10 17:45:40.622515+08
51	Out	2016-05-10 17:58:58.802327+08	2016-05-10 17:58:58.802327+08
60	Out	2016-05-10 18:00:08.37036+08	2016-05-10 18:00:08.37036+08
23	Out	2016-05-10 18:04:10.012921+08	2016-05-10 18:04:10.012921+08
41	Out	2016-05-10 18:10:51.897885+08	2016-05-10 18:10:51.897885+08
30	Out	2016-05-10 18:11:48.188945+08	2016-05-10 18:11:48.188945+08
53	Out	2016-05-10 18:13:36.328758+08	2016-05-10 18:13:36.328758+08
31	Out	2016-05-10 18:13:56.586165+08	2016-05-10 18:13:56.586165+08
54	Out	2016-05-10 19:02:42.5994+08	2016-05-10 19:02:42.5994+08
29	Out	2016-05-10 19:06:17.794482+08	2016-05-10 19:06:17.794482+08
55	Out	2016-05-10 19:06:37.461095+08	2016-05-10 19:06:37.461095+08
11	Out	2016-05-10 19:09:33.201604+08	2016-05-10 19:09:33.201604+08
41	In	2016-05-11 07:46:45.25782+08	2016-05-11 07:46:45.25782+08
28	In	2016-05-11 07:48:17.292183+08	2016-05-11 07:48:17.292183+08
23	In	2016-05-11 07:48:39.08507+08	2016-05-11 07:48:39.08507+08
61	In	2016-05-11 07:50:08.478605+08	2016-05-11 07:50:08.478605+08
12	In	2016-05-11 07:50:26.131738+08	2016-05-11 07:50:26.131738+08
53	In	2016-05-11 07:52:25.849625+08	2016-05-11 07:52:25.849625+08
51	In	2016-05-11 08:04:59.276202+08	2016-05-11 08:04:59.276202+08
30	In	2016-05-11 08:07:44.22475+08	2016-05-11 08:07:44.22475+08
58	In	2016-05-11 08:18:07.225194+08	2016-05-11 08:18:07.225194+08
57	Out	2016-05-11 08:18:45.55203+08	2016-05-11 08:18:45.55203+08
55	In	2016-05-11 08:22:22.5485+08	2016-05-11 08:22:22.5485+08
56	In	2016-05-11 08:24:33.575575+08	2016-05-11 08:24:33.575575+08
59	In	2016-05-11 08:36:18.784094+08	2016-05-11 08:36:18.784094+08
13	In	2016-05-11 08:39:04.699308+08	2016-05-11 08:39:04.699308+08
62	In	2016-05-11 08:40:59.332369+08	2016-05-11 08:40:59.332369+08
54	In	2016-05-11 08:46:10.556454+08	2016-05-11 08:46:10.556454+08
29	In	2016-05-11 09:09:08.221977+08	2016-05-11 09:09:08.221977+08
31	In	2016-05-11 09:49:38.224313+08	2016-05-11 09:49:38.224313+08
17	In	2016-05-11 10:02:43.075259+08	2016-05-11 10:02:43.075259+08
60	In	2016-05-11 10:29:18.439816+08	2016-05-11 10:29:18.439816+08
11	In	2016-05-11 12:15:29.180251+08	2016-05-11 12:15:29.180251+08
27	In	2016-05-11 12:43:20.883335+08	2016-05-11 12:43:20.883335+08
47	In	2016-05-11 12:52:46.286844+08	2016-05-11 12:52:46.286844+08
13	Out	2016-05-11 14:01:23.229111+08	2016-05-11 14:01:23.229111+08
12	Out	2016-05-11 14:14:28.580449+08	2016-05-11 14:14:28.580449+08
53	Out	2016-05-11 17:12:59.19189+08	2016-05-11 17:12:59.19189+08
41	Out	2016-05-11 17:12:59.274069+08	2016-05-11 17:12:59.274069+08
61	Out	2016-05-11 17:13:58.871615+08	2016-05-11 17:13:58.871615+08
17	Out	2016-05-11 17:20:09.14814+08	2016-05-11 17:20:09.14814+08
23	Out	2016-05-11 17:20:16.657671+08	2016-05-11 17:20:16.657671+08
47	Out	2016-05-11 17:33:58.509543+08	2016-05-11 17:33:58.509543+08
28	Out	2016-05-11 17:37:08.802876+08	2016-05-11 17:37:08.802876+08
51	Out	2016-05-11 17:51:44.478599+08	2016-05-11 17:51:44.478599+08
60	Out	2016-05-11 17:56:49.404806+08	2016-05-11 17:56:49.404806+08
27	Out	2016-05-11 18:01:35.470511+08	2016-05-11 18:01:35.470511+08
62	Out	2016-05-11 18:01:40.455691+08	2016-05-11 18:01:40.455691+08
30	Out	2016-05-11 18:01:56.139429+08	2016-05-11 18:01:56.139429+08
56	Out	2016-05-11 18:04:17.310359+08	2016-05-11 18:04:17.310359+08
31	Out	2016-05-11 19:04:39.26504+08	2016-05-11 19:04:39.26504+08
29	Out	2016-05-11 19:04:50.467133+08	2016-05-11 19:04:50.467133+08
11	Out	2016-05-11 19:04:53.46405+08	2016-05-11 19:04:53.46405+08
59	Out	2016-05-11 19:04:53.492564+08	2016-05-11 19:04:53.492564+08
58	Out	2016-05-11 19:05:42.173552+08	2016-05-11 19:05:42.173552+08
55	Out	2016-05-11 19:07:22.772968+08	2016-05-11 19:07:22.772968+08
54	Out	2016-05-11 19:13:26.917274+08	2016-05-11 19:13:26.917274+08
23	In	2016-05-12 07:44:05.771274+08	2016-05-12 07:44:05.771274+08
62	In	2016-05-12 07:45:04.204272+08	2016-05-12 07:45:04.204272+08
30	In	2016-05-12 07:55:08.769272+08	2016-05-12 07:55:08.769272+08
41	In	2016-05-12 07:56:40.741382+08	2016-05-12 07:56:40.741382+08
55	In	2016-05-12 07:58:27.128925+08	2016-05-12 07:58:27.128925+08
58	In	2016-05-12 07:58:51.872075+08	2016-05-12 07:58:51.872075+08
59	In	2016-05-12 07:59:09.314153+08	2016-05-12 07:59:09.314153+08
51	In	2016-05-12 08:10:10.322846+08	2016-05-12 08:10:10.322846+08
56	In	2016-05-12 08:14:16.882949+08	2016-05-12 08:14:16.882949+08
29	In	2016-05-12 08:23:42.708255+08	2016-05-12 08:23:42.708255+08
17	In	2016-05-12 08:24:52.515304+08	2016-05-12 08:24:52.515304+08
61	In	2016-05-12 08:29:32.841993+08	2016-05-12 08:29:32.841993+08
11	In	2016-05-12 08:44:47.993376+08	2016-05-12 08:44:47.993376+08
53	In	2016-05-12 08:56:16.794499+08	2016-05-12 08:56:16.794499+08
12	In	2016-05-12 08:58:41.719808+08	2016-05-12 08:58:41.719808+08
54	In	2016-05-12 08:59:48.534549+08	2016-05-12 08:59:48.534549+08
28	In	2016-05-12 09:08:48.255286+08	2016-05-12 09:08:48.255286+08
27	In	2016-05-12 09:29:50.709671+08	2016-05-12 09:29:50.709671+08
60	In	2016-05-12 10:51:48.351953+08	2016-05-12 10:51:48.351953+08
13	In	2016-05-12 12:36:13.117463+08	2016-05-12 12:36:13.117463+08
47	In	2016-05-12 12:38:54.305399+08	2016-05-12 12:38:54.305399+08
29	Out	2016-05-12 13:14:28.155123+08	2016-05-12 13:14:28.155123+08
27	Out	2016-05-12 14:00:36.90422+08	2016-05-12 14:00:36.90422+08
17	Out	2016-05-12 14:05:47.492022+08	2016-05-12 14:05:47.492022+08
12	Out	2016-05-12 14:07:18.720376+08	2016-05-12 14:07:18.720376+08
11	Out	2016-05-12 15:09:56.306409+08	2016-05-12 15:09:56.306409+08
30	Out	2016-05-12 17:04:57.984406+08	2016-05-12 17:04:57.984406+08
41	Out	2016-05-12 17:05:34.775017+08	2016-05-12 17:05:34.775017+08
51	Out	2016-05-12 17:55:42.376567+08	2016-05-12 17:55:42.376567+08
23	Out	2016-05-12 17:59:15.26074+08	2016-05-12 17:59:15.26074+08
62	Out	2016-05-12 18:00:10.114668+08	2016-05-12 18:00:10.114668+08
61	Out	2016-05-12 18:00:31.106157+08	2016-05-12 18:00:31.106157+08
60	Out	2016-05-12 18:02:49.07151+08	2016-05-12 18:02:49.07151+08
28	Out	2016-05-12 18:10:10.044767+08	2016-05-12 18:10:10.044767+08
47	Out	2016-05-12 18:10:34.173475+08	2016-05-12 18:10:34.173475+08
53	Out	2016-05-12 18:12:07.56368+08	2016-05-12 18:12:07.56368+08
56	Out	2016-05-12 18:14:29.051152+08	2016-05-12 18:14:29.051152+08
13	Out	2016-05-12 18:34:40.780036+08	2016-05-12 18:34:40.780036+08
59	Out	2016-05-12 18:37:57.327864+08	2016-05-12 18:37:57.327864+08
55	Out	2016-05-12 19:04:06.772244+08	2016-05-12 19:04:06.772244+08
58	Out	2016-05-12 19:18:41.091309+08	2016-05-12 19:18:41.091309+08
54	Out	2016-05-12 19:35:35.132653+08	2016-05-12 19:35:35.132653+08
23	In	2016-05-13 07:52:16.02102+08	2016-05-13 07:52:16.02102+08
61	In	2016-05-13 07:53:17.56896+08	2016-05-13 07:53:17.56896+08
58	In	2016-05-13 07:57:53.085573+08	2016-05-13 07:57:53.085573+08
54	In	2016-05-13 08:00:56.991369+08	2016-05-13 08:00:56.991369+08
51	In	2016-05-13 08:13:30.995764+08	2016-05-13 08:13:30.995764+08
13	In	2016-05-13 08:25:06.153873+08	2016-05-13 08:25:06.153873+08
55	In	2016-05-13 08:26:20.106795+08	2016-05-13 08:26:20.106795+08
31	In	2016-05-13 08:32:24.235792+08	2016-05-13 08:32:24.235792+08
12	In	2016-05-13 08:34:05.314164+08	2016-05-13 08:34:05.314164+08
57	In	2016-05-13 09:12:46.695266+08	2016-05-13 09:12:46.695266+08
41	In	2016-05-13 09:16:22.53556+08	2016-05-13 09:16:22.53556+08
60	In	2016-05-13 09:32:02.241044+08	2016-05-13 09:32:02.241044+08
53	In	2016-05-13 09:56:39.403119+08	2016-05-13 09:56:39.403119+08
62	In	2016-05-13 09:57:24.275562+08	2016-05-13 09:57:24.275562+08
29	In	2016-05-13 09:58:18.237267+08	2016-05-13 09:58:18.237267+08
30	In	2016-05-13 09:58:27.893224+08	2016-05-13 09:58:27.893224+08
11	In	2016-05-13 10:33:32.422147+08	2016-05-13 10:33:32.422147+08
47	In	2016-05-13 10:38:59.771639+08	2016-05-13 10:38:59.771639+08
17	In	2016-05-13 11:30:40.00403+08	2016-05-13 11:30:40.00403+08
13	Out	2016-05-13 14:05:21.043697+08	2016-05-13 14:05:21.043697+08
27	In	2016-05-13 14:47:20.203197+08	2016-05-13 14:47:20.203197+08
12	Out	2016-05-13 16:15:00.598844+08	2016-05-13 16:15:00.598844+08
23	Out	2016-05-13 17:08:25.917786+08	2016-05-13 17:08:25.917786+08
61	Out	2016-05-13 17:12:09.279638+08	2016-05-13 17:12:09.279638+08
51	Out	2016-05-13 17:54:11.297508+08	2016-05-13 17:54:11.297508+08
47	Out	2016-05-13 17:58:08.121168+08	2016-05-13 17:58:08.121168+08
60	Out	2016-05-13 18:00:22.202695+08	2016-05-13 18:00:22.202695+08
17	Out	2016-05-13 18:07:40.546498+08	2016-05-13 18:07:40.546498+08
11	Out	2016-05-13 18:48:33.624938+08	2016-05-13 18:48:33.624938+08
27	Out	2016-05-13 19:00:03.311509+08	2016-05-13 19:00:03.311509+08
62	Out	2016-05-13 19:00:36.621714+08	2016-05-13 19:00:36.621714+08
30	Out	2016-05-13 19:01:07.982732+08	2016-05-13 19:01:07.982732+08
31	Out	2016-05-13 19:01:22.299615+08	2016-05-13 19:01:22.299615+08
29	Out	2016-05-13 19:02:09.28499+08	2016-05-13 19:02:09.28499+08
41	Out	2016-05-13 19:02:10.587034+08	2016-05-13 19:02:10.587034+08
53	Out	2016-05-13 19:02:41.339898+08	2016-05-13 19:02:41.339898+08
55	Out	2016-05-13 19:08:51.118272+08	2016-05-13 19:08:51.118272+08
57	Out	2016-05-13 19:19:32.945381+08	2016-05-13 19:19:32.945381+08
58	Out	2016-05-13 19:43:47.564356+08	2016-05-13 19:43:47.564356+08
54	Out	2016-05-13 19:46:21.226807+08	2016-05-13 19:46:21.226807+08
17	In	2016-05-16 07:11:02.327258+08	2016-05-16 07:11:02.327258+08
23	In	2016-05-16 07:36:54.981637+08	2016-05-16 07:36:54.981637+08
12	In	2016-05-16 07:37:16.571307+08	2016-05-16 07:37:16.571307+08
51	In	2016-05-16 08:03:02.238669+08	2016-05-16 08:03:02.238669+08
61	In	2016-05-16 08:15:58.447184+08	2016-05-16 08:15:58.447184+08
47	In	2016-05-16 08:19:38.714221+08	2016-05-16 08:19:38.714221+08
13	In	2016-05-16 08:24:03.516632+08	2016-05-16 08:24:03.516632+08
30	In	2016-05-16 08:55:54.928081+08	2016-05-16 08:55:54.928081+08
54	In	2016-05-16 08:56:31.828635+08	2016-05-16 08:56:31.828635+08
41	In	2016-05-16 08:58:22.214007+08	2016-05-16 08:58:22.214007+08
31	In	2016-05-16 09:30:17.922532+08	2016-05-16 09:30:17.922532+08
55	In	2016-05-16 09:30:45.997378+08	2016-05-16 09:30:45.997378+08
29	In	2016-05-16 09:32:34.860379+08	2016-05-16 09:32:34.860379+08
62	In	2016-05-16 09:49:53.048411+08	2016-05-16 09:49:53.048411+08
28	In	2016-05-16 09:50:17.498839+08	2016-05-16 09:50:17.498839+08
53	In	2016-05-16 09:51:17.67946+08	2016-05-16 09:51:17.67946+08
58	In	2016-05-16 09:55:11.246061+08	2016-05-16 09:55:11.246061+08
59	In	2016-05-16 09:55:17.010052+08	2016-05-16 09:55:17.010052+08
60	In	2016-05-16 10:19:01.562541+08	2016-05-16 10:19:01.562541+08
27	In	2016-05-16 11:00:20.259607+08	2016-05-16 11:00:20.259607+08
23	Out	2016-05-16 17:19:35.428555+08	2016-05-16 17:19:35.428555+08
12	Out	2016-05-16 17:37:25.369589+08	2016-05-16 17:37:25.369589+08
51	Out	2016-05-16 18:05:45.186365+08	2016-05-16 18:05:45.186365+08
41	Out	2016-05-16 18:07:55.661396+08	2016-05-16 18:07:55.661396+08
60	Out	2016-05-16 18:15:42.742653+08	2016-05-16 18:15:42.742653+08
30	Out	2016-05-16 18:41:02.4328+08	2016-05-16 18:41:02.4328+08
61	Out	2016-05-16 18:42:56.42078+08	2016-05-16 18:42:56.42078+08
27	Out	2016-05-16 18:45:22.695499+08	2016-05-16 18:45:22.695499+08
17	Out	2016-05-16 18:45:24.978982+08	2016-05-16 18:45:24.978982+08
28	Out	2016-05-16 18:46:40.412456+08	2016-05-16 18:46:40.412456+08
13	Out	2016-05-16 18:49:09.37842+08	2016-05-16 18:49:09.37842+08
62	Out	2016-05-16 19:00:11.06702+08	2016-05-16 19:00:11.06702+08
53	Out	2016-05-16 19:02:00.002609+08	2016-05-16 19:02:00.002609+08
29	Out	2016-05-16 19:03:30.606766+08	2016-05-16 19:03:30.606766+08
55	Out	2016-05-16 19:03:55.513396+08	2016-05-16 19:03:55.513396+08
31	Out	2016-05-16 19:04:23.904485+08	2016-05-16 19:04:23.904485+08
47	Out	2016-05-16 19:08:55.826892+08	2016-05-16 19:08:55.826892+08
58	Out	2016-05-16 19:16:21.979071+08	2016-05-16 19:16:21.979071+08
54	Out	2016-05-16 19:20:29.572658+08	2016-05-16 19:20:29.572658+08
59	Out	2016-05-16 19:21:18.544196+08	2016-05-16 19:21:18.544196+08
12	In	2016-05-17 07:36:21.387992+08	2016-05-17 07:36:21.387992+08
17	In	2016-05-17 07:36:32.66695+08	2016-05-17 07:36:32.66695+08
23	In	2016-05-17 07:38:45.294869+08	2016-05-17 07:38:45.294869+08
41	In	2016-05-17 07:48:34.661258+08	2016-05-17 07:48:34.661258+08
59	In	2016-05-17 07:49:50.908853+08	2016-05-17 07:49:50.908853+08
58	In	2016-05-17 07:51:40.421282+08	2016-05-17 07:51:40.421282+08
30	In	2016-05-17 07:58:50.518126+08	2016-05-17 07:58:50.518126+08
51	In	2016-05-17 08:10:02.09642+08	2016-05-17 08:10:02.09642+08
61	In	2016-05-17 08:11:00.177585+08	2016-05-17 08:11:00.177585+08
13	In	2016-05-17 08:29:18.100072+08	2016-05-17 08:29:18.100072+08
31	In	2016-05-17 08:29:25.38522+08	2016-05-17 08:29:25.38522+08
55	In	2016-05-17 08:30:19.990062+08	2016-05-17 08:30:19.990062+08
54	In	2016-05-17 08:33:12.371969+08	2016-05-17 08:33:12.371969+08
28	In	2016-05-17 08:34:52.108714+08	2016-05-17 08:34:52.108714+08
62	In	2016-05-17 08:56:34.258058+08	2016-05-17 08:56:34.258058+08
29	In	2016-05-17 09:39:19.67544+08	2016-05-17 09:39:19.67544+08
56	In	2016-05-17 10:15:51.095111+08	2016-05-17 10:15:51.095111+08
60	In	2016-05-17 10:22:50.984877+08	2016-05-17 10:22:50.984877+08
47	In	2016-05-17 13:00:28.785036+08	2016-05-17 13:00:28.785036+08
12	Out	2016-05-17 13:37:03.501491+08	2016-05-17 13:37:03.501491+08
17	Out	2016-05-17 14:30:08.887583+08	2016-05-17 14:30:08.887583+08
41	Out	2016-05-17 17:03:20.525332+08	2016-05-17 17:03:20.525332+08
30	Out	2016-05-17 17:04:54.375341+08	2016-05-17 17:04:54.375341+08
23	Out	2016-05-17 17:09:16.982519+08	2016-05-17 17:09:16.982519+08
58	Out	2016-05-17 17:47:51.300696+08	2016-05-17 17:47:51.300696+08
59	Out	2016-05-17 17:56:52.950197+08	2016-05-17 17:56:52.950197+08
60	Out	2016-05-17 18:00:44.649964+08	2016-05-17 18:00:44.649964+08
31	Out	2016-05-17 18:00:51.541874+08	2016-05-17 18:00:51.541874+08
53	Out	2016-05-17 18:01:19.411212+08	2016-05-17 18:01:19.411212+08
61	Out	2016-05-17 18:02:32.849987+08	2016-05-17 18:02:32.849987+08
51	Out	2016-05-17 18:02:34.58439+08	2016-05-17 18:02:34.58439+08
62	Out	2016-05-17 18:03:32.660091+08	2016-05-17 18:03:32.660091+08
13	Out	2016-05-17 18:06:48.110578+08	2016-05-17 18:06:48.110578+08
56	Out	2016-05-17 18:07:44.681976+08	2016-05-17 18:07:44.681976+08
28	Out	2016-05-17 18:13:42.813569+08	2016-05-17 18:13:42.813569+08
55	Out	2016-05-17 18:19:58.402907+08	2016-05-17 18:19:58.402907+08
54	Out	2016-05-17 18:35:45.449074+08	2016-05-17 18:35:45.449074+08
29	Out	2016-05-17 19:16:42.533673+08	2016-05-17 19:16:42.533673+08
30	In	2016-05-18 07:47:16.850311+08	2016-05-18 07:47:16.850311+08
28	In	2016-05-18 07:47:29.826746+08	2016-05-18 07:47:29.826746+08
23	In	2016-05-18 07:47:37.9132+08	2016-05-18 07:47:37.9132+08
61	In	2016-05-18 07:47:55.036326+08	2016-05-18 07:47:55.036326+08
12	In	2016-05-18 07:48:14.14877+08	2016-05-18 07:48:14.14877+08
41	In	2016-05-18 07:48:28.00022+08	2016-05-18 07:48:28.00022+08
53	In	2016-05-18 07:57:58.719441+08	2016-05-18 07:57:58.719441+08
13	In	2016-05-18 08:18:44.024155+08	2016-05-18 08:18:44.024155+08
54	In	2016-05-18 08:26:09.614932+08	2016-05-18 08:26:09.614932+08
55	In	2016-05-18 08:26:56.720688+08	2016-05-18 08:26:56.720688+08
57	In	2016-05-18 08:37:39.163451+08	2016-05-18 08:37:39.163451+08
31	In	2016-05-18 08:40:55.434873+08	2016-05-18 08:40:55.434873+08
59	In	2016-05-18 08:41:26.763155+08	2016-05-18 08:41:26.763155+08
56	In	2016-05-18 08:43:44.553023+08	2016-05-18 08:43:44.553023+08
58	In	2016-05-18 08:46:30.610759+08	2016-05-18 08:46:30.610759+08
62	In	2016-05-18 08:49:32.756312+08	2016-05-18 08:49:32.756312+08
17	In	2016-05-18 09:12:58.58374+08	2016-05-18 09:12:58.58374+08
29	In	2016-05-18 09:15:41.838055+08	2016-05-18 09:15:41.838055+08
60	In	2016-05-18 10:37:38.626678+08	2016-05-18 10:37:38.626678+08
27	In	2016-05-18 10:39:50.566439+08	2016-05-18 10:39:50.566439+08
47	In	2016-05-18 11:09:09.285808+08	2016-05-18 11:09:09.285808+08
12	Out	2016-05-18 14:25:07.941154+08	2016-05-18 14:25:07.941154+08
17	Out	2016-05-18 15:43:14.507785+08	2016-05-18 15:43:14.507785+08
27	Out	2016-05-18 15:51:36.00349+08	2016-05-18 15:51:36.00349+08
28	Out	2016-05-18 16:19:36.637574+08	2016-05-18 16:19:36.637574+08
41	Out	2016-05-18 17:01:38.724699+08	2016-05-18 17:01:38.724699+08
30	Out	2016-05-18 17:02:12.914222+08	2016-05-18 17:02:12.914222+08
53	Out	2016-05-18 17:02:26.786999+08	2016-05-18 17:02:26.786999+08
23	Out	2016-05-18 17:03:55.718584+08	2016-05-18 17:03:55.718584+08
61	Out	2016-05-18 17:06:25.783667+08	2016-05-18 17:06:25.783667+08
47	Out	2016-05-18 17:51:25.27429+08	2016-05-18 17:51:25.27429+08
60	Out	2016-05-18 18:01:03.237464+08	2016-05-18 18:01:03.237464+08
57	Out	2016-05-18 18:01:22.286281+08	2016-05-18 18:01:22.286281+08
62	Out	2016-05-18 18:01:43.306036+08	2016-05-18 18:01:43.306036+08
56	Out	2016-05-18 18:03:17.051345+08	2016-05-18 18:03:17.051345+08
31	Out	2016-05-18 18:07:04.152655+08	2016-05-18 18:07:04.152655+08
13	Out	2016-05-18 18:28:19.144567+08	2016-05-18 18:28:19.144567+08
59	Out	2016-05-18 18:34:32.398629+08	2016-05-18 18:34:32.398629+08
58	Out	2016-05-18 18:53:36.270249+08	2016-05-18 18:53:36.270249+08
29	Out	2016-05-18 19:01:37.39774+08	2016-05-18 19:01:37.39774+08
54	Out	2016-05-18 19:02:19.678637+08	2016-05-18 19:02:19.678637+08
55	Out	2016-05-18 19:09:56.369259+08	2016-05-18 19:09:56.369259+08
23	In	2016-05-19 07:55:54.456554+08	2016-05-19 07:55:54.456554+08
41	In	2016-05-19 07:56:06.61882+08	2016-05-19 07:56:06.61882+08
55	In	2016-05-19 07:56:55.568689+08	2016-05-19 07:56:55.568689+08
30	In	2016-05-19 07:56:58.984285+08	2016-05-19 07:56:58.984285+08
12	In	2016-05-19 07:57:26.124315+08	2016-05-19 07:57:26.124315+08
51	In	2016-05-19 07:57:27.481842+08	2016-05-19 07:57:27.481842+08
59	In	2016-05-19 08:29:44.69823+08	2016-05-19 08:29:44.69823+08
58	In	2016-05-19 08:30:00.577286+08	2016-05-19 08:30:00.577286+08
13	In	2016-05-19 08:32:22.54031+08	2016-05-19 08:32:22.54031+08
53	In	2016-05-19 08:51:45.006296+08	2016-05-19 08:51:45.006296+08
62	In	2016-05-19 08:56:27.516523+08	2016-05-19 08:56:27.516523+08
31	In	2016-05-19 08:58:52.962964+08	2016-05-19 08:58:52.962964+08
29	In	2016-05-19 09:02:34.101559+08	2016-05-19 09:02:34.101559+08
54	In	2016-05-19 09:15:30.998167+08	2016-05-19 09:15:30.998167+08
28	In	2016-05-19 09:28:21.77847+08	2016-05-19 09:28:21.77847+08
47	In	2016-05-19 09:32:27.892933+08	2016-05-19 09:32:27.892933+08
17	In	2016-05-19 10:38:31.232298+08	2016-05-19 10:38:31.232298+08
27	In	2016-05-19 11:45:45.58766+08	2016-05-19 11:45:45.58766+08
41	Out	2016-05-19 13:27:36.358494+08	2016-05-19 13:27:36.358494+08
12	Out	2016-05-19 15:11:28.922757+08	2016-05-19 15:11:28.922757+08
47	Out	2016-05-19 15:39:49.230518+08	2016-05-19 15:39:49.230518+08
62	Out	2016-05-19 16:01:48.842944+08	2016-05-19 16:01:48.842944+08
17	Out	2016-05-19 16:18:15.234831+08	2016-05-19 16:18:15.234831+08
30	Out	2016-05-19 17:02:03.178728+08	2016-05-19 17:02:03.178728+08
23	Out	2016-05-19 17:11:17.289593+08	2016-05-19 17:11:17.289593+08
51	Out	2016-05-19 17:59:04.341165+08	2016-05-19 17:59:04.341165+08
28	Out	2016-05-19 18:00:28.574579+08	2016-05-19 18:00:28.574579+08
31	Out	2016-05-19 18:01:01.886373+08	2016-05-19 18:01:01.886373+08
53	Out	2016-05-19 18:01:38.914113+08	2016-05-19 18:01:38.914113+08
55	Out	2016-05-19 18:07:44.031455+08	2016-05-19 18:07:44.031455+08
58	Out	2016-05-19 18:47:30.868924+08	2016-05-19 18:47:30.868924+08
13	Out	2016-05-19 18:47:56.386894+08	2016-05-19 18:47:56.386894+08
59	Out	2016-05-19 18:48:19.924597+08	2016-05-19 18:48:19.924597+08
29	Out	2016-05-19 19:01:26.901309+08	2016-05-19 19:01:26.901309+08
54	Out	2016-05-19 19:01:40.253137+08	2016-05-19 19:01:40.253137+08
23	In	2016-05-20 07:51:07.152778+08	2016-05-20 07:51:07.152778+08
30	In	2016-05-20 07:51:16.683606+08	2016-05-20 07:51:16.683606+08
12	In	2016-05-20 07:52:04.112987+08	2016-05-20 07:52:04.112987+08
53	In	2016-05-20 07:52:11.373572+08	2016-05-20 07:52:11.373572+08
51	In	2016-05-20 08:16:30.930024+08	2016-05-20 08:16:30.930024+08
56	In	2016-05-20 08:20:04.384532+08	2016-05-20 08:20:04.384532+08
55	In	2016-05-20 08:21:07.050349+08	2016-05-20 08:21:07.050349+08
29	In	2016-05-20 08:29:14.727724+08	2016-05-20 08:29:14.727724+08
13	In	2016-05-20 08:29:43.585499+08	2016-05-20 08:29:43.585499+08
54	In	2016-05-20 08:40:50.850008+08	2016-05-20 08:40:50.850008+08
41	In	2016-05-20 08:45:40.220112+08	2016-05-20 08:45:40.220112+08
31	In	2016-05-20 08:55:29.197524+08	2016-05-20 08:55:29.197524+08
57	In	2016-05-20 09:00:13.377066+08	2016-05-20 09:00:13.377066+08
17	In	2016-05-20 09:05:07.029267+08	2016-05-20 09:05:07.029267+08
62	In	2016-05-20 09:46:55.031432+08	2016-05-20 09:46:55.031432+08
58	In	2016-05-20 09:56:50.879027+08	2016-05-20 09:56:50.879027+08
59	In	2016-05-20 09:58:37.046925+08	2016-05-20 09:58:37.046925+08
60	In	2016-05-20 10:22:21.703988+08	2016-05-20 10:22:21.703988+08
27	Out	2016-05-20 10:44:04.19614+08	2016-05-20 10:44:04.19614+08
27	In	2016-05-20 10:44:12.29684+08	2016-05-20 10:44:12.29684+08
28	In	2016-05-20 10:56:57.190651+08	2016-05-20 10:56:57.190651+08
47	In	2016-05-20 13:30:28.429141+08	2016-05-20 13:30:28.429141+08
12	Out	2016-05-20 14:38:22.391466+08	2016-05-20 14:38:22.391466+08
27	Out	2016-05-20 16:02:47.222211+08	2016-05-20 16:02:47.222211+08
30	Out	2016-05-20 17:03:51.433737+08	2016-05-20 17:03:51.433737+08
41	Out	2016-05-20 17:05:12.055403+08	2016-05-20 17:05:12.055403+08
53	Out	2016-05-20 17:06:13.593784+08	2016-05-20 17:06:13.593784+08
17	Out	2016-05-20 17:10:42.305527+08	2016-05-20 17:10:42.305527+08
23	Out	2016-05-20 17:51:49.496933+08	2016-05-20 17:51:49.496933+08
31	Out	2016-05-20 18:00:50.030496+08	2016-05-20 18:00:50.030496+08
29	Out	2016-05-20 18:01:10.512519+08	2016-05-20 18:01:10.512519+08
56	Out	2016-05-20 18:26:29.061694+08	2016-05-20 18:26:29.061694+08
63	Out	2016-05-20 18:26:55.140303+08	2016-05-20 18:26:55.140303+08
55	Out	2016-05-20 18:27:05.204447+08	2016-05-20 18:27:05.204447+08
57	Out	2016-05-20 18:27:08.546606+08	2016-05-20 18:27:08.546606+08
28	Out	2016-05-20 18:27:44.24007+08	2016-05-20 18:27:44.24007+08
51	Out	2016-05-20 18:27:56.861276+08	2016-05-20 18:27:56.861276+08
62	Out	2016-05-20 19:01:11.353932+08	2016-05-20 19:01:11.353932+08
58	Out	2016-05-20 19:03:54.134394+08	2016-05-20 19:03:54.134394+08
59	Out	2016-05-20 19:04:33.971226+08	2016-05-20 19:04:33.971226+08
13	Out	2016-05-20 19:10:42.97396+08	2016-05-20 19:10:42.97396+08
47	Out	2016-05-20 19:16:56.409066+08	2016-05-20 19:16:56.409066+08
54	Out	2016-05-20 19:19:08.961863+08	2016-05-20 19:19:08.961863+08
23	In	2016-05-23 07:39:20.31939+08	2016-05-23 07:39:20.31939+08
17	In	2016-05-23 07:41:11.851658+08	2016-05-23 07:41:11.851658+08
53	In	2016-05-23 07:56:16.611506+08	2016-05-23 07:56:16.611506+08
51	In	2016-05-23 08:10:50.124605+08	2016-05-23 08:10:50.124605+08
28	In	2016-05-23 08:13:55.891575+08	2016-05-23 08:13:55.891575+08
30	In	2016-05-23 08:21:02.241918+08	2016-05-23 08:21:02.241918+08
55	In	2016-05-23 08:28:07.150169+08	2016-05-23 08:28:07.150169+08
13	In	2016-05-23 08:37:59.818131+08	2016-05-23 08:37:59.818131+08
31	In	2016-05-23 08:38:14.450329+08	2016-05-23 08:38:14.450329+08
58	In	2016-05-23 08:41:13.960782+08	2016-05-23 08:41:13.960782+08
59	In	2016-05-23 08:49:59.752589+08	2016-05-23 08:49:59.752589+08
47	In	2016-05-23 08:55:42.135467+08	2016-05-23 08:55:42.135467+08
70	In	2016-05-23 09:00:53.934331+08	2016-05-23 09:00:53.934331+08
12	In	2016-05-23 09:04:31.307624+08	2016-05-23 09:04:31.307624+08
29	In	2016-05-23 09:07:41.034383+08	2016-05-23 09:07:41.034383+08
62	In	2016-05-23 09:09:14.902939+08	2016-05-23 09:09:14.902939+08
63	In	2016-05-23 09:16:26.874743+08	2016-05-23 09:16:26.874743+08
54	In	2016-05-23 09:29:16.377518+08	2016-05-23 09:29:16.377518+08
56	In	2016-05-23 09:57:06.799785+08	2016-05-23 09:57:06.799785+08
27	In	2016-05-23 10:41:02.934135+08	2016-05-23 10:41:02.934135+08
12	Out	2016-05-23 15:18:02.782504+08	2016-05-23 15:18:02.782504+08
28	Out	2016-05-23 15:53:07.137358+08	2016-05-23 15:53:07.137358+08
27	Out	2016-05-23 16:00:06.02297+08	2016-05-23 16:00:06.02297+08
53	Out	2016-05-23 17:03:14.173374+08	2016-05-23 17:03:14.173374+08
23	Out	2016-05-23 17:04:26.068157+08	2016-05-23 17:04:26.068157+08
31	Out	2016-05-23 18:01:18.645315+08	2016-05-23 18:01:18.645315+08
70	Out	2016-05-23 18:01:36.061323+08	2016-05-23 18:01:36.061323+08
30	Out	2016-05-23 18:01:58.600922+08	2016-05-23 18:01:58.600922+08
51	Out	2016-05-23 18:23:34.710782+08	2016-05-23 18:23:34.710782+08
29	Out	2016-05-23 19:02:53.910918+08	2016-05-23 19:02:53.910918+08
56	Out	2016-05-23 19:03:12.970412+08	2016-05-23 19:03:12.970412+08
55	Out	2016-05-23 19:05:06.342411+08	2016-05-23 19:05:06.342411+08
62	Out	2016-05-23 19:07:18.706413+08	2016-05-23 19:07:18.706413+08
59	Out	2016-05-23 19:07:58.289124+08	2016-05-23 19:07:58.289124+08
63	Out	2016-05-23 19:09:56.841736+08	2016-05-23 19:09:56.841736+08
13	Out	2016-05-23 19:10:15.045709+08	2016-05-23 19:10:15.045709+08
58	Out	2016-05-23 19:11:07.54062+08	2016-05-23 19:11:07.54062+08
54	Out	2016-05-23 19:14:36.738866+08	2016-05-23 19:14:36.738866+08
23	In	2016-05-24 07:56:40.243051+08	2016-05-24 07:56:40.243051+08
12	In	2016-05-24 08:02:14.840924+08	2016-05-24 08:02:14.840924+08
30	In	2016-05-24 08:17:08.11079+08	2016-05-24 08:17:08.11079+08
51	In	2016-05-24 08:19:05.435148+08	2016-05-24 08:19:05.435148+08
31	In	2016-05-24 08:33:57.020782+08	2016-05-24 08:33:57.020782+08
55	In	2016-05-24 08:41:03.221549+08	2016-05-24 08:41:03.221549+08
53	In	2016-05-24 08:41:35.500557+08	2016-05-24 08:41:35.500557+08
58	In	2016-05-24 08:47:15.358643+08	2016-05-24 08:47:15.358643+08
63	In	2016-05-24 08:49:33.177394+08	2016-05-24 08:49:33.177394+08
54	In	2016-05-24 08:50:02.785744+08	2016-05-24 08:50:02.785744+08
61	In	2016-05-24 09:02:52.490801+08	2016-05-24 09:02:52.490801+08
59	In	2016-05-24 09:04:13.215215+08	2016-05-24 09:04:13.215215+08
29	In	2016-05-24 09:18:38.103947+08	2016-05-24 09:18:38.103947+08
28	In	2016-05-24 09:39:51.753566+08	2016-05-24 09:39:51.753566+08
17	In	2016-05-24 10:51:23.833695+08	2016-05-24 10:51:23.833695+08
27	In	2016-05-24 11:38:03.913532+08	2016-05-24 11:38:03.913532+08
57	In	2016-05-24 12:05:48.229011+08	2016-05-24 12:05:48.229011+08
47	In	2016-05-24 12:51:06.93941+08	2016-05-24 12:51:06.93941+08
13	In	2016-05-24 13:23:01.758865+08	2016-05-24 13:23:01.758865+08
12	Out	2016-05-24 15:11:27.165852+08	2016-05-24 15:11:27.165852+08
61	Out	2016-05-24 18:00:54.172985+08	2016-05-24 18:00:54.172985+08
63	Out	2016-05-24 18:01:21.278591+08	2016-05-24 18:01:21.278591+08
53	Out	2016-05-24 18:02:30.008955+08	2016-05-24 18:02:30.008955+08
30	Out	2016-05-24 18:02:45.314389+08	2016-05-24 18:02:45.314389+08
47	Out	2016-05-24 18:03:01.5786+08	2016-05-24 18:03:01.5786+08
51	Out	2016-05-24 18:04:30.149141+08	2016-05-24 18:04:30.149141+08
31	Out	2016-05-24 18:07:41.770801+08	2016-05-24 18:07:41.770801+08
59	Out	2016-05-24 18:24:28.654292+08	2016-05-24 18:24:28.654292+08
58	Out	2016-05-24 18:28:03.673129+08	2016-05-24 18:28:03.673129+08
23	Out	2016-05-24 18:52:54.836502+08	2016-05-24 18:52:54.836502+08
13	Out	2016-05-24 19:00:05.549756+08	2016-05-24 19:00:05.549756+08
27	Out	2016-05-24 19:00:19.486803+08	2016-05-24 19:00:19.486803+08
55	Out	2016-05-24 19:01:17.236155+08	2016-05-24 19:01:17.236155+08
29	Out	2016-05-24 19:01:32.250605+08	2016-05-24 19:01:32.250605+08
57	Out	2016-05-24 19:01:43.309077+08	2016-05-24 19:01:43.309077+08
54	Out	2016-05-24 19:09:34.112948+08	2016-05-24 19:09:34.112948+08
12	In	2016-05-24 19:32:42.740163+08	2016-05-24 19:32:42.740163+08
17	Out	2016-05-24 19:48:21.738309+08	2016-05-24 19:48:21.738309+08
28	Out	2016-05-24 20:12:28.527033+08	2016-05-24 20:12:28.527033+08
23	In	2016-05-25 07:54:19.09694+08	2016-05-25 07:54:19.09694+08
12	In	2016-05-25 07:58:48.929658+08	2016-05-25 07:58:48.929658+08
61	In	2016-05-25 08:03:17.447234+08	2016-05-25 08:03:17.447234+08
51	In	2016-05-25 08:19:09.831744+08	2016-05-25 08:19:09.831744+08
13	In	2016-05-25 08:32:00.970054+08	2016-05-25 08:32:00.970054+08
58	In	2016-05-25 08:32:13.308612+08	2016-05-25 08:32:13.308612+08
55	In	2016-05-25 08:32:17.910576+08	2016-05-25 08:32:17.910576+08
53	In	2016-05-25 08:55:47.190787+08	2016-05-25 08:55:47.190787+08
70	In	2016-05-25 08:55:59.524832+08	2016-05-25 08:55:59.524832+08
31	In	2016-05-25 08:56:00.22443+08	2016-05-25 08:56:00.22443+08
29	In	2016-05-25 09:46:10.98884+08	2016-05-25 09:46:10.98884+08
57	In	2016-05-25 09:55:01.137339+08	2016-05-25 09:55:01.137339+08
54	In	2016-05-25 09:57:31.916245+08	2016-05-25 09:57:31.916245+08
47	In	2016-05-25 10:01:31.686577+08	2016-05-25 10:01:31.686577+08
17	In	2016-05-25 10:13:52.036005+08	2016-05-25 10:13:52.036005+08
30	In	2016-05-25 10:18:17.634773+08	2016-05-25 10:18:17.634773+08
28	In	2016-05-25 10:45:00.805169+08	2016-05-25 10:45:00.805169+08
79	In	2016-05-25 11:15:46.59612+08	2016-05-25 11:15:46.59612+08
80	In	2016-05-25 11:15:50.161722+08	2016-05-25 11:15:50.161722+08
27	In	2016-05-25 12:49:36.906979+08	2016-05-25 12:49:36.906979+08
12	Out	2016-05-25 15:05:03.024726+08	2016-05-25 15:05:03.024726+08
30	Out	2016-05-25 15:12:34.545901+08	2016-05-25 15:12:34.545901+08
58	Out	2016-05-25 16:49:57.945403+08	2016-05-25 16:49:57.945403+08
23	Out	2016-05-25 17:10:32.719481+08	2016-05-25 17:10:32.719481+08
17	Out	2016-05-25 17:24:32.415444+08	2016-05-25 17:24:32.415444+08
61	Out	2016-05-25 18:00:33.487272+08	2016-05-25 18:00:33.487272+08
53	Out	2016-05-25 18:00:53.370008+08	2016-05-25 18:00:53.370008+08
70	Out	2016-05-25 18:02:05.446635+08	2016-05-25 18:02:05.446635+08
31	Out	2016-05-25 18:03:46.622938+08	2016-05-25 18:03:46.622938+08
79	Out	2016-05-25 18:04:28.938132+08	2016-05-25 18:04:28.938132+08
51	Out	2016-05-25 18:07:28.445111+08	2016-05-25 18:07:28.445111+08
51	In	2016-05-25 18:07:44.637114+08	2016-05-25 18:07:44.637114+08
27	Out	2016-05-25 18:09:26.902873+08	2016-05-25 18:09:26.902873+08
28	Out	2016-05-25 18:10:05.345894+08	2016-05-25 18:10:05.345894+08
55	Out	2016-05-25 18:11:00.048799+08	2016-05-25 18:11:00.048799+08
13	Out	2016-05-25 18:51:05.080758+08	2016-05-25 18:51:05.080758+08
78	Out	2016-05-25 19:00:52.630932+08	2016-05-25 19:00:52.630932+08
29	Out	2016-05-25 19:01:54.950466+08	2016-05-25 19:01:54.950466+08
54	Out	2016-05-25 19:05:27.397539+08	2016-05-25 19:05:27.397539+08
57	Out	2016-05-25 19:16:00.546527+08	2016-05-25 19:16:00.546527+08
23	In	2016-05-26 07:48:41.427288+08	2016-05-26 07:48:41.427288+08
12	In	2016-05-26 07:49:00.803399+08	2016-05-26 07:49:00.803399+08
53	In	2016-05-26 07:49:50.531185+08	2016-05-26 07:49:50.531185+08
61	In	2016-05-26 07:50:09.074874+08	2016-05-26 07:50:09.074874+08
51	In	2016-05-26 07:56:30.391111+08	2016-05-26 07:56:30.391111+08
62	In	2016-05-26 08:00:37.063623+08	2016-05-26 08:00:37.063623+08
55	In	2016-05-26 08:24:31.608581+08	2016-05-26 08:24:31.608581+08
58	In	2016-05-26 08:30:12.212752+08	2016-05-26 08:30:12.212752+08
59	In	2016-05-26 08:30:24.856459+08	2016-05-26 08:30:24.856459+08
54	In	2016-05-26 08:38:22.435624+08	2016-05-26 08:38:22.435624+08
13	In	2016-05-26 08:39:04.183605+08	2016-05-26 08:39:04.183605+08
31	In	2016-05-26 08:45:42.5989+08	2016-05-26 08:45:42.5989+08
70	In	2016-05-26 08:53:43.473465+08	2016-05-26 08:53:43.473465+08
29	In	2016-05-26 09:27:29.090238+08	2016-05-26 09:27:29.090238+08
47	In	2016-05-26 11:20:55.916793+08	2016-05-26 11:20:55.916793+08
17	In	2016-05-26 12:41:40.8465+08	2016-05-26 12:41:40.8465+08
27	In	2016-05-26 12:50:49.564209+08	2016-05-26 12:50:49.564209+08
28	In	2016-05-26 13:09:57.944713+08	2016-05-26 13:09:57.944713+08
13	Out	2016-05-26 14:15:34.288574+08	2016-05-26 14:15:34.288574+08
12	Out	2016-05-26 14:19:14.444792+08	2016-05-26 14:19:14.444792+08
23	Out	2016-05-26 17:02:21.865532+08	2016-05-26 17:02:21.865532+08
53	Out	2016-05-26 17:03:19.338908+08	2016-05-26 17:03:19.338908+08
61	Out	2016-05-26 17:12:12.347825+08	2016-05-26 17:12:12.347825+08
47	Out	2016-05-26 17:17:57.53784+08	2016-05-26 17:17:57.53784+08
62	Out	2016-05-26 17:18:09.397596+08	2016-05-26 17:18:09.397596+08
27	Out	2016-05-26 18:00:23.1385+08	2016-05-26 18:00:23.1385+08
70	Out	2016-05-26 18:00:35.081338+08	2016-05-26 18:00:35.081338+08
31	Out	2016-05-26 18:01:18.826629+08	2016-05-26 18:01:18.826629+08
55	Out	2016-05-26 18:04:19.235105+08	2016-05-26 18:04:19.235105+08
54	Out	2016-05-26 18:06:34.755104+08	2016-05-26 18:06:34.755104+08
51	Out	2016-05-26 18:20:17.182231+08	2016-05-26 18:20:17.182231+08
28	Out	2016-05-26 19:03:32.12337+08	2016-05-26 19:03:32.12337+08
29	Out	2016-05-26 19:14:13.671831+08	2016-05-26 19:14:13.671831+08
59	Out	2016-05-26 19:32:52.333522+08	2016-05-26 19:32:52.333522+08
17	Out	2016-05-26 19:36:40.492162+08	2016-05-26 19:36:40.492162+08
58	Out	2016-05-26 19:45:09.520242+08	2016-05-26 19:45:09.520242+08
23	In	2016-05-27 07:51:22.942697+08	2016-05-27 07:51:22.942697+08
62	In	2016-05-27 07:51:37.045165+08	2016-05-27 07:51:37.045165+08
12	In	2016-05-27 07:53:59.72151+08	2016-05-27 07:53:59.72151+08
31	In	2016-05-27 07:56:29.65553+08	2016-05-27 07:56:29.65553+08
54	In	2016-05-27 07:59:14.807456+08	2016-05-27 07:59:14.807456+08
13	In	2016-05-27 08:19:45.223029+08	2016-05-27 08:19:45.223029+08
55	In	2016-05-27 08:21:11.494398+08	2016-05-27 08:21:11.494398+08
29	In	2016-05-27 08:28:13.931524+08	2016-05-27 08:28:13.931524+08
61	In	2016-05-27 08:38:02.821142+08	2016-05-27 08:38:02.821142+08
58	In	2016-05-27 08:38:06.037649+08	2016-05-27 08:38:06.037649+08
51	In	2016-05-27 08:45:42.510147+08	2016-05-27 08:45:42.510147+08
53	In	2016-05-27 08:47:10.082417+08	2016-05-27 08:47:10.082417+08
70	In	2016-05-27 08:55:13.137127+08	2016-05-27 08:55:13.137127+08
17	In	2016-05-27 09:21:37.80616+08	2016-05-27 09:21:37.80616+08
28	In	2016-05-27 09:35:50.662881+08	2016-05-27 09:35:50.662881+08
56	In	2016-05-27 09:37:32.97598+08	2016-05-27 09:37:32.97598+08
57	In	2016-05-27 09:48:07.325824+08	2016-05-27 09:48:07.325824+08
47	In	2016-05-27 10:21:53.2749+08	2016-05-27 10:21:53.2749+08
59	In	2016-05-27 10:31:51.072518+08	2016-05-27 10:31:51.072518+08
27	In	2016-05-27 10:53:56.33191+08	2016-05-27 10:53:56.33191+08
17	Out	2016-05-27 15:01:16.50698+08	2016-05-27 15:01:16.50698+08
12	Out	2016-05-27 15:02:12.827896+08	2016-05-27 15:02:12.827896+08
47	Out	2016-05-27 15:12:30.469965+08	2016-05-27 15:12:30.469965+08
58	Out	2016-05-27 15:28:43.232891+08	2016-05-27 15:28:43.232891+08
27	Out	2016-05-27 16:01:07.468363+08	2016-05-27 16:01:07.468363+08
28	Out	2016-05-27 16:51:07.608466+08	2016-05-27 16:51:07.608466+08
62	Out	2016-05-27 17:01:24.486703+08	2016-05-27 17:01:24.486703+08
31	Out	2016-05-27 17:04:26.204592+08	2016-05-27 17:04:26.204592+08
23	Out	2016-05-27 17:11:51.258505+08	2016-05-27 17:11:51.258505+08
53	Out	2016-05-27 18:00:22.22301+08	2016-05-27 18:00:22.22301+08
61	Out	2016-05-27 18:01:47.434028+08	2016-05-27 18:01:47.434028+08
29	Out	2016-05-27 18:02:01.672471+08	2016-05-27 18:02:01.672471+08
70	Out	2016-05-27 18:02:10.052037+08	2016-05-27 18:02:10.052037+08
13	Out	2016-05-27 18:02:19.948389+08	2016-05-27 18:02:19.948389+08
57	Out	2016-05-27 18:03:30.772451+08	2016-05-27 18:03:30.772451+08
51	Out	2016-05-27 18:03:42.951204+08	2016-05-27 18:03:42.951204+08
55	Out	2016-05-27 18:10:46.837391+08	2016-05-27 18:10:46.837391+08
54	Out	2016-05-27 18:12:40.715727+08	2016-05-27 18:12:40.715727+08
56	Out	2016-05-27 19:02:28.319654+08	2016-05-27 19:02:28.319654+08
57	Out	2016-05-27 19:02:29.861288+08	2016-05-27 19:02:29.861288+08
57	Out	2016-05-27 19:03:06.00973+08	2016-05-27 19:03:06.00973+08
57	Out	2016-05-27 19:04:01.401095+08	2016-05-27 19:04:01.401095+08
57	Out	2016-05-27 19:05:28.584859+08	2016-05-27 19:05:28.584859+08
23	In	2016-05-30 07:32:50.630406+08	2016-05-30 07:32:50.630406+08
17	In	2016-05-30 07:32:54.665424+08	2016-05-30 07:32:54.665424+08
12	In	2016-05-30 07:34:21.409408+08	2016-05-30 07:34:21.409408+08
28	In	2016-05-30 07:34:52.526725+08	2016-05-30 07:34:52.526725+08
13	In	2016-05-30 07:49:37.379106+08	2016-05-30 07:49:37.379106+08
53	In	2016-05-30 08:28:31.573971+08	2016-05-30 08:28:31.573971+08
27	In	2016-05-30 08:39:22.359672+08	2016-05-30 08:39:22.359672+08
51	In	2016-05-30 08:40:36.901894+08	2016-05-30 08:40:36.901894+08
59	In	2016-05-30 08:44:32.894562+08	2016-05-30 08:44:32.894562+08
54	In	2016-05-30 08:45:09.356088+08	2016-05-30 08:45:09.356088+08
58	In	2016-05-30 08:45:34.938102+08	2016-05-30 08:45:34.938102+08
55	In	2016-05-30 08:51:27.473044+08	2016-05-30 08:51:27.473044+08
31	In	2016-05-30 08:54:01.516734+08	2016-05-30 08:54:01.516734+08
61	In	2016-05-30 09:15:58.946098+08	2016-05-30 09:15:58.946098+08
47	In	2016-05-30 09:36:34.350421+08	2016-05-30 09:36:34.350421+08
29	In	2016-05-30 09:52:32.41603+08	2016-05-30 09:52:32.41603+08
57	In	2016-05-30 10:08:24.471305+08	2016-05-30 10:08:24.471305+08
70	In	2016-05-30 13:00:01.92232+08	2016-05-30 13:00:01.92232+08
12	Out	2016-05-30 14:46:50.609062+08	2016-05-30 14:46:50.609062+08
17	Out	2016-05-30 15:06:32.158495+08	2016-05-30 15:06:32.158495+08
27	Out	2016-05-30 15:07:03.805689+08	2016-05-30 15:07:03.805689+08
47	Out	2016-05-30 16:37:07.77918+08	2016-05-30 16:37:07.77918+08
23	Out	2016-05-30 17:06:00.458298+08	2016-05-30 17:06:00.458298+08
31	Out	2016-05-30 18:00:11.355107+08	2016-05-30 18:00:11.355107+08
13	Out	2016-05-30 18:00:32.545415+08	2016-05-30 18:00:32.545415+08
70	Out	2016-05-30 18:01:12.233995+08	2016-05-30 18:01:12.233995+08
53	Out	2016-05-30 18:01:50.107187+08	2016-05-30 18:01:50.107187+08
55	Out	2016-05-30 18:02:15.317701+08	2016-05-30 18:02:15.317701+08
28	Out	2016-05-30 18:04:55.759373+08	2016-05-30 18:04:55.759373+08
51	Out	2016-05-30 18:09:59.202897+08	2016-05-30 18:09:59.202897+08
59	Out	2016-05-30 18:10:00.679112+08	2016-05-30 18:10:00.679112+08
58	Out	2016-05-30 18:12:16.449211+08	2016-05-30 18:12:16.449211+08
54	Out	2016-05-30 18:28:12.51752+08	2016-05-30 18:28:12.51752+08
61	Out	2016-05-30 19:00:36.751251+08	2016-05-30 19:00:36.751251+08
57	Out	2016-05-30 19:01:40.459512+08	2016-05-30 19:01:40.459512+08
29	Out	2016-05-30 19:05:17.711724+08	2016-05-30 19:05:17.711724+08
23	In	2016-05-31 07:48:47.651776+08	2016-05-31 07:48:47.651776+08
55	In	2016-05-31 07:49:10.977438+08	2016-05-31 07:49:10.977438+08
62	In	2016-05-31 07:50:14.704807+08	2016-05-31 07:50:14.704807+08
61	In	2016-05-31 07:54:27.845099+08	2016-05-31 07:54:27.845099+08
51	In	2016-05-31 07:54:38.525679+08	2016-05-31 07:54:38.525679+08
12	In	2016-05-31 07:55:03.195894+08	2016-05-31 07:55:03.195894+08
54	In	2016-05-31 08:23:06.935292+08	2016-05-31 08:23:06.935292+08
13	In	2016-05-31 08:32:13.206824+08	2016-05-31 08:32:13.206824+08
31	In	2016-05-31 08:40:54.655312+08	2016-05-31 08:40:54.655312+08
28	In	2016-05-31 08:44:17.662772+08	2016-05-31 08:44:17.662772+08
70	In	2016-05-31 08:52:35.011871+08	2016-05-31 08:52:35.011871+08
53	In	2016-05-31 08:56:33.986639+08	2016-05-31 08:56:33.986639+08
17	In	2016-05-31 08:56:39.559691+08	2016-05-31 08:56:39.559691+08
56	In	2016-05-31 08:59:47.138641+08	2016-05-31 08:59:47.138641+08
29	In	2016-05-31 09:32:43.23124+08	2016-05-31 09:32:43.23124+08
47	In	2016-05-31 09:46:24.381355+08	2016-05-31 09:46:24.381355+08
57	In	2016-05-31 09:55:19.04092+08	2016-05-31 09:55:19.04092+08
59	In	2016-05-31 11:01:01.090691+08	2016-05-31 11:01:01.090691+08
55	Out	2016-05-31 12:05:40.952747+08	2016-05-31 12:05:40.952747+08
27	In	2016-05-31 12:48:15.416139+08	2016-05-31 12:48:15.416139+08
13	Out	2016-05-31 14:00:17.788556+08	2016-05-31 14:00:17.788556+08
62	Out	2016-05-31 15:02:20.854233+08	2016-05-31 15:02:20.854233+08
12	Out	2016-05-31 15:12:53.520393+08	2016-05-31 15:12:53.520393+08
47	Out	2016-05-31 15:43:00.798281+08	2016-05-31 15:43:00.798281+08
61	Out	2016-05-31 17:00:25.094595+08	2016-05-31 17:00:25.094595+08
17	Out	2016-05-31 17:00:28.493053+08	2016-05-31 17:00:28.493053+08
23	Out	2016-05-31 17:05:23.548892+08	2016-05-31 17:05:23.548892+08
53	Out	2016-05-31 18:00:15.396204+08	2016-05-31 18:00:15.396204+08
27	Out	2016-05-31 18:00:18.847533+08	2016-05-31 18:00:18.847533+08
51	Out	2016-05-31 18:01:39.001685+08	2016-05-31 18:01:39.001685+08
70	Out	2016-05-31 18:02:52.609867+08	2016-05-31 18:02:52.609867+08
31	Out	2016-05-31 18:08:05.726908+08	2016-05-31 18:08:05.726908+08
28	Out	2016-05-31 18:17:25.672604+08	2016-05-31 18:17:25.672604+08
59	Out	2016-05-31 18:34:48.833429+08	2016-05-31 18:34:48.833429+08
59	Out	2016-05-31 18:34:52.465273+08	2016-05-31 18:34:52.465273+08
57	Out	2016-05-31 19:01:12.92228+08	2016-05-31 19:01:12.92228+08
29	Out	2016-05-31 19:03:34.23821+08	2016-05-31 19:03:34.23821+08
54	Out	2016-05-31 19:07:15.158489+08	2016-05-31 19:07:15.158489+08
17	In	2016-06-01 07:50:41.115791+08	2016-06-01 07:50:41.115791+08
12	In	2016-06-01 07:50:49.616407+08	2016-06-01 07:50:49.616407+08
62	In	2016-06-01 07:52:37.44522+08	2016-06-01 07:52:37.44522+08
23	In	2016-06-01 07:53:43.283389+08	2016-06-01 07:53:43.283389+08
77	In	2016-06-01 08:05:35.968403+08	2016-06-01 08:05:35.968403+08
61	In	2016-06-01 08:17:13.814689+08	2016-06-01 08:17:13.814689+08
13	In	2016-06-01 08:18:56.641176+08	2016-06-01 08:18:56.641176+08
58	In	2016-06-01 08:22:10.25149+08	2016-06-01 08:22:10.25149+08
59	In	2016-06-01 08:27:49.527003+08	2016-06-01 08:27:49.527003+08
70	In	2016-06-01 08:55:34.782531+08	2016-06-01 08:55:34.782531+08
56	Out	2016-06-01 08:58:11.180257+08	2016-06-01 08:58:11.180257+08
56	In	2016-06-01 08:58:39.079343+08	2016-06-01 08:58:39.079343+08
61	Out	2016-06-01 09:02:47.863037+08	2016-06-01 09:02:47.863037+08
54	In	2016-06-01 09:12:43.653604+08	2016-06-01 09:12:43.653604+08
29	In	2016-06-01 09:42:57.997509+08	2016-06-01 09:42:57.997509+08
31	In	2016-06-01 09:43:07.079687+08	2016-06-01 09:43:07.079687+08
47	In	2016-06-01 10:04:53.904409+08	2016-06-01 10:04:53.904409+08
27	In	2016-06-01 10:41:10.815518+08	2016-06-01 10:41:10.815518+08
28	In	2016-06-01 11:44:20.584373+08	2016-06-01 11:44:20.584373+08
47	Out	2016-06-01 13:06:25.161388+08	2016-06-01 13:06:25.161388+08
12	Out	2016-06-01 13:38:09.015733+08	2016-06-01 13:38:09.015733+08
59	Out	2016-06-01 15:56:53.296467+08	2016-06-01 15:56:53.296467+08
58	Out	2016-06-01 16:00:09.978373+08	2016-06-01 16:00:09.978373+08
17	Out	2016-06-01 17:00:31.343577+08	2016-06-01 17:00:31.343577+08
23	Out	2016-06-01 17:01:21.02159+08	2016-06-01 17:01:21.02159+08
70	Out	2016-06-01 18:01:25.167626+08	2016-06-01 18:01:25.167626+08
62	Out	2016-06-01 18:02:46.474195+08	2016-06-01 18:02:46.474195+08
13	Out	2016-06-01 18:05:16.92328+08	2016-06-01 18:05:16.92328+08
56	Out	2016-06-01 18:06:23.797204+08	2016-06-01 18:06:23.797204+08
77	Out	2016-06-01 18:15:38.024314+08	2016-06-01 18:15:38.024314+08
31	Out	2016-06-01 19:00:26.364559+08	2016-06-01 19:00:26.364559+08
27	Out	2016-06-01 19:00:59.905524+08	2016-06-01 19:00:59.905524+08
29	Out	2016-06-01 19:03:38.359004+08	2016-06-01 19:03:38.359004+08
54	Out	2016-06-01 19:03:59.406136+08	2016-06-01 19:03:59.406136+08
28	Out	2016-06-01 19:08:59.523503+08	2016-06-01 19:08:59.523503+08
77	In	2016-06-02 08:03:42.138167+08	2016-06-02 08:03:42.138167+08
61	In	2016-06-02 08:04:11.411809+08	2016-06-02 08:04:11.411809+08
17	In	2016-06-02 08:04:13.421313+08	2016-06-02 08:04:13.421313+08
23	In	2016-06-02 08:05:01.201261+08	2016-06-02 08:05:01.201261+08
12	In	2016-06-02 08:05:47.659156+08	2016-06-02 08:05:47.659156+08
62	In	2016-06-02 08:19:52.398887+08	2016-06-02 08:19:52.398887+08
13	In	2016-06-02 08:38:12.267815+08	2016-06-02 08:38:12.267815+08
58	In	2016-06-02 08:38:48.13566+08	2016-06-02 08:38:48.13566+08
55	In	2016-06-02 08:39:24.613137+08	2016-06-02 08:39:24.613137+08
31	In	2016-06-02 08:44:10.195918+08	2016-06-02 08:44:10.195918+08
47	In	2016-06-02 08:56:02.59707+08	2016-06-02 08:56:02.59707+08
29	In	2016-06-02 09:14:12.991914+08	2016-06-02 09:14:12.991914+08
57	In	2016-06-02 09:15:43.28223+08	2016-06-02 09:15:43.28223+08
56	In	2016-06-02 09:39:39.976385+08	2016-06-02 09:39:39.976385+08
54	In	2016-06-02 09:44:17.592952+08	2016-06-02 09:44:17.592952+08
28	In	2016-06-02 11:08:20.078188+08	2016-06-02 11:08:20.078188+08
84	In	2016-06-02 12:20:17.143401+08	2016-06-02 12:20:17.143401+08
\.


--
-- Data for Name: titles; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY titles (pk, title, created_by, date_created) FROM stdin;
1	Owner & Managing Director	28	2016-04-01 10:47:22.39449+08
2	Accounting Consultant	28	2016-04-01 10:47:22.39449+08
3	Accounting Supervisor	28	2016-04-01 10:47:22.39449+08
4	Assistant HR Manager	28	2016-04-01 10:47:22.39449+08
5	Assistant Recruitment & Client Specialist	28	2016-04-01 10:47:22.39449+08
6	Business Development Associate	28	2016-04-01 10:47:22.39449+08
7	Cashier/Skin Care Advisor	28	2016-04-01 10:47:22.39449+08
8	Client & Recruitment Supervisor	28	2016-04-01 10:47:22.39449+08
9	Client & Recruitment Manager	28	2016-04-01 10:47:22.39449+08
10	Clinic Consultant	28	2016-04-01 10:47:22.39449+08
11	Corporate Quality Supervisor	28	2016-04-01 10:47:22.39449+08
12	HR Associate	28	2016-04-01 10:47:22.39449+08
13	HR Associate Intern	28	2016-04-01 10:47:22.39449+08
14	IT Associate	28	2016-04-01 10:47:22.39449+08
15	IT Project Manager	28	2016-04-01 10:47:22.39449+08
16	Liaison Associate	28	2016-04-01 10:47:22.39449+08
17	Talent Acquisition Associate	28	2016-04-01 10:47:22.39449+08
18	HR & Admin Associate	28	2016-04-01 10:47:22.39449+08
19	Assistant Client & Recruitment Manager	28	2016-04-01 11:25:10.42375+08
20	Business Development Officer	28	2016-04-01 11:26:08.856986+08
21	Programmer Trainee	28	2016-04-12 16:06:27.615282+08
22	Office Support Intern	28	2016-04-25 16:39:08.265271+08
23	Business Development Trainee	28	2016-04-25 16:47:25.875086+08
24	Corporate Quality Trainee	28	2016-04-25 16:51:50.051687+08
\.


--
-- Name: titles_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('titles_pk_seq', 24, true);


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
-- Name: feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs; Tablespace: 
--

ALTER TABLE ONLY feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (pk);


--
-- Name: levels_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs; Tablespace: 
--

ALTER TABLE ONLY levels
    ADD CONSTRAINT levels_pkey PRIMARY KEY (pk);


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
-- Name: employees_levels_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT employees_levels_pk_fkey FOREIGN KEY (levels_pk) REFERENCES levels(pk);


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
    ADD CONSTRAINT employees_titles_title_pk_fkey FOREIGN KEY (titles_pk) REFERENCES titles(pk);


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

