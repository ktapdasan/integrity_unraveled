--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.4
-- Dumped by pg_dump version 9.5.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: random_string(integer); Type: FUNCTION; Schema: public; Owner: chrs
--

CREATE FUNCTION random_string(length integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
  	chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
  	result text := '';
  	i integer := 0;
begin
  	if length < 0 then
    	raise exception 'Given length cannot be less than 0';
  	end if;
  	for i in 1..length loop
    	result := result || chars[1+random()*(array_length(chars, 1)-1)];
  	end loop;
  	return result;
end;
$$;


ALTER FUNCTION public.random_string(length integer) OWNER TO chrs;

--
-- Name: update_leave_balance(integer, integer); Type: FUNCTION; Schema: public; Owner: chrs
--

CREATE FUNCTION update_leave_balance(employees_pk integer, leave_types_pk integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

DECLARE

old_value int;

begin
if employees_pk is null or leave_types_pk is null then
 	return FALSE;
end if;

select leave_balances->'1'::int from employees where pk = employees_pk into old_value;

update employees set leave_balances=jsonb_set(leave_balances, '{' + leave_types_pk + '}', '" ' + old_value++ + ' "', true) where pk = employees_pk;

return TRUE;

end;
$$;


ALTER FUNCTION public.update_leave_balance(employees_pk integer, leave_types_pk integer) OWNER TO chrs;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE accounts (
    employee_id text,
    password text DEFAULT md5('chrs123456'::text)
);


ALTER TABLE accounts OWNER TO chrs;

--
-- Name: allowances; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE allowances (
    pk integer NOT NULL,
    allowance text NOT NULL,
    archived boolean DEFAULT false
);


ALTER TABLE allowances OWNER TO chrs;

--
-- Name: allowances_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE allowances_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE allowances_pk_seq OWNER TO chrs;

--
-- Name: allowances_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE allowances_pk_seq OWNED BY allowances.pk;


--
-- Name: attritions; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE attritions (
    pk integer NOT NULL,
    employees_pk integer,
    hr_details jsonb NOT NULL,
    supervisor_details jsonb,
    created_by integer,
    date_created timestamp with time zone DEFAULT now(),
    archived boolean DEFAULT false
);


ALTER TABLE attritions OWNER TO chrs;

--
-- Name: attritions_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE attritions_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE attritions_pk_seq OWNER TO chrs;

--
-- Name: attritions_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE attritions_pk_seq OWNED BY attritions.pk;


--
-- Name: calendar; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE calendar (
    pk integer NOT NULL,
    location text NOT NULL,
    description text NOT NULL,
    time_from timestamp with time zone,
    time_to timestamp with time zone,
    color text NOT NULL,
    created_by integer,
    date_created timestamp with time zone DEFAULT now(),
    archived boolean DEFAULT false
);


ALTER TABLE calendar OWNER TO chrs;

--
-- Name: calendar_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE calendar_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE calendar_pk_seq OWNER TO chrs;

--
-- Name: calendar_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE calendar_pk_seq OWNED BY calendar.pk;


--
-- Name: civil_statuses; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE civil_statuses (
    pk integer NOT NULL,
    status text NOT NULL,
    archived boolean DEFAULT false
);


ALTER TABLE civil_statuses OWNER TO chrs;

--
-- Name: civil_statuses_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE civil_statuses_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE civil_statuses_pk_seq OWNER TO chrs;

--
-- Name: civil_statuses_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE civil_statuses_pk_seq OWNED BY civil_statuses.pk;


--
-- Name: cutoff_dates; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE cutoff_dates (
    cutoff_types_pk integer,
    dates json NOT NULL,
    archived boolean DEFAULT false
);


ALTER TABLE cutoff_dates OWNER TO chrs;

--
-- Name: cutoff_types; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE cutoff_types (
    pk integer NOT NULL,
    type text NOT NULL,
    archived boolean DEFAULT false
);


ALTER TABLE cutoff_types OWNER TO chrs;

--
-- Name: cutoff_types_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE cutoff_types_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cutoff_types_pk_seq OWNER TO chrs;

--
-- Name: cutoff_types_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE cutoff_types_pk_seq OWNED BY cutoff_types.pk;


--
-- Name: daily_pass_slip; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE daily_pass_slip (
    pk integer NOT NULL,
    type text DEFAULT 'Official'::text,
    employees_pk integer,
    time_from timestamp with time zone,
    time_to timestamp with time zone,
    date_created timestamp with time zone DEFAULT now(),
    archived boolean DEFAULT false
);


ALTER TABLE daily_pass_slip OWNER TO chrs;

--
-- Name: daily_pass_slip_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE daily_pass_slip_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE daily_pass_slip_pk_seq OWNER TO chrs;

--
-- Name: daily_pass_slip_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE daily_pass_slip_pk_seq OWNED BY daily_pass_slip.pk;


--
-- Name: daily_pass_slip_status; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE daily_pass_slip_status (
    daily_pass_slip_pk integer,
    status text DEFAULT 'Pending'::text,
    created_by integer,
    remarks text NOT NULL,
    date_created timestamp with time zone DEFAULT now()
);


ALTER TABLE daily_pass_slip_status OWNER TO chrs;

--
-- Name: default_values; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE default_values (
    pk integer NOT NULL,
    name text NOT NULL,
    details jsonb NOT NULL,
    archived boolean DEFAULT false
);


ALTER TABLE default_values OWNER TO chrs;

--
-- Name: default_values_logs; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE default_values_logs (
    default_values_pk integer,
    log text NOT NULL,
    created_by integer,
    date_created timestamp with time zone DEFAULT now()
);


ALTER TABLE default_values_logs OWNER TO chrs;

--
-- Name: default_values_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE default_values_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE default_values_pk_seq OWNER TO chrs;

--
-- Name: default_values_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE default_values_pk_seq OWNED BY default_values.pk;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE departments (
    pk integer NOT NULL,
    department text NOT NULL,
    code text NOT NULL,
    archived boolean DEFAULT false
);


ALTER TABLE departments OWNER TO chrs;

--
-- Name: departments_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE departments_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE departments_pk_seq OWNER TO chrs;

--
-- Name: departments_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE departments_pk_seq OWNED BY departments.pk;


--
-- Name: employee_types; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE employee_types (
    pk integer NOT NULL,
    type text NOT NULL,
    archived boolean DEFAULT false
);


ALTER TABLE employee_types OWNER TO chrs;

--
-- Name: employee_types_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE employee_types_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE employee_types_pk_seq OWNER TO chrs;

--
-- Name: employee_types_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE employee_types_pk_seq OWNED BY employee_types.pk;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: chrs
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
    levels_pk integer,
    details jsonb,
    leave_balances jsonb
);


ALTER TABLE employees OWNER TO chrs;

--
-- Name: employees_backup; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE employees_backup (
    pk integer NOT NULL,
    details jsonb,
    leave_balances jsonb,
    date_created timestamp with time zone DEFAULT now(),
    archived boolean DEFAULT false
);


ALTER TABLE employees_backup OWNER TO chrs;

--
-- Name: employees_backup_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE employees_backup_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE employees_backup_pk_seq OWNER TO chrs;

--
-- Name: employees_backup_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE employees_backup_pk_seq OWNED BY employees_backup.pk;


--
-- Name: employees_logs; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE employees_logs (
    employees_pk integer,
    log text NOT NULL,
    created_by integer,
    date_created timestamp with time zone DEFAULT now()
);


ALTER TABLE employees_logs OWNER TO chrs;

--
-- Name: employees_permissions; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE employees_permissions (
    employees_pk integer,
    permission json NOT NULL,
    archived boolean DEFAULT false
);


ALTER TABLE employees_permissions OWNER TO chrs;

--
-- Name: employees_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE employees_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE employees_pk_seq OWNER TO chrs;

--
-- Name: employees_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE employees_pk_seq OWNED BY employees.pk;


--
-- Name: employees_titles; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE employees_titles (
    employees_pk integer,
    titles_pk integer,
    created_by integer,
    date_created timestamp with time zone DEFAULT now()
);


ALTER TABLE employees_titles OWNER TO chrs;

--
-- Name: employment_statuses; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE employment_statuses (
    pk integer NOT NULL,
    status text NOT NULL,
    archived boolean DEFAULT false
);


ALTER TABLE employment_statuses OWNER TO chrs;

--
-- Name: employment_statuses_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE employment_statuses_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE employment_statuses_pk_seq OWNER TO chrs;

--
-- Name: employment_statuses_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE employment_statuses_pk_seq OWNED BY employment_statuses.pk;


--
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE feedbacks (
    pk integer NOT NULL,
    feedback text NOT NULL,
    tool text NOT NULL,
    date_created timestamp with time zone DEFAULT now()
);


ALTER TABLE feedbacks OWNER TO chrs;

--
-- Name: feedbacks_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE feedbacks_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE feedbacks_pk_seq OWNER TO chrs;

--
-- Name: feedbacks_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE feedbacks_pk_seq OWNED BY feedbacks.pk;


--
-- Name: gender_type; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE gender_type (
    pk integer NOT NULL,
    type text NOT NULL,
    archived boolean DEFAULT false
);


ALTER TABLE gender_type OWNER TO chrs;

--
-- Name: gender_type_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE gender_type_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gender_type_pk_seq OWNER TO chrs;

--
-- Name: gender_type_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE gender_type_pk_seq OWNED BY gender_type.pk;


--
-- Name: groupings; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE groupings (
    employees_pk integer,
    supervisor_pk integer
);


ALTER TABLE groupings OWNER TO chrs;

--
-- Name: holidays; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE holidays (
    pk integer NOT NULL,
    name text NOT NULL,
    type text DEFAULT 'Regular'::text,
    datex timestamp with time zone,
    created_by integer,
    archived boolean DEFAULT false
);


ALTER TABLE holidays OWNER TO chrs;

--
-- Name: holidays_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE holidays_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE holidays_pk_seq OWNER TO chrs;

--
-- Name: holidays_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE holidays_pk_seq OWNED BY holidays.pk;


--
-- Name: leave_filed; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE leave_filed (
    pk integer NOT NULL,
    employees_pk integer,
    leave_types_pk integer,
    date_started timestamp with time zone NOT NULL,
    date_ended timestamp with time zone NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    archived boolean DEFAULT false,
    duration text,
    category text
);


ALTER TABLE leave_filed OWNER TO chrs;

--
-- Name: leave_filed_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE leave_filed_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE leave_filed_pk_seq OWNER TO chrs;

--
-- Name: leave_filed_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE leave_filed_pk_seq OWNED BY leave_filed.pk;


--
-- Name: leave_status; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE leave_status (
    leave_filed_pk integer,
    status text DEFAULT 'Pending'::text,
    created_by integer,
    date_created timestamp with time zone DEFAULT now(),
    remarks text NOT NULL,
    archived boolean DEFAULT false
);


ALTER TABLE leave_status OWNER TO chrs;

--
-- Name: leave_types; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE leave_types (
    pk integer NOT NULL,
    name text NOT NULL,
    code text NOT NULL,
    days integer NOT NULL,
    archived boolean DEFAULT false,
    details jsonb
);


ALTER TABLE leave_types OWNER TO chrs;

--
-- Name: leave_types_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE leave_types_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE leave_types_pk_seq OWNER TO chrs;

--
-- Name: leave_types_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE leave_types_pk_seq OWNED BY leave_types.pk;


--
-- Name: levels; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE levels (
    pk integer NOT NULL,
    level_title character varying NOT NULL,
    archived boolean DEFAULT false
);


ALTER TABLE levels OWNER TO chrs;

--
-- Name: levels_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE levels_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE levels_pk_seq OWNER TO chrs;

--
-- Name: levels_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE levels_pk_seq OWNED BY levels.pk;


--
-- Name: manual_logs; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE manual_logs (
    pk integer NOT NULL,
    employees_pk integer,
    type text NOT NULL,
    time_log timestamp with time zone NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    archived boolean DEFAULT false
);


ALTER TABLE manual_logs OWNER TO chrs;

--
-- Name: manual_logs_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE manual_logs_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE manual_logs_pk_seq OWNER TO chrs;

--
-- Name: manual_logs_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE manual_logs_pk_seq OWNED BY manual_logs.pk;


--
-- Name: manual_logs_status; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE manual_logs_status (
    manual_logs_pk integer,
    status text DEFAULT 'Pending'::text,
    created_by integer,
    date_created timestamp with time zone DEFAULT now(),
    remarks text NOT NULL,
    archived boolean DEFAULT false
);


ALTER TABLE manual_logs_status OWNER TO chrs;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE notifications (
    pk integer NOT NULL,
    created_by integer,
    employees_pk integer,
    notification text NOT NULL,
    table_from text NOT NULL,
    table_from_pk integer NOT NULL,
    read boolean DEFAULT false,
    date_created timestamp with time zone DEFAULT now(),
    archived boolean DEFAULT false
);


ALTER TABLE notifications OWNER TO chrs;

--
-- Name: notifications_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE notifications_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE notifications_pk_seq OWNER TO chrs;

--
-- Name: notifications_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE notifications_pk_seq OWNED BY notifications.pk;


--
-- Name: overtime; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE overtime (
    pk integer NOT NULL,
    time_from timestamp with time zone NOT NULL,
    time_to timestamp with time zone NOT NULL,
    employees_pk integer,
    date_created timestamp with time zone DEFAULT now(),
    archived boolean DEFAULT false
);


ALTER TABLE overtime OWNER TO chrs;

--
-- Name: overtime_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE overtime_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE overtime_pk_seq OWNER TO chrs;

--
-- Name: overtime_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE overtime_pk_seq OWNED BY overtime.pk;


--
-- Name: overtime_status; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE overtime_status (
    overtime_pk integer,
    created_by integer,
    status text DEFAULT 'Pending'::text,
    date_created timestamp with time zone DEFAULT now(),
    remarks text NOT NULL
);


ALTER TABLE overtime_status OWNER TO chrs;

--
-- Name: payroll; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE payroll (
    pk integer NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    first_name text
);


ALTER TABLE payroll OWNER TO chrs;

--
-- Name: payroll_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE payroll_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE payroll_pk_seq OWNER TO chrs;

--
-- Name: payroll_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE payroll_pk_seq OWNED BY payroll.pk;


--
-- Name: salary_types; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE salary_types (
    pk integer NOT NULL,
    type text NOT NULL,
    archived boolean DEFAULT false
);


ALTER TABLE salary_types OWNER TO chrs;

--
-- Name: salary_types_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE salary_types_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE salary_types_pk_seq OWNER TO chrs;

--
-- Name: salary_types_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE salary_types_pk_seq OWNED BY salary_types.pk;


--
-- Name: suspension; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE suspension (
    pk integer NOT NULL,
    time_from timestamp with time zone,
    time_to timestamp with time zone,
    remarks text,
    created_by integer,
    archived boolean DEFAULT false
);


ALTER TABLE suspension OWNER TO chrs;

--
-- Name: suspension_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE suspension_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE suspension_pk_seq OWNER TO chrs;

--
-- Name: suspension_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE suspension_pk_seq OWNED BY suspension.pk;


--
-- Name: time_log; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE time_log (
    employees_pk integer,
    type text DEFAULT 'In'::text NOT NULL,
    date_created timestamp with time zone DEFAULT now(),
    time_log timestamp with time zone DEFAULT now(),
    random_hash text,
    pk integer NOT NULL
);


ALTER TABLE time_log OWNER TO chrs;

--
-- Name: time_log_new; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE time_log_new (
    pk integer NOT NULL,
    employees_pk integer,
    time_in time without time zone,
    time_out time without time zone,
    date_created timestamp with time zone DEFAULT now()
);


ALTER TABLE time_log_new OWNER TO chrs;

--
-- Name: time_log_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE time_log_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE time_log_pk_seq OWNER TO chrs;

--
-- Name: time_log_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE time_log_pk_seq OWNED BY time_log_new.pk;


--
-- Name: time_log_pk_seq1; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE time_log_pk_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE time_log_pk_seq1 OWNER TO chrs;

--
-- Name: time_log_pk_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE time_log_pk_seq1 OWNED BY time_log.pk;


--
-- Name: titles; Type: TABLE; Schema: public; Owner: chrs
--

CREATE TABLE titles (
    pk integer NOT NULL,
    title text NOT NULL,
    created_by integer,
    date_created timestamp with time zone DEFAULT now(),
    archived boolean DEFAULT false
);


ALTER TABLE titles OWNER TO chrs;

--
-- Name: titles_pk_seq; Type: SEQUENCE; Schema: public; Owner: chrs
--

CREATE SEQUENCE titles_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE titles_pk_seq OWNER TO chrs;

--
-- Name: titles_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrs
--

ALTER SEQUENCE titles_pk_seq OWNED BY titles.pk;


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY allowances ALTER COLUMN pk SET DEFAULT nextval('allowances_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY attritions ALTER COLUMN pk SET DEFAULT nextval('attritions_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY calendar ALTER COLUMN pk SET DEFAULT nextval('calendar_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY civil_statuses ALTER COLUMN pk SET DEFAULT nextval('civil_statuses_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY cutoff_types ALTER COLUMN pk SET DEFAULT nextval('cutoff_types_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY daily_pass_slip ALTER COLUMN pk SET DEFAULT nextval('daily_pass_slip_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY default_values ALTER COLUMN pk SET DEFAULT nextval('default_values_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY departments ALTER COLUMN pk SET DEFAULT nextval('departments_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY employee_types ALTER COLUMN pk SET DEFAULT nextval('employee_types_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY employees ALTER COLUMN pk SET DEFAULT nextval('employees_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY employees_backup ALTER COLUMN pk SET DEFAULT nextval('employees_backup_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY employment_statuses ALTER COLUMN pk SET DEFAULT nextval('employment_statuses_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY feedbacks ALTER COLUMN pk SET DEFAULT nextval('feedbacks_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY gender_type ALTER COLUMN pk SET DEFAULT nextval('gender_type_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY holidays ALTER COLUMN pk SET DEFAULT nextval('holidays_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY leave_filed ALTER COLUMN pk SET DEFAULT nextval('leave_filed_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY leave_types ALTER COLUMN pk SET DEFAULT nextval('leave_types_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY levels ALTER COLUMN pk SET DEFAULT nextval('levels_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY manual_logs ALTER COLUMN pk SET DEFAULT nextval('manual_logs_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY notifications ALTER COLUMN pk SET DEFAULT nextval('notifications_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY overtime ALTER COLUMN pk SET DEFAULT nextval('overtime_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY payroll ALTER COLUMN pk SET DEFAULT nextval('payroll_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY salary_types ALTER COLUMN pk SET DEFAULT nextval('salary_types_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY suspension ALTER COLUMN pk SET DEFAULT nextval('suspension_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY time_log ALTER COLUMN pk SET DEFAULT nextval('time_log_pk_seq1'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY time_log_new ALTER COLUMN pk SET DEFAULT nextval('time_log_pk_seq'::regclass);


--
-- Name: pk; Type: DEFAULT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY titles ALTER COLUMN pk SET DEFAULT nextval('titles_pk_seq'::regclass);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY accounts (employee_id, password) FROM stdin;
201000001	c20ad4d76fe97759aa27a0c99bff6710
201400081	c20ad4d76fe97759aa27a0c99bff6710
201400087	c20ad4d76fe97759aa27a0c99bff6710
201400084	c20ad4d76fe97759aa27a0c99bff6710
201400059	c20ad4d76fe97759aa27a0c99bff6710
201300004	c20ad4d76fe97759aa27a0c99bff6710
201400089	c20ad4d76fe97759aa27a0c99bff6710
201400097	c20ad4d76fe97759aa27a0c99bff6710
201400098	c20ad4d76fe97759aa27a0c99bff6710
201400100	c20ad4d76fe97759aa27a0c99bff6710
201400102	c20ad4d76fe97759aa27a0c99bff6710
201400103	c20ad4d76fe97759aa27a0c99bff6710
201400108	c20ad4d76fe97759aa27a0c99bff6710
201400109	c20ad4d76fe97759aa27a0c99bff6710
201400110	c20ad4d76fe97759aa27a0c99bff6710
201400111	c20ad4d76fe97759aa27a0c99bff6710
201400112	c20ad4d76fe97759aa27a0c99bff6710
201400113	c20ad4d76fe97759aa27a0c99bff6710
201400114	c20ad4d76fe97759aa27a0c99bff6710
201400115	c20ad4d76fe97759aa27a0c99bff6710
201400117	c20ad4d76fe97759aa27a0c99bff6710
201400118	c20ad4d76fe97759aa27a0c99bff6710
201400119	c20ad4d76fe97759aa27a0c99bff6710
201400120	c20ad4d76fe97759aa27a0c99bff6710
201400121	c20ad4d76fe97759aa27a0c99bff6710
201400122	c20ad4d76fe97759aa27a0c99bff6710
201400126	c20ad4d76fe97759aa27a0c99bff6710
201400128	c20ad4d76fe97759aa27a0c99bff6710
201400107	c20ad4d76fe97759aa27a0c99bff6710
201400104	c20ad4d76fe97759aa27a0c99bff6710
201400088	c20ad4d76fe97759aa27a0c99bff6710
201400124	c20ad4d76fe97759aa27a0c99bff6710
201400058	c20ad4d76fe97759aa27a0c99bff6710
201400066	c20ad4d76fe97759aa27a0c99bff6710
201400106	c20ad4d76fe97759aa27a0c99bff6710
201400134	c20ad4d76fe97759aa27a0c99bff6710
201400136	c20ad4d76fe97759aa27a0c99bff6710
201400135	c20ad4d76fe97759aa27a0c99bff6710
201400132	c20ad4d76fe97759aa27a0c99bff6710
201400138	c20ad4d76fe97759aa27a0c99bff6710
201400140	c20ad4d76fe97759aa27a0c99bff6710
201400141	c20ad4d76fe97759aa27a0c99bff6710
201400142	c20ad4d76fe97759aa27a0c99bff6710
201400143	c20ad4d76fe97759aa27a0c99bff6710
201400145	c20ad4d76fe97759aa27a0c99bff6710
201400144	c20ad4d76fe97759aa27a0c99bff6710
201400139	c20ad4d76fe97759aa27a0c99bff6710
201400137	c20ad4d76fe97759aa27a0c99bff6710
201400078	c20ad4d76fe97759aa27a0c99bff6710
201400150	c20ad4d76fe97759aa27a0c99bff6710
201400151	c20ad4d76fe97759aa27a0c99bff6710
201400154	c20ad4d76fe97759aa27a0c99bff6710
201400125	c20ad4d76fe97759aa27a0c99bff6710
201400123	c20ad4d76fe97759aa27a0c99bff6710
201400155	c20ad4d76fe97759aa27a0c99bff6710
201400156	c20ad4d76fe97759aa27a0c99bff6710
201400157	c20ad4d76fe97759aa27a0c99bff6710
201400158	c20ad4d76fe97759aa27a0c99bff6710
201400152	c20ad4d76fe97759aa27a0c99bff6710
201400159	c20ad4d76fe97759aa27a0c99bff6710
201400160	c20ad4d76fe97759aa27a0c99bff6710
201400161	c20ad4d76fe97759aa27a0c99bff6710
201400162	c20ad4d76fe97759aa27a0c99bff6710
201400105	c20ad4d76fe97759aa27a0c99bff6710
201400072	d3ce41680f4dcb1e999c01a503421a7c
\.


--
-- Data for Name: allowances; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY allowances (pk, allowance, archived) FROM stdin;
1	Transportation	f
2	Food	f
\.


--
-- Name: allowances_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('allowances_pk_seq', 2, true);


--
-- Data for Name: attritions; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY attritions (pk, employees_pk, hr_details, supervisor_details, created_by, date_created, archived) FROM stdin;
2	63	{"reason": "Wala alng", "last_day": "211-2-20", "effective_date": "111-1-12"}	{"elig": "false", "reason": "Wag na", "remark": "AWOL"}	12	2016-09-21 11:04:01.093405+08	f
1	39	{"reason": null, "last_day": null, "effective_date": null}	{"elig": "false", "reason": "Wag", "remark": "wad"}	\N	2016-08-09 18:41:04.732126+08	f
\.


--
-- Name: attritions_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('attritions_pk_seq', 2, true);


--
-- Data for Name: calendar; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY calendar (pk, location, description, time_from, time_to, color, created_by, date_created, archived) FROM stdin;
1	N/A	Bday ni Pat	2016-09-16 11:59:00+08	2016-09-16 00:00:00+08	#fcfa90	28	2016-09-15 15:16:47.324525+08	f
2	N/A	Bday ule ni Pat	2016-09-17 11:59:00+08	2016-09-17 00:00:00+08	#fcfa90	28	2016-09-15 15:18:42.109668+08	f
3	N/A	di na bday ni pat	2016-09-19 00:00:00+08	2016-09-19 11:59:00+08	#fcfa90	28	2016-09-15 15:20:53.334371+08	f
4	N/A	asdas	2016-11-23 00:00:00+08	2016-11-23 23:59:59+08	#fcfa90	28	2016-09-15 15:23:37.770689+08	f
\.


--
-- Name: calendar_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('calendar_pk_seq', 4, true);


--
-- Data for Name: civil_statuses; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY civil_statuses (pk, status, archived) FROM stdin;
1	Married	f
2	Single	f
3	Divorce	f
4	Living Common Law	f
5	Widowed	f
\.


--
-- Name: civil_statuses_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('civil_statuses_pk_seq', 5, true);


--
-- Data for Name: cutoff_dates; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY cutoff_dates (cutoff_types_pk, dates, archived) FROM stdin;
2	{"first":{"from":"1","to":"15"},"second":{"from":"16","to":"31"}}	f
\.


--
-- Data for Name: cutoff_types; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY cutoff_types (pk, type, archived) FROM stdin;
1	Monthly	f
2	Bi-Monthly	f
\.


--
-- Name: cutoff_types_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('cutoff_types_pk_seq', 2, true);


--
-- Data for Name: daily_pass_slip; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY daily_pass_slip (pk, type, employees_pk, time_from, time_to, date_created, archived) FROM stdin;
1	Official	12	2016-09-09 13:00:00+08	2016-09-09 01:00:00+08	2016-09-09 15:50:23.894298+08	f
\.


--
-- Name: daily_pass_slip_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('daily_pass_slip_pk_seq', 1, true);


--
-- Data for Name: daily_pass_slip_status; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY daily_pass_slip_status (daily_pass_slip_pk, status, created_by, remarks, date_created) FROM stdin;
1	Pending	12	aaa	2016-09-09 15:50:23.894298+08
1	Cancelled	12	aaa	2016-09-09 15:50:30.154731+08
\.


--
-- Data for Name: default_values; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY default_values (pk, name, details, archived) FROM stdin;
3	rates	{"NCR": {"Daily": {"cola": "10", "basic": "481"}, "Monthly": {"cola": "130", "basic": "10000"}}, "Provincial": {"Daily": {"cola": "13", "basic": "401"}, "Monthly": {"cola": "1500", "basic": "9000"}}, "Provincials": {"Daily": {"cola": "1300", "basic": "40100"}, "Monthly": {"cola": "15000", "basic": "900000"}}}	f
1	leave	{"staggered": "Staggered monthly", "carry_over": "5", "regularization": "113"}	f
4	work_days	{"friday": "false", "monday": "true", "sunday": "false", "tuesday": "true", "saturday": "false", "thursday": "false", "wednesday": "false"}	f
5	work_hours	{"work_hours": "123"}	f
\.


--
-- Data for Name: default_values_logs; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY default_values_logs (default_values_pk, log, created_by, date_created) FROM stdin;
1	Updated Leave default values	28	2016-08-08 16:27:39.454578+08
1	Updated Leave default values	28	2016-08-08 16:28:05.96142+08
1	Updated Leave default values	28	2016-08-08 16:28:41.572404+08
1	Updated Leave default values	28	2016-08-08 16:28:46.082872+08
1	Updated Leave default values	28	2016-08-21 16:41:52.028541+08
1	Updated Leave default values	28	2016-09-19 10:05:25.883081+08
1	Updated Leave default values	28	2016-09-19 11:24:52.693888+08
\.


--
-- Name: default_values_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('default_values_pk_seq', 5, true);


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY departments (pk, department, code, archived) FROM stdin;
21	VRT	VRT	f
22	BRT	BRT	f
23	F&A	F&A	f
24	HRPC	HRPC	f
25	CQT	CQT	f
27	TRT	TRT	f
28	NVRT	NVRT	f
29	CSRT	CSRT	f
31	Sourcing Recruitment Team	SRT	f
32	Strategic Recruitment Project Management	SRPM	f
20	Executive Commitee	EXECOM	f
30	Business Development	BD	f
26	Innovations and Information Technology	IIT	f
\.


--
-- Name: departments_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('departments_pk_seq', 32, true);


--
-- Data for Name: employee_types; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY employee_types (pk, type, archived) FROM stdin;
1	Exempt	f
2	Non-exempt	f
\.


--
-- Name: employee_types_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('employee_types_pk_seq', 2, true);


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY employees (pk, employee_id, first_name, middle_name, last_name, email_address, archived, date_created, business_email_address, titles_pk, level, department, levels_pk, details, leave_balances) FROM stdin;
43	201400121	Kathleen Kay	Macalino	Ongcal	kkongcal.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	kathleen.ongcal@chrsglobal.com	10	Associate	{29}	7	{"company": {"levels_pk": "7", "titles_pk": "10", "supervisor": "null", "employee_id": "201400121", "departments_pk": "29", "business_email_address": "kathleen.ongcal@chrsglobal.com"}, "personal": {"last_name": "Ongcal", "first_name": "Kathleen Kay", "middle_name": "Macalino", "email_address": "kkongcal.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
45	201400126	Michelle	Tan	De Guzman	mdeguzman.chrs@gmail.com	f	2016-03-04 16:14:08.15679+08	michelle.deguzman@chrsglobal.com	19	Manager	{27}	4	{"company": {"levels_pk": "4", "titles_pk": "19", "supervisor": "11", "employee_id": "201400126", "departments_pk": "27", "business_email_address": "michelle.deguzman@chrsglobal.com"}, "personal": {"last_name": "De Guzman", "first_name": "Michelle", "middle_name": "Tan", "email_address": "mdeguzman.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
53	201400136	Kazylynn	Razo	Catacutan	kcatacutan.chrs@gmail.com	f	2016-04-12 16:08:41.478974+08	kazylynn.catacutan@chrsglobal.com	18	Associate	{31}	7	{"company": {"levels_pk": "7", "titles_pk": "18", "supervisor": "10", "employee_id": "201400136", "departments_pk": "31", "business_email_address": "kazylynn.catacutan@chrsglobal.com"}, "personal": {"last_name": "Catacutan", "first_name": "Kazylynn", "middle_name": "Razo", "email_address": "kcatacutan.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
17	201400088	Arjev	Price	De Los Reyes	adlreyes.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	arjevdelosreyes@gmail.com	4	Asst Manager	{24}	6	{"company": {"levels_pk": "6", "titles_pk": "4", "supervisor": "10", "employee_id": "201400088", "departments_pk": "24", "business_email_address": "arjevdelosreyes@gmail.com"}, "personal": {"last_name": "De Los Reyes", "first_name": "Arjev", "middle_name": "Price", "email_address": "adlreyes.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
11	201400066	Judy Ann	Lantican	Reginaldo	jreginaldo.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	N/A	9	Manager	{28}	4	{"company": {"levels_pk": "4", "titles_pk": "9", "supervisor": "10", "employee_id": "201400066", "departments_pk": "28", "business_email_address": "N/A"}, "personal": {"last_name": "Reginaldo", "first_name": "Judy Ann", "middle_name": "Lantican", "email_address": "jreginaldo.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
77	201400155	Ken	Espera	Gelisanga	kgelisanga.chrs@gmail.com	f	2016-05-25 11:06:25.026458+08	ken.gelisanga@chrsglobal.com	12	Associate	{32}	7	{"company": {"levels_pk": "7", "titles_pk": "12", "supervisor": "null", "employee_id": "201400155", "departments_pk": "32", "business_email_address": "ken.gelisanga@chrsglobal.com"}, "personal": {"last_name": "Gelisanga", "first_name": "Ken", "middle_name": "Espera", "email_address": "kgelisanga.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
62	201400145	Claire Receli	Morales	Renosa	crrenosa.chrs@gmail.com	f	2016-04-25 16:56:37.76254+08	claire.renosa@chrsglobal.com	21	Associate	{26}	3	{"company": {"hours": "250", "levels_pk": "3", "titles_pk": "21", "supervisor": "28", "employee_id": "201400145", "departments_pk": "26", "business_email_address": "claire.renosa@chrsglobal.com"}, "personal": {"last_name": "Renosa", "first_name": "Claire Receli", "middle_name": "Morales", "email_address": "crrenosa.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
54	201400137	Arbie	Castillo	Honra	ahonra.chrs@gmail.com	f	2016-04-22 14:36:12.162891+08	arbie.honra@chrsglobal.com	19	Associate	{31}	7	{"company": {"levels_pk": "7", "titles_pk": "19", "supervisor": "10", "employee_id": "201400137", "departments_pk": "31", "business_email_address": "arbie.honra@chrsglobal.com"}, "personal": {"last_name": "Honra", "first_name": "Arbie", "middle_name": "Castillo", "email_address": "ahonra.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
48	201400132	Maria Eliza	Querido	De Mesa	medemesa.chrs@gmail.com	f	2016-03-07 16:21:37.202235+08	maria.demesa@chrsglobal.com	17	Associate	{22}	7	{"company": {"levels_pk": "7", "titles_pk": "17", "supervisor": "19", "employee_id": "201400132", "departments_pk": "22", "business_email_address": "maria.demesa@chrsglobal.com"}, "personal": {"last_name": "De Mesa", "first_name": "Maria Eliza", "middle_name": "Querido", "email_address": "medemesa.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
63						f	2016-05-20 11:34:40.871902+08		21	Associate	{26}	3	{"company": {"hours": "250", "levels_pk": "3", "titles_pk": "21", "supervisor": "28", "employee_id": "", "departments_pk": "26", "business_email_address": ""}, "personal": {"gender_pk": "", "last_name": "", "first_name": "", "middle_name": "", "civil_status": "", "email_address": ""}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
49	201400124	Renz	Santiago	Feliciano	rfeliciano.chrs@gmail.com	f	2016-03-08 09:05:10.063741+08	renz.feliciano@chrsglobal.com	12	Associate	{22}	7	{"company": {"levels_pk": "7", "titles_pk": "12", "supervisor": "19", "employee_id": "201400124", "departments_pk": "22", "business_email_address": "renz.feliciano@chrsglobal.com"}, "personal": {"last_name": "Feliciano", "first_name": "Renz", "middle_name": "Santiago", "email_address": "rfeliciano.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
79	201400157	Frances Therese	Yamongan	Garay	ftgaray.chrs@gmail.com	f	2016-05-25 11:08:33.958727+08	frances.garay@chrsglobal.com	23	Associate	{30}	7	{"company": {"levels_pk": "7", "titles_pk": "23", "supervisor": "47", "employee_id": "201400157", "departments_pk": "30", "business_email_address": "frances.garay@chrsglobal.com"}, "personal": {"last_name": "Garay", "first_name": "Frances Therese", "middle_name": "Yamongan", "email_address": "ftgaray.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
83	201400161	Jomarie	Dela Cruz	Baun	jbaun.chrs@gmail.com	f	2016-05-30 11:55:47.879323+08	joemarie.baun@chrsglobal.com	13	Associate	{32}	7	{"company": {"levels_pk": "7", "titles_pk": "13", "supervisor": "null", "employee_id": "201400161", "departments_pk": "32", "business_email_address": "joemarie.baun@chrsglobal.com"}, "personal": {"last_name": "Baun", "first_name": "Jomarie", "middle_name": "Dela Cruz", "email_address": "jbaun.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
27	201400104	Eliza	Alcaraz	Mandique	emandique.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	eliza.mandique@chrsglobal.com	11	Supervisor	{25}	8	{"company": {"levels_pk": "8", "titles_pk": "11", "supervisor": "10", "employee_id": "201400104", "departments_pk": "25", "business_email_address": "eliza.mandique@chrsglobal.com"}, "personal": {"last_name": "Mandique", "first_name": "Eliza", "middle_name": "Alcaraz", "email_address": "emandique.chrs@gmail.com", "contact_number": "09323232", "landline_number": "323232", "present_address": "Manila", "permanent_address": "Cavite"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
51	201400135	John Gregory	Ducay	Funtera	jgfuntera.chrs@gmail.com	f	2016-04-12 16:08:41.478974+08	john.funtera@chrsglobal.com	21	Associate	{26}	3	{"company": {"hours": "250", "levels_pk": "3", "titles_pk": "21", "supervisor": "28", "employee_id": "201400135", "departments_pk": "26", "business_email_address": "john.funtera@chrsglobal.com"}, "personal": {"last_name": "Funtera", "first_name": "John Gregory", "middle_name": "Ducay", "email_address": "jgfuntera.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "3.5", "3": 13, "4": "1", "5": "11", "7": "9"}
21	201400097	Ariel	Dela Cruz	Solis	N/A	f	2016-02-14 23:42:40.014678+08	acsolis10@yahoo.com	2	Associate	{23}	7	{"company": {"levels_pk": "7", "titles_pk": "2", "supervisor": "10", "employee_id": "201400097", "date_started": "undefined", "email_address": "N/A", "departments_pk": "23", "business_email_address": "acsolis10@yahoo.com"}, "personal": {"last_name": "Solis", "first_name": "Ariel", "middle_name": "Dela Cruz", "contact_number": "undefined", "landline_number": "undefined", "present_address": "undefined", "permanent_address": "undefined"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
29	201400106	Eralyn May	Bayot	Adino	emadino.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	jinra25@gmail.com	13	Associate	{27}	7	{"company": {"levels_pk": "7", "titles_pk": "13", "supervisor": "45", "employee_id": "201400106", "departments_pk": "27", "business_email_address": "jinra25@gmail.com"}, "personal": {"last_name": "Adino", "first_name": "Eralyn May", "middle_name": "Bayot", "email_address": "emadino.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
30	201400107	Ana Margarita	Hernandez	Galero	amgalero.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	anamgalero@gmail.com	13	Associate	{27}	7	{"company": {"levels_pk": "7", "titles_pk": "13", "supervisor": "45", "employee_id": "201400107", "departments_pk": "27", "business_email_address": "anamgalero@gmail.com"}, "personal": {"last_name": "Galero", "first_name": "Ana Margarita", "middle_name": "Hernandez", "email_address": "amgalero.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
15	201400087	Faya Lou	Mahinay	Parenas	fparenas.chrs@gmail.com	t	2016-02-14 23:42:40.014678+08	N/A	5	Specialist	{27}	2	{"company": {"salary": {"details": {"bank": "BDO", "amount": "1000000", "account_number": "100010001"}, "allowances": {"1": "100", "2": "100"}, "salary_types_pk": "1"}, "levels_pk": "4", "titles_pk": "15", "start_date": "2016-01-18", "supervisor": "10", "email_address": "rafael.pascual@chrsglobal.com", "work_schedule": {"friday": {"in": "08:00", "out": "17:00"}, "monday": {"in": "08:00", "out": "17:00"}, "sunday": null, "tuesday": {"in": "08:00", "out": "17:00"}, "saturday": null, "thursday": {"in": "08:00", "out": "17:00"}, "wednesday": {"in": "08:00", "out": "17:00"}}, "departments_pk": "26", "employee_types_pk": "1", "business_email_address": "rpascual0812@gmail.com", "employment_statuses_pk": "4"}, "personal": {}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
47	201400128	Aleine Leilanie	Braza	Oro	aloro.chrs@gmail.com	f	2016-03-07 12:16:40.262446+08	aleine.oro@chrsglobal.com	20	Officer	{30}	5	{"company": {"levels_pk": "5", "titles_pk": "20", "supervisor": "10", "employee_id": "201400128", "departments_pk": "30", "business_email_address": "aleine.oro@chrsglobal.com"}, "personal": {"last_name": "Oro", "first_name": "Aleine Leilanie", "middle_name": "Braza", "email_address": "aloro.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
78	201400156	Margaret Stefanie Arielle	Catindig	Gecana	msagecana.chrs@gmail.com	f	2016-05-25 11:07:34.704259+08	margaret.gecana@chrsglobal.com	17	Associate	{32}	7	{"company": {"levels_pk": "7", "titles_pk": "17", "supervisor": "null", "employee_id": "201400156", "departments_pk": "32", "business_email_address": "margaret.gecana@chrsglobal.com"}, "personal": {"last_name": "Gecana", "first_name": "Margaret Stefanie Arielle", "middle_name": "Catindig", "email_address": "msagecana.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
82	201400160	Jedaiah Shekinah	Rondilla	Magno	jsmagno.chrs@gmail.com	f	2016-05-30 11:54:51.956072+08	jedaiah.magno@chrsglobal.com	13	Associate	{32}	7	{"company": {"levels_pk": "7", "titles_pk": "13", "supervisor": "47", "employee_id": "201400160", "departments_pk": "32", "business_email_address": "jedaiah.magno@chrsglobal.com"}, "personal": {"last_name": "Magno", "first_name": "Jedaiah Shekinah", "middle_name": "Rondilla", "email_address": "jsmagno.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
33	201400110	Shena Mae	Jardinel	Nava	shena.nava@chrsglobal.com	f	2016-02-14 23:42:40.014678+08	shenamaenavacalma@yahoo.com	13	Associate	{21}	7	{"company": {"levels_pk": "7", "titles_pk": "13", "supervisor": "14", "employee_id": "201400110", "departments_pk": "21", "business_email_address": "shenamaenavacalma@yahoo.com"}, "personal": {"last_name": "Nava", "first_name": "Shena Mae", "middle_name": "Jardinel", "email_address": "shena.nava@chrsglobal.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
35	201400112	Alween Orange	Ceredon	Gemao	aogemao.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	orangegemao@yahoo.com	13	Associate	{21}	7	{"company": {"levels_pk": "7", "titles_pk": "13", "supervisor": "14", "employee_id": "201400112", "departments_pk": "21", "business_email_address": "orangegemao@yahoo.com"}, "personal": {"last_name": "Gemao", "first_name": "Alween Orange", "middle_name": "Ceredon", "email_address": "aogemao.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
38	201400115	Jennifer	Araneta	Balucay	jbalucay.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	jennbalucay93@gmail.com	7	Associate	{29}	7	{"company": {"levels_pk": "7", "titles_pk": "7", "supervisor": "null", "employee_id": "201400115", "departments_pk": "29", "business_email_address": "jennbalucay93@gmail.com"}, "personal": {"last_name": "Balucay", "first_name": "Jennifer", "middle_name": "Araneta", "email_address": "jbalucay.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
37	201400114	Karen	Medo	Esmeralda	kesmeraldo@gmail.com	f	2016-02-14 23:42:40.014678+08	kesmeraldo.chrs@gmail.com	7	Associate	{29}	7	{"company": {"levels_pk": "7", "titles_pk": "7", "supervisor": "null", "employee_id": "201400114", "departments_pk": "29", "business_email_address": "kesmeraldo.chrs@gmail.com"}, "personal": {"last_name": "Esmeralda", "first_name": "Karen", "middle_name": "Medo", "email_address": "kesmeraldo@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
39	201400117	Arlene	Diama	Obasa	aobasa.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	obasa_arlene@yahoo.com	7	Associate	{29}	7	{"company": {"levels_pk": "7", "titles_pk": "7", "supervisor": "28", "employee_id": "201400117", "departments_pk": "29", "business_email_address": "obasa_arlene@yahoo.com"}, "personal": {"last_name": "Obasa", "first_name": "Arlene", "middle_name": "Diama", "email_address": "aobasa.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
41	201400119	Alyssa	Iligan	Panaguiton	apanaguiton.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	panaguitonalyssaend121@gmail.com	13	Associate	{24}	7	{"company": {"levels_pk": "7", "titles_pk": "13", "supervisor": "10", "employee_id": "201400119", "departments_pk": "24", "business_email_address": "panaguitonalyssaend121@gmail.com"}, "personal": {"last_name": "Panaguiton", "first_name": "Alyssa", "middle_name": "Iligan", "email_address": "apanaguiton.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
55	201400138	Jhon Michel	Alcaide	Lalis	jmlalis.chrs@gmail.com	f	2016-04-22 14:36:12.162891+08	jhon.lalis@chrsglobal.com	17	Associate	{31}	7	{"company": {"levels_pk": "7", "titles_pk": "17", "supervisor": "10", "employee_id": "201400138", "departments_pk": "31", "business_email_address": "jhon.lalis@chrsglobal.com"}, "personal": {"last_name": "Lalis", "first_name": "Jhon Michel", "middle_name": "Alcaide", "email_address": "jmlalis.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
13	201400078	Lita	Llanera	Elejido	lelejido.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	lhitaelejido@gmail.com	17	Associate	{28}	7	{"company": {"levels_pk": "7", "titles_pk": "17", "supervisor": "11", "employee_id": "201400078", "departments_pk": "28", "business_email_address": "lhitaelejido@gmail.com"}, "personal": {"last_name": "Elejido", "first_name": "Lita", "middle_name": "Llanera", "email_address": "lelejido.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
34	201400111	Angelyn	Daguro	Cuevas	acuevas.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	angelyn.cuevas1017@gmail.com	13	Associate	{21}	7	{"company": {"levels_pk": "7", "titles_pk": "13", "supervisor": "14", "employee_id": "201400111", "departments_pk": "21", "business_email_address": "angelyn.cuevas1017@gmail.com"}, "personal": {"last_name": "Cuevas", "first_name": "Angelyn", "middle_name": "Daguro", "email_address": "acuevas.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
42	201400120	Aimee	Gaborni	Legaspi	alegaspi.chrs@gmail.com	t	2016-02-14 23:42:40.014678+08	aimeelgsp@icloud.com	13	Associate	{22,29}	7	{"company": {"salary": {"details": {"bank": "BDO", "amount": "1000000", "account_number": "100010001"}, "allowances": {"1": "100", "2": "100"}, "salary_types_pk": "1"}, "levels_pk": "4", "titles_pk": "15", "start_date": "2016-01-18", "supervisor": "10", "email_address": "rafael.pascual@chrsglobal.com", "work_schedule": {"friday": {"in": "08:00", "out": "17:00"}, "monday": {"in": "08:00", "out": "17:00"}, "sunday": null, "tuesday": {"in": "08:00", "out": "17:00"}, "saturday": null, "thursday": {"in": "08:00", "out": "17:00"}, "wednesday": {"in": "08:00", "out": "17:00"}}, "departments_pk": "26", "employee_types_pk": "1", "business_email_address": "rpascual0812@gmail.com", "employment_statuses_pk": "4"}, "personal": {}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
80	201400158	Roxanne Alyssa	Miel	Chua	rachua.chrs@gmail.com	f	2016-05-25 11:09:11.150361+08	roxanne.chua@chrsglobal.com	23	Associate	{30}	7	{"company": {"levels_pk": "7", "titles_pk": "23", "supervisor": "null", "employee_id": "201400158", "departments_pk": "30", "business_email_address": "roxanne.chua@chrsglobal.com"}, "personal": {"last_name": "Chua", "first_name": "Roxanne Alyssa", "middle_name": "Miel", "email_address": "rachua.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
70	201400152	Grace Lene	Dela Cruz	Bigay	glbigay.chrs@gmail.com	f	2016-05-20 11:53:34.089181+08	grace.bigay@chrsglobal.com	13	Associate	{31}	3	{"company": {"hours": "250", "levels_pk": "3", "titles_pk": "13", "supervisor": "10", "employee_id": "201400152", "departments_pk": "31", "business_email_address": "grace.bigay@chrsglobal.com"}, "personal": {"last_name": "Bigay", "first_name": "Grace Lene", "middle_name": "Dela Cruz", "email_address": "glbigay.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
44	201400122	Marry Jeane	Genteroy	Sadsad	mjsadsad.chrs@gmail.com	t	2016-02-14 23:42:40.014678+08	marry.sadsad@chrsglobal.com	10	Associate	{29}	7	{"company": {"salary": {"details": {"bank": "BDO", "amount": "1000000", "account_number": "100010001"}, "allowances": {"1": "100", "2": "100"}, "salary_types_pk": "1"}, "levels_pk": "4", "titles_pk": "15", "start_date": "2016-01-18", "supervisor": "10", "email_address": "rafael.pascual@chrsglobal.com", "work_schedule": {"friday": {"in": "08:00", "out": "17:00"}, "monday": {"in": "08:00", "out": "17:00"}, "sunday": null, "tuesday": {"in": "08:00", "out": "17:00"}, "saturday": null, "thursday": {"in": "08:00", "out": "17:00"}, "wednesday": {"in": "08:00", "out": "17:00"}}, "departments_pk": "26", "employee_types_pk": "1", "business_email_address": "rpascual0812@gmail.com", "employment_statuses_pk": "4"}, "personal": {}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
76	201400123	Kristia Marie		Velasco	kmvelasco.chrs@gmail.com	f	2016-05-23 12:58:46.584679+08	kristia.velasco@chrsglobal.com	17	Associate	{32}	7	{"company": {"levels_pk": "7", "titles_pk": "17", "supervisor": "null", "employee_id": "201400123", "departments_pk": "32", "business_email_address": "kristia.velasco@chrsglobal.com"}, "personal": {"last_name": "Velasco", "first_name": "Kristia Marie", "middle_name": "", "email_address": "kmvelasco.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
59	201400142	Mariam Hazel	Sango	Pugoy	mhpugoy.chrs@gmail.com	f	2016-04-25 16:56:37.76254+08	mariam.pugoy@chrsglobal.com	\N	Associate	{32}	7	{"company": {"salary": {"amount": "12000", "salary_type": "cash"}, "levels_pk": "8", "titles_pk": "8", "supervisor": "10", "employee_id": "201400118", "date_started": "03/01/2016", "departments_pk": "22", "employee_status_pk": "3", "employment_type_pk": "1", "company_work_schedule": {"friday": {"ins": "09:00", "out": "18:00"}, "monday": {"ins": "09:00", "out": "18:00"}, "sunday": null, "tuesday": {"ins": "09:00", "out": "18:00"}, "saturday": null, "thursday": {"ins": "09:00", "out": "18:00"}, "wednesday": {"ins": "09:00", "out": "18:00"}}, "business_email_address": "chrs@chrsglobal.com"}, "personal": {"last_name": "Pugoy", "first_name": "Mariam Hazel", "middle_name": "Sango", "email_address": "mhpugoy.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
60	201400143	John Patrick	Escosio	Purugganan	jppurugganan.chrs@gmail.com	f	2016-04-25 16:56:37.76254+08	john.purugganan@chrsglobal.com	\N	Associate	{30}	7	{"company": {"salary": {"amount": "12000", "salary_type": "cash"}, "levels_pk": "8", "titles_pk": "8", "supervisor": "10", "employee_id": "201400118", "date_started": "03/01/2016", "departments_pk": "22", "employee_status_pk": "3", "employment_type_pk": "1", "company_work_schedule": {"friday": {"ins": "09:00", "out": "18:00"}, "monday": {"ins": "09:00", "out": "18:00"}, "sunday": null, "tuesday": {"ins": "09:00", "out": "18:00"}, "saturday": null, "thursday": {"ins": "09:00", "out": "18:00"}, "wednesday": {"ins": "09:00", "out": "18:00"}}, "business_email_address": "chrs@chrsglobal.com"}, "personal": {"last_name": "Purugganan", "first_name": "John Patrick", "middle_name": "Escosio", "email_address": "jppurugganan.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
74	201400125	Raquel	Villocino	Trasmonte	rtrasmonte.chrs@gmail.com	f	2016-05-23 12:50:58.383123+08	raquel.trasmonte@chrsglobal.com	17	Associate	{32}	7	{"company": {"levels_pk": "7", "titles_pk": "17", "supervisor": "null", "employee_id": "201400125", "departments_pk": "32", "business_email_address": "raquel.trasmonte@chrsglobal.com"}, "personal": {"last_name": "Trasmonte", "first_name": "Raquel", "middle_name": "Villocino", "email_address": "rtrasmonte.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
18	201400059	Marilyn May	Villano	Bolocon	mbolocon.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	bolocon.marilynmay@yahoo.com	17	Associate	{21}	7	{"company": {"levels_pk": "7", "titles_pk": "17", "supervisor": "14", "employee_id": "201400059", "departments_pk": "21", "business_email_address": "bolocon.marilynmay@yahoo.com"}, "personal": {"last_name": "Bolocon", "first_name": "Marilyn May", "middle_name": "Villano", "email_address": "mbolocon.chrs@gmail.com", "contact_number": "undefined", "landline_number": "undefined", "present_address": "undefined", "permanent_address": "undefined"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
31	201400108	Irone John	Mendoza	Amor	ijamor.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	ironejohn@gmail.com	13	Associate	{27}	7	{"company": {"levels_pk": "7", "titles_pk": "13", "supervisor": "45", "employee_id": "201400108", "departments_pk": "27", "business_email_address": "ironejohn@gmail.com"}, "personal": {"last_name": "Amor", "first_name": "Irone John", "middle_name": "Mendoza", "email_address": "ijamor.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
22	201400098	Rolando	Garfin	Lipardo	N/A	f	2016-02-14 23:42:40.014678+08	N/A	16	Associate	{23}	7	{"company": {"levels_pk": "7", "titles_pk": "16", "supervisor": "10", "employee_id": "201400098", "departments_pk": "23", "business_email_address": "N/A"}, "personal": {"last_name": "Lipardo", "first_name": "Rolando", "middle_name": "Garfin", "email_address": "N/A"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
84	201400162	Girome	Roque	Fernandez	gfernandez.chrs@gmail.com	f	2016-06-02 10:44:04.950151+08	girome.fernandez@chrsglobal.com	13	Associate	{32}	7	{"company": {"levels_pk": "7", "titles_pk": "13", "supervisor": "null", "employee_id": "201400162", "departments_pk": "32", "business_email_address": "girome.fernandez@chrsglobal.com"}, "personal": {"last_name": "Fernandez", "first_name": "Girome", "middle_name": "Roque", "email_address": "gfernandez.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
10	201000001	Rheyan	Feliciano	Lipardo	waynelipardo.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	wayne.lipardo@gmail.com	1	C-Level	{20}	1	{"company": {"levels_pk": "1", "titles_pk": "1", "supervisor": "null", "employee_id": "201000001", "departments_pk": "20", "business_email_address": "wayne.lipardo@gmail.com"}, "personal": {"last_name": "Lipardo", "first_name": "Rheyan", "middle_name": "Feliciano", "email_address": "waynelipardo.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
71	201400154	Reenalyn	Fediles	Ortilano	rortilano.chrs@gmail.com	f	2016-05-20 11:55:14.912758+08	rennalyn.ortilano@chrsglobal.com	13	Associate	{31}	3	{"company": {"hours": "250", "levels_pk": "3", "titles_pk": "13", "supervisor": "10", "employee_id": "201400154", "departments_pk": "31", "business_email_address": "rennalyn.ortilano@chrsglobal.com"}, "personal": {"last_name": "Ortilano", "first_name": "Reenalyn", "middle_name": "Fediles", "email_address": "rortilano.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
81	201400159	Maria Quiara	Flor	Valenzona	mqvalenzona.chrs@gmail.com	f	2016-05-30 11:53:45.637891+08	maria.valenzona@chrsglobal.com	13	Associate	{30}	3	{"company": {"hours": "undefined", "levels_pk": "3", "titles_pk": "13", "supervisor": "47", "employee_id": "201400159", "departments_pk": "30", "business_email_address": "maria.valenzona@chrsglobal.com"}, "personal": {"last_name": "Valenzona", "first_name": "Maria Quiara", "middle_name": "Flor", "email_address": "mqvalenzona.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
20	201400089	Ma. Fe	Pariscal	Bolinas	mfbolinas.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	mafe.bolinas@gmail.com	6	Associate	{NULL}	7	{"company": {"salary": {"amount": "12000", "salary_type": "cash"}, "levels_pk": "8", "titles_pk": "8", "supervisor": "10", "employee_id": "201400118", "date_started": "03/01/2016", "departments_pk": "22", "employee_status_pk": "3", "employment_type_pk": "1", "company_work_schedule": {"friday": {"ins": "09:00", "out": "18:00"}, "monday": {"ins": "09:00", "out": "18:00"}, "sunday": null, "tuesday": {"ins": "09:00", "out": "18:00"}, "saturday": null, "thursday": {"ins": "09:00", "out": "18:00"}, "wednesday": {"ins": "09:00", "out": "18:00"}}, "business_email_address": "chrs@chrsglobal.com"}, "personal": {"last_name": "Bolinas", "first_name": "Ma. Fe", "middle_name": "Pariscal", "email_address": "mfbolinas.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
16	201400084	Michelle	Balasta	Gongura	mgongura.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	michelle.gongura@chrsglobal.com	17	Intern	{21}	7	{"company": {"levels_pk": "7", "titles_pk": "17", "supervisor": "14", "employee_id": "201400084", "departments_pk": "21", "business_email_address": "michelle.gongura@chrsglobal.com"}, "personal": {"last_name": "Gongura", "first_name": "Michelle", "middle_name": "Balasta", "email_address": "mgongura.chrs@gmail.com", "contact_number": "09993232121", "landline_number": "5340368", "present_address": "Caloocan", "permanent_address": "Mandaluyong"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
24	201400102	John Erasmus Mari	Regado	Fernandez	undefined	f	2016-02-14 23:42:40.014678+08	johnerasmusmarif@gmail.com	12	Associate	{22}	7	{"company": {"levels_pk": "7", "titles_pk": "12", "supervisor": "19", "employee_id": "201400102", "departments_pk": "22", "business_email_address": "johnerasmusmarif@gmail.com"}, "personal": {"last_name": "Fernandez", "first_name": "John Erasmus Mari", "middle_name": "Regado", "email_address": "undefined", "contact_number": "undefined", "landline_number": "undefined", "present_address": "Undefined", "permanent_address": "Undefined"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
28	201400105	Rafael	Aurelio	Pascual	rpascual0812@gmail.com	f	2016-02-14 23:42:40.014678+08	rafael.pascual@chrsglobal.com	15	Manager	{26}	4	{"company": {"levels_pk": "4", "titles_pk": "15", "supervisor": "10", "employee_id": "201400105", "departments_pk": "26", "business_email_address": "rafael.pascual@chrsglobal.com"}, "personal": {"last_name": "Pascual", "first_name": "Rafael", "middle_name": "Aurelio", "email_address": "rpascual0812@gmail.com", "contact_number": "undefined", "landline_number": "undefined", "present_address": "undefined", "permanent_address": "undefined"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": 14, "3": 12, "4": "3", "5": "12", "7": 12}
23	201400100	Rolando	Carillo	Fabi	rollyfabi_23@yahoo.com	f	2016-02-14 23:42:40.014678+08	rolando.fabi@chrsglobal.com	3	Supervisor	{23}	8	{"company": {"levels_pk": "8", "titles_pk": "3", "supervisor": "10", "employee_id": "201400100", "departments_pk": "23", "business_email_address": "rolando.fabi@chrsglobal.com"}, "personal": {"last_name": "Fabi", "first_name": "Rolando", "middle_name": "Carillo", "email_address": "rollyfabi_23@yahoo.com", "contact_number": "0932323232", "landline_number": "undefined", "present_address": "Undefined", "permanent_address": "Undefined"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
14	201400081	Vincent	Yturralde	Ramil	vramil.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	vincent.ramil@chrsglobal.com	8	Supervisor	{21}	8	{"company": {"levels_pk": "8", "titles_pk": "8", "supervisor": "45", "employee_id": "201400081", "departments_pk": "21", "business_email_address": "vincent.ramil@chrsglobal.com"}, "personal": {"last_name": "Ramil", "first_name": "Vincent", "middle_name": "Yturralde", "email_address": "vramil.chrs@gmail.com", "contact_number": "undefined", "landline_number": "undefined", "present_address": "undefined", "permanent_address": "undefined"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
25	201400058	Rodette Joyce	Magaway	Laurio	jlaurio.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	joyce.laurio@chrsglobal.com	12	Associate	{28}	7	{"company": {"levels_pk": "7", "titles_pk": "12", "supervisor": "11", "employee_id": "201400058", "departments_pk": "28", "business_email_address": "joyce.laurio@chrsglobal.com"}, "personal": {"last_name": "Laurio", "first_name": "Rodette Joyce", "middle_name": "Magaway", "email_address": "jlaurio.chrs@gmail.com", "contact_number": "undefined", "landline_number": "323232", "present_address": "Undefined", "permanent_address": "Undefined"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
12	201400072	Ken	Villanueva	Tapdasan	ktapdasan.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	ken.tapdasan@chrsglobal.com	14	Associate	{26}	7	{"company": {"salary": {"amount": "2500", "bank_name": "BDO", "salary_type": "bank", "account_number": "323232323232"}, "levels_pk": "7", "titles_pk": "14", "supervisor": "28", "employee_id": "201400072", "departments_pk": "26", "business_email_address": "ken.tapdasan@chrsglobal.com"}, "personal": {"last_name": "Tapdasan", "first_name": "Ken", "middle_name": "Villanueva", "email_address": "ktapdasan.chrs@gmail.com", "contact_number": "09504151950", "landline_number": "None", "present_address": "Mandaluyong", "permanent_address": "Dasmarinas"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
58	201400141	Rochelle Ann	Bellita	Laquinon	ralaquinon.chrs@gmail.com	f	2016-04-25 16:56:37.76254+08	rochelle.laquinon@chrsglobal.com	\N	Associate	{32}	7	{"company": {"salary": {"amount": "12000", "salary_type": "cash"}, "levels_pk": "8", "titles_pk": "8", "supervisor": "10", "employee_id": "201400118", "date_started": "03/01/2016", "departments_pk": "22", "employee_status_pk": "3", "employment_type_pk": "1", "company_work_schedule": {"friday": {"ins": "09:00", "out": "18:00"}, "monday": {"ins": "09:00", "out": "18:00"}, "sunday": null, "tuesday": {"ins": "09:00", "out": "18:00"}, "saturday": null, "thursday": {"ins": "09:00", "out": "18:00"}, "wednesday": {"ins": "09:00", "out": "18:00"}}, "business_email_address": "chrs@chrsglobal.com"}, "personal": {"last_name": "Laquinon", "first_name": "Rochelle Ann", "middle_name": "Bellita", "email_address": "ralaquinon.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
19	201300004	Mary Grace	Soriano	Lacerna	gracesoriano.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	grace.soriano@chrsglobal.com	8	Supervisor	{22,29}	8	{"company": {"salary": {"amount": "12000", "salary_type": "cash"}, "levels_pk": "8", "titles_pk": "8", "supervisor": "10", "employee_id": "201400004", "date_started": "03/01/2016", "departments_pk": "22", "employee_status_pk": "3", "employment_type_pk": "1", "company_work_schedule": {"friday": {"ins": "09:00", "out": "18:00"}, "monday": {"ins": "09:00", "out": "18:00"}, "sunday": null, "tuesday": {"ins": "09:00", "out": "18:00"}, "saturday": null, "thursday": {"ins": "09:00", "out": "18:00"}, "wednesday": {"ins": "09:00", "out": "18:00"}}, "business_email_address": "grace_lacerna@chrsglobal.com"}, "personal": {"last_name": "Lacerna", "first_name": "Mary Grace", "middle_name": "Soriano", "email_address": "gracesoriano.chrs@gmail.com", "contact_number": "undefined", "landline_number": "undefined", "present_address": "undefined", "permanent_address": "undefined"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
40	201400118	Cristina	Tulayan	Ibanez	cibanez.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	tina_041481@yahoo.com	13	Associate	{22,29}	7	{"company": {"salary": {"amount": "12000", "salary_type": "cash"}, "levels_pk": "8", "titles_pk": "8", "supervisor": "10", "employee_id": "201400118", "date_started": "03/01/2016", "departments_pk": "22", "employee_status_pk": "3", "employment_type_pk": "1", "company_work_schedule": {"friday": {"ins": "09:00", "out": "18:00"}, "monday": {"ins": "09:00", "out": "18:00"}, "sunday": null, "tuesday": {"ins": "09:00", "out": "18:00"}, "saturday": null, "thursday": {"ins": "09:00", "out": "18:00"}, "wednesday": {"ins": "09:00", "out": "18:00"}}, "business_email_address": "chrs@chrsglobal.com"}, "personal": {"last_name": "Ibanez", "first_name": "Cristina", "middle_name": "Tulayan", "email_address": "cibanez.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
32	201400109	Angelica	Barredo	Abaleta	aabelata.chrs@gmail.com	f	2016-02-14 23:42:40.014678+08	a.abaleta@yahoo.com	13	Associate	{NULL}	7	{"company": {"salary": {"amount": "12000", "salary_type": "cash"}, "levels_pk": "8", "titles_pk": "8", "supervisor": "10", "employee_id": "201400118", "date_started": "03/01/2016", "departments_pk": "22", "employee_status_pk": "3", "employment_type_pk": "1", "company_work_schedule": {"friday": {"ins": "09:00", "out": "18:00"}, "monday": {"ins": "09:00", "out": "18:00"}, "sunday": null, "tuesday": {"ins": "09:00", "out": "18:00"}, "saturday": null, "thursday": {"ins": "09:00", "out": "18:00"}, "wednesday": {"ins": "09:00", "out": "18:00"}}, "business_email_address": "chrs@chrsglobal.com"}, "personal": {"last_name": "Abaleta", "first_name": "Angelica", "middle_name": "Barredo", "email_address": "aabelata.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
36	201400113	Aprilil Mae	Denalo	Nefulda	Aprilil.nefulda@chrsglobal.com	f	2016-02-14 23:42:40.014678+08	Aprililmaenefulda@ymail.com	13	Associate	{NULL}	7	{"company": {"salary": {"amount": "12000", "salary_type": "cash"}, "levels_pk": "8", "titles_pk": "8", "supervisor": "10", "employee_id": "201400118", "date_started": "03/01/2016", "departments_pk": "22", "employee_status_pk": "3", "employment_type_pk": "1", "company_work_schedule": {"friday": {"ins": "09:00", "out": "18:00"}, "monday": {"ins": "09:00", "out": "18:00"}, "sunday": null, "tuesday": {"ins": "09:00", "out": "18:00"}, "saturday": null, "thursday": {"ins": "09:00", "out": "18:00"}, "wednesday": {"ins": "09:00", "out": "18:00"}}, "business_email_address": "chrs@chrsglobal.com"}, "personal": {"last_name": "Nefulda", "first_name": "Aprilil Mae", "middle_name": "Denalo", "email_address": "Aprilil.nefulda@chrsglobal.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
26	201400103	Gerlie	Pagaduan	Andres	gerlie.andres@chrsglobal.com	f	2016-02-14 23:42:40.014678+08	gerlieandres0201@gmail.com	12	Intern	{24}	3	{"company": {"salary": {"amount": "12000", "salary_type": "cash"}, "levels_pk": "8", "titles_pk": "8", "supervisor": "10", "employee_id": "201400118", "date_started": "03/01/2016", "departments_pk": "22", "employee_status_pk": "3", "employment_type_pk": "1", "company_work_schedule": {"friday": {"ins": "09:00", "out": "18:00"}, "monday": {"ins": "09:00", "out": "18:00"}, "sunday": null, "tuesday": {"ins": "09:00", "out": "18:00"}, "saturday": null, "thursday": {"ins": "09:00", "out": "18:00"}, "wednesday": {"ins": "09:00", "out": "18:00"}}, "business_email_address": "chrs@chrsglobal.com"}, "personal": {"last_name": "Andres", "first_name": "Gerlie", "middle_name": "Pagaduan", "email_address": "gerlie.andres@chrsglobal.com", "contact_number": "undefined", "landline_number": "undefined", "present_address": "undefined", "permanent_address": "undefined"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
64	201400151	Ma. Maxine Estrelle	Mercado	Soliven	mmesoliven.chrs@gmail.com	f	2016-05-20 11:48:09.95915+08	maxine.soliven@chrsglobal.com	23	one	{30}	\N	{"company": {"salary": {"amount": "12000", "salary_type": "cash"}, "levels_pk": "8", "titles_pk": "8", "supervisor": "10", "employee_id": "201400118", "date_started": "03/01/2016", "departments_pk": "22", "employee_status_pk": "3", "employment_type_pk": "1", "company_work_schedule": {"friday": {"ins": "09:00", "out": "18:00"}, "monday": {"ins": "09:00", "out": "18:00"}, "sunday": null, "tuesday": {"ins": "09:00", "out": "18:00"}, "saturday": null, "thursday": {"ins": "09:00", "out": "18:00"}, "wednesday": {"ins": "09:00", "out": "18:00"}}, "business_email_address": "chrs@chrsglobal.com"}, "personal": {"last_name": "Soliven", "first_name": "Ma. Maxine Estrelle", "middle_name": "Mercado", "email_address": "mmesoliven.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
52	201400134	Blu Raven	Lipardo	Villanueva	brvillanueva.chrs@gmail.com	f	2016-04-12 16:08:41.478974+08	blu.villanueva@chrsglobal.com	\N	Associate	{31}	7	{"company": {"salary": {"amount": "12000", "salary_type": "cash"}, "levels_pk": "8", "titles_pk": "8", "supervisor": "10", "employee_id": "201400118", "date_started": "03/01/2016", "departments_pk": "22", "employee_status_pk": "3", "employment_type_pk": "1", "company_work_schedule": {"friday": {"ins": "09:00", "out": "18:00"}, "monday": {"ins": "09:00", "out": "18:00"}, "sunday": null, "tuesday": {"ins": "09:00", "out": "18:00"}, "saturday": null, "thursday": {"ins": "09:00", "out": "18:00"}, "wednesday": {"ins": "09:00", "out": "18:00"}}, "business_email_address": "chrs@chrsglobal.com"}, "personal": {"last_name": "Villanueva", "first_name": "Blu Raven", "middle_name": "Lipardo", "email_address": "brvillanueva.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
57	201400140	Lovely	De Leon	Larracas	llarracas.chrs@gmail.com	f	2016-04-25 16:56:37.76254+08	lovely.larracas@chrsglobal.com	\N	Associate	{32}	7	{"company": {"salary": {"amount": "12000", "salary_type": "cash"}, "levels_pk": "8", "titles_pk": "8", "supervisor": "10", "employee_id": "201400118", "date_started": "03/01/2016", "departments_pk": "22", "employee_status_pk": "3", "employment_type_pk": "1", "company_work_schedule": {"friday": {"ins": "09:00", "out": "18:00"}, "monday": {"ins": "09:00", "out": "18:00"}, "sunday": null, "tuesday": {"ins": "09:00", "out": "18:00"}, "saturday": null, "thursday": {"ins": "09:00", "out": "18:00"}, "wednesday": {"ins": "09:00", "out": "18:00"}}, "business_email_address": "chrs@chrsglobal.com"}, "personal": {"last_name": "Larracas", "first_name": "Lovely", "middle_name": "De Leon", "email_address": "llarracas.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
56	201400139	Romarie Joy	Bulawit	Silva	rsilva.chrs@gmail.com	f	2016-04-25 16:56:37.76254+08	romarie.silva@chrsglobal.com	\N	Associate	{32}	7	{"company": {"salary": {"amount": "12000", "salary_type": "cash"}, "levels_pk": "8", "titles_pk": "8", "supervisor": "10", "employee_id": "201400118", "date_started": "03/01/2016", "departments_pk": "22", "employee_status_pk": "3", "employment_type_pk": "1", "company_work_schedule": {"friday": {"ins": "09:00", "out": "18:00"}, "monday": {"ins": "09:00", "out": "18:00"}, "sunday": null, "tuesday": {"ins": "09:00", "out": "18:00"}, "saturday": null, "thursday": {"ins": "09:00", "out": "18:00"}, "wednesday": {"ins": "09:00", "out": "18:00"}}, "business_email_address": "chrs@chrsglobal.com"}, "personal": {"last_name": "Silva", "first_name": "Romarie Joy", "middle_name": "Bulawit", "email_address": "rsilva.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
61	201400144	Romnick	Bedonia	Ilag	rilag.chrs@gmail.com	f	2016-04-25 16:56:37.76254+08	romnick.ilag@chrsglobal.com	\N	Associate	{25}	7	{"company": {"salary": {"amount": "12000", "salary_type": "cash"}, "levels_pk": "8", "titles_pk": "8", "supervisor": "10", "employee_id": "201400118", "date_started": "03/01/2016", "departments_pk": "22", "employee_status_pk": "3", "employment_type_pk": "1", "company_work_schedule": {"friday": {"ins": "09:00", "out": "18:00"}, "monday": {"ins": "09:00", "out": "18:00"}, "sunday": null, "tuesday": {"ins": "09:00", "out": "18:00"}, "saturday": null, "thursday": {"ins": "09:00", "out": "18:00"}, "wednesday": {"ins": "09:00", "out": "18:00"}}, "business_email_address": "chrs@chrsglobal.com"}, "personal": {"last_name": "Ilag", "first_name": "Romnick", "middle_name": "Bedonia", "email_address": "rilag.chrs@gmail.com"}, "government": {"data_sss": "N/A", "data_tin": "N/A", "data_phid": "N/A", "data_pagmid": "N/A"}}	{"1": "12", "3": "12", "4": "3", "5": "12", "7": "12"}
\.


--
-- Data for Name: employees_backup; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY employees_backup (pk, details, leave_balances, date_created, archived) FROM stdin;
5	{"company": {"salary": {"amount": "323232", "bank_name": "dwdaw", "salary_type": "bank", "account_number": "323232"}, "levels_pk": "", "titles_pk": "", "employee_id": "", "date_started": "", "supervisor_pk": "", "work_schedule": {"friday": {"in": "null", "out": "null"}, "monday": {"in": "null", "out": "null"}, "sunday": {"in": "null", "out": "null"}, "tuesday": {"in": "null", "out": "null"}, "saturday": {"in": "null", "out": "null"}, "thursday": {"in": "null", "out": "null"}, "wednesday": {"in": "null", "out": "null"}}, "departments_pk": "", "employee_status": "", "employment_type": "", "business_email_address": ""}, "personal": {"gender": "", "religion": "", "last_name": "", "birth_date": "", "first_name": "", "civilstatus": "", "middle_name": "", "contact_number": "null", "landline_number": "null", "present_address": "", "profile_picture": "./ASSETS/img/blank.gif", "permanent_address": "", "emergency_contact_name": "", "emergency_contact_number": ""}, "education": {"school_type": [{"educ_level": "Primary"}]}, "government": {"data_sss": "null", "data_tin": "null", "data_phid": "null", "data_pagmid": "null"}}	\N	2016-09-22 14:17:29.666739+08	f
\.


--
-- Name: employees_backup_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('employees_backup_pk_seq', 5, true);


--
-- Data for Name: employees_logs; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY employees_logs (employees_pk, log, created_by, date_created) FROM stdin;
\.


--
-- Data for Name: employees_permissions; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY employees_permissions (employees_pk, permission, archived) FROM stdin;
28	{ \n"employees" : {\n"list" : true,\n"employees" : true\n}, \n"management" : {\n"manual log" : true,\n"leave" : true\n}, \n"administration" : {\n"departments" : true,\n"positions" : true,\n"levels" : true,\n"permissions" : true\n} \n}	f
12	{ \n"employees" : {\n"list" : true,\n"employees" : true\n}, \n"management" : {\n"manual log" : true,\n"leave" : true\n}, \n"administration" : {\n"departments" : true,\n"positions" : true,\n"levels" : true,\n"permissions" : true\n} \n}	f
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
-- Data for Name: employment_statuses; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY employment_statuses (pk, status, archived) FROM stdin;
1	Probationary	f
2	Trainee	f
3	Contractual	f
4	Regular	f
5	Consultant	f
\.


--
-- Name: employment_statuses_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('employment_statuses_pk_seq', 5, true);


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
-- Data for Name: gender_type; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY gender_type (pk, type, archived) FROM stdin;
1	Male	f
2	Female	f
\.


--
-- Name: gender_type_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('gender_type_pk_seq', 2, true);


--
-- Data for Name: groupings; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY groupings (employees_pk, supervisor_pk) FROM stdin;
21	10
42	19
27	10
15	10
41	10
13	11
38	\N
40	19
37	\N
20	10
43	\N
10	\N
11	10
29	45
31	45
32	11
33	14
36	11
35	14
45	11
47	10
48	19
49	19
52	\N
53	10
55	10
62	28
59	\N
60	\N
61	\N
56	\N
57	\N
64	47
70	10
71	10
74	\N
76	\N
77	\N
78	\N
79	47
81	47
82	47
83	\N
84	\N
30	45
39	28
34	14
51	28
54	10
58	\N
80	\N
17	10
22	10
63	28
28	10
16	14
26	11
23	10
24	19
19	10
18	14
14	45
25	11
12	28
\.


--
-- Data for Name: holidays; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY holidays (pk, name, type, datex, created_by, archived) FROM stdin;
1	adas	Special Non-Working	2016-09-15 00:00:00+08	28	f
2	asdsa	Special Working	2016-09-17 00:00:00+08	28	f
3	Bday ule ni Pat	Regular	2016-09-17 00:00:00+08	28	f
4	di na bday ni pat	Regular	2016-09-19 00:00:00+08	28	f
5	asdas	Special Non-Working	2016-11-23 00:00:00+08	28	f
\.


--
-- Name: holidays_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('holidays_pk_seq', 5, true);


--
-- Data for Name: leave_filed; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY leave_filed (pk, employees_pk, leave_types_pk, date_started, date_ended, date_created, archived, duration, category) FROM stdin;
56	51	1	2016-08-22 00:00:00+08	2016-08-23 00:00:00+08	2016-08-21 15:38:17.503495+08	f	Whole Day	Paid
57	51	4	2016-08-23 00:00:00+08	2016-08-23 00:00:00+08	2016-08-23 19:33:21.524293+08	f	Whole Day	Paid
58	28	1	2016-08-25 00:00:00+08	2016-08-25 00:00:00+08	2016-08-25 10:51:30.737233+08	t	Whole Day	Paid
59	51	3	2016-08-30 00:00:00+08	2016-08-30 00:00:00+08	2016-08-25 11:38:32.430418+08	f	Whole Day	Paid
60	51	3	2016-08-31 00:00:00+08	2016-08-31 00:00:00+08	2016-08-25 11:41:33.824252+08	f	Whole Day	Paid
61	28	3	2016-09-05 00:00:00+08	2016-09-05 00:00:00+08	2016-09-05 15:04:51.559512+08	t	First Half	Paid
62	28	7	2016-09-05 00:00:00+08	2016-09-08 00:00:00+08	2016-09-05 15:07:57.472283+08	t	Whole Day	Paid
\.


--
-- Name: leave_filed_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('leave_filed_pk_seq', 62, true);


--
-- Data for Name: leave_status; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY leave_status (leave_filed_pk, status, created_by, date_created, remarks, archived) FROM stdin;
56	Pending	51	2016-08-21 15:38:17.503495+08	asdf	f
56	Approved	28	2016-08-21 15:39:13.220684+08	Approved	f
57	Pending	51	2016-08-23 19:33:21.524293+08	ddd	f
58	Pending	28	2016-08-25 11:09:32.187648+08		f
58	Deleted	28	2016-08-25 11:09:56.632673+08	DELETED	f
57	Approved	28	2016-08-25 11:33:41.665341+08	Approved	f
59	Pending	51	2016-08-25 11:38:32.430418+08	Test	f
59	Approved	28	2016-08-25 11:39:36.030663+08	Approved	f
60	Pending	51	2016-08-25 11:41:33.824252+08	xdsfdf	f
60	Disapproved	28	2016-08-25 11:42:01.585393+08	dfsakdjf	f
61	Pending	28	2016-09-05 15:04:51.559512+08	asdsadas	f
61	Deleted	28	2016-09-05 15:04:58.856659+08	DELETED	f
62	Pending	28	2016-09-05 15:07:57.472283+08	aa	f
62	Deleted	28	2016-09-05 15:08:35.419491+08	DELETED	f
\.


--
-- Data for Name: leave_types; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY leave_types (pk, name, code, days, archived, details) FROM stdin;
4	Emergency Leave	EL	3	f	{"staggered": "Staggered monthly", "regularization": 180}
3	Sick Leave	SL	12	f	{"staggered": "Staggered monthly", "regularization": 180}
5	Maternity Leave	ML	12	f	{"staggered": "Staggered monthly", "regularization": 180}
7	Paternity Leave	PL	12	f	{"staggered": "Staggered monthly", "regularization": "180"}
1	Vacation Leave	VL	12	f	{"staggered": "Staggered monthly", "regularization": "90"}
6	LWOP	LWOP	0	t	{"staggered": "Staggered monthly", "regularization": 180}
\.


--
-- Name: leave_types_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('leave_types_pk_seq', 7, true);


--
-- Data for Name: levels; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY levels (pk, level_title, archived) FROM stdin;
1	C-Level	f
2	Specialist	f
4	Manager	f
5	Officer	f
6	Assistant Manager	f
7	Associate	f
8	Supervisor	f
9	Rank and File	f
3	Intern	f
\.


--
-- Name: levels_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('levels_pk_seq', 9, true);


--
-- Data for Name: manual_logs; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY manual_logs (pk, employees_pk, type, time_log, date_created, archived) FROM stdin;
1	28	In	2016-08-10 12:41:00+08	2016-08-17 12:41:19.733022+08	f
2	28	In	2016-08-12 12:41:00+08	2016-08-17 12:41:46.354549+08	f
3	51	In	2016-08-09 12:49:00+08	2016-08-17 12:49:12.459251+08	f
4	51	In	2016-08-10 12:49:00+08	2016-08-17 12:49:56.619288+08	f
5	51	In	2016-08-09 08:00:00+08	2016-08-21 13:56:59.781138+08	f
10	51	In	2016-08-16 09:33:00+08	2016-08-25 09:33:47.257704+08	f
11	51	In	2016-08-16 11:29:00+08	2016-08-25 11:29:50.188995+08	f
\.


--
-- Name: manual_logs_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('manual_logs_pk_seq', 11, true);


--
-- Data for Name: manual_logs_status; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY manual_logs_status (manual_logs_pk, status, created_by, date_created, remarks, archived) FROM stdin;
1	Pending	28	2016-08-17 12:41:19.733022+08	dd	f
2	Pending	28	2016-08-17 12:41:46.354549+08	dd	f
5	Approved	28	2016-08-21 13:56:59.781138+08	APPROVED	f
4	Approved	28	2016-08-17 12:49:56.619288+08	APPROVED	f
3	Approved	28	2016-08-17 12:49:12.459251+08	APPROVED	f
10	Disapproved	28	2016-08-25 09:33:47.257704+08	SDFSDFSD	f
11	Approved	28	2016-08-25 11:29:50.188995+08	APPROVED	f
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY notifications (pk, created_by, employees_pk, notification, table_from, table_from_pk, read, date_created, archived) FROM stdin;
1	28	10	New leave filed.	leave_filed	58	f	2016-08-25 10:51:30.737233+08	f
4	\N	51	New manual log filed.	manual_log	11	f	2016-08-25 11:29:50.188995+08	f
6	\N	51	Leave Approved	leave_filed	57	f	2016-08-25 11:33:41.665341+08	f
8	\N	51	Leave Approved	leave_filed	59	f	2016-08-25 11:39:36.030663+08	f
10	\N	51	Leave Disapproved	leave_filed	60	f	2016-08-25 11:42:01.585393+08	f
9	51	28	New leave filed.	leave_filed	60	t	2016-08-25 11:41:33.824252+08	f
15	28	10	New leave filed.	leave_filed	61	f	2016-09-05 15:04:51.559512+08	f
16	28	10	New leave filed.	leave_filed	62	f	2016-09-05 15:07:57.472283+08	f
7	51	28	New leave filed.	leave_filed	59	t	2016-08-25 11:38:32.430418+08	f
11	12	28	Overtime filed	overtime	2	t	2016-09-06 21:59:23.758447+08	f
5	\N	28	Manual log filed Approved	manual_log	11	t	2016-08-25 11:30:29.672453+08	f
3	\N	28	Manual log filed Disapproved	manual_log	10	t	2016-08-25 11:26:03.181171+08	f
2	\N	28	Manual log filed Approved	manual_log	3	t	2016-08-25 11:25:51.116912+08	f
14	28	12	Overtime Disapproved	overtime_result	2	t	2016-09-01 17:04:42.361253+08	f
13	28	12	Overtime Disapproved	overtime_result	2	t	2016-09-01 17:03:22.61511+08	f
12	28	12	Overtime Disapproved	overtime_result	2	t	2016-09-01 17:01:46.180476+08	f
17	12	28	New attrition filed	attritions	2	t	2016-09-21 11:04:01.093405+08	f
19	28	\N	Attrition response	attrition	1	f	2016-09-21 11:05:02.493515+08	f
18	28	12	Attrition response	attrition	2	t	2016-09-21 11:04:53.480743+08	f
\.


--
-- Name: notifications_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('notifications_pk_seq', 19, true);


--
-- Data for Name: overtime; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY overtime (pk, time_from, time_to, employees_pk, date_created, archived) FROM stdin;
1	2016-09-03 17:00:00+08	2016-09-03 19:19:12+08	12	2016-09-03 19:19:30.547816+08	f
2	2016-09-06 17:00:00+08	2016-09-06 21:59:19+08	12	2016-09-06 21:59:23.758447+08	f
\.


--
-- Name: overtime_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('overtime_pk_seq', 2, true);


--
-- Data for Name: overtime_status; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY overtime_status (overtime_pk, created_by, status, date_created, remarks) FROM stdin;
1	12	Pending	2016-09-03 19:19:30.547816+08	....
1	12	Cancelled	2016-09-03 19:20:46.565613+08	awaladfa sd
2	12	Pending	2016-09-06 21:59:23.758447+08	RAF ASDFAVFAWCEFA
2	28	Disapproved	2016-09-01 17:01:46.180476+08	
2	28	Disapproved	2016-09-01 17:03:22.61511+08	
2	28	Disapproved	2016-09-01 17:04:42.361253+08	
\.


--
-- Data for Name: payroll; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY payroll (pk, date_created, first_name) FROM stdin;
1	2016-08-22 15:45:01.644785+08	Rafael
\.


--
-- Name: payroll_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('payroll_pk_seq', 1, true);


--
-- Data for Name: salary_types; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY salary_types (pk, type, archived) FROM stdin;
1	bank	f
2	cash	f
3	wire	f
\.


--
-- Name: salary_types_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('salary_types_pk_seq', 3, true);


--
-- Data for Name: suspension; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY suspension (pk, time_from, time_to, remarks, created_by, archived) FROM stdin;
8	2016-09-15 14:00:00+08	2016-09-16 13:00:00+08	zxzxxz	28	t
1	2016-09-13 12:00:00+08	2016-09-14 13:00:00+08	asdasdsadaadasasdsaddasdasa	28	t
2	2016-09-11 14:00:00+08	2016-09-23 15:00:00+08	Gusto ko lang!	28	t
3	2016-09-05 13:00:00+08	2016-09-22 14:00:00+08	aa	28	t
4	2016-09-15 10:00:00+08	2016-09-16 11:00:00+08	zzz	28	t
5	2016-09-15 11:00:00+08	2016-09-16 22:00:00+08	adasdasdasas	28	t
6	2016-09-15 09:00:00+08	2016-09-15 11:00:00+08	,./ ,m,	28	t
7	2016-09-15 12:00:00+08	2016-09-15 13:00:00+08	ascassdsa	28	t
\.


--
-- Name: suspension_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('suspension_pk_seq', 8, true);


--
-- Data for Name: time_log; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY time_log (employees_pk, type, date_created, time_log, random_hash, pk) FROM stdin;
30	In	2016-03-07 11:40:05.831914+08	2016-03-07 11:40:05.831914+08	LCELaNashc1cZALOK3rBvliA9SRSlWw8iCTJZ3CHfDsFNEdhIV	11
47	In	2016-03-07 12:20:45.91341+08	2016-03-07 12:20:45.91341+08	sEHaOP3proMow61QPaTbq9njOBy3sGYlUoMsEPi7E5vCBwcZW5	12
17	In	2016-03-07 12:34:02.969568+08	2016-03-07 12:34:02.969568+08	BNFz8dB6f4NEpr3CkIbTOpYK2iHdJnjUCxTJbeQIimWYeZkOqL	13
11	In	2016-03-07 13:07:55.739427+08	2016-03-07 13:07:55.739427+08	rFBPZD9qqSeZwqYQAA5ZRoNxN1W8QOTHdfhDsq4iIiJFZqfj1k	14
25	In	2016-03-07 13:08:58.074692+08	2016-03-07 13:08:58.074692+08	JSZgQwhw58KYPxE7B6xFpGx9VXzAH1uaTUGsRxpW6B5V9JcKPZ	15
13	In	2016-03-07 13:10:01.174937+08	2016-03-07 13:10:01.174937+08	aFpYOL6OVNORxrvElNCbtImynvIQGh0qwpPLBVihs78qz46kRI	16
41	In	2016-03-07 14:26:51.77572+08	2016-03-07 14:26:51.77572+08	MLa9KO5coLKoCHeacq7LX0SfrSkwDCFZXqisFnV49psK7XviO3	17
26	Out	2016-03-07 16:07:02.161364+08	2016-03-07 16:07:02.161364+08	4v3WbuyMrCY7l6xVyDJTGSJ9mQgiA4lEzokbijwavVhhbfDasW	18
48	In	2016-03-07 16:37:53.745243+08	2016-03-07 16:37:53.745243+08	49yNIloxUx3GC35wdngbOb77JimWIe3Mn2k5nY4IX6Yj9dfmRM	19
48	Out	2016-03-07 18:00:21.373753+08	2016-03-07 18:00:21.373753+08	OpxVwIEjoWOrsCtdHgCLyjRXSaB9NcVlSTHPlV9a2XSujMZ23l	20
27	Out	2016-03-07 18:00:25.109912+08	2016-03-07 18:00:25.109912+08	N3VoaxPl7nOcZq6rHrNQSPxtKhGtjKf6MBvw9LiH96tiwzaEqx	21
17	Out	2016-03-07 18:00:31.828868+08	2016-03-07 18:00:31.828868+08	eJMcDhKUb4nGAAR67bRpsavlJslt7cqlvEOAuieWmSmxcF4jqV	22
41	Out	2016-03-07 18:01:17.261243+08	2016-03-07 18:01:17.261243+08	Zi6VVPOHJVtAIpOg0JPepC6dAisDTji2SoXxDvEWR8gjx5PxOo	23
25	Out	2016-03-07 18:01:25.309+08	2016-03-07 18:01:25.309+08	cF2jrBSkOvU7xwvVt9R8fsGMbER2Dpqp4sYw42hSwCau8WQ2fq	24
23	Out	2016-03-07 18:01:45.404678+08	2016-03-07 18:01:45.404678+08	ALjRhLf8NsxFi37HyBJgeGsFB1ka3QSElBfTXLbuDZ9vcHDbSW	25
12	Out	2016-03-07 18:02:01.981262+08	2016-03-07 18:02:01.981262+08	J7mCMxD7YGX1UJCAmjUOeiyneb5rDXOWfCi19u8iBfjfzvpmfK	26
28	Out	2016-03-07 18:02:22.807699+08	2016-03-07 18:02:22.807699+08	BK3A8glDYykxVQADRJ8Z2KGkzGgp3MAEfCNnt91S8mQdDaqety	27
13	Out	2016-03-07 18:05:21.932566+08	2016-03-07 18:05:21.932566+08	EuJUgJkN9mjI1PVPDPYFrg2IJErAsl98gRcNkNktAUCBtha779	28
30	Out	2016-03-07 18:06:34.525406+08	2016-03-07 18:06:34.525406+08	MxoNG8c9IVuRdbsFyecjXnEjy8RZFYibWXymgbvy7qQkSKzRxc	29
31	Out	2016-03-07 13:03:24.803197+08	2016-03-07 13:03:24.803197+08	BVQPGPXhymGhOnFNavyWu6NLppfpHdSS9srPIP8HCOyZCFwmBv	30
29	Out	2016-03-07 13:03:37.382413+08	2016-03-07 13:03:37.382413+08	J62gSrW8hmlBFu47KMWSdirdI4rFq3BAADqb5NjmAUwPP1XkN4	31
47	Out	2016-03-07 18:11:43.105179+08	2016-03-07 18:11:43.105179+08	D2m5e58WLyaW9jjzMoN6bXaYw0ZUkwYyyL4dQCAlBkIKV2Kqqg	32
18	Out	2016-03-07 18:12:01.778656+08	2016-03-07 18:12:01.778656+08	wREX0BYZeJXDIVYL9yXKki533a5NRu4ONIvNTUw8nTL6ztR9sy	33
14	Out	2016-03-07 18:18:08.462828+08	2016-03-07 18:18:08.462828+08	TdiYgl8k8afCy3UuQxPN6DqRIqLjzEjTqR1XDAILjxYi23dR13	34
45	Out	2016-03-07 18:19:27.196977+08	2016-03-07 18:19:27.196977+08	o6GfXYWsIW62zxT1VgBn2uladndHFeK4kajJ9GBSmIUmFxnkey	35
11	Out	2016-03-07 18:22:00.168102+08	2016-03-07 18:22:00.168102+08	XguKHY7vqMaBQLlAeuQpNE8r1Noo8TogBj0SI7N8TxJtJ64x1U	36
41	In	2016-03-08 08:24:18.483061+08	2016-03-08 08:24:18.483061+08	nOivGjJ5YRYN8j68COGZWjXqdqvhowCcLuYbergDKFZSygaB5q	37
28	In	2016-03-08 08:26:59.845928+08	2016-03-08 08:26:59.845928+08	kbaIREANvyK9bf4AHh2xuMCVoBBPMGG7rqPJ6Zh2Y2BAiFKzwM	38
23	In	2016-03-08 08:27:29.703135+08	2016-03-08 08:27:29.703135+08	wrjANYLYxhoEng6DzCmhELjOURdoRaCOSvYpTsORaDgPtlctxP	39
26	In	2016-03-08 08:28:04.809894+08	2016-03-08 08:28:04.809894+08	aCkKaFlE5DoHbHCA7f4V8ein3bafVY56kpQL5CZAQOR2fdClJG	40
12	In	2016-03-08 08:29:07.939125+08	2016-03-08 08:29:07.939125+08	HRtzFxbpd7OjD9ZeUeq3oHRGJ7tVsDkAffAucmkGtAz7JZlmEc	41
30	In	2016-03-08 08:31:14.681182+08	2016-03-08 08:31:14.681182+08	q3sHKCOEhHRSR78c2kOm2Iw2QGbC3posshBDtZQbqr5IyDu1xK	42
17	In	2016-03-08 08:32:29.127312+08	2016-03-08 08:32:29.127312+08	nzck231cF4S3wLk8XegxGXqLqpXlpV6eViPXlPA0Tc4QwoYUTF	43
48	In	2016-03-08 08:34:15.348835+08	2016-03-08 08:34:15.348835+08	TjmJ5d9dQy9VdfF2C0SM1vy5MvstRM9t6wDCaMo0LyWxdk1qlS	44
25	In	2016-03-08 08:43:25.87703+08	2016-03-08 08:43:25.87703+08	DmOCqk9keZ7nTDkhPK4ELPDqNqcOgOqtAF720FleosSJ6D1UX4	45
18	In	2016-03-08 08:45:32.594354+08	2016-03-08 08:45:32.594354+08	isTvjqmMETk5NuLUwLjizYbSrhesDCwv5QroGeBV8vaVqu0nGj	46
31	In	2016-03-08 08:46:28.091295+08	2016-03-08 08:46:28.091295+08	WGJ8hBpM43Z1yeQqThVeCcam9Qi9EyskECtvNjJRmsSlWscza7	47
27	In	2016-03-08 08:48:09.875441+08	2016-03-08 08:48:09.875441+08	emkEZsfI2tGveV8YRVIkw5cPq9JS9tangK2GEhYGboCGKJolp7	48
45	In	2016-03-08 08:49:16.181366+08	2016-03-08 08:49:16.181366+08	WmC9C2JUVSO5G5QILdzttbi6r3PgoFmL2yVE1oiWH7cXC2pXgp	49
13	In	2016-03-08 08:53:31.389269+08	2016-03-08 08:53:31.389269+08	RaRAgID7y3MlOOktbmiLJzSuWexNCdDdFdnvv13u4PgSmSMPE5	50
14	In	2016-03-08 08:57:08.970241+08	2016-03-08 08:57:08.970241+08	jX5CSbqQy34BgJpUFlVIgZgN2TpOs4UdbYp4BgT9jXLQqAu6vP	51
11	In	2016-03-08 09:02:07.736326+08	2016-03-08 09:02:07.736326+08	Ncy411YqPRut5WSuadb4mLb8lSIgYE6vq51r6ZiV1dP69r0jUb	52
49	In	2016-03-08 09:06:46.782774+08	2016-03-08 09:06:46.782774+08	nHwPPishPRvVNmaOegxNCx1b4AT4txfhGc7eLzMkRIGo5rDjYA	53
26	Out	2016-03-08 16:03:54.760259+08	2016-03-08 16:03:54.760259+08	7k88MCIpGCovt4Y1jt16eROuGTmTDLdK6lSTykJFw8BqCjrvds	54
48	Out	2016-03-08 17:59:05.774623+08	2016-03-08 17:59:05.774623+08	2ILQDbt057LhRSUtuSeEhbMsSZcKVGEXYZxmBrmFx9wPaRIWtw	55
11	Out	2016-03-08 18:00:08.779787+08	2016-03-08 18:00:08.779787+08	kbY8U1g8LCOZjx9hjJZXYXgWwHxFnrCYTkfxkN66ZUfJSo2C8a	56
31	Out	2016-03-08 18:00:12.747056+08	2016-03-08 18:00:12.747056+08	jg8QD5hBKU3W3WHiU26a8f5nyXc1jkbTRksepapA5rh8Oxqs1w	57
41	Out	2016-03-08 18:00:37.470899+08	2016-03-08 18:00:37.470899+08	T9cYwb6ZcpKEJlyDPnnFys7f1VerOenrnQRk2XKeNesgPrtpfg	58
25	Out	2016-03-08 18:00:51.388258+08	2016-03-08 18:00:51.388258+08	5eZCKZhyR7dFyRgQCiwWNLBG2a8vQncUSChmlPlDVPTUq9u3rr	59
49	Out	2016-03-08 18:01:48.095596+08	2016-03-08 18:01:48.095596+08	ZFDkVFLdAlRmGuyxhkNTxssRNjaImSAMiN7EcSsmEKZUEYRvJo	60
18	Out	2016-03-08 18:01:48.937727+08	2016-03-08 18:01:48.937727+08	PHhIi52JNnmYBUvIiYkbLxvvSAUt7niW5QnnVp7sdtRoON68vq	61
13	Out	2016-03-08 18:02:17.141509+08	2016-03-08 18:02:17.141509+08	jIofDHphBwVtSaKHOp6WjkPBZoYfwUWfmLL0cBhn8Dhbn2rCry	62
27	Out	2016-03-08 18:02:56.677464+08	2016-03-08 18:02:56.677464+08	iaj8lIwKxtoUZbpubS6JFFWwpKyiWqhFRQNDiKXgEMBnx1iZTo	63
23	Out	2016-03-08 18:03:03.634168+08	2016-03-08 18:03:03.634168+08	sj4PgujfcHVKWwktATFhBT4MH2OzbroTastHndwQuSkRPVLZya	64
30	Out	2016-03-08 18:03:20.848599+08	2016-03-08 18:03:20.848599+08	H93LVKMtJxl8RM2LdoyaFt2zKRUf1TGIdJc9dz3xxo6PB8kowj	65
12	Out	2016-03-08 18:03:24.680777+08	2016-03-08 18:03:24.680777+08	OCdRCxshetBuCnEowso0pmowCy4xn2hCELdQJW8xRJsd77S4zH	66
28	Out	2016-03-08 18:03:37.395662+08	2016-03-08 18:03:37.395662+08	4p5smHrqFfsws7IWXb3fZUxS75YZAYrEOv7ADz1SftPY1g5XI8	67
14	Out	2016-03-08 18:04:54.933987+08	2016-03-08 18:04:54.933987+08	DrcBKjHsKRRBfp7m1Lm2mTvC2wt6UCFh4qtObBHubj7HZE5aYr	68
45	Out	2016-03-08 18:07:08.754122+08	2016-03-08 18:07:08.754122+08	cMLYYMVSTzehhiZb7AlO6N8CfgQjHzbtLwStJwMmw1Uei4GpE2	69
17	Out	2016-03-08 18:16:22.471313+08	2016-03-08 18:16:22.471313+08	EKQMW53xoKwREIOfDhcZTaZyFJ2V9HXNbxj83m6r73JLLg1YOe	70
12	In	2016-03-09 08:06:46.079569+08	2016-03-09 08:06:46.079569+08	8rEhqT1syAAWXlUHtX4zPC3iXOPYxnC6fRnWuoPtyZRWLvnFSr	71
17	In	2016-03-09 08:06:53.660195+08	2016-03-09 08:06:53.660195+08	Fr4Iaagz9dnMjTmXzhMPcLy3rKyfZRXoJb6tCmtMRghBAViAD5	72
28	In	2016-03-09 08:08:44.78807+08	2016-03-09 08:08:44.78807+08	ZpPYsHsrwSJUHc6NWIAQdb7MmHqUR4Z1tyZmGSeDuyhBbnZ85j	73
23	In	2016-03-09 08:21:20.347626+08	2016-03-09 08:21:20.347626+08	ZjLg67xwcQ1CQuB0hRSNeMLMYw976FqeyCM4KK1vk28BwJBfkd	74
31	In	2016-03-09 08:29:36.219485+08	2016-03-09 08:29:36.219485+08	3P0OlYMufSAW79iTD3nEyXG7iEPtsAXvZXKK6gFl8PIFY1im4V	75
30	In	2016-03-09 08:30:12.965671+08	2016-03-09 08:30:12.965671+08	134HAmVZgPjELJkfdqMsbUJtkruTeyyf23wCoSlVrVjCoUrSLE	76
48	In	2016-03-09 08:31:39.121183+08	2016-03-09 08:31:39.121183+08	LwjerUWmwBlvpnymyoGkK7G3J4XCWsQrpAWhd3UbEGX44Wr3L7	77
29	In	2016-03-09 08:31:55.125098+08	2016-03-09 08:31:55.125098+08	nfF4iY8Gke9BWzL3hy6CaKS8OWfGZ1ONfcROBZfvEo7koSnWRt	78
26	In	2016-03-09 08:37:16.919228+08	2016-03-09 08:37:16.919228+08	i2EAAcgptGpHdVt4u6dZ2rO8cDaQj2KR4YcFCJ45ZtNCQHHKNu	79
41	In	2016-03-09 08:38:09.344533+08	2016-03-09 08:38:09.344533+08	uOmJXPW8pFAAgFiJTucYzBSMNsdeD1Y8PLRwkw5aCFktUTDxOo	80
13	In	2016-03-09 08:42:18.405864+08	2016-03-09 08:42:18.405864+08	VO0ykNqO25PbDowdlhbqIn53hZWuXuj3Jj248sSAxrlBgioSQQ	81
49	In	2016-03-09 08:46:45.819279+08	2016-03-09 08:46:45.819279+08	JiEOlvxJqVEaZXKbaSU3bSuNdc6S5VsOF7m13lKtHYUq5oSgHw	82
45	In	2016-03-09 08:49:11.374376+08	2016-03-09 08:49:11.374376+08	jsPeG3HMVMrOk7VX8ZJSTb0yS6nul5rVxHAELRZqnSFYYk6gKP	83
11	In	2016-03-09 08:49:23.881355+08	2016-03-09 08:49:23.881355+08	9n19mTFZO1eGXcXhps9QjwsyVRjc842Hr3QdWfEtgsAEUhvKa5	84
27	In	2016-03-09 08:54:20.063233+08	2016-03-09 08:54:20.063233+08	kJ3dIY52AD6CUwFublaofHhpVCXRX8WIRZvj70lIDqUhnjcPVD	85
25	In	2016-03-09 08:57:19.024815+08	2016-03-09 08:57:19.024815+08	EBUv118YSfgyx8Xtqftcx8TRpICShhgvsBstC1Sdg8ceGAY7pS	86
47	In	2016-03-09 09:27:19.913748+08	2016-03-09 09:27:19.913748+08	jnZEFPWRrE8YA1j3uu4MYkVBPlLxsCPcyyqEONfHanokoYnjUr	87
31	Out	2016-03-09 12:32:22.383675+08	2016-03-09 12:32:22.383675+08	2PqVIJokZrhh1gSluEtjyIK9Zghb23k4SaZktOWUGDCHtd3orw	89
11	Out	2016-03-09 18:01:07.625127+08	2016-03-09 18:01:07.625127+08	YqGs0pYhRbkBfDmFxgeUBuhNCb1FRsCzkSskIRSi3DuiPhxOOb	90
13	Out	2016-03-09 18:01:12.751326+08	2016-03-09 18:01:12.751326+08	sZWawiCxxdrAdbbWMtxnc01XiQFgodJhDpIAYU8V9yflaHIwBG	91
25	Out	2016-03-09 18:01:25.902944+08	2016-03-09 18:01:25.902944+08	koGlMyDbf2FyjSo2cMWjsfjYRKpjH203pGoDG2ov44unWio86M	92
29	Out	2016-03-09 18:01:27.118232+08	2016-03-09 18:01:27.118232+08	sx2bWTwMDEOEHEU6Rj8GfCKaypJoyPArNCTtfQGtee7vsb2KLA	93
48	Out	2016-03-09 18:01:45.868335+08	2016-03-09 18:01:45.868335+08	a2LtcKkv9jLJaiV4cCUt58YC4Rn6lAFMCbGnv1j5k5OLouPR6t	94
45	Out	2016-03-09 18:01:46.108938+08	2016-03-09 18:01:46.108938+08	LB2tO6LCC7MRTY3kMyl64WCSq0NGRTAmeCg3I1FU8cwbAzMWy8	95
30	Out	2016-03-09 18:02:12.242193+08	2016-03-09 18:02:12.242193+08	d3doVVpslHMv418k4QlKuuvrW6rsdp1Gse6O9uHuCcqHdy2iPn	96
12	Out	2016-03-09 18:02:17.309037+08	2016-03-09 18:02:17.309037+08	2KhxCE537ht8ymm4BvzSrC5iTigUR6ITQ0RbFWfMEYUDLHHWDH	97
27	Out	2016-03-09 18:02:48.83869+08	2016-03-09 18:02:48.83869+08	x5T3mvmUQEaih0i9cxfHKupo8B6PhJffN9jB5VeVjFERFwaruH	98
49	Out	2016-03-09 18:03:24.581094+08	2016-03-09 18:03:24.581094+08	9FBy4JA9hrSNXpWH1bmf7WuLxAIY1DpAS19VKJe2C7Qjww1wYn	99
41	Out	2016-03-09 18:03:32.045939+08	2016-03-09 18:03:32.045939+08	cfKX0JhIriVhswi2S3M75XEVHBSI816kfQIfjzybiTJbR2dt5z	100
28	Out	2016-03-09 18:05:04.015258+08	2016-03-09 18:05:04.015258+08	1BXGgoR97Z9DKoedVOcTzLxJwOLbIQaKb8ZIw1R5ZaIuPwXuKB	101
23	Out	2016-03-09 18:08:21.60687+08	2016-03-09 18:08:21.60687+08	OKWMdUky53PfN1owJlxkqXL9Sk60fQB4khQOCCMHFlwcnlZ7XX	102
17	Out	2016-03-09 18:09:48.744238+08	2016-03-09 18:09:48.744238+08	rO5DXXxdYd4jhoR8CdKZuZLrC9dlGCJ8aOL9vJmUwqEdeflrJ6	103
47	Out	2016-03-09 18:14:50.421847+08	2016-03-09 18:14:50.421847+08	REfm6qvjcCvuKWJffGyRkvIyZweLoxRGC72Ixx2a9xVTUp9A68	104
12	In	2016-03-10 08:08:21.286732+08	2016-03-10 08:08:21.286732+08	cq4updrUygSRwdYyvWwx77vdaQTjaYsCPw7FayiZfB1coZbk6Y	105
48	In	2016-03-10 08:14:53.8154+08	2016-03-10 08:14:53.8154+08	iEfeqG5K0fssrIpyXPxGydR1GGar2gQku6PlMT6M9yF1H40oUx	106
23	In	2016-03-10 08:15:31.732057+08	2016-03-10 08:15:31.732057+08	5TbWUrm4jokAZfHyRdSXzbWEcnJdcmbhHDEk52poqayQGGOhtq	107
45	In	2016-03-10 08:39:17.902291+08	2016-03-10 08:39:17.902291+08	EsTk86YRjBEKsVX7Gc85RyfQPvhncafrU8cbEA3xLHJEmqL3TT	108
41	In	2016-03-10 08:41:43.452194+08	2016-03-10 08:41:43.452194+08	8uSnMrj3fNdKE8Tqjh1mfM4yaqoutIO2EqpZiZcOwGjBOC28t3	109
27	In	2016-03-10 08:47:17.799341+08	2016-03-10 08:47:17.799341+08	vZP0Y0qNvkgKmtBcUuD7JAN2LmFNu9QqipqHphfkTM5GGHskB6	110
13	In	2016-03-10 08:52:30.926099+08	2016-03-10 08:52:30.926099+08	rUGFXb1lxvuOmeDdv3Lbooxt5EBxxN4prK5Ou6As26HpjUTfYo	111
31	In	2016-03-10 08:55:01.836529+08	2016-03-10 08:55:01.836529+08	HNdFHhSSfRpjHg3M5ySGrUL9K6dmlCb3YFIpwlIcD8MToQptOI	112
25	In	2016-03-10 08:55:23.542947+08	2016-03-10 08:55:23.542947+08	AGmWO7c2tOEVRnkjdhVvKh4hCs72nVJxl7UAD6D7URdvEOfr6A	113
49	In	2016-03-10 08:56:16.191523+08	2016-03-10 08:56:16.191523+08	oQrs84lF5YkPWWV1hj7tqaLUWarCSxMHPE9XIumNTXmz5I0l27	114
18	In	2016-03-10 08:57:01.95203+08	2016-03-10 08:57:01.95203+08	gsh2NEcFQ5DmMc1VAIQwgtVStZltMn13gi53whINmVA98BeIT5	115
11	In	2016-03-10 08:57:28.853825+08	2016-03-10 08:57:28.853825+08	FAykcsKOlgCmirVnvTVEqIj1SrC7AgCQqBAT4VspB4cuw8irbE	116
47	In	2016-03-10 09:03:07.179996+08	2016-03-10 09:03:07.179996+08	6SXpUyhg6rNIIETShXxaN9ez4b8mTj2ZCYPgX6NexjwGxQifxf	117
30	In	2016-03-10 09:10:03.817918+08	2016-03-10 09:10:03.817918+08	GKouKtWSgzChZOGy4o5RT3BPJ9p2pnh68X1SQWu7W7o6U55YtA	118
28	In	2016-03-10 09:26:29.396469+08	2016-03-10 09:26:29.396469+08	0NEBmXKcYAQGGZnG2EnwLK4AQZGW8Ag8XtJKRew0oOH4w5LyJ8	119
45	Out	2016-03-10 18:01:07.835067+08	2016-03-10 18:01:07.835067+08	weS1ota5PiF6ql1A6Ro4ScRigPn2O7BLldMaXvfwet3Vg4emVT	120
25	Out	2016-03-10 18:01:10.059256+08	2016-03-10 18:01:10.059256+08	qx6IgnhUp6c0ROdmyBje8NYCsFFX2l1rj7AQurvkxXkPvOCuZv	121
27	Out	2016-03-10 18:01:13.064483+08	2016-03-10 18:01:13.064483+08	YhJ7tCM9jNulGesQ5nI1YGYJfThrOInw074tJQ33nyn4dgUiUm	122
13	Out	2016-03-10 18:01:19.835705+08	2016-03-10 18:01:19.835705+08	i33HMil4aAMO7MVBGobJrPIfSvNwdriNumeHVQM6ZiVg51rLpT	123
18	Out	2016-03-10 18:01:58.583646+08	2016-03-10 18:01:58.583646+08	ehrwNLskHWc1tXmYoIyBPZstGxu8JkbxRTuoonZ6KB7FitnXCm	124
30	Out	2016-03-10 18:02:02.34444+08	2016-03-10 18:02:02.34444+08	ibMcVcaQksBMqdqlSfZ2ltDs9vmwUyjDa6p6iQWTJhpALgvnMV	125
11	Out	2016-03-10 18:02:25.257013+08	2016-03-10 18:02:25.257013+08	o7Q2zYxmVSlFfLLVR4vxYFgOP15LoRrdYHfYpdKM66bmRwHt2D	126
49	Out	2016-03-10 18:02:45.623767+08	2016-03-10 18:02:45.623767+08	raSYyrZ4DOV524MhcCLwYS3AEU7WO9jGjBni3NmGlHLmLhUxtp	127
48	Out	2016-03-10 18:02:49.249402+08	2016-03-10 18:02:49.249402+08	uSIxcWSj2qsl6cxtL1H7H3PbpkJKiDAdeRaHx311ttm0WjurkC	128
31	Out	2016-03-10 18:02:54.355785+08	2016-03-10 18:02:54.355785+08	y2EOd49wOqAYUo056y97y31l3YVwQG9PIOnvSvsqn3PHrQNxOV	129
12	Out	2016-03-10 18:03:18.650026+08	2016-03-10 18:03:18.650026+08	5OY7AbefY5whUF6HBYD4P17oIxFfvdB12j8CLmrurocM3idEGq	130
41	Out	2016-03-10 18:03:51.642928+08	2016-03-10 18:03:51.642928+08	IfrOVANkpJO2KRlSc8GU28JeTMN7adxsJpHo1dZqwxsHPek2m0	131
47	Out	2016-03-10 18:04:29.971105+08	2016-03-10 18:04:29.971105+08	Xo8pTbCqimUhfnXwcYaCPXBIoawZcjZAYg02JDs2zNjfBHbnpC	132
23	Out	2016-03-10 18:05:03.441096+08	2016-03-10 18:05:03.441096+08	0FjBXYlU8OEhXmOXphkijk5TPGk24aE4qxFOW0seO7LvujTjRE	133
28	Out	2016-03-10 18:07:12.429724+08	2016-03-10 18:07:12.429724+08	SByXeOnPQqzeupbAE8A7mYE8U9rxsJDLUCs9agX1XXfSNHcbPm	134
12	In	2016-03-11 08:12:34.201064+08	2016-03-11 08:12:34.201064+08	iCLxKp7Cn0V1L0DE9nugoSETubkYEALwMgufW2rK2NLNNXbWLW	135
23	In	2016-03-11 08:19:10.012559+08	2016-03-11 08:19:10.012559+08	C9yQdu2OSGYnDtT7az9SKBpfXDD9iYfvhfMLZOj2eIpqCKymK8	136
41	In	2016-03-11 08:22:35.568642+08	2016-03-11 08:22:35.568642+08	FeJ4JqHW005gvnLH9ufsxKAnCM8B9RIO6bSPSjvSj19foUwwPd	137
13	In	2016-03-11 08:36:14.65055+08	2016-03-11 08:36:14.65055+08	pNx0B9NIKWjcupENFg6B9pDIV1lSyB5nY3oiDB2WhlAcbOzq56	138
48	In	2016-03-11 08:37:09.385816+08	2016-03-11 08:37:09.385816+08	3FvFWRHJtFUz423rlF3nmlZwNBLN2QT5fPLCrbVlqylu2omn4q	139
31	In	2016-03-11 08:38:00.314793+08	2016-03-11 08:38:00.314793+08	aqbAnzL9NNZqSFGnR8PvtGvfBwTxkYoLPQVDQqLnEudhAuVb3u	140
30	In	2016-03-11 08:39:46.383491+08	2016-03-11 08:39:46.383491+08	YwBTcMR6KCe9X3Z3G0tbn8XRphMKJPFqMQLyml57xjGVmqY3qS	141
25	In	2016-03-11 08:39:56.023258+08	2016-03-11 08:39:56.023258+08	eeaC7QsTkCsz4FPOECBIJ92ZeoQDrHfWvGh3gbVRnORrdqGr3R	142
29	In	2016-03-11 08:42:37.739374+08	2016-03-11 08:42:37.739374+08	AMaCvF1MSsd8PZP7b6i8XWWyOApf2r7CEhOAwPWPIAXgjvnL2W	143
18	In	2016-03-11 08:44:44.469666+08	2016-03-11 08:44:44.469666+08	TZ30YSAN7CGEOUvmesCBHULoB5kyRmVuMZuu15I9HYNf3JShBe	144
27	In	2016-03-11 08:49:47.017686+08	2016-03-11 08:49:47.017686+08	tT9FHKK3JlpofCOa8PfQYwyvb2F4jQidsrsBCDEUy4KeGiFO8u	145
17	In	2016-03-11 08:50:13.212604+08	2016-03-11 08:50:13.212604+08	ngqmcToqXYHGCB84MKHZoGd9ttr9Iz46gutJOiAvHRCScKXyeo	146
26	In	2016-03-11 08:51:26.883888+08	2016-03-11 08:51:26.883888+08	YT4Ccy6U8OUCVA7OTV7dRO6eqiyOhdCG7HTkFZENxiZTsgrMCy	147
49	In	2016-03-11 08:51:42.463487+08	2016-03-11 08:51:42.463487+08	0eM6IDoHbWuom35GmLp2inkHHdx90B81oU77hvPKSK8FNEVAYK	148
47	In	2016-03-11 09:57:54.666476+08	2016-03-11 09:57:54.666476+08	CH8wYPaXYahgaXBhesd4D6OLKlZpv8A9OJ5xifUIFDxqj9YO3C	149
28	In	2016-03-11 10:13:22.117739+08	2016-03-11 10:13:22.117739+08	SGHqbccASZIchhvnefS9wiMvY657U8JxNboyER9g1RJi9FVnuy	150
31	Out	2016-03-11 12:00:26.315334+08	2016-03-11 12:00:26.315334+08	wrgJnGPsNu0hrNIgMW8VD8wWq6lNsgLpY29MIZEgTENLbf2xCA	151
26	Out	2016-03-11 15:04:31.230723+08	2016-03-11 15:04:31.230723+08	TPIQv9WgWPNrFvtPIDxWsSkGnMwpK90nYIEUSkBxAYpPUkomxm	152
12	Out	2016-03-11 18:01:06.553253+08	2016-03-11 18:01:06.553253+08	JqF473Q4skDsZlBnGdYRbi0S8VDvIAia1xe915DtpQmPCxDSbl	153
18	Out	2016-03-11 18:01:15.617209+08	2016-03-11 18:01:15.617209+08	tEUugcPsYh4II5FwEG2RArqwH4uUWWGQkkLRNkKvSOEkTThhkj	154
25	Out	2016-03-11 18:01:18.279081+08	2016-03-11 18:01:18.279081+08	9tb0qs4lNaId13PMUm7ojYDxJhR2PCkY6MYwFcicD2GE5fZZSg	155
49	Out	2016-03-11 18:01:32.63643+08	2016-03-11 18:01:32.63643+08	OCGcAZKbbjmMIsiqqxTZagbrtgXUG0BfCQIM0bxbLkxddgUUew	156
30	Out	2016-03-11 18:02:06.350798+08	2016-03-11 18:02:06.350798+08	4Fdf7YMe3deDJqeaDeCBGYuEBZuf4ac8pGowoBbroG587jiKOu	157
29	Out	2016-03-11 18:02:06.503671+08	2016-03-11 18:02:06.503671+08	VfTQtezoK4PwCFE1C3Dnt23y9AirU7mzmGQguQVFUuCgAQhMTu	158
13	Out	2016-03-11 18:02:15.631252+08	2016-03-11 18:02:15.631252+08	ANwDM6O5xsDlsz2IgwiCCD7PtHpbdJWngT23ZP9XILJALLT2IC	159
48	Out	2016-03-11 18:03:00.74648+08	2016-03-11 18:03:00.74648+08	EVOLuIcktH4Q5jt6mTVv1nIKydfSfydtU2FOKr9E9DeDwXKj1p	160
23	Out	2016-03-11 18:06:53.532476+08	2016-03-11 18:06:53.532476+08	f2exMcb25H1iAUkPt6H3KQFxdCVxwWncYRat5CvATwsdRd3LjK	161
41	Out	2016-03-11 18:08:45.589858+08	2016-03-11 18:08:45.589858+08	O4jd2NpXLm49Pca1WfDTpfQiJrMMC6gaAQECo4jArnJHQtIwZV	162
28	Out	2016-03-11 18:10:33.144677+08	2016-03-11 18:10:33.144677+08	QPBp8UhUrtbYUlyjxmnhwfVGwvAFsjjI9v9HQqmHkNpF9oy7bm	163
27	Out	2016-03-11 18:27:05.701007+08	2016-03-11 18:27:05.701007+08	nYSJoOExd7hOQqJY8jPu2AIrPRgOYIBMqdff2uef2M4SDN1L7Q	164
17	Out	2016-03-11 18:28:54.887335+08	2016-03-11 18:28:54.887335+08	G9aY101gOZyavpDbVFWAvYWy1jN25USLd3td3uKSTJ2QAG2fVY	165
47	Out	2016-03-11 18:40:04.006515+08	2016-03-11 18:40:04.006515+08	pR7MQ86nABHcWufQYjLtBpDEFNTH2yprQwEq5KdFVvr2qYTPHo	166
17	In	2016-03-14 08:11:46.989462+08	2016-03-14 08:11:46.989462+08	JSdWgstAAv90oZw3Q3N4Is0AuqiOG0DZTq6AjyKuvTuj3smTuA	167
13	In	2016-03-14 08:17:58.163837+08	2016-03-14 08:17:58.163837+08	YD3YNyP6Nf6ZEZQKjBK46FX1yasl5nvc1yBOxaULFauUALotW9	168
48	In	2016-03-14 08:27:40.628915+08	2016-03-14 08:27:40.628915+08	wcOUcN6VAAK6nL5yj4ZEOooJJye8sBGpneLQ3QwCbGIObONLSw	169
47	In	2016-03-14 08:32:52.258614+08	2016-03-14 08:32:52.258614+08	ZqlOA5NoCG1S7o8RFArBNTSfs44GOWDxNyMX4jMG1Ni7CpYR1R	170
12	In	2016-03-14 08:33:27.665949+08	2016-03-14 08:33:27.665949+08	cOu54m883XeGV2FrZJbvYcJHjV8Jv9kZWfdaSmiVJOmoP2hyLJ	171
23	In	2016-03-14 08:35:07.450826+08	2016-03-14 08:35:07.450826+08	uuvECfiKyfSjEzOsaqeJMyh9n7CV6Xo1SkEeQxxPdR9rQXk1OP	172
26	In	2016-03-14 08:37:19.051809+08	2016-03-14 08:37:19.051809+08	KkO2uC96gFdVF5GUjgSh559EwZlhaA7uuUvog5vNKYsZe94OoV	173
11	In	2016-03-14 08:47:46.942627+08	2016-03-14 08:47:46.942627+08	6ubF9YotFP4MKyqGnXLjufInFwwJLloRgPgpxVjEunaFmRWayr	174
31	In	2016-03-14 08:49:33.913787+08	2016-03-14 08:49:33.913787+08	KtXchmZe5uQtM7J3wHYgVTU5iHWFrV7CPeo7ROlWJCQfJjiG2G	175
49	In	2016-03-14 08:54:20.967259+08	2016-03-14 08:54:20.967259+08	wXkRcTi9ibepn4UcAu1vRK8r0RbihdyeAj6mDowvQblEeGqpBr	176
25	In	2016-03-14 08:57:32.294901+08	2016-03-14 08:57:32.294901+08	lcDtUDL7v2kuguemhrbem2GYFuo6kzyWcBP8OkEKmyFTttGbkr	177
18	In	2016-03-14 08:57:33.020417+08	2016-03-14 08:57:33.020417+08	GYtW79SvFDvEjYP9gotu9gtOBnIRP3JfbDDiMeebrZpb8Fko4e	178
41	In	2016-03-14 09:03:07.951858+08	2016-03-14 09:03:07.951858+08	jDLdcWRuxqxHWZUjIqOwSHWIrfYcUcHEpcrS9JN7ALOgutQDkp	179
45	In	2016-03-14 09:05:55.284703+08	2016-03-14 09:05:55.284703+08	AD6gVxL4apgr4WUvycGLjQg97a2XnmNxzTeVSzY3pFutlOqj26	180
29	In	2016-03-14 09:26:31.957886+08	2016-03-14 09:26:31.957886+08	5lWludNwBBjY9j2mETmmWc2RXnpNXrUcd1PYelVpwFN6xPtDtg	181
28	In	2016-03-14 10:34:22.742001+08	2016-03-14 10:34:22.742001+08	0QJ2rqphENZi0DjPlNBHD9VaFU19htphK9jCzZtEwTwwgfMS4X	182
41	Out	2016-03-14 14:02:58.384643+08	2016-03-14 14:02:58.384643+08	iHgErvis4Qmt873rJ3QDHNgDJNtfpwDYEsm6oWxtwkn4rqvCtM	183
31	Out	2016-03-14 15:00:38.460235+08	2016-03-14 15:00:38.460235+08	PAj7N4UHjKEvsSpfYeCWY9HLDAC9L6VkGGrdJMu3fAyYcoEBTQ	184
26	Out	2016-03-14 15:15:22.570651+08	2016-03-14 15:15:22.570651+08	h1YyNl9ZuUfRFvg7Z1TU39e2hHqvSKMAMu9igIIbmx33tjATkd	185
18	Out	2016-03-14 18:00:31.56844+08	2016-03-14 18:00:31.56844+08	xnmcqUthQM3mWOgf8NxQzlO3nInxkYbiMOMDsGuJcx59MmoUAn	186
14	In	2016-03-14 18:01:07.652447+08	2016-03-14 18:01:07.652447+08	uAYJDNb1LMYw6uLR8Dh3WK0bTMOIqY6lif5w2gwN3WK9RfaZsH	187
14	Out	2016-03-14 18:01:19.325624+08	2016-03-14 18:01:19.325624+08	bPbc25yQNpyTbh9geBNbYQ8sZZYA8RRjq3Mr8LIWBH0mz9TeKq	188
29	Out	2016-03-14 18:01:26.689293+08	2016-03-14 18:01:26.689293+08	GsHOlqwK06lRpbVCUdXmAi4AU4JxhcoxW6MIwKcwPNPFzuRTYy	189
25	Out	2016-03-14 18:01:47.076519+08	2016-03-14 18:01:47.076519+08	GhhKrCNAA6ny4K6Qb3kEzAcPPbJq6rpMZXfRj4buAPtEjzeL2O	190
45	Out	2016-03-14 18:02:24.257926+08	2016-03-14 18:02:24.257926+08	Z2YCRxokotcfGCDvdw0FrAelNOk2jmQKoyWGxL1mFdSVqeRUbR	191
48	Out	2016-03-14 18:03:01.604868+08	2016-03-14 18:03:01.604868+08	jTaPEyny0XmRrbQNrOitBxXcSOHtstLcMv1auoauMNMDymbqBK	192
49	Out	2016-03-14 18:03:06.618855+08	2016-03-14 18:03:06.618855+08	kLHIxkgGeZ9zCWvD7q2hlO48b3uCt6WeRnxQYegCEpCQM8dTyf	193
12	Out	2016-03-14 18:03:30.986371+08	2016-03-14 18:03:30.986371+08	Ak3FseInqCtNqLCnljSSvhI88eGl7FQIzUWs9oh01bOqwZfiJ8	194
23	Out	2016-03-14 18:04:45.277494+08	2016-03-14 18:04:45.277494+08	BGpTOx8fiFt9Wtd4nmrUns6Bj3lPm5XxLNRjLZP4nKDLErO1eG	195
13	Out	2016-03-14 18:05:14.421847+08	2016-03-14 18:05:14.421847+08	WR9cdsfOJSTqQpErZZQydFJqZWixYNF5oOgSHMqaoLRFAf6jFX	196
47	Out	2016-03-14 18:11:41.012984+08	2016-03-14 18:11:41.012984+08	isl2kLYTK7qYCfws8FFzp4LHJVwPFCwy5i1p5ZJOh9xtpumx93	197
28	Out	2016-03-14 18:17:33.66347+08	2016-03-14 18:17:33.66347+08	wy7IGQnCp3Om2TV3JadbyKlwEaq1Y14V0BnGbbSRfqEhKjkdKO	198
17	Out	2016-03-14 18:18:33.413642+08	2016-03-14 18:18:33.413642+08	GJi2Gwc7yB83g8EVOo7qGmhUU2EFfYdvrMx7JaEIkMLSUYxsO5	199
11	Out	2016-03-14 18:27:43.432264+08	2016-03-14 18:27:43.432264+08	jerQ8MTMb9uF5mb3tud9DOVXq16ntUsc9k4H7WdifZxlMYoGTR	200
12	In	2016-03-15 08:29:51.406623+08	2016-03-15 08:29:51.406623+08	PfpuDgvKUooOSx9VFG3syiSvUnUJ5xkUdaPrHLCmA1BcxK8DaB	201
23	In	2016-03-15 08:32:40.878887+08	2016-03-15 08:32:40.878887+08	6YtYVONzhRxSvb3KTLff8pfISecarDkxleWG3sGkKEDGqGaKbG	202
17	In	2016-03-15 08:33:09.102709+08	2016-03-15 08:33:09.102709+08	zi6f2YKe8Bqt9cYfsbYANsOZ9FqjZR0YB6EDeYqmjhgsKFYEq7	203
30	In	2016-03-15 08:33:55.797125+08	2016-03-15 08:33:55.797125+08	NEzln91esa6s9HzNUevLRf48ZON7cEE0SElHNnvGN29WK9unnq	204
13	In	2016-03-15 08:34:39.162213+08	2016-03-15 08:34:39.162213+08	AFWDM6bjDEyRERf0i3neJBgSh1bcoOTyd0C06nkJ2ilGBRGtU4	205
26	In	2016-03-15 08:34:45.345139+08	2016-03-15 08:34:45.345139+08	XmFEFwFpZ4E33r3Fr93cS4LEKWfaP9dxvsCBpR1QWGSY7Vnyeq	206
11	In	2016-03-15 08:35:54.207922+08	2016-03-15 08:35:54.207922+08	b8uwMFT2osBTq7M3ICUJc1Z5ZgbNgGEIO9FkNhlDawfR42UMEy	207
45	In	2016-03-15 08:43:38.779372+08	2016-03-15 08:43:38.779372+08	gqzGvZwXwdnAuCJAwgritTfZukbP7qNnhN4dw0Bsdy4YBNj84b	208
48	In	2016-03-15 08:45:45.934358+08	2016-03-15 08:45:45.934358+08	qx5WXzH9OOzmCgAFK6GVztU3SfQCmUndSsAzrR9Ho931pDGAJW	209
49	In	2016-03-15 08:45:54.354628+08	2016-03-15 08:45:54.354628+08	fJQAMspm5dHsHjlRidrrug1xhqBy1UVgnurAohvtLDmcwY3fCu	210
25	In	2016-03-15 08:55:22.442989+08	2016-03-15 08:55:22.442989+08	X7cY6KPHJQln8ZjziXheR3rEfomiUyd27GbCa1TtRFiZoRZXzH	211
28	In	2016-03-15 08:58:21.552821+08	2016-03-15 08:58:21.552821+08	CRK5fytShORMQYc2lE3F8UUq4JIcqHt3iD8OD2quQJHqrtsc8v	212
18	In	2016-03-15 08:58:21.788711+08	2016-03-15 08:58:21.788711+08	rGPM6TfO6WgyZPDinQkeLBxc2pWuSepKuFh2iNQot7nTW1CKRv	213
47	In	2016-03-15 08:59:47.454525+08	2016-03-15 08:59:47.454525+08	yl7wO8mu3FasZV8HXqexfX5T2aUEuvAuhHr6Pe2SsbLS7UjeLO	214
27	In	2016-03-15 09:00:06.081569+08	2016-03-15 09:00:06.081569+08	c1vgUxHzBDuL8ccyj2dkVXNqzULj9g8kh4RC2jCDv7Z4kC3TEh	215
31	In	2016-03-15 09:16:11.397366+08	2016-03-15 09:16:11.397366+08	FjEbaE6uxFb6zJARVCBhP7oxBZAF3OvI8AthOzdMEFSEYcf4np	216
14	In	2016-03-15 10:22:39.32245+08	2016-03-15 10:22:39.32245+08	lDwaB99LNCjJUrTNZrNDEbSgp0JV47LpKJQVRZrolb8GTbd3U1	217
41	In	2016-03-15 12:20:02.74709+08	2016-03-15 12:20:02.74709+08	FidhPTiiymqKcBd3g5cYtOA2dceIf8JurwdHPL0O8qik2MniRQ	218
14	Out	2016-03-15 18:00:10.238044+08	2016-03-15 18:00:10.238044+08	HLnRNS42kjB4e20IJQdJolAXXCtLuLkCfZc42g6lQGp5IpNbG1	219
18	Out	2016-03-15 18:00:28.246801+08	2016-03-15 18:00:28.246801+08	v5m6cKIVfDqQPWz2a1jgnAwcFGScridnnQtQkCvQPmqoKprura	220
26	Out	2016-03-15 18:00:39.566658+08	2016-03-15 18:00:39.566658+08	aekYI0nkcfTGTHgNhRZdryQinkYfePGG51oM1c7eIaulsbAa4j	221
11	Out	2016-03-15 18:00:50.558513+08	2016-03-15 18:00:50.558513+08	EviedWPCC4cSKgT93UlB94l4pefzFijSeR7IxWVAa7cvo65rap	222
13	Out	2016-03-15 18:01:23.769035+08	2016-03-15 18:01:23.769035+08	3jtonkSSkhCUApvI9tod5PlhLZmPROGU8AJuulOfTZ9dQ5vYzk	223
25	Out	2016-03-15 18:01:31.284877+08	2016-03-15 18:01:31.284877+08	D4AxlUYZtzwAU5Km0FYOu3x4gOAcwAMAEW801gZvgW6BbQxbfW	224
48	Out	2016-03-15 18:02:17.533463+08	2016-03-15 18:02:17.533463+08	0aZyeGNosKyFUDlcDmJlizIoAtF8VtfWUFV9UrxNCwcg9OJMCd	225
49	Out	2016-03-15 18:02:21.973899+08	2016-03-15 18:02:21.973899+08	9udRjnLxvqsbNNqrWLkUiwRLdbkwxwa7qEXa2sYxjRZ7oQzLlk	226
45	Out	2016-03-15 18:02:27.922423+08	2016-03-15 18:02:27.922423+08	pVgHqKsbIqXsxP7Vz8OY78zgGn7G9t0yOgGF2AqJ1OCxnJTmRr	227
27	Out	2016-03-15 18:03:07.622815+08	2016-03-15 18:03:07.622815+08	LY1LFG9MWIGWHfDXuFhlZiAlgw5AjW2553QKJZgprwM9cZgXpO	228
30	Out	2016-03-15 18:03:29.915366+08	2016-03-15 18:03:29.915366+08	IO7SAnPFxAlzFq2fBLFrB7oXGR7wywLHLSjVGAkDKWDZOFFYbU	229
28	Out	2016-03-15 18:04:16.949017+08	2016-03-15 18:04:16.949017+08	RmbGKrhRogNAxiciEsry6CWJltZ1TBVuw7BHyshmZ6wYoZH3S9	230
41	Out	2016-03-15 18:06:39.423104+08	2016-03-15 18:06:39.423104+08	2YLYr7TR8wcdqZk2qiuYWUeT3S3JVVSY4n7vuaO3X1fOaQQQ9L	231
47	Out	2016-03-15 18:07:04.913142+08	2016-03-15 18:07:04.913142+08	zfpd9s7CDchfBlTJiOt6RR78pgXH8hc8NSlWMsiYVQEgChzt7t	232
23	Out	2016-03-15 18:09:52.849111+08	2016-03-15 18:09:52.849111+08	1YK7fAoERwv44IWposiXREwfv9Nv4Uo43ACiK1wlxrp2BMsyFb	233
12	Out	2016-03-15 18:13:28.967216+08	2016-03-15 18:13:28.967216+08	WfpTLldihgDWlGgwy1xvmvncxyypxDRUtHxF3bxkIBH4Rw1Pxy	234
17	Out	2016-03-15 18:15:21.933326+08	2016-03-15 18:15:21.933326+08	Lku9Mr7Li5YAZRRXgU9eFRpWVGTVgRU1CPAYHHtzMR9vtaUa5d	235
23	In	2016-03-16 08:29:42.377445+08	2016-03-16 08:29:42.377445+08	FK55qZLL61ma3yyDXGURGqsPnm0IN5ubPzgHZ2bf3OF6NFJuVn	236
49	In	2016-03-16 08:29:49.812563+08	2016-03-16 08:29:49.812563+08	MleFBS1BkOGf1gfhwFjYumxAsLPCFuzbgepr7r4rGKXH1DxxSh	237
13	In	2016-03-16 08:30:43.779505+08	2016-03-16 08:30:43.779505+08	XMUUWNpvZ5qZgXEXPMPTEfnlvoyumQcKn7pKUeG4k7dResx4FN	238
17	In	2016-03-16 08:31:11.57996+08	2016-03-16 08:31:11.57996+08	XT2MEyBDsxdVIRc8l6m1BX8oylhwqvKOPMjdLuqEsVjCwLKhS7	239
12	In	2016-03-16 08:33:13.823473+08	2016-03-16 08:33:13.823473+08	jcerRdd9ZU5trUGc9bX0oQVYcStwAM4tyikQMOZvsfpkA6NJgu	240
28	In	2016-03-16 08:35:26.89744+08	2016-03-16 08:35:26.89744+08	JWMo5yHyvRM0LLi6l5VM0N2p9CvWVdRo9ndEmuEiMZihuSnhWI	241
26	In	2016-03-16 08:38:32.320586+08	2016-03-16 08:38:32.320586+08	3Xg5NpHJMlwna6cEKP9Y8V8rC4J0kpJoNztkoA4Bw1zX7blR1u	242
30	In	2016-03-16 08:40:12.553996+08	2016-03-16 08:40:12.553996+08	0AQ81cCLdwBvlYveJkoNwlNvJUY6vZ1viR4k4G5hDGdyoZd8LT	243
27	In	2016-03-16 08:44:02.022982+08	2016-03-16 08:44:02.022982+08	VHFsEYNleJLfF47JoBZtsnAXmy7Q7Stbj9UxhrjMB42P89iwKJ	244
45	In	2016-03-16 08:45:11.997272+08	2016-03-16 08:45:11.997272+08	qE60lsysJ6LDh5LD235lQFpSfybOvvglAnmvglnzr9CaEYmGbr	245
48	In	2016-03-16 08:45:40.583839+08	2016-03-16 08:45:40.583839+08	327sTmr5An1rZBeM7L8uL14XaI6OZhGbjNUD9MIJAJBjVp6bBE	246
25	In	2016-03-16 08:53:13.981247+08	2016-03-16 08:53:13.981247+08	WWEa4psAESrT4aqYozu7J4QUnvLtXW743Me7CYHP19s5jjcYjX	247
31	In	2016-03-16 08:58:55.471389+08	2016-03-16 08:58:55.471389+08	f3c6XQ2sJZPRdSnIZyqqPqzIvj2YIk7wni3L94DTdctH5hZehP	248
29	In	2016-03-16 08:59:22.356928+08	2016-03-16 08:59:22.356928+08	V6HVOCFPlWArTxbWJkbWDF98VEp5sWUOclt1x9QjgbbAZDhrwI	249
18	In	2016-03-16 09:00:05.085766+08	2016-03-16 09:00:05.085766+08	OBXXI4l89ffd4IPyJN8k6oMhyuugnryC3XkLaWUjC9NGSlEl9M	250
47	In	2016-03-16 09:00:06.254507+08	2016-03-16 09:00:06.254507+08	WGBrxAnsqakqnnNXAy4diGn6WFrk117XHJPFTD8KnsBbhY9qWE	251
14	In	2016-03-16 09:00:06.304911+08	2016-03-16 09:00:06.304911+08	VFUJL1YDlZEt7UCXjfkr0YkBASiJJGXoV28q3g3pHHiOluvVbg	252
11	In	2016-03-16 09:36:08.433434+08	2016-03-16 09:36:08.433434+08	NbF8lOaViulGjHIr7MZABqRtFDpBiQr726FnUqJDk5TULmNS8w	253
28	Out	2016-03-16 18:00:11.348497+08	2016-03-16 18:00:11.348497+08	cJm4D2H3D1U47WANKfDdsxiNT49qWHm9bZDobVroVMtdr40CjD	254
14	Out	2016-03-16 18:00:28.314771+08	2016-03-16 18:00:28.314771+08	pcCYzfb9V8QII2sVqU1iJW5D9wHAA1NzdZYdEAmkIE3aGv67Q6	255
18	Out	2016-03-16 18:00:50.167063+08	2016-03-16 18:00:50.167063+08	pjcuwmsDv2EJ2ssaW7kJr3XudnqjtGpk0TfwFYABaOVcHODmVy	256
13	Out	2016-03-16 18:01:08.177691+08	2016-03-16 18:01:08.177691+08	7N2dIfR9QLPG6PilMyKVAuufXB4lyZj5wljFSBOrWn8cDrPYpi	257
29	Out	2016-03-16 18:01:12.497318+08	2016-03-16 18:01:12.497318+08	51dyfBBjwAJgFGTyVvAtnghvJuniTdRYe5XKGi5DrOu8eO6AJG	258
45	Out	2016-03-16 18:01:12.815341+08	2016-03-16 18:01:12.815341+08	57wm3HhqzBURi9WGUmyY1rwuybJ6lcMqjJdmaKdaV91EIXVlLU	259
25	Out	2016-03-16 18:01:19.991618+08	2016-03-16 18:01:19.991618+08	KLMHHLsaReDnVw79jhTNIxWJCorhaCCvYXDos6PKkc8GZFPJxr	260
48	Out	2016-03-16 18:01:20.214023+08	2016-03-16 18:01:20.214023+08	hFqEZ33QkdcvYBUl0NrQhc3psc6Iw3AdJ1rr4uJoXvk77Fs7bk	261
27	Out	2016-03-16 18:01:21.363691+08	2016-03-16 18:01:21.363691+08	XKNaAGDFZ9JjnbkfUoanc8jNFqc7xErVYF6iWJx5SHoGsZvNOW	262
31	Out	2016-03-16 18:01:22.613237+08	2016-03-16 18:01:22.613237+08	B1etOsk11iFsEn8JWecUj5lYLe8H2WnCXS7wLqxMZDFn2N7Y2k	263
23	Out	2016-03-16 18:01:52.158886+08	2016-03-16 18:01:52.158886+08	2lpnKBSSTTzHgXjmU5eRQEff2g3AF4tHpj5AuXcO1cfhAOVdT9	264
11	Out	2016-03-16 18:01:53.315769+08	2016-03-16 18:01:53.315769+08	6uOkaQScZhhTyWD4g9bKXdwCL6bpk5zpyNbZn4CNktrkQ5o7DQ	265
49	Out	2016-03-16 18:02:07.769811+08	2016-03-16 18:02:07.769811+08	Rk4OwOUYFEcE5bcgBQjNnVHeFhj4oxUGiYefw9ECNqQST38eTs	266
30	Out	2016-03-16 18:02:36.339319+08	2016-03-16 18:02:36.339319+08	2HNJvc0ggodB6Mjj2gsGsG7JiaMrEpjG77Z3kZjRONcUjMFm48	267
12	Out	2016-03-16 18:05:29.121666+08	2016-03-16 18:05:29.121666+08	3wOAG7kcyzSiGZppcaPL2nifIT2XG6fJ23TIBEu9ENrUwiJYJi	268
26	Out	2016-03-16 18:05:48.65759+08	2016-03-16 18:05:48.65759+08	uLXd1p73NN92fB69TGNOQbkI6h0PHJ9BefofVvisJrvy219VIW	269
47	Out	2016-03-16 18:09:14.474942+08	2016-03-16 18:09:14.474942+08	th8e0EM0edJnoyTeeyaMrtEntGo2l7YfphKpvgpaKAN98qnmqO	270
17	Out	2016-03-16 18:10:04.157684+08	2016-03-16 18:10:04.157684+08	9iINWCeMEQTm6IUQ8Q8y1S8OcHGQ36oDo7aLJFhXfAKlToCbFK	271
17	In	2016-03-17 07:54:45.502067+08	2016-03-17 07:54:45.502067+08	aGmiePzuo31dGpkqB46sbl3vXWkk915jHrSvHRq6UrjkhUbsZi	272
23	In	2016-03-17 08:02:43.727526+08	2016-03-17 08:02:43.727526+08	lAUp72MrmVsrEAjg618v8cnrNVMzOvhB6C0DFN52sxt78enDfv	273
41	In	2016-03-17 08:15:33.328362+08	2016-03-17 08:15:33.328362+08	9nZxfwT2wrxe34q4H6QN8JL3QSgEfNApAjmpgGrc9pHCt9FBFg	274
30	In	2016-03-17 08:16:08.796353+08	2016-03-17 08:16:08.796353+08	YNysQPM7e2UoreYeUEuMr4B9G5IVGXCouBiLa4SF6w4wbbb6qX	275
49	In	2016-03-17 08:17:38.629033+08	2016-03-17 08:17:38.629033+08	SibdrqiAMzhYodjXyKbRZgOde0GG67nYoOCgGuqcuYBjCtGBFr	276
48	In	2016-03-17 08:22:18.413523+08	2016-03-17 08:22:18.413523+08	coY2SD2iT8pHgegsLwnCYikjSwei8sZki9lBMntpwj8dNoWikK	277
31	In	2016-03-17 08:23:09.646281+08	2016-03-17 08:23:09.646281+08	uK3f4VchEkbnVJwHUJ5O928HfV5CEqX9AaoE6RvJCX7gr4xMN4	278
13	In	2016-03-17 08:30:40.162144+08	2016-03-17 08:30:40.162144+08	kW6snlPsxdjVmt6b8C34WFcdvThtp5xbb4UOptHoX1KJuQu3dx	279
14	In	2016-03-17 08:36:16.97132+08	2016-03-17 08:36:16.97132+08	79Djn9DV34a1fC5Aau4rjas4umUpp8nwH0g59taCwADcMImwEp	280
45	In	2016-03-17 08:38:49.910028+08	2016-03-17 08:38:49.910028+08	oxRh2LUWBKeyHvyw18qaKolXQ8pD533t1Ua3p5Y1PDyg9xdA6V	281
11	In	2016-03-17 08:44:27.808084+08	2016-03-17 08:44:27.808084+08	kPJWwkdmxip1cqVDtLITMhgLOoJ2yPXjpqFmbtZYcPZFG5SBQk	282
26	In	2016-03-17 08:48:53.971595+08	2016-03-17 08:48:53.971595+08	dmSK8q9St8rRrgI7Tt12SdR3ri8KsZ5WMXqUOzwI8njzV26yu7	283
25	In	2016-03-17 08:55:11.582442+08	2016-03-17 08:55:11.582442+08	1OkSRcBZx583bUaSyySvHaj1ZF2gDxnEMYhmBsM9xUBYyl1xkT	284
27	In	2016-03-17 08:58:02.690499+08	2016-03-17 08:58:02.690499+08	t24d3dr5K538KPf2CquY0r3BQ2wS1hvtjyXmcPrwVu5pKkqWbl	285
47	In	2016-03-17 09:05:16.946346+08	2016-03-17 09:05:16.946346+08	5bd8n4BkWCSR6DRdz43r1Ym6O7qFeS1j5drrh3dEF6fLI7yIB3	286
12	In	2016-03-17 10:10:56.814548+08	2016-03-17 10:10:56.814548+08	ADbwJz59FibFSgtLZbOCpdIVyadxso132b0Kb5Uqn66GmzbMbz	287
14	Out	2016-03-17 18:00:24.938962+08	2016-03-17 18:00:24.938962+08	YRdqwbRaZKPaORCOlnTGeHMlY9kAVMA4nmukPMLygkY5BlTwZw	288
13	Out	2016-03-17 18:01:04.68181+08	2016-03-17 18:01:04.68181+08	DEFZznikxE77HuuCfJY1IFlrKwcntCk7QyfQmOBkcJrtEl6t6e	289
12	Out	2016-03-17 18:01:06.227494+08	2016-03-17 18:01:06.227494+08	uOtgFEds2X5meVlKvYi7ILQAFewMY21TQuAg9nYBLdwy9iJ4H2	290
25	Out	2016-03-17 18:01:14.691661+08	2016-03-17 18:01:14.691661+08	BaNbkcGhynjzHAuRq4FPFa3CZBusFCuRmI3XuJFt7ytO9oqzs6	291
49	Out	2016-03-17 18:01:17.381683+08	2016-03-17 18:01:17.381683+08	O8gRJGcF8rR3JELMlGf0Amy4C7s27l9VtowD5ZRDSsHl7c9sso	292
11	Out	2016-03-17 18:01:30.034393+08	2016-03-17 18:01:30.034393+08	s3bq8my1p6mxbfnYss9L6aENNLyVDrK6vvw3iv4Y1qXcWLCPDK	293
26	Out	2016-03-17 18:01:32.569852+08	2016-03-17 18:01:32.569852+08	kJvygIKfnXY8dT4aWnWaMXRsBxEMNRh7lc6SuQ8jwgraAvCgjh	294
41	Out	2016-03-17 18:01:32.881601+08	2016-03-17 18:01:32.881601+08	H5GiyRfDn3eVAQ8Gr4g0mdgeFqaQXK9oPPXOpDbeHGARgIhYLO	295
48	Out	2016-03-17 18:01:44.431572+08	2016-03-17 18:01:44.431572+08	Z93GnI7OieirT8H1W7E8lVPuw5DeeY4Dh7TVOat7EcyhkGiHNx	296
27	Out	2016-03-17 18:01:44.998679+08	2016-03-17 18:01:44.998679+08	Q8To4QuH5Yp9lXGF3epvm4YlmJ2VaOT1XvpbMkrRJha6FqLIVB	297
45	Out	2016-03-17 18:02:08.989686+08	2016-03-17 18:02:08.989686+08	EIGm3265XgT1h1wYcJJUkcCLiRC4jhFxzVk3Xq85Xb6Gc3nFM7	298
17	Out	2016-03-17 18:02:17.290473+08	2016-03-17 18:02:17.290473+08	j7jvTSOfW8Nm6NHrPoiXtGA0Wm3K2PRlWChze6eBE2xKPFCo5u	299
30	Out	2016-03-17 18:02:21.736939+08	2016-03-17 18:02:21.736939+08	NyBWyhJ23LRU7xgpxLvdW9fUU5kgtpaHomnnU7qXTI2aHiQF5L	300
23	Out	2016-03-17 18:03:10.269585+08	2016-03-17 18:03:10.269585+08	rbVX6ycqfWgGnV3bJXiA6CS8mjqDxvYqX4Od31UiXByLf2wyaf	301
47	Out	2016-03-17 18:11:00.579275+08	2016-03-17 18:11:00.579275+08	9fsbnfKfsJbR98VXlYYGH6RGR7IO6s5FYwqNcB2VTdwdlSBX1j	302
17	In	2016-03-18 07:55:48.012607+08	2016-03-18 07:55:48.012607+08	oIpGYINqgTjliJjZfMjhrELoq7H2fIlTabj8t7zaajMJ36siSc	303
41	In	2016-03-18 07:58:12.276298+08	2016-03-18 07:58:12.276298+08	QKql8htPjYhV3I7mQ1tQbVAyoD5hvWKMqA9yr2Pba77dPDQpEK	304
12	In	2016-03-18 07:58:13.925684+08	2016-03-18 07:58:13.925684+08	GqpQpedtLZRfvIp4Hh7gJhnQLDdl3s7IiwiYaMSvvtbqCRvTA2	305
23	In	2016-03-18 07:58:55.570176+08	2016-03-18 07:58:55.570176+08	ATjxt6AXrDPyV9uFhVbASW44OFVKieMs87q2C1Y4Ey3j8xyoTa	306
48	In	2016-03-18 08:03:04.738518+08	2016-03-18 08:03:04.738518+08	yv73yVJUp29CuHJlJVmrZ1qclyakn4LmySpyx9SnBcz5tJqCod	307
11	In	2016-03-18 08:29:01.815908+08	2016-03-18 08:29:01.815908+08	5Oeu1QtbBheVUexKcvT6jdhjjb2anqEsFtnFKhqUPV1tAyEnuh	308
13	In	2016-03-18 08:29:13.322317+08	2016-03-18 08:29:13.322317+08	teMbN6DQg1GutVoik9Qbdq7ekHcy5XhyC3aZ9nzpoGkjlZRWis	309
27	In	2016-03-18 08:43:29.208813+08	2016-03-18 08:43:29.208813+08	8MiG1TXdScBAbNDBwMyvCnDwWyWyVFqebatb4RFW5QffnsrjFq	310
31	In	2016-03-18 08:52:47.370684+08	2016-03-18 08:52:47.370684+08	gRdsOBruANA12lbvNeOcBS3r9qk0a0qHRUApf2kpQuqSgSO47m	311
47	In	2016-03-18 08:55:38.313968+08	2016-03-18 08:55:38.313968+08	gIFjANatNBuESMicCOfxE5r5XYXvcdiJvx36Ld1iouxHHgtU5Z	312
49	In	2016-03-18 08:58:06.000613+08	2016-03-18 08:58:06.000613+08	RJeKOCsv8VZqnWoqcAUcsJXqapWUKb3lvh6KtyF3TotILi9wrd	313
45	In	2016-03-18 09:01:17.877661+08	2016-03-18 09:01:17.877661+08	Zkw7bXw81Hk53fm9zh8Fkb4dtPM2MEfvyc3aA1jBITGLA3UAkb	314
29	In	2016-03-18 09:04:13.250613+08	2016-03-18 09:04:13.250613+08	PVDT97rVAEjpAjSDKbE3nVX4qh7LqrwGNAjWHb3RpmHzVjDpLR	315
41	Out	2016-03-18 13:01:12.090359+08	2016-03-18 13:01:12.090359+08	t8xQCo8JAyB7FZHy6Ya90QuHQR0dHL5AU3bgrjz1iB8xkPwqxX	316
26	In	2016-03-18 13:12:31.536511+08	2016-03-18 13:12:31.536511+08	yxyuFPMG3db9n6CPm49m5rxDpicmZaLYYKTnip4lSfuGl7fYAo	317
31	Out	2016-03-18 18:00:21.351515+08	2016-03-18 18:00:21.351515+08	KFfISV14Jaee9Dxc1hR5TukOBVVq4feOuKgNqhS9I7nRKl4LTV	318
45	Out	2016-03-18 18:01:04.354215+08	2016-03-18 18:01:04.354215+08	PwQALbfqSjW78RRpoIXHRpOFHh2L3UqSRHdmsJcK39RCat1QCZ	319
27	Out	2016-03-18 18:01:04.879793+08	2016-03-18 18:01:04.879793+08	gdP5sgnu2qPsJqBwd3GGOJPpU1jWQv68ZVDSC0NEqm7AdI7HMM	320
17	Out	2016-03-18 18:01:15.004679+08	2016-03-18 18:01:15.004679+08	XjfxaBxKgPFmWoIjHUkdiaQpl48rLUEtEtqo5p9lFOZlDqVTLG	321
26	Out	2016-03-18 18:01:16.728555+08	2016-03-18 18:01:16.728555+08	84qYtcc2UyVirkdjZiZhUn63ZJu5mGLuJCTDo6FJ5k2xVfg4OG	322
49	Out	2016-03-18 18:01:26.298157+08	2016-03-18 18:01:26.298157+08	mr4sveBqjx65sQIMd7TrQYdTW99DDWTyOXrKC3Bv1H2uhKHLRk	323
48	Out	2016-03-18 18:01:27.861004+08	2016-03-18 18:01:27.861004+08	DrIqKoyT2C0VCP34jG7uC8CE3tXKFy5SqNJCCIfEVfjg4mkn3r	324
13	Out	2016-03-18 18:01:30.266776+08	2016-03-18 18:01:30.266776+08	iF0vT3p1N50SXqpq32AhGeNzLRm6Fpxx5xtX1jYOoYqMPfEShN	325
29	Out	2016-03-18 18:01:56.249297+08	2016-03-18 18:01:56.249297+08	Ax2XxOykUEZSDeP7CQqkpfJf2iMGB4dL2gsy4sjY7J0KxQRAqH	326
47	Out	2016-03-18 18:02:03.919263+08	2016-03-18 18:02:03.919263+08	ugwFMzxiG9mtVoZOndHXCOqDiod9yURuBO9XO7GdH3Xlr7AfkR	327
23	Out	2016-03-18 18:02:12.069032+08	2016-03-18 18:02:12.069032+08	Dxp4AXsnhrI9mTXw2u4IYKL66DDHsyi5wY9762unuDvhgTdiOh	328
11	Out	2016-03-18 18:03:55.741329+08	2016-03-18 18:03:55.741329+08	1x2M49ZHQSG8YDghKmjFZeSWMAy0sOhtLkGPsqhJJxRrB8ZVuJ	329
12	Out	2016-03-18 18:05:26.719028+08	2016-03-18 18:05:26.719028+08	kVwD1JN0JFO19jlQ9fHqyaoQRzY1UTKFyHS0ap0t5OvE9heIMv	330
17	In	2016-03-21 08:20:00.377247+08	2016-03-21 08:20:00.377247+08	9LVwlxwKxRoIgnZ9nAyn54D0ILhxd5smPPjBMgWL8Ldo8DyvNx	331
23	In	2016-03-21 08:21:18.184735+08	2016-03-21 08:21:18.184735+08	jS2wSKIAIvFBieaSqw9MIIhv7p95lW3Vx4SQOkaghprQUSsLP3	332
12	In	2016-03-21 08:21:25.295973+08	2016-03-21 08:21:25.295973+08	hhKPdRFmW1JZWIeyi3jJjQ9bqd4jyTmgB76pYKc5LvfrEJpwMZ	333
48	In	2016-03-21 08:28:45.48815+08	2016-03-21 08:28:45.48815+08	G60Qhq4lb3ENjQUpF3Ar9VonM27CyTlGZlfHdk3EnHcXh7MwAW	334
18	In	2016-03-21 08:31:22.421313+08	2016-03-21 08:31:22.421313+08	pJ2d7OgFafiMvI9bamMd1Auchcj4auaPEc4L1jabPJyLb7xCtK	335
45	In	2016-03-21 08:33:34.825433+08	2016-03-21 08:33:34.825433+08	puUkXBNHFxCpNQSRlTBM5bf3wHBuT5FIzj3XuQoAO1zlRSDEvO	336
31	In	2016-03-21 08:34:40.657143+08	2016-03-21 08:34:40.657143+08	Z0yF4vWFqzJ6IJpLpkleuAguu8M8LIWvIVBMShbJhuPzEFK506	337
13	In	2016-03-21 08:36:58.891765+08	2016-03-21 08:36:58.891765+08	juGQoBXCJtUpomM09nhk8PfXOtmjynpih68WHgibZCRPynP9b7	338
49	In	2016-03-21 08:37:26.811842+08	2016-03-21 08:37:26.811842+08	tjWZHuU5eSrUBZaK6r1oTa2uz1iPAKW443dLx7QcaI7lrh6xZ7	339
14	In	2016-03-21 08:40:58.688181+08	2016-03-21 08:40:58.688181+08	n3hoxhpf600c44fgPdopGO7NBy5HweOkh5ZfmPLsPLVTPBApoy	340
25	In	2016-03-21 08:41:37.851606+08	2016-03-21 08:41:37.851606+08	e5NlSYkXphDDSuJ2Z6RvyqHUKgfVWUUBZrw2QhZGQmTshluHrN	341
11	In	2016-03-21 08:45:40.85635+08	2016-03-21 08:45:40.85635+08	DqEULYB14hVYs5Pp7pYh6yUZrCLmTDAf4OAPwLQ13wYv2yl9oK	342
47	In	2016-03-21 08:53:15.071893+08	2016-03-21 08:53:15.071893+08	quILUAXpw137g7UqWRCwSFt1Au0v5oGvjYHEio4fo6mVDHMjiY	343
28	In	2016-03-21 09:47:50.892338+08	2016-03-21 09:47:50.892338+08	gBnaDxVDua2BWmjn1Sc48RBuwOCJ8vro7fPKdvXXWZi3MRqMtS	344
30	In	2016-03-21 09:53:43.366085+08	2016-03-21 09:53:43.366085+08	Q2tbwqzAA852wChMWLI3socbqy3hLwBlz5NwvN66UB8RNpntB6	345
31	Out	2016-03-21 12:05:47.714627+08	2016-03-21 12:05:47.714627+08	x3uaelZhTueegej4bfRhlvttOHjCBuI9xDjcyJKTEy8udqyEWQ	346
27	In	2016-03-21 12:53:20.012747+08	2016-03-21 12:53:20.012747+08	vHNpBk7vxIpGRnTBQSUkvhj3cNubbR3XiPNuBUp8mfOEUrPuKt	347
14	Out	2016-03-21 18:00:18.77605+08	2016-03-21 18:00:18.77605+08	fGbQKEmEqOfswOIKITo9bbo0pJrFED9tTkKmy72pWhiT52nOVc	348
27	Out	2016-03-21 18:00:41.124066+08	2016-03-21 18:00:41.124066+08	W7EL74eyJsCSmfE7SDEU3kBlDHn1fJdCQrXXvDXF5jirOvyq9D	349
47	Out	2016-03-21 18:00:41.855236+08	2016-03-21 18:00:41.855236+08	LCxWyCnmDT6qfWhD4dQasVKbOiXNagbvsZSrlGexjkoPHWcLA3	350
45	Out	2016-03-21 18:01:14.783806+08	2016-03-21 18:01:14.783806+08	v3YGewyCKZsvVlVxdGEJEx43NKZ0fj3bmcrRZqduRWpvILtvb8	351
18	Out	2016-03-21 18:01:23.743311+08	2016-03-21 18:01:23.743311+08	Fq7ItUdTUJDXu1AmSjd6e5bU1tpvpR44IBNCe0f9JtgEur1Mbe	352
30	Out	2016-03-21 18:01:47.703159+08	2016-03-21 18:01:47.703159+08	SGj4kkxagn3krLuFXaFDjY7Qm2HmOsRq9ButwsVdfXNXsJmQt2	353
25	Out	2016-03-21 18:01:49.434722+08	2016-03-21 18:01:49.434722+08	ecal3MmLABEb2NnwIjomNVLk3E4pfxqJaR5enryx4EZ6bM3t7r	354
48	Out	2016-03-21 18:01:54.293603+08	2016-03-21 18:01:54.293603+08	gUN2FQGJFvH6FsXKXLDWJHksNMFQGMIwpfy56FPLBgRQZzl7Ly	355
12	Out	2016-03-21 18:01:54.865378+08	2016-03-21 18:01:54.865378+08	deFNXcjm3z9Kvy0u56ATRLBslksXqEVUslrQObDRbMlXLlSQrc	356
49	Out	2016-03-21 18:02:08.066764+08	2016-03-21 18:02:08.066764+08	tJx4Cjo4GfImABY3avenNGA9nVuGunso6qtIaiMrOedZpCbQ8G	357
17	Out	2016-03-21 18:02:43.915758+08	2016-03-21 18:02:43.915758+08	EVWOeKtaaoNTdUKXmuF9mdoQDeco5k5JHahvubWVQty4OJaAEq	358
23	Out	2016-03-21 18:03:10.753245+08	2016-03-21 18:03:10.753245+08	K1U8Shm5WrpbB7Ct37VZcvTazrta29RMAvUccIh9AXkLewFh4k	359
13	Out	2016-03-21 18:03:23.840138+08	2016-03-21 18:03:23.840138+08	HffkHfbBGdKg0UcV7FmoPwM9I16XhAHyqxj7cLJszdZz8CUFSH	360
11	Out	2016-03-21 18:03:48.952572+08	2016-03-21 18:03:48.952572+08	4qEQ0WR749HL88JrFvDYoDCODKbhZ3ydtD4ujV2neJ9mQSegOs	361
28	Out	2016-03-21 18:05:40.971076+08	2016-03-21 18:05:40.971076+08	FD5QbIkDzKGyyAC35wY7kDPt1qLfWjYlwdCYvwlvI2uHC7KH4t	362
12	In	2016-03-22 07:58:17.490387+08	2016-03-22 07:58:17.490387+08	Nn7mh8d3nAnLvjy8Iv64qO6lfIszYwtwk1jS8NVvXJIU3HcMDi	363
23	In	2016-03-22 07:59:54.023102+08	2016-03-22 07:59:54.023102+08	Q47VplnilMffJQf3soQOkyh3SkK57WnWat3QgqASDp7WGna9b1	364
17	In	2016-03-22 08:02:01.823022+08	2016-03-22 08:02:01.823022+08	XMzEPSyjX6GLcqFfHvWROjHVHXJrfurDHrRgKRQqXgCAXRpoNM	365
48	In	2016-03-22 08:15:58.43541+08	2016-03-22 08:15:58.43541+08	Gl7XHO4aFjV8wmzOTJptBMaNW8pNwDjCyqjGFnqUXLcU9cscvi	366
45	In	2016-03-22 08:28:53.877342+08	2016-03-22 08:28:53.877342+08	W757UcFKzCXjOWa8movdKUywy8YskVbHcgO7JeRJpy2FVcNIRJ	367
13	In	2016-03-22 08:36:09.544879+08	2016-03-22 08:36:09.544879+08	vlnuim2HfmmG4PxSWH7xZxwcCSEZkgsgSgbBTdS9QFPUdNwAe4	368
11	In	2016-03-22 08:36:54.94274+08	2016-03-22 08:36:54.94274+08	9E26qEY5nJlg0ENbOrFq1f6QAjn7tSB3gD9XRhcF1Ov2bKd0Bs	369
27	In	2016-03-22 08:39:55.649857+08	2016-03-22 08:39:55.649857+08	qCXwchgQoat0daEm7fUjuV8rXjCAjN3bZaYCIEd7oW8S7LFE1j	370
25	In	2016-03-22 08:49:33.61894+08	2016-03-22 08:49:33.61894+08	xwF6nmpzwZNzAwai9twm1mJ9FQUUfVEdSTjGGYGD8dDIan1jhx	371
18	In	2016-03-22 08:52:05.830761+08	2016-03-22 08:52:05.830761+08	Wikqq0HLVvqjZJEJZUrpgzTtI4hJnPIL83By3SKYOBIxUWH419	372
14	In	2016-03-22 08:53:56.707886+08	2016-03-22 08:53:56.707886+08	uh8ObQSKkHj2bq5mp8FAgdLzcpWttX2oFBDqbfAMwtOYkTMabb	373
49	In	2016-03-22 08:56:18.474501+08	2016-03-22 08:56:18.474501+08	kIG6IruoloMndayqRaWcvTWK2HnOsOzdhFiz8eosTBh7lfxEGT	374
26	In	2016-03-22 08:57:52.365145+08	2016-03-22 08:57:52.365145+08	pDwMXydKNWjMAQcsQjXGd1RK8D15QHYHUVd1UHLrn5FxVqqwbO	375
47	In	2016-03-22 09:02:30.611779+08	2016-03-22 09:02:30.611779+08	CFOdZWqabHrBYMgCNCTi4HnIFKA6GkTTzs6ZPwA1E2CmOtyl5S	376
28	In	2016-03-22 09:33:08.131855+08	2016-03-22 09:33:08.131855+08	U9jIRycb4sMYMMQSvpP6rd84QVwPH3rlCa4dZgFdabCvxcPtSo	377
17	Out	2016-03-22 13:29:27.321507+08	2016-03-22 13:29:27.321507+08	zKS7OscLItO9fakjEJRTx159x3lMvFBvYd3wWfInZgxFHhzV2Q	378
31	In	2016-03-22 13:36:07.23018+08	2016-03-22 13:36:07.23018+08	yyS39P6um29xxia1f7gyuHfsWwaWScwRbPUkoZfbbpYZXAaEHH	379
31	Out	2016-03-22 18:00:08.907256+08	2016-03-22 18:00:08.907256+08	CCYr55ogbHJYiuxCfmmLNOBwyi6ZwNq9ZP1eUpL67eepab2GOo	380
45	Out	2016-03-22 18:00:20.643339+08	2016-03-22 18:00:20.643339+08	clDniCWolTCdcl3dQXTmdaRIQ2tSIIHt5UhmhEbThn6JZ9w1gQ	381
25	Out	2016-03-22 18:00:21.058708+08	2016-03-22 18:00:21.058708+08	nL1FdRGXtYpBSuf9hNNKp58wOi6LjmlW8mllE2J8a9J24yClLZ	382
14	Out	2016-03-22 18:00:28.452802+08	2016-03-22 18:00:28.452802+08	6CeF83xEOg1AD9xyuC1DKaMddQbpDxPJA3YI6VWUDXeQgcPboQ	383
26	Out	2016-03-22 18:00:28.542456+08	2016-03-22 18:00:28.542456+08	o91BmebOUoMt8Wwgo3CLXPtCoaoECee1ngDaLoypdMjlsfShie	384
12	Out	2016-03-22 18:00:55.964212+08	2016-03-22 18:00:55.964212+08	4G3wSrYH7kvlljSyJonJeReNDX4eFmJJ3MGVFomLZi8LRaKkP8	385
48	Out	2016-03-22 18:01:05.768889+08	2016-03-22 18:01:05.768889+08	43ZiRmGVSVIkoL85qMtciTLpomR9XpHbtqLLdbq679qvTy1KLu	386
49	Out	2016-03-22 18:01:17.969207+08	2016-03-22 18:01:17.969207+08	w3OItC5LLdBcF5TaQ7CGDJP4Fs3GDNCARaSLmYf8BqkRvE1MLD	387
18	Out	2016-03-22 18:01:18.811147+08	2016-03-22 18:01:18.811147+08	cYW2cluf283EIUokobJUjVLUvHixc4BFchHFTBuVJxjbRYMGAf	388
13	Out	2016-03-22 18:01:19.274346+08	2016-03-22 18:01:19.274346+08	ktB7N7O741BFGnwX3Pjxv3vfeNE1dOgOHrVfxtl3uwIBkFineS	389
23	Out	2016-03-22 18:02:24.948129+08	2016-03-22 18:02:24.948129+08	laUhG94UAhsp7AhcpgVbjQY2bJGK7vmsVHalQeGaN9QTI868ob	390
27	Out	2016-03-22 18:03:26.325755+08	2016-03-22 18:03:26.325755+08	jX2IZdapxilkbH2C3SqJ3ESShkbnsPQcwStW6VM5D8poPr1SKr	391
28	Out	2016-03-22 18:05:07.420633+08	2016-03-22 18:05:07.420633+08	lM6EpnyQcrp3UnVOKbtfg7nWvDNwfhoR5vftjfLMXBP2yuRIWL	392
30	In	2016-03-23 08:23:18.449139+08	2016-03-23 08:23:18.449139+08	yDSmjOy7MeoB6t7mnqR9CzKb2JWTb2oZFHMygL621vE7pKtdBL	393
17	In	2016-03-23 08:23:33.02576+08	2016-03-23 08:23:33.02576+08	mNL7zNPVq1YfanwwmdJsgJotQeFKIQf5n1CnObJFdquEesBRWU	394
48	In	2016-03-23 08:23:36.55518+08	2016-03-23 08:23:36.55518+08	LDoA7FoMZ7mFDaGPNe1gteYosDh4eEY0QNAXcztC7gRJGhieMj	395
12	In	2016-03-23 08:24:06.408397+08	2016-03-23 08:24:06.408397+08	LGOt5G7mKl1slRGwzsvt63aXNqF6VcpqsEkxUrkodliPDyMDrI	396
23	In	2016-03-23 08:24:53.94733+08	2016-03-23 08:24:53.94733+08	7xLgUiXko3MdtFreDMWyBAksaxrwBjFHhayCJWw8ZKlTZd8m0f	397
49	In	2016-03-23 08:26:31.312089+08	2016-03-23 08:26:31.312089+08	lBpV4PTwMegbwOCuaWRXe1rQVR5dE5JzG8VKXzHtexVaMhWwEx	398
13	In	2016-03-23 08:27:54.92993+08	2016-03-23 08:27:54.92993+08	UsyMJUnO82SR2iZX47XL1CJWmeFIbSG7LFTejH3rKVJMEstIzR	399
27	In	2016-03-23 08:30:53.686434+08	2016-03-23 08:30:53.686434+08	d1dvXQamiDFyJbFmGy5IrOnAk33eL37x4ktbAUOthes1F8nV7s	400
26	In	2016-03-23 08:40:41.60001+08	2016-03-23 08:40:41.60001+08	nyHc92eCh0FnxIYruiNJc5xV6DdtikmWj49s7o5noKcmcBeXt2	401
14	In	2016-03-23 08:41:04.670844+08	2016-03-23 08:41:04.670844+08	qW6n3C1g6jRsGBxP54EAs2UVo7gTeaVU8bIAnJqu3InJTljYpw	402
31	In	2016-03-23 08:43:35.485877+08	2016-03-23 08:43:35.485877+08	iizDEoKtIyUnTcPmmD6d79vuTQgCyWAhF9uTxGNGEr4iVSUIfa	403
29	In	2016-03-23 08:45:03.524762+08	2016-03-23 08:45:03.524762+08	vmjriDIPPHvZzBiuegB2xPt18PTch9DdwwVfAn4Z6195Cr0pYB	404
11	In	2016-03-23 08:45:45.113015+08	2016-03-23 08:45:45.113015+08	rWamXhB1KsBXW7U2mepqEvrM14E1tmClJmYqUjroc3M9AqBwV1	405
45	In	2016-03-23 08:45:59.29487+08	2016-03-23 08:45:59.29487+08	niwf6xjJyd6CPPyxGTh8IKAeTKVdH1e5kbkpYU9Y7GjWfiUvCC	406
25	In	2016-03-23 08:46:28.561961+08	2016-03-23 08:46:28.561961+08	4UWE9zZedqfIvQsgGSBP0JfkpLSKHeWL93ZI38wfycxu3qcJJn	407
18	In	2016-03-23 08:46:30.264886+08	2016-03-23 08:46:30.264886+08	iJ7O4wjWH1BnMKqvct5YZ4BXyEObXhPG1Vf4SPajRlYn6PjiJn	408
47	In	2016-03-23 08:54:20.228153+08	2016-03-23 08:54:20.228153+08	HsrTQqhoSFWqWXNBbpaCZ2x8p5XZmqN5jGXA7FyZVVQ13nDedn	409
41	In	2016-03-23 13:01:21.012395+08	2016-03-23 13:01:21.012395+08	qDpoLftsFgjclTsJdzYcY48y6BmIpP7fcwUxcOqr5aVq4O9hNi	410
31	Out	2016-03-23 13:01:28.936932+08	2016-03-23 13:01:28.936932+08	KvmSusehBT7IAjFehr3Xk88GxBd8s2qDxdfsVKagnhyxREc86f	411
26	Out	2016-03-23 15:01:10.31802+08	2016-03-23 15:01:10.31802+08	gqno6l0ktslj6jNlcs6DZtuYrMmUUs9BjwyqiyacrMMx6jjidp	412
49	Out	2016-03-23 18:01:02.127895+08	2016-03-23 18:01:02.127895+08	wDjqmbDZ5hSFrCCr3uqdXi0th7dRpHImU2dHcqqiYJwQV9IY49	413
27	Out	2016-03-23 18:01:04.907005+08	2016-03-23 18:01:04.907005+08	CarCUZI918QJuuKYCxP2fxLcOqlgPppaRhmvH65IEUb9Pwhbt7	414
11	Out	2016-03-23 18:01:07.450669+08	2016-03-23 18:01:07.450669+08	dZ5yDTpyAFpzpGhcCyiHHwls6BpnmjvQK1PXUFWeUMeLcMxoKg	415
13	Out	2016-03-23 18:01:07.870955+08	2016-03-23 18:01:07.870955+08	5cdqVj2LYo5TFPUevytSdPoHjQdiFxPLa3C6mERL3WpIuKwqIq	416
48	Out	2016-03-23 18:01:09.159641+08	2016-03-23 18:01:09.159641+08	JvG8D1Zqioo89PBLVxawJdT9vOSsFkjZgzhu1Glj5aqF12aWzB	417
18	Out	2016-03-23 18:01:09.494944+08	2016-03-23 18:01:09.494944+08	TJnwRjLtcafMAMMrHM836EdwSey4BxEeH3bimvdPWJkgf7YwTg	418
14	Out	2016-03-23 18:01:10.360098+08	2016-03-23 18:01:10.360098+08	0YueVNJURUSf9jikSVg6tEOfu4lT2FA2n5fKSynsTGYc0HNSm5	419
45	Out	2016-03-23 18:01:10.698482+08	2016-03-23 18:01:10.698482+08	YgIxMD28g4Nq6BvlVNkJGEZpqZ6F3sJbZbZvpb4WfQMlcIW7fH	420
17	Out	2016-03-23 18:01:11.533431+08	2016-03-23 18:01:11.533431+08	QwW0lNascdlvFLXoHNQKs6kGrNYOUEfuBCvwZVoC9a7OvfDC3d	421
25	Out	2016-03-23 18:01:12.337612+08	2016-03-23 18:01:12.337612+08	WvjICafkyAye69q16QXucgVj5RPHdSuAOdSaF8LEIKsNTjPZAv	422
47	Out	2016-03-23 18:01:25.431615+08	2016-03-23 18:01:25.431615+08	Vmc0WhRvy5OtFmXhNmoi073sVWct6nqbaTb7A3498S3NFb5cOt	423
30	Out	2016-03-23 18:01:43.167232+08	2016-03-23 18:01:43.167232+08	LO1OHWuuQ1hHcIjEPuHT4Pu8mAjrm7l8VmWnJQhkRP24hlI7gZ	424
29	Out	2016-03-23 18:01:47.693428+08	2016-03-23 18:01:47.693428+08	akyWslgbdTjPbFC83WYkG1AI4r4MzkvaVu7Ohm0LHjksyw11Ta	425
41	Out	2016-03-23 18:02:44.061224+08	2016-03-23 18:02:44.061224+08	ljav2fo62nqxOMsVjaIkvZUfSTcTU64GpeCrK1wMonKEADitn2	426
12	Out	2016-03-23 18:09:59.444376+08	2016-03-23 18:09:59.444376+08	ejb9P4b2X68bNwGZoaalwPZHcjUMdJNI2yRS33UaAbBWZR6N2g	427
23	Out	2016-03-23 18:28:24.861303+08	2016-03-23 18:28:24.861303+08	Ax5jFiTj472RQ5RrWTu145cFbCghZiOjgTTuCweG4ghUl9MIcH	428
48	In	2016-03-28 08:39:07.574243+08	2016-03-28 08:39:07.574243+08	KgLwvx9cfiK3S1WvvisaywIgR4omMR4g8Pc4Nlf3V16x2dtxLm	429
30	In	2016-03-28 08:39:58.512646+08	2016-03-28 08:39:58.512646+08	YKjq1BtpxGH3wPSZTpM9srAypBbj9xWhIGYJRS9QiQSfpuFIkb	430
17	In	2016-03-28 08:40:14.445855+08	2016-03-28 08:40:14.445855+08	RdSbcInE2wCYeUoCnHevhNMA3C6IUqswULY7dLLfIYEw339pKn	431
41	In	2016-03-28 08:40:18.800533+08	2016-03-28 08:40:18.800533+08	m2B9CELHWp8PlckKjPg55ydJugM5WgsJh4RtImBncJDOwyigNP	432
26	In	2016-03-28 08:40:27.743634+08	2016-03-28 08:40:27.743634+08	lSOPlJ68OcoHuWKMQc9cRlveAsdsY1ILTgkF1qNPSBfNi1k9dt	433
12	In	2016-03-28 08:40:35.274689+08	2016-03-28 08:40:35.274689+08	k5fgjpZMi8N1TriE7i4U8XfnuOofWSZIXFyG5Ydmg1oAsWOzFS	434
45	In	2016-03-28 08:41:00.644272+08	2016-03-28 08:41:00.644272+08	UOzACuY1a5TAN1PMHTtuGav5kob9orbIFbSRW1S76wHTxfoF9i	435
13	In	2016-03-28 08:41:06.050035+08	2016-03-28 08:41:06.050035+08	AQK6V5u7Ejxp3DSVeyW76c4M522uHCdRbxX73SDHCC7FPZk4YH	436
23	In	2016-03-28 08:41:24.119466+08	2016-03-28 08:41:24.119466+08	BdsF1yH3sYFWyqUWxWyBnCNuRmUCq3T2gMIhLZkE70k7rFdpmc	437
27	In	2016-03-28 08:41:44.985252+08	2016-03-28 08:41:44.985252+08	1aoOVGByR22u4iHMQcvCq3CbA4rnsdQtEFJiUUiwWkraT8xtkt	438
31	In	2016-03-28 08:41:59.102317+08	2016-03-28 08:41:59.102317+08	6bwIE7L5uFjL9waSg5wO1T9s4d12XmvdOsvc0HhuVQGeOq74u4	439
25	In	2016-03-28 08:42:13.751949+08	2016-03-28 08:42:13.751949+08	TwWcpaGqcndXQ2QMdQdLL9mbnASuFNyiKVLA6b1hOeGoggBK7o	440
11	In	2016-03-28 08:49:41.76499+08	2016-03-28 08:49:41.76499+08	fSxS5lcXgrufZFAuPGWQyu5Ejluv62klUhEZTq7Ai2pIH1DhHj	441
18	In	2016-03-28 08:59:24.979855+08	2016-03-28 08:59:24.979855+08	8FdDUOzPJ6R4rvl6VGwcQeeGwvHAcYsknXyIvxhF48Jv452ZKy	442
28	In	2016-03-28 09:10:04.437554+08	2016-03-28 09:10:04.437554+08	Ckdp2alJkOrdAfB9x77eMBne7rj9R57cpkSrLEA6d2jnhuvf23	443
31	Out	2016-03-28 12:02:59.028542+08	2016-03-28 12:02:59.028542+08	KNE83LymUQrb3hNWZikjnOlXBTS78TASrOatkZgFzYq3FEZovJ	444
30	Out	2016-03-28 16:14:27.251886+08	2016-03-28 16:14:27.251886+08	YjhKHsnj1vDBP5ZyyKZfYYEPbTdBIZUqJDBb6xL6uYHJdqJcBr	445
41	Out	2016-03-28 16:19:57.370332+08	2016-03-28 16:19:57.370332+08	IjRV93ymEHMj7gvIH2Gc8BBQUoHnRSfiC7FMAE9OVV8cC4uT6C	446
48	Out	2016-03-28 18:01:08.034397+08	2016-03-28 18:01:08.034397+08	6FNHer6vfWOLGbSUwci61Ec9qoElIKxOZLgEDlBsJZEZBg48Jm	447
45	Out	2016-03-28 18:01:17.678427+08	2016-03-28 18:01:17.678427+08	FK1qTrfhdy2bNbw4pAp139aGhkwlsGY8aay5Sfm6doh1Pe5Fou	448
11	Out	2016-03-28 18:01:19.380506+08	2016-03-28 18:01:19.380506+08	Gr4q8lb5XVL7dvgc19InFvbww2c2HRvXJzORl0WJVsQ9o7lpG3	449
26	Out	2016-03-28 18:01:21.620525+08	2016-03-28 18:01:21.620525+08	dVyFSvH5wYWt6ptUHeVnx1gO9VVuMlxzGwFisWnq5KjBAdgRIB	450
25	Out	2016-03-28 18:01:26.680329+08	2016-03-28 18:01:26.680329+08	FGCveLRAGnvEmCB2v4Yjud4epDIVeahtrspWEHgU4ciroutkyT	451
18	Out	2016-03-28 18:01:38.649515+08	2016-03-28 18:01:38.649515+08	Ut7YYwlrSQSAKK39qHQXmUBVMzPGkOjFIqnrnZiGzBQKVTTMlt	452
27	Out	2016-03-28 18:02:17.384212+08	2016-03-28 18:02:17.384212+08	tXO53l5T2prl5Acs2QRkhRv8lRbEnN8iuXnxIsRKiI6nTjfUA8	453
12	Out	2016-03-28 18:03:07.261785+08	2016-03-28 18:03:07.261785+08	GrZCzLdbZRxhAsFxqXpIsYayM4i2YsAokj1k5eLe6KMGDbE494	454
13	Out	2016-03-28 18:08:30.11081+08	2016-03-28 18:08:30.11081+08	M2cw1y1j1ZcBONvO803Te9n1P1cc5mgQoJNpIOZJxDVLaQkiRm	455
17	Out	2016-03-28 18:09:06.773815+08	2016-03-28 18:09:06.773815+08	C6v07L1kx6XeWMxtCGIlZGy5bZWMIx9U35VBQWuOcS29o031GL	456
23	Out	2016-03-28 18:09:18.805478+08	2016-03-28 18:09:18.805478+08	mqalvCKSXcPh8TmcdD9Zal2dtpdwquHdlrOh4jAcMZJU367hJG	457
28	Out	2016-03-28 18:10:04.491975+08	2016-03-28 18:10:04.491975+08	Gt1IXu9Brz69cq22Y6lih8I2bL8i3QyJK1brvk3nj9wM0yOY5A	458
13	In	2016-03-29 08:39:10.490672+08	2016-03-29 08:39:10.490672+08	HmIZotuwdxNcHicsaYcdNMmKjmJ8LOIcBaCzU7v75KjL2NEcvq	459
25	In	2016-03-29 08:39:45.847594+08	2016-03-29 08:39:45.847594+08	GJD3dwpw5BKMnVwzVR7SYBlJXnflQbcgupjYlYUqjoEXLBXqbd	460
17	In	2016-03-29 08:41:48.418132+08	2016-03-29 08:41:48.418132+08	JBp5TNsA8Jlk0gZjFMIjD2YQZtb7kDk4Oa9rx226LnqMUQ6jmO	461
41	In	2016-03-29 08:42:49.229509+08	2016-03-29 08:42:49.229509+08	SzQ1Q1u28fFsjdTsWRtYXGMObqohab63aW41Xz3ffJYPw2HTTC	462
30	In	2016-03-29 08:43:47.756597+08	2016-03-29 08:43:47.756597+08	21SOP4FDlporsPOxRvwUbcn92kBJFeVHfxf52vIml7eeW3cxyZ	463
31	In	2016-03-29 08:44:29.768772+08	2016-03-29 08:44:29.768772+08	SZCGjE2uYGa4XG1DL39dpujUZHWCEVlg5yxoDyjkGKonap1usA	464
27	In	2016-03-29 08:44:43.658647+08	2016-03-29 08:44:43.658647+08	Yi6IDfZjrnFeVLcSApStbhEQVoGWj9gIrma5SAoKx5yTQbvaRO	465
47	In	2016-03-29 08:45:05.643298+08	2016-03-29 08:45:05.643298+08	U36iTbXj8HtoZlbAq4KfOIkNmByilR7FUDxxoVhwmblLNOVESp	466
48	In	2016-03-29 08:45:06.577243+08	2016-03-29 08:45:06.577243+08	tr8fFuqEdcfkrAxp8mLpj8RVToty3MowEwcSrTgV5MGwWEme19	467
45	In	2016-03-29 08:45:19.104228+08	2016-03-29 08:45:19.104228+08	UkGvGjkAinWXkkUMDMpuruH8rnLfSMnw74sOndYWQ64BqXX4tN	468
12	In	2016-03-29 08:45:49.255321+08	2016-03-29 08:45:49.255321+08	ylIGsA4EpWbdTihM7Wyf3Ql6abd8fXVeJovCy0RoW2S0lBMsgM	469
23	In	2016-03-29 08:47:49.904857+08	2016-03-29 08:47:49.904857+08	YjlKqNvUVb21HLpDXoDydj16kmH7fyTDiFXYbT37669MRyZynm	470
14	In	2016-03-29 08:49:52.86883+08	2016-03-29 08:49:52.86883+08	xRWyYHlpORoqeX6C6if9plFy8gxhflUeD1dlIPbfpPXUwdh3LN	471
18	In	2016-03-29 08:50:40.449466+08	2016-03-29 08:50:40.449466+08	CB9SAH98zotUT7V7snVTTMt1qpeYs0u6B4XMLgTLWNoyUL6N9b	472
29	In	2016-03-29 08:53:15.253727+08	2016-03-29 08:53:15.253727+08	qcxkdoaIMTIIZTM8phoJ2KhrKCCQZL2QxyAbnktAFCSofnwVVk	473
49	In	2016-03-29 08:56:33.171971+08	2016-03-29 08:56:33.171971+08	oX6WPPicpHwqhuqrWecQorcGgI4dnZOd8UAXts9jA7br2RjY6M	474
28	In	2016-03-29 09:07:01.967679+08	2016-03-29 09:07:01.967679+08	zuFcBvuFZipxMwSWUNOd7YkhQmAALGXLAlxLhrbHbQGxNiTr5s	475
27	Out	2016-03-29 18:00:09.902771+08	2016-03-29 18:00:09.902771+08	VCRGtr242OKZiULgp4YRLArb8FJb8PUdbusVmvZoKtO3OjjEnI	476
14	Out	2016-03-29 18:00:14.080312+08	2016-03-29 18:00:14.080312+08	f9TYkan4CvTgY5bSaOOBEh4ckSMUhAnNKGv5qj94fdkEiMgJk4	477
25	Out	2016-03-29 18:00:17.190362+08	2016-03-29 18:00:17.190362+08	UylYbX1x2i8o7S53Xwmg1SKkg27NLrRpqDORkPPm9YbF1gIYd5	478
31	Out	2016-03-29 18:00:17.557927+08	2016-03-29 18:00:17.557927+08	FdXZOEbVbxN3mEGBf1a6mjeOzf5IEiNTMu3k9eHkcemPs3aY4C	479
18	Out	2016-03-29 18:00:20.048868+08	2016-03-29 18:00:20.048868+08	eqvJFuxLDC3afQViBeNSPz7CPzF0YJCDA8WQ3UkGgorMEN5P3S	480
48	Out	2016-03-29 18:00:26.132491+08	2016-03-29 18:00:26.132491+08	rSSyerytsXD5kNDHnGmYWTNOqblv1oOtGrsujqncO1gAOtRBAE	481
28	Out	2016-03-29 18:00:40.290564+08	2016-03-29 18:00:40.290564+08	jgh75YiqTjfsdvjVqTNe6lfmv4gNFqbzWK7brpSMZ8ED4yjtS7	482
45	Out	2016-03-29 18:00:44.507281+08	2016-03-29 18:00:44.507281+08	YYsFLoI2DYsoYP9f21VUM5caIgZ2a29Aa2Ovqhx3GqrnG1TI2y	483
29	Out	2016-03-29 18:01:21.490673+08	2016-03-29 18:01:21.490673+08	mO4PyN5YPfbYpCZE8Qv6UBwMzDNTVPSInWgmtmMJSwqI9RWHrS	484
13	Out	2016-03-29 18:01:23.278151+08	2016-03-29 18:01:23.278151+08	NLdKhdY574UZMI635zpRIIO9aXa8oSaCnEWVr5by96YVOeYTeO	485
30	Out	2016-03-29 18:01:45.169027+08	2016-03-29 18:01:45.169027+08	uwgJ7HphPe9zqwENS6R46aAe6XJe1x3vuiF115iPjrPaodwIjP	486
49	Out	2016-03-29 18:01:46.75525+08	2016-03-29 18:01:46.75525+08	LpzVT63mj5km1fVFgWKPw4HMe7zbOj1kY1G36JpqNadOG9exfy	487
41	Out	2016-03-29 18:03:13.264556+08	2016-03-29 18:03:13.264556+08	Nc4exilxKAhLuGLAJRTAIrkvG15tylsLNw0MelKyv2KqIf1b8U	488
12	Out	2016-03-29 18:03:20.486659+08	2016-03-29 18:03:20.486659+08	lQMWMbXRWWCPraMsw1eG0aIKRa0SD8wyYJVtu3LRZXqR8DJ5Ex	489
47	Out	2016-03-29 18:05:16.535458+08	2016-03-29 18:05:16.535458+08	LEYdY0FYSSgPREiv9dyU5Y2vyA9JEMHZapE9pShJuOiMdRIl6H	490
23	Out	2016-03-29 18:14:33.167848+08	2016-03-29 18:14:33.167848+08	GBpI7oSG8gcPGEFUN5w5OrT7E7YWsdn9ocRvRtDZapxq4DLQIJ	491
12	In	2016-03-30 08:23:08.417356+08	2016-03-30 08:23:08.417356+08	WgBzmP7Lv0yjAnMbknVwN6mLwqYIIqbnXmnKCuf8uer5TEgD2C	492
41	In	2016-03-30 08:23:13.401027+08	2016-03-30 08:23:13.401027+08	BPIxkFoJX7A9uhvi39diHYN9eqNL4PXFopDZ52sc93l4lhmoqQ	493
23	In	2016-03-30 08:23:15.506503+08	2016-03-30 08:23:15.506503+08	X8zuHdleyp4W5rMIRRKK4TOpXAYKxPkVXjQoNBSN1Wt6OGNqhh	494
13	In	2016-03-30 08:27:06.813921+08	2016-03-30 08:27:06.813921+08	BlBZciiA2hZmD7WdvuoOHpuBvJRJAA1LvCuYudiwLIjYPGBLB0	495
17	In	2016-03-30 08:27:27.748236+08	2016-03-30 08:27:27.748236+08	iSqddmx568F8TBKNjF1SCMkvtAC6UM6EowrSipYownwQyHnhWo	496
49	In	2016-03-30 08:27:41.775584+08	2016-03-30 08:27:41.775584+08	AhBud54oBYBHm0DeTvU1lRoiqnzeVVTfDdaqjeftDrB0rOfLK9	497
48	In	2016-03-30 08:32:42.933272+08	2016-03-30 08:32:42.933272+08	M6aBoRyo6UKZBYDkPwP5qdw2doQJAlSXr2igThVZDp9NNM8mIY	498
45	In	2016-03-30 08:40:18.395466+08	2016-03-30 08:40:18.395466+08	r9BoBpeb8oNaMFc5u7nQg0GoNdBWQT5IdG7o6lQEanox3R3xYp	499
30	In	2016-03-30 08:43:20.751301+08	2016-03-30 08:43:20.751301+08	OEqe4EIFkhio0L58ABtbPUPESSfVQELpSCUWQllAUTzUp5czGW	500
18	In	2016-03-30 08:46:32.966993+08	2016-03-30 08:46:32.966993+08	af10tTSZysnKiGWDmvyY7T26xrCarS7S88S2bvbaoPvXgSkTOj	501
27	In	2016-03-30 08:46:39.802022+08	2016-03-30 08:46:39.802022+08	2VD4bBvnlnGsGO1iQce2ETR918blb0UdVhh7sdueRAWhYXQyA5	502
31	In	2016-03-30 08:50:18.249962+08	2016-03-30 08:50:18.249962+08	1OYTYYbAKDAoqeWYlPCg4craKQ8kPIpQhNtFwVPHiZ6YEd703I	503
25	In	2016-03-30 08:56:58.030724+08	2016-03-30 08:56:58.030724+08	g7vYhGyp1N8qopEh5BDUSv4YUIBaIEtzLoY35Ws5u1viqARwLe	504
28	In	2016-03-30 08:57:24.863917+08	2016-03-30 08:57:24.863917+08	RmaVL4nWf6kY66Nd9SB2Y63UotdGqytHlUm7YadEgOnmVBQedb	505
29	In	2016-03-30 08:58:24.311442+08	2016-03-30 08:58:24.311442+08	fChifVcKlTJfk5AXCj8pxoFlbkw2Oad5mLnSrQmdt6JeBTCODK	506
14	In	2016-03-30 08:58:39.399855+08	2016-03-30 08:58:39.399855+08	EB9TwkEsncTRhGmUieuVHocaTn4fBIzQT9sQt7Jgjn8Q4uvmZq	507
47	In	2016-03-30 08:59:51.882382+08	2016-03-30 08:59:51.882382+08	JqfuR9iVntnnKHwDhqK1X4ofVrbQeBIx2xsT7byvVmjp4f3lWO	508
31	Out	2016-03-30 13:00:16.339687+08	2016-03-30 13:00:16.339687+08	m4SajxSLO8Wg6Yey1lZ1g6nQvr6yccNPgp0RnTmCbJsgrWfsIF	509
27	Out	2016-03-30 18:00:06.446103+08	2016-03-30 18:00:06.446103+08	tzLgQHYWGC9dbqUbIH55TfOMNGs39BI3BdjbuJ8BUHp68KhPbm	510
14	Out	2016-03-30 18:00:08.321738+08	2016-03-30 18:00:08.321738+08	U5SsQp9JsIVBLgo5IjOPushkyo5gFfTjkvcClkVd31oOhdTyMq	511
18	Out	2016-03-30 18:00:15.29938+08	2016-03-30 18:00:15.29938+08	PIj73iv7PBnruYnWkZIGDLH2iyfCx23NKmUMVQUubHmWpa3aAL	512
48	Out	2016-03-30 18:00:15.642004+08	2016-03-30 18:00:15.642004+08	qNf8PP75a57dSQRwnwNHqyZdUPEX0OsrlZzCx7GYCNDfodccaz	513
49	Out	2016-03-30 18:00:16.023817+08	2016-03-30 18:00:16.023817+08	tSyS6TrK2sjujVTjhRqx14MEiArLmSLguJ91m1Mot5jeaDOIfF	514
25	Out	2016-03-30 18:00:18.566374+08	2016-03-30 18:00:18.566374+08	GgJct2mmNZFhGA1PBoQWdKcMyDaNVFclvvOpxBcLkr3115PCsp	515
45	Out	2016-03-30 18:00:29.442768+08	2016-03-30 18:00:29.442768+08	jWBMtAZTX5iAqe6FU4Q7PBxSCzXcCRSvxdIqmqLKv4Umia3EfT	516
13	Out	2016-03-30 18:00:58.170621+08	2016-03-30 18:00:58.170621+08	L5fJXrJ6TVWvRUZjLMaggXkCKTmNhSq3XVM5NfBrBhncBNMXjw	517
28	Out	2016-03-30 18:01:05.874521+08	2016-03-30 18:01:05.874521+08	DRUxcoSPCAr3COYYTvEenPLa2XxO4hMI9qGlfiBqr2t4QScuOq	518
17	Out	2016-03-30 18:01:07.991659+08	2016-03-30 18:01:07.991659+08	YCGtmIRkgVS2nbs4NXlYPebIi2kLw9CVLSP8kqsQNLTBwMFLt1	519
29	Out	2016-03-30 18:01:10.914677+08	2016-03-30 18:01:10.914677+08	tJfUbOXMjTWwyqPOy9GqadC3nAP3VJ4OcjtE8Qaru7otxDIwMY	520
30	Out	2016-03-30 18:01:12.018694+08	2016-03-30 18:01:12.018694+08	nwB10zBP3fi75KqyYxPApKHeDFrVCE4zBF0BFBaIqJOvdFtCDJ	521
23	Out	2016-03-30 18:01:18.958239+08	2016-03-30 18:01:18.958239+08	M4dchqrZM3oQ3zg3BvElD54b1hqut5EG8qsqhkQ5nFVqEBtP79	522
47	Out	2016-03-30 18:02:13.737156+08	2016-03-30 18:02:13.737156+08	BKEFvEwn9rrN70E0qvkH1YWWPkhKAoSL9ga5uXs4PkQXleXcbI	523
41	Out	2016-03-30 18:03:00.387256+08	2016-03-30 18:03:00.387256+08	tcqP8GApaKe3fniGsdnlhDW9kInItPan2RDAhNzHhdKNR4dKhR	524
12	Out	2016-03-30 18:03:17.606603+08	2016-03-30 18:03:17.606603+08	5PebYPtMhnlIbmiowQCwiua3H26uMnMRE13lQw88ktPMh9BeZO	525
12	In	2016-03-31 08:24:17.069783+08	2016-03-31 08:24:17.069783+08	bHICKaERVaFq2Tr5FI1OQlIp80yJeYhGp0SAagb6HqwIKoNZ7O	526
13	In	2016-03-31 08:24:50.216045+08	2016-03-31 08:24:50.216045+08	wXAGNIGMcutKBjKctuJV1aMxsgmFGtdDRoTo7iBjd54npORjJk	527
23	In	2016-03-31 08:28:02.221073+08	2016-03-31 08:28:02.221073+08	FKLcIEI5TYy7lQvFF3xQmbVqPLFq5YbLtwwCBGGeoFlafhoukm	528
48	In	2016-03-31 08:28:54.121003+08	2016-03-31 08:28:54.121003+08	LXOqOnCdeHCHc6EZHOoY3dnoDTW3OIpjpEaE3mrh54ygACGRb5	529
27	In	2016-03-31 08:45:45.636369+08	2016-03-31 08:45:45.636369+08	0dinTwI0zgIpQ842L7oDotHnaR0qsbwsFfhiczibg1R78V9Ucx	530
11	In	2016-03-31 08:52:45.025353+08	2016-03-31 08:52:45.025353+08	hSryGSQGKJrGD8vtqYtZAaachi8qDlouDhtTAKkTdckqkgkaFe	531
45	In	2016-03-31 08:55:20.784375+08	2016-03-31 08:55:20.784375+08	APFk2wTAngucb9KUcUoNxSziJjP4LeiV4xG6ujGiQBL1KfWwAL	532
26	In	2016-03-31 08:55:50.52547+08	2016-03-31 08:55:50.52547+08	K8nJq84GCOtutxsA4ntKWKWrLqYrnhD8p1Sg9VwKtqGoo9ytws	533
47	In	2016-03-31 08:57:11.826201+08	2016-03-31 08:57:11.826201+08	ETCkMXbtPPcbXSdz9lV67PvMElVDeS5svHdIpECEdoqBHUAQGf	534
14	In	2016-03-31 09:00:41.522602+08	2016-03-31 09:00:41.522602+08	VM5SjJEFWshblesPwid9wHxnSFIcfYJBuOdehqtEjbpVGjuCSY	535
25	In	2016-03-31 09:06:04.282407+08	2016-03-31 09:06:04.282407+08	LPpJDIYVuE4EPyc2dKtXYd9PAP85badwzTHDlpjh3nvSmXUQsO	536
18	In	2016-03-31 09:15:10.746167+08	2016-03-31 09:15:10.746167+08	xR38qCWyH8Zu6ZONmACWrGKmi7LDXDbWeedVqBU8J43PdRmQby	537
28	In	2016-03-31 09:23:01.421421+08	2016-03-31 09:23:01.421421+08	wSFHFxOaAwnlTTQ7yHITObXR1BrnbTmYv2qBzFlACawf3Mm2d4	538
28	Out	2016-03-31 18:00:11.539622+08	2016-03-31 18:00:11.539622+08	V2f4ThFLVqoIPkLGwLViVhJRMMo9OSDuUtyxbDJ648OTtjjp5F	539
48	Out	2016-03-31 18:00:17.495912+08	2016-03-31 18:00:17.495912+08	YZwr2JEqScJgXnaVlBj5HnDgH7Q1wVHV5EN7Xbx0EGgk4HHoS1	540
18	Out	2016-03-31 18:00:22.187777+08	2016-03-31 18:00:22.187777+08	tjn8Q5Fq7CLNhQb5X9fV9tlpep7veZwZJkgjpvZw8vKpMvtu5a	541
14	Out	2016-03-31 18:00:23.11433+08	2016-03-31 18:00:23.11433+08	PETB591B5gk2F4mwmcsMZ1IupeqkZvKyBoBFwCR2sC38Fp53Sw	542
25	Out	2016-03-31 18:00:27.394546+08	2016-03-31 18:00:27.394546+08	P2xhwnNnYwjsvth7AeJagCmjK2ZO52MU4KC18ZngWXZSRGZbus	543
27	Out	2016-03-31 18:00:34.42646+08	2016-03-31 18:00:34.42646+08	Cb5yLP2un6wAa1Un2cMpIsNrLo9tQ4mcfrb1Hcw6jtGKuk8xNU	544
45	Out	2016-03-31 18:00:47.093812+08	2016-03-31 18:00:47.093812+08	nfNBXizgcQkP2QIdRZGOf0IvKDgSB4wxjK9H39xfZi5b9NFawW	545
26	Out	2016-03-31 18:01:15.83739+08	2016-03-31 18:01:15.83739+08	ycWHYqUGJfKHd4bmLevKJV3O7ClMmhsmKP3tGX9aDTqqWSer7a	546
13	Out	2016-03-31 18:01:26.082851+08	2016-03-31 18:01:26.082851+08	CQ6FoDRZaEIS1cr4W8cfip8Zgf2LX9vjY2yNGQwpeFJfrBjOJM	547
23	Out	2016-03-31 18:01:44.368795+08	2016-03-31 18:01:44.368795+08	32CCbsqdEPlA9LC8hSYfIDtaslldA5zD7BPi4GMIf9SoTewC7V	548
47	Out	2016-03-31 18:03:22.12716+08	2016-03-31 18:03:22.12716+08	qOilzbXlFhqEuyQKhUb4mHCE6gs3szYjOHVOt3A8k2Ng0m1hHc	549
12	Out	2016-03-31 18:05:48.6339+08	2016-03-31 18:05:48.6339+08	l4txI0eC4WBcGatlyno9wZBJGB7HsOteRncknGvqn8T4hOpgCe	550
11	Out	2016-03-31 18:07:07.778049+08	2016-03-31 18:07:07.778049+08	q8E2SUDZl6wejPSM9Fc57QDaUuyKbAySJEUlhhKTnI8XgatpqW	551
23	In	2016-04-01 08:25:10.773497+08	2016-04-01 08:25:10.773497+08	uwx8XS3Wmehm710cliK7C7OKe5uYul6qi3xHV1nIfV5mV5PInj	552
12	In	2016-04-01 08:27:50.466562+08	2016-04-01 08:27:50.466562+08	OzqmKVsF5n1AekDc2idp2JK76pCV8zFWy6JJbCZg0aqeL4HMnu	553
31	In	2016-04-01 08:28:27.070616+08	2016-04-01 08:28:27.070616+08	CoEWvKM8pU8517BLQmXzTXaJCuOTIBOT1c0wwN5mrDrsK3Ekpk	554
25	In	2016-04-01 08:30:03.685915+08	2016-04-01 08:30:03.685915+08	kJJLcVG1yXCN2Dy2AvPEiGRa9ldNWT8GmRbPwrQvPcJRpITzEs	555
14	In	2016-04-01 08:33:04.778439+08	2016-04-01 08:33:04.778439+08	Ew9fXJRBfwfoESGprDhJ97vRZlk3lyv0v5fTN7f44KrIm88fLp	556
41	In	2016-04-01 08:33:08.162468+08	2016-04-01 08:33:08.162468+08	xUwtvVfgYRfURbZ75wEk1J5sar1iXMYVqVPm16TaX94ykd7qaL	557
13	In	2016-04-01 08:33:16.825792+08	2016-04-01 08:33:16.825792+08	abdgUFYVx6sWbj21W371deAhduLkkv6MWj31ybXwhPTJ9VKgYR	558
48	In	2016-04-01 08:33:26.708546+08	2016-04-01 08:33:26.708546+08	gC6qtklFVWBashLviKXGHEfkXoGsVpKC1R3uBnAgLLHE3cAlvg	559
49	In	2016-04-01 08:33:40.092354+08	2016-04-01 08:33:40.092354+08	2DvhyTXFM34gF68H1J6ByRWHeZsoLoWN3S51vbGIeLytR6BSPH	560
30	In	2016-04-01 08:38:13.014189+08	2016-04-01 08:38:13.014189+08	dPhAfNiYC4OiRRAWS68iOm4MgUTrws9aHqjwETWQWt9xLJUnPc	561
28	In	2016-04-01 08:42:13.05819+08	2016-04-01 08:42:13.05819+08	WmPaA65cx2V6cmwMkBpGbMBkKV4oJTRpGqQQwV3tXZ19MxV7AL	562
18	In	2016-04-01 08:48:00.825826+08	2016-04-01 08:48:00.825826+08	NlhYW24aqN3IDJ9dj68m0fM1oiyLp9gDuOkQQp1HD4ZQNj37oC	563
27	In	2016-04-01 08:50:41.24395+08	2016-04-01 08:50:41.24395+08	uprGqgyp2oyi2s7mJXcKopOPFl8JtxUnnM4d34T5sSnuLuheSK	564
11	In	2016-04-01 08:51:25.229879+08	2016-04-01 08:51:25.229879+08	zIAOhPApi4nDrbavFd0iisBXnWSVBvpBDzZuPjk8nYLfAvbPZb	565
29	In	2016-04-01 08:56:21.668914+08	2016-04-01 08:56:21.668914+08	8IUJpIpIn2EdDRdlM3W7BJfWypSaE2BMKffAxVSlXgPk83WU63	566
47	In	2016-04-01 08:59:23.258748+08	2016-04-01 08:59:23.258748+08	bHMHnL6GuLI7hcmNlktEVRuuB3xiW3k8K7O8SUOOpgUXIHu52n	567
31	Out	2016-04-01 18:00:15.965152+08	2016-04-01 18:00:15.965152+08	JXFESRHQ9nTuun2JvUoKse0NBJe6NgugEAugaC7kzaeuNgEJC3	568
14	Out	2016-04-01 18:00:34.564903+08	2016-04-01 18:00:34.564903+08	c5hdSsv7zKot134wje9qP8Q43nlI7xLk33NVvKcveRpfUubEZk	569
48	Out	2016-04-01 18:00:54.920897+08	2016-04-01 18:00:54.920897+08	4ysU4vJoEQmZBpcYKYsxUXPLCsFo7oYBoRfrOyhbPUBaJn9eM2	570
18	Out	2016-04-01 18:00:57.452293+08	2016-04-01 18:00:57.452293+08	crZ1CltSa1H9C6bsxyrfbH9msTa28w4jodk1QfT1gkAsqllokd	571
29	Out	2016-04-01 18:01:18.482608+08	2016-04-01 18:01:18.482608+08	TMud9n6jpEgtxVYiWxO0y5k9ybtjQeNt1IXA6dtvrapp6OYcMw	572
25	Out	2016-04-01 18:01:23.138229+08	2016-04-01 18:01:23.138229+08	cM2NU1yPkP49J5RqFXT9TLjKBoiiR5g4RiSvjRLUpPd9V5zkcT	573
49	Out	2016-04-01 18:01:24.114502+08	2016-04-01 18:01:24.114502+08	t7ocQzS9itEPxf8QcrrxMhN0qs5qdhKWoAAG9bPsVdIUKPuvHl	574
13	Out	2016-04-01 18:02:42.248405+08	2016-04-01 18:02:42.248405+08	tdTHeLAjCnRWKGgUWp6vibZ16tQ1phmjMG10bBjnyBKJR1mxrs	575
30	Out	2016-04-01 18:03:12.289244+08	2016-04-01 18:03:12.289244+08	taVTbaN2bDjOv6ew7G8q472OPTPDSH6MrbpTCCVnPFCLLqJS7R	576
11	Out	2016-04-01 18:05:19.836731+08	2016-04-01 18:05:19.836731+08	IBXKZxoyBGHHc9sRc5e8t4N5PivhB39TEgonecmps47VCzwo5b	577
23	Out	2016-04-01 18:20:02.578994+08	2016-04-01 18:20:02.578994+08	wxfK4430mD4vhIcV5H9r72vDX8DUwI6tGlEKpGLcUOYCgBhlSq	578
12	Out	2016-04-01 18:23:40.156882+08	2016-04-01 18:23:40.156882+08	eZrZmPh0ufI1ZZmntc4FFYdnkKzS6SIk2AKoa3oUi7VIgI5au9	579
27	Out	2016-04-01 18:24:46.462262+08	2016-04-01 18:24:46.462262+08	oAhSySnxttQCeSNzHw26SkDx3sG8TBHILylKRYILSjY8Bv7Ss9	580
28	Out	2016-04-01 18:30:14.180516+08	2016-04-01 18:30:14.180516+08	YLukIweY57iMQ4MBOnjg9DQhKbdR4WbcrVOAS2iXARtZWGku4V	581
47	Out	2016-04-01 18:33:42.347767+08	2016-04-01 18:33:42.347767+08	bDh2u2dYTi55Lvaj64lobvHVVnlHhplK3UMxW0W0ia54WgndjZ	582
41	Out	2016-04-01 19:21:56.492524+08	2016-04-01 19:21:56.492524+08	SLVjq1WdIFT4YWYuU5v05ebAj8qXla7EvcwmdTQvitzHPXCtc8	583
48	In	2016-04-04 08:17:52.971251+08	2016-04-04 08:17:52.971251+08	thmVrWci4OKAcGmZ3Q3TLkNL2msFgVNaDA56giok79ujOhIR7L	584
17	In	2016-04-04 08:19:44.229331+08	2016-04-04 08:19:44.229331+08	vT7Io95hOlDlMQvSWcALMHUH1syJK6eGZlYOue5IQJ4mjzEGcP	585
49	In	2016-04-04 08:20:10.888307+08	2016-04-04 08:20:10.888307+08	byg6GhyF1JMgZvR8KMmPfCijySiEiLdLKKRa2Pq3iDjI9CQSYD	586
13	In	2016-04-04 08:20:15.46976+08	2016-04-04 08:20:15.46976+08	rDPawO3fcl1G7LaYvcxmfgzQz8bQbAdTN34KR805t1L1MuZJXW	587
23	In	2016-04-04 08:20:53.745977+08	2016-04-04 08:20:53.745977+08	6EE5dEEGeoQHJnKN8mV8rPACQW8yofWutk0XxEnc3DuM1Fj92E	588
12	In	2016-04-04 08:28:05.324301+08	2016-04-04 08:28:05.324301+08	HsdR54xD4msahmKiKJv8vzLqLM65V8Kn1xE62CJ6yCfhy1PJKM	589
11	In	2016-04-04 08:28:38.753724+08	2016-04-04 08:28:38.753724+08	RGLm6h9CmfJ7SK5hR7tkDswsawt0GEMhTiUaPdlCJ6JlQOTrVM	590
26	In	2016-04-04 08:30:48.958355+08	2016-04-04 08:30:48.958355+08	chGZaqWUqliDTCvxlLbYXueqf5F9wkWZSl93cfYTRGguScsFxU	591
14	In	2016-04-04 08:44:13.956104+08	2016-04-04 08:44:13.956104+08	nVORM5WcETNj3pWBs9qRbIhJDAu6PsZDOxek3BNHek1hZXsTfj	592
19	In	2016-04-04 08:56:31.153607+08	2016-04-04 08:56:31.153607+08	tI2caFmVLCOvPmt4XwFuEtfFbFmUiSEcjHFKW2qrEFnc2hgZfv	593
47	In	2016-04-04 08:57:05.015505+08	2016-04-04 08:57:05.015505+08	UtpA9RQuv9NBl7S1Ry3IqHXetYNa83WdvNn5oE1kNOv9VOAwMD	594
27	In	2016-04-04 09:04:41.840422+08	2016-04-04 09:04:41.840422+08	FDUmsOLGzTIW7FtuKh9KTViPeEmpB93QNXCGvXVv1nS83M3N4B	595
28	In	2016-04-04 10:06:24.592985+08	2016-04-04 10:06:24.592985+08	hXhQvMdjCosFEGmRWjy2fzp88sUAFYMw63N2P1lbpeq5udVRMU	596
14	Out	2016-04-04 18:00:16.331426+08	2016-04-04 18:00:16.331426+08	S2UIAcBemQC9OIClKbm6Ddk4hfhE65iZ7DrHp3ucT8lrQxdkZQ	597
26	Out	2016-04-04 18:02:31.276995+08	2016-04-04 18:02:31.276995+08	qn3brlHZyNehwkuo2krwNL49DU7qFgG6UKgM5xv5LZmIKh6MSx	598
11	Out	2016-04-04 18:04:32.058612+08	2016-04-04 18:04:32.058612+08	JpKNyXs6N7meDGytc4rX8D7uVScbo5Z7utVtRNzoVlTi3SceWV	599
13	Out	2016-04-04 18:05:30.081845+08	2016-04-04 18:05:30.081845+08	DehKZDmDoaIOiDIE7jb7Y7s2pvTSazxnef8EsuRhVj7EwPS484	600
27	Out	2016-04-04 18:05:37.475643+08	2016-04-04 18:05:37.475643+08	BgB5i10DTbCROq8X61RWixGpCDEdINhT4sYmtYyN9CpY3w59xX	601
48	Out	2016-04-04 18:06:13.669124+08	2016-04-04 18:06:13.669124+08	fgUwWgAkKS72vBuTxo2xDCA2kDzpMwN3dryAY9usb2vXDq1Bg3	602
28	Out	2016-04-04 18:06:26.097211+08	2016-04-04 18:06:26.097211+08	9sFJvyWuossCvW5ugd4bWfcSDqJE2yHBsWUoV1jLtcXp9ckpFo	603
19	Out	2016-04-04 18:07:02.551107+08	2016-04-04 18:07:02.551107+08	RlU4EhuXvwWD8PjcEFexaYa8Okj9ayx1lS5zA0X6w4J5U2hiHM	604
49	Out	2016-04-04 18:13:46.256056+08	2016-04-04 18:13:46.256056+08	gruIyJ2iSciPdTrjT2j18g5RlYTTHkpxckGb4IKWv3vZWoJzq3	605
17	Out	2016-04-04 18:15:31.001359+08	2016-04-04 18:15:31.001359+08	0yi5QUetxventHZAsdTDAOF6xluHllKlk3rBXV5VRjKM1sWsWz	606
12	Out	2016-04-04 18:19:25.546762+08	2016-04-04 18:19:25.546762+08	6gOLmN7gesSyfD1WOY3T5UDOpDIM7oMDVkYH8fymYQkEdmk2Ln	607
47	Out	2016-04-04 18:29:42.145634+08	2016-04-04 18:29:42.145634+08	VQHhp8v7U2wqFRbnjjThW29IGm51oQnJq51gDwnhykYECA2vuU	608
23	Out	2016-04-04 18:32:12.193529+08	2016-04-04 18:32:12.193529+08	dRWmjmYomNFag6giltfZbeKAsWKuSFP6gvsQhREUoT6VZlELft	609
48	In	2016-04-05 08:20:44.177468+08	2016-04-05 08:20:44.177468+08	vGYGQRmkMFzlKfhD6PeKtTnzyNlDiR7ehft87gsTvrFGYvTeL8	610
49	In	2016-04-05 08:21:07.748918+08	2016-04-05 08:21:07.748918+08	yGcmGbB2otSwYAcSIj9BD53SLbOpGkxF1a2HBDI16lwevZ7FJG	611
31	In	2016-04-05 08:21:23.120224+08	2016-04-05 08:21:23.120224+08	QWLTyh5OWK9UZA5bQGnjHuUEZRogf8w6eIZezd3WxC1XL69mMw	612
41	In	2016-04-05 08:23:38.305314+08	2016-04-05 08:23:38.305314+08	Vdr1sQRg77o4DUMm9MQCrONsvjy5VL22yt2rLUYSbOWorsb1E2	613
30	In	2016-04-05 08:25:16.924025+08	2016-04-05 08:25:16.924025+08	C6QazNKySpKUrKPtCjOkCz9io1aQ2pSFvsovG9uiyFDpZcjkM8	614
12	In	2016-04-05 08:28:40.895368+08	2016-04-05 08:28:40.895368+08	WY8eHwgrNihpwdjlYzuTitivjIYU4ucZTkFjhub5dJuaweMVeI	615
17	In	2016-04-05 08:30:13.153708+08	2016-04-05 08:30:13.153708+08	yMCiIv1qQ5l3eFnsyUnbZRuV2qAOMngMBr5Tn6KEA6HoL5hKZW	616
26	In	2016-04-05 08:37:21.098871+08	2016-04-05 08:37:21.098871+08	uAxpezgoO4c5PnwUHlabzkhHZ3MINvnI6l8kloZAsCFIyCmGxN	617
23	In	2016-04-05 08:37:40.054346+08	2016-04-05 08:37:40.054346+08	rx8ZFhbbzyXnHcaPNMEwX79mQ9yDPwaGuipARRlQQJFhvo7KBL	618
14	In	2016-04-05 08:43:48.386827+08	2016-04-05 08:43:48.386827+08	HiSQVsZU6xRgFNQ5XqWJHwcWeYLlrW79FZZkS9FY7hGM5fRcWw	619
11	In	2016-04-05 08:47:00.339906+08	2016-04-05 08:47:00.339906+08	uotXLY6gKxDR7T1gEUpT3xBJJGykrVhnKcLfBQMVOZwW3xDHS3	620
45	In	2016-04-05 08:51:16.125946+08	2016-04-05 08:51:16.125946+08	kV1voKBn53JnqdQBJbcf71F4XH3kYVnJ1oEo9PcETv2JZSVs47	621
47	In	2016-04-05 08:57:43.353225+08	2016-04-05 08:57:43.353225+08	YB8mGf5IQdnEvo3AdCaFQ3BSNkurdyzBA8yQn3iEgWScKUmxgN	622
29	In	2016-04-05 08:59:22.840171+08	2016-04-05 08:59:22.840171+08	D7QOan9VflUexenv4bzmpfJHIdm5bTSpasEBgMfL9A16on3sP2	623
27	In	2016-04-05 09:01:36.684582+08	2016-04-05 09:01:36.684582+08	fFiyW1cJ6FmY4NRIX8eETnOUuCJw5izkxhjUiMnpbZOfwqxUxc	624
28	In	2016-04-05 10:10:47.388206+08	2016-04-05 10:10:47.388206+08	iSQ6wLIFIOxH9vzsPiFDYpmwVjnTEl5wEV3BqLQ9jOQrKQkj9y	625
31	Out	2016-04-05 18:00:12.572939+08	2016-04-05 18:00:12.572939+08	whpjeLTSnhEseSPgcG33OlRpelGOVPOS7EDmYgFMOTG3vfjYum	626
48	Out	2016-04-05 18:01:07.832659+08	2016-04-05 18:01:07.832659+08	bKY4ADpPbLo0nwE1jmhx96RP8N5svzfXKEbTQRt2mi2afGbO3I	627
45	Out	2016-04-05 18:01:20.122808+08	2016-04-05 18:01:20.122808+08	NCOobWBfP7f5ezIFTigNlT6n4l4eA6xXIMMtsXZIeGNJGfYjOF	628
26	Out	2016-04-05 18:01:25.779589+08	2016-04-05 18:01:25.779589+08	7AiDwly1RA7PhQk4KdbuvFAJYQy7ANMHW5UUqUVIdcgL3SPN60	629
17	Out	2016-04-05 18:01:55.662711+08	2016-04-05 18:01:55.662711+08	I2GSLosKv3hHKEMoiDJDVwpCIsehHkiYmx18mtSiw90GNM66ZP	630
27	Out	2016-04-05 18:02:02.844003+08	2016-04-05 18:02:02.844003+08	J5MAIe3wNKg5sT4tbqn3ZjDZ1av6gVV0brAsWDptWWyPz3Jbt7	631
28	Out	2016-04-05 18:02:44.565375+08	2016-04-05 18:02:44.565375+08	eSqr2qSxw9TS95KJxqVnk3KjSKmlvfsa8iSAZu8X4c0DhKWfC2	632
14	Out	2016-04-05 18:02:47.826743+08	2016-04-05 18:02:47.826743+08	Uw5ofX9SJ58BfGu8RU3Z28C2LtMqZXs4UxsAV2cn6kzl2ttSOx	633
23	Out	2016-04-05 18:02:54.483743+08	2016-04-05 18:02:54.483743+08	3Q5ERQ8nHiLAmp8e1dgdRmORZQLTskRvAWAcwJQE2lOnbWTcAA	634
12	Out	2016-04-05 18:03:02.159968+08	2016-04-05 18:03:02.159968+08	Gbwe3W5Pzx9QtJw4vtNM8P8WDj3gMDqconHsKMHJLQjFkhJgbg	635
47	Out	2016-04-05 18:06:10.897843+08	2016-04-05 18:06:10.897843+08	2j5AGIuJyHWpuMdCFwZWHtw19hiSNJ8Q3EaJWVcVn9LhVytkwT	636
41	Out	2016-04-05 18:15:50.109956+08	2016-04-05 18:15:50.109956+08	GDNDEWuwxJG7iJLKcrpFNcOjLtiFefius687c44aMLh5e2PHtF	637
49	Out	2016-04-05 18:16:47.582544+08	2016-04-05 18:16:47.582544+08	VHrt1DnjSSPBNIHVPsZUUvoB2TERk8gGPYAQlyADQZOnqfKHYt	638
29	Out	2016-04-05 18:16:51.019654+08	2016-04-05 18:16:51.019654+08	k3pZEq3SInZx5zWFQIEaVe9tS1ZmH8f2AVcOMfqeUQcYQ9npR2	639
30	Out	2016-04-05 18:17:06.5865+08	2016-04-05 18:17:06.5865+08	QwgZq9aPvrXbth7W6TCw8gOjFns3eK55Hle7uFXq74S2mZYs3k	640
11	Out	2016-04-05 18:23:55.422748+08	2016-04-05 18:23:55.422748+08	pAREug2njg8olPaQWVf4Mm9onuNMnQ7daZrVGuJ0bRpMrQmOvS	641
48	In	2016-04-06 08:28:48.476196+08	2016-04-06 08:28:48.476196+08	SIFb63WUQKuXxV7q1MkKNMmCidcV2YxUqD6wGbQgvLEuqKkrhV	642
12	In	2016-04-06 08:30:06.632162+08	2016-04-06 08:30:06.632162+08	C4rxGabs6eR49IHEEXqfEm1ShqmSiUyuYqsoRUiX9AcIRtWgRN	643
23	In	2016-04-06 08:30:22.874907+08	2016-04-06 08:30:22.874907+08	MfAM8rDuKvPJqxAinbEVANfle8fBn8YAniWvakqvgGFWFPG22U	644
13	In	2016-04-06 08:30:34.885352+08	2016-04-06 08:30:34.885352+08	XBqExVLdgAlFKZxqVZaNUHdjosA4uBYSNPgLu2ycCkrVKpMpPx	645
17	In	2016-04-06 08:35:41.732164+08	2016-04-06 08:35:41.732164+08	CtFpd3in8dyg6M6mg1ofd1QVWkLtajqmd6dHAM5Iz4x6Q4t76i	646
11	In	2016-04-06 08:39:01.346724+08	2016-04-06 08:39:01.346724+08	mjjDEHxZAXJ2Kx8xFIKKZJOYQocJvi2iRmvf3tFDRZFlXNjme4	647
49	In	2016-04-06 08:39:16.640985+08	2016-04-06 08:39:16.640985+08	7FNVmnKP7G8AyZvuGyoVDG5S2cplOUpVjD1W1Mw8c5IbeEXuEM	648
45	In	2016-04-06 08:39:37.308515+08	2016-04-06 08:39:37.308515+08	RQcWsd9iPXDF3vS5TTQPb3Utf98C5MYVmB2foBNFiaUlWwp0QH	649
27	In	2016-04-06 08:41:57.439617+08	2016-04-06 08:41:57.439617+08	P2Kuuz43C9PkeCvgqkrFzZpTLMQCMqTmrngnmkqytGjYSfFJQ7	650
14	In	2016-04-06 08:57:00.55306+08	2016-04-06 08:57:00.55306+08	YQhNu3kLF7Bit3VaqILhHGx1oPh4i8BHYseTvPoBWzsP3O0tgM	651
28	In	2016-04-06 09:30:33.655315+08	2016-04-06 09:30:33.655315+08	bybZzQygUhpfyOYerU4ffZfYzjwzddMFcxocNnJrV9XUX69PaC	652
14	Out	2016-04-06 18:00:16.559568+08	2016-04-06 18:00:16.559568+08	5GmknmUlm8P8N26BeTyxLU7tye084aK8q7tftOQfVposrt4WN3	653
49	Out	2016-04-06 18:00:17.886291+08	2016-04-06 18:00:17.886291+08	UjXbdWGdeKFzS67Mk1kBgG2V9tPDQnGuXnXAKnoy83ya96xt7h	654
45	Out	2016-04-06 18:00:19.660247+08	2016-04-06 18:00:19.660247+08	5nx7J71jKQWaL4NsEig3ho6gPFmN9t5Ei3L2AMlUmI49MS2bAi	655
13	Out	2016-04-06 18:01:03.219603+08	2016-04-06 18:01:03.219603+08	drWjZwyMK8GPMySh1c4m7q6BzSd14njhgGSFDRbWZsvvrOds1h	656
11	Out	2016-04-06 18:01:20.134608+08	2016-04-06 18:01:20.134608+08	g7YlIXEvYIjI0QYSflsHISAFO2d1udiblHN4pb0OtkgtBFMq1F	657
47	Out	2016-04-06 18:01:50.500825+08	2016-04-06 18:01:50.500825+08	8KhIY6KC7Fppqb8EfwpgLkQ2ebI1SJGadxtC4EOBTE1Kp8XV6O	658
17	Out	2016-04-06 18:03:03.919103+08	2016-04-06 18:03:03.919103+08	CR8cTmFlnh54Ih2Ct6PIGsVHDLQkqV93wHgQ4uCrcGvuxx7r4W	659
27	Out	2016-04-06 18:04:23.999558+08	2016-04-06 18:04:23.999558+08	AKPgbc22NsXWvUncurX6jAMf5LeBDihN374fj5h7yFduiRXdI5	660
12	Out	2016-04-06 18:04:46.550018+08	2016-04-06 18:04:46.550018+08	j2F7hJRMUe4C28K6m4BUBAio5RGc5YhpavvIFNdj3iw5pGBcKM	661
23	Out	2016-04-06 18:04:54.402616+08	2016-04-06 18:04:54.402616+08	7VWpKbIaDN8uDiq916XeqZNmeD4ppODwtjnEK5nYSwTfeKofQM	662
28	Out	2016-04-06 18:05:49.199434+08	2016-04-06 18:05:49.199434+08	KHvh5au8QkWdiPNVdhaRG3Ojj34YiUt4lpkqQfyrQVV9vreZZF	663
48	Out	2016-04-06 19:36:44.79636+08	2016-04-06 19:36:44.79636+08	1pIPZ2SdaC8UFtK1kkgkc7G8FC0tlZ9mPRCyTec4qkY7fs7Qdn	664
41	In	2016-04-07 08:15:43.891896+08	2016-04-07 08:15:43.891896+08	BGuROAdO4OxDBOeNN921DsllzRd7rIu3YpUwz8L3XKGiiv6648	665
48	In	2016-04-07 08:16:12.96285+08	2016-04-07 08:16:12.96285+08	7H1s21Kg8Dx3GWrkUrtpuQAC9r7FyCM6TNyVOJCVWAYmhRXBJR	666
13	In	2016-04-07 08:16:45.503779+08	2016-04-07 08:16:45.503779+08	1ErBQ13XG2jc7Cz6hOPttv4ShltFwDgxRY9rZCPoD9RLLRR4pq	667
17	In	2016-04-07 08:16:56.216905+08	2016-04-07 08:16:56.216905+08	xjl2CUn6jkIQijxrbX40NH9ocUG3Y5tWofY1AM7t7PKp9Ihkpk	668
12	In	2016-04-07 08:16:57.106861+08	2016-04-07 08:16:57.106861+08	kD3u2ePHixNcUBI2CSOJMVigLry2conN2pI3UhLDfhp9t9C6ba	669
23	In	2016-04-07 08:23:08.870606+08	2016-04-07 08:23:08.870606+08	Ox67eRydTbSHyU7HXbxsodafmUnyZPZyOf6365gZgAqfewvCYu	670
31	In	2016-04-07 08:34:38.886003+08	2016-04-07 08:34:38.886003+08	5OYf4LArKjHtifYnifsQFZZ6EE3BQb5V0dB4yLvI5DCmslbbQU	671
27	In	2016-04-07 08:35:32.168978+08	2016-04-07 08:35:32.168978+08	2f4blIonTFQYkQCvUBGPTLcf8VRj7rE8XIjJZY73nXbYxnUSxk	672
47	In	2016-04-07 08:37:09.064699+08	2016-04-07 08:37:09.064699+08	rR6U8FyYy6QDExUxH5WP8KwituWOMU9EwFi4UhdTn4g22BzJGW	673
26	In	2016-04-07 08:39:36.070551+08	2016-04-07 08:39:36.070551+08	iNqe7kZd8v9HB5XtA2bmUQqBSsMSCcyu0pa7aAki6t1HyXB9Zm	674
14	In	2016-04-07 08:46:56.586444+08	2016-04-07 08:46:56.586444+08	v4DmFefb7sE6nFvNMWX7Fd1Gu1n6ANs6R6tgkZIsRXyFlud8RB	675
11	In	2016-04-07 08:47:52.654365+08	2016-04-07 08:47:52.654365+08	GgoHxkIlqS9jZaoSHa2aST7RjtMN2nYIUNZS8rExKNhtwWMF7O	676
29	In	2016-04-07 08:50:19.206797+08	2016-04-07 08:50:19.206797+08	oZrw1bpNxrAWAetj71bLzvhhpfEBtLZjuRfv3VJ1NTXX9RHGSr	677
45	In	2016-04-07 08:57:02.962829+08	2016-04-07 08:57:02.962829+08	bSnJAdyOosjOcfpIbsouuCOSjWt1mNsOpghzKgO9a8YDnOVPHK	678
30	In	2016-04-07 09:34:37.379987+08	2016-04-07 09:34:37.379987+08	JCWhfGFZH2wAQmq8lBpALPIsc6H8UZSolyWRFl1WnwgEjXMVjC	679
28	In	2016-04-07 09:53:00.118177+08	2016-04-07 09:53:00.118177+08	f4bxxE4FNZopOaou14f2aTyGhio4EXGucssa7wpUWdKuE9oGCV	680
26	Out	2016-04-07 12:22:22.231438+08	2016-04-07 12:22:22.231438+08	ImyH3g0rkEP292t2c1yRVV6pQKyFZBkrxi92P9tAOJCXL6Zx7Y	681
14	Out	2016-04-07 18:00:29.469154+08	2016-04-07 18:00:29.469154+08	Pd4VTUpSkPeUHcERedaYnxrzVE64CDcbqh7LCvnvMSRd5e4jIe	682
48	Out	2016-04-07 18:00:36.490009+08	2016-04-07 18:00:36.490009+08	I6dA68OCDaPpBGXIbjFPfaq7EvlJf5xwBb8HjVTw6smH9Kak3p	683
11	Out	2016-04-07 18:01:04.775119+08	2016-04-07 18:01:04.775119+08	AiQ1pewbxcgvZrXh9HDbEJU1beLBPO1Z8Rax6XZ49G1i8YQHpd	684
13	Out	2016-04-07 18:01:11.504215+08	2016-04-07 18:01:11.504215+08	s4wN5Y2RjRpk0xCavI8VMHlN0tvRBk54p2RuaTMKuC5u9GV5Yd	685
28	Out	2016-04-07 18:01:36.987859+08	2016-04-07 18:01:36.987859+08	auuNIuHEMSyQWoSxj3R6NMHSHRimWIQ7DKUVFljbEi2kXViHYA	686
17	Out	2016-04-07 18:01:38.229112+08	2016-04-07 18:01:38.229112+08	MvWdOn57abP0icLD8axrCCaEw8jeOHolELPc9Ujj69jol51tfz	687
27	Out	2016-04-07 18:01:58.699427+08	2016-04-07 18:01:58.699427+08	lqCM58Tonr6cdKx3v8XfrdobSagTUMTGDfbJn57bxEDbYCeUJC	688
12	Out	2016-04-07 18:02:20.668826+08	2016-04-07 18:02:20.668826+08	ABpymIZTl4pFK4uvMi1UKyhXaGjEk3QuEGt1YTVKYLarOVnkEp	689
45	Out	2016-04-07 18:02:40.52244+08	2016-04-07 18:02:40.52244+08	FXnw5ODocxr4s6Km8sGcDoxngMJV8WKN59KAXXyAVqEOxYB5RR	690
47	Out	2016-04-07 18:03:12.970869+08	2016-04-07 18:03:12.970869+08	heGfSx3lSAInXNvrWTPVduNrJKQUQrv8WCoyAqkc23QZPNRwqq	691
23	Out	2016-04-07 18:05:50.285818+08	2016-04-07 18:05:50.285818+08	SUmpM6AmaaeXiBjXAtOuXQwxzNKRJBJmf5b2CmpmNTJ6e3dox2	692
31	Out	2016-04-07 18:10:48.134075+08	2016-04-07 18:10:48.134075+08	jUSgSS4mtNxDAdIlgUYVHvza2edfTbiD6BuYdyLYMKlWx4JeYr	693
30	Out	2016-04-07 19:05:08.557937+08	2016-04-07 19:05:08.557937+08	ApnAQqo4WJfFWlQRK4Qgcm0OKyScd1UnqJxH9mLf61ucmL48PT	694
41	Out	2016-04-07 19:08:19.550719+08	2016-04-07 19:08:19.550719+08	o3HoRantDQuiEl2C2ByNq4OmgC8jKXE8aUw15kuJBp2Pa3bdEZ	695
29	Out	2016-04-07 19:09:15.891244+08	2016-04-07 19:09:15.891244+08	16dPrKbz4vXI58n29sm4CxtENUHx8VY9bCZTWBTa71tC8gEIZ1	696
17	In	2016-04-08 08:27:06.180599+08	2016-04-08 08:27:06.180599+08	MlyGyMkGKsls2N5bpbmJCtK66SmKkML68KM8g7O10At3XydNaQ	697
23	In	2016-04-08 08:27:40.258915+08	2016-04-08 08:27:40.258915+08	gmK1sQTfkE36KBQgJ7oh8or2rO1VmavTOHUHhxwSC0ZWBzEU72	698
12	In	2016-04-08 08:27:45.859298+08	2016-04-08 08:27:45.859298+08	BFq3GiRHEEsAhGRCX8BVbNVAtgA8BHAMV1Pljq4x5v8nCY0khB	699
41	In	2016-04-08 08:28:42.062241+08	2016-04-08 08:28:42.062241+08	FIYkTSRdZbtjyPkOCUFFSLCa8O989qJO9r9cJZFsCAdAZOYlsn	700
13	In	2016-04-08 08:29:20.249028+08	2016-04-08 08:29:20.249028+08	1L9DvHb5Pjvi85aGhtqwm37QDfolRhZS4ifzyG5P11886iPncG	701
48	In	2016-04-08 08:29:53.544001+08	2016-04-08 08:29:53.544001+08	kPIrpVXeHyNqRQZ7QYNVxOX6WdovRRCCqU4g1bLIbi939iAZHY	702
45	In	2016-04-08 08:30:00.506179+08	2016-04-08 08:30:00.506179+08	6FwcLTGAPibbuR7y97bUPCDZFMIQvZx2oueBOuLndvQYOXXWe9	703
11	In	2016-04-08 08:30:07.07174+08	2016-04-08 08:30:07.07174+08	14LEdbav2WVzYKuDVJ9q7mmWLB4shi2inOxQzYM15q1dBvqgEz	704
49	In	2016-04-08 08:30:17.91167+08	2016-04-08 08:30:17.91167+08	XLmKs8Uw1Cf3vSRstQRGRW7SAIO1zc1WxnqquMmvYSyUuQNoqo	705
14	In	2016-04-08 08:37:23.089538+08	2016-04-08 08:37:23.089538+08	4JLBlVUAWTmX1lLrbHEPDmrCHmcebTTfmoqYLLiroVPpHlhs2v	706
30	In	2016-04-08 08:48:51.380284+08	2016-04-08 08:48:51.380284+08	IFiARyw4dYX8EKw5sHQa9G7Z6NKnHNjZcSj4Sg86EfES0AXsSx	707
31	In	2016-04-08 08:53:24.614166+08	2016-04-08 08:53:24.614166+08	TbEaBKxV8EsrnULXYmDgsRM7uMHSFjQiMeJWxH37VuyJQKqy74	708
27	In	2016-04-08 08:53:37.287376+08	2016-04-08 08:53:37.287376+08	f0W27QPOse9JNUxg2vx43Tz2nPLeOSi4SF7ZfWxYB7rYboGdkE	709
47	In	2016-04-08 08:53:52.96882+08	2016-04-08 08:53:52.96882+08	inhhoV7AAVcsa58genDdMOkDwM2D1mRia9QQfYap4DieJqLxeY	710
29	In	2016-04-08 09:23:42.051134+08	2016-04-08 09:23:42.051134+08	b0wMDtiF7j3YSdht4NReDVruAAlV8Q4jQ15dvos3Yvb1ZJtcgL	711
28	In	2016-04-08 09:55:51.215262+08	2016-04-08 09:55:51.215262+08	Htr9o2JaXR1cBRdG5Z5xcdtEdSXY6EtN8lVxnoYLGZxR1bh6Bm	712
47	Out	2016-04-08 18:00:39.292588+08	2016-04-08 18:00:39.292588+08	3nQw24PZbVoVrwHNt5CSQS3Ot40b9COCyo91rYaU4P0vMHKGMW	713
27	Out	2016-04-08 18:01:10.013126+08	2016-04-08 18:01:10.013126+08	jnylCtpCVyOtBNhLPat04xP4ulME3illWkYieOu9NJ3Yhkt7Ln	714
13	Out	2016-04-08 18:01:10.913109+08	2016-04-08 18:01:10.913109+08	7PlWTfJpuLYf85Qfn54jER3H0k2trMhylTVG9n64AejHjBxXG2	715
14	Out	2016-04-08 18:01:14.359815+08	2016-04-08 18:01:14.359815+08	HUTKlT5mNvA5uvYQChEIlOwVfggdEwfVQ9pCctyzq95k6cBIKP	716
12	Out	2016-04-08 18:01:22.401575+08	2016-04-08 18:01:22.401575+08	Z6nWcTDJ6RFlwgumsWgrWX1bI7ETOYsyfgVHAiaGAp28WwuPTb	717
28	Out	2016-04-08 18:01:38.464052+08	2016-04-08 18:01:38.464052+08	H09IbRPpunOnm4UILd1vtBlvJIsEgMoxMxGxPfnKTC8FFcXaGY	718
48	Out	2016-04-08 18:01:40.084904+08	2016-04-08 18:01:40.084904+08	WBkI74a1HHN7Fj5VhUBVodhwtxZRYpz51jN8nw85EVCUGHzxkB	719
31	Out	2016-04-08 18:01:54.285606+08	2016-04-08 18:01:54.285606+08	TZoBVi959hu9mvs93g6ClLhxoxFovzzPZob5WkAfR5oE0iN4PU	720
45	Out	2016-04-08 18:02:22.191217+08	2016-04-08 18:02:22.191217+08	GBpx9euNTqNSGwHr2nbCU4GJIH2fKQAabyYkdT97KWaaTrSUf4	721
11	Out	2016-04-08 18:03:35.735371+08	2016-04-08 18:03:35.735371+08	g98wSQEU6YuG9WFhHsBQ0Wwa7PRZu7daGlXiClDIL8XUemCvfO	722
49	Out	2016-04-08 18:03:42.920472+08	2016-04-08 18:03:42.920472+08	MftJG1ihadoFE51lnDY1Vs93NnpajWx6CrPSt8AUkyiy4kkrxJ	723
29	Out	2016-04-08 18:05:50.11498+08	2016-04-08 18:05:50.11498+08	sTC2WapNAZs9f514XuChOwg8wkrhdp1WJDZpnPDxy67dB8ij2u	724
30	Out	2016-04-08 18:06:01.424697+08	2016-04-08 18:06:01.424697+08	RRr8ZotRWWHX3akcQY2dX0jeeulNeoH6GAEox8GUeY2h9mKZMM	725
30	Out	2016-04-08 18:06:23.491884+08	2016-04-08 18:06:23.491884+08	DsNwX1sJOX8fcOprDnyUJd2LLB8gkU3xNQvuRnEpLMWxkLpxAo	726
23	Out	2016-04-08 18:07:08.678933+08	2016-04-08 18:07:08.678933+08	SSSUnnfvUQQXOnxKhP8vGTIlR48H2H6UkXyYMeUq5uOThMnQmv	727
41	Out	2016-04-08 18:10:00.159522+08	2016-04-08 18:10:00.159522+08	M2Penqiv7kDDExkDW7r1xvvMPdiD4V9PXY5LPnHWXUjmSU0ybr	728
17	Out	2016-04-08 18:10:23.273299+08	2016-04-08 18:10:23.273299+08	0ZnvvDZeQd9Z3g882XvI4TmmGGIGFt8FTvBO9l3ZPC9SsHatoW	729
47	In	2016-04-11 08:33:30.881306+08	2016-04-11 08:33:30.881306+08	DrzzfGFxWUqejKZviihlI6xRYqj9kYfwQew6uC4Rhu5RFfNxO5	730
17	In	2016-04-11 08:33:59.685901+08	2016-04-11 08:33:59.685901+08	jgBh8jYrsIQXGqDDx8P1Z7weYCKvAi0tPBbXu9PnSpMhhZufgK	731
12	In	2016-04-11 08:34:40.080517+08	2016-04-11 08:34:40.080517+08	gGRduyoFuyxvsN7Uu2dKq6BCnsliXS2EjTreSgtOfsJYFQ2ATf	732
23	In	2016-04-11 08:34:56.5728+08	2016-04-11 08:34:56.5728+08	UJlfWZXIH6kKKUnC9Gs3dYvx6BO9LroqBaVhA4zR9kkTFYfNoX	733
30	In	2016-04-11 08:36:21.523531+08	2016-04-11 08:36:21.523531+08	RS6NQCYoLtg9krjGZtKYLUJ6xYedvTBNwHjNTICoCrywjiEJcY	734
11	In	2016-04-11 08:36:25.040107+08	2016-04-11 08:36:25.040107+08	rw2B30jidfCo287mVa5hPHZOFK7Sdi1Vg4gj4QSh6dW8mduIE0	735
41	In	2016-04-11 08:37:53.469184+08	2016-04-11 08:37:53.469184+08	zdIZ2Wt9zXr13Y4jH8AjpGNNPA1KSFKSsc2v9w49TvAWUEGlNQ	736
48	In	2016-04-11 08:40:30.519525+08	2016-04-11 08:40:30.519525+08	VDhta64aQWqkyjN2fWxjgRfqyA5FwSfSfNLGTPqtvhfuR3w6Zu	737
13	In	2016-04-11 08:45:58.254191+08	2016-04-11 08:45:58.254191+08	pGMV7LgCaceG5JdRZ7qQ2m8giYjfeKaUaw1gIgssKX9PqmpQug	738
26	In	2016-04-11 08:49:30.296132+08	2016-04-11 08:49:30.296132+08	qvTydCXNqChRgIOhygOrZiPj7GWxgReXN8W1K3OBF6cvO1dNh2	739
27	In	2016-04-11 08:49:56.455594+08	2016-04-11 08:49:56.455594+08	FIke1suXpbxU9LcfMwil8yrkuGlYdTaslMXmESK54IZDdCs18b	740
45	In	2016-04-11 08:51:46.198218+08	2016-04-11 08:51:46.198218+08	lGad1Vtl4WFeP10wmFO7JSPsf35Y4DAqTkUUGNGJuVxKWxHKDf	741
31	In	2016-04-11 09:05:27.333552+08	2016-04-11 09:05:27.333552+08	RW8qPmtULyhVoBGJfWgvpbRnvylDIyrjVzaumVP9T7eIIubwRJ	742
29	In	2016-04-11 09:34:04.991614+08	2016-04-11 09:34:04.991614+08	sHuK4qJp4bovMKvwFiRdrvkWE3Rp0r9s94EDvW3y9ruUCqRRZt	743
28	In	2016-04-11 09:34:38.097698+08	2016-04-11 09:34:38.097698+08	5Ropx3sOtsH3lQ7yd3Wg2fYwAknbCOVHpK7nNzCHsTJesRdWTA	744
45	Out	2016-04-11 14:00:25.33514+08	2016-04-11 14:00:25.33514+08	DVplTzXHbje71UR8Io8U60wPepqIMKSZpILJIsatbF2cjTk2Ir	745
13	Out	2016-04-11 14:01:24.518678+08	2016-04-11 14:01:24.518678+08	WOsTnXJepfyJFoba8tTin5xphhJRkbKH0Cknj4SajQszGUaOO4	746
12	Out	2016-04-11 14:04:48.562948+08	2016-04-11 14:04:48.562948+08	6C942qmLIWwcnwoYkYcD9Md2LtWvHt0O69S9zFUIlRtZOi89Hk	747
48	Out	2016-04-11 14:04:54.694544+08	2016-04-11 14:04:54.694544+08	MQ71SSuyOCsOazX39XIco54ieSRmcjXyAdzc6ubV7VthVRkdy3	748
47	Out	2016-04-11 15:09:22.862583+08	2016-04-11 15:09:22.862583+08	Gn7KWlnxZQh6PrkPUqJ7MQbG87grkfu2T3MzoAxOZfUyYFO36h	749
11	Out	2016-04-11 15:19:43.563109+08	2016-04-11 15:19:43.563109+08	9S9liGsP9d54eY62YvBWJlCokk49nAqwc0iLGbkPFpTtOZvvV7	750
27	Out	2016-04-11 15:33:22.032497+08	2016-04-11 15:33:22.032497+08	SosfcdQgmDqdBTdtouVYKkOmemMairhBgaqJEHz1UqefKJZ8E5	751
17	Out	2016-04-11 15:43:12.213258+08	2016-04-11 15:43:12.213258+08	hXo5KTrg4aYllFMcYatXbOOG4iZcqnhYLWdg0VN46vprBCUimO	752
28	Out	2016-04-11 17:13:11.978385+08	2016-04-11 17:13:11.978385+08	HOlffpOFSG3AoPgS5gxSl4ObwZnRJbpa0bGfReutuy4iOkBTSA	753
26	Out	2016-04-11 18:00:25.517209+08	2016-04-11 18:00:25.517209+08	vDELoAudbEFRnF34uUipOdoSMDDXgfhcsvxi6sLh6a9tpCxjfg	754
31	Out	2016-04-11 18:00:27.832755+08	2016-04-11 18:00:27.832755+08	a4KPWgbjEIPuuIqs1wkMfrwolm0kWgR7kkWGR80fQPaLhREiPz	755
23	Out	2016-04-11 18:01:56.536363+08	2016-04-11 18:01:56.536363+08	54q2sdntNLZoRKaxa26agW0Ishj7Q97VDxW6bL0yfZn8tO6UPC	756
41	Out	2016-04-11 18:09:24.504809+08	2016-04-11 18:09:24.504809+08	57i5Pbm9iDHoiVmFbOabNGBBO5ZUZzgf7PkV2XejlvZTRMj3kJ	757
30	Out	2016-04-11 18:09:28.616754+08	2016-04-11 18:09:28.616754+08	e9apKyvtTVtAB1avWbTBLF8uiYISb3lHCM7WL3QoYKyjMZfsB9	758
29	Out	2016-04-11 18:12:15.209879+08	2016-04-11 18:12:15.209879+08	4WOCS7kjZNmMdyikV4nvsNGr7cRmVcvZ9KlbSWM2s9OX86IcA6	759
17	In	2016-04-12 08:25:49.802152+08	2016-04-12 08:25:49.802152+08	Y3TouaRNNwzJW9dHk6n78gGWENcW1ncZq6Plgq94n8NJH1b27P	760
30	In	2016-04-12 08:26:13.252704+08	2016-04-12 08:26:13.252704+08	9G6PmKmPqnDTN4ZmpGdyJQ7gkOhLQpkZ5qyrBlI2aUUxY4kOKN	761
41	In	2016-04-12 08:26:15.375966+08	2016-04-12 08:26:15.375966+08	MdoTKYr2tIreswWrpgd7iEcDCBHwZbKvF9PZhHcbaUHSRmKHUy	762
48	In	2016-04-12 08:29:32.642176+08	2016-04-12 08:29:32.642176+08	ODD1QPChMlJghYo79WPk8yFPShCmyflNsyOJOa1jLLQ3tFA3lZ	763
49	In	2016-04-12 08:30:02.531236+08	2016-04-12 08:30:02.531236+08	ntY4I1kUojBa64ZUNw5OgQi7UdMef8EU2mXKoJpc20D94mdQji	764
23	In	2016-04-12 08:32:51.764383+08	2016-04-12 08:32:51.764383+08	oQAXXdBtIq2WL4JtP8CEkEExNIk1iUjYut6SXHNp8PMUTfNsmZ	765
12	In	2016-04-12 08:33:04.7992+08	2016-04-12 08:33:04.7992+08	7XoMVCeGDOjxver27PJUFRtavOGJH3sOahk6tPM7n65jlwlsM5	766
11	In	2016-04-12 08:37:37.920297+08	2016-04-12 08:37:37.920297+08	NaWHBSeRlvUfK5N5BHUXPIeU2PRmImrfOPwZrb1dXVJragwlxR	767
31	In	2016-04-12 08:47:19.255076+08	2016-04-12 08:47:19.255076+08	JNjxrlNJYf6RLUpI4ht4MQZfIAMGvKhFhRDZDasmGyDbT4tWlm	768
26	In	2016-04-12 08:49:12.345185+08	2016-04-12 08:49:12.345185+08	b8EBnWLAmHUUWDvjm9Kfvae9C8D6eysG87Rvdm6Q4auanqKa1e	769
47	In	2016-04-12 08:49:37.059318+08	2016-04-12 08:49:37.059318+08	GwFu6R2JXhJRxQYPMCCRdH2YrpPCQQpfN5aTWcm5K5WHV5grHt	770
27	In	2016-04-12 08:49:51.328525+08	2016-04-12 08:49:51.328525+08	JuAMT2CsDbK4Ig9sAfVvko2H7XLnPchiXr51sHu7sEABvJ36yY	771
45	In	2016-04-12 08:53:08.23796+08	2016-04-12 08:53:08.23796+08	2kN41UbNI10zjYqoZk5Urxj29eLCkLkm58q7cRTuSTtC2l1bW6	772
13	In	2016-04-12 08:57:33.025677+08	2016-04-12 08:57:33.025677+08	6N5pPDUkPF6A2BIsItKlomGiyIUzt060OBpnOKYnZexbpGU8Ao	773
29	In	2016-04-12 09:24:53.175188+08	2016-04-12 09:24:53.175188+08	tyb9haRCZLDfLaqBOFVw36b1hRHCYR1SQbb8C3LlOXSj9JuXXR	774
28	In	2016-04-12 13:56:15.295501+08	2016-04-12 13:56:15.295501+08	UaW5bEWsQ6JRYj3AsFDE2blULumHSKhvvF2XTYPtejLCTOMMea	775
26	Out	2016-04-12 14:01:12.57469+08	2016-04-12 14:01:12.57469+08	agCMAXHxoiIWfEkgkEFA8ttT6NsSjX3KDFgOmwLbfd8Lrs2c7I	776
27	Out	2016-04-12 14:02:25.016352+08	2016-04-12 14:02:25.016352+08	mGCgjI4ckn9n8N3okpl6RRjZmbSpEZ81pJhZblBNaLBihEWT4I	777
47	Out	2016-04-12 14:08:13.186663+08	2016-04-12 14:08:13.186663+08	ZWjJ5XuXN97UAworWQdhmE3xvkCTEHlnmV7r32QQCXuLUiD19r	778
13	Out	2016-04-12 14:13:52.728269+08	2016-04-12 14:13:52.728269+08	iv5lu2X7UlNGZAmg3piSGu0BGUtUV3LEzQ1tSX1wJOEsY1YbqH	779
45	Out	2016-04-12 14:14:25.215476+08	2016-04-12 14:14:25.215476+08	56C5HSZBw5EIKEiK8Bs89CXM46NchEumK7rbZRmWW1oqFYCMj4	780
12	Out	2016-04-12 14:19:43.26639+08	2016-04-12 14:19:43.26639+08	VrG2FK8cwpprcByUmZvZ6SauKoTVBDag5piKAqw8hm0KxyojYj	781
48	Out	2016-04-12 14:30:58.473022+08	2016-04-12 14:30:58.473022+08	JeDsZWh33tFcaLTJedAblqOlBMkz6JjOxwIXTzaWsp9TBcmpGw	782
17	Out	2016-04-12 14:34:26.184368+08	2016-04-12 14:34:26.184368+08	R2npmyCYyIrigofyM9ywfrmoLxR8ng4Fir5VqH4pYvYFkDE7MC	783
28	Out	2016-04-12 17:25:44.659098+08	2016-04-12 17:25:44.659098+08	424rqPoIXcybrhTwEKEHAmDi2xvG5JSALX1CwqUTTT5LBYIOsW	784
31	Out	2016-04-12 18:00:07.520903+08	2016-04-12 18:00:07.520903+08	g2JtkMrgcwz57Kc8WYy13SU8nfg74YdkbweMJW3uT30aNciuCh	785
53	Out	2016-04-12 18:00:38.861649+08	2016-04-12 18:00:38.861649+08	vEAPMx5349bhsDeXZx4ctXft83WqxiXtwhJJfNMjWySPB7xk52	786
49	Out	2016-04-12 18:01:05.233725+08	2016-04-12 18:01:05.233725+08	NyZ3sg7PX585y6mIPSflDCkebvlZhrb5qA9jqG9OLITKNHbmjH	787
53	Out	2016-04-12 18:01:20.164635+08	2016-04-12 18:01:20.164635+08	ZvTKa5GNexEF35PCnGRxfmF96cPiQ9yy5SJfXZ3BWHQZMqlA7D	788
51	Out	2016-04-12 18:01:20.88343+08	2016-04-12 18:01:20.88343+08	7m0Mu6zLoPUnOZGhFnHIynZQNvG96NMDAMZ5TZQIyt6OTN6iBN	789
23	Out	2016-04-12 18:01:37.154139+08	2016-04-12 18:01:37.154139+08	1ABaaYWqhcF5pPRPUuyuCyoJNIfT1qp211dbZASImhMb7n1bi1	790
30	Out	2016-04-12 18:03:00.875391+08	2016-04-12 18:03:00.875391+08	VuyKEMctodkfflgJMGTpYFXuqeisFRskMr5aEhU4KEi0zPJMfm	791
41	Out	2016-04-12 18:08:32.759386+08	2016-04-12 18:08:32.759386+08	CE2j9sOrldJeOfXTGlBjpVxYVxxpKdbWrdG1XesJICxfrV97HK	792
29	Out	2016-04-12 18:08:34.309301+08	2016-04-12 18:08:34.309301+08	q6ppeLncB9Hmf9QvAxa4HsGFY7kiE2368rumEiPOrfBXocUza5	793
52	Out	2016-04-12 18:15:10.109643+08	2016-04-12 18:15:10.109643+08	4rxJ7WRrFftIl1AgnOPDmHsxphaJhBOl3M5AsW28CvQwxadlx4	794
17	In	2016-04-13 08:30:49.431204+08	2016-04-13 08:30:49.431204+08	xkLqiBZJUHUs3XE8h8ejGqgfndGRPEVNzqEi2n2V5WO83cGkku	795
12	In	2016-04-13 08:31:09.492549+08	2016-04-13 08:31:09.492549+08	V1lBgZpw1FCWcBNqtPevujRJrVv8Gg4khpwOPlLQ1XxdiLUcjA	796
41	In	2016-04-13 08:31:56.270924+08	2016-04-13 08:31:56.270924+08	YetzxlUtukayVHnSfEE1eFXcsGwNshXQMRQKDvE8go7C6uel9t	797
23	In	2016-04-13 08:32:35.511451+08	2016-04-13 08:32:35.511451+08	mn9LP2bNPU5wuROMlcHzkxorAumphviUirp9tQVJuaGp2fCmHT	798
52	In	2016-04-13 08:33:11.418199+08	2016-04-13 08:33:11.418199+08	m2RatcWgSDbBhL3WTwxyGsZWibCuOTOBWqlQSI6uVi6D39jW6h	799
48	In	2016-04-13 08:33:12.678774+08	2016-04-13 08:33:12.678774+08	WMa6sJh5E6ZdH5T4VvMbqrKw5N5otBWQW7WPREVfK4Ic9lfei2	800
51	In	2016-04-13 08:34:11.752735+08	2016-04-13 08:34:11.752735+08	GZtaWyxbnrmLIJSojt3EZNIrzRdf6MiNvcwSbu3Pmpk59Dss6v	801
13	In	2016-04-13 08:36:05.518578+08	2016-04-13 08:36:05.518578+08	7fJPXJqByxXhKUKIvuDyKzo54xIwqOsx4DNbWEmVCLDWoXokS2	802
49	In	2016-04-13 08:37:50.780181+08	2016-04-13 08:37:50.780181+08	km2Zr6YA3PYwMc9jEfx1BAMOhCvWwOYhBaH3foDjElfbOpLcVJ	803
45	In	2016-04-13 08:43:23.998562+08	2016-04-13 08:43:23.998562+08	egT15BD1hAOGqZp8cWwpFCbvm0k8dGRHwvJ27V3ofR5W1uedRb	804
30	In	2016-04-13 08:47:28.993973+08	2016-04-13 08:47:28.993973+08	Ugn6ca6OiieA1b6KdCpg1V86291gnSIH96NlgTAPCoZDQeX4rN	805
29	In	2016-04-13 08:51:11.761041+08	2016-04-13 08:51:11.761041+08	ksrsyt20apSs8cyVOfxY4BNdOnJvrBIb4BU35X3eNVXU8WzWBx	806
31	In	2016-04-13 08:51:18.488977+08	2016-04-13 08:51:18.488977+08	5G9StXGDS7NljRvEU1lXf93DdBjdgvblBkE5ITIkbgWK8SYbTK	807
14	In	2016-04-13 08:51:30.13986+08	2016-04-13 08:51:30.13986+08	99TCM7N6k42MpD74JPYbB9IgTP932cNBlqN9wkFhoH4fVCjnbH	808
53	In	2016-04-13 08:51:38.945626+08	2016-04-13 08:51:38.945626+08	PlRhTu7cx9GLJ2BhB9SQqHhuwD7g1hxRUO8xJFaHOqchsnP4wr	809
47	In	2016-04-13 08:54:41.919424+08	2016-04-13 08:54:41.919424+08	Um9Ch5PolRWjr181ySGZjeQLMI9lM6dqsl4bqTPcuwMmxUnww4	810
27	In	2016-04-13 08:56:19.064349+08	2016-04-13 08:56:19.064349+08	Wfiv26FBrbHUSAHWl8zBku87h6bV2XaYEJUFOjQGKhlmr2JdAJ	811
11	In	2016-04-13 08:58:20.602585+08	2016-04-13 08:58:20.602585+08	ouEw2v2dR5B1dPK8ejq5zBmkyfnIIxb7so4vk6ZCBkDoAXvoHm	812
28	In	2016-04-13 10:15:54.024024+08	2016-04-13 10:15:54.024024+08	uHxh2wNpFfnqmgfqcQxCc8wpw8NswefrueZxbvnqcbgPIMGumE	813
27	Out	2016-04-13 14:04:43.346297+08	2016-04-13 14:04:43.346297+08	7PM5EJDbCAGr1CWa98Xwx9XfYp2olp3sEPxTiA5uKLmLXJvgQT	814
45	Out	2016-04-13 14:23:42.24732+08	2016-04-13 14:23:42.24732+08	dPcB5B27zmv2fBRde9nj485qTd9PKZsxyV94fBAfx7heI9HwI5	815
13	Out	2016-04-13 14:24:52.590205+08	2016-04-13 14:24:52.590205+08	gMDlDgPM6jwygvUqzA2Aq0HYeZhvV01CNFyavNw27t1noVeogg	816
47	Out	2016-04-13 14:25:20.278122+08	2016-04-13 14:25:20.278122+08	yWgG5LpmHLmIYAXWkTtgV1aWpP3UEjBDGrTLCJ8TfulD5Ijple	817
14	Out	2016-04-13 14:30:05.692436+08	2016-04-13 14:30:05.692436+08	WHf7nVXqylaAzp1TCEmKgSFSfKkPAX4hnjocEMTD83N8tPb5cO	818
17	Out	2016-04-13 14:33:14.866534+08	2016-04-13 14:33:14.866534+08	PKqemWyXvA50qsjfVx2yBA2ZHvxs1bIQu95hf4FbEKc5DLkiJm	819
48	Out	2016-04-13 14:44:58.385084+08	2016-04-13 14:44:58.385084+08	gVwi4Ee37edP5YXAGDEVpRpSW3nIk74Rc1AgFoiMTNlYvJiCXw	820
28	Out	2016-04-13 16:04:26.270153+08	2016-04-13 16:04:26.270153+08	hNOXovacDLjImMJx3YlluG9go50XHXUyutWjp7M3R6LFSeCVDy	821
12	Out	2016-04-13 18:00:27.035313+08	2016-04-13 18:00:27.035313+08	H8EPp4UpblN6jIzG2oNOroUE4wsGS6FjET94Xdt9OHF9ZEPa4m	822
51	Out	2016-04-13 18:01:04.057704+08	2016-04-13 18:01:04.057704+08	yvbTAeQ2vs8AcMelQCOJKnaZw9nMkr8jnjDwOezKX7U9T9utKJ	823
23	Out	2016-04-13 18:01:38.511965+08	2016-04-13 18:01:38.511965+08	Df7nE4x2QhtYRhHfefKezqlU1GdvAxFNdMCrQ9tqrnOJVgyBMJ	824
31	Out	2016-04-13 18:01:54.31555+08	2016-04-13 18:01:54.31555+08	oMAbqBrT72RMP5ibw9kq0cfPvB5uLRDBnOmeYd8ffa15fjgctR	825
49	Out	2016-04-13 18:04:15.727987+08	2016-04-13 18:04:15.727987+08	Tt39JyJOtfp7qeVcJ4GRjv2k2gVhJP9mJCvbBF05uqDlVhOnlf	826
53	Out	2016-04-13 18:05:35.631596+08	2016-04-13 18:05:35.631596+08	FWbGHdxmLHBU4Ug06sF7xBxAvSsLGe0VBbmSFkFa2Q46ul62dL	827
29	Out	2016-04-13 18:16:00.729923+08	2016-04-13 18:16:00.729923+08	8bW6mSZfnpKnLVP8xerCEtcJzY56ZiRiKxo7ROmFD73YcSga7Z	828
41	Out	2016-04-13 18:16:23.533775+08	2016-04-13 18:16:23.533775+08	mLTQeSxiYXR1Gmy5tQTgegohFRAw1HVncyEHRC00jS11Fz69PY	829
30	Out	2016-04-13 18:16:27.057098+08	2016-04-13 18:16:27.057098+08	p5FemV5wR7Exupv97NL7O5ZO6nOCwnkms0RfVWbwdpuYfqhmE3	830
23	In	2016-04-14 08:29:57.169257+08	2016-04-14 08:29:57.169257+08	uc9T1EIQQFEB27BUlg1OdeDYDtPugdybG75IMNhmcvxe399opA	831
17	In	2016-04-14 08:29:58.383964+08	2016-04-14 08:29:58.383964+08	DToQ22KRx16vcM4heP5MChI9MLIVB8fObVodX96VBCRnYVVDua	832
51	In	2016-04-14 08:31:47.062745+08	2016-04-14 08:31:47.062745+08	Z7IsGeEYAPgqnILcvsl2OwEqjmMFzHpZN7SdlgCw6snsB9V72H	833
48	In	2016-04-14 08:35:53.972518+08	2016-04-14 08:35:53.972518+08	9QDNHxAdCAt2jH9Cvvs8sy1frCoNJqeSHrpZp0C2A64tOE6JAy	834
27	In	2016-04-14 08:36:43.6938+08	2016-04-14 08:36:43.6938+08	R2xShpeWDxNrQfjGEZHQbRWgMutSF4Rg6P9nFnKSkhJBN3Sbcj	835
13	In	2016-04-14 08:36:44.180863+08	2016-04-14 08:36:44.180863+08	2EBYtWUoyisQPypYm5M7X7oqJCtkmWUojfOeCrSBbLc1KSZ6Xv	836
11	In	2016-04-14 08:36:47.430069+08	2016-04-14 08:36:47.430069+08	D532vLEp71Lbp6HEjS6DehYGhsiHyGDCLFEGbS6iTRJJXaXH3d	837
41	In	2016-04-14 08:43:06.165113+08	2016-04-14 08:43:06.165113+08	UhL3x3vgKuwX8ImMYOoe7I7Qce1Av4nQl9UkDQRXLO5TgrpFGe	838
30	In	2016-04-14 08:43:45.9271+08	2016-04-14 08:43:45.9271+08	tNx1naeojasY2ehVPuvpSIEXluPb9fH33E4poieYKX7LCorbjn	839
49	In	2016-04-14 08:46:18.649939+08	2016-04-14 08:46:18.649939+08	RC6fjra8TknjnqyrgnbLMurTH4I8f2v7E2nxtO6N9t7wk6oRsQ	840
45	In	2016-04-14 08:46:47.597099+08	2016-04-14 08:46:47.597099+08	mFLeicj2kP4gWIjKGdiM0qG8n1DcS72FMNt5zd7k3BRYSBsiob	841
31	In	2016-04-14 08:46:52.774808+08	2016-04-14 08:46:52.774808+08	5oSKwGMAsoHu4cIxiIbo3ezUDSe6BThGIBaERwOKlfFpIXn1pP	842
53	In	2016-04-14 08:47:07.40125+08	2016-04-14 08:47:07.40125+08	ps4pMHJ2OUU6kmHM2iJQ256HtOohPe8FXC5tTOvqsQwdDEzFwJ	843
47	In	2016-04-14 08:52:26.741095+08	2016-04-14 08:52:26.741095+08	fyNlHHA6zYk7nIJtDlI8dBYaomoo2l7hkUT2md8lCss1CCtOyC	844
12	In	2016-04-14 08:52:39.065177+08	2016-04-14 08:52:39.065177+08	XbM6CBs1ztm7bXb5ZOihAub4unGpCE2jpOp2Zh4ZcqgEOJJyh2	845
29	In	2016-04-14 08:53:34.383375+08	2016-04-14 08:53:34.383375+08	grwIus6BhIPj2G8rIhZMHCDyRbHkaymHqjZlcfwKyN41dCsvtS	846
14	In	2016-04-14 08:59:25.190734+08	2016-04-14 08:59:25.190734+08	IBeVA67RqhQdyHOZ31F1LENPE1a7wUZFfFkpLqGCYgpYxE71EN	847
28	In	2016-04-14 11:18:39.175535+08	2016-04-14 11:18:39.175535+08	2ZaPypQZwN4WcjlNZ7EqJnX9LVNTWbpYBRyAGPjDnnjQYWn8d2	848
12	Out	2016-04-14 14:02:58.430798+08	2016-04-14 14:02:58.430798+08	xwoV6B1TeY5U7Gv6QCV9PJxAjVfWdJYbGO7MZ8oDgtinAdtaqP	849
13	Out	2016-04-14 14:04:03.681611+08	2016-04-14 14:04:03.681611+08	jGihPRD6yqPXSevZ1UipiOjQCt56UuVEBEvaf9gey5CRk82lcj	850
27	Out	2016-04-14 14:04:30.600851+08	2016-04-14 14:04:30.600851+08	bK9LkLGpRkkwyvBtWr3DW2JiT3pVoSFQmNlYi2OBl98k5JebBh	851
14	Out	2016-04-14 14:12:10.592478+08	2016-04-14 14:12:10.592478+08	pgj8PDBFi0hxQVLC35ERF0aNkfhQHr77ZqFy4REmRwkrS64VBI	852
11	Out	2016-04-14 14:24:06.563798+08	2016-04-14 14:24:06.563798+08	wQJXo4DVUVObcwSrvWJBJk84dZAh5L13mKaaOn7sIUUuSxmOU7	853
47	Out	2016-04-14 14:37:33.851884+08	2016-04-14 14:37:33.851884+08	ZnrhsVH3DNPEPBXzmwmsp6OK1pInEmunbmVTImXVAvjZ8HYtEM	854
45	Out	2016-04-14 14:39:45.188729+08	2016-04-14 14:39:45.188729+08	n3SBOT1gHGTC44yZXGM5lV1V59me310q4S3Sv48DKbPOfNwDeJ	855
17	Out	2016-04-14 14:51:49.93815+08	2016-04-14 14:51:49.93815+08	IQoKvtTiYWiYNm2QFwUNAoyZCew9rbSA2IUxCwfkTPJqCLHRJl	856
51	Out	2016-04-14 15:07:04.934695+08	2016-04-14 15:07:04.934695+08	oTan3mR0vJbPTdhxbtuHePgxGsJXJcJ86tv8gN8cgj2ANj8yc4	857
48	Out	2016-04-14 15:09:26.444993+08	2016-04-14 15:09:26.444993+08	GHSwFioYH8BaGHUCPBZXnGIqQfZZeDcuU6qjofJ6oUg5kBHBMr	858
28	Out	2016-04-14 16:20:21.226525+08	2016-04-14 16:20:21.226525+08	iA811Yga7KnkFIp72emLkbpRgacxlxpT9wU9VBjdVXOkpErrse	859
31	Out	2016-04-14 18:01:52.119506+08	2016-04-14 18:01:52.119506+08	DeF36vdhuOgjsohNyDXiq3GFo6TgxMKC1aE6WroRGVB9KsWJ75	860
49	Out	2016-04-14 18:06:11.213919+08	2016-04-14 18:06:11.213919+08	2x8ICwOfcM2xY3Ym95exWuTh4nba7hf8fnQrkoXNBZLjctWlyB	861
30	Out	2016-04-14 18:06:28.123888+08	2016-04-14 18:06:28.123888+08	jV6CEA0ol7XRFCFf50UcNfCjPodvZc6J8CVMNWB9charupXzp2	862
29	Out	2016-04-14 18:06:29.439104+08	2016-04-14 18:06:29.439104+08	bDgnw6ca2CD8VLK1hhXrqAaR2VHZU7b7KJuIPXrQj5YFQsG8bn	863
41	Out	2016-04-14 18:06:35.536093+08	2016-04-14 18:06:35.536093+08	0Sxas16AaaHChcVbtt9lLsrt8ImOPOCPpA0jB6tlgBxNnTzhN9	864
23	Out	2016-04-14 18:09:32.824779+08	2016-04-14 18:09:32.824779+08	Ti2LbAdOY3mkTcuTM6ZGrFRqcFKcwhlQPnl2wPQVSDGvpBPDIx	865
53	Out	2016-04-14 18:10:17.659105+08	2016-04-14 18:10:17.659105+08	TAEu1qAKT72FYR2KTzjtVD7l9wwYAFWdPjYPaik4pmJOELjhLT	866
17	In	2016-04-15 08:30:59.16119+08	2016-04-15 08:30:59.16119+08	bqghbpfYNpntSCe1cFjMJZ9cyNxh5JBfArNlh3K5s8yLKdLws5	867
48	In	2016-04-15 08:32:05.54094+08	2016-04-15 08:32:05.54094+08	JDeSpdpnLu7WaHOx361NBtVBFpoamhf6uKYkxOYJJfpswEq0Ls	868
49	In	2016-04-15 08:32:31.554688+08	2016-04-15 08:32:31.554688+08	NWlth1jWbWEHc9bBtZaSss8jm5xd5JWSpIMXJ64ucICFSoQMO1	869
49	Out	2016-04-15 08:32:39.37943+08	2016-04-15 08:32:39.37943+08	oHtv1g1yK6IqY8AufT1iPd2bsUQJpoKe6Ea7ub6GhO7GWHBBkC	870
13	In	2016-04-15 08:32:56.936466+08	2016-04-15 08:32:56.936466+08	uApwliQC1H0Lv6ZWDU8Jkphr6E9IPtUK4KHp3h24y2Qt8zQLUY	871
41	In	2016-04-15 08:33:21.155947+08	2016-04-15 08:33:21.155947+08	eFOM7VaGm1AILFcc5fK6jJ8ADGAdbeCFtab26CIsDSBYhnBmTV	872
30	In	2016-04-15 08:33:23.292054+08	2016-04-15 08:33:23.292054+08	sDn1N1HXerCq87Qj8WwQPAsahaNsNqOG4CHRDXzrQCiXJ9HRfE	873
31	In	2016-04-15 08:33:35.526253+08	2016-04-15 08:33:35.526253+08	s5Nlf6M3yjtNzxZGQnoQfEcNlvW4NCHGHf2wkO0j9u78sgPJUD	874
53	In	2016-04-15 08:34:51.035145+08	2016-04-15 08:34:51.035145+08	j9RMXEI4HfGYvYExVyNWjVQqeJX3d2GNBiiiv1mDg3mcb1b70x	875
11	In	2016-04-15 08:36:38.443728+08	2016-04-15 08:36:38.443728+08	djU4a8N8C1ASOLA7478qKou7RW83d81HrVLSdiaojkH87SFBYN	876
52	In	2016-04-15 08:37:15.589247+08	2016-04-15 08:37:15.589247+08	3tCw0dT8g7HhO9DjbqSDfCxxK5PZGywJr9Gsmj1UqHCFQOy3FR	877
27	In	2016-04-15 08:37:56.252801+08	2016-04-15 08:37:56.252801+08	FudDsyIIYYHVr9e82Sr3vjK8ylWxnlP3h4Ga3Zsb897zJl7KEz	878
23	In	2016-04-15 08:43:56.282447+08	2016-04-15 08:43:56.282447+08	NBihJhTpgHc6KJAatCAmnIvuHFgPZvOw68ePp8FVPrbjClL6xV	879
14	In	2016-04-15 08:44:53.20952+08	2016-04-15 08:44:53.20952+08	rlmng53NTcJsZP0EopM4LlvwV8iqEhL6T8tADwXgYqZ8GZM5Pi	880
45	In	2016-04-15 08:49:48.852573+08	2016-04-15 08:49:48.852573+08	9kU5h0DRqR8CXbKRlXNJEwAn4PNQUm9dWdiFdwgUOofvQ1NCYk	881
51	In	2016-04-15 08:53:09.289611+08	2016-04-15 08:53:09.289611+08	Vmhfal5xCZjLDHywWctC7I1mERnaeMLA93pjouh1USMiiLeFyY	882
47	In	2016-04-15 09:03:50.143899+08	2016-04-15 09:03:50.143899+08	R6qSs4ugeY30iD3YwrTesx6FgpaM5ZuWfkyYotGUSJUBWXjSPD	883
28	In	2016-04-15 11:52:01.906601+08	2016-04-15 11:52:01.906601+08	7IBEXs39E8i9eOtewjYDD1WiC3GvWf9dxLqVDueS3NahlULiEt	884
27	Out	2016-04-15 14:01:37.053412+08	2016-04-15 14:01:37.053412+08	vRuSA7WQ426Df4YXZlREEUboCMKX5YR1zNTAU0ZY2flijKFJ6h	885
12	Out	2016-04-15 14:03:08.60457+08	2016-04-15 14:03:08.60457+08	YKC99OVSva1Nb1k6AF6jn8QZqAs6Tyn2J0BROgtKIuhtvS06h6	886
14	Out	2016-04-15 14:04:07.618085+08	2016-04-15 14:04:07.618085+08	qVEG55QxCtwzvG07hOnbi6XQ0St0Yb6P8LfCQ6Ac07bvNb350q	887
48	Out	2016-04-15 14:23:14.496622+08	2016-04-15 14:23:14.496622+08	giwEAwg4xFf4emPLzpRARRH4NefPjfGQPDeYBKc9aIDF5ca5R2	888
11	Out	2016-04-15 14:24:08.046747+08	2016-04-15 14:24:08.046747+08	FsSXwpCcFvIWMhj0HuLs3vBGBGslLKnaEG8B6KnLG6rbnbc5Vx	889
13	Out	2016-04-15 14:27:40.257553+08	2016-04-15 14:27:40.257553+08	xZsAp5Qiql3eNHuVS1oGM5MDgBoJGKHEtAOjEoT5aWjxneSGeH	890
47	Out	2016-04-15 15:24:04.796339+08	2016-04-15 15:24:04.796339+08	W1MsE343MJNdXInv22kV8L2rIpVk6A2cBPVPSZSotqSR9GNBJ8	891
17	In	2016-04-15 16:34:47.299253+08	2016-04-15 16:34:47.299253+08	fQThIlXnWdxZG9xlZQL2FFsig1y4CICrifa1R7oxknW1wUnWu9	892
17	Out	2016-04-15 16:35:02.610328+08	2016-04-15 16:35:02.610328+08	YBORs5SrAe9MXs27tSFiQzVw1SSoyNxXXMxRSQIb5SxcLzjESy	893
28	Out	2016-04-15 17:04:20.691315+08	2016-04-15 17:04:20.691315+08	wsySpzvIotfmREAPebpxDuQBXkBHydGvWEONEKf3ELpfYz5Dbu	894
51	Out	2016-04-15 18:00:38.745982+08	2016-04-15 18:00:38.745982+08	Bopb0NMBeLouHL9fiN0OQEiGtIGyVquggkIg8dsnyhiG3rvlFw	895
31	Out	2016-04-15 18:01:36.944431+08	2016-04-15 18:01:36.944431+08	AfBsv5BC5g3yNjjfQrJJfI1NY4FVpURzAcs6i4ImkLm85WmVO6	896
30	Out	2016-04-15 18:02:08.50051+08	2016-04-15 18:02:08.50051+08	n4OoSxshSiBuiLXbRFfj3Q5pYALLekRToqIGnBxHt9CcVjEwyt	897
53	Out	2016-04-15 18:02:12.949148+08	2016-04-15 18:02:12.949148+08	g2KkqsuDEZxf3lWL3KW1bQAn3fWHcVBJXV4POyccYZIbLowO9T	898
23	Out	2016-04-15 18:02:25.757637+08	2016-04-15 18:02:25.757637+08	PktZYvF5DrbOB9tFYIDAuljDN62KUBntvhTUdjZqbBFmJ91rRE	899
41	Out	2016-04-15 18:02:59.670202+08	2016-04-15 18:02:59.670202+08	2N1laOrciLnWFjEjErSni4yxqI7rAZ6Cv7xWVp9EBwkRgyAuqc	900
31	In	2016-04-18 08:29:32.009784+08	2016-04-18 08:29:32.009784+08	iZhhXX0ePAEWMBdKh9AqNLn8lU7vQxZ9YGq6oqkE1zkNAOhrXr	901
41	In	2016-04-18 08:30:00.328552+08	2016-04-18 08:30:00.328552+08	iuDW3y1AvR8VaglRmaIXoJXZhhxPZVHHQUnSUpcQHkurRhJDIb	902
17	In	2016-04-18 08:31:42.148331+08	2016-04-18 08:31:42.148331+08	k7uIgcyf2YBKpaoe3JUfjkQecrMv5dWpkS7S5777fIRVsHAwae	903
48	In	2016-04-18 08:32:03.835185+08	2016-04-18 08:32:03.835185+08	cKP3y2uKxyyUojwwC23J9ibbEUrPRS34mS7kU26S15wpotm0vp	904
49	In	2016-04-18 08:32:31.515344+08	2016-04-18 08:32:31.515344+08	K6YvgnQZCr2Gwoi4ZD6ff7kdxYXkZTasZAoGxFpA8rP4g88GMF	905
13	In	2016-04-18 08:33:16.772739+08	2016-04-18 08:33:16.772739+08	v2MgfKFD5ogfhGoWXmlNwtFMxvV7CqL9thpZ25l7tTmbjb8HOt	906
30	In	2016-04-18 08:33:38.464454+08	2016-04-18 08:33:38.464454+08	eLnshmoDt24FAxxzXz5J7ymsaWUimscRERKvDA97CEMMCKMiKR	907
23	In	2016-04-18 08:33:42.858705+08	2016-04-18 08:33:42.858705+08	2QPoKzLoi8hLZwlusz437GGTcSnyC7QEYp3rpOgXWPs6Me1Fe5	908
12	In	2016-04-18 08:34:41.643048+08	2016-04-18 08:34:41.643048+08	HkLYEx12wD9NQhCTZ2rHZOgSU27UHlZZWv8kt9mqLwEmeQGES8	909
51	In	2016-04-18 08:35:25.610008+08	2016-04-18 08:35:25.610008+08	V3WCV0EcVVP55v0DgtLTkgQyT5PjIrrnuNzQOE3sjSxoNy25sN	910
47	In	2016-04-18 08:37:41.634433+08	2016-04-18 08:37:41.634433+08	Yd4ycX41IMs9AnXADuOHo8imw7kyBdLjHQisxmuG9nPJbwUors	911
45	In	2016-04-18 08:41:50.942765+08	2016-04-18 08:41:50.942765+08	6g1oSxvDw7qIr8ia1gNvvWjLpKIK9ADFqE4JCzX87OQyW9ZXpw	912
11	In	2016-04-18 08:49:52.821684+08	2016-04-18 08:49:52.821684+08	TlTD8JXQdhaqwR51lG1JO8hp6DxfkncEZ6RhPy83gitcBydwFe	913
28	In	2016-04-18 08:50:20.237115+08	2016-04-18 08:50:20.237115+08	FemwTsASYvGBApHbXgafjHPetZdXWsCmXyi1rtTRojcyZta7ZB	914
27	In	2016-04-18 08:55:56.76872+08	2016-04-18 08:55:56.76872+08	nJRCxLmbtJU6525o3whWOWG1Vpu6wUHknjwl5jNy3r59tAxw7f	915
14	In	2016-04-18 08:58:24.125212+08	2016-04-18 08:58:24.125212+08	TVCjWiZRoWv6HjpFWuyts2lxBf88cFn6k1pHiOiXveeDOTRuOQ	916
29	In	2016-04-18 09:31:51.515943+08	2016-04-18 09:31:51.515943+08	oISaGdGOlscayOaofJEOr93VMSznNOFCfhmvL3K7wwhvLIk1cx	917
13	Out	2016-04-18 14:03:03.678282+08	2016-04-18 14:03:03.678282+08	PT8TzTuyIINWU4EHzZLKhHHPDchxdJw3n4VmYRmqjANFEbWECr	918
14	Out	2016-04-18 14:03:37.765149+08	2016-04-18 14:03:37.765149+08	Xt9oINR0L4JH77Mcuu4gkor835kZJwRrpag9x79JCSaJZwvUq0	919
12	Out	2016-04-18 14:05:29.604416+08	2016-04-18 14:05:29.604416+08	Bco3kr9VSSRtJIU0QS8ZlJ2MccJY7AYImNLXGU2hwUbGl7GCZO	920
45	Out	2016-04-18 14:07:41.433207+08	2016-04-18 14:07:41.433207+08	lLhohKR0rYBQqwnDU4hWmd1OumVBy5ZlPHa7a17TZItRFhdjlL	921
48	Out	2016-04-18 14:39:16.604603+08	2016-04-18 14:39:16.604603+08	HYyIwt5R54WdpvuP3VRAy1SsSha6RMRiuQ0qJ5IO9o2ylxOoTp	922
27	Out	2016-04-18 14:59:26.725999+08	2016-04-18 14:59:26.725999+08	ySqRKJ9uObHpJCGK3ZPLxYB1XvxvkRljtcCEvLAKvRAGcQaf0z	923
47	Out	2016-04-18 15:59:58.534559+08	2016-04-18 15:59:58.534559+08	1yYCy68x2sPndJQoYLAhf69pMlGwRGwSFVdEalCcebQIup7TCH	924
28	Out	2016-04-18 16:36:04.352159+08	2016-04-18 16:36:04.352159+08	BrOKik5yhWFexUAcjkOvN3XnLTdTwpk8h9RQtXPb3eG2APesA2	925
17	Out	2016-04-18 17:13:53.57085+08	2016-04-18 17:13:53.57085+08	oX6NLRpyumofuXnMwhsMJw1YyByc49ftglG2D618spmnNbAKJ3	926
11	Out	2016-04-18 17:50:04.627001+08	2016-04-18 17:50:04.627001+08	gb0iBys9cxIHqy371GE1O7rBuEm5Y68Gh9xs8q2joL2fK5mKL1	927
31	Out	2016-04-18 18:00:18.275108+08	2016-04-18 18:00:18.275108+08	Mj8Du3Sh81mHHUPFNX6QHukJa5NNPiOlSWyNZQ5hRryiNOxkv4	928
51	Out	2016-04-18 18:00:49.978635+08	2016-04-18 18:00:49.978635+08	BDyvVZ1twQcLB5rASSaXA3P9lmXiXTmhgldCKe6I5hdGnVQGw1	929
23	Out	2016-04-18 18:01:37.173495+08	2016-04-18 18:01:37.173495+08	n73DGozoXWIKFx5sAQXGhcxLrlqI2nIovM2CB21iYI2nH8gRYE	930
49	Out	2016-04-18 18:03:58.011535+08	2016-04-18 18:03:58.011535+08	gGqfbiQS1SGJHCfJOpLPYuhaiyiPQHd7XUl9DDbDfrWw4CGT2c	931
30	Out	2016-04-18 18:08:06.868622+08	2016-04-18 18:08:06.868622+08	saWaCFZueyCI6imsr05TDkMkhQwxtyala7MmNvg2usK1c7sU7y	932
29	Out	2016-04-18 18:10:02.726678+08	2016-04-18 18:10:02.726678+08	xLjK6Rk3Qd21Pc8lOVh6WcyqdbyW56V4RFNWg8Z7lb8BEGwcle	933
41	Out	2016-04-18 18:10:18.879427+08	2016-04-18 18:10:18.879427+08	iIHhAtI8QOEvRfBpCrxlyiN6ubMrE8WwQneahwi9Lw5mdGcp8Z	934
23	In	2016-04-19 08:04:06.876685+08	2016-04-19 08:04:06.876685+08	b6JzDEaZ6ohcl8QQi8NRHiOMV2c8rkhUq1T4F5dKtLwfTN6CWS	935
51	In	2016-04-19 08:04:16.039546+08	2016-04-19 08:04:16.039546+08	cnB2Ag4movWWQNXtRmy57sP4YsRe4x8hlJjvynhnjFKAcq44d3	936
12	In	2016-04-19 08:04:23.04823+08	2016-04-19 08:04:23.04823+08	8kvXoUQG9VEHD0ZvvZjdNTsgcVYgYCjhwfFlAf2KBHaOHBKCk4	937
30	In	2016-04-19 08:05:52.25779+08	2016-04-19 08:05:52.25779+08	q8WjoAENqnZaUWFkHQQKjbaLzrWK4HOuOudD5savfAVBfluxBL	938
41	In	2016-04-19 08:08:24.492645+08	2016-04-19 08:08:24.492645+08	HuxrGwjmHn3fiSaMffFGbuP766r133NKyKDFIw2Zk5FTXppDV5	939
48	In	2016-04-19 08:09:00.538129+08	2016-04-19 08:09:00.538129+08	S70sE7y6829VM8pZN8WPhHUwj2naFJfhQfadmZjubsPx1GXOO4	940
17	In	2016-04-19 08:09:53.413579+08	2016-04-19 08:09:53.413579+08	n6KI35KpfY9KGZ0qEmQxh2q7zrNXGka3qvLt1fjfEt0VT1Mgnm	941
49	In	2016-04-19 08:14:40.954974+08	2016-04-19 08:14:40.954974+08	eUoUcnMzLckvfbr1VsgFYu9YQcZmJNZxrNSUCoUXRET7qL8LEo	942
13	In	2016-04-19 08:15:19.193102+08	2016-04-19 08:15:19.193102+08	bljjLAMuvfIVcAt6e5u8cMN6TDRcZfRARBumLHgIwynZ9gfmma	943
45	In	2016-04-19 08:31:33.73571+08	2016-04-19 08:31:33.73571+08	vPwJVQWw36bUG3fBp2SWJOV7xeodRaDNzAfVaCRdI38Y6njvpB	944
53	In	2016-04-19 08:31:36.06541+08	2016-04-19 08:31:36.06541+08	S9axGYc5C4fPRfZ7BAKcncfvBmjuiY6Bhg9yFl3QpjpHPQOZai	945
14	In	2016-04-19 08:43:53.370141+08	2016-04-19 08:43:53.370141+08	COLrKWe4RNcXYLEhKSTNtJ7jaVAz6kiI94ATaoX1CBYkVmSpFv	946
31	In	2016-04-19 08:49:14.231924+08	2016-04-19 08:49:14.231924+08	D9FKspp3pumYDvbNPCCwDO8l9dYbTnXgxm1qcqsSlg0yccM3nY	947
29	In	2016-04-19 08:50:47.809103+08	2016-04-19 08:50:47.809103+08	01w8m6lLhGAFw71xxdor6aX7ZBivEWUEYSMLY8gGOqVLyWJwA8	948
27	In	2016-04-19 08:53:01.981493+08	2016-04-19 08:53:01.981493+08	nGiMNIX6EkdiyBBKWjTEzr5UD31W0BenSNApfhvsSZcRkmlHWF	949
47	In	2016-04-19 08:53:38.004305+08	2016-04-19 08:53:38.004305+08	UW7Z2Jd3qdEVRgscWYJSRl24Dlqy3NEYtL8vekyVOD1pttSQRl	950
28	In	2016-04-19 09:47:06.88526+08	2016-04-19 09:47:06.88526+08	ssYuwlgnkjBzI5LQ10ByVZCWP6QrXrdQkCLhx2Vimfi5k4Ul4f	951
29	Out	2016-04-19 13:05:26.171374+08	2016-04-19 13:05:26.171374+08	kZFx6e4WWbOA29MNqKPL3C2lHmolYsRKTgHZLM6qxU1zdNNUhm	952
27	Out	2016-04-19 14:05:42.54816+08	2016-04-19 14:05:42.54816+08	pjyrVGeK2DESXg9oGUBML9qN8UkVySIoCHghXL3YYH26xBuEf6	953
12	Out	2016-04-19 14:10:19.952031+08	2016-04-19 14:10:19.952031+08	a1FRONv9stbBinSPVzkYYIpZOnkK2QQcRf4p3zyvta7cOZ2tZm	954
17	Out	2016-04-19 14:52:01.935426+08	2016-04-19 14:52:01.935426+08	S85IhT6Tn8tEkLtoBwnAsik0L9aN3A9WIEoziuTW3MkmhebtbP	955
47	Out	2016-04-19 14:53:48.707569+08	2016-04-19 14:53:48.707569+08	4U8oUTy5p2FzYWEMWwHzSKMD75rixT92xGrSjpXarlZQJnmpk4	956
14	Out	2016-04-19 15:03:37.395406+08	2016-04-19 15:03:37.395406+08	pEOCRVHJEFmNHjd9COyjxqVYGoM3d78TLWfm2v6GBrdScIbofZ	957
45	Out	2016-04-19 15:04:53.738271+08	2016-04-19 15:04:53.738271+08	YeQ4CgrYkVfry1OenPbsgmlKFNbqCIQkvqo8XghHCN9COXqCwS	958
13	Out	2016-04-19 15:09:36.892088+08	2016-04-19 15:09:36.892088+08	5dFqxUEZLQrkBnb0v9gdRs1a5P8vb6OhjcYg7mGSD8DPvoPry5	959
48	Out	2016-04-19 15:13:26.642955+08	2016-04-19 15:13:26.642955+08	VPxW03v9yYEMFxzne7auZn3nDycbqbhM1fr1ioAhMO4cM4Q1B1	960
28	Out	2016-04-19 15:56:40.035318+08	2016-04-19 15:56:40.035318+08	vloyY1xBcomKAn03oiryQENUqiYHjkHfV6e47dFjS24cp4fenW	961
51	Out	2016-04-19 16:14:57.247727+08	2016-04-19 16:14:57.247727+08	cEk0ibiHsS2B9XHncOQr8suDVjHBO5h2IS225kJxEL9MtQAVob	962
23	Out	2016-04-19 18:02:01.529417+08	2016-04-19 18:02:01.529417+08	OwUI9z3RARVrToLVpQG9OUUXqOw1tlcIi7br6eJH6o9ZdU5TuL	963
53	Out	2016-04-19 18:03:57.029597+08	2016-04-19 18:03:57.029597+08	cIp8pgWniQZLiHSK9YySp5HyeuTiOO51gu8WbeKK5sfnB78Kg7	964
41	Out	2016-04-19 18:04:18.282146+08	2016-04-19 18:04:18.282146+08	mVC4UpxxZMMdN3YVZAAtTEm93xHBIwI5TT9xK7vtTIXqL6MuGV	965
30	Out	2016-04-19 18:06:14.433905+08	2016-04-19 18:06:14.433905+08	ojkcsmaAxs7GxZj7Y4EUwhmUY9at4pQsZAVTx6cuyjBwKu4ryI	966
31	Out	2016-04-19 18:11:56.253366+08	2016-04-19 18:11:56.253366+08	MvzARYI1SMrsFR3ku1qXvpH7mb2qT19px8zOgIQ9eI2tj5ee6V	967
49	Out	2016-04-19 18:18:07.539181+08	2016-04-19 18:18:07.539181+08	C2LT985ByYD8OAGOYwfy6KG8E0DseJOqKjLTsQfryrzN3GlbDR	968
11	In	2016-04-20 08:00:17.473524+08	2016-04-20 08:00:17.473524+08	aKlrSzrfsWyHNJ1ins9Tk7LkUO1GzEgaYTR2TJhLqgcE0dwnW6	969
12	In	2016-04-20 08:13:28.308564+08	2016-04-20 08:13:28.308564+08	HHDc2h03x0Heaq82raMZvCGYQGCN4iTLzgw2Ow5MwM1XC9a5jv	970
51	In	2016-04-20 08:14:00.76975+08	2016-04-20 08:14:00.76975+08	ef9tFZARwE9RZ98WBWTFtRbuyo3YsnVXTdRiDb9BpJbPSjvdHP	971
41	In	2016-04-20 08:14:44.292354+08	2016-04-20 08:14:44.292354+08	sApV5oJ9NDvskPXC8knHvdaX33HxgYNZjD5o2PwQbsJMIpXQaL	972
30	In	2016-04-20 08:16:19.809794+08	2016-04-20 08:16:19.809794+08	hWyI42LL01tObdbgRd6O3hIM4aDb0nwhKwzOyKjyMdNxHxejbj	973
23	In	2016-04-20 08:17:11.387931+08	2016-04-20 08:17:11.387931+08	8fRQ2V0E8125iM2hk03UzO8NMPL09wkHcChehhspiuuQHw91wB	974
13	In	2016-04-20 08:29:37.421123+08	2016-04-20 08:29:37.421123+08	VwZdKv3fwCcgTFtBsbslRagM2wJAyGLTDv7WrACnMoVp3P0w1s	975
45	In	2016-04-20 08:31:43.689536+08	2016-04-20 08:31:43.689536+08	hSUOoVM8gKO2obxv8p6KdS99HCYI9YBq1eFpBbxqvMskwqf5fl	976
17	In	2016-04-20 08:36:22.560568+08	2016-04-20 08:36:22.560568+08	PJEYSVk1ntZxkadzRnbPeXkXHiOxn4jDOxlqTWrGQREA2rATfl	977
27	In	2016-04-20 08:39:45.769286+08	2016-04-20 08:39:45.769286+08	sKIdsaLHY9LIMiF9ZifRy5sDGu5QOkBH6Uux5GFcPZumJAussa	978
48	In	2016-04-20 08:45:18.408088+08	2016-04-20 08:45:18.408088+08	KrgD5v8AMWvXn12iy7yEjOneB7o7zghKYNXdKfngCjEzkGhjNg	979
47	In	2016-04-20 08:48:50.480097+08	2016-04-20 08:48:50.480097+08	x76llHsZNsH5DpTkTnPHTb1halxJVLzTS5GEM9nk24pFtJyN6P	980
53	In	2016-04-20 08:51:12.528535+08	2016-04-20 08:51:12.528535+08	ea0fIbRGtwbtQ4zgIMp57qAw64F6RMU5vVkE6CU196uZAuGSG6	981
31	In	2016-04-20 08:54:17.062332+08	2016-04-20 08:54:17.062332+08	XNwhJ3lZ9CvdIr936FFaGOgAyq5FJLKqiIX3LJcUVX8nQHqWW6	982
14	In	2016-04-20 08:57:15.526067+08	2016-04-20 08:57:15.526067+08	7mUnxTe3hxO3o7KMAffmACKJykapH7vOuQCrtrubpJeeQy1aeg	983
28	In	2016-04-20 09:52:03.733317+08	2016-04-20 09:52:03.733317+08	Mosg8rRiiiqe7k5JcyBXa1qFfHEgrsOEhHuq9MZq5PVCBaVnZh	984
29	In	2016-04-20 13:44:38.939789+08	2016-04-20 13:44:38.939789+08	LAiCPOTc6LVUZEkU4tqdkw3G9Eqe2QMNa5ZzU3caO84xMoSQiJ	985
12	Out	2016-04-20 14:02:56.412203+08	2016-04-20 14:02:56.412203+08	4TG7jOLb4N2QkdVLc0OFamNejjTCACVEflLQAg2E44eohAAKAX	986
27	Out	2016-04-20 14:06:24.160004+08	2016-04-20 14:06:24.160004+08	ZkKwO4grGq5l5kXQBh6CuAGZyxj9Itgrd1o36WuMNz8SjfruMy	987
13	Out	2016-04-20 14:32:02.45503+08	2016-04-20 14:32:02.45503+08	7I9Or8MaGdUwV8yKB4q6QE5YgpEYkaWrsfGjnbL4Fp1kx0694w	988
11	Out	2016-04-20 14:33:56.184472+08	2016-04-20 14:33:56.184472+08	FVBK4qAIPtswllb2VPdpTtfUedUkmZh14rL8jVQ9PJ5C5hEa7r	989
48	Out	2016-04-20 14:34:55.389829+08	2016-04-20 14:34:55.389829+08	Qal65QkZBW9rYDktMTPmco6h1BPElW6C6rJBI3lSauL8862UZR	990
45	Out	2016-04-20 14:36:24.977451+08	2016-04-20 14:36:24.977451+08	HCGOtHZJVLocXvUq7ltrFUmacufePF6hRM5Ldee9zTlXOFOV2I	991
14	Out	2016-04-20 14:49:29.488678+08	2016-04-20 14:49:29.488678+08	OHmBrP6X4VmADEWIZAwEJwh4U7KscMC0cxBUNH2Rnpb147JeHG	992
47	Out	2016-04-20 15:51:50.273226+08	2016-04-20 15:51:50.273226+08	saEaeigxcJKnKxmVSAmUbaKDbOKu2bBuCPVp8CokV9Yp6LKYV8	993
53	Out	2016-04-20 18:00:41.694909+08	2016-04-20 18:00:41.694909+08	37hNJJkeEnGQhRpDHxP6iuFIkLc5t8CwFuKZE5DTsTsauinDhD	994
51	Out	2016-04-20 18:01:08.291927+08	2016-04-20 18:01:08.291927+08	JQ8YirtLwnUAlj45JJBWl3zfduOR76eQWmyFfsacg5mSnqX7Ai	995
23	Out	2016-04-20 18:01:28.362894+08	2016-04-20 18:01:28.362894+08	dvldbPY0rf6W7dK5ryxSbeXO7LFeSPN6L9jwZIwRx4x5gIAZH9	996
31	Out	2016-04-20 18:01:36.814239+08	2016-04-20 18:01:36.814239+08	2snZHuvXZOwwUI7FFfXC7VG5axMlXdtZXh9od5MDTIAxaHDpwk	997
41	Out	2016-04-20 18:03:50.212836+08	2016-04-20 18:03:50.212836+08	34GJ9qGWcnAWNhEWVrbr55AG3kXGaU1dZHwi8DEj1OGO6VubNX	998
30	Out	2016-04-20 18:04:45.327733+08	2016-04-20 18:04:45.327733+08	TScehfPFv0jwdIEa1MoG6peMEkrAMEgqgJVOyuduuNrYf6AgSx	999
29	Out	2016-04-20 18:07:03.111943+08	2016-04-20 18:07:03.111943+08	wYnbu2MmCj1sZhC56Bzj6t6xTl5cTXbQ6P21ROmd8nXhVjmbum	1000
12	In	2016-04-21 08:05:17.765189+08	2016-04-21 08:05:17.765189+08	K1gQyAD3mfaO6gn8gFWUseIQMnA9P4vj5cB4mN7Z3hx9OlH51n	1001
51	In	2016-04-21 08:05:31.976401+08	2016-04-21 08:05:31.976401+08	ZtSrKofTx5XtocWygJMntQVrZtdqydeYX7Qrv6LsAsmyWKxCdK	1002
23	In	2016-04-21 08:06:13.069863+08	2016-04-21 08:06:13.069863+08	0WkVOKP2BOgpwEwN5rTQldKYcpsa3Vu33fYR0xTBMA1KOwhToB	1003
48	In	2016-04-21 08:08:45.163373+08	2016-04-21 08:08:45.163373+08	tapE9S4237Xy9aeh2efWp2gqM4n4XcFRD5fNXjPapwZzXEhZsN	1004
11	In	2016-04-21 08:12:54.943625+08	2016-04-21 08:12:54.943625+08	6iPmZlqNpOz5pDAVahFzI6vr5T6m4zAAiawIMneCCeH2rSXSAm	1005
17	In	2016-04-21 08:13:16.692979+08	2016-04-21 08:13:16.692979+08	SSsOKxsQkwQv79V4Rrr644kM6cnd6xQYQJwkHpB3mcytlUwDMo	1006
30	In	2016-04-21 08:13:46.079427+08	2016-04-21 08:13:46.079427+08	JRs4mxgbbmZ2LzLIkd8vguXenJ9lWVaowSsjRZL3Mu5huRze48	1007
27	In	2016-04-21 08:37:27.086455+08	2016-04-21 08:37:27.086455+08	ak29PqSYbx4Cn1fgl6G79c2EKwfKcjRDUULtKnSwlX9ZYoGKuV	1008
41	In	2016-04-21 08:38:01.103302+08	2016-04-21 08:38:01.103302+08	R48TISQxm3hEGCib64PY0C6Alex1ysXQwftF8KDuNu9d7rGDvf	1009
49	In	2016-04-21 08:38:03.769349+08	2016-04-21 08:38:03.769349+08	lwrr6dW4eVxCuuroAzANuXH4BOwRbs7NoxFubmzGHwSDrK22KC	1010
13	In	2016-04-21 08:38:05.263673+08	2016-04-21 08:38:05.263673+08	PFjgJu5GLg9S4xQJs36sJNqlai6ckQo9eXpxSuEnbNGfLhzEj5	1011
45	In	2016-04-21 08:39:56.492609+08	2016-04-21 08:39:56.492609+08	83Txo4gugRLVb14RyWMDKyabevIdA3jI6DHvHxqxPCT0DXRC4o	1012
31	In	2016-04-21 08:41:47.711004+08	2016-04-21 08:41:47.711004+08	POm1zRwI57LoPR2gMJeEH4Qk4dIWpMKFk7GkZD2eKNTkoVRBo5	1013
53	In	2016-04-21 08:49:06.700117+08	2016-04-21 08:49:06.700117+08	P69oqDS9jIV4XGBn0k13PLQs6EOWPDcoJldAy7JiPnlw4xl4hm	1014
47	In	2016-04-21 08:56:12.682551+08	2016-04-21 08:56:12.682551+08	778W0EkPlBcNzv9d68kPqADc7HasLIeSPnyQ2jonuSBuOKYUSJ	1015
14	In	2016-04-21 08:57:33.017644+08	2016-04-21 08:57:33.017644+08	tJT7vZOVSjn8CEuBdwuTkquvkJGJnicg26nxfCT8vIG9VBKA9F	1016
28	In	2016-04-21 10:11:16.740213+08	2016-04-21 10:11:16.740213+08	cs5Xoqq5AennLpt9nZMIhIZxR6AkFI0rC6Q1wG67utuGjnQXNm	1017
29	In	2016-04-21 13:24:54.323767+08	2016-04-21 13:24:54.323767+08	p65P4WVEHlWHdiN4jKKoRFiLWS9v0XipcnGgJluaXRrBAFFtZZ	1018
45	Out	2016-04-21 14:05:42.295651+08	2016-04-21 14:05:42.295651+08	i1oRMKtVHt3zjfm0N6lIhJjZUtojnOIWP7xlSqHikKiV0VVNcH	1019
14	Out	2016-04-21 14:06:10.102494+08	2016-04-21 14:06:10.102494+08	fJaPs5Jio777dWEbIgSZQDt9iueEIGVwa6MTBfBzmI7QoL172T	1020
27	Out	2016-04-21 14:08:13.486144+08	2016-04-21 14:08:13.486144+08	gSgaaPVFdmV8k6E7YPmkPZ3Vzrq1ytVeLCGvbkBEYgNImbPL1C	1021
13	Out	2016-04-21 14:08:32.982567+08	2016-04-21 14:08:32.982567+08	6Pl9vk1mmygHe2Ttx5f9KDqgWdIvyI85hsEdeFQRE7is9Cm7HS	1022
11	Out	2016-04-21 14:18:13.711624+08	2016-04-21 14:18:13.711624+08	Gbf7IBjZ7isFna82EmHeEVlwOu9B1QcH1IOJU8tbqlqeMyhbly	1023
48	Out	2016-04-21 14:32:49.016972+08	2016-04-21 14:32:49.016972+08	G0U2wsv64xVhFXzcqUkk5bWvGsvxUhwkhSmeLikPgG7un7XeaI	1024
12	Out	2016-04-21 15:45:15.56218+08	2016-04-21 15:45:15.56218+08	PgtucAoY8JG63xXpcsYNJFeQASWh780VotQR5FyDYFJbDqRqk1	1025
17	Out	2016-04-21 16:47:31.576236+08	2016-04-21 16:47:31.576236+08	E3GsTPK08R88ww2NN7cNKBcdnqUFgEGvIVnkv9l3atBXpEuDLX	1026
28	Out	2016-04-21 17:03:17.29095+08	2016-04-21 17:03:17.29095+08	afjDJW4mlk22gJYU5TdqXEjikZwfnIEOxxbGUf4GQ6J7PqbULF	1027
47	Out	2016-04-21 17:03:33.637636+08	2016-04-21 17:03:33.637636+08	LsT5bEeYuSq9po6S5a89qYFAfe2H9MXTF1YqFDPAeHJV6PwBz5	1028
51	Out	2016-04-21 18:00:24.480995+08	2016-04-21 18:00:24.480995+08	KqdZ1JE3aNQ8qf9PWOcvZHDrmIHkTHpo8TO9mcCNzcVqIfGn4s	1029
31	Out	2016-04-21 18:00:27.151278+08	2016-04-21 18:00:27.151278+08	jdAwVxFlhi3XXB1vKnXXBXAgORMeFQXy3hvYfBLNuOuSZvNtiv	1030
23	Out	2016-04-21 18:01:23.230471+08	2016-04-21 18:01:23.230471+08	QtTaaq2wVHN3HRkDzPOKmJihlHd9BM5bGXCrPEotVCwmchzc7O	1031
53	Out	2016-04-21 18:01:41.301701+08	2016-04-21 18:01:41.301701+08	wuhfcTwGc9chktFwkdBZYhkVUODU0KsxEadq4a7fjkNUdcROGc	1032
30	Out	2016-04-21 18:04:26.519505+08	2016-04-21 18:04:26.519505+08	xoKiKo7XI7rB56lixpI5V2psWTUwslaqauZuigS1oJDtQxbNnu	1033
49	Out	2016-04-21 18:08:58.162672+08	2016-04-21 18:08:58.162672+08	SJwICSlgQeS0V2u5wdlPeairU9p6Wd0zwwI9P4ppiHpEJkJHO5	1034
41	Out	2016-04-21 18:09:17.017136+08	2016-04-21 18:09:17.017136+08	g3fPu9YkF6PF5MDNVcRKSAcIOv3hDQmsUSIPbrAqwZ72vJPRvq	1035
29	Out	2016-04-21 18:12:26.04917+08	2016-04-21 18:12:26.04917+08	lO2OgQKj8WAuQeNi3yaDpXmwaiHzADqvbsKIId1QABLaphJtgt	1036
17	In	2016-04-22 08:14:17.77629+08	2016-04-22 08:14:17.77629+08	7WRtU1dk1nxrjZk4r3hsTr5oSuWloDfvk6pE8Ty9Hw11Xl4Opl	1037
12	In	2016-04-22 08:16:24.614433+08	2016-04-22 08:16:24.614433+08	IJdN86Ier6sX2cdrqlLqucnvcLhhjXT2q7PyDge5nWdpAHh133	1038
51	In	2016-04-22 08:17:21.059431+08	2016-04-22 08:17:21.059431+08	rxefuI1cykASm1ZC1msergBVWLmEMpGDnusiDtLCeVeRXEdX0W	1039
23	In	2016-04-22 08:27:04.375816+08	2016-04-22 08:27:04.375816+08	CsDONjjAx50EJo9CXM6sZkOECvSpTSMfLZ4iJnsHstVCheOF1V	1040
48	In	2016-04-22 08:30:36.09179+08	2016-04-22 08:30:36.09179+08	7aGWoSRGIuifb4FfmYTgpMZLYHzwW1SebiAQBbgUXP98TOnGxH	1041
41	In	2016-04-22 08:30:47.27682+08	2016-04-22 08:30:47.27682+08	vndW9Bn99KAbylK9CVkszII9QlYE2VVxK9UTKHcTbn5aZPjluU	1042
30	In	2016-04-22 08:36:52.094002+08	2016-04-22 08:36:52.094002+08	eumw4DhcRj8whS6CvQTYt6MygvOPhJtMEfJJs2vKl4ITWOeRo8	1043
45	In	2016-04-22 08:36:52.509665+08	2016-04-22 08:36:52.509665+08	0iEMhtI6KzPEMetfxmhs8SwPvTnaubiuKwH2qZ8BZYOvDJbA6J	1044
13	In	2016-04-22 08:37:54.275298+08	2016-04-22 08:37:54.275298+08	3Dm0chTQIO32JNyaPpAY1j6QfJiHToaW2NXf516OP8PiVOJuET	1045
31	In	2016-04-22 08:39:45.294957+08	2016-04-22 08:39:45.294957+08	TFDZfssOAMDktF8QuDR0bq91ZePsZdM3tZcZSWxcsBNmQVDKie	1046
11	In	2016-04-22 08:43:33.280788+08	2016-04-22 08:43:33.280788+08	LKVTL58kxhPKjItNrMspym0MYQrmkaR6uwZG2h10OQK9iFVabP	1047
14	In	2016-04-22 08:52:59.520169+08	2016-04-22 08:52:59.520169+08	QbCQxkqpXbQxhMvHcxxdxM3IVlX1M9QmkcDiN4YtfzsNLndxlb	1048
53	In	2016-04-22 08:54:10.891607+08	2016-04-22 08:54:10.891607+08	ajye2UQZVmjvZUYmDuploVlhs7VW5H9g17K3bkc7XL37pat3Vj	1049
27	In	2016-04-22 09:01:41.970204+08	2016-04-22 09:01:41.970204+08	oKGa29hXfnonTpvnsWZVd7qfEgH8jmrY789AGqhveWj8NfvFCV	1050
47	In	2016-04-22 09:02:21.286823+08	2016-04-22 09:02:21.286823+08	kpcbWqImy1ZqZgyiqFaYCF5vNSbJhnoSdR3AILwHMW8wD8f4NG	1051
28	In	2016-04-22 09:40:41.303992+08	2016-04-22 09:40:41.303992+08	cZVhVs96Cqu1JYSMilhg35DB1QJhVgw7GSokLxrXolY8K1U3mD	1052
47	Out	2016-04-22 13:04:32.011209+08	2016-04-22 13:04:32.011209+08	jpHw1JNK0s1x0HQo2lmtIbfqjzrF3eSmTjjU37p30q108RoACb	1053
45	Out	2016-04-22 14:03:45.304242+08	2016-04-22 14:03:45.304242+08	3VEiMxiDDmrfZLOJqRQfUQWVRewGo9rre6a04KEH66wfSLyInP	1054
14	Out	2016-04-22 14:04:03.494082+08	2016-04-22 14:04:03.494082+08	yIpVnHAjXytPqYVRYalmrrsoXLAWdxvcGm843InaHh18FWZn7L	1055
48	Out	2016-04-22 14:04:14.415303+08	2016-04-22 14:04:14.415303+08	ayDUnloxISvE5C1EG4W4fnlfv1CVoJqQI4t5pi38CzNHCOVRS2	1056
12	Out	2016-04-22 14:07:07.286226+08	2016-04-22 14:07:07.286226+08	V8pHnkI0G7J7XbBRg1BkAMjWevu9ONBtU1BIlTJ2ac98EKZuLk	1057
11	Out	2016-04-22 14:08:52.485151+08	2016-04-22 14:08:52.485151+08	fV7P2lLwujK6do7n7sHQur33yHNYCjJrEQHGCcD7MXDyMKnTD5	1058
13	Out	2016-04-22 14:20:25.950258+08	2016-04-22 14:20:25.950258+08	u7vxBuEYUQImIWDZmPB1VXXiWt3KOGPINLGYGU7kvOXEukmhAy	1059
28	Out	2016-04-22 16:06:52.322324+08	2016-04-22 16:06:52.322324+08	ifWGP3BSNYilr678dNck8Y9fm4QZlZXUG4ke7v7UUpGMuNUYk7	1060
17	Out	2016-04-22 16:19:19.881335+08	2016-04-22 16:19:19.881335+08	JsfSXRWx1HXZlncWSjSZEwPUJKrmtctDUZf22B03TXbFLFlnyE	1061
51	Out	2016-04-22 18:01:08.342192+08	2016-04-22 18:01:08.342192+08	NCBmgT8YH2ABFekthm6hpZFRoagaOfolrzZYTh7kiHvxwgrdTx	1062
31	Out	2016-04-22 18:01:19.801216+08	2016-04-22 18:01:19.801216+08	LJXakLCQwa6lMxkvWFddzMuvJrcCV6ArPgS93eayEgkaeVWBkA	1063
30	Out	2016-04-22 18:02:40.013262+08	2016-04-22 18:02:40.013262+08	okWjgpaJ26PBxnsQxv5XuJEftsBR3wbrh7bNxCgyI6BGt4gryl	1064
23	Out	2016-04-22 18:04:00.892552+08	2016-04-22 18:04:00.892552+08	Pt5dZyWlQZh1RP93m6FT6XZHnUKVMKHlEMPnKvZkWHlxgu1T1F	1065
41	Out	2016-04-22 18:06:38.339303+08	2016-04-22 18:06:38.339303+08	x7mXOb2i7N3N9HjZ64Vfo2wbzdW18XG5e3c3eell2o9C6slCxH	1066
28	In	2016-04-25 08:40:49.911384+08	2016-04-25 08:40:49.911384+08	qmJnOJSuKZSaf7dI9Jwu4zjECo7w14ErqXgFq8ABibkNiPgrhd	1067
23	In	2016-04-25 08:41:13.704341+08	2016-04-25 08:41:13.704341+08	mmdW0pL7mMC1E3YuIP3Sal4L9mkpeSTRE7xEwJMjfXktaJotir	1068
12	In	2016-04-25 08:41:31.712721+08	2016-04-25 08:41:31.712721+08	MJdQemDPdsr7K6EIKBbguHEfBpy0ihr51WVfJi5wbw3v2HFNSq	1069
17	In	2016-04-25 08:42:13.546889+08	2016-04-25 08:42:13.546889+08	4N8I2J81KqiCvjiQP2AVxlR1hUJwrlnu9vDBFLCZCul7eTY5Vh	1070
47	In	2016-04-25 08:44:23.481088+08	2016-04-25 08:44:23.481088+08	ZTT2UBVn8NZvIhqVs6q5f31RAfuijQQKttLO5rCDEl8XTz3N6t	1071
27	In	2016-04-25 08:48:35.8417+08	2016-04-25 08:48:35.8417+08	SlwTC787psXGDRAYoEP1RemZBGZEdf86R6YdDhk3aIJmjSLZhl	1072
41	In	2016-04-25 08:49:16.097985+08	2016-04-25 08:49:16.097985+08	a9PNibdIpHxxMP4v3HcnKD7d0q6MPn70wXNf81yxHwwdM1ZPIC	1073
30	In	2016-04-25 08:50:19.71634+08	2016-04-25 08:50:19.71634+08	DcPKFQALla9ta6QwlZxkXFhUt4UTTmfgP50fVB1IkABLGcI3BG	1074
29	In	2016-04-25 08:50:39.983132+08	2016-04-25 08:50:39.983132+08	niVVDPahr3UXjtdjZ9uaQfkc11EJ4PZr85NLUx3M1XtkRXV1gQ	1075
11	In	2016-04-25 08:51:04.448435+08	2016-04-25 08:51:04.448435+08	b76Mj7NxQROzJW5grZeuvfSpQtNvu3LWARstYGsxhGx0m3gebL	1076
51	In	2016-04-25 08:53:03.442342+08	2016-04-25 08:53:03.442342+08	ZX12NRvkNrniOxAHsiXkgF2fFohvTKH4rI6Fj2z7tnpIl1aej8	1077
31	In	2016-04-25 08:55:16.18937+08	2016-04-25 08:55:16.18937+08	PQNR6cGnYj8pn09tFsvF0q3q9oqjTart1EL7qbuPL3F94O3JHz	1078
45	In	2016-04-25 08:55:46.543783+08	2016-04-25 08:55:46.543783+08	YHpb8zRyiuZaoboAifkd57gKGkhJ4yJdG9FO9gNrbxSQYHaHwL	1079
48	In	2016-04-25 08:55:48.645398+08	2016-04-25 08:55:48.645398+08	u2SbLiM42Q3L4KUJid06Vb4y2cGctDynEQPa9meBDhWH12ajfa	1080
53	In	2016-04-25 08:56:21.164889+08	2016-04-25 08:56:21.164889+08	pBDtAFWPrPcqEqHdRRQ5cdm9unAVXp7N1JHBYmbQDDHQ5Z5V0U	1081
14	In	2016-04-25 08:56:37.24013+08	2016-04-25 08:56:37.24013+08	bc8Ol3CvZjlf7nyOyXCayOnGpsptOpPzSXNEaZAAKvpRjopiN2	1082
13	In	2016-04-25 09:27:56.617747+08	2016-04-25 09:27:56.617747+08	JMQ7cGySANIZNk7kyhL9rf6h7pXwYtyrGQysgxLqMdQjOXUNGp	1083
49	In	2016-04-25 12:52:38.669416+08	2016-04-25 12:52:38.669416+08	W8UbpbRNYzHYrXxpQenlVAPvtmTOAjEgriIhKj5sjMRbuPRL4F	1084
12	Out	2016-04-25 14:12:42.435709+08	2016-04-25 14:12:42.435709+08	7ZPWVJJygTiuAadSIxCNqvjIXehyzlE7LedrwwqeQZZbAD4SBH	1085
47	Out	2016-04-25 16:02:34.899161+08	2016-04-25 16:02:34.899161+08	p2DZKkD3jDoyKBcw2atsFKSovc205CHuFUTZFhcytRxEcaBeB5	1086
27	Out	2016-04-25 16:19:02.123638+08	2016-04-25 16:19:02.123638+08	XQP1FLdGLiTcdh78ILouKjMIxxt9c5EBVdBkzo1LYUxCC5KUQ9	1087
13	Out	2016-04-25 16:42:14.925248+08	2016-04-25 16:42:14.925248+08	Olsk4qiw0M2EWXshIrXJD5mCIyGbTglrSecWWLTWhVkE4cvLVT	1088
11	Out	2016-04-25 17:06:40.22575+08	2016-04-25 17:06:40.22575+08	eiYRuqRBTurEmKtPqPkKvRqgfuJbGo5uXeMSVndyhWDUq7thWd	1089
14	Out	2016-04-25 18:01:03.506746+08	2016-04-25 18:01:03.506746+08	3S6s9lnSN4HTyo8LHd9vbqRoLIvF0Ss3tyw3jkV8nmbmbi8tMH	1090
53	Out	2016-04-25 18:01:03.653685+08	2016-04-25 18:01:03.653685+08	ox9GmUZijZBcc5bZ8LJdT8Q4u3n4w9Ll8U2uybdiBoLotvN3Hh	1091
61	Out	2016-04-25 18:01:06.922924+08	2016-04-25 18:01:06.922924+08	gkp7okAcn7l9stduocWSKhHfWBbtEsbtdQ2SBC5zJr9Blm6ZPc	1092
31	Out	2016-04-25 18:01:42.619431+08	2016-04-25 18:01:42.619431+08	2jKJPqU1kitLcXme0xq6wAw6LisRII4L2OeQF9RzrLLUs89s50	1093
49	Out	2016-04-25 18:02:15.985041+08	2016-04-25 18:02:15.985041+08	y3Av9Ve2wxK2JLQxmf7EfyY1TR9cKEcJHmFPIuRGrlIB7i9tOG	1094
30	Out	2016-04-25 18:02:57.592938+08	2016-04-25 18:02:57.592938+08	74Eg5h8EKSSxlik193vaJnLbySJ8MhNTlbAqKH5ejWcVGMWOQR	1095
41	Out	2016-04-25 18:03:16.802483+08	2016-04-25 18:03:16.802483+08	yjFLKEneLAMjd9Lmzf55KobwJrJpGjHFSWZnkNS7XopBxBxwq3	1096
29	Out	2016-04-25 18:03:17.581383+08	2016-04-25 18:03:17.581383+08	2Bqd8BVR1lAI1coaQZxsgWhWgeifcZhekZIsjnJkZT3Z7rAXR9	1097
48	Out	2016-04-25 18:08:53.762218+08	2016-04-25 18:08:53.762218+08	P8e7fMlN1Owj3hJKa38tnhNpHUhR19aRHFXwbKKchIMkzf5ZiE	1098
51	Out	2016-04-25 18:11:36.354517+08	2016-04-25 18:11:36.354517+08	TWuqMCL4eMDFmUULR7emjM4674lCdUQ71LyNYJRDfeSS9wna4S	1099
28	Out	2016-04-25 18:16:51.729942+08	2016-04-25 18:16:51.729942+08	NnpRtwVf99BZGBvFYTYzgEe9gn6UOAwlwmDrihXsqiS8tNNSrv	1100
45	Out	2016-04-25 18:17:14.686754+08	2016-04-25 18:17:14.686754+08	SY97hpunKJxH5u4Imn0Kfr28ywWMPOHrwRyeHtScDQtILxa8la	1101
17	Out	2016-04-25 18:25:17.574674+08	2016-04-25 18:25:17.574674+08	SRSUZRR6nqU6iQWh5ocXQpxL8JJiR5KtWmO7EpD2gg8P8e8DTj	1102
23	Out	2016-04-25 18:33:51.63577+08	2016-04-25 18:33:51.63577+08	ktZiFi2YRTdlNAXmHlcTnJAviIapV3aGxAyDs1lKUP6rZeepQH	1103
17	In	2016-04-26 08:20:16.778447+08	2016-04-26 08:20:16.778447+08	JEaUAJmj9HnjXktVxmWj718DshrYXIorWPMfi8PrPDbwxVSwIy	1104
41	In	2016-04-26 08:24:31.957329+08	2016-04-26 08:24:31.957329+08	fP1odtWVS4mHvJgHyPQPHpcsmaPFXhFD7F2k9YFbc3sYMZpLzG	1105
27	In	2016-03-07 11:06:21.192923+08	2016-03-07 11:06:21.192923+08	lpgC7j2wSPgRqPENpnF6HZuA5lMaSUBEKsQRcSO5r5WiUk6KYK	1
28	In	2016-03-07 11:06:56.305992+08	2016-03-07 11:06:56.305992+08	QquL0z7NaZrlnBeEcHg1MX6sHZdMtChK3cf3blQCLIx9TcN6s3	2
26	In	2016-03-07 11:11:49.474127+08	2016-03-07 11:11:49.474127+08	7FbD8rmlFgxw11Yg4BSUMnmKwGwKMpNU5yhDrUx6Bv3Cwcs1mL	3
12	In	2016-03-07 11:11:50.438158+08	2016-03-07 11:11:50.438158+08	VA9HU6XRQuIoONn6aeaYllUoxQRqRECvOLEtSlLsgdg51UBaAl	4
23	In	2016-03-07 11:19:41.435441+08	2016-03-07 11:19:41.435441+08	9vXdkV4CMVQZSoufiNS4F9hwEhRPIbBRWi5HE9TaetA7i5mRRF	5
45	In	2016-03-07 11:27:21.389282+08	2016-03-07 11:27:21.389282+08	VhODebu61DhCeEujV9tyjYrtfayS2QiX86jmiesjrZvXnqHK0A	6
14	In	2016-03-07 11:28:46.282855+08	2016-03-07 11:28:46.282855+08	IjiBdOlcrn3ZLBf5xOjq8bQ49EuQYuarfK2JinvaczAwBp39Em	7
31	In	2016-03-07 11:29:32.976929+08	2016-03-07 11:29:32.976929+08	0MOQQXeLxEHZ5vs8FbvCCYBMVNCYWRKWnjwEHbZFpqnumh33Jy	8
18	In	2016-03-07 11:29:49.825062+08	2016-03-07 11:29:49.825062+08	EVWQr2m4aJVupJemXvO7BExy9kgCnzB2VhSNjFRKYwGOGuBmpa	9
29	In	2016-03-07 11:30:13.419541+08	2016-03-07 11:30:13.419541+08	t1or0ydgBRgLTC3vZnB28jyN9FIK28uw9joAhSqstXENjHJK5U	10
30	In	2016-04-26 08:29:19.459334+08	2016-04-26 08:29:19.459334+08	kH6MAswZ8UHNhOcj9mIOOtRHSnrI9qXs8dGIVDreh92PXeAgRR	1106
13	In	2016-04-26 08:29:42.594916+08	2016-04-26 08:29:42.594916+08	5pLW7nJy6SpdLxHbGno9RWITvp86VZXaPt7WhQUnsKREIjpYWe	1107
59	In	2016-04-26 08:31:45.923468+08	2016-04-26 08:31:45.923468+08	gxByR8oZEK9luXf24NSYALscZBLPjs4QqGPINErbY1NTY2UcPw	1108
55	In	2016-04-26 08:32:20.911639+08	2016-04-26 08:32:20.911639+08	BZH5CqFXGyQLPHaoZx3RZaTw42yYeNVqwmu9dAgt97FYOqNxoQ	1109
58	In	2016-04-26 08:32:24.613312+08	2016-04-26 08:32:24.613312+08	QO1sL5uKdZh9PeuLnYVVTeciD1YbyN1Om3I78CRll9tCnpWbO2	1110
12	In	2016-04-26 08:35:03.496862+08	2016-04-26 08:35:03.496862+08	7rhjauk9WjXX8JaQRhcsTP1OaoD8RbAYTrI4m2DJljqt3QKU9w	1111
23	In	2016-04-26 08:40:04.244572+08	2016-04-26 08:40:04.244572+08	NcMO1wDE5epFDJ7UNtWaCJK3DOTXscUFFqdGnrUtVL9ieGD2Ak	1112
54	In	2016-04-26 08:40:32.675869+08	2016-04-26 08:40:32.675869+08	cM3wPGKtnDWJSmA73xxXrUr1DWHQYQABnE8DUT7Igdb9QlGSjE	1113
47	In	2016-04-26 08:42:05.69466+08	2016-04-26 08:42:05.69466+08	0birbuOsLxJW97jHKEkRWQ68ZVtpyd4yEmqqhGj3D3ZMAJdUXO	1114
51	In	2016-04-26 08:45:13.202318+08	2016-04-26 08:45:13.202318+08	v4o2COX6EWiIVx4NolcXpqaODkiqFGEBK3DWRlcfIMxoK3B8oo	1115
62	In	2016-04-26 08:50:51.68625+08	2016-04-26 08:50:51.68625+08	feeG3r1liG2wRM1fsSQV8jr7XC9iKxX0cCGg5IRnYTk0olfhE7	1116
29	In	2016-04-26 08:58:19.447925+08	2016-04-26 08:58:19.447925+08	EMp6TNHc7bbebEqsuvAMiipTieFONTVapLgJjxwpZYUBmM4gIE	1117
36	In	2016-04-26 09:00:08.539633+08	2016-04-26 09:00:08.539633+08	31wsUfXk5tEZV4vBOe9KUiszufMxMdCPe9IAoottj8TECPQa4Z	1118
60	In	2016-04-26 09:03:21.028188+08	2016-04-26 09:03:21.028188+08	uYJnYDTuCoYOEDXVNMLHF5PiJb8jCCJ7kcuJpOD2DlQRywwMJI	1119
31	In	2016-04-26 09:08:17.470316+08	2016-04-26 09:08:17.470316+08	dYN3IgeQQqbkxMNsfDHsFUfeuebs1uBeTYhlFMCfDnQBAm4p0L	1120
53	In	2016-04-26 09:09:36.323954+08	2016-04-26 09:09:36.323954+08	jFoOtk3Vc4RniuMPgalrGyfg9pTEgTYPiOoc8r8kvZYdTu4AVo	1121
56	In	2016-04-26 09:21:50.641071+08	2016-04-26 09:21:50.641071+08	3lniSwYvBFPje88TkGLs1GSauvUx60n9mbrFYRBjgaTLiboTrA	1122
28	In	2016-04-26 11:54:19.763352+08	2016-04-26 11:54:19.763352+08	MtQoTLkyJqy7zlir1HIC1ymUKW790yJMrjBM5vKOmJVm5Ee6Vw	1123
49	In	2016-04-26 13:00:44.394943+08	2016-04-26 13:00:44.394943+08	IWv51Gb8Pb7ixySALX5fvrzRe5gJBCGTiCYjSArslybkx4tJaz	1124
57	In	2016-04-26 13:05:58.992231+08	2016-04-26 13:05:58.992231+08	yXrxyW3foEq5hZHGJjQBbC9Dw7HqQrpPOhNNDQ32ft7NTOdm83	1125
27	In	2016-04-26 13:58:15.708662+08	2016-04-26 13:58:15.708662+08	xjF7wCEE3e6s3UZQsnrvpWpwtJLW6Ta3DpAB2OO53Uw6yXWqKO	1126
12	Out	2016-04-26 14:17:42.658662+08	2016-04-26 14:17:42.658662+08	mBuc8ovUL2xv5BlGMnekrgFpmEMJ5hhrscU1QQUlSShYdSnzGS	1127
13	Out	2016-04-26 14:36:16.487097+08	2016-04-26 14:36:16.487097+08	k99yxwDKGI2xBuafu16QnYsU7VxuVENGMWFLTSfjlhhvcIbYKh	1128
17	Out	2016-04-26 16:30:32.609016+08	2016-04-26 16:30:32.609016+08	x7GqcMMaHroe8BBNWdqCNbt5XWO95hq3p6tRTG2j9qOH2ZeYDV	1129
47	Out	2016-04-26 16:34:38.066929+08	2016-04-26 16:34:38.066929+08	ja7efeB4nGleKbkE3EU5xdvMuxvZV84GiBuPp6SdMEIgp3tsHO	1130
28	Out	2016-04-26 16:53:05.496249+08	2016-04-26 16:53:05.496249+08	xF2tbwrXWOfaeOmYnceGG1VZhLcbEt0C937kzyIWNx71MtaAWF	1131
60	Out	2016-04-26 18:00:09.204857+08	2016-04-26 18:00:09.204857+08	QmGvLxHxZVrZh1colbn48A1FBN8lYe1yRHumEClnhdNPeyEQa1	1132
27	Out	2016-04-26 18:00:47.211363+08	2016-04-26 18:00:47.211363+08	TiBUxNs69Qk9PCQKyeWkSENpd2orSPsv94Q6RJCakwjA9AU8o2	1133
53	Out	2016-04-26 18:01:48.398144+08	2016-04-26 18:01:48.398144+08	sHGH6tJulkLegUj7aBQmkBkULtep2Sruj8Cp2VlnG7TwaD4BOU	1134
49	Out	2016-04-26 18:02:21.396687+08	2016-04-26 18:02:21.396687+08	y9fjd1dIqfkhbUpnLrI7gYDAVoMZ0k4ytjiXkMpa2aJd59RP1j	1135
62	Out	2016-04-26 18:02:26.108485+08	2016-04-26 18:02:26.108485+08	WhIjrnYEMZyQYsAHPudFVfpnJuwkKxUqflbXZAlvjjNIcXZ3RD	1136
61	Out	2016-04-26 18:02:59.699153+08	2016-04-26 18:02:59.699153+08	Iws7kC2hwMgRDMDotmyejiP612da45oM2hTmtVUqsBI6XVuRIt	1137
31	Out	2016-04-26 18:04:09.226406+08	2016-04-26 18:04:09.226406+08	62cV8dWlFbq3wrkReewAWpLovsJqKbkPdOul2RXH3NK0F5RujO	1138
51	Out	2016-04-26 18:05:04.549277+08	2016-04-26 18:05:04.549277+08	5GEQ5AIO1c1l2eAwQCPwSRKmRarsVbHZrVzwfILhuMTx1duRpK	1139
30	Out	2016-04-26 18:05:17.457805+08	2016-04-26 18:05:17.457805+08	OIli5DJw7oYOORuOOagkIb7lZ8PUYEowWafboyYvn8KCZFaxpH	1140
29	Out	2016-04-26 18:05:32.080811+08	2016-04-26 18:05:32.080811+08	h8sosSwIxVWmS3N8eC7E8uMS6vggtWxbeqQXJNpHsM4LPSS4eZ	1141
55	Out	2016-04-26 18:06:14.128951+08	2016-04-26 18:06:14.128951+08	ImUeFaavHUSF676XePuUgnql8FDaKsAcfeItFspWNIlTPq14Gv	1142
23	Out	2016-04-26 18:06:35.49583+08	2016-04-26 18:06:35.49583+08	YxiOirewSyocbUItOXmE4AXodwge2waZuJydBdadcPGEtY8I5t	1143
56	Out	2016-04-26 18:06:37.151567+08	2016-04-26 18:06:37.151567+08	X945xh2eM3bvdWFcAQGk3rAJ64rEMw8t6Cx4t0iF4JBgpRJzqZ	1144
58	Out	2016-04-26 18:10:00.121439+08	2016-04-26 18:10:00.121439+08	ktRtDXx5lL2tF86DCzDtFHERx4rI4iqncJiqqgvc2xWH6cUIch	1145
59	Out	2016-04-26 18:10:41.241086+08	2016-04-26 18:10:41.241086+08	CryQJwUBFXt6MWP5NGlJsnHO5N1YfdGrVFIoClyRKsXgQvknCW	1146
54	Out	2016-04-26 18:11:13.229581+08	2016-04-26 18:11:13.229581+08	85KPTPmUxT8ELdTcSfPR7jLdQlaBZmhhr36LStpQMyfhc9L5oj	1147
57	Out	2016-04-26 18:11:50.462863+08	2016-04-26 18:11:50.462863+08	WvTrZtdA5Dwmtop1AIuziHxOyaXKfM4CIY4rRh2WuyJon9pxRk	1148
62	In	2016-04-27 08:24:11.317967+08	2016-04-27 08:24:11.317967+08	wB2vZ1W7LCTPOlxTdPBfw6eGuTPkQrVO3XKcZpju2DKQxItbh4	1149
17	In	2016-04-27 08:24:19.193593+08	2016-04-27 08:24:19.193593+08	HeAwu5PKqqCMEFtYrTOaNRnhrl1kNipeN0bI61dvqpI65Cewf3	1150
61	In	2016-04-27 08:25:11.3097+08	2016-04-27 08:25:11.3097+08	X4UKlM6m7UVw9swkB3loyceHijUNfARDEvXzHelO8HLH9J2KMm	1151
30	In	2016-04-27 08:25:27.609572+08	2016-04-27 08:25:27.609572+08	9LQnc9W7WCHwPVsxVAbHZkYu2hE33aqCuGyYPVfviws8Tl6xwh	1152
13	In	2016-04-27 08:26:29.81412+08	2016-04-27 08:26:29.81412+08	GVSnQTWeXYFNkAeji4GOzyLs7oeDmbu27NqYqNDOvSlgcQRLUg	1153
55	In	2016-04-27 08:27:05.823959+08	2016-04-27 08:27:05.823959+08	iTf4Nms2zfduhkHYJ8vWWrxIYai0vDgegMi39b59Hi4yULXnUT	1154
56	In	2016-04-27 08:27:18.0465+08	2016-04-27 08:27:18.0465+08	J1LIJus2uoEbTuyCy8n4H5mL4Hhb5B5OCRgVMZXGNlsqgq3eyp	1155
59	In	2016-04-27 08:28:09.534734+08	2016-04-27 08:28:09.534734+08	iHuWcynKasVfGh7wDTWjjtVckCTnqTdZjY6MXtg8mCo3tv07PW	1156
23	In	2016-04-27 08:28:29.214999+08	2016-04-27 08:28:29.214999+08	q9QMlBYFyPicySB6pjzWrmigpccpj2MaBnwwyUCxtuatNlzDVz	1157
58	In	2016-04-27 08:28:49.241351+08	2016-04-27 08:28:49.241351+08	jNlS3b5fRnhoOsbKpap2Xjv8dKtdXPcGmPip1nVSbDHy6sKuSA	1158
28	In	2016-08-10 21:53:34.5843+08	2016-08-01 08:00:00+08	IFsY8r8pyDbhySJ0ycMmWtsQ7qwrQc8WfosdWqHItgpfwwWkNg	2155
28	Out	2016-08-10 21:53:34.5843+08	2016-08-01 18:00:00+08	IFsY8r8pyDbhySJ0ycMmWtsQ7qwrQc8WfosdWqHItgpfwwWkNg	2156
28	In	2016-08-10 21:53:34.5843+08	2016-08-02 08:00:00+08	14xHrLDemwDwrSGD7H8aJLX8ma8Z5ozwgk2Nv5pVpqFU8KX4RT	2157
28	Out	2016-08-10 21:53:34.5843+08	2016-08-02 18:00:00+08	14xHrLDemwDwrSGD7H8aJLX8ma8Z5ozwgk2Nv5pVpqFU8KX4RT	2158
28	In	2016-08-10 21:53:34.5843+08	2016-08-03 08:00:00+08	jq5lhphEcKceXBy6Kx24glGafhrA3gtbLmCqPhssrIMCHA9Qvz	2159
28	Out	2016-08-10 21:53:34.5843+08	2016-08-03 18:00:00+08	jq5lhphEcKceXBy6Kx24glGafhrA3gtbLmCqPhssrIMCHA9Qvz	2160
28	In	2016-08-11 17:32:07.541598+08	2016-08-11 17:32:07.541598+08	ZWHIWJjkgxwZ-2yG9MTB4O7czZpsyEAwzgdt-xPf3jc2lKJvwA	2185
51	In	2016-08-13 06:59:19.435413+08	2016-08-13 06:59:19.435413+08	yqxDcphVjCv1r-emlAlnIZ5Lzrxuf0GPqdrCDIwXj1YL0a7lLt	2186
28	Out	2016-08-14 09:53:14.646766+08	2016-08-14 09:53:14.646766+08	undefined	2187
28	Out	2016-08-20 21:13:11.366965+08	2016-08-20 21:13:11.366965+08	undefined	2189
28	In	2016-08-22 08:44:29.673159+08	2016-08-10 12:49:00+08	1k2etzoK1DQCVzLCPUkWtYAiRSHib3tdovrS3RB4tqHm_r_Oki	2193
28	In	2016-08-10 21:56:05.923935+08	2016-08-01 08:00:00+08	8xOMTFmruTu3ISqstfjUz9DaaqJKvIet5t5Oyg3hznY83ComiM	2161
28	Out	2016-08-10 21:56:05.923935+08	2016-08-01 18:00:00+08	8xOMTFmruTu3ISqstfjUz9DaaqJKvIet5t5Oyg3hznY83ComiM	2162
28	In	2016-08-10 21:56:05.923935+08	2016-08-02 08:00:00+08	zf2t7ul8mOxdDhFqSfJpxVmiUKhqBHB1m3ikmJgMYUqZztFHOP	2163
28	Out	2016-08-10 21:56:05.923935+08	2016-08-02 18:00:00+08	zf2t7ul8mOxdDhFqSfJpxVmiUKhqBHB1m3ikmJgMYUqZztFHOP	2164
28	In	2016-08-10 21:56:05.923935+08	2016-08-03 08:00:00+08	cOc5fewRLqYunhz5vUNhMq6Xk6lx3YqTkGMFl8XuntfQQSM9mX	2165
28	Out	2016-08-10 21:56:05.923935+08	2016-08-03 18:00:00+08	cOc5fewRLqYunhz5vUNhMq6Xk6lx3YqTkGMFl8XuntfQQSM9mX	2166
26	Out	2016-03-09 12:02:59.806342+08	2016-03-09 12:02:59.806342+08	23423423432324234	88
28	In	2016-08-17 11:50:57.868925+08	2016-08-16 08:00:00+08	23423423432324234sadfasdfasdf	2188
28	In	2016-08-20 21:14:23.723432+08	2016-08-20 21:14:23.723432+08	iyEH78fobkUQkg_UqsahTAjuuHTWgVmys0fz8uZkPR98570wzb	2190
51	Out	2016-08-22 20:58:25.808295+08	2016-08-22 20:58:25.808295+08	undefined	2194
28	In	2016-08-10 21:56:31.126614+08	2016-08-01 08:00:00+08	pF0nhHnNFVcVbLXPERoeQ2RJDa1ANqT2vJfQPGdSc3n3D8JHPv	2167
28	Out	2016-08-10 21:56:31.126614+08	2016-08-01 18:00:00+08	pF0nhHnNFVcVbLXPERoeQ2RJDa1ANqT2vJfQPGdSc3n3D8JHPv	2168
28	In	2016-08-10 21:56:31.126614+08	2016-08-02 08:00:00+08	D8Etij85Tfg42UfUoLwKHYVsSu8dmJvpFxYoVWhozBhpVAA9Lw	2169
28	Out	2016-08-10 21:56:31.126614+08	2016-08-02 18:00:00+08	D8Etij85Tfg42UfUoLwKHYVsSu8dmJvpFxYoVWhozBhpVAA9Lw	2170
28	In	2016-08-10 21:56:31.126614+08	2016-08-03 08:00:00+08	s8yGiVZrQkPzhEIBMofKGQgjno4lokEUi2YFNywbY9R3DZ2NBX	2171
28	Out	2016-08-10 21:56:31.126614+08	2016-08-03 18:00:00+08	s8yGiVZrQkPzhEIBMofKGQgjno4lokEUi2YFNywbY9R3DZ2NBX	2172
28	Out	2016-08-20 21:14:32.565635+08	2016-08-20 21:14:32.565635+08	iyEH78fobkUQkg_UqsahTAjuuHTWgVmys0fz8uZkPR98570wzb	2191
51	In	2016-08-25 11:25:51.116912+08	2016-08-09 12:49:00+08	4gAhC1hzGkkdob4CUbmoc6KZHuSYy98CqJU1K9BpuXDT6Iu-UR	2195
28	In	2016-08-10 21:56:48.63663+08	2016-08-01 08:00:00+08	sTgPJC5Ihn2xHlPntYXYaP3HN0I76WLonp2xsx3PYtDgUQHCme	2173
28	Out	2016-08-10 21:56:48.63663+08	2016-08-01 18:00:00+08	sTgPJC5Ihn2xHlPntYXYaP3HN0I76WLonp2xsx3PYtDgUQHCme	2174
28	In	2016-08-10 21:56:48.63663+08	2016-08-02 08:00:00+08	j8OQQ76xwPNHvi16fwq3rHvHT3hYDmumk8005wmp9xvvTmpzZU	2175
28	Out	2016-08-10 21:56:48.63663+08	2016-08-02 18:00:00+08	j8OQQ76xwPNHvi16fwq3rHvHT3hYDmumk8005wmp9xvvTmpzZU	2176
28	In	2016-08-10 21:56:48.63663+08	2016-08-03 08:00:00+08	mL3MncopZAk6fxS7EaPV3vzf2tHX9D7lPyw0QYfoZEi21yz3OD	2177
28	Out	2016-08-10 21:56:48.63663+08	2016-08-03 18:00:00+08	mL3MncopZAk6fxS7EaPV3vzf2tHX9D7lPyw0QYfoZEi21yz3OD	2178
28	In	2016-08-21 13:58:17.97482+08	2016-08-09 08:00:00+08	FQfqv9e9f9UEVt9SOiX27_pusHBIKzHooXQU532kcW_6n7YaqT	2192
51	In	2016-08-25 11:30:29.672453+08	2016-08-16 11:29:00+08	mdPIIBPyQUEbsng7xin_oKrm-w5-4Zhqb48VGXruQ4GgrYoZeL	2196
28	In	2016-08-10 21:57:35.058183+08	2016-08-01 08:00:00+08	UGysMye1C1EdGqbMqZAGQl3cUDPzebYwfKcq86hAvmb2Q3C4QD	2179
28	Out	2016-08-10 21:57:35.058183+08	2016-08-01 18:00:00+08	UGysMye1C1EdGqbMqZAGQl3cUDPzebYwfKcq86hAvmb2Q3C4QD	2180
28	In	2016-08-10 21:57:35.058183+08	2016-08-02 08:00:00+08	AdZJJJ7MdkbMy10kvOA5dDGE50qrHZrF2EOBOKNpsm1gbpEM4D	2181
28	Out	2016-08-10 21:57:35.058183+08	2016-08-02 18:00:00+08	AdZJJJ7MdkbMy10kvOA5dDGE50qrHZrF2EOBOKNpsm1gbpEM4D	2182
28	In	2016-08-10 21:57:35.058183+08	2016-08-03 08:00:00+08	SNgXKES6QWfsmUH7B0ORSdGrN3FZEnyWySr7W83lUWR4pYzqOE	2183
28	Out	2016-08-10 21:57:35.058183+08	2016-08-03 18:00:00+08	SNgXKES6QWfsmUH7B0ORSdGrN3FZEnyWySr7W83lUWR4pYzqOE	2184
12	In	2016-04-27 08:29:11.88815+08	2016-04-27 08:29:11.88815+08	w1ts9XD3BjSo1FDj5EWag8nx8tpRoIblJVeS3rVFcy3cEGMJUt	1159
41	In	2016-04-27 08:29:13.723016+08	2016-04-27 08:29:13.723016+08	tB2h99bybRHDDbir4mkZ1MY4zlLM5pGy1IgARI93jRGw2yp6lZ	1160
31	In	2016-04-27 08:36:12.536775+08	2016-04-27 08:36:12.536775+08	fmwDrwyCJ42Z34qjEI3OLmobjqbZwN9cA6p13pEMtGvwKmgY5j	1161
54	In	2016-04-27 08:36:52.700609+08	2016-04-27 08:36:52.700609+08	vRVl3FceoZ1xCB42D7rQTlgPi1CPZH8VieHlttPiTRgfckipsa	1162
27	In	2016-04-27 08:46:13.699325+08	2016-04-27 08:46:13.699325+08	GMMwk5xwUXEc3vHKhBE7tiYaOBM71EhHa4EM9CIdjWGnTX8BiM	1163
29	In	2016-04-27 08:50:33.34739+08	2016-04-27 08:50:33.34739+08	Ic5qET2aa3oIKPLYlUk48VbOI4vQFemXIrOVKQ6uTuCnKYM638	1164
53	In	2016-04-27 08:53:03.273148+08	2016-04-27 08:53:03.273148+08	ABdlZvpUM5A9cR01xKR4FuyRiJ06Q3EaEqMmmCI9HRHttHuqcM	1165
57	In	2016-04-27 09:15:54.544293+08	2016-04-27 09:15:54.544293+08	urHtJ0EJ6dMKEaBaNxmf747Ox1frrIEmAVhTVunbZAvnk7O85B	1166
28	In	2016-04-27 10:55:56.546748+08	2016-04-27 10:55:56.546748+08	nCFvaDwG6oYKbipJDKE1vnBrbvy044BrFRnpej6kYe4ANtTaEh	1167
47	In	2016-04-27 10:58:46.370281+08	2016-04-27 10:58:46.370281+08	bBVl37h27l5IdKjQAOBG9jtDtI7NsL5UWaGZhwboig7M1qmBFx	1168
49	In	2016-04-27 13:45:34.990615+08	2016-04-27 13:45:34.990615+08	QNgLbacixV43zaeGAMDlBvRIIS95dO34ljPNK35JY9MYj1ntM1	1169
12	Out	2016-04-27 14:00:19.794185+08	2016-04-27 14:00:19.794185+08	fXw7pFZxKDMNI87hVRkakIj7qT8fOVg33dBrtkqEyCaGKhxp9i	1170
27	Out	2016-04-27 14:55:37.433724+08	2016-04-27 14:55:37.433724+08	Qt1A1sdAX1eE5hsGZl1PzycaGwIEmRwDLxMNq0WO2Bc6sUMSHN	1171
17	Out	2016-04-27 15:16:58.211286+08	2016-04-27 15:16:58.211286+08	rGMUqbR9pEamRvknJaopyp1bwt6JMNfEd2iVdAeTOFGpC0dVbS	1172
47	Out	2016-04-27 16:00:27.898276+08	2016-04-27 16:00:27.898276+08	LZIMBFGHXceEqJFZnsjSN8hcxtdbOE4joN60cNIAzwNqFdQ4WA	1173
53	Out	2016-04-27 17:57:10.346007+08	2016-04-27 17:57:10.346007+08	WtIEWG8ArWOwGDJNDvjV6jSUah71leBHXTV4jdEbAdYRqrn4nY	1174
31	Out	2016-04-27 18:00:17.90106+08	2016-04-27 18:00:17.90106+08	ZtI1OsiVtUA5mhXImHv1s7eQYUJMY7u81C9P5suxN539maSYrO	1175
23	Out	2016-04-27 18:03:01.181707+08	2016-04-27 18:03:01.181707+08	ZkVEC3iUPHbKPcWY2bQvZn1cxnEPM6nvqJA2MsXlA96Zkc8mEY	1176
41	Out	2016-04-27 18:04:00.829197+08	2016-04-27 18:04:00.829197+08	inMjRKXejtkXpbpzeCrBx2K4b5gjruIbieLAxsohlZFbB5bpHT	1177
30	Out	2016-04-27 18:05:36.486832+08	2016-04-27 18:05:36.486832+08	1FWLJ8QzqIt9tcnEml7bTsBhUMm6B4ZCJ6XcDxb4GWD991OvmV	1178
62	Out	2016-04-27 18:05:46.804534+08	2016-04-27 18:05:46.804534+08	WFOhxs4kyFoYR7eyjrwLvDqAM0AkvwFSCdAAWEuVTi4vpiuZbr	1179
49	Out	2016-04-27 18:06:09.110067+08	2016-04-27 18:06:09.110067+08	uX5mhRmrCioRB15MBba675oC0euuEWm94rvkJidVRSwcT1yecZ	1180
28	Out	2016-04-27 18:08:16.11675+08	2016-04-27 18:08:16.11675+08	kkeZweErZSNNbRFXDYGp4hI0Kk2JPesAPWjLBwDkPa823NZFvp	1181
61	Out	2016-04-27 18:09:41.645002+08	2016-04-27 18:09:41.645002+08	5zXN0r92BYg4i6bSRmPeXoFgqI4RXzHdyp1yh91shhxQnYsFLI	1182
29	Out	2016-04-27 18:13:06.841325+08	2016-04-27 18:13:06.841325+08	st89ZyRdPychccWcbEmc7UK5u8dnNy7GsEPSDq5dphKSKq5v5r	1183
57	Out	2016-04-27 18:31:57.064589+08	2016-04-27 18:31:57.064589+08	ZCMtHH2u6OtCemQ4FduKHk2bDNSIJXArkWl2nnwtDr6reXvtBr	1184
59	Out	2016-04-27 18:35:04.365154+08	2016-04-27 18:35:04.365154+08	EScG4odW7w4HoonaqbPoVbfcTK9QEKHRmtiqiLOqIS87Hvh9Y7	1185
56	Out	2016-04-27 18:36:30.376736+08	2016-04-27 18:36:30.376736+08	w4idgCxpcCAtexnMoWhDN0fV7wRo6zv44dhjqfZTrkNWiBsXia	1186
58	Out	2016-04-27 18:38:26.808561+08	2016-04-27 18:38:26.808561+08	k6aQbhN3WT3SX76FqwuQPmBmJtxBQgmBlNbN6yQcST50aBFR7A	1187
55	Out	2016-04-27 18:41:11.587747+08	2016-04-27 18:41:11.587747+08	rXw3KFwIRNyDYkaA8g9ZJb3NccYr4f2vDxyXEvpeKossZT3hAC	1188
54	Out	2016-04-27 18:45:50.121475+08	2016-04-27 18:45:50.121475+08	HToJqQwPI16KwJIvqWsgBCU464X9liL3CAM3aISsJYDGrVCi25	1189
12	In	2016-04-28 07:49:42.996569+08	2016-04-28 07:49:42.996569+08	PDHuHNypVkXrmj29mcRFVkni1gEDPGHoTYjkvhaRS8JFqLOdwq	1190
17	In	2016-04-28 07:50:04.85199+08	2016-04-28 07:50:04.85199+08	sSbhBcOPpne7c8gMsc5T4XaNmSiB6g2y9cfKF4i5rODUWsqPVv	1191
51	In	2016-04-28 07:50:21.955072+08	2016-04-28 07:50:21.955072+08	rZTSxFugQ1NSyW5fqLjZQbxc6TWws2skbMEZb9G3AdU9Aao1vY	1192
23	In	2016-04-28 07:51:44.619562+08	2016-04-28 07:51:44.619562+08	aL9YyF2VCuX5g9Qti23z5DdZMnABn6iORrwQ7yvJtSOaboUKqX	1193
41	In	2016-04-28 08:10:27.526843+08	2016-04-28 08:10:27.526843+08	KvkxV7lfHZl0xDsudzsZJm2gNeVryMPJIAHoH2UYbGZaUSU8RO	1194
30	In	2016-04-28 08:10:29.85421+08	2016-04-28 08:10:29.85421+08	hkBkRYOwQNKphczxQH1upcBPDfrhnJ6V4HGVpeTG2m6jP6ipNi	1195
58	In	2016-04-28 08:17:03.217213+08	2016-04-28 08:17:03.217213+08	kDMvcZbTHPmNuqeBNUppjrcpb2vKrI3cVPZ8yBbGaPdVGHgdlW	1196
49	In	2016-04-28 08:19:24.459467+08	2016-04-28 08:19:24.459467+08	TWO6M09HK1ZNd5nDDmOo2yEfUUwB8igbF5hb6qsQrSnVXbhkO6	1197
59	In	2016-04-28 08:20:50.333302+08	2016-04-28 08:20:50.333302+08	ZQ4n6YI3jQmR22WjccaV2SxqwVSeHpkqGpeMOwP8MCZOE68qhi	1198
55	In	2016-04-28 08:21:36.520014+08	2016-04-28 08:21:36.520014+08	MkAKb8q3m7sXxANcWlZvtv8TKLYRCHAY2LscSjgFqZmojARFv1	1199
13	In	2016-04-28 08:28:12.637052+08	2016-04-28 08:28:12.637052+08	BpwIJGerip9sOBDIng2Uvs4ihmsA2oBDe7WxOAp71yzPADhxti	1200
53	In	2016-04-28 08:29:05.856103+08	2016-04-28 08:29:05.856103+08	RobVXKIQULFfYtm5qBFgHGfHfoUNmO6EDijk33BWOQCwJy1BAH	1201
62	In	2016-04-28 08:41:48.929816+08	2016-04-28 08:41:48.929816+08	rRWXiDMDZAbgOnO8YRBjxZ9AVT9XeJnWkL4TXQg8ZInx6D7edI	1202
57	In	2016-04-28 08:42:38.405059+08	2016-04-28 08:42:38.405059+08	OcrXmN1vufFiC04FTbfAjGSXEYjLDOdb1UAnrBjmqyV3yYISAx	1203
29	In	2016-04-28 08:45:21.462874+08	2016-04-28 08:45:21.462874+08	ctD5RRdBmrZQTaudOno7Zf65i6d0YoxBiCGAdtLQluqFVmstZg	1204
61	In	2016-04-28 08:53:03.867744+08	2016-04-28 08:53:03.867744+08	1AM8F5Ds5lh4wQFDas8vKtqB9Mx1GXhHh5PwAcpFOXJLxYZXSg	1205
54	In	2016-04-28 08:59:01.986844+08	2016-04-28 08:59:01.986844+08	TmaKxigvkwTSFBXe8hHxwfVG2Soa1HHU4ro2bVxLSRohcLMk3d	1206
31	In	2016-04-28 08:59:34.908109+08	2016-04-28 08:59:34.908109+08	i0JDGLf5vgMDBQ6yShVQ3xqrfTD2EGfwGyAWJpcFWyShPYgrGC	1207
56	In	2016-04-28 09:01:09.823988+08	2016-04-28 09:01:09.823988+08	IJA9BpdOrreWouVyRoo45L3X3S6kKMwcf6lqvPFnHtL6oq4Gfs	1208
28	In	2016-04-28 10:28:01.376361+08	2016-04-28 10:28:01.376361+08	KkFNIIqO3BlynR6aI2zXpHQBMF2QWhKqSYFkq59tGus5Myee1e	1209
47	In	2016-04-28 10:32:49.142386+08	2016-04-28 10:32:49.142386+08	Brvc3Ir5iOm3FFbU0TZAMp5GuQFZ5GFG7AsASkFC92EOHqsIJS	1210
27	In	2016-04-28 12:56:34.081094+08	2016-04-28 12:56:34.081094+08	RgIWvDwBm2R2IYCBievyq615UIvNaFp3v8YsLW48YUAq4M2m1x	1211
12	Out	2016-04-28 14:07:11.154857+08	2016-04-28 14:07:11.154857+08	lr4mxY5tvf9li5tHxEn1MMWWCZrENtD8lHujpzcmfmYOrRfpfT	1212
49	Out	2016-04-28 14:08:47.063263+08	2016-04-28 14:08:47.063263+08	q2oNY2wRGKKTS6kNpbNSN3FvR7N6v3Zm6OAeQ86gRQAuWuIMWe	1213
17	Out	2016-04-28 15:00:24.289539+08	2016-04-28 15:00:24.289539+08	oth4p9BCF7GptLE40eC6LdWVY3RpPxVEqDIgMTscZ9RUUfYVKk	1214
28	Out	2016-04-28 16:51:39.074802+08	2016-04-28 16:51:39.074802+08	bgO8CwBdnaaIoSW78sZ2VABwdfdCBxwmeLuqI5T6f4OTWuaenB	1215
53	Out	2016-04-28 18:00:23.236822+08	2016-04-28 18:00:23.236822+08	gJKrHyXuBis8VXTQNlVqrAvGeSBF7zPnJkfajDUuvN3RtWrIJM	1216
51	Out	2016-04-28 18:01:17.562716+08	2016-04-28 18:01:17.562716+08	9BX5RBXcQecqSvb8VKL0FHNIiIoaZ8wjJUokfLN7zywRuYZQsu	1217
31	Out	2016-04-28 18:01:47.39189+08	2016-04-28 18:01:47.39189+08	Q8CoRu6GUgORPgvERcZniZng1iFa98VZGhOhbUx7BLYa3UoT7N	1218
27	Out	2016-04-28 18:01:53.905188+08	2016-04-28 18:01:53.905188+08	Ipw6WxnlYxt4XAlvrOQpUbB3CEY0hfOyVL52JsnrqgvOqhKi6k	1219
23	Out	2016-04-28 18:02:46.700617+08	2016-04-28 18:02:46.700617+08	YaMjeXxCXfrveOGjQZcDRTuNrl5CUBw3lImPqkcOPUK4sanJAR	1220
61	Out	2016-04-28 18:03:02.106523+08	2016-04-28 18:03:02.106523+08	WbuRymC4zgEvj0FWP5G2TgWnkPOYiYzFAug8hsChZQdJQspqx6	1221
55	Out	2016-04-28 18:03:24.480561+08	2016-04-28 18:03:24.480561+08	sRmPFWpd5YC5nMyUUhMgOv83FYu5PtBILwhaUXFZ6RdsndNJLj	1222
62	Out	2016-04-28 18:04:20.916316+08	2016-04-28 18:04:20.916316+08	zjg8mvfh15bBNw94XcbmChEpa2TxKohKYOSKK83LDdWaafe8IG	1223
30	Out	2016-04-28 18:05:11.297428+08	2016-04-28 18:05:11.297428+08	uUx9LYBoWVdEpCdIWxQZJdDpEnVswn9rI71dfCSCg6QXH4pn2G	1224
41	Out	2016-04-28 18:05:53.121671+08	2016-04-28 18:05:53.121671+08	NKtaA8Pf1LTADlHEPwQr97wZeEdT3ejQyd19kQollIvz4DET9e	1225
29	Out	2016-04-28 18:06:05.911413+08	2016-04-28 18:06:05.911413+08	LIlIrQWUtZAd09G2I2S8nEQiEUvSx56JNrbFI8jChtoi26jL7C	1226
56	Out	2016-04-28 18:11:44.122199+08	2016-04-28 18:11:44.122199+08	SuQsdeNZ7LeDd25FGNN0Y6tOovTYHbkjWBcAp0iwLNAyPFEgcc	1227
58	Out	2016-04-28 18:13:02.210185+08	2016-04-28 18:13:02.210185+08	gChaaWW45nfpYB1BLqB4nWRyVrEjXqME34ocaLgf9MVhXXssO5	1228
59	Out	2016-04-28 18:14:03.679607+08	2016-04-28 18:14:03.679607+08	wCbPB6GPpnGC2JGqvqCdWMz34XZwQx2NBdmMj3kar1mtK3kHtx	1229
57	Out	2016-04-28 18:16:11.126944+08	2016-04-28 18:16:11.126944+08	tQJtTNR3Lr1NFC12Yk6JKxK7rfAcv4aqUtkxIC1d421JE2LmmR	1230
13	Out	2016-04-28 18:59:46.112635+08	2016-04-28 18:59:46.112635+08	67PQEH6Ot2RUsvPcthouKrxLBCNWy9y4GOVUeasZdK4VHT9BBx	1231
54	Out	2016-04-28 19:11:37.977561+08	2016-04-28 19:11:37.977561+08	6Vp4q1FEYENWIeun9ZO292NDXdggoqeuMTyEUFS3TpZlUUZd4x	1232
23	In	2016-04-29 07:53:22.823123+08	2016-04-29 07:53:22.823123+08	gD03QYh7FWxsSLNRYrf1u9qUuLyUz4TfHTjh2RoHxmAQ8WqgOX	1233
17	In	2016-04-29 07:54:49.637936+08	2016-04-29 07:54:49.637936+08	iJgZobun7uqZa84Kp5leMjSW9a31HRYzlFYZqUNxOFXzNbKDg5	1234
12	In	2016-04-29 07:56:42.207009+08	2016-04-29 07:56:42.207009+08	r3oKZytcyB4XBpmjQdEnbc29cPjvcQ2UTqo3pifotjM5Z9o0n3	1235
51	In	2016-04-29 07:58:26.652461+08	2016-04-29 07:58:26.652461+08	nOfpXIGHEsiGNC7CFwtuloe8tEIiE6l2URr2j8Jy12FNEMZTJT	1236
41	In	2016-04-29 08:23:41.797995+08	2016-04-29 08:23:41.797995+08	N5I2ECGWuUbgW68P8sXSrXU7viTUBnyYsHa7SqcNLE4rLDHT6n	1237
58	In	2016-04-29 08:28:50.190477+08	2016-04-29 08:28:50.190477+08	uwMP4H8XmJLkrE2SLUJxseCwWXAn1FcvCxLGGTo2l9mdNo6iKP	1238
59	In	2016-04-29 08:29:41.719487+08	2016-04-29 08:29:41.719487+08	gC4s9bQJPRY2Nk0i1GBpIxy5bMuh5E8lQCeZn5sDVRFsBFbDVm	1239
61	In	2016-04-29 08:33:18.734467+08	2016-04-29 08:33:18.734467+08	2nk1sMNn4S2CESOs3CwvPTNeMYuwlQjnDUo7qCtufv7sPWlSii	1240
62	In	2016-04-29 08:44:23.805663+08	2016-04-29 08:44:23.805663+08	O9CknYKiV58GsLkhSbuMWZJeTiAFAsxY2AKphdYDjgTc2EKUpE	1241
53	In	2016-04-29 08:50:58.103049+08	2016-04-29 08:50:58.103049+08	rMoA0HsBW34Uc6dvvMaUZJA3vCHGh6UYSJiSabd6fhaHnEEkan	1242
27	In	2016-04-29 08:57:53.139694+08	2016-04-29 08:57:53.139694+08	FA7PD3bTJJZnr26aVgD9nsqOAecOPDCeMJ3ZNf3fydTqfZRAGe	1243
29	In	2016-04-29 08:58:01.537696+08	2016-04-29 08:58:01.537696+08	J4XASho46EHIsdcvDybHeat8RZhskyX435EVl3ZrHqAAVm7ili	1244
28	In	2016-04-29 09:10:26.279215+08	2016-04-29 09:10:26.279215+08	zQItYjUHcEGAIJEWn1ZNsrE32jp8SbqS29MasprV58fNQttEtU	1245
60	In	2016-04-29 09:38:40.9189+08	2016-04-29 09:38:40.9189+08	cmLqpNafV2HMUKVquPgmuluZALT4aNXCAt31Gdglfx8AIe1D3h	1246
57	In	2016-04-29 09:46:18.153736+08	2016-04-29 09:46:18.153736+08	0xUuXdH2hqPG4Z97aQjHCPFKZXyak2Ik0mgYQwZ8oyOrYXy9wi	1247
47	In	2016-04-29 10:56:41.064405+08	2016-04-29 10:56:41.064405+08	Q98fUhDTIxVajVNQ4nNevCdK4Cr3LpllytRTbewtdSUNxrm2fA	1248
12	Out	2016-04-29 14:19:28.69733+08	2016-04-29 14:19:28.69733+08	gbMKvQWoTrdFdc956kk3dOU8kSyXUeiBG5VDV11ysfEWINbO7M	1249
17	Out	2016-04-29 15:23:55.046197+08	2016-04-29 15:23:55.046197+08	RlkvsVOs3sXl5nqZ1Mb3LUhZ10vdO4zpojliFAaI3848wuhxHJ	1250
58	Out	2016-04-29 16:23:04.751028+08	2016-04-29 16:23:04.751028+08	1cniBoi8S7BRw1ChiRrKjuSo3PjkN14Ncr6ngov9v7as8maqES	1251
59	Out	2016-04-29 16:23:49.486684+08	2016-04-29 16:23:49.486684+08	BxMdmP3VAPWDm95swlhsud0WV8J6zWYBUuoHKrmUHJh4SmxPZf	1252
27	Out	2016-04-29 17:10:57.019169+08	2016-04-29 17:10:57.019169+08	IUJI0oRJuQqTbLOQciHPDYiudBhaaGGskZBlOc5J3umeGC5suM	1253
47	Out	2016-04-29 17:15:33.355703+08	2016-04-29 17:15:33.355703+08	I8u12YCj9l1PelypXNRbgUXU9nfEgaayiWzk5BUExVdcHcSozt	1254
28	Out	2016-04-29 17:50:37.6604+08	2016-04-29 17:50:37.6604+08	QgOxBYkqmRRNQAtQuybPCZupBCSd1SXR9vOJU9AHbce2mYRhX3	1255
61	Out	2016-04-29 18:00:07.036893+08	2016-04-29 18:00:07.036893+08	7jc3aoF3SFVzgev5xQF9hpkMrXuJFSNMCzOmndpGtKGayCfwct	1256
62	Out	2016-04-29 18:01:02.766596+08	2016-04-29 18:01:02.766596+08	6KkqgbObvc4IyGIO362rMvDcVCnB9Q5Ekp5RRT3N67f5NxTQ4V	1257
60	Out	2016-04-29 18:02:46.818461+08	2016-04-29 18:02:46.818461+08	IRRU3wgq8pHD4239SUcVricXnzWHPamh1EC5BsvJiDWmFZvi4Y	1258
51	Out	2016-04-29 18:03:55.107442+08	2016-04-29 18:03:55.107442+08	EwHqU5p1MGa9xcNAhY3drlqNZ7wVo143xKtSPjSlz4uwgJ7NrB	1259
53	Out	2016-04-29 18:05:19.670053+08	2016-04-29 18:05:19.670053+08	1iwr7Wy41n55q3PkVpVxbV2WSipa6hl7QizXExaGlgLdjkOEat	1260
29	Out	2016-04-29 18:06:35.277007+08	2016-04-29 18:06:35.277007+08	CCPEirwYS3FEBfwADB9nRuUmYDXwS8qeKGt29qabtpp5VlFiwO	1261
41	Out	2016-04-29 18:06:58.35213+08	2016-04-29 18:06:58.35213+08	WOJ1BrEiogqfLBvED45nfzdV59HLrEjOc2PntdWiJNNeXJtkNy	1262
57	Out	2016-04-29 18:07:15.515065+08	2016-04-29 18:07:15.515065+08	Y4yCY4MpOE48chA2U5e1myOAdvTXgrWGuVSTZoKx2O6e6HgaLL	1263
23	Out	2016-04-29 18:15:06.784629+08	2016-04-29 18:15:06.784629+08	b8K0JxvmUde1sZWL36AN4ClAqrQXSls5uD5DB10feegXDDtHJ4	1264
23	In	2016-05-02 08:12:26.313654+08	2016-05-02 08:12:26.313654+08	dMGQW7IwekjXpekurvvrbaWI9kV21n6fBL5hTNe88Ofx2RstMo	1265
12	In	2016-05-02 08:13:07.361471+08	2016-05-02 08:13:07.361471+08	mxPJGY3la5Zgjk2oRVC6dLUJJWkCR71D6QWLyZ7ZegGORIEsnQ	1266
17	In	2016-05-02 08:13:20.355859+08	2016-05-02 08:13:20.355859+08	yRlTk50VGRdHeihB5gkCGQsVoJn3CbTB3FeoKfKa6xqkgYvlFh	1267
62	In	2016-05-02 08:17:08.424608+08	2016-05-02 08:17:08.424608+08	xU7p1vAoyMRTXUiCJ3rcdxaUjH3f3IN0nVqnR0dRM4ttYc6rfx	1268
28	In	2016-05-02 08:21:22.052952+08	2016-05-02 08:21:22.052952+08	UJw5ngMqMP9jQwFGkgHO8dS2X2edtLbOdYTREqIaGRLgOaw9HE	1269
53	In	2016-05-02 08:34:08.255687+08	2016-05-02 08:34:08.255687+08	XOr0RP263vReK5DnWReo2uGNbewZnEnLcfM44OA7KalefxSCP7	1270
41	In	2016-05-02 08:36:45.548022+08	2016-05-02 08:36:45.548022+08	1S3HpevmEj125dhRhlprtATen9dGL3OMVQdK5Z7KJ8MPl4qUpg	1271
57	In	2016-05-02 08:36:54.414612+08	2016-05-02 08:36:54.414612+08	MjppOdy2uK5IgZjKtot19D9UcvYTQO9m8ycVdbXYvcqcCax6Pr	1272
55	In	2016-05-02 08:37:17.010826+08	2016-05-02 08:37:17.010826+08	8Y5H3hDbBc0KP8J2dwdCVZnMCzwA6M2Eu7Vxoha0LaKkiemNbP	1273
54	In	2016-05-02 08:37:27.722534+08	2016-05-02 08:37:27.722534+08	Y7yMTBMQLSmNghUBfJtGJEqdyZIlvtBV1ArTLEtggg4NNYZ3qS	1274
31	In	2016-05-02 08:37:35.021863+08	2016-05-02 08:37:35.021863+08	JAh9ogi6Sf0cA1m2V8GPpx5sLSRuVINoT5xHlgOEMOqWPdZulp	1275
30	In	2016-05-02 08:37:41.509633+08	2016-05-02 08:37:41.509633+08	JbnPV9rw3NFQCiVA0HqOVDmMkD0J8m9ROwqs6hp955ZHn6RnNI	1276
56	In	2016-05-02 08:37:46.140458+08	2016-05-02 08:37:46.140458+08	CsVzFGDFZK2jlQgcJlK9uPEVg2a8pxP2rv27CEMlZOVLoCx8xI	1277
58	In	2016-05-02 08:38:21.610762+08	2016-05-02 08:38:21.610762+08	HshVOOWyWMxvOorQv4eJoEhKZWWWeUovNWRlvxkRKhOiXG9TJn	1278
59	In	2016-05-02 08:39:53.454413+08	2016-05-02 08:39:53.454413+08	l92TTb0z9fTxbqV2cQ0NsK5G3cWC6p1ry3MSfMSn1vmcmHePhe	1279
27	In	2016-05-02 08:40:10.169878+08	2016-05-02 08:40:10.169878+08	mazrq3UNFZDGSDJnfyA7mB3ZnpqTFY8198szAMNQwagOnzCTyM	1280
29	In	2016-05-02 08:57:24.436361+08	2016-05-02 08:57:24.436361+08	alYdLMSCphkxit5btGxHfurMJfMW9Lsi7RMRnodcWOaFIgpCwn	1281
51	In	2016-05-02 08:57:40.773903+08	2016-05-02 08:57:40.773903+08	SciKy2zLY8fRrmrDFf2sJYHtnZZdlWRE9BY8DYTlgADYw5lBko	1282
61	In	2016-05-02 08:59:20.800553+08	2016-05-02 08:59:20.800553+08	44NLwBuXog4GtDQSLd1oPhycGuh26SpAWDVUOQ1C75S1ItUdXU	1283
47	In	2016-05-02 09:10:16.882488+08	2016-05-02 09:10:16.882488+08	TxCRaSMIUTkKdHX9lvam9hrbiBVDo3hI0tjaM6sqZdBDuiNffw	1284
60	In	2016-05-02 10:28:07.775117+08	2016-05-02 10:28:07.775117+08	TneLPNWuaLxIcxCMYYTRO35ZGzIdfxa9lFUBc06DL3Vy1hLaFo	1285
47	Out	2016-05-02 17:05:38.663552+08	2016-05-02 17:05:38.663552+08	2dq6D76VklTLuFaPQDPWQkZvjad5BssDWkJkrPGcBjx6yYUPlt	1286
31	Out	2016-05-02 18:01:04.615188+08	2016-05-02 18:01:04.615188+08	uCeU8O6lTGeMTB6mvxCCaNvXTu6xKrsF4XjCvpyO6dkZoqMkpY	1287
60	Out	2016-05-02 18:01:15.372921+08	2016-05-02 18:01:15.372921+08	wPvsxOn4N7vFNzm7CiwB73ordcjzNYYKyTDws00F8vVUvIb80Y	1288
23	Out	2016-05-02 18:02:38.764446+08	2016-05-02 18:02:38.764446+08	J8c8zFkjF8InSHHfDAfEQnAuI6DtEDTXL5fLLQ4aYMO1dggrqM	1289
12	Out	2016-05-02 18:02:45.650862+08	2016-05-02 18:02:45.650862+08	6GAFCSLOMZcp7wumIGDNqljFmNvUFmqL31aFTvdpWGfdDaQVrd	1290
51	Out	2016-05-02 18:04:55.856426+08	2016-05-02 18:04:55.856426+08	siOcxC1tfGgWajXBy18cqdsWH67hbyKUhj7gu8abNH8y1fA0gI	1291
61	Out	2016-05-02 18:06:41.860495+08	2016-05-02 18:06:41.860495+08	cXvV4DbBuDAGhrzoYuw9WKQdJSJTSzl5XiabvCmrPw77p7vN2s	1292
27	Out	2016-05-02 18:06:47.559663+08	2016-05-02 18:06:47.559663+08	WXDwCXPV1rVnw3VXdSjQJ9NQFDXBaZ488I5JoUopMLdJN9r2bb	1293
17	Out	2016-05-02 18:06:50.299171+08	2016-05-02 18:06:50.299171+08	SujpMz3tBdTFlbWquMLkCh5p1SysUaUwVEmrEplOTFdFpA6kWR	1294
11	Out	2016-05-02 18:07:23.443233+08	2016-05-02 18:07:23.443233+08	Vi9aYA4X3Y8XVelIVz8HObW2rNCx8iPdRYEziIXmpfKLK6dp5l	1295
62	Out	2016-05-02 18:09:04.829664+08	2016-05-02 18:09:04.829664+08	7TOdVF1hD9QbmrA1rsIPf95yUP58FAtMdI09X1qjAHMw9Vx2OG	1296
53	Out	2016-05-02 18:09:20.012264+08	2016-05-02 18:09:20.012264+08	R4PW3tv81AJvXwDX6kYwUjEqgOMdPltqpJNsDI2ETKA0HNXN87	1297
55	Out	2016-05-02 18:09:51.386624+08	2016-05-02 18:09:51.386624+08	KcqYUWwqAMc5DSOaLasNoLhyMyMtMU1g7qGbNDSYZ5cmW1NrbF	1298
59	Out	2016-05-02 18:10:14.379141+08	2016-05-02 18:10:14.379141+08	FQbwPwvlqIGrzNiGy7SRe3VIp3JCuuSAL37k03WqLmiLASa9Y4	1299
29	Out	2016-05-02 18:11:25.975499+08	2016-05-02 18:11:25.975499+08	ZE66Vv8o83iaE5dKpdNMViAE4KgeTFi3To9ykHnsKWTYb7sRkH	1300
41	Out	2016-05-02 18:11:33.426531+08	2016-05-02 18:11:33.426531+08	nGzxU4HBikQRntGws1EfuYDN7nU0FFH3VH11LJC44cWrVmnOo2	1301
28	Out	2016-05-02 18:13:16.727538+08	2016-05-02 18:13:16.727538+08	5iaH7h6bhLqyONGPNbiZfmCCdhyR6mTBV4SckXESs5RIShhpIQ	1302
30	Out	2016-05-02 18:14:10.017736+08	2016-05-02 18:14:10.017736+08	PxDbAqJ8JPumaRq33baH4UMVlnDTdVt4T7edxxlHOg4y8t1BVc	1303
54	Out	2016-05-02 18:16:33.708445+08	2016-05-02 18:16:33.708445+08	Sa6o6rcJMHnGKINzuLxgcMNgKVbMh7xAh5ynwb6JsuZDCwD8IB	1304
56	Out	2016-05-02 18:17:38.4667+08	2016-05-02 18:17:38.4667+08	ouXCcrhDEPLCZ2HXpE9vX2q6F33SBLdyGBCs3t7HJRTrUjQKxZ	1305
58	Out	2016-05-02 18:20:07.337164+08	2016-05-02 18:20:07.337164+08	GVa7bpAeILzwKG8W9BQGSjhubCf2Wdam9Btk24OKPOHjeOGnZg	1306
57	Out	2016-05-02 18:21:27.314656+08	2016-05-02 18:21:27.314656+08	42Plw1xc3TGdGPo9AqDYBcwSMbqcPQITSiFPjD3mgJQwiF7s6K	1307
12	In	2016-05-03 07:38:30.771988+08	2016-05-03 07:38:30.771988+08	RHwNjJyZuP0EsSv8sgLuS2Esyw86oFQGWMdFfdoa2pouIk3ARO	1308
23	In	2016-05-03 07:41:04.485448+08	2016-05-03 07:41:04.485448+08	6tQJnQGvW6BwLgJzvydlZfbOat9d4a2AVTTJtjFQpQNB7gB3fn	1309
17	In	2016-05-03 07:49:20.265136+08	2016-05-03 07:49:20.265136+08	oFTQd4JmiNOkXtE1C8kRYaqulxbw2HkqWFG9JZw2xLmUE1VQ8G	1310
56	In	2016-05-03 07:56:18.582202+08	2016-05-03 07:56:18.582202+08	rgqjbchDZjUKZ0ZqAsQ7uORgsghO7pezWVi87RLgAp1kpZa0S2	1311
61	In	2016-05-03 07:58:05.258715+08	2016-05-03 07:58:05.258715+08	7MPY4IFlgMbLM8p5HwWcdgSdRJE2Jf4Q3Ty7lErSaTmvcc1sZX	1312
51	In	2016-05-03 08:00:04.538272+08	2016-05-03 08:00:04.538272+08	VDEyrfH5iall1oFzu1EnTnHGkstlmTJIgYHYEYevAQiBFxBAzO	1313
62	In	2016-05-03 08:10:34.653562+08	2016-05-03 08:10:34.653562+08	xTDFjx8dju73DnbUMp31lCRUNfSYpSwnvA3f7BIq5PuIDWmZMp	1314
30	In	2016-05-03 08:14:58.754161+08	2016-05-03 08:14:58.754161+08	b822cPi6xYYtMU4PACaS3frxx5UkfqaGycJc21iyaHtwkxMuAw	1315
41	In	2016-05-03 08:23:42.747554+08	2016-05-03 08:23:42.747554+08	NDcFBaKfLzWvGVXZ8ZaqYB7S8sQUnaQBn3QyclexkBt1hRap1B	1316
11	In	2016-05-03 08:24:43.891445+08	2016-05-03 08:24:43.891445+08	gZMn2TgSxU3OfpR6o5rT3cewdMOECOPsylg1FNTDrVbXM3eB8V	1317
31	In	2016-05-03 08:29:48.367025+08	2016-05-03 08:29:48.367025+08	eB8J7mgV1stRlsCSsRpMehrHGEKtPSQ4cYNjL4FMw9ni20BuS1	1318
45	In	2016-05-03 08:30:03.787529+08	2016-05-03 08:30:03.787529+08	H7iANyNhsmAJqmrEWDIlZEvNwxO8sp8AwrKKqh3jUC3LzuYW8q	1319
59	In	2016-05-03 08:30:21.182989+08	2016-05-03 08:30:21.182989+08	Jh5E52CTA5JIFGAZb1Hdjlqm6pgfMoWfWbtbe65oAP7PfHyGIF	1320
53	In	2016-05-03 08:33:35.303984+08	2016-05-03 08:33:35.303984+08	u21lo7bVmxKJdqvXSZdYOowVEcmCs5Sn6TZuaBQO9khmbcK4Dx	1321
29	In	2016-05-03 09:20:52.919674+08	2016-05-03 09:20:52.919674+08	cbmZ71CtD5xfs59SzjdQ8mBoZmRtresTGe3MfFGsKEYEJhgJRJ	1322
60	In	2016-05-03 09:51:30.39731+08	2016-05-03 09:51:30.39731+08	jZ6uOfhpZZUR3k767mLNffcEtvvaFOtywztLebBEBgfERmLYYg	1323
28	In	2016-05-03 10:30:50.855149+08	2016-05-03 10:30:50.855149+08	wFNZTGVPqknkjkjd6PFHdRxJfP51xehus5TMLylCiZwSKg6Q6L	1324
13	In	2016-05-03 10:43:15.937772+08	2016-05-03 10:43:15.937772+08	iimg2S67T4lBxeFR1aQmmANjchQi8W4qFqXHJcPmgAxeoD6poW	1325
27	In	2016-05-03 10:48:26.860588+08	2016-05-03 10:48:26.860588+08	dbg0LJhl2pJ6gYwEpFqF2XP0CFDI52ohdViyoQlqG4wwcsBT92	1326
47	In	2016-05-03 11:45:46.090586+08	2016-05-03 11:45:46.090586+08	iBZ8BkNP3SRrA5Os4DJp4Zt1WXth03jjEJrP4Fo7hFzsKOlOb5	1327
61	Out	2016-05-03 12:01:20.211183+08	2016-05-03 12:01:20.211183+08	Efd8hAfbsfecPtvHJ0W87EN77hVr77wLnaTUl86dokGDeCUxC1	1328
57	In	2016-05-03 12:48:41.270855+08	2016-05-03 12:48:41.270855+08	6JFTRLBwEI4Adql6LWFSA4DQHrclpomv82PZNaWasZlWRWcm3r	1329
45	Out	2016-05-03 14:05:53.266728+08	2016-05-03 14:05:53.266728+08	FEvSeDKHyA6k5EmUnA5JkxtWUL3786yNKtpy7AF5KLqPZctNmy	1330
11	Out	2016-05-03 14:13:34.203927+08	2016-05-03 14:13:34.203927+08	gXwa4Qv6X4DWQWQGVXQkcj7S9g634s2kQxLTPHavKmSlKs2pPS	1331
12	Out	2016-05-03 15:18:09.450667+08	2016-05-03 15:18:09.450667+08	a2ChULOaPRTRCtPXNooxkAlDu66wvVOWXaE2wccM46mH0CoO1d	1332
17	Out	2016-05-03 15:19:01.281189+08	2016-05-03 15:19:01.281189+08	Mln8yiD4f9Z4f7ft9cWlxaskrsxgHxKdj8kiqxmW7MalTGfcrC	1333
27	Out	2016-05-03 16:00:35.473591+08	2016-05-03 16:00:35.473591+08	OqmHbdAZKQXe4Hlo0cmn9tAjgdyMFrXdiKuKx5sIVRvZiiOiLB	1334
13	Out	2016-05-03 16:32:02.224626+08	2016-05-03 16:32:02.224626+08	WT6gDlKC8Z4fEm097xD0GiRCIAugsFsPix6vkQ9s0DYE0YN7Wa	1335
23	Out	2016-05-03 17:12:32.502234+08	2016-05-03 17:12:32.502234+08	7mJYycisJb9C1rA7nuXwmYALmAtAHQkOD4wCgf6yHEBH6LOtGv	1336
62	Out	2016-05-03 17:14:30.603541+08	2016-05-03 17:14:30.603541+08	q3U1OHCIQTiBrvFp8uVEulS64YRSShPKktL8AXQa09ls61iEvE	1337
47	Out	2016-05-03 17:15:52.08151+08	2016-05-03 17:15:52.08151+08	Sqzuw4TOWv5uGpoaxy8Pa8YM1eNjsKxKBxF81iWXebStRHVPGc	1338
56	Out	2016-05-03 17:25:24.487935+08	2016-05-03 17:25:24.487935+08	oqlNDm2aWuuUF5SUDTDj1qLTlmkGC2t1seP6RRgyMaTbgu6tOI	1339
28	Out	2016-05-03 17:28:56.760856+08	2016-05-03 17:28:56.760856+08	cPAxsukdBwf5xXjNdCoJABudlaYrUwA7MK5EFprRmXVl5G9iRx	1340
51	Out	2016-05-03 17:59:14.883437+08	2016-05-03 17:59:14.883437+08	2c8wGtXol2lv97GFMV5EwrlSdqimZAjbmrY3m6rY8dUHkkW6Hb	1341
31	Out	2016-05-03 18:00:26.707555+08	2016-05-03 18:00:26.707555+08	KET6g7wPsWZd9NVhQInHqvuLEf6klNM6bpDIwAhpgITpeyX5GL	1342
60	Out	2016-05-03 18:00:35.780243+08	2016-05-03 18:00:35.780243+08	M7HHSVwYGivcpXS2pPCXFspiiUgGZwbv4sDWOA5es1HhYjkP9w	1343
59	Out	2016-05-03 18:00:36.412034+08	2016-05-03 18:00:36.412034+08	wOpl7YGnopkPlpIyMg9RM1Sdj2OTQXQNvGA3oQpcGb22QL0m29	1344
30	Out	2016-05-03 18:01:30.393585+08	2016-05-03 18:01:30.393585+08	EOBh2tiQOAxoXt5hvs7mWNNYPntPbvYpKjWMdGl2QjqxdueZom	1345
41	Out	2016-05-03 18:02:49.430325+08	2016-05-03 18:02:49.430325+08	MLAjtZXmy9iXx3HVOulBwBun9Xin7XaTsjDlJkZItIprL6Nj18	1346
53	Out	2016-05-03 18:02:51.904718+08	2016-05-03 18:02:51.904718+08	uxKplTNUHU3qxubBguvGDpY2ht95dADY9XOu1lPHGS9FNjQ4eM	1347
29	Out	2016-05-03 18:04:12.911486+08	2016-05-03 18:04:12.911486+08	LrCtttn3yRDD0LkOGkAf3Q8BeVv5ZaRuSdoMXcOW4bi4wTSDEc	1348
57	Out	2016-05-03 18:05:06.663871+08	2016-05-03 18:05:06.663871+08	tH32ShXOm7yE2QrpmPSBvWmfak93xNfreis7QQVDXURZuJPhir	1349
31	In	2016-05-04 07:37:21.699256+08	2016-05-04 07:37:21.699256+08	teOgKzQT3PqiGVRAcqa948dVgYo7HXyACNqWNHzQgq9wMZ7yRh	1350
12	In	2016-05-04 07:40:57.215395+08	2016-05-04 07:40:57.215395+08	8Vpk0WKocaMbkZzb6Mt6mavvXIVeHwMPSBAShUHL5ewpDwSJJM	1351
41	In	2016-05-04 07:40:57.821057+08	2016-05-04 07:40:57.821057+08	P6vL2UdY9uVVKwgUQOxhj3MgsZdLswhI4dd68HeGC9lV7SzWqx	1352
59	In	2016-05-04 07:41:30.934865+08	2016-05-04 07:41:30.934865+08	Eb1aIt9vG2twKwbx3iEhzQqlvxEuU5sigtIyoSu4Uo2olcmoM2	1353
30	In	2016-05-04 07:41:36.511774+08	2016-05-04 07:41:36.511774+08	WLRN7NLKJpPCY66q5uJzznn2daeQP1RvMtKTHfnaVEm3KstOoD	1354
23	In	2016-05-04 07:41:57.866733+08	2016-05-04 07:41:57.866733+08	On2DpemU5CVX8rQSKh89IdM5ggxa5moTapgQVTuafQ7nIYHcGP	1355
29	In	2016-05-04 07:49:34.233248+08	2016-05-04 07:49:34.233248+08	lY28djobKtO9Oyy4PUXK5DlC23kIg1hRZjZDTOonJCwgBvlaQJ	1356
62	In	2016-05-04 08:14:49.865072+08	2016-05-04 08:14:49.865072+08	uVWghYjSqQTYr3JSGmq5aAHXqSTb3suyORe60PXqp1Ph4iAKV1	1357
56	In	2016-05-04 08:22:03.000275+08	2016-05-04 08:22:03.000275+08	O6Bfc286dByZAN1pT1E1r43Il71wQWxpb9VFBdKopKOzhPoBQ4	1358
51	In	2016-05-04 08:33:04.147012+08	2016-05-04 08:33:04.147012+08	CI8FatLbqm8objx7y9lJxadMaKlPVCTiUbw5VJgM5oAhY8oWHa	1359
53	In	2016-05-04 08:35:22.708248+08	2016-05-04 08:35:22.708248+08	pFBTalnMBKYf23Gz8mIo8OdJ5CRtjhUZwf3XRrucBTIEWYDeLV	1360
45	In	2016-05-04 08:47:52.428919+08	2016-05-04 08:47:52.428919+08	TTt7myKEt3wOdt3gRUXM8joQwLyAzKgToaabZupTxmqbfuI7Pp	1361
17	In	2016-05-04 09:45:23.831192+08	2016-05-04 09:45:23.831192+08	TXZJxWewgdHN76wigWdWzbJqDylV7BLaitsgQXc7BtUI0S1gyd	1362
57	In	2016-05-04 10:04:50.11911+08	2016-05-04 10:04:50.11911+08	EyFXpSWbxdmJEVD7CdeolpiG9iiAQhneg3CWWi8TMumaQzhcdN	1363
27	In	2016-05-04 10:37:08.700258+08	2016-05-04 10:37:08.700258+08	RODAeMtNVK5JykMBHstQNGLArl9ZOmwpCA1qVuE1FILD4hOLaI	1364
47	In	2016-05-04 11:45:24.918043+08	2016-05-04 11:45:24.918043+08	lxY77QsHzH4w8F686b3KdIcxVgft2GCmEktLBmcB4f8CvEK2pN	1365
12	Out	2016-05-04 13:00:29.86055+08	2016-05-04 13:00:29.86055+08	MTeyRAf74hNGUb1OwCBZNFFVQBikEZ8a2nZTxFa2wyISaJqYV2	1366
58	In	2016-05-04 13:38:15.54731+08	2016-05-04 13:38:15.54731+08	8sHNOhZ8SmgaNiOwDMDnOAmgcOzTvVV4PlSnT2uvocXCLv9YIM	1367
45	Out	2016-05-04 14:03:00.79846+08	2016-05-04 14:03:00.79846+08	MgW9M9XMcUr7YHt15N2zKqcq3xmCW5Ysl528EZUq4NxcdrdiFf	1368
62	Out	2016-05-04 15:15:49.972635+08	2016-05-04 15:15:49.972635+08	iYWLQaIDmoILh4QjCeJgUN4S0hKdQZJ98pUYQmlDb5YJ8y3KdM	1369
56	Out	2016-05-04 15:21:41.958552+08	2016-05-04 15:21:41.958552+08	19j5bjmvNDVgNeWqDwdyAF4iYCibXMwYVgd7RQ3neYU1D1sQxW	1370
27	Out	2016-05-04 16:00:54.258638+08	2016-05-04 16:00:54.258638+08	P8lTqKgZvEvsmRaQY1qboVAJWNKPnIvDPhgG2NpxblqNDQnlRe	1371
17	Out	2016-05-04 16:13:05.916983+08	2016-05-04 16:13:05.916983+08	MHAWagtu6gC2tcjbslyiiaVZxi0lTRQpibMJIGEOwQQq39SvuR	1372
31	Out	2016-05-04 17:00:39.899183+08	2016-05-04 17:00:39.899183+08	ed1ADzrDlLeCCNnYg6ouUlLtcO45KyWycX9qX24JNiVZ7J8nOv	1373
41	Out	2016-05-04 17:03:32.748348+08	2016-05-04 17:03:32.748348+08	ish4nLSrQmqvlTUuK2wOKK7ptD911YxjRfnE1G6Q2vNoPrjjsg	1374
30	Out	2016-05-04 17:05:52.83259+08	2016-05-04 17:05:52.83259+08	8E1E4tSDvTlsDDZ1RZHX1JTN7tFqd8XkMYzQSSdNvPH9cpA4QR	1375
29	Out	2016-05-04 17:07:48.646416+08	2016-05-04 17:07:48.646416+08	bQk5ory3ibCGNXoNyHpcel2vufm5jCWLcGQR9OUr1g9OExkDFa	1376
23	Out	2016-05-04 17:18:52.339022+08	2016-05-04 17:18:52.339022+08	ptLrpGXcLHorcS83tHRO9S5IqKFbXUCNOXFFnmr94g1g8Aj2RB	1377
51	Out	2016-05-04 18:00:15.544543+08	2016-05-04 18:00:15.544543+08	QadVsUp86NcIj2pzGdm8nqooXwyHyQTP07vsbl1h9dzsfpsvTf	1378
47	Out	2016-05-04 18:06:38.290739+08	2016-05-04 18:06:38.290739+08	4HWs64p5MoVpEVwAOYvPG54Gyj6rfZWjq3cw8R3UGXJU3GfRob	1379
53	Out	2016-05-04 18:14:14.289185+08	2016-05-04 18:14:14.289185+08	q4guKfeQWKz44q7foF8qiOO3sRJYs8AkCqeWWJw3dw6hnDNbSV	1380
58	Out	2016-05-04 18:25:29.209172+08	2016-05-04 18:25:29.209172+08	TBtrEmJXLCeUwqLbNruKtYH1G5Edhg9Ar326pLcAXIfU916Wr1	1381
59	Out	2016-05-04 18:26:49.527954+08	2016-05-04 18:26:49.527954+08	rmZ9npE1Tvhc6Zf8fVTIf1aLUjMaGEb81BHo1VpVSX8Y7ngmJA	1382
57	Out	2016-05-04 19:12:13.180613+08	2016-05-04 19:12:13.180613+08	5yBeKfOgHeusmw44k5Zba29iaGWH3oR8ncm8IBoZpkRbgVfSbF	1383
12	In	2016-05-05 07:17:06.728972+08	2016-05-05 07:17:06.728972+08	3BHDtrTQ8WFZe4CRCUc24SlV4S1juczynHBh8e8GBNppR2HdWt	1384
23	In	2016-05-05 07:19:44.951689+08	2016-05-05 07:19:44.951689+08	fZLR6Pt7Apj9nXQzGYeOopmefEgwrDpXmBysbszkijtWHKWXsB	1385
17	In	2016-05-05 07:33:52.867653+08	2016-05-05 07:33:52.867653+08	vh1iMfv4cnGSL3eKvFDv0veuSwFyT8AQpA8Cq4GTsWvDZaXVpk	1386
62	In	2016-05-05 07:51:23.435527+08	2016-05-05 07:51:23.435527+08	Rpf6k83y7W7HwwR59I9Pl2vgFVHm17XSwDYgMbgT8mk4jC9sUI	1387
41	In	2016-05-05 07:53:14.69095+08	2016-05-05 07:53:14.69095+08	IFKEwZjEMkLtCH7kyTMewUShYCth5O1NdLaauKoG5AAHRH2PkP	1388
53	In	2016-05-05 07:53:27.673515+08	2016-05-05 07:53:27.673515+08	5hsWPSiJAnhBBLVlvQ6kgBurSL9UlttqbmN1F6KPt2a5N6rJWx	1389
59	In	2016-05-05 07:53:57.792458+08	2016-05-05 07:53:57.792458+08	5D9y5bLE678zwjmKk2Q6QL81QV7HodFtqOsvyEA5LI5I3rdns4	1390
30	In	2016-05-05 07:54:24.035486+08	2016-05-05 07:54:24.035486+08	sKP1LpWS7L6NGwk9tkN4piNu1PmeDfi7z88Kxem50sRGpDPjxm	1391
56	In	2016-05-05 08:02:38.447866+08	2016-05-05 08:02:38.447866+08	nnVAiWaUBnAttA22UygH4g9WwyjMig9WUdgDAHhL5rFy2G1WGh	1392
61	In	2016-05-05 08:04:50.942091+08	2016-05-05 08:04:50.942091+08	nKOwqLwahfHqClUsyeAg0EZFDbVE8lvv6KswgpWOVnFgZjZYOj	1393
31	In	2016-05-05 08:07:58.057283+08	2016-05-05 08:07:58.057283+08	GOxodBQ9PYuLU1fNwLDUjhIyOsixR8hhWfWApwJFVEazEFMCbZ	1394
45	In	2016-05-05 08:44:37.204903+08	2016-05-05 08:44:37.204903+08	gLHyKfr3eJBL0h1WrqTB7yOgycvLoXuUsCTDrLGWdRre9sB1kf	1395
29	In	2016-05-05 08:58:49.34369+08	2016-05-05 08:58:49.34369+08	CqeaYdDUy22uXt717yMOV0pOeyHp12VDsAnRn1vn3wharoayow	1396
48	In	2016-05-05 09:11:05.54188+08	2016-05-05 09:11:05.54188+08	MKwChcCzSD2xPu8DMvEIiHFRq7GS64PSOMf7yq6R48OU3WgPSu	1397
60	In	2016-05-05 09:27:07.065648+08	2016-05-05 09:27:07.065648+08	gBCvc33sV8wtaLHGSG7ZgCg6fjcN95IpGUlsXol2wiwX4DnWTv	1398
48	Out	2016-05-05 10:12:14.698402+08	2016-05-05 10:12:14.698402+08	6A7mGmWrAfwSVDvI6T6qV4ZRbdfPA9LGJS3YGaQQGNrman4gHB	1399
28	In	2016-05-05 10:14:41.670069+08	2016-05-05 10:14:41.670069+08	XmE7EpktGu3bBM4EuKoLk5jcrKQv1i7YVLejBPdRKg2V37jxRY	1400
47	In	2016-05-05 11:28:43.191044+08	2016-05-05 11:28:43.191044+08	JBe2nWMFSNwYuStZC5ypWJWYoZfYX78pIms6JFLkbIKWkE7wJ6	1401
27	In	2016-05-05 11:42:34.152593+08	2016-05-05 11:42:34.152593+08	mpPJOEs4nQAvGSh9Y1Otl0C6WwKdtdjgS9zqNsuBJ56aXoj7p8	1402
11	In	2016-05-05 12:05:20.835636+08	2016-05-05 12:05:20.835636+08	1b8EheB2I5f2l8AlzXeuixzoYXdIeTQf5YtmD5oVAUXvdhhcFM	1403
13	In	2016-05-05 12:39:50.098708+08	2016-05-05 12:39:50.098708+08	XyKXns5RBkubQ0AKmNPbsa7QWj8DNOZuMtSAmYbxIWYiWi4J6T	1404
57	In	2016-05-05 12:49:52.353169+08	2016-05-05 12:49:52.353169+08	vy43PZmXnAvM5IGXS2540OaY78IBROeNNiPnICL6MHSRZix2k3	1405
12	Out	2016-05-05 14:00:32.244624+08	2016-05-05 14:00:32.244624+08	6kRhKYocjG1OdO73CPGXVcnx3Ng1PR5WCWDW539oJACwYJ0jiG	1406
45	Out	2016-05-05 14:18:21.516941+08	2016-05-05 14:18:21.516941+08	HEs5BvTrwsJ2PVYc2deBRxLeusxvdgCtu4y60SxwLHyjmXMoB2	1407
17	Out	2016-05-05 15:39:57.646953+08	2016-05-05 15:39:57.646953+08	1dzMHuFFqrv2mq7lw7Eu4ZC4JybgomhoQhBhcQwTItV5kcqhj5	1408
23	Out	2016-05-05 17:00:49.044002+08	2016-05-05 17:00:49.044002+08	cneorxnSecFMRf4cNh3KALEgQyJHg3NJq28h0vBeYQ2z66cTnf	1409
27	Out	2016-05-05 17:02:56.447965+08	2016-05-05 17:02:56.447965+08	nx12eS1xjg07zq88Y94jncBpcHvFkiuYgvaLObJ8IJFIANQiWU	1410
41	Out	2016-05-05 17:03:43.862916+08	2016-05-05 17:03:43.862916+08	TK6d9iu5wfnrEUnopCQ9KiSZ1cwRLSvom2SwjN1h3oZHKN5AZV	1411
30	Out	2016-05-05 17:04:20.969837+08	2016-05-05 17:04:20.969837+08	JtEkTFNPgisbXfd1cNOd5QTehm2mwbIGVW1ylOOS8H4fwhgZ54	1412
61	Out	2016-05-05 17:07:21.003015+08	2016-05-05 17:07:21.003015+08	DAVgoDUrzRTIgyohxa7N3Ee7tboaCteP5A6tNalM1EfiEUQC5X	1413
53	Out	2016-05-05 17:45:15.525421+08	2016-05-05 17:45:15.525421+08	Y8mDFgp4H1xvQ26WvT7hp9vVrAzIL5puDc8RJwVayTWPVcvR64	1414
62	Out	2016-05-05 18:02:55.088335+08	2016-05-05 18:02:55.088335+08	9vC5R4FRMaVCViocA8afhY9Exert6xxFtAKLEZmaAIme1bIBjs	1415
60	Out	2016-05-05 18:03:11.832825+08	2016-05-05 18:03:11.832825+08	qRR0gPeYKkVIzQSJlgsYI3q5hrgz4QrurJuYjZ73KcLJ3ndoVW	1416
31	Out	2016-05-05 18:14:20.525027+08	2016-05-05 18:14:20.525027+08	NmYErG6YF9y84rRyQBYXEsAZCDOp1tLOgubYAh7Qq6YvxyuOAT	1417
29	Out	2016-05-05 18:14:37.156756+08	2016-05-05 18:14:37.156756+08	uOM5xZIMPJGkhwfJVp1cGsjonhni5xD1MZ6L9OhYgxJOuyhQoi	1418
56	Out	2016-05-05 18:15:02.022841+08	2016-05-05 18:15:02.022841+08	35altPTh8ZgLZ3ufO446ck4v9yuqPjZSoAEiZhRhH72qAwXY1a	1419
47	Out	2016-05-05 18:16:55.870582+08	2016-05-05 18:16:55.870582+08	edMiZVhTL7DuZ25nkeWCMmKOeUMB3Nmh18RZd93yGGupIze3eA	1420
11	Out	2016-05-05 18:29:19.677581+08	2016-05-05 18:29:19.677581+08	G1xZQb4ln79ZpAiHjMQnLg4GXMGBPuMfvJFMvK8iRHJHR2YBNy	1421
59	Out	2016-05-05 18:35:14.00864+08	2016-05-05 18:35:14.00864+08	yif3yDPFOoAkU64jR04ZjVq2mI4LTRJSByVACtOaiYLDePx6Q2	1422
57	Out	2016-05-05 18:37:12.472393+08	2016-05-05 18:37:12.472393+08	f9XWCKoGeJhylsxG2ABRktz68eV5kv7Q5ewHxlXc5Fbp7Z7AiI	1423
28	Out	2016-05-05 18:55:21.826093+08	2016-05-05 18:55:21.826093+08	aTCaZJF6Pz2WQ7ANO99vlEBN4IwBSfT3AfdjysoOsqtJx5fMDp	1424
13	Out	2016-05-05 19:06:49.94981+08	2016-05-05 19:06:49.94981+08	Iy4SN8kJJDzmG9StsRmipfZjyXoet3UB2XePfPiycimrsFllgY	1425
61	In	2016-05-06 07:46:24.150421+08	2016-05-06 07:46:24.150421+08	TWE3GDa6rT8LeAsJZYiIYK1LCtZyfGX9mlC4ym9pGICuS5E2ew	1426
11	In	2016-05-06 07:47:52.625378+08	2016-05-06 07:47:52.625378+08	LCHMXUG7SvOz5BlIEj5OaLflG8qUBVSVhjrFD9Ng4kfAvRRABW	1427
23	In	2016-05-06 07:48:31.104313+08	2016-05-06 07:48:31.104313+08	YlqFX8NPcYu54cnvs25Fh90OJvpk71Hfm9uLGIksqexuIlqAnv	1428
30	In	2016-05-06 07:51:46.792374+08	2016-05-06 07:51:46.792374+08	PV5QtOMjATkR9Xa4sqMdjDIh7aUxkItAnyahOxQYRBzaiafbR2	1429
53	In	2016-05-06 07:54:37.058673+08	2016-05-06 07:54:37.058673+08	FBEXsM8NKsfE3SDeAbba93l9eUjK6AMLLasFw1cGtHUwjhatJD	1430
41	In	2016-05-06 07:54:51.845996+08	2016-05-06 07:54:51.845996+08	UTGGcukMFqWaCrB5786iOz1tvkbXeukAO1Q1vAMB2smEkxJr6P	1431
58	In	2016-05-06 07:56:58.624281+08	2016-05-06 07:56:58.624281+08	aVPbPLM0s1vdBJeaKblgmnZZ1KXLBekl9ANYVjYOkU2vnhX8IJ	1432
55	In	2016-05-06 07:57:00.526432+08	2016-05-06 07:57:00.526432+08	o56Oe8hCStqDfzN3Ytm8IYcLUQ22YKKNPQl4YTG1N7F37c6fWt	1433
54	In	2016-05-06 07:58:58.993286+08	2016-05-06 07:58:58.993286+08	moRP9vpBwOWIlviX0H2GIPNXSUAYAgSwVtMepBpmZM5LInsI5u	1434
51	In	2016-05-06 08:03:48.226558+08	2016-05-06 08:03:48.226558+08	ZNKwumR6LamnXHhtvX5mKe9P0RDtkIoKf8HauigHJT5qkmkgKp	1435
59	In	2016-05-06 08:11:33.615569+08	2016-05-06 08:11:33.615569+08	TfUc5V5IOpaD9GMQrH9XXS1cJlP5SjuwPPZUuemJUNWdds4VAD	1436
12	In	2016-05-06 08:15:40.501339+08	2016-05-06 08:15:40.501339+08	3hf4Kzpj4JTyFsOoMJT9cxW9bB2fgCsjsYnDYewcwQbCJz2fJV	1437
45	In	2016-05-06 08:32:06.478134+08	2016-05-06 08:32:06.478134+08	pvTM54X7jDIcwCBlPjPMMMmwZ6walG6bCZxHdVONigzfsBRItq	1438
31	In	2016-05-06 08:53:15.022191+08	2016-05-06 08:53:15.022191+08	eGESDmYBOKRUvd4tuhPJ57z5nsFFBA6pPJId7qoUBGz7t41nlQ	1439
17	In	2016-05-06 09:27:46.859045+08	2016-05-06 09:27:46.859045+08	7qY7uLzBaBKg1kzJO79CbKSbSLeTAQtHGSNCnNMOYh4YR4rpB1	1440
60	In	2016-05-06 10:12:34.99929+08	2016-05-06 10:12:34.99929+08	2mMUOnp3IzSCGjdduR1HpZyt8Qy0G91IvNmKBcNTbperZJWUkX	1441
28	In	2016-05-06 10:15:53.386434+08	2016-05-06 10:15:53.386434+08	ma7lVGCTGSdHkZeXtpAHJl7xegHAB2ixdpi86ucMNGc9pHgj7p	1442
47	In	2016-05-06 10:30:01.730784+08	2016-05-06 10:30:01.730784+08	1Pb9NGpeQ1h9yKyhT5d5R1L49BLpvSfwrI6GYvuyvc8uw8cPDG	1443
57	In	2016-05-06 11:15:35.342912+08	2016-05-06 11:15:35.342912+08	VdHqiR34HxWwvOF2enwZmtCuo93RYGh4tyucQxfhvCerastGgq	1444
27	In	2016-05-06 13:02:56.376356+08	2016-05-06 13:02:56.376356+08	pTj2OYBR1jhinbhjE8gtpd6TVhNOw4FmXzovY1NZk4HYfzIt8z	1445
45	Out	2016-05-06 14:03:10.861344+08	2016-05-06 14:03:10.861344+08	nxctS8boWYslLQlBMKBitvnBVTBnMJmAHQ4iYfY5ERqZrdkExw	1446
12	Out	2016-05-06 14:16:38.291593+08	2016-05-06 14:16:38.291593+08	wqsk2OEDBaWylnOpWwU52iXsIPW4dU0aLsLNGZaSB7QvuplSmH	1447
11	Out	2016-05-06 14:46:10.954646+08	2016-05-06 14:46:10.954646+08	Xoz5hIUEM7hMh3F4QVd2xo9Ok4EWW1n4on9W6dkSkSoTV4WvZB	1448
17	Out	2016-05-06 16:30:24.264675+08	2016-05-06 16:30:24.264675+08	xXy7vkBBHhB5m1svXyZHRKjGnFKKCtVARUGNFRYVAjavjTrHSR	1449
57	Out	2016-05-06 16:54:05.606254+08	2016-05-06 16:54:05.606254+08	YtlJAZYUtkOOtosBD8ckdmUFiFibWC356oOGNwkHh9gbyZmBhP	1450
53	Out	2016-05-06 17:00:35.963343+08	2016-05-06 17:00:35.963343+08	wLCRavfJXCVZHbOfrmcd4KmjvlKiw29tNLKxH1IoDnOUPmAHZm	1451
28	Out	2016-05-06 17:01:52.687046+08	2016-05-06 17:01:52.687046+08	ud6hN3ThlQiuJ6Ge4YeMMr9kMYYVp7IkkOS8RuoDLY8eeOJiwx	1452
61	Out	2016-05-06 17:02:21.246918+08	2016-05-06 17:02:21.246918+08	5JpE5Cmchck0NUOocpkS350Bkea4MX2Rqrfu4SXm4ImRmBGP21	1453
41	Out	2016-05-06 17:02:48.511746+08	2016-05-06 17:02:48.511746+08	r56rGqWqusOvKEozAsRhfWzSxmdEDeF5jLw1CSr6LF3fUrfdk7	1454
30	Out	2016-05-06 17:06:37.430764+08	2016-05-06 17:06:37.430764+08	LQdLra9VoLA4QtPMuapmhB2kqWbWBMdWmGrer19gMJjmE999jy	1455
47	Out	2016-05-06 17:34:10.122713+08	2016-05-06 17:34:10.122713+08	uRAwC1UnXeABBwR3bJ4kyQ4jDIrMRbLM3UJFVn33SDEdAfhlyl	1456
23	Out	2016-05-06 17:48:55.213752+08	2016-05-06 17:48:55.213752+08	WxCahPsZlKB7gFb0U8nXBGkOtu4bf3NC1ZmizfIlzTsfiUgCcU	1457
27	Out	2016-05-06 18:00:13.326738+08	2016-05-06 18:00:13.326738+08	jnkUCeOGG5KdHLE44DjMyiprPYM5kyZUmKxyzNFGSZtju8myLW	1458
51	Out	2016-05-06 18:04:22.303706+08	2016-05-06 18:04:22.303706+08	LKFBCejYkUXKyKewJeKYum8oV3wJ2IpNc5YojINUmvolGTiZ83	1459
31	Out	2016-05-06 18:04:33.734716+08	2016-05-06 18:04:33.734716+08	83pGrLJoeL7UijYHYJawnNsc896qhEupHj696Pxkk4ETnnkN7L	1460
60	Out	2016-05-06 18:04:59.29493+08	2016-05-06 18:04:59.29493+08	JthCWqLch3rct9MzISPFDAKRd8FOVLjoGR1mIMP1PHcJQzIhSh	1461
55	Out	2016-05-06 18:09:14.867539+08	2016-05-06 18:09:14.867539+08	wfrH7UPLsuhcjw5kjN7AOWQ1oq18YTpW8gnFCDa58IiqFmczBi	1462
59	Out	2016-05-06 18:22:46.316495+08	2016-05-06 18:22:46.316495+08	9YFaa5RaD042WCjKRvX21eKiVaW8agqjG7KpClRPlVRIhBc969	1463
58	Out	2016-05-06 18:23:23.562763+08	2016-05-06 18:23:23.562763+08	B7nWpK6MSg3JQJQk9cWa1I5SamdDvjM7qBdgUj3wQ6HqPhbYK8	1464
54	Out	2016-05-06 18:32:54.770646+08	2016-05-06 18:32:54.770646+08	9LQEn11RDwBa42khiGRlDsrUjHBMpVUyqtDeuE78BIiFLTx4jP	1465
28	In	2016-05-10 07:47:42.035116+08	2016-05-10 07:47:42.035116+08	qwIiR21cOq8spym3dhHkpS3ZiO3fSm6JjO2BQ3notvhjuUmYC4	1466
23	In	2016-05-10 07:48:06.705034+08	2016-05-10 07:48:06.705034+08	K2WNbFleuFR1YBOaNocBdW7LG2p2b16v3cJer5JmKjnrvCSI26	1467
12	In	2016-05-10 07:48:25.598881+08	2016-05-10 07:48:25.598881+08	Tfcb1rdptFr1AudTZVYrIsc5kXIDpJJKyuuzmYphnhhycLSBq1	1468
51	In	2016-05-10 07:48:36.968376+08	2016-05-10 07:48:36.968376+08	38sfEdDVq3oANn5InrrdZfLHexc69T7Db0roe6LV9AfWxkolcg	1469
41	In	2016-05-10 07:49:02.174707+08	2016-05-10 07:49:02.174707+08	QCMlU0j77saE6BEx1s4MODV4jUoYGSFgebS9bCFi5pwB1B924D	1470
58	In	2016-05-10 07:51:24.620465+08	2016-05-10 07:51:24.620465+08	OSQtW9OLhenwLSYobB1qt6gpHh1Rk5e9X434DRPv6DsRfRGHcH	1471
59	In	2016-05-10 07:51:47.729258+08	2016-05-10 07:51:47.729258+08	8WNoMfWN6HTkQ0oT42uUx1hqTOIjfu0nROco39C9RftqfiKkkF	1472
30	In	2016-05-10 07:57:28.754284+08	2016-05-10 07:57:28.754284+08	EhGwYjKqSzmSnEqQ3tZF31uwrafCKQRZ8hVgRqYtqKMdYD4b7d	1473
53	In	2016-05-10 08:00:28.368304+08	2016-05-10 08:00:28.368304+08	qBel8WMnigDAGMrl3JbaDSvZ6UnA6unw6SiDy51glEq1ajmd3P	1474
13	In	2016-05-10 08:15:57.743575+08	2016-05-10 08:15:57.743575+08	EGrApxed8kYwhdPQrNVs4H7vIhf5LhUZxMjnKORS90PqdnIVBn	1475
31	In	2016-05-10 08:36:07.900635+08	2016-05-10 08:36:07.900635+08	OG4VCMDqRYZv8XIsLbHm4QmTHRHZwTMLjQqum4mFcLBksScE5t	1476
57	In	2016-05-10 08:37:23.724065+08	2016-05-10 08:37:23.724065+08	29KocbGtADNWY7xO2kSoz5ABp3dSIiMJrg9UIPOSclyBswZuh2	1477
54	In	2016-05-10 08:45:30.750544+08	2016-05-10 08:45:30.750544+08	jh7tsvwWPFFlY7Shbj7zCjlCte9UZqWJYdDRZAxyPDkxKCfvwm	1478
27	In	2016-05-10 09:28:12.971837+08	2016-05-10 09:28:12.971837+08	v9WhLQMUuvLRFt4SLecJc3XN1rZgnWTjf0R1RoVMkpm0jrS5V6	1479
47	In	2016-05-10 09:32:11.437985+08	2016-05-10 09:32:11.437985+08	P98wV9o6qccKMIKnJlco7NeuNOlqTIvsQ5pwEd35GePcwjQGV3	1480
29	In	2016-05-10 09:44:09.693723+08	2016-05-10 09:44:09.693723+08	5dQiXn7KeacaT3fJ0uw3zDhPpe9HufK0IkjqYqBDRmnvpTFpOC	1481
60	In	2016-05-10 11:42:56.480996+08	2016-05-10 11:42:56.480996+08	sOPanFFwWBbqBubukAlvNDiB9YfOP4ZIRysFE8CkJnaUiCPTMA	1482
11	In	2016-05-10 13:04:54.591461+08	2016-05-10 13:04:54.591461+08	PjN8uWgZu6dUO6TGLhPWShK4C3GbWcluL93GfjqapU5EZYUuHt	1483
12	Out	2016-05-10 14:02:53.627802+08	2016-05-10 14:02:53.627802+08	Rjbmnnp4PMfBH2LKI149btcg8DGc8WWZH8M5vC8LYnXopr98sD	1484
13	Out	2016-05-10 14:04:07.873934+08	2016-05-10 14:04:07.873934+08	HV7tCF7SrFyOoGVBKRNSnvHLk7DuF78VbFPnUWGMlFkaUGmoiA	1485
27	Out	2016-05-10 15:02:25.492911+08	2016-05-10 15:02:25.492911+08	IW6Yqqf5kuBsRm9qadNq095kka2WPjghGmG7dvCOrNHJAQAk4X	1486
47	Out	2016-05-10 16:46:41.680567+08	2016-05-10 16:46:41.680567+08	b5hhpRHrygbfOrSey5aATSXllhCuTGS5LAmBb43akeG9VhmUnO	1487
58	Out	2016-05-10 17:00:23.191955+08	2016-05-10 17:00:23.191955+08	eHqD3buFXNV0SqAF2lJ5M3jcCFKyj7NOOEbRpWgNtCNM3Xb5Ju	1488
59	Out	2016-05-10 17:00:55.692354+08	2016-05-10 17:00:55.692354+08	AfxtIA9cAsjXI8ltabPHyKTMgWtIbDDltCfBMonViX30fotGQJ	1489
17	Out	2016-05-10 17:25:10.386786+08	2016-05-10 17:25:10.386786+08	WQd0mKWgd8uqtn2azOPmu8Kx81m2HELndynQJK8wS2nMppwpEM	1490
28	Out	2016-05-10 17:45:40.622515+08	2016-05-10 17:45:40.622515+08	d9Ux7cyteF8z3lyqDIBKFdM20Drw37KfGodNRcH5rP5vB4mOMy	1491
51	Out	2016-05-10 17:58:58.802327+08	2016-05-10 17:58:58.802327+08	iac5ccIVaLbt2rifFAIWFBvK67OtVjrEKUJx7cShx4bzvKfBTx	1492
60	Out	2016-05-10 18:00:08.37036+08	2016-05-10 18:00:08.37036+08	gi8c4FjR8EC0SWUmUbOwJM1uMxF28iypR8RVMBwVQ9Vsf1fAc4	1493
23	Out	2016-05-10 18:04:10.012921+08	2016-05-10 18:04:10.012921+08	7vQ9qm66oFon4GvWlIhjn8sK0YKfiwjqtBzkx6qmLfaPvWvhod	1494
41	Out	2016-05-10 18:10:51.897885+08	2016-05-10 18:10:51.897885+08	RdlKwlsHSbFCS8NSsLYj8tPiJLFG34tUhfoeRgwtIB6kKSDDnl	1495
30	Out	2016-05-10 18:11:48.188945+08	2016-05-10 18:11:48.188945+08	wvfMeyhsFkx9Ffo3KGkGA3SGnli1yWmwSSI6R0zgkxpzcd3wun	1496
53	Out	2016-05-10 18:13:36.328758+08	2016-05-10 18:13:36.328758+08	E5qfLeS4fRaSO3ug9Mg93R7sRjWUgRIuV9aqn3uTUVvsYqZhEG	1497
31	Out	2016-05-10 18:13:56.586165+08	2016-05-10 18:13:56.586165+08	rHix9AhfeP7wKd6uUsxPMSuILTAuBNC3eu1n4iUj8bgREmMifK	1498
54	Out	2016-05-10 19:02:42.5994+08	2016-05-10 19:02:42.5994+08	83m3L9VU4hrGjWAkKFToxbQe4eRQO8kWAYYVh50llr1WPCHjQk	1499
29	Out	2016-05-10 19:06:17.794482+08	2016-05-10 19:06:17.794482+08	YPMy4QdVq2dcXnB7JrBJdxCeTaqkKHVsgrrkJWGAYtm6ixC2pO	1500
55	Out	2016-05-10 19:06:37.461095+08	2016-05-10 19:06:37.461095+08	LTMW8p7xaSF6LvxEgHjxRIrEOaBab1ywTLTbAbZk3pqPlocS6M	1501
11	Out	2016-05-10 19:09:33.201604+08	2016-05-10 19:09:33.201604+08	QWeIk3svdUwcRQwu28WcsZRjxEYbgdx7BcPveIrIlouDFr8Hzd	1502
41	In	2016-05-11 07:46:45.25782+08	2016-05-11 07:46:45.25782+08	trDLbCZAmGnkNyNmu24mKqbF4q7C86p1y4MaFvj3BYnYXBLSDP	1503
28	In	2016-05-11 07:48:17.292183+08	2016-05-11 07:48:17.292183+08	FXGqmKhtWo0MpyQCZf8JiJrWsPhErud7StxFEf9kUA7K9XWiDe	1504
23	In	2016-05-11 07:48:39.08507+08	2016-05-11 07:48:39.08507+08	2vytSqJ95B4iJWcHlrvucQ5jkEHIwUwyQvssmD2rO6ahcEyP5u	1505
61	In	2016-05-11 07:50:08.478605+08	2016-05-11 07:50:08.478605+08	KhLPR6diOaDLadHTV4gYv5eXmHkkgqf1Y2Qz85iWfvrGY9j5DP	1506
12	In	2016-05-11 07:50:26.131738+08	2016-05-11 07:50:26.131738+08	c9UHgHZR2GIhHqjhqrlYORUGh3PQ8cqklL3RbcsdrBM926qrxc	1507
53	In	2016-05-11 07:52:25.849625+08	2016-05-11 07:52:25.849625+08	QM4uclx2C6d3rPOuq0XjePu0Yw6Po42FP6A2r944Fh777V2xVZ	1508
51	In	2016-05-11 08:04:59.276202+08	2016-05-11 08:04:59.276202+08	hAycBXZHwOKydk4nmvwq1DY8KfdMdAvLKuyUSYlPw6OZqSOcPL	1509
30	In	2016-05-11 08:07:44.22475+08	2016-05-11 08:07:44.22475+08	TPY2XshCFLLBhf7gAZEvyB2Nksp9VFUyf31DviPB5kMlQTSa3g	1510
58	In	2016-05-11 08:18:07.225194+08	2016-05-11 08:18:07.225194+08	W3rYQdRGmwVHvBKwOGfmRkXnWxIyYLg6OYenC65y4aGzlaw9qc	1511
57	Out	2016-05-11 08:18:45.55203+08	2016-05-11 08:18:45.55203+08	wINU6uSOt2ja879mvLs0JwaZwMAtV1WSIuwOoPmjRWJZdSMZnF	1512
55	In	2016-05-11 08:22:22.5485+08	2016-05-11 08:22:22.5485+08	Z7CBg9Wq32rZUATRYJrM2JsMsWoF6cUfkgqRpNIsQASuKvMtFE	1513
56	In	2016-05-11 08:24:33.575575+08	2016-05-11 08:24:33.575575+08	GHX8dQeSfk5BRprIHhfaa5k306yNzEbFV9N9a2bGngQEWIWn1B	1514
59	In	2016-05-11 08:36:18.784094+08	2016-05-11 08:36:18.784094+08	ObH9eHFdeEqGTMPrVzt6FhngvKyR8zdWbufFCusq9j7c7WUbVO	1515
13	In	2016-05-11 08:39:04.699308+08	2016-05-11 08:39:04.699308+08	il5VS1pRSxR6U21AID4B4DuAp2gKdCiMxnrQohrHfIOAKPKccP	1516
62	In	2016-05-11 08:40:59.332369+08	2016-05-11 08:40:59.332369+08	nfciqSkXmPjUlhId87MyO2HmCcCXFnv3UYmK1XrnwbIhJaMRhh	1517
54	In	2016-05-11 08:46:10.556454+08	2016-05-11 08:46:10.556454+08	Q6jiswK5TasPdMxQhyxZmuB5cUfyvNgMTQ4NNPRqzKGdgE4OE2	1518
29	In	2016-05-11 09:09:08.221977+08	2016-05-11 09:09:08.221977+08	x1v96ZdlYZ9Fvdf103QRtPlA3SO6rc8pd4yidcUCCdQ8H69H8Y	1519
31	In	2016-05-11 09:49:38.224313+08	2016-05-11 09:49:38.224313+08	i2yUC1wa8oDGepKcZxG4AShaaxgjFoIyqHT3IQdQFqftg0WGym	1520
17	In	2016-05-11 10:02:43.075259+08	2016-05-11 10:02:43.075259+08	J8E1ioyOYFDqD48g7Q7kqMbWGIXmXVZrdosMdrkC7y3L3B2Ab9	1521
60	In	2016-05-11 10:29:18.439816+08	2016-05-11 10:29:18.439816+08	uRVWxlnVZM19Eex61bxln5kqQn2Sxdas56P3sDYSZZbnEYtFAr	1522
11	In	2016-05-11 12:15:29.180251+08	2016-05-11 12:15:29.180251+08	1xxkoOYrpWUQPZXodQ2CrblTOy2IECAFB80zVYrL5MmUvKIZjK	1523
27	In	2016-05-11 12:43:20.883335+08	2016-05-11 12:43:20.883335+08	lbvW5KW7ckJmzUuzUQYLmdhZ8esQDdkyFgVK22SellRlGMlknK	1524
47	In	2016-05-11 12:52:46.286844+08	2016-05-11 12:52:46.286844+08	6awo95S3VggHevxAGyCidxU5jkSVVFpbpmQyrs2NZieEecPubb	1525
13	Out	2016-05-11 14:01:23.229111+08	2016-05-11 14:01:23.229111+08	dFZ8KKsmpO2e0rRQrJJtgscL7HxWCZ8qohy91rvqGxVHpwhhG1	1526
12	Out	2016-05-11 14:14:28.580449+08	2016-05-11 14:14:28.580449+08	bxtEJ2UGYgpfXeNWnPOiGehlvXicFzeqwY4GZYW8GMon0CKnbi	1527
53	Out	2016-05-11 17:12:59.19189+08	2016-05-11 17:12:59.19189+08	WrNEdJlMv1MZqJ8uYiU5qkReYRqrFSalKx0wGlJCmfmdxuYXd3	1528
41	Out	2016-05-11 17:12:59.274069+08	2016-05-11 17:12:59.274069+08	cUm49LV0DkSnWllWj2I3F5i1igvHEZJp47tCSPCfAeUgRGDBIW	1529
61	Out	2016-05-11 17:13:58.871615+08	2016-05-11 17:13:58.871615+08	DXbvYJcVaq5tg81aLTzX99Ccpds3oBZ2iByHUbm4Sqx9yyjKSj	1530
17	Out	2016-05-11 17:20:09.14814+08	2016-05-11 17:20:09.14814+08	rbs4Eii8mXJMZ2XXJ1966bw4kv3UGVE877DMpvTcSmy2oVZ8Wj	1531
23	Out	2016-05-11 17:20:16.657671+08	2016-05-11 17:20:16.657671+08	EcLBg67jaNGnWNuijkeDN71L9pqjxNSC0nMgtTQUrgIO4D7nxl	1532
47	Out	2016-05-11 17:33:58.509543+08	2016-05-11 17:33:58.509543+08	1Ls2g2qXlouE1v2Ncvq3Qiji7nvEbt0cEsduuVSgKNvKJxhvtZ	1533
28	Out	2016-05-11 17:37:08.802876+08	2016-05-11 17:37:08.802876+08	yKIi3PWyd8sdk8WP3StV9Es5YC3G7wp6H8oLXMKBUDoFLLeOnY	1534
51	Out	2016-05-11 17:51:44.478599+08	2016-05-11 17:51:44.478599+08	twmm2Ly5b62RCJZ2e7NyHrC67XSlvGKpD7cFRaJ3gLUse4uJAI	1535
60	Out	2016-05-11 17:56:49.404806+08	2016-05-11 17:56:49.404806+08	ISBUYI214yGOnTVQiw120hNUa2YVKincAy7iH9jL8zjvTFMCDO	1536
27	Out	2016-05-11 18:01:35.470511+08	2016-05-11 18:01:35.470511+08	ED6ahgcGCwy0Z9ygrGqbcybMu5cIHofU2l6jSizefyeF8ew0un	1537
62	Out	2016-05-11 18:01:40.455691+08	2016-05-11 18:01:40.455691+08	cXmEthJWyaLf5NQB7st7XZ6CoDqlElZpJL4D3Nj3x5h4S9FY28	1538
30	Out	2016-05-11 18:01:56.139429+08	2016-05-11 18:01:56.139429+08	fZhllWycIDOq3iD7vGVfITk0XC9llBuRkbDW8C9QPYHSGTaCj6	1539
56	Out	2016-05-11 18:04:17.310359+08	2016-05-11 18:04:17.310359+08	r2Zc27pBsaNn37PGeXSnxrMELciupS1hUaKWhAiak5OnDn4qLV	1540
31	Out	2016-05-11 19:04:39.26504+08	2016-05-11 19:04:39.26504+08	eIN1XidFdThfBCGVixfRYRWwFjkIa6oFOCGvutBZNsFY5V4nTk	1541
29	Out	2016-05-11 19:04:50.467133+08	2016-05-11 19:04:50.467133+08	F2BlyQVji6pXMEjcAfWLEuETTJxX7RIMTT8TtdDcj3A6IuhRZF	1542
11	Out	2016-05-11 19:04:53.46405+08	2016-05-11 19:04:53.46405+08	mo91HcJGAQhSmBvueqYsTIveNEY6f9KSwUSF7lUHCDkyOgt3XR	1543
59	Out	2016-05-11 19:04:53.492564+08	2016-05-11 19:04:53.492564+08	v1jre75EDkMXDJ2fY9S3ReGBderXhPydQiV5paJ3LfaYzcEXmg	1544
58	Out	2016-05-11 19:05:42.173552+08	2016-05-11 19:05:42.173552+08	bDLrOyVHWEgVq7FMD5wW8ICiqCM6j8mLL8Ck7i2dviAnpOA3T7	1545
55	Out	2016-05-11 19:07:22.772968+08	2016-05-11 19:07:22.772968+08	ZbPlKGwgMgo92BGEuOww2sfCgVaqY4w7fNs0dpgzWV9YgPmbmj	1546
54	Out	2016-05-11 19:13:26.917274+08	2016-05-11 19:13:26.917274+08	ZocE1Jkb9If7QKTJL7927fXFEEe0pSjPHMdIfOtogYv7tPQEWZ	1547
23	In	2016-05-12 07:44:05.771274+08	2016-05-12 07:44:05.771274+08	GdEnsS2YSs1DIIZvaFKT422y9vOZAu8QYNFSpH0IA1VRJ4NtJi	1548
62	In	2016-05-12 07:45:04.204272+08	2016-05-12 07:45:04.204272+08	NMjPMsLkSWfawExBgmSg5cha41eRtxAHKtggm3RFY7pVLmh1ZA	1549
30	In	2016-05-12 07:55:08.769272+08	2016-05-12 07:55:08.769272+08	hemPFqQtIKrScCMJs9MKOuRERm19naJWF5vUvMOEgGgJS4cMDy	1550
41	In	2016-05-12 07:56:40.741382+08	2016-05-12 07:56:40.741382+08	gbt8pLupUjQmFfsBAoXY3EokXHnAd29Kd3TTPOJs7jgNPYXZN5	1551
55	In	2016-05-12 07:58:27.128925+08	2016-05-12 07:58:27.128925+08	8QJwBqFz1s1ADeEg8c5QVCBCZak7A8DJZWGkNVjOOlYbQmIXPN	1552
58	In	2016-05-12 07:58:51.872075+08	2016-05-12 07:58:51.872075+08	yuZ979jsGt1TDazTLNy5lNqKyG7InWfmSFvZOfSeZT8m37GOUF	1553
59	In	2016-05-12 07:59:09.314153+08	2016-05-12 07:59:09.314153+08	TGcKacahtOEZBgo6GDlirLBz8F7Odbd7rGQSr1AlPOLZ5AgLMS	1554
51	In	2016-05-12 08:10:10.322846+08	2016-05-12 08:10:10.322846+08	4EnFEvULK8wwFoDfH5gRr6pDguNMHjoKxcaCY5XsCTpRI37Z8n	1555
56	In	2016-05-12 08:14:16.882949+08	2016-05-12 08:14:16.882949+08	1zuqCalZx2JmNIQwUy21rEVhfnkmNsbNrWE57ze52xrPGINjHP	1556
29	In	2016-05-12 08:23:42.708255+08	2016-05-12 08:23:42.708255+08	l9dGpJ4a7RSioLE3PL34R52JUIbr2sGn2t4sE8TKZv3OHHRgdU	1557
17	In	2016-05-12 08:24:52.515304+08	2016-05-12 08:24:52.515304+08	k4ZnN46zv8sCvu61nK9GeiCh8TyZAc4ugdi4ho4cwwossutfF3	1558
61	In	2016-05-12 08:29:32.841993+08	2016-05-12 08:29:32.841993+08	wtl9btcaTmDXitBRyrG3UD0K6sFzYU3VPpe1jHbD5pkmjuEinU	1559
11	In	2016-05-12 08:44:47.993376+08	2016-05-12 08:44:47.993376+08	lIhlcnernDMqhlfMmPdPciENWxIkg6FROwD1krsY4GPm259oUn	1560
53	In	2016-05-12 08:56:16.794499+08	2016-05-12 08:56:16.794499+08	E7WSU2Qmm7s2YIylJjdCIiRgUTldIHRWOxxszOfmVZp4qoqAYU	1561
12	In	2016-05-12 08:58:41.719808+08	2016-05-12 08:58:41.719808+08	MqCnYhIKLabm6zj5sjTYWy8M4yBt9jOVabK9IbTdC4QI4BNwuq	1562
54	In	2016-05-12 08:59:48.534549+08	2016-05-12 08:59:48.534549+08	VRpdntcynliDHKnbS6DvjO0Bg5L41GuWhkAVelVTXEfoXTQ1Zd	1563
28	In	2016-05-12 09:08:48.255286+08	2016-05-12 09:08:48.255286+08	wK3wUj2qn36iZoTjK8Vpb33HsbkJcLwYfzVAiX1WZ7F9vjsGrO	1564
27	In	2016-05-12 09:29:50.709671+08	2016-05-12 09:29:50.709671+08	5TR9kKkWdMqauWZQgJxgpXn6hjpayhy5BQDvkxSNKJxFpYfWrd	1565
60	In	2016-05-12 10:51:48.351953+08	2016-05-12 10:51:48.351953+08	DhB1nskdTkLRoWr2Sczu0KEyZ4XFaOsn74ouwaXQKss9PkCrNC	1566
13	In	2016-05-12 12:36:13.117463+08	2016-05-12 12:36:13.117463+08	lNV0M54sJeHCSOGHJErqeCjXL9IX1fim3EnOJrHdWZpyx6GHK8	1567
47	In	2016-05-12 12:38:54.305399+08	2016-05-12 12:38:54.305399+08	8yKrWf1oD2UvoWAcuUUC71lwyj3F0NN8Mh1sM2hZ4CVsifVdAz	1568
29	Out	2016-05-12 13:14:28.155123+08	2016-05-12 13:14:28.155123+08	qH0cDzMGFMdcUyKVrgXZGbllUUR09b0zs0b60xMFKzsoyCKqsq	1569
27	Out	2016-05-12 14:00:36.90422+08	2016-05-12 14:00:36.90422+08	Q9SCuwgNxpyxorxRxxPKEjK6YJJsBCkbLDnHAVe8Ld5AU4bS21	1570
17	Out	2016-05-12 14:05:47.492022+08	2016-05-12 14:05:47.492022+08	mGk7MKQfDbrwDDA1UKW9SrlX2GbdidfVtQdGk4vxfnus15tVPQ	1571
12	Out	2016-05-12 14:07:18.720376+08	2016-05-12 14:07:18.720376+08	erIQQKg2xQfdvZ4ZpodllIZgBal56CWk4nAU9rW7HCkDlombcQ	1572
11	Out	2016-05-12 15:09:56.306409+08	2016-05-12 15:09:56.306409+08	NOiw6tXrzd4VO8KYcSQ9ZhLKv78hil87Aq4Gkc8kGBGdJaDv3c	1573
30	Out	2016-05-12 17:04:57.984406+08	2016-05-12 17:04:57.984406+08	5cLQvGX5yHp7N0xSGi4OTKZjxtJBpMnuy9MuPtzOApUYpS07B5	1574
41	Out	2016-05-12 17:05:34.775017+08	2016-05-12 17:05:34.775017+08	VdP5NNygYo3Nj2W5vvyvJAlohcHiiSnE6CJTZHA86DVpF2uBwt	1575
51	Out	2016-05-12 17:55:42.376567+08	2016-05-12 17:55:42.376567+08	7H4s6lVMUEoHSuUkO43YC9lhx1jsCgmJxqC3chQ7uFPNAs8YwB	1576
23	Out	2016-05-12 17:59:15.26074+08	2016-05-12 17:59:15.26074+08	79KsrIsaB5HxOFoZIRHiYCxxa8qifntmxEfoWYQhdhf1wUbGws	1577
62	Out	2016-05-12 18:00:10.114668+08	2016-05-12 18:00:10.114668+08	yV5wTe4KNk9IW7VCv2kMjN4PP2t0IqsHMxDpcIA12JIZQolMqV	1578
61	Out	2016-05-12 18:00:31.106157+08	2016-05-12 18:00:31.106157+08	iatmyIosI6jBN69avls6luP4UosGBjltKfgJxUCGavRx2aYxMR	1579
60	Out	2016-05-12 18:02:49.07151+08	2016-05-12 18:02:49.07151+08	38MSCqH57SorM9X2SVWel8bE6doebA6eIS7UJOaQrPIEYpG1Lm	1580
28	Out	2016-05-12 18:10:10.044767+08	2016-05-12 18:10:10.044767+08	f8uHL1uAfWKlBcEI7YghyY7Hlf72gTpMakdwlY6R5QDF3SXB0E	1581
47	Out	2016-05-12 18:10:34.173475+08	2016-05-12 18:10:34.173475+08	sym0GYgNaNqQjSBNOwwVO2vbHy3oA4342p4IOkfy7XPryaFOWC	1582
53	Out	2016-05-12 18:12:07.56368+08	2016-05-12 18:12:07.56368+08	suDoWUoZJycM3fC7xaqdZyBypAY5X6HR0UGWy56I4ie7OqEMR5	1583
56	Out	2016-05-12 18:14:29.051152+08	2016-05-12 18:14:29.051152+08	z04BytLXysdGKdkaAjfG3jyhqNY4j09i0Cty6FX58BLRo72yqh	1584
13	Out	2016-05-12 18:34:40.780036+08	2016-05-12 18:34:40.780036+08	GtRFbHcALMBU5BhyAnEhsLsFmhLogCWw6xChFosaA35FEmEOaS	1585
59	Out	2016-05-12 18:37:57.327864+08	2016-05-12 18:37:57.327864+08	6Tnyiag4QNGwKMtW49KvjUyokDbycCRifFhOpORFlhC647c8Gw	1586
55	Out	2016-05-12 19:04:06.772244+08	2016-05-12 19:04:06.772244+08	40R4oCHRBtdbcIqKggi8vUq9auFD3VA7VbBLnSlyMPayhRIO81	1587
58	Out	2016-05-12 19:18:41.091309+08	2016-05-12 19:18:41.091309+08	X5VND6ITILySSU4dpr6bpS1QQirj71je5F2JLKldfk68FAl51q	1588
54	Out	2016-05-12 19:35:35.132653+08	2016-05-12 19:35:35.132653+08	gqJhIjQATYBEDGTFZnZLRG6XNLh9Ri08ZKpr4G2XnDl1TEG33q	1589
23	In	2016-05-13 07:52:16.02102+08	2016-05-13 07:52:16.02102+08	OU6U2UqidHRdP2xFt2UvZJ9KKdZagbR56XZ82QrehJI7LGMEIq	1590
61	In	2016-05-13 07:53:17.56896+08	2016-05-13 07:53:17.56896+08	BqAKCUxl6eNXjU5Jc7jUlSn5Z8KvNcmXUwrfRpRXUo5EJ9XvGH	1591
58	In	2016-05-13 07:57:53.085573+08	2016-05-13 07:57:53.085573+08	Q2jD7JMREj41HYx9EQygxTV2hoCFkSWAUGObZj3oT7pkfntuEt	1592
54	In	2016-05-13 08:00:56.991369+08	2016-05-13 08:00:56.991369+08	aCN6E5uPJfrqpM7Exgx1UR9KCo86jMzKYNQmRLCl14bqRi5PP3	1593
51	In	2016-05-13 08:13:30.995764+08	2016-05-13 08:13:30.995764+08	QtUZEgONm7jmRIAr5bDHMELy5mg9C6Cc0gCFNabBhMx9e81ijE	1594
13	In	2016-05-13 08:25:06.153873+08	2016-05-13 08:25:06.153873+08	06SL5X8lgKrtwsa97xjj9Q57ajFbSxqS5Jn9qvuXGnRDg1Mny6	1595
55	In	2016-05-13 08:26:20.106795+08	2016-05-13 08:26:20.106795+08	W8WcF7LUinSZGXr5gi1bGHPhV6jrtixQqU36bOaLD3tTamYHVZ	1596
31	In	2016-05-13 08:32:24.235792+08	2016-05-13 08:32:24.235792+08	smqIUMODEIvCinhktJ9UeMXYp8LOPqwIcnb7AzKOHGaz4Ikxat	1597
12	In	2016-05-13 08:34:05.314164+08	2016-05-13 08:34:05.314164+08	SFG1n698UZyRrbFSiPS3njKOjOfUMHOpWepKkzSFYRfQ3utlKM	1598
57	In	2016-05-13 09:12:46.695266+08	2016-05-13 09:12:46.695266+08	p869VoXBJtShjyMZI7ZkM8C2YGwS2HnqPt1ujY73SZkCY7lqEL	1599
41	In	2016-05-13 09:16:22.53556+08	2016-05-13 09:16:22.53556+08	baToc25ZU6rIxHDyCvXJyzsiCQpwH4ItdliGompJthbrxopAkN	1600
60	In	2016-05-13 09:32:02.241044+08	2016-05-13 09:32:02.241044+08	TiNMSYmIW4MoxzagGPT6iNnKFl85vsSPcpk4PXMucikaiLHxkk	1601
53	In	2016-05-13 09:56:39.403119+08	2016-05-13 09:56:39.403119+08	4T8rmNdvSZouyRljVAIr6tapUJBlHvVLPdDC1q8TQwPPOA9tLR	1602
62	In	2016-05-13 09:57:24.275562+08	2016-05-13 09:57:24.275562+08	lQLMHpfSbwO7InkVzmM8Gm5eCTpLMAm8a8UrxAKZ7igOVRuVEH	1603
29	In	2016-05-13 09:58:18.237267+08	2016-05-13 09:58:18.237267+08	dT4i9GBxcY8PgjXCbVMu5Sdlr9DleQ3Iu703OB20jAQQtxcUTx	1604
30	In	2016-05-13 09:58:27.893224+08	2016-05-13 09:58:27.893224+08	QYR4KIDX4rx8AsFAwdLxd584V218WV6w4X1OpEvt6t2FnHPjtk	1605
11	In	2016-05-13 10:33:32.422147+08	2016-05-13 10:33:32.422147+08	hXpqbLrdSP8YMC6MavaWpgRrvE9Ly36gauXDGPpioxIAAOXlJ8	1606
47	In	2016-05-13 10:38:59.771639+08	2016-05-13 10:38:59.771639+08	I9oj1kxA6wDCdn7A1Naq6OoOZzm7k6F4G4mHokRuhe6LSDVTa6	1607
17	In	2016-05-13 11:30:40.00403+08	2016-05-13 11:30:40.00403+08	LhUA64AsBuyQyFUlWJWyEEcKZ6X6Z9Cupg5vkEov9oM84qtbAR	1608
13	Out	2016-05-13 14:05:21.043697+08	2016-05-13 14:05:21.043697+08	ZOfDiFJHLsPXnFErCy71uGpIOt9IVJj5hPHQeah0T7XGNl9YkF	1609
27	In	2016-05-13 14:47:20.203197+08	2016-05-13 14:47:20.203197+08	ZfWPwuJ6DnPws8MAY1kG2ENZUkLdJ5sskPIhKboXPEUILqTusE	1610
12	Out	2016-05-13 16:15:00.598844+08	2016-05-13 16:15:00.598844+08	BtSYTwJoactUVetnMDPBkoPG8k7afyoptHONEhCoK6JqkCe7Q4	1611
23	Out	2016-05-13 17:08:25.917786+08	2016-05-13 17:08:25.917786+08	IBthQ1SXc7XRxRiMow40lP65FqHtxhxGsrwJsPqVWOwUpeqdbv	1612
61	Out	2016-05-13 17:12:09.279638+08	2016-05-13 17:12:09.279638+08	eNKkSabjUYRSoJKmdEBUjisfDhK4LwyzKJkmtLWOuxrjHCWuQh	1613
51	Out	2016-05-13 17:54:11.297508+08	2016-05-13 17:54:11.297508+08	O9QHoczAgL6fLQy6DsRiIMg96xLbslJHujYkMYt3t1iFRhKdal	1614
47	Out	2016-05-13 17:58:08.121168+08	2016-05-13 17:58:08.121168+08	Ms832E1OptA9B5sjpFIjHCkzRBhloIXCBfFEtGbjAlsLqk6gzO	1615
60	Out	2016-05-13 18:00:22.202695+08	2016-05-13 18:00:22.202695+08	QHaBH2MynBHLNT2chvsJf35XPvIVcIt3aUDrWZqJk8f8bhkJdd	1616
17	Out	2016-05-13 18:07:40.546498+08	2016-05-13 18:07:40.546498+08	cIghq6d9bGRUI2yWtV6joqsUyUCjmpMP836y9j8kzZFIbFoUju	1617
11	Out	2016-05-13 18:48:33.624938+08	2016-05-13 18:48:33.624938+08	FZl84kbGUP6qoEtuC3fKnet4wVIl03gFbSNfDyvhO2YDGS8SWn	1618
27	Out	2016-05-13 19:00:03.311509+08	2016-05-13 19:00:03.311509+08	mKSgOPBgCBjsQLLn1YmxHBzpOFIXhoLU9nBXDMEPXxIyJdmKCZ	1619
62	Out	2016-05-13 19:00:36.621714+08	2016-05-13 19:00:36.621714+08	ITlHIAXbhFQ3kZqu74ILTpJlocPbwbBE5wVN73ypIPs3yjx6nG	1620
30	Out	2016-05-13 19:01:07.982732+08	2016-05-13 19:01:07.982732+08	SH6l3uNSWK4hY8e4Vm8UcQtUTsERy2hRJoCMjanGtrxT0dXWPf	1621
31	Out	2016-05-13 19:01:22.299615+08	2016-05-13 19:01:22.299615+08	126uWYnk1mmiE5XQRG1FWu7UO78vdXaeZgY7FMrG9dyNiWnAmn	1622
29	Out	2016-05-13 19:02:09.28499+08	2016-05-13 19:02:09.28499+08	PJiVn7dv3GTdu3JTAZp1pyeoMNK9X7xwRgSFn6BpMeTHhnkrMb	1623
41	Out	2016-05-13 19:02:10.587034+08	2016-05-13 19:02:10.587034+08	sCaY0wvL7TS4Qtks9YyJPLxscffOX3zQEayFXuaeP3ipwUi63h	1624
53	Out	2016-05-13 19:02:41.339898+08	2016-05-13 19:02:41.339898+08	PR3NKf403b332Hd1WBv7pLAZB73sD6acXd1rI4rMfuPhC3jiEf	1625
55	Out	2016-05-13 19:08:51.118272+08	2016-05-13 19:08:51.118272+08	p51zdC7g5KmfwKIxCb24xiyNQBQ9tepjiqjN2q47Bqm9B57Ng9	1626
57	Out	2016-05-13 19:19:32.945381+08	2016-05-13 19:19:32.945381+08	RdqQ1HbRRV6GFo7zC9qFG263BH8IdoR5SIVTa7u1c0IroPr1Yi	1627
58	Out	2016-05-13 19:43:47.564356+08	2016-05-13 19:43:47.564356+08	GokMrvdyEHnfMGxrjYyeZberTTGLUo4kdo7UlkUz2IfOYdGIBF	1628
54	Out	2016-05-13 19:46:21.226807+08	2016-05-13 19:46:21.226807+08	vkqacK4seYhiJKXQpJAJICbxb9arRm7NXxx9I22wajft4DJtVU	1629
17	In	2016-05-16 07:11:02.327258+08	2016-05-16 07:11:02.327258+08	DognlIwNAO9HmgFkpXmrTOb9HfMbZr5lglaS4XpEwyUifjTVHG	1630
23	In	2016-05-16 07:36:54.981637+08	2016-05-16 07:36:54.981637+08	NkeytveGXE9c0pPaIT88g57BnmvHIDXfxCer8J8fWHJW7h7PBF	1631
12	In	2016-05-16 07:37:16.571307+08	2016-05-16 07:37:16.571307+08	XrKe37RyOjCvP9841GNAwtRFQYwXw8nUz793Fa2dKEZjNhnOyB	1632
51	In	2016-05-16 08:03:02.238669+08	2016-05-16 08:03:02.238669+08	Yu5zAWX74VFrzFy9IEjLq4YQnv9cK7ns2srCPQKTuZLuoK48Yn	1633
61	In	2016-05-16 08:15:58.447184+08	2016-05-16 08:15:58.447184+08	SPr1pfwyIH66A8y3LOSesOEEJ4YNB6BdV3fMicL1uR75Z77uVa	1634
47	In	2016-05-16 08:19:38.714221+08	2016-05-16 08:19:38.714221+08	ZOxobHrAe3GphlsM8byTctujyUq6PMgyjfmMwfWbimRQYKmgvl	1635
13	In	2016-05-16 08:24:03.516632+08	2016-05-16 08:24:03.516632+08	AZf4JeYAkwVRvG7jb4O8f7u7XTSKAO6JxlNHRvQCtwdpCkZoox	1636
30	In	2016-05-16 08:55:54.928081+08	2016-05-16 08:55:54.928081+08	wU5qbcK4wUS3nQoBhG89S156qIqQ6fO39Utl7Ep3iI6WjviRBp	1637
54	In	2016-05-16 08:56:31.828635+08	2016-05-16 08:56:31.828635+08	Zdqfjiwa93FX6P21A9FzCxIJU2EDTQ334tincfNljdKp2MqDV5	1638
41	In	2016-05-16 08:58:22.214007+08	2016-05-16 08:58:22.214007+08	Dh3V0XXFk0en3ihlWKRt6BXQ1ZmqmHwyy0UzY2EJ2t75cor99J	1639
31	In	2016-05-16 09:30:17.922532+08	2016-05-16 09:30:17.922532+08	3GUagVASMwkJwjJRjrSxBUrHaU6SdFlgVGICkSe8PPRM9knrbG	1640
55	In	2016-05-16 09:30:45.997378+08	2016-05-16 09:30:45.997378+08	pmkh4LCAnpPYXuoo7ZHlhhB94JsqCV72IskMEwW2nwaKrPAyyR	1641
29	In	2016-05-16 09:32:34.860379+08	2016-05-16 09:32:34.860379+08	kg9upCFi4QEBTV3DrHAPJxLtIDJSCItvy3roF6XJWkTzHXD9oN	1642
62	In	2016-05-16 09:49:53.048411+08	2016-05-16 09:49:53.048411+08	Y8Lt2d7L6Jd0Fc37QIDxbji5jzcx9SLhagbcKixR1bRHEUOemb	1643
28	In	2016-05-16 09:50:17.498839+08	2016-05-16 09:50:17.498839+08	cOLLT5L73UYOC95nlPVjqXMInamCFZnrx9EREZYH47eGGj42AZ	1644
53	In	2016-05-16 09:51:17.67946+08	2016-05-16 09:51:17.67946+08	m178Jui57xeupc445HddYhjDy1x337cp8jxRegWleCgUokYt2C	1645
58	In	2016-05-16 09:55:11.246061+08	2016-05-16 09:55:11.246061+08	WauHosHmvKtYA2I8TwoziTBPx0AWtCiQndhbWyOSJI1TKJamFP	1646
59	In	2016-05-16 09:55:17.010052+08	2016-05-16 09:55:17.010052+08	mxsxNpxXMrk5IXizAEyYgIqhkA1MxGlkEdicTgApYuuqTdqcrp	1647
60	In	2016-05-16 10:19:01.562541+08	2016-05-16 10:19:01.562541+08	BZ81HsCIFAZ0tnecQ8JaxsWtjyXabPQmyYoGS1ZgA9h5wLhNT1	1648
27	In	2016-05-16 11:00:20.259607+08	2016-05-16 11:00:20.259607+08	xStULdTsE5IesHEhXfh7NrG5wDQeZtfYMY3hCWaQbs5UAJBiys	1649
23	Out	2016-05-16 17:19:35.428555+08	2016-05-16 17:19:35.428555+08	pMl6QiIqNsl2R7bTpnzQEaJJ5TcGCb92xu8OdQF1J13k8eExSD	1650
12	Out	2016-05-16 17:37:25.369589+08	2016-05-16 17:37:25.369589+08	OgohztBbANDKPBFXZsyptIqw3ybGw4ULkJ3kDEMNbag1lvYLoX	1651
51	Out	2016-05-16 18:05:45.186365+08	2016-05-16 18:05:45.186365+08	Bip1fr1I9xMcJ8vLs9ZFWBpDCb9kwyI7h89O09g973lQBhl3qK	1652
41	Out	2016-05-16 18:07:55.661396+08	2016-05-16 18:07:55.661396+08	INV8ahijSfikmQsvos6U2DXnciVOlMi4iECJvu3Oal9OC2K1uQ	1653
60	Out	2016-05-16 18:15:42.742653+08	2016-05-16 18:15:42.742653+08	Vwc4kGlFeXbNbLbneYjhwKT6ig83h4TD06HkM300bcNDwz1bXk	1654
30	Out	2016-05-16 18:41:02.4328+08	2016-05-16 18:41:02.4328+08	JU5nanTjqBmKOnQfYmiYmKBAX8AZkhK4COrmCLW3WJNu7nafZK	1655
61	Out	2016-05-16 18:42:56.42078+08	2016-05-16 18:42:56.42078+08	ENePXCXhlIP5MbUFOgauj7F73Mud1UxFrcePoD7aVWfr8A7Xqh	1656
27	Out	2016-05-16 18:45:22.695499+08	2016-05-16 18:45:22.695499+08	Saohhr3cV57TKx6yNuCUVh1CZ9MggDO9nDpV5t8ZxF3ID9Ia4U	1657
17	Out	2016-05-16 18:45:24.978982+08	2016-05-16 18:45:24.978982+08	5ZC6kmF7TvKr485ueAomjm1n5EvNo0rtZ4zKqFRKAlCFuIAYSx	1658
28	Out	2016-05-16 18:46:40.412456+08	2016-05-16 18:46:40.412456+08	LCkNzqbvEQv6KVAKq1ZIMj4Yyyq9YI7tVrHUirQwIN3csDxjFW	1659
13	Out	2016-05-16 18:49:09.37842+08	2016-05-16 18:49:09.37842+08	2aH69G5zOdIWXnOoI7gj3y66cyJZiY7k9NqIdvI2aaY8Owvg4d	1660
62	Out	2016-05-16 19:00:11.06702+08	2016-05-16 19:00:11.06702+08	P7cVDFVWoE5vxEJoWwlnyLOXTmUPSY3sffOsutPj8Ue6ixuEug	1661
53	Out	2016-05-16 19:02:00.002609+08	2016-05-16 19:02:00.002609+08	3u2RSVEwvgVyYAdw3YqSHyxw5gu0uqgxljODFcBAJf9rqmptLg	1662
29	Out	2016-05-16 19:03:30.606766+08	2016-05-16 19:03:30.606766+08	MdfKak0VkuMRs7BHLQtVaDBj62XuvsbIWHc62cbmYxER5PiQoc	1663
55	Out	2016-05-16 19:03:55.513396+08	2016-05-16 19:03:55.513396+08	vPq89v9gq5ZTN6kzClcoYBmmbrBKI0wEPnMZjVGaap4xuox8aa	1664
31	Out	2016-05-16 19:04:23.904485+08	2016-05-16 19:04:23.904485+08	v9livNa7hs7e8WSU6CzMnaBrZ7fXEH8APtsLGTSxMYcU65yCIx	1665
47	Out	2016-05-16 19:08:55.826892+08	2016-05-16 19:08:55.826892+08	X5Zjw8pdf4tnFKh8fyb7wygZTlfRxwQV3yFz85cn9WcOqKWVJ8	1666
58	Out	2016-05-16 19:16:21.979071+08	2016-05-16 19:16:21.979071+08	dF7JpZ6U23SRZUQoUYt7M3dyRUJx1b6drDwhm3Cn6eGf9gUdFN	1667
54	Out	2016-05-16 19:20:29.572658+08	2016-05-16 19:20:29.572658+08	lbQParttpuWvYO8V5uYIjewyK6fojuCVXcu8Uo2KjYGIwPn2KM	1668
59	Out	2016-05-16 19:21:18.544196+08	2016-05-16 19:21:18.544196+08	K41G3MMiB7eNcB0XKVMMp6u6OrVCtpYDtZUwvqf6xKTaVU8pzU	1669
12	In	2016-05-17 07:36:21.387992+08	2016-05-17 07:36:21.387992+08	Bpa6vyxRBrHj5BJZ7FQmMO7pycK6RJad9Bj5BhXMYo6eyQD7fd	1670
17	In	2016-05-17 07:36:32.66695+08	2016-05-17 07:36:32.66695+08	t121q1cB75UhhdsRj49GQi5WM5vZBbE5cG6UHieOnA6VnyxW27	1671
23	In	2016-05-17 07:38:45.294869+08	2016-05-17 07:38:45.294869+08	nSosyCwul9WzE9GJdX3JuqS1MGyKm2QaUGTSRQODZuDm4T7h19	1672
41	In	2016-05-17 07:48:34.661258+08	2016-05-17 07:48:34.661258+08	1vzTwMjvfWx77SNauo1J2aDFNIjUzjd1fdTc0DYfjWmqyARtyS	1673
59	In	2016-05-17 07:49:50.908853+08	2016-05-17 07:49:50.908853+08	C13QGQhzthjYiPCC2CParA7f16oSynuCoxb5NK5I1ppjF2vIEL	1674
58	In	2016-05-17 07:51:40.421282+08	2016-05-17 07:51:40.421282+08	s6V0lW6by5PtHEqsJEDPWEEMxUOtlcFejkeVHk6FqV98j013FE	1675
30	In	2016-05-17 07:58:50.518126+08	2016-05-17 07:58:50.518126+08	RlSg8RAWLwAabtLGPc2Vrs121k22nHGF3ivBA6iV3r6elRvB4x	1676
51	In	2016-05-17 08:10:02.09642+08	2016-05-17 08:10:02.09642+08	gwphxqR0sFH8UKrQW2XEWa7cFs4B498j5xR4os4h8Lpdgg4Dia	1677
61	In	2016-05-17 08:11:00.177585+08	2016-05-17 08:11:00.177585+08	RFBYrQRwaU5iEBhfEWZIDhe3KKjOXSyyiAXaaxXBScuhnbN28w	1678
13	In	2016-05-17 08:29:18.100072+08	2016-05-17 08:29:18.100072+08	LLdyOyJ8NqbMpJWNu7LRJo5DVspsuxpGJTFgSYppQRCGkjdfqy	1679
31	In	2016-05-17 08:29:25.38522+08	2016-05-17 08:29:25.38522+08	7AnCNJ5DC0B2GTVUAy40oTR1jCkNrbMylABATGNfGXhW1E1CC5	1680
55	In	2016-05-17 08:30:19.990062+08	2016-05-17 08:30:19.990062+08	C1Yd2JqmghO3hBDsKg9hMOF5uGIvSU1eVZIXs9KZqicYtpREWZ	1681
54	In	2016-05-17 08:33:12.371969+08	2016-05-17 08:33:12.371969+08	vtyBytRHptlqYHQroI09rrsUPmKq1rQwlP8jIZ18Tmy25Ottht	1682
28	In	2016-05-17 08:34:52.108714+08	2016-05-17 08:34:52.108714+08	3Zlv4BiO2iGSf2rnmAMnIpaHseflYNfcwRY1cGPezg7fiySU9p	1683
62	In	2016-05-17 08:56:34.258058+08	2016-05-17 08:56:34.258058+08	ISfsjYXPK7m1ijSHk5XAjXqqDZqf40VMSBFCjma5tN6c7XtrcR	1684
29	In	2016-05-17 09:39:19.67544+08	2016-05-17 09:39:19.67544+08	2MysECR4sV4OsWZ8iKuJOogURn2Kfflh2kaGx2KpXPEQvnYd7T	1685
56	In	2016-05-17 10:15:51.095111+08	2016-05-17 10:15:51.095111+08	wWHe1iS338iopkaQ1XSLN1kbRfPyKXSH3ju4SN7VWpKMaumbTF	1686
60	In	2016-05-17 10:22:50.984877+08	2016-05-17 10:22:50.984877+08	wqGhShOrghP9ySstWLIdqnTCA47wgaCdRSLtAjmqRCzQesLBEc	1687
47	In	2016-05-17 13:00:28.785036+08	2016-05-17 13:00:28.785036+08	p6RJHbOOY4ykhQE4KNn7EFJEgx729MeyR6Iigg8Fk71SXEWscK	1688
12	Out	2016-05-17 13:37:03.501491+08	2016-05-17 13:37:03.501491+08	yqZI5GGDHOYvN02fjiMry7yyZWE6PpQOgzgmGwzXLYTiYVPIEl	1689
17	Out	2016-05-17 14:30:08.887583+08	2016-05-17 14:30:08.887583+08	ADs9CSfQY5GyTwyAjE7jlSIFCqka9yMJCFSOg8oFD5Eg2DqlRx	1690
41	Out	2016-05-17 17:03:20.525332+08	2016-05-17 17:03:20.525332+08	VDRnSceDEnCa7OoZmWhaluf0bhDSUeQzrrnKURWiFiJL78usec	1691
30	Out	2016-05-17 17:04:54.375341+08	2016-05-17 17:04:54.375341+08	UQWAQ8sdaMI1MAsATOb17qjQCpY7jDjEdGO4OGhyd000AtAdIl	1692
23	Out	2016-05-17 17:09:16.982519+08	2016-05-17 17:09:16.982519+08	ePcOppEOwxcgBGwZLKp3JT3KTEDerVQWu3uks99p7lVI2SrNmh	1693
58	Out	2016-05-17 17:47:51.300696+08	2016-05-17 17:47:51.300696+08	Q7CTQfhdJZ9j64n1ngAxVGj2YlTQ9H9ZNK3n0kRKKb4QerRTXb	1694
59	Out	2016-05-17 17:56:52.950197+08	2016-05-17 17:56:52.950197+08	Q4sA6RvZr5q1dELg2MRUfl5jCjbeD9GeD9oJajsSoiUSwp9yCa	1695
60	Out	2016-05-17 18:00:44.649964+08	2016-05-17 18:00:44.649964+08	TrMYbZIDDVNTAacxtDilgXVAzS09RCju46TfflssIGNSqzQkD9	1696
31	Out	2016-05-17 18:00:51.541874+08	2016-05-17 18:00:51.541874+08	Wtg24gU5pvHZqLfK1L7tEOAaq1aHloQIi7Kmnorck9CbUrvVD3	1697
53	Out	2016-05-17 18:01:19.411212+08	2016-05-17 18:01:19.411212+08	PQRa2IbcZNR0g971vupoXaxjCRb8woBNFdwHvZtVwKWdUddQYT	1698
61	Out	2016-05-17 18:02:32.849987+08	2016-05-17 18:02:32.849987+08	F63CpFeRNbGZxVCvm8VfdS1A5UnjuMDASGMIV1jsb0SaVeWIm1	1699
51	Out	2016-05-17 18:02:34.58439+08	2016-05-17 18:02:34.58439+08	xQTyaYUOIPkUZDkvVGvGAYGb8lGe43f3T924iVT0uEVURGQwXM	1700
62	Out	2016-05-17 18:03:32.660091+08	2016-05-17 18:03:32.660091+08	DguTJ3FZhJcOM6XOAGtdGprlKJ2jGZ6TG1wZ4C8lVkArqhG1wA	1701
13	Out	2016-05-17 18:06:48.110578+08	2016-05-17 18:06:48.110578+08	eDzWyJp136aAZqAWQEhY0DJA5ArLBoVq2VN1oD3sJd2tUDPuR8	1702
56	Out	2016-05-17 18:07:44.681976+08	2016-05-17 18:07:44.681976+08	TRLmbQvTl8IHxKmLMbZOUs2WmWjCRBKucfgE6disk1AjLw5hZe	1703
28	Out	2016-05-17 18:13:42.813569+08	2016-05-17 18:13:42.813569+08	63X9aJfJV7Up27UiLbM4T75dpQbv8AZFE7NnQ37vAblCiGu5rG	1704
55	Out	2016-05-17 18:19:58.402907+08	2016-05-17 18:19:58.402907+08	9LNEzDea9mki2ypPmGSuDcWyoFFiK7yTSMgSaL3i8oSAnIYaY1	1705
54	Out	2016-05-17 18:35:45.449074+08	2016-05-17 18:35:45.449074+08	Vld2kSIzBc7A5aWm3786pGtIQhayI90nuepf68eHkmRpMycP5k	1706
29	Out	2016-05-17 19:16:42.533673+08	2016-05-17 19:16:42.533673+08	Uv1PEQ7nQPwQDr54XBCCSvytlLsOkx8Ft9e8alv0BtQPlVSJge	1707
30	In	2016-05-18 07:47:16.850311+08	2016-05-18 07:47:16.850311+08	W9aV4Mqwkauspo2UwcGscSm3qYYJrGxOPYsTujPfKLYAAaf7Dv	1708
28	In	2016-05-18 07:47:29.826746+08	2016-05-18 07:47:29.826746+08	1pOnsFMSYEhWc75Va1FzfZLEjVpPc3LcrjQlymDX1v5d3A8cBN	1709
23	In	2016-05-18 07:47:37.9132+08	2016-05-18 07:47:37.9132+08	cqwx6gSu65xRhpB9bAvoivkmZnxhQ853z215hT1nYyFGoQPQaK	1710
61	In	2016-05-18 07:47:55.036326+08	2016-05-18 07:47:55.036326+08	GJH06qn4YECdHCfHHNkIBJHQZ6qyWRKmkamrRav0o8d6KJNbh8	1711
12	In	2016-05-18 07:48:14.14877+08	2016-05-18 07:48:14.14877+08	tsRBJ1HA0nbKZNuNFMxAMmI1sbKGD2N7uoIEpYOqM0BvN6JcSH	1712
41	In	2016-05-18 07:48:28.00022+08	2016-05-18 07:48:28.00022+08	mo45pvgACtCZ17PJLFri6EjGA7MTiokVdnaUkHevBqWCxuVJAN	1713
53	In	2016-05-18 07:57:58.719441+08	2016-05-18 07:57:58.719441+08	3GblWlssFbhy8MnhpXyVUAM0NKvsd6GgMrSsdLmsxUr5qfngDm	1714
13	In	2016-05-18 08:18:44.024155+08	2016-05-18 08:18:44.024155+08	ChwYhKscDWiTD5Lfyy2kryGk46QrmdeyKbX2uPe8wObATwpSvr	1715
54	In	2016-05-18 08:26:09.614932+08	2016-05-18 08:26:09.614932+08	DnqTYvZynMbRLw3syxId6F2hPVeFxa7BOxewtEvgaX9wUCpTA8	1716
55	In	2016-05-18 08:26:56.720688+08	2016-05-18 08:26:56.720688+08	7HN9ymec3cDAnb8SY2gUjI3sEW540FC7VZGUMu7PXLZLwhoVkV	1717
57	In	2016-05-18 08:37:39.163451+08	2016-05-18 08:37:39.163451+08	1Um3M2aR6agIhCrxgEsndR9Dm6ubbf7bAteWvFx1pdJXpBVWPO	1718
31	In	2016-05-18 08:40:55.434873+08	2016-05-18 08:40:55.434873+08	L3oUGbZBDBqKm1ESX9gUBW9U4yfYW5wq8mLOOuZb6QvsRALxJ2	1719
59	In	2016-05-18 08:41:26.763155+08	2016-05-18 08:41:26.763155+08	TUYcxcbdB8i9yquKEJFnvLErFf1ZeKc7oBjmnLQzT99Sy4nEN3	1720
56	In	2016-05-18 08:43:44.553023+08	2016-05-18 08:43:44.553023+08	2JPHBdwCEaWqiL2S8pnYpIhykg3YuQbwj1EueB7sldjUylw7bl	1721
58	In	2016-05-18 08:46:30.610759+08	2016-05-18 08:46:30.610759+08	fR3NQn4TMztxwdyBYdMfW8JGdI2aPdM55PSVDXyZXsYUVXf4B2	1722
62	In	2016-05-18 08:49:32.756312+08	2016-05-18 08:49:32.756312+08	jiA2ynK1Ojdjpi9IFNpDwN6Vqb3WfEXPvhRuVmusWZdMImeXAU	1723
17	In	2016-05-18 09:12:58.58374+08	2016-05-18 09:12:58.58374+08	k7qqbhTeE9slYoT1jymerJEVfWIK4RnpYfgANAobJhNrWqsGpf	1724
29	In	2016-05-18 09:15:41.838055+08	2016-05-18 09:15:41.838055+08	uhy9DefVykwmaVSHfpRVRjDobifUyVAtD93QniumTra4N3K3sl	1725
60	In	2016-05-18 10:37:38.626678+08	2016-05-18 10:37:38.626678+08	YKWk88UncTImNVvPvj8qXbj8f6B0A4lhNISVQwJ3Qbpm8lD4VL	1726
27	In	2016-05-18 10:39:50.566439+08	2016-05-18 10:39:50.566439+08	u3weBckLcuPPcmh5I82bBSE0FLlSPHnKKkyVNjq0eHPH47MMFP	1727
47	In	2016-05-18 11:09:09.285808+08	2016-05-18 11:09:09.285808+08	xPrBQ7XCZwTNHn8GJU1BVfRuwV1JrGhofZ16gYIGUldmZl3sG4	1728
12	Out	2016-05-18 14:25:07.941154+08	2016-05-18 14:25:07.941154+08	4liVff1gyswghcGiixG1ElmrYLdbFteJeOoK3p22hyiPcy8LwO	1729
17	Out	2016-05-18 15:43:14.507785+08	2016-05-18 15:43:14.507785+08	MBA83hUgJjax2FMqaPfbRObAnDAuY7KuIU3LCX2VHbTJqpARFp	1730
27	Out	2016-05-18 15:51:36.00349+08	2016-05-18 15:51:36.00349+08	3gEer1r1wQ8GLQkOkwwmSDOvWGlgh2WkikPalHbihjy3AjRugO	1731
28	Out	2016-05-18 16:19:36.637574+08	2016-05-18 16:19:36.637574+08	h9b658Mro3sLnb6DCrUnaCXZEgJgb14JAgPFol7do0ycb5pnwK	1732
41	Out	2016-05-18 17:01:38.724699+08	2016-05-18 17:01:38.724699+08	bXV97kpRQRRVkbBAr0uyejydMaiCOgV0E29LlylDPEiAptKgtF	1733
30	Out	2016-05-18 17:02:12.914222+08	2016-05-18 17:02:12.914222+08	fYyeCLFvWdb3dp5mBqlw4BBlL0ffhauM9s1LEGHltsoYisLtj7	1734
53	Out	2016-05-18 17:02:26.786999+08	2016-05-18 17:02:26.786999+08	qmI2Yd2FJjoE6x77JLNZ7ISvpBoB5YIvLZxtDy9WixkovrvEEJ	1735
23	Out	2016-05-18 17:03:55.718584+08	2016-05-18 17:03:55.718584+08	nLbGGRS5cXcuSxUQsiQ2F9zzxurtA6DxQoFgGglsEOngNI7F1X	1736
61	Out	2016-05-18 17:06:25.783667+08	2016-05-18 17:06:25.783667+08	HGfHGdC8WMEjKeYZLoG7hTVVAsoH8poP5UgL8sTfFhPZLx9gmO	1737
47	Out	2016-05-18 17:51:25.27429+08	2016-05-18 17:51:25.27429+08	nVsK13DpKLfAkkeS6mLZSaGqAcpJJci78aR9deyy0e8lPmDVZY	1738
60	Out	2016-05-18 18:01:03.237464+08	2016-05-18 18:01:03.237464+08	529LsKxidHLLOTwpcaUcZUHhGfUTB52G6BbzVZh9q3UGWR692a	1739
57	Out	2016-05-18 18:01:22.286281+08	2016-05-18 18:01:22.286281+08	lb62JMiopttrA04lzZMhhDkDSHeYQgACIGFccwRSqKK1KNmKw9	1740
62	Out	2016-05-18 18:01:43.306036+08	2016-05-18 18:01:43.306036+08	2eLmro4VNVCXhUnv7QsYrjsCkDZYXWgZB3M3rQZFulmcGaZN1S	1741
56	Out	2016-05-18 18:03:17.051345+08	2016-05-18 18:03:17.051345+08	vsDo5x2eWZCD9NFUQ7uzMql9T2j2PkVLchAhfBNCkYOtveONlJ	1742
31	Out	2016-05-18 18:07:04.152655+08	2016-05-18 18:07:04.152655+08	N8A8GdA0fZkAuNs56YGSj119uxmJLYchgmqwQ1x6aiGV69aBgq	1743
13	Out	2016-05-18 18:28:19.144567+08	2016-05-18 18:28:19.144567+08	eRrfZndN7xvjgcWWZwXX28GIdLRDX84BZwq9jUWqTSa958fe5D	1744
59	Out	2016-05-18 18:34:32.398629+08	2016-05-18 18:34:32.398629+08	C7LRPxnqCLzGWZCOivsFmMhOVlWBQaOchj58isytDyAkXM8GI1	1745
58	Out	2016-05-18 18:53:36.270249+08	2016-05-18 18:53:36.270249+08	V6NCUsy04PaS2ID7QuzPoDOyxvL6Ce7gkUsEMrFQHptK97RY2R	1746
29	Out	2016-05-18 19:01:37.39774+08	2016-05-18 19:01:37.39774+08	xqeMqcIChTqpAbJ4pgv57Du1X37yc9Pa14wqgF3OitEsVXwLEs	1747
54	Out	2016-05-18 19:02:19.678637+08	2016-05-18 19:02:19.678637+08	PL6KMdNTczd2ad6WVmlYCUSQNxxKJCEiXK3txQNaP1czeiW9WI	1748
55	Out	2016-05-18 19:09:56.369259+08	2016-05-18 19:09:56.369259+08	himA8A86VRIiAp3Dj1d7b38E3lwZvTsdBfnKqwQLOj5YZ8kJ9O	1749
23	In	2016-05-19 07:55:54.456554+08	2016-05-19 07:55:54.456554+08	QkRYxULu4GOwtZcisTeKo33tac2MvBkNvCvugHplXEiSnLAgoo	1750
41	In	2016-05-19 07:56:06.61882+08	2016-05-19 07:56:06.61882+08	1dr4XTgZpckazgmvbTCRFkexCSJM97CAk4DIXtqMWbwWIjStDe	1751
55	In	2016-05-19 07:56:55.568689+08	2016-05-19 07:56:55.568689+08	LSP0QbSiybqAlbEysltk8QM5weoPY25tUUtu6Md5xUFj6TjyFc	1752
30	In	2016-05-19 07:56:58.984285+08	2016-05-19 07:56:58.984285+08	iN35S0jGQJIUCmy6h5SL9RpOBurtt7WdUaivaSC1lUVxIT4zYX	1753
12	In	2016-05-19 07:57:26.124315+08	2016-05-19 07:57:26.124315+08	LhxB696x305adZBMVlohlZDHXUkcUKAp2808H67L7Cvkl67Hru	1754
51	In	2016-05-19 07:57:27.481842+08	2016-05-19 07:57:27.481842+08	ydVBu3ggfB0o02w0AE7HZETVxFb5VT0U7Vg2YMiEXi3Xl0XvEe	1755
59	In	2016-05-19 08:29:44.69823+08	2016-05-19 08:29:44.69823+08	DnsgJqvuvRNwvUSbX1yGFWyI4kIbgWGtL9ae0VYwwwssRLUyMT	1756
58	In	2016-05-19 08:30:00.577286+08	2016-05-19 08:30:00.577286+08	EayDs3xAeeguX248g5dF1aCtTdFxcbQqCP55S3F7gw2Fy7NeB1	1757
13	In	2016-05-19 08:32:22.54031+08	2016-05-19 08:32:22.54031+08	tDa674jM2MxSEBrIFKLVR3RUHQae5lfzyG66KpSMCRnQbgir15	1758
53	In	2016-05-19 08:51:45.006296+08	2016-05-19 08:51:45.006296+08	MS7owPFX4KJiKIyQOJGrfSIUtuAclBh9dowZDC7HWQ0qiyH7JX	1759
62	In	2016-05-19 08:56:27.516523+08	2016-05-19 08:56:27.516523+08	yy1HStCcWxnE7R341GG8XmZXeIWvPpTOoUfHOrtupi9wAB1BRH	1760
31	In	2016-05-19 08:58:52.962964+08	2016-05-19 08:58:52.962964+08	Jy4sWiB3ear8ygbfx0XruNa4KjFKuhbEgf7COIF2s7AsnmXlm5	1761
29	In	2016-05-19 09:02:34.101559+08	2016-05-19 09:02:34.101559+08	dhSDlmx28sij7PPFbmXqpQxzJlmqXYwBGPP3CM4KFn4MDSboG8	1762
54	In	2016-05-19 09:15:30.998167+08	2016-05-19 09:15:30.998167+08	f6Zd6sQrjxQg9h6YjIuocAbgWoA8dPGIVpwahMSRKt8UaE2LWx	1763
28	In	2016-05-19 09:28:21.77847+08	2016-05-19 09:28:21.77847+08	9A8kqeZ0lDQ2VurSWZoy19s9dTNfotdx4liuQIuCVLE1G6TmfI	1764
47	In	2016-05-19 09:32:27.892933+08	2016-05-19 09:32:27.892933+08	lgRdp57Dkv7OtBAc6au1mQL1Rb7uOmDATenJjvWUreslp4OvdJ	1765
17	In	2016-05-19 10:38:31.232298+08	2016-05-19 10:38:31.232298+08	wQjIRCuY6JKJTnxH7hDdC4I5p89E3mX0DHIeSDDZWXszLqHRYT	1766
27	In	2016-05-19 11:45:45.58766+08	2016-05-19 11:45:45.58766+08	5jYNoOVxbYk9YxQrcs5oSbMLahCr9kLEUtcKI7Htf23E0T6cMA	1767
41	Out	2016-05-19 13:27:36.358494+08	2016-05-19 13:27:36.358494+08	RolnAMUMFd7asbUUumbDgIFjWFDbrZmJNY6XubtAF1k8bFcX3F	1768
12	Out	2016-05-19 15:11:28.922757+08	2016-05-19 15:11:28.922757+08	kjWzT3Fge6FRPdzVBu745M5pTh57E8LyrrxKuD1ZJG1it1F5vL	1769
47	Out	2016-05-19 15:39:49.230518+08	2016-05-19 15:39:49.230518+08	90hEpCvuIA3d9uV7FQKG0eX1NR2cVwxewfsnroiAyln8gJFvja	1770
62	Out	2016-05-19 16:01:48.842944+08	2016-05-19 16:01:48.842944+08	DjFjlcBmEgjCMhrFVj4Et30gBg1Qdk1pUGaGrl37SmJoUB4yu9	1771
17	Out	2016-05-19 16:18:15.234831+08	2016-05-19 16:18:15.234831+08	DoCDWNuWnXHoNl5x2xj54CrN1MZ6LUEZJQmpnhMbFdRcPWaRUK	1772
30	Out	2016-05-19 17:02:03.178728+08	2016-05-19 17:02:03.178728+08	WYWOvYkVe6zsfJJS97AViO9A1YgczBwWiTue2eAglAYRTrtcy4	1773
23	Out	2016-05-19 17:11:17.289593+08	2016-05-19 17:11:17.289593+08	7iSGsToZ6oj2KTVF8XtIEfSm7uf1Xe5eMWuF1jo6YY9s2e8AC2	1774
51	Out	2016-05-19 17:59:04.341165+08	2016-05-19 17:59:04.341165+08	SQhuDopspNWu2tRx9ShxYFWh8YMGiYIBy05Cou5fJbaLV2IeU0	1775
28	Out	2016-05-19 18:00:28.574579+08	2016-05-19 18:00:28.574579+08	c3G9kOg7ePfwaewfqmbvRtX2F34YhYYKaoSLDASrZ7oAllpcYR	1776
31	Out	2016-05-19 18:01:01.886373+08	2016-05-19 18:01:01.886373+08	Y0L62a969qehBFVdaim3ZMBOWwAMZim7j8DliMrrCWZNl51Mmn	1777
53	Out	2016-05-19 18:01:38.914113+08	2016-05-19 18:01:38.914113+08	PNAalgXw26fpEPxRBgm3YyZ8MKCNgzB7NMh93E55LkuZAs0LZn	1778
55	Out	2016-05-19 18:07:44.031455+08	2016-05-19 18:07:44.031455+08	O8mxF9ISWySi6o4nx723CNo6vyywKYjifWfvgxNDwpv3e0qd7s	1779
58	Out	2016-05-19 18:47:30.868924+08	2016-05-19 18:47:30.868924+08	gJGVPCUO9nvsWcPCX6BvJ8lFBQF24LukeBG4NjSWXOP51oHYuS	1780
13	Out	2016-05-19 18:47:56.386894+08	2016-05-19 18:47:56.386894+08	UEZGTlhhnk4iVitlmHVFm3dC8e1PDvqhARycDfK1ROjw7dittE	1781
59	Out	2016-05-19 18:48:19.924597+08	2016-05-19 18:48:19.924597+08	8hHltPQuodqfM07KdJ1xKRM4OTh7NbKVJbID1i8pMyViyc3cv4	1782
29	Out	2016-05-19 19:01:26.901309+08	2016-05-19 19:01:26.901309+08	aGVwKtR21odLKwxcAyKHogGJPFvSrrWR82PSvpUwe8Iy5GbFFv	1783
54	Out	2016-05-19 19:01:40.253137+08	2016-05-19 19:01:40.253137+08	W3dmN32JVtB2LJ4kl0aGwFPFEUWpiklFoP2CS4Uxxf1Jy54k5d	1784
23	In	2016-05-20 07:51:07.152778+08	2016-05-20 07:51:07.152778+08	22sQH7unwdYisN8uZaz4YxjZHidKTiyUkru2ypouTOdMllHKMH	1785
30	In	2016-05-20 07:51:16.683606+08	2016-05-20 07:51:16.683606+08	OvE8UVq9pJroncgjefYTa2rEOc1ewNvMJAUnfKwVdoKSR1B5fk	1786
12	In	2016-05-20 07:52:04.112987+08	2016-05-20 07:52:04.112987+08	YHmQVA3Wp1tlMDvq1bBx7omRHDSSJ8DrPzIuALRzMKkiXgZYIk	1787
53	In	2016-05-20 07:52:11.373572+08	2016-05-20 07:52:11.373572+08	VPZIqqVJKoRXgqWylgKDggXRP58ydQj9pJRgAxzUmR2TIYS4Fn	1788
51	In	2016-05-20 08:16:30.930024+08	2016-05-20 08:16:30.930024+08	HvUpNtuVsXvbhku9R66RasscMBBoFQcXM6MjzHFsoAUWvPeNVl	1789
56	In	2016-05-20 08:20:04.384532+08	2016-05-20 08:20:04.384532+08	o6egi1rsp7JSefY1PYIdR7ovdkLJ8q4vwidfjVZZcs2HYaIx9a	1790
55	In	2016-05-20 08:21:07.050349+08	2016-05-20 08:21:07.050349+08	bahQWLBrdJiiFfRrLANujznlHMMYKV9v6qNcCYTpqCX6ryyDAM	1791
29	In	2016-05-20 08:29:14.727724+08	2016-05-20 08:29:14.727724+08	8tMvfcI2CbXKYdBuGNTjCKvkQnjP1tl9n74TkMVvx3HWhSRxou	1792
13	In	2016-05-20 08:29:43.585499+08	2016-05-20 08:29:43.585499+08	h2FcmgQW6RPraDyegj1CfzFwWwOxuDsbF9F2ofXu7xmgBlMrVN	1793
54	In	2016-05-20 08:40:50.850008+08	2016-05-20 08:40:50.850008+08	4BNJ7sGVqAjkmys10igYdmWQUgCpYhDcravyTBVKME58Dx9Dgp	1794
41	In	2016-05-20 08:45:40.220112+08	2016-05-20 08:45:40.220112+08	lKdIk8ywxXdBAVl6VFH0adFflSdufLlRfOjQWiNUG1fQWRW2hn	1795
31	In	2016-05-20 08:55:29.197524+08	2016-05-20 08:55:29.197524+08	2IQHxCjb8OwtqcIZ2oIPJZQyzwQWy8K2QkJOw205RwyHYHrb6A	1796
57	In	2016-05-20 09:00:13.377066+08	2016-05-20 09:00:13.377066+08	1OjQNiOnFNwZPNKilHklMCiLTHcLshVt7FKUxhID5FmUb6DNNx	1797
17	In	2016-05-20 09:05:07.029267+08	2016-05-20 09:05:07.029267+08	9jAq5d9hy2QUuWjF1hwJu3YhXAnjXBhfuqX1UgiUh9ycfirgQp	1798
62	In	2016-05-20 09:46:55.031432+08	2016-05-20 09:46:55.031432+08	zLrX3Php9F1quvhSwD9fgqofTUOMBoBAA4iDTQ3cf4Sa0B3xNC	1799
58	In	2016-05-20 09:56:50.879027+08	2016-05-20 09:56:50.879027+08	d53SkWw9s7x4I880LbQOD6SgfTqjQFu4JxV4VSDOZBSrKarfCI	1800
59	In	2016-05-20 09:58:37.046925+08	2016-05-20 09:58:37.046925+08	4POW65yxnPCiTWhzaCSna2y3tIdlxp52FTXLXXILwV5Q1mQbyr	1801
60	In	2016-05-20 10:22:21.703988+08	2016-05-20 10:22:21.703988+08	OZtNbnfFad4ffJ8Degkw2hS78TtX4rQSRKp39WIiANOpgW3LDn	1802
27	Out	2016-05-20 10:44:04.19614+08	2016-05-20 10:44:04.19614+08	IFVjNcDGBH9bkavad47vmHJB6yi9KvwcBSMY5ZoGqxqbXmCBqJ	1803
27	In	2016-05-20 10:44:12.29684+08	2016-05-20 10:44:12.29684+08	7eZQpgPYpjTmMfFiDKI2a9zSlXFxi6GqkqHaWg8MRb9mHPVUjo	1804
28	In	2016-05-20 10:56:57.190651+08	2016-05-20 10:56:57.190651+08	WKxWmj42gn8xdsnuSKcag3DqqUFMyyBVK927r78ZtGWY9KTbe5	1805
47	In	2016-05-20 13:30:28.429141+08	2016-05-20 13:30:28.429141+08	CM8PCytRLsRWOkeRrXY06SGc0PwT1cZExhdAgXc2Q3XonDGfjo	1806
12	Out	2016-05-20 14:38:22.391466+08	2016-05-20 14:38:22.391466+08	fpGwSHMQkN2Ja01EBhlmjCpI1eUIKE605NwXeJxPgziH0jVBSH	1807
27	Out	2016-05-20 16:02:47.222211+08	2016-05-20 16:02:47.222211+08	xCTnTUSxmmDsnIGkpt4mJjm21nlWxEnvQHktmDrY05RnNhYCcc	1808
30	Out	2016-05-20 17:03:51.433737+08	2016-05-20 17:03:51.433737+08	zvMmxNajtYxiUN0FHmSALSFmGcVoo7Ro3nb0BCj5khnF5nUMav	1809
41	Out	2016-05-20 17:05:12.055403+08	2016-05-20 17:05:12.055403+08	WvOlieNDUCLv1OjcOuo8zZpnoubIICFo7dapIx4mAOhCmRoBLd	1810
53	Out	2016-05-20 17:06:13.593784+08	2016-05-20 17:06:13.593784+08	JLD9924kKMwZB4CktUixHtMy69QuKlYd8mmHoq29DyiO3uAwPs	1811
17	Out	2016-05-20 17:10:42.305527+08	2016-05-20 17:10:42.305527+08	ugmHgrQ7mksMO18BHw3J5GIneKioH8hCpUTVMuc9fVV4VdGnaI	1812
23	Out	2016-05-20 17:51:49.496933+08	2016-05-20 17:51:49.496933+08	7fZPTEjC32KkEAFhfbcIkInGMJuc7UuEBUdeiNqlPCWdMkL2Mw	1813
31	Out	2016-05-20 18:00:50.030496+08	2016-05-20 18:00:50.030496+08	K7F8NbRIEZmAnxeRcMoU8Efeq2PC4l9PsPXG1yYFYMPLK3mwQb	1814
29	Out	2016-05-20 18:01:10.512519+08	2016-05-20 18:01:10.512519+08	RYp7Cg9bsEN2cFRAWS95hhR73lApiaRA9GHLwQwpeKrHZJR6la	1815
56	Out	2016-05-20 18:26:29.061694+08	2016-05-20 18:26:29.061694+08	BTIcaLOkB6LcGUsXppwmfb7YsgrKmdux8DZiYxTj4oLKJEr95o	1816
63	Out	2016-05-20 18:26:55.140303+08	2016-05-20 18:26:55.140303+08	vkQ2JJiBdUpYSwl2fJ0934xOPGcGPh6LSWNlp6wTam22jn5P75	1817
55	Out	2016-05-20 18:27:05.204447+08	2016-05-20 18:27:05.204447+08	YA9VYYlBoCsuWMQt8Gz5jZrlcbZg1glYqu4PTqaH2TCZpcTxtS	1818
57	Out	2016-05-20 18:27:08.546606+08	2016-05-20 18:27:08.546606+08	2d3tQfVzMWg85X39vW0Wn310bqd5nXYqBakbGFaclHlqoozkL0	1819
28	Out	2016-05-20 18:27:44.24007+08	2016-05-20 18:27:44.24007+08	I93IAe9mjwKHnVsY69nhlZyXPnMPYhPpqS907InqF883c1bjAP	1820
51	Out	2016-05-20 18:27:56.861276+08	2016-05-20 18:27:56.861276+08	QvyPTODonkWDbNfjNm2BcHJkKvlvfvL6qKVKih9WSgj43PnRCp	1821
62	Out	2016-05-20 19:01:11.353932+08	2016-05-20 19:01:11.353932+08	cp7vaSrMOWIjc948TmpdJIK3NNSBof1RU8N6aFSzlkjOtnWOaM	1822
58	Out	2016-05-20 19:03:54.134394+08	2016-05-20 19:03:54.134394+08	2tfLw2iPDX4EyZMMexb7xNrhllVIA6eC0KXwMGLZnQnmyA9e8k	1823
59	Out	2016-05-20 19:04:33.971226+08	2016-05-20 19:04:33.971226+08	l57dmsPIBZOqkPAILWYh6M7s973IlB3XGAA33ZLF9k6u9GDUml	1824
13	Out	2016-05-20 19:10:42.97396+08	2016-05-20 19:10:42.97396+08	Cs8JlHQoZCzcjGmtJqUe6dOBYXRk3EWF7eYrvzgWCg9uvvpFlJ	1825
47	Out	2016-05-20 19:16:56.409066+08	2016-05-20 19:16:56.409066+08	trwI3VpUGsim8pSghOfOur53m2ycHkvAcsSgOJBeBtRJitzQIf	1826
54	Out	2016-05-20 19:19:08.961863+08	2016-05-20 19:19:08.961863+08	pCXuFLvExDztNcmpJB9UpLNHe7AdXSKNerHtDD9AQ94nlqe52n	1827
23	In	2016-05-23 07:39:20.31939+08	2016-05-23 07:39:20.31939+08	Yq8w8m3IQakkxPcFKpSTzsb4gNtLSv91mHxu41DUbxFZOrnihH	1828
17	In	2016-05-23 07:41:11.851658+08	2016-05-23 07:41:11.851658+08	BhAmkqBeCdaKeNbcIfdVAFTQnrIcZzslh3YStj75MhQ152dNhG	1829
53	In	2016-05-23 07:56:16.611506+08	2016-05-23 07:56:16.611506+08	srVMHJEZvnZoZHr8ilqpqDYHEdIr1z8trdG9wUisIJhqZZyJLp	1830
51	In	2016-05-23 08:10:50.124605+08	2016-05-23 08:10:50.124605+08	9C3hTHLl9MlHGduWmr0VkInS9O27hNwqa0Y4HtqQGchWGc22U2	1831
28	In	2016-05-23 08:13:55.891575+08	2016-05-23 08:13:55.891575+08	XEKMgTkiaR7XIhXqlokcG1ExWUaZW5b5KvQ1PBjzcqXvY5mKtX	1832
30	In	2016-05-23 08:21:02.241918+08	2016-05-23 08:21:02.241918+08	vAYB85fjeCoGH9Ch9bstaWk8RJDEd8mZILkQQQA5cxLt7XbG8V	1833
55	In	2016-05-23 08:28:07.150169+08	2016-05-23 08:28:07.150169+08	Aj1urSE6hrDTSVoDvFd6KG4fABCmSLHc5IYwlm2TeGw7llKh0x	1834
13	In	2016-05-23 08:37:59.818131+08	2016-05-23 08:37:59.818131+08	nKFszP4CCWXT9bmhYYUa19qxGcjbKjZ84o14E5GQbnukPgSxFw	1835
31	In	2016-05-23 08:38:14.450329+08	2016-05-23 08:38:14.450329+08	YG6PEM2xxMhXUmMVqaa71CuvwKcQIrMq8SGMpHKmd2K7ngceHD	1836
58	In	2016-05-23 08:41:13.960782+08	2016-05-23 08:41:13.960782+08	lIPgEM0qmIi99qcODRfWFJYZRMG41XHmqfS53TvpleytVbJh3y	1837
59	In	2016-05-23 08:49:59.752589+08	2016-05-23 08:49:59.752589+08	EIImrj99nAg4wXkPbmsXceCbYhDrPGreYARRtaZgkGlhnV8PI1	1838
47	In	2016-05-23 08:55:42.135467+08	2016-05-23 08:55:42.135467+08	wufAXErk7H1xvZ8N12xaiiqUQe0Y4IZ2EFBkT3VaLWYG6gd7ib	1839
70	In	2016-05-23 09:00:53.934331+08	2016-05-23 09:00:53.934331+08	iRKZvkEvJIFsJS7VEaYiBtFjALPnT8PBajkWUySnHhfaAm6ONe	1840
12	In	2016-05-23 09:04:31.307624+08	2016-05-23 09:04:31.307624+08	7YYMIiihWBqvMQf7wA6PwN7dxHQ4fnimNH9ezrNW3DSPd8WaIc	1841
29	In	2016-05-23 09:07:41.034383+08	2016-05-23 09:07:41.034383+08	1Fz8sxPI157jqU1190rWWujyKN7rxOUydU6WSVoTavDRQDSZEK	1842
62	In	2016-05-23 09:09:14.902939+08	2016-05-23 09:09:14.902939+08	5kFojaCpSAFw9sRGPslEMMAZnZmF91ZElo3VPFLrQanZTFps8b	1843
63	In	2016-05-23 09:16:26.874743+08	2016-05-23 09:16:26.874743+08	6VwG4kqr0zsZEePHAoXVgw6UXZjNRsyYNvoSgfJgeCHsqgB1Vh	1844
54	In	2016-05-23 09:29:16.377518+08	2016-05-23 09:29:16.377518+08	WBebgCBQZdIXBgT08AfSrLe9EVoOWK62WleCxpcXTu5ebYfkjL	1845
56	In	2016-05-23 09:57:06.799785+08	2016-05-23 09:57:06.799785+08	CafqjtMZJstPvPBZc9PFgsAlXlKDW3YieEaO8wxRpqqlH2LtBl	1846
27	In	2016-05-23 10:41:02.934135+08	2016-05-23 10:41:02.934135+08	8reIcC5wPa1xKfCt4Kq1lhsbTAdo3oaBgFUJRYGrAHoTv1NzLF	1847
12	Out	2016-05-23 15:18:02.782504+08	2016-05-23 15:18:02.782504+08	17vtiP3ME7CoIr4mBVLSNUiCyfEMfZbggXaPwdlCkx13p4o2aA	1848
28	Out	2016-05-23 15:53:07.137358+08	2016-05-23 15:53:07.137358+08	TxeCAdrOzXwaDd9n26RoIClIEbN3dxD7usJ5VBTViQ6v4Fj6LB	1849
27	Out	2016-05-23 16:00:06.02297+08	2016-05-23 16:00:06.02297+08	udMgvbIJevHr3CkNHGYjlHAsDE8wKT8E8Uu46ENkAecDqNa7d9	1850
53	Out	2016-05-23 17:03:14.173374+08	2016-05-23 17:03:14.173374+08	rPQ2IdFQaZtin2Dj5IwT377fLx2v6f4w6UyN8FniohRcieMowJ	1851
23	Out	2016-05-23 17:04:26.068157+08	2016-05-23 17:04:26.068157+08	I0RPflNhhTOlQTHPrPde9SMa56FRuClCCCbryyZgSxSsRjII9v	1852
31	Out	2016-05-23 18:01:18.645315+08	2016-05-23 18:01:18.645315+08	xIOKsTQ7vLJgXVtAMr9vYbs1UKklcthaC7u5aLCVgVDF06OMyX	1853
70	Out	2016-05-23 18:01:36.061323+08	2016-05-23 18:01:36.061323+08	IXACYdWJQ9D8jQFeVp1hLhCYwDeLZctrA34iha27jFGTfU8AK9	1854
30	Out	2016-05-23 18:01:58.600922+08	2016-05-23 18:01:58.600922+08	rfq4EnHrAqV4if7mOoNPv6fCZKghV1rNgiRtXimgZIkJxs6LhT	1855
51	Out	2016-05-23 18:23:34.710782+08	2016-05-23 18:23:34.710782+08	ldaQpAlWrGXjdES58yougODRhBKnW1HHeriU2T1tjYdOm6Tu5I	1856
29	Out	2016-05-23 19:02:53.910918+08	2016-05-23 19:02:53.910918+08	plg3DNEXCjYT2ELjiMEjGxItM4ypy47ppns4B6bNqApsOBc7Xp	1857
56	Out	2016-05-23 19:03:12.970412+08	2016-05-23 19:03:12.970412+08	qno8gADgzCk72auue61FTqPJjnUMu2Ckp1tXB7DBJxILYDFCJG	1858
55	Out	2016-05-23 19:05:06.342411+08	2016-05-23 19:05:06.342411+08	Sl7r5qfZDacQLSRFycMDneB5ziIFvaVNNcFSUu2hVe8q7Y67BS	1859
62	Out	2016-05-23 19:07:18.706413+08	2016-05-23 19:07:18.706413+08	Jx7U47DMM9wrWKUmmyhogDTn5aMBhXd1WkVZsivFrs7PDbBzas	1860
59	Out	2016-05-23 19:07:58.289124+08	2016-05-23 19:07:58.289124+08	oG6J5BtRMby0cVl85dq1sjtz87aK7BDwRJFWU9xrlwrOSdWXHO	1861
63	Out	2016-05-23 19:09:56.841736+08	2016-05-23 19:09:56.841736+08	YA7S9GZkZhvmdN6stb3rTnoLCHxioF7MPEoYUPJ46FrkcxdWZg	1862
13	Out	2016-05-23 19:10:15.045709+08	2016-05-23 19:10:15.045709+08	O3UENgVLPJaWg0lVZGusK18ClkAOHj5gmZtAGPVfi6CP7xufEo	1863
58	Out	2016-05-23 19:11:07.54062+08	2016-05-23 19:11:07.54062+08	YYpgkbRu0ie5OQeIauh6ZQDlpKjjzwZYVPFG0fB1Op6mGk6ren	1864
54	Out	2016-05-23 19:14:36.738866+08	2016-05-23 19:14:36.738866+08	xFEB14UknUhN3ElIUmxfnNVtAldFdJ3aYHlZLGKAk2WnGJ6k65	1865
23	In	2016-05-24 07:56:40.243051+08	2016-05-24 07:56:40.243051+08	PsRumbgRqKjuuICgrYwChhEFVTXcEdgdX8YKjGkbZVWVniCfG9	1866
12	In	2016-05-24 08:02:14.840924+08	2016-05-24 08:02:14.840924+08	qxr5DNYkzmPgRvpzGZG1BpWgLKPXzfgqeYvrvVcvI1cjxSjE2y	1867
30	In	2016-05-24 08:17:08.11079+08	2016-05-24 08:17:08.11079+08	FDoltA6Jg6yOwdvtVrP7nh9QR7sAKu9Z7xM18SKoYJDVw9PS2o	1868
51	In	2016-05-24 08:19:05.435148+08	2016-05-24 08:19:05.435148+08	ZpWiGwp97A4HkBF6CNYWD7pPcnZ2FbqoRNXhKNqRXuiI6xOJLv	1869
31	In	2016-05-24 08:33:57.020782+08	2016-05-24 08:33:57.020782+08	pX3fxfTXhi8YXZu6HFT8h13QI9OgSjcIHfxFLRm3AubiUWnllH	1870
55	In	2016-05-24 08:41:03.221549+08	2016-05-24 08:41:03.221549+08	tTIwta7HHZ1trIZpXuHKwRFY9k5xWqFQKWOE7VVN4WHvoqlMl3	1871
53	In	2016-05-24 08:41:35.500557+08	2016-05-24 08:41:35.500557+08	giUwHdhMbEDqeYN2mUXIrboAYe1K1lNhUqemVM97ZMxEuLHhpo	1872
58	In	2016-05-24 08:47:15.358643+08	2016-05-24 08:47:15.358643+08	zhQoqyTrIUdfC9Wru2E49nQ72LSJ3H73yXrqWLiopMU2V1tQ48	1873
63	In	2016-05-24 08:49:33.177394+08	2016-05-24 08:49:33.177394+08	UDvuKxGlHJ4OM3wEsTZbIPxmSSnMsrUN5PIPNYBerF4EH1SBT2	1874
54	In	2016-05-24 08:50:02.785744+08	2016-05-24 08:50:02.785744+08	mmSjZtDNG6FkTKAljYKuDC9HQQHsbluNXN87HLUYRjIu4Sgn10	1875
61	In	2016-05-24 09:02:52.490801+08	2016-05-24 09:02:52.490801+08	hECqVcImVtYQH6nPD5kidBSv6WPmKQm2eyt9bCw75VXMbLlpQW	1876
59	In	2016-05-24 09:04:13.215215+08	2016-05-24 09:04:13.215215+08	X4i01oWPaqpNsUMmdxxa546cQhwCXOj5SR5SGbsqSiFLDb7qa6	1877
29	In	2016-05-24 09:18:38.103947+08	2016-05-24 09:18:38.103947+08	Rf9WHZEFmlcVp5xuYDWQ5y9KJLvRCWXdBgATGPi3ALZ1QWvykS	1878
28	In	2016-05-24 09:39:51.753566+08	2016-05-24 09:39:51.753566+08	PoRY9kt5C7bikmPuGgKyjUKJVkpRjat9PLgY6bdIhF1S2RNI8h	1879
17	In	2016-05-24 10:51:23.833695+08	2016-05-24 10:51:23.833695+08	HrCaBhL1A5b4D1PuZVVDnESpgUH4mOl4GxeRf0Sp54tI4JCdoi	1880
27	In	2016-05-24 11:38:03.913532+08	2016-05-24 11:38:03.913532+08	qdwJSdnjha8TdPRIq7IJwNNqfRAr6yavcXF5A3orcwLHLlZCss	1881
57	In	2016-05-24 12:05:48.229011+08	2016-05-24 12:05:48.229011+08	VpGsguLpnQpONRvcW6fLxIIIZd49px2MnHFTCaK019OOaJ18Pg	1882
47	In	2016-05-24 12:51:06.93941+08	2016-05-24 12:51:06.93941+08	SNykfYOkhFhibV0qyDRJDSSbr4usBLYeiXPO6n9n3qWdMWULjw	1883
13	In	2016-05-24 13:23:01.758865+08	2016-05-24 13:23:01.758865+08	ewP7YHBT9Moi1WGPuMD4AGvguIDPdxLIukQT2bwBxltxIAODWb	1884
12	Out	2016-05-24 15:11:27.165852+08	2016-05-24 15:11:27.165852+08	HgrDNlVaB9YXSTIrvKTsWRdQPvam97ORnGeB2AlEJKllm4diO7	1885
61	Out	2016-05-24 18:00:54.172985+08	2016-05-24 18:00:54.172985+08	buXGKwCukM29noPS0Rclfv6RgsVKbtRDnzT9wf3h25qouFHuhs	1886
63	Out	2016-05-24 18:01:21.278591+08	2016-05-24 18:01:21.278591+08	gNoloWeJqGDIT1Iw9FdDweImUD3l7ken8TZvzEFqUS9xTRudgY	1887
53	Out	2016-05-24 18:02:30.008955+08	2016-05-24 18:02:30.008955+08	pdD9QhLTTTE8HLbpHa4XRYzaWT1R6h0wLE5lvRFPuTWBo816j6	1888
30	Out	2016-05-24 18:02:45.314389+08	2016-05-24 18:02:45.314389+08	dBedkA6mcDUc9pqFblgqBaJhl8pnEZtrkXVVhbIKomwxcmDDZt	1889
47	Out	2016-05-24 18:03:01.5786+08	2016-05-24 18:03:01.5786+08	4kUOSGWI4krxccV88DjPXXCUWnHj2qc6a8U3O1LSlDQOpvWw9G	1890
51	Out	2016-05-24 18:04:30.149141+08	2016-05-24 18:04:30.149141+08	NgoYBKNS4OJgUuoyxDzJflW6AM2hKBxgrlF36cWA1pqVjfUhsU	1891
31	Out	2016-05-24 18:07:41.770801+08	2016-05-24 18:07:41.770801+08	1YGXeQtg8Er6ujrAmxmJ8n8yJseoaXJa7Z8l12S8GKEA46Kq47	1892
59	Out	2016-05-24 18:24:28.654292+08	2016-05-24 18:24:28.654292+08	ABuIBFBp3kOMMUvUGwWi5m3Jx7PIxTP8eLQpZbfdM4ziYvDosk	1893
58	Out	2016-05-24 18:28:03.673129+08	2016-05-24 18:28:03.673129+08	XyXZIUghmeBClpXCf7nKkAOkswg7lZqIYOsqsZYfDjszZQCEX0	1894
23	Out	2016-05-24 18:52:54.836502+08	2016-05-24 18:52:54.836502+08	ZHBx24uiBfI2yqQqhJQGyd0rdZHpnopN61L85FqGu9Htyhkg1B	1895
13	Out	2016-05-24 19:00:05.549756+08	2016-05-24 19:00:05.549756+08	wzowqSW8JKw9h3A3BFI2UDBm7AUrqV3oUrlLKJTddRmLUwNfCf	1896
27	Out	2016-05-24 19:00:19.486803+08	2016-05-24 19:00:19.486803+08	hgssT03xruSujwmVJ7nmkREXmhTBOfq6Mjypj2nbwGWgEIBWPz	1897
55	Out	2016-05-24 19:01:17.236155+08	2016-05-24 19:01:17.236155+08	KARXgEGBOdqFjDyi3ikqKh8pOM8ZsXZDh1kOF0ZdeQsOdr7gar	1898
29	Out	2016-05-24 19:01:32.250605+08	2016-05-24 19:01:32.250605+08	Xuafkx1tYtR7798qXNr71VXttAl1qMsOHT42R5uzyM76VFw3co	1899
57	Out	2016-05-24 19:01:43.309077+08	2016-05-24 19:01:43.309077+08	AcLhWFrIGieA8vdBw5Hs5GFCMkRJn49ygUgDjYVzHAAP6ma3rr	1900
54	Out	2016-05-24 19:09:34.112948+08	2016-05-24 19:09:34.112948+08	vw8B9UvanjewhLQOZAw5AEFKdL7EOy6JvDU5hPfV9KSrfsFF3C	1901
12	In	2016-05-24 19:32:42.740163+08	2016-05-24 19:32:42.740163+08	KDQZW3udHIdNcZa7eIWKnfeFXL8maByuOPUuSOZjhC6KlgQQyw	1902
17	Out	2016-05-24 19:48:21.738309+08	2016-05-24 19:48:21.738309+08	kmdP2AkAwKLvFiLien8DXpQd9CLacKXN6Am8LWHIrcF6LapzOx	1903
28	Out	2016-05-24 20:12:28.527033+08	2016-05-24 20:12:28.527033+08	DumdZwptWRE4oKFbRZ8jszL86hhvg6tt2gXadNVAoiEd3TFV3N	1904
23	In	2016-05-25 07:54:19.09694+08	2016-05-25 07:54:19.09694+08	EvNa3THlPxrJsszQUdnynch2FlUUGXrUTF5WiMI8KARD3RdX5R	1905
12	In	2016-05-25 07:58:48.929658+08	2016-05-25 07:58:48.929658+08	Wr3EtJzPnGwfkQupwdCFlWPDkSeOzipVbskVCjtz0qekHZaEDm	1906
61	In	2016-05-25 08:03:17.447234+08	2016-05-25 08:03:17.447234+08	UyKsB4LpSLYHqAAbfMLZMMQ17haivnVQmoJxsfnL1MdrWnTCAp	1907
51	In	2016-05-25 08:19:09.831744+08	2016-05-25 08:19:09.831744+08	kWBBXJt91pwWGjLahFFVaGrE8O2bZDRLjcWHvQQwGMTW6p7m4M	1908
13	In	2016-05-25 08:32:00.970054+08	2016-05-25 08:32:00.970054+08	IfcAtkYvN89oTrR19NRZKhvnE2dKohh7NKHH5pDSxMHREhSN5t	1909
58	In	2016-05-25 08:32:13.308612+08	2016-05-25 08:32:13.308612+08	wPasEourAkZqrwB9EGyRixnzP2hrPmlMDMGRCBILvsDnpOw4ev	1910
55	In	2016-05-25 08:32:17.910576+08	2016-05-25 08:32:17.910576+08	VNtJNJL5Bkrw75KNWVYoqTh4HXSEb7A7U4RrNlwZWoWduq1RMZ	1911
53	In	2016-05-25 08:55:47.190787+08	2016-05-25 08:55:47.190787+08	GD3xHJVjX7qhELmfCAR9jyxGcs7dKSCagFXxY3h7AYoOtb46lW	1912
70	In	2016-05-25 08:55:59.524832+08	2016-05-25 08:55:59.524832+08	GVUEl77skRLw12CZ0lcirmHgCBIGH4mXZHlLOsE9Ja6LcItc3W	1913
31	In	2016-05-25 08:56:00.22443+08	2016-05-25 08:56:00.22443+08	LvKbcVmul4yYbYoNuDF9MZjRtMjoxnLJifuLBhGwlFVNoKkjX0	1914
29	In	2016-05-25 09:46:10.98884+08	2016-05-25 09:46:10.98884+08	stZcLTx6IwseGcJBxUsESfTx3IIn1pntjNW6rUCAR5ngh8rfck	1915
57	In	2016-05-25 09:55:01.137339+08	2016-05-25 09:55:01.137339+08	t5QN3TfLHhB5buT81KcDU3IJkzRcf4NZ9nwCIcWZKheuc83dSf	1916
54	In	2016-05-25 09:57:31.916245+08	2016-05-25 09:57:31.916245+08	qwi9GS8h5nkSMuHJ6Yvc8GKmBxuEbNtSKbaa5jIAX3ctxtD4SA	1917
47	In	2016-05-25 10:01:31.686577+08	2016-05-25 10:01:31.686577+08	gaP2OayJoagi31KdbPNtZuwCou52yYCf9bhXCgp2HWjKX4x9TL	1918
17	In	2016-05-25 10:13:52.036005+08	2016-05-25 10:13:52.036005+08	33G1E5vK7tsJZ2uHY7xP9FvsYTxWdRrgU8hiDc3KXvd7wYOWfM	1919
30	In	2016-05-25 10:18:17.634773+08	2016-05-25 10:18:17.634773+08	uobqiAKghx8ZechMLuyOFWKsdHR2m8Oiw0ZfAtMrrURW7AsS5r	1920
28	In	2016-05-25 10:45:00.805169+08	2016-05-25 10:45:00.805169+08	qKOBD1Sf3FmRxkRXQcRmUJHvqO6jqBbhVzsj1LP4aCWXwx5MaW	1921
79	In	2016-05-25 11:15:46.59612+08	2016-05-25 11:15:46.59612+08	95pQ1go7PeI2Nn1FX3aw7B9di5bnSBKbGA2HqpNGVgIrUJ82Mi	1922
80	In	2016-05-25 11:15:50.161722+08	2016-05-25 11:15:50.161722+08	yTt87cDhQfskG9uIPl8n2cTKUxdc0yLySE7ZqKHHyA3GJxXijf	1923
27	In	2016-05-25 12:49:36.906979+08	2016-05-25 12:49:36.906979+08	WlJ05nxiQyilxBz5kqP18OBBeU9CDssjdBkjyiSPhABfLBk62A	1924
12	Out	2016-05-25 15:05:03.024726+08	2016-05-25 15:05:03.024726+08	7BYJLDnUP2NIl1TVkSEDsvN4bjFMpHWwR5GnI4Ih5fzqgTNRvb	1925
30	Out	2016-05-25 15:12:34.545901+08	2016-05-25 15:12:34.545901+08	enX2rAl7WaO3Xp8ndQrw8xc8oJbBkXnPLLRDVDK2ni5MZDADd2	1926
58	Out	2016-05-25 16:49:57.945403+08	2016-05-25 16:49:57.945403+08	Alzltn5Vzp3mFO8gcdswehgj3FwDTaFcMFPH3Um3JppYExEqb8	1927
23	Out	2016-05-25 17:10:32.719481+08	2016-05-25 17:10:32.719481+08	nHoT1sjx6CXLpuaEBdixg2nWa2Vos7wgOmAOftMl6t7vohA0Ls	1928
17	Out	2016-05-25 17:24:32.415444+08	2016-05-25 17:24:32.415444+08	x3ulZVn5KgCHNa4XyjRLUXFbT4Kd4fV3iQoIvcNGKZXg9cE8Lf	1929
61	Out	2016-05-25 18:00:33.487272+08	2016-05-25 18:00:33.487272+08	SqDhSglmJpSpsAGhSCKoSeO0LXcZfxF8oSqH9c3SSVILfY38kN	1930
53	Out	2016-05-25 18:00:53.370008+08	2016-05-25 18:00:53.370008+08	wD2LDNtpwZnChcfYtoBwHdSZy881GsOE5QZInT8k2vxjXcIRRT	1931
70	Out	2016-05-25 18:02:05.446635+08	2016-05-25 18:02:05.446635+08	Oi6rI5zQ6GJVUOv4gjXnUZjSJH5bjW58FByXGyxMFHrjfnnMYL	1932
31	Out	2016-05-25 18:03:46.622938+08	2016-05-25 18:03:46.622938+08	A3ttVDBaou7t3N52uL1shHAZ1pOoCvAMy4FUIR57MC1OZ6RTRS	1933
79	Out	2016-05-25 18:04:28.938132+08	2016-05-25 18:04:28.938132+08	N9jXikN7ZZ4ju3nBX6ccDxoFNNLnrmGFv0mekAlLjp5esspQyR	1934
51	Out	2016-05-25 18:07:28.445111+08	2016-05-25 18:07:28.445111+08	2CPqRmFma6YrLUr89cIux1k3gdvV4ux67NwYACLlItcdOUlX74	1935
51	In	2016-05-25 18:07:44.637114+08	2016-05-25 18:07:44.637114+08	S55D8lq3HtxF05cwdm9yYRsB5GfqnmuGrzTykJ22E0HE5tBifK	1936
27	Out	2016-05-25 18:09:26.902873+08	2016-05-25 18:09:26.902873+08	hEmaPrq4ieqcuicOhNhkQvkgAqaMZGgHUTrtKix3OogJXJhGgP	1937
28	Out	2016-05-25 18:10:05.345894+08	2016-05-25 18:10:05.345894+08	17MloWbPrBfYSA2K4N43QRr7kQQSg7sgEFS3k5RdG7CiIE4Mb7	1938
55	Out	2016-05-25 18:11:00.048799+08	2016-05-25 18:11:00.048799+08	P2ZH8KhYnOfg5tuXwgcOJsWVbnkfBLmaNMrVgZ4UxjB2d6aalC	1939
13	Out	2016-05-25 18:51:05.080758+08	2016-05-25 18:51:05.080758+08	y65VbhJMNUhA45WvaEVeiTOsV2y5clIbqN7T5QoRtXcxc9tDNP	1940
78	Out	2016-05-25 19:00:52.630932+08	2016-05-25 19:00:52.630932+08	r5sGyOJxTvilXa9d3E4sgxPIw2RqFoH7tAOsXgq2cZnAAxnDCr	1941
29	Out	2016-05-25 19:01:54.950466+08	2016-05-25 19:01:54.950466+08	6rqVAmYcdnQuuL4JEc04eceSmoPb2bT8TKee7CGkzhfu2kDGNE	1942
54	Out	2016-05-25 19:05:27.397539+08	2016-05-25 19:05:27.397539+08	K1qyTensFpUixy3bcAntunaaidLvthAEj1DDf16upbdnZfPDpD	1943
57	Out	2016-05-25 19:16:00.546527+08	2016-05-25 19:16:00.546527+08	6k1gLjKgfEOpR8qeLVfRQV34JcjipZvvJxcegwLMBjCcr3ICYx	1944
23	In	2016-05-26 07:48:41.427288+08	2016-05-26 07:48:41.427288+08	dyTg2mJlV8LR4ePhJ6eeTpNfSFhkRHi6FClIx54TEPuI4KzNRe	1945
12	In	2016-05-26 07:49:00.803399+08	2016-05-26 07:49:00.803399+08	1tUOZwdHh6YQBncx6a3A4HZzZdKZ0lE1fiQFf4WNA5oMtRKz2N	1946
53	In	2016-05-26 07:49:50.531185+08	2016-05-26 07:49:50.531185+08	A6ej6ENQnOC1Prjp7Ptdm4ibQc3jc47mBlXHzuimJunimXYtwS	1947
61	In	2016-05-26 07:50:09.074874+08	2016-05-26 07:50:09.074874+08	XjWHLwtOhWSoJdZquZldM4XAmKiLEfnlPK3kHw9yTbmmFNcAwO	1948
51	In	2016-05-26 07:56:30.391111+08	2016-05-26 07:56:30.391111+08	nJSLTFgCaurOhHik20hByAmlw29ZC6x0PQMsf25HwwfeDOPFO6	1949
62	In	2016-05-26 08:00:37.063623+08	2016-05-26 08:00:37.063623+08	QNHD9EFInROkRnCngrpl8nhnSvCrBaxbwFo7S4PGWn1xbDlH5b	1950
55	In	2016-05-26 08:24:31.608581+08	2016-05-26 08:24:31.608581+08	3DPk1rgDiqmgTkvIqOMGes4fpfrbwwEyAdjBVQOEHBvkvr3mGP	1951
58	In	2016-05-26 08:30:12.212752+08	2016-05-26 08:30:12.212752+08	3tH7Z8mRjjOxiYbSj6s8KBJGvE7x1NN4HeBqmxJWhhUQG5s0Cm	1952
59	In	2016-05-26 08:30:24.856459+08	2016-05-26 08:30:24.856459+08	8WwRmsftqgHEkZtvQgtiDbQh2hmuhygpVeHIXwCOdTcO3VKTCF	1953
54	In	2016-05-26 08:38:22.435624+08	2016-05-26 08:38:22.435624+08	CPqc6rKtm2rUrN99ff5r4iLg6NCRqOf3nWftO1nC2fgt3o3iU8	1954
13	In	2016-05-26 08:39:04.183605+08	2016-05-26 08:39:04.183605+08	ZYquFwIRO9p4CcasWzsKBvzrp3gskC1KkrFzpYREhGIttsmQsg	1955
31	In	2016-05-26 08:45:42.5989+08	2016-05-26 08:45:42.5989+08	k4ckvSndLYpNtaF9a5h1JPHbJBU7bNmMSP7Orv2DUraORpX2uF	1956
70	In	2016-05-26 08:53:43.473465+08	2016-05-26 08:53:43.473465+08	3EeKpxVL57irTAHbY9WaM1SxPtnwviCywqJnoo8tvqlP131aCX	1957
29	In	2016-05-26 09:27:29.090238+08	2016-05-26 09:27:29.090238+08	BYZcWyWKvS38R0yknnZvgVmSuoVvOhTZG3Cm2i7xCA6dA5Nxsw	1958
47	In	2016-05-26 11:20:55.916793+08	2016-05-26 11:20:55.916793+08	uZSh2MWXIuElUUpgHqPOobYvEi1cgsZbS1JUOp2gkGTEkIu2AK	1959
17	In	2016-05-26 12:41:40.8465+08	2016-05-26 12:41:40.8465+08	QyvytAhumPnM1HOKllAnTu4v9oE4rOOINKHHVyCIO0ePH3j3ot	1960
27	In	2016-05-26 12:50:49.564209+08	2016-05-26 12:50:49.564209+08	qIouExkS2cqQuDlCUGCgYahEyyHi26csORncPY5RAvr59cHetT	1961
28	In	2016-05-26 13:09:57.944713+08	2016-05-26 13:09:57.944713+08	LS43g32wl44PwSql5FKAgU6YZFBrt5LFXOIERLBEPFdMhT8ljS	1962
13	Out	2016-05-26 14:15:34.288574+08	2016-05-26 14:15:34.288574+08	vQw2xWIAOCEjRl8jzZ5BnUQRq7uyteRp4Os3uACIMR2nDAXDjc	1963
12	Out	2016-05-26 14:19:14.444792+08	2016-05-26 14:19:14.444792+08	OX7oyxvtwpYOfclYfgiry5J1sWBRju47TBvS9sM6iuUOYGwEwg	1964
23	Out	2016-05-26 17:02:21.865532+08	2016-05-26 17:02:21.865532+08	6wlPxev96e4AmXLizVbMbKH6joMg3KN9G9ZEnUNtAR4wyQfyuH	1965
53	Out	2016-05-26 17:03:19.338908+08	2016-05-26 17:03:19.338908+08	KWbbcLRy2UJOdZXDnLhBFrdJocjUaeluCOXojxnlS7A6ghJU31	1966
61	Out	2016-05-26 17:12:12.347825+08	2016-05-26 17:12:12.347825+08	gIsJbhvLCW0xSCLy05xnqQu1Wcio7lpn3i7eQ30ba0Z2Cv2C1y	1967
47	Out	2016-05-26 17:17:57.53784+08	2016-05-26 17:17:57.53784+08	1rPvrvYakfMaTPKa4jd5ME5vGHqIUrIUihRbcyCNeYy8xJi23M	1968
62	Out	2016-05-26 17:18:09.397596+08	2016-05-26 17:18:09.397596+08	7OaCKrTBAw3SSl9sNmsZAX89f5SO8VkFtMREEuPOrSqKF0Dcm6	1969
27	Out	2016-05-26 18:00:23.1385+08	2016-05-26 18:00:23.1385+08	CwdJ6JPYhX4SlxoDD37cRy5HJKHWw4c91GS8YrgGPkjBiYOvbV	1970
70	Out	2016-05-26 18:00:35.081338+08	2016-05-26 18:00:35.081338+08	Y2UdKnxbKvgw4hDXpmOW3nHly0KMvvrUxN8IB6uW2aT6Jgd9S2	1971
31	Out	2016-05-26 18:01:18.826629+08	2016-05-26 18:01:18.826629+08	fVpwIowcBsY4NWQVpbbj8dLbjdINmkPSHFOY4LCFEjJbHj77Mi	1972
55	Out	2016-05-26 18:04:19.235105+08	2016-05-26 18:04:19.235105+08	qUMC66pNSc9r5P8TyCoAR4ukfCUmIqV9LrLRwBoQnxIsNQMMbC	1973
54	Out	2016-05-26 18:06:34.755104+08	2016-05-26 18:06:34.755104+08	X3FSnveIiw9E7U5Sv2dkSRikK6BgTms1q8Se47wl47zBb5dX7G	1974
51	Out	2016-05-26 18:20:17.182231+08	2016-05-26 18:20:17.182231+08	Iah1L27WiaKbbAj4onClZGrZRTd41lLJL3Kg5SEo3XQehAjWwu	1975
28	Out	2016-05-26 19:03:32.12337+08	2016-05-26 19:03:32.12337+08	IWBB6cejgfV2zq5KYBmmypKPU2ZDZX9r4K3AwhtdNPfNGkgovT	1976
29	Out	2016-05-26 19:14:13.671831+08	2016-05-26 19:14:13.671831+08	buJvLnxu2XSAPWUSfRAZ5XyktFVb5R5gMOchCacD85OXaszHJ9	1977
59	Out	2016-05-26 19:32:52.333522+08	2016-05-26 19:32:52.333522+08	qOgp9a5eCA6HqTeSBq3m5BrSiSLijesa3ZPCAVrMfxcWQIyb92	1978
17	Out	2016-05-26 19:36:40.492162+08	2016-05-26 19:36:40.492162+08	OEEGgwj2gThY3k8TwIxoedlHADZ9ojBDxPTeMDh3gObj9jD62B	1979
58	Out	2016-05-26 19:45:09.520242+08	2016-05-26 19:45:09.520242+08	ugogyytY8hIJuGiPu5cc8J1j3ATGGVRBCHrBGljNT2gPIPoDUR	1980
23	In	2016-05-27 07:51:22.942697+08	2016-05-27 07:51:22.942697+08	ockpMn0p4GLVRXmJi25TPZV6ynVm10Epcyfxlgnpw9LOg8iQAn	1981
62	In	2016-05-27 07:51:37.045165+08	2016-05-27 07:51:37.045165+08	saNOgMCC9DCN3oMin8ObxLjKkQSTqcHjDe9t1L6AXIYa7uJu3h	1982
12	In	2016-05-27 07:53:59.72151+08	2016-05-27 07:53:59.72151+08	W14GLogmHXPYIcDRWEmbOKuwu2qEwtvSuziGnQ45xTeG6rhb6T	1983
31	In	2016-05-27 07:56:29.65553+08	2016-05-27 07:56:29.65553+08	EUn9RiBIw7Dsa8rJOfjSlhuPy1HgdNAqrxzJhAbdIoWswOCL5v	1984
54	In	2016-05-27 07:59:14.807456+08	2016-05-27 07:59:14.807456+08	mqeiGcjXJMuTEmRE59OgmgVJZShlmmiZdMItz1RJOMmc9EpEMF	1985
13	In	2016-05-27 08:19:45.223029+08	2016-05-27 08:19:45.223029+08	u9vQSVsBHfx0FaNXUMYvfwISYQfOe3dZCZ1f5spMYnMnOjLs6t	1986
55	In	2016-05-27 08:21:11.494398+08	2016-05-27 08:21:11.494398+08	olp7EOXtnCwRlA1mo6feSESo2rYNkeHZQ7feVDYJQWkCflyUre	1987
29	In	2016-05-27 08:28:13.931524+08	2016-05-27 08:28:13.931524+08	AJtc8vUfJEKankgUPDhyW8VHJB3IfuxpEqSMmw36CNgz8NTXaB	1988
61	In	2016-05-27 08:38:02.821142+08	2016-05-27 08:38:02.821142+08	W7J2PcDSvsNtibkBxX81dKNKKVin4JzaQJcpvoIrhfkQHVbF3j	1989
58	In	2016-05-27 08:38:06.037649+08	2016-05-27 08:38:06.037649+08	Gh4d2OAkCE4CoUUQJQFbIwH4NYZyncj4KnhMCr6O5Aate5KxVZ	1990
51	In	2016-05-27 08:45:42.510147+08	2016-05-27 08:45:42.510147+08	ZoXrruQRtE4cIOQzkcrq2w1cqfhBdDlE2I5tDVL7jPk1nB1Xos	1991
53	In	2016-05-27 08:47:10.082417+08	2016-05-27 08:47:10.082417+08	OppPSg5AsiNdwPw2JAXeHG32IqDJO1Cmr2DJiITa2qFxGB0ZLX	1992
70	In	2016-05-27 08:55:13.137127+08	2016-05-27 08:55:13.137127+08	EcoHe68rPWsbKkcX4LpYwqPCpgNpGiNUMCl1IushRlJkWwIaI8	1993
17	In	2016-05-27 09:21:37.80616+08	2016-05-27 09:21:37.80616+08	9FyYRoFoeVX2ztEluWfnE7ZXs6UBgmIp2HPS6dHj9ol9i0udWa	1994
28	In	2016-05-27 09:35:50.662881+08	2016-05-27 09:35:50.662881+08	Qkh0Ja6nlmZ4dbL35RgMCpBxytxtXUUxFCxYm4MYrvcVXyXcQE	1995
56	In	2016-05-27 09:37:32.97598+08	2016-05-27 09:37:32.97598+08	yc4AZ34Xwb3RZIdXqQbCyT8bygaWI1kHdoRDsVlp6nGf6tDwKp	1996
57	In	2016-05-27 09:48:07.325824+08	2016-05-27 09:48:07.325824+08	9KJHvHxWnGXYXBOyOHU96bwNH3HUzbK9vcQruOOifvHD7fDVwh	1997
47	In	2016-05-27 10:21:53.2749+08	2016-05-27 10:21:53.2749+08	e3IbQZfh4fJOoE1F6vdUeJQvWXcj3ZRhcjJ3KyjOd3mSInhOiL	1998
59	In	2016-05-27 10:31:51.072518+08	2016-05-27 10:31:51.072518+08	sNeJKCqvutVMb86uBQtuoXxa0GOhe73WVipotglpaHCCPI7Zi1	1999
27	In	2016-05-27 10:53:56.33191+08	2016-05-27 10:53:56.33191+08	UXYT8ZiWHNeKt93kywRjm21xEPHMz0NUXvwfVgDl4q6x19iy6A	2000
17	Out	2016-05-27 15:01:16.50698+08	2016-05-27 15:01:16.50698+08	irCjqQ98m989df6aLaHYMLPTJQc2PhB8aNrRn2YaBgjnMpPhQg	2001
12	Out	2016-05-27 15:02:12.827896+08	2016-05-27 15:02:12.827896+08	Fn2eGL5sNUaYcBvUcjWBKhr5VDuuuLaA8cpOxuHLPrt23pWfZ3	2002
47	Out	2016-05-27 15:12:30.469965+08	2016-05-27 15:12:30.469965+08	qtkhyGvsAqEl1MOqlMk3hAubBxRhd1kTuVCsk7mvx0gyN5p8Sa	2003
58	Out	2016-05-27 15:28:43.232891+08	2016-05-27 15:28:43.232891+08	BAk6lv4DehEPB9uM2fUobSoIQCNGKoqUybakXexCLCbWLWtNCN	2004
27	Out	2016-05-27 16:01:07.468363+08	2016-05-27 16:01:07.468363+08	Cmp15GCSWWHN1Hyb2WG0ibCK8Xq2v3P7pF8uVKN2qePsvOUxvk	2005
28	Out	2016-05-27 16:51:07.608466+08	2016-05-27 16:51:07.608466+08	xeMAyVipXdswliCtdhE0j5e9xaYSYTDW8Zg85Pxc3qZoZliCTw	2006
62	Out	2016-05-27 17:01:24.486703+08	2016-05-27 17:01:24.486703+08	CD2rMzSuS0OeWXFDfKcdvfUVU3HCGk9SwBKKBmFcmdHJBWWqq9	2007
31	Out	2016-05-27 17:04:26.204592+08	2016-05-27 17:04:26.204592+08	TmoxIJ2aVHKejIp4b0qqcdUuwfRTVIcz5RxNkzxGHIu1ak6Ckw	2008
23	Out	2016-05-27 17:11:51.258505+08	2016-05-27 17:11:51.258505+08	3OaXJXDk1i2di74gVogS5wlzyLj5YV1bsb9C9Mv95xmn6qUagA	2009
53	Out	2016-05-27 18:00:22.22301+08	2016-05-27 18:00:22.22301+08	4k8ok7BUBi0DKsoT5wo17tyth5kCfRMiCTXwaiRlRSylLmFPj4	2010
61	Out	2016-05-27 18:01:47.434028+08	2016-05-27 18:01:47.434028+08	QqxQkfUVrAvEs8hR5IAX4by3NKpckZgBRfaBL6gDGdRAl9aqRk	2011
29	Out	2016-05-27 18:02:01.672471+08	2016-05-27 18:02:01.672471+08	OVMOYkiONSx4dPjEa6KHJaukkgtLXK7vpTJOE2lbUjf89PNjVh	2012
70	Out	2016-05-27 18:02:10.052037+08	2016-05-27 18:02:10.052037+08	1oIvZ3bSO9nV5dyO2CRnnvXT4gtQQP8REQMmTyGr83NDgLbiY3	2013
13	Out	2016-05-27 18:02:19.948389+08	2016-05-27 18:02:19.948389+08	WMx4p2kjTB8bcM2y9VxPN5SkI96trewN0uRpwCZQNh2z44yDZw	2014
57	Out	2016-05-27 18:03:30.772451+08	2016-05-27 18:03:30.772451+08	bw24gLDmF5RCSS7tI46rUTZWTdaTq9PS6SWmnja2o2EHTLBlQH	2015
51	Out	2016-05-27 18:03:42.951204+08	2016-05-27 18:03:42.951204+08	dulDRFq2ihB8AHag4OReQGgeWA0hvQzZLlmm1dojLzrUHSCLpc	2016
55	Out	2016-05-27 18:10:46.837391+08	2016-05-27 18:10:46.837391+08	zGsfvPpv8mM7Mhs9UtmJc7JUcZwnunQu4JbziRvpEHxZyqiTjV	2017
54	Out	2016-05-27 18:12:40.715727+08	2016-05-27 18:12:40.715727+08	mNc6rFfo3bcTWgl8fUZbKnsINr96Lsb8GEE8StwVUYy1Fk9uGi	2018
56	Out	2016-05-27 19:02:28.319654+08	2016-05-27 19:02:28.319654+08	VaVOssG1yctakAoxIHrEnMmlN2XWwmESNkqGd8IckCDUM2TeJL	2019
57	Out	2016-05-27 19:02:29.861288+08	2016-05-27 19:02:29.861288+08	s6hfs5hPbeDp7aaxqD69pqL3Lh4oLN9EUqtMvcmWGzNNZxMQBS	2020
57	Out	2016-05-27 19:03:06.00973+08	2016-05-27 19:03:06.00973+08	Z1Ju4eb8TwVcB0T6MOh9vy9IMiGiARBjSUdW9FebDBEOBhUX6C	2021
57	Out	2016-05-27 19:04:01.401095+08	2016-05-27 19:04:01.401095+08	h2BpKXZaGi2RSVv625MggYrvx3cRbjeIlp96NigdRj5tF10G6M	2022
57	Out	2016-05-27 19:05:28.584859+08	2016-05-27 19:05:28.584859+08	xmupissLKU5ynpowvCedp6Nuzbv0r2MpoIfXBZsV4xUqnJnjVS	2023
23	In	2016-05-30 07:32:50.630406+08	2016-05-30 07:32:50.630406+08	NLYkGYMCYEEu43DkaOJTtNROEFh2yEUMZ37pbT2AhG6lJJWshp	2024
17	In	2016-05-30 07:32:54.665424+08	2016-05-30 07:32:54.665424+08	MaDnzR2hT2vxOU1VKcyMmgbrSuBynsoAT1xTS0Bv27sQbtvvWu	2025
12	In	2016-05-30 07:34:21.409408+08	2016-05-30 07:34:21.409408+08	HIbsB4nM3bFrlisjCLjNHlUBD6592a4JsfC4j0QmbgdOPW8bsr	2026
28	In	2016-05-30 07:34:52.526725+08	2016-05-30 07:34:52.526725+08	zAdUKqaPzbz4usj7xS8OFj5s7UQF6I76SlZmcACclBfg5Pn2rv	2027
13	In	2016-05-30 07:49:37.379106+08	2016-05-30 07:49:37.379106+08	Q7fV0myQ25i9BAukwXu99gKpNPEBR77sEmOEZNebSNkdXfOUDJ	2028
53	In	2016-05-30 08:28:31.573971+08	2016-05-30 08:28:31.573971+08	dM0xCNNQYpXfhlS6z1Tdcw1NaY4z3HJgdJfph3GGsnvaZOhZQB	2029
27	In	2016-05-30 08:39:22.359672+08	2016-05-30 08:39:22.359672+08	D38EQimUhpl1XOLDE2GVI9JFjsdRS4cf7jtXSg2AWnC3CWGQYW	2030
51	In	2016-05-30 08:40:36.901894+08	2016-05-30 08:40:36.901894+08	vrfF7P8kqZoTFvD9TgoWqLJ2OVZew8Bs0q87GFr7oga4coD7U2	2031
59	In	2016-05-30 08:44:32.894562+08	2016-05-30 08:44:32.894562+08	cLNvOlSwRP5cI5TPCje4rUlSYOHlVln87B4VxWSPvX2DdVdpFI	2032
54	In	2016-05-30 08:45:09.356088+08	2016-05-30 08:45:09.356088+08	t7mfZL4p7Ybvgi7kE5HgTDEVQq14gGMaN9GwUKmctOXa8eLLjc	2033
58	In	2016-05-30 08:45:34.938102+08	2016-05-30 08:45:34.938102+08	2DpGiH7jLn0hPOqfLL08wtWVUeAp0tS27IIpZPauEabcySIJmJ	2034
55	In	2016-05-30 08:51:27.473044+08	2016-05-30 08:51:27.473044+08	RkCxFgcPVdJxfRGxHpNrkbSMEQoXjbpBM3Acjm2FQLD6mU44KR	2035
31	In	2016-05-30 08:54:01.516734+08	2016-05-30 08:54:01.516734+08	v53ORHoGoZrekFhuqQhsf8FtD2NH6hi3mlRE4GUspMXabEVSeD	2036
61	In	2016-05-30 09:15:58.946098+08	2016-05-30 09:15:58.946098+08	LLLaEYcbpiJZl7LCLPSpHICosn3OGhbc3vDHUpsLYDtKJFXeez	2037
47	In	2016-05-30 09:36:34.350421+08	2016-05-30 09:36:34.350421+08	UwIglBUnYkWANZ6apbQjvzvpKF6rtkrNh94SKYHsKm3hMAICki	2038
29	In	2016-05-30 09:52:32.41603+08	2016-05-30 09:52:32.41603+08	vgirX37cu1NmP5vTXG2o9LbD3yNLB857onyMq6yl7NYWSTz0j2	2039
57	In	2016-05-30 10:08:24.471305+08	2016-05-30 10:08:24.471305+08	otNR7QPUlacqhRegnVnmHuApRcJRc3SRwps4GJY3tBtbbYIP46	2040
70	In	2016-05-30 13:00:01.92232+08	2016-05-30 13:00:01.92232+08	CL1MASyTtbXN4UDwYTF7W9IQktx4J2AWNBsXer1YTYuW38Tbcj	2041
12	Out	2016-05-30 14:46:50.609062+08	2016-05-30 14:46:50.609062+08	j8s2YdvWhFYrlv4dThVVGy4CV7KyiwiS5bUdFPAwejpQfs49bZ	2042
17	Out	2016-05-30 15:06:32.158495+08	2016-05-30 15:06:32.158495+08	erXi33pN3YKk1PMV3buDZawO1cI5mseRkCAnGyBIXV3ZuQ5x20	2043
27	Out	2016-05-30 15:07:03.805689+08	2016-05-30 15:07:03.805689+08	Bba9zblHgYBKzuW9im8u5gQ8GLYLJaLVCvdBXPTExdYxZ57IrG	2044
47	Out	2016-05-30 16:37:07.77918+08	2016-05-30 16:37:07.77918+08	Dwwd5CyeXJFsnQoScMr5Zpj8nJDub5Bo28S8KSlrl1jZRY23ut	2045
23	Out	2016-05-30 17:06:00.458298+08	2016-05-30 17:06:00.458298+08	9UjscYBpTmuebwm557XqxJqisIHtMBnVfXNI6Y8ZM3Exz1348a	2046
31	Out	2016-05-30 18:00:11.355107+08	2016-05-30 18:00:11.355107+08	u6tlnl55fQHTvw2JF8sNhEPvCPwFT5qOAjAyVF4CgKfcHhvWpn	2047
13	Out	2016-05-30 18:00:32.545415+08	2016-05-30 18:00:32.545415+08	tX2JTFiQUDULbf5leb1imh3TJKBFq13kX541KnRo0vAbbFNGqO	2048
70	Out	2016-05-30 18:01:12.233995+08	2016-05-30 18:01:12.233995+08	xd517OMIdDIgxql3q7pIvqE6RpMo6CD4qI6xhRFLeY2dOofGuW	2049
53	Out	2016-05-30 18:01:50.107187+08	2016-05-30 18:01:50.107187+08	YqMmwodJdjVqnMAtKrLZD18FdW3KmxpKoD8m2k6fUbWIxgCIYX	2050
55	Out	2016-05-30 18:02:15.317701+08	2016-05-30 18:02:15.317701+08	rkYy0CV3WI2McqZkdbVjHzLnHJUTa31SnZSnlxqHGsesjEdNp8	2051
28	Out	2016-05-30 18:04:55.759373+08	2016-05-30 18:04:55.759373+08	778RuPkPtLStoGTG4FEuWUoANYO0vE93KHUFgFeab7UPNxfRDt	2052
51	Out	2016-05-30 18:09:59.202897+08	2016-05-30 18:09:59.202897+08	MjOBtljIlfWuirBD7sTlS4sxTGvAh944sSFmEy5yectNT5aax4	2053
59	Out	2016-05-30 18:10:00.679112+08	2016-05-30 18:10:00.679112+08	NQ8GObWKlETpILIX8WVEVApPXKU8uSBItJYIu4cgI5WaRp7ZLd	2054
58	Out	2016-05-30 18:12:16.449211+08	2016-05-30 18:12:16.449211+08	nrndHLxlSsEdB8wjPsn2Z676gYvo9IRv9FaQaYC3RQhcYeMyXA	2055
54	Out	2016-05-30 18:28:12.51752+08	2016-05-30 18:28:12.51752+08	17H8Dxh9mpREmaUM15uD8MdpyDULB2VC8mLLk2UXsvleWG2WKv	2056
61	Out	2016-05-30 19:00:36.751251+08	2016-05-30 19:00:36.751251+08	jSINIHamclo9ywvJJgMnEFjztGFvmZrW3AuLSV85HwEGt9ZDpv	2057
57	Out	2016-05-30 19:01:40.459512+08	2016-05-30 19:01:40.459512+08	24Bl452J1ossLv3GGVlOa3LoJGxsTnoUrzGv5IE577xS31iJWU	2058
29	Out	2016-05-30 19:05:17.711724+08	2016-05-30 19:05:17.711724+08	h8X3vqJtjmhYHZYXVcpjiwrgQth9DFdvMCyJ2IDl5uKMUru1Vk	2059
23	In	2016-05-31 07:48:47.651776+08	2016-05-31 07:48:47.651776+08	kEhbt8WcHjqvfE8eWAwjv2eGO98JAd4urlWlt3OCmF8STF70P5	2060
55	In	2016-05-31 07:49:10.977438+08	2016-05-31 07:49:10.977438+08	jL7ObVYkoiOsdGeA2ZDPl1fsT98a9YfttmIVIqG7ZezDteNvEb	2061
62	In	2016-05-31 07:50:14.704807+08	2016-05-31 07:50:14.704807+08	Lyb1s5A1fJZLDT7VyPMFWvsW9mBXiP84Pj5HoEIUXrpkLwGKMc	2062
61	In	2016-05-31 07:54:27.845099+08	2016-05-31 07:54:27.845099+08	ZsYSQiFbFx1O2Q87hwL0RtsHeEEtYaW7U5ZunoV3nWRpwZweWI	2063
51	In	2016-05-31 07:54:38.525679+08	2016-05-31 07:54:38.525679+08	eyCXGpkUkJ5HRZM1UApzEdWfTTFP8lhnktK1j6UUPZlqA8qdJh	2064
12	In	2016-05-31 07:55:03.195894+08	2016-05-31 07:55:03.195894+08	dWLBCneREmEvaypuzZ1U4Q4pGEx8rHpVoAf1yKSD8g9hfydfYe	2065
54	In	2016-05-31 08:23:06.935292+08	2016-05-31 08:23:06.935292+08	Ad5ETLSSTJjJoXTVYSp1fxiogOnJ4MxDz2RTNtvqDeA3CdYl6O	2066
13	In	2016-05-31 08:32:13.206824+08	2016-05-31 08:32:13.206824+08	mlMVa3tNMxkKBkMcEjW9aknkn1OLlUkYG74qAxEWvyp7jCkwvH	2067
31	In	2016-05-31 08:40:54.655312+08	2016-05-31 08:40:54.655312+08	6X2uIovgBhCvHS2LJCJYiFXYMGk7DgOJEPEWFAEQrQL9sOUCan	2068
28	In	2016-05-31 08:44:17.662772+08	2016-05-31 08:44:17.662772+08	kI3HqPXbWkIt5WKJ4ZTHyLhLUaixmJlXbooSEM4k8NeDtyWxXz	2069
70	In	2016-05-31 08:52:35.011871+08	2016-05-31 08:52:35.011871+08	FXLxrpYbnLuZsWOgyc44MBQ1OL0uJYtY6FWx54ZsPTSIzryyU3	2070
53	In	2016-05-31 08:56:33.986639+08	2016-05-31 08:56:33.986639+08	3qETscosX8RRgWgCUlH4fgX8xXzwWTzZKE3Dqr6OzWpf3WsYJ9	2071
17	In	2016-05-31 08:56:39.559691+08	2016-05-31 08:56:39.559691+08	bxpA6ng6kEZknuyq8piEEik3OnZHMsQxqG8w4o4o3dZqYYggOP	2072
56	In	2016-05-31 08:59:47.138641+08	2016-05-31 08:59:47.138641+08	tb8efVTFmp8DnySvwWk0LndueCSLsqknTsS8OvOBkWOYVqUSNG	2073
29	In	2016-05-31 09:32:43.23124+08	2016-05-31 09:32:43.23124+08	Ti47diK64Dwo1QhTY6OwHATfiyWDStTucX2GGMMKZJ9ajq3IwS	2074
47	In	2016-05-31 09:46:24.381355+08	2016-05-31 09:46:24.381355+08	FEbitKiQXAK16wY8DnUZ84sHdc9hu69AKlsE6bedlxervDz91T	2075
57	In	2016-05-31 09:55:19.04092+08	2016-05-31 09:55:19.04092+08	iAXaRBDas8f2I0nBEtmrXYqCQmPQuRtdbRE3cRcVZJXrJL3XEp	2076
59	In	2016-05-31 11:01:01.090691+08	2016-05-31 11:01:01.090691+08	PlPGyo3OFxp9bRapTDI7irPGjibnGpdfc2vbryz7wpGYHqOk4g	2077
55	Out	2016-05-31 12:05:40.952747+08	2016-05-31 12:05:40.952747+08	qmYH3Ize6FUjv7lridqiknY1MorlZvSRi1hmJhRPwv9s3uklYb	2078
27	In	2016-05-31 12:48:15.416139+08	2016-05-31 12:48:15.416139+08	UJP2KlrCXR8yrqzZdJH5iF1q84lsqKTKdsNxeEABfIAX9A8mTP	2079
13	Out	2016-05-31 14:00:17.788556+08	2016-05-31 14:00:17.788556+08	rCes3mwoem998n1UlfjvqOE2wNC4AfT2r8uuuqkZethmhjHTP1	2080
62	Out	2016-05-31 15:02:20.854233+08	2016-05-31 15:02:20.854233+08	PGPdIL1UPBAsD318xvyiVdcDQKwgmMhCc7puSqPs2ZlFbnNZiM	2081
12	Out	2016-05-31 15:12:53.520393+08	2016-05-31 15:12:53.520393+08	IE0uRQEO71joDMv3HPsfIuF4ArqXRaujoueGLseSuOI8kEB2d4	2082
47	Out	2016-05-31 15:43:00.798281+08	2016-05-31 15:43:00.798281+08	hvywzAoqhGRc0GXeVsYAMSYdaJslLWp3Rp0RzoIh5jK6zrkVkJ	2083
61	Out	2016-05-31 17:00:25.094595+08	2016-05-31 17:00:25.094595+08	f7lDkNWd9rAyubou3ojLWo5qu5ifaTyFalSL9yzIq9Hll7fovP	2084
17	Out	2016-05-31 17:00:28.493053+08	2016-05-31 17:00:28.493053+08	ARFGIAL1pvVpB6bdRjdR2UaJGMQvBLLLnab6kw8arcQ3i2gAlK	2085
23	Out	2016-05-31 17:05:23.548892+08	2016-05-31 17:05:23.548892+08	bnoC75YX1jtM5gwgnhduJVYjYHlFRXZ3LPGTTo1UYuqcboJPWw	2086
53	Out	2016-05-31 18:00:15.396204+08	2016-05-31 18:00:15.396204+08	KpSsY09KGarpeDFtgiigDHb5tDtDcQAwFboocy9sZ1iEEx8tgq	2087
27	Out	2016-05-31 18:00:18.847533+08	2016-05-31 18:00:18.847533+08	bt8Dy2QsF2IPyY2oMdmVWNWFajDjdtaFoiSnkrgzuyPtXQit5V	2088
51	Out	2016-05-31 18:01:39.001685+08	2016-05-31 18:01:39.001685+08	PbsvqTf4DJxnYmV1aGtHGnGfhn6QhBw7mp3dJihW2gKbTqc47V	2089
70	Out	2016-05-31 18:02:52.609867+08	2016-05-31 18:02:52.609867+08	KMKb22P8T7JPE5FHjZzR628QdbGGfNl0j6bl80tb7C1LIGc2pc	2090
31	Out	2016-05-31 18:08:05.726908+08	2016-05-31 18:08:05.726908+08	TvebMIDcXrzJrjPTVYTP9acBvuRXvHAPDo1Y6DBe5BxwvNQRvt	2091
28	Out	2016-05-31 18:17:25.672604+08	2016-05-31 18:17:25.672604+08	q5USGQNhxJy8iBwjk3wvh28fy33QUyKL4nnKEB2CU1KDCHwwKt	2092
59	Out	2016-05-31 18:34:48.833429+08	2016-05-31 18:34:48.833429+08	s2v1hu4kLYjesoTg9hrAtNBEaNVXKpRDrNEZIHKdp4IislQ2TI	2093
59	Out	2016-05-31 18:34:52.465273+08	2016-05-31 18:34:52.465273+08	CNfNbGk7n5xFIpcWPuojYeoqNhdnj76vUkJ615EoAB4S1gzQbo	2094
57	Out	2016-05-31 19:01:12.92228+08	2016-05-31 19:01:12.92228+08	BASz1phedQljMGUgMVkaKulOOm5NEfCOpeOqU6V8WHrsXMZurK	2095
29	Out	2016-05-31 19:03:34.23821+08	2016-05-31 19:03:34.23821+08	VCFHad4f1ILDgCr53NAYVgpNaOjAIbUnnj5PN95OQQb7cTCfqM	2096
54	Out	2016-05-31 19:07:15.158489+08	2016-05-31 19:07:15.158489+08	EM44jdSTnk5IYs3dIPmNoDnQKQtW6jsK6vOpaqJObOhAHjnZAZ	2097
17	In	2016-06-01 07:50:41.115791+08	2016-06-01 07:50:41.115791+08	wxmlO7CHdI2Wc8S1x3rGRSe9cvsQV3zS1mDPtPgXhi4KqWLoZD	2098
12	In	2016-06-01 07:50:49.616407+08	2016-06-01 07:50:49.616407+08	51fjAIe3iA6ic6VpVPGCwxu1JlXeZ7re8XOIp3LYDQHpXmf3Cv	2099
62	In	2016-06-01 07:52:37.44522+08	2016-06-01 07:52:37.44522+08	FAtABDuhqVoiAwGXE6aZen0vdXhJauFo49yFLuwDPlvZiC7wIi	2100
23	In	2016-06-01 07:53:43.283389+08	2016-06-01 07:53:43.283389+08	WvWWr93ZSdUhSYqRnCMkPlWLLFXTCpBhlhEdqHEJui1NHrp54B	2101
77	In	2016-06-01 08:05:35.968403+08	2016-06-01 08:05:35.968403+08	pTxNoJcMlnBwWwekbV2oowXpKohAtlLjEJ73biONXaL3X0n9Vp	2102
61	In	2016-06-01 08:17:13.814689+08	2016-06-01 08:17:13.814689+08	xLmVB7KsHEecxsu5vWnLuLuGPTGDbl3Z7o5IvQCDeqpcjkhfHV	2103
13	In	2016-06-01 08:18:56.641176+08	2016-06-01 08:18:56.641176+08	1CqvSGPiT1UVabLgtH66UkvKNf45LMaMYSI1ihiBhDhJp2yjK6	2104
58	In	2016-06-01 08:22:10.25149+08	2016-06-01 08:22:10.25149+08	popl8DRDInYsA7LS749qFr4wAtyAdJFS86FGJgSbU2Ue8p6GtG	2105
59	In	2016-06-01 08:27:49.527003+08	2016-06-01 08:27:49.527003+08	798B6I56ShPhBWmPm66FhaHDFP3Lfwbm7iwD12JTjhBuExK15Q	2106
70	In	2016-06-01 08:55:34.782531+08	2016-06-01 08:55:34.782531+08	Gm1XzGw3bc0DO7wMKxOcR8Lc3ZaNafnqSoOS6LVhxWvMcsiwq7	2107
56	Out	2016-06-01 08:58:11.180257+08	2016-06-01 08:58:11.180257+08	aIFuuHUVe5BSvdHK6Ngb5d811ksiijpI25EwMiS1ndTjHk5N8k	2108
56	In	2016-06-01 08:58:39.079343+08	2016-06-01 08:58:39.079343+08	zEP8EPs89brytt38qPpJQdwtOFfScnEc1ckG2dOBEGA8ADG1d6	2109
61	Out	2016-06-01 09:02:47.863037+08	2016-06-01 09:02:47.863037+08	L4jIx8XdaARomSRWiTA7eONoWX2mYfrtjcChjiLLsm9fFaCx4M	2110
54	In	2016-06-01 09:12:43.653604+08	2016-06-01 09:12:43.653604+08	5ikRXHyZ4YFvRyYdgIN2dGnmv3N81RU6BFXiWXIa5XWXV4BCMY	2111
29	In	2016-06-01 09:42:57.997509+08	2016-06-01 09:42:57.997509+08	E0n2mj6Ar7bMDmbkU8ImiNKFupJ62feGfSJSCOc4VEQi12TVBl	2112
31	In	2016-06-01 09:43:07.079687+08	2016-06-01 09:43:07.079687+08	It9c94SSAV8olnH5HTTtXy8xh90BeBwx56aEA3fKYn9KcPPtss	2113
47	In	2016-06-01 10:04:53.904409+08	2016-06-01 10:04:53.904409+08	mQrvNZ5OkjZhhenIsxLYItNRFyqesjXf9PbXygukQUS89GP1Ek	2114
27	In	2016-06-01 10:41:10.815518+08	2016-06-01 10:41:10.815518+08	ZWfwwtvnYoX6VhV7EUnAFDehLmxkoBVOhBLe5HTd71jchFiwjW	2115
28	In	2016-06-01 11:44:20.584373+08	2016-06-01 11:44:20.584373+08	6yjkg5XdqMpMkXX6DcOfGUgy7PEqMxNSw7DdCkH377PrevxqYL	2116
47	Out	2016-06-01 13:06:25.161388+08	2016-06-01 13:06:25.161388+08	XoqEnxd2nyzBRvIeZUOqXVxwNcsKTRg1GWF4Us6Jr5TJ1lwaHM	2117
12	Out	2016-06-01 13:38:09.015733+08	2016-06-01 13:38:09.015733+08	RorPlE1fZU7FVNmkRHcXZUc4ndplF77gvy6hE7NmcV38sosK6V	2118
59	Out	2016-06-01 15:56:53.296467+08	2016-06-01 15:56:53.296467+08	rg0Uko8aZNhg4dg9MtGjhsEj17ZsRfPJLPn6DvgnJOUN2BWO5n	2119
58	Out	2016-06-01 16:00:09.978373+08	2016-06-01 16:00:09.978373+08	8mgMWgU5avkyF7O3DbztPJHtgK5DhA1pvgCSOgYxcJwrPLvcxu	2120
17	Out	2016-06-01 17:00:31.343577+08	2016-06-01 17:00:31.343577+08	WMFnGv8L9pVAfRqstFZSDClA4BVznTuKpA875GSE6wOlOFeJUD	2121
23	Out	2016-06-01 17:01:21.02159+08	2016-06-01 17:01:21.02159+08	lhPXrTiNTWqOqgYyneEFsKCH6bWku1xfhNDZrvxLRnjIVJHIwV	2122
70	Out	2016-06-01 18:01:25.167626+08	2016-06-01 18:01:25.167626+08	Xppk7vLdgGdevM29vt5tEWhyoDH6VFb35RnCN9o4PTiMpkVlda	2123
62	Out	2016-06-01 18:02:46.474195+08	2016-06-01 18:02:46.474195+08	fs7Nqva936NeAS6xeU7TYWwGsl1OXeyDX6bO2CX5IujSNpP2JW	2124
13	Out	2016-06-01 18:05:16.92328+08	2016-06-01 18:05:16.92328+08	Vr4S8wE9LlnJzLPajRmHV5CFXZ5wbOT7GXYOUmXoZL9YgXAQyw	2125
56	Out	2016-06-01 18:06:23.797204+08	2016-06-01 18:06:23.797204+08	hU2tjYToV4DzBTWjs1WQp6lyeSWosVla0mUkMwZr1mrCGOv9PS	2126
77	Out	2016-06-01 18:15:38.024314+08	2016-06-01 18:15:38.024314+08	ZGYLFEol3hHoIHbm2xjbpkNgwe6snVMMkuiz9WlCE30WKbJMZ2	2127
31	Out	2016-06-01 19:00:26.364559+08	2016-06-01 19:00:26.364559+08	xPmL7j0CdnhyAStsS3PEEeHFBbqUxQWvpJIw4I9g5qfFJZ8lcX	2128
27	Out	2016-06-01 19:00:59.905524+08	2016-06-01 19:00:59.905524+08	0qCH6NswqqNNmEh4AkMJSRA8hTipFLNFCZWIwPFnGdC3qs71eT	2129
29	Out	2016-06-01 19:03:38.359004+08	2016-06-01 19:03:38.359004+08	K6vUFcxwSDIqSUQymNO3CefNgWHoXuIs2DNGpLEJYWA11a1nxP	2130
54	Out	2016-06-01 19:03:59.406136+08	2016-06-01 19:03:59.406136+08	qA4WXl3oZajrTl5q3uCGElmOmnynbwDS7Hxe31TccEU60Zw3UA	2131
28	Out	2016-06-01 19:08:59.523503+08	2016-06-01 19:08:59.523503+08	Jju68ht6VV3ixA1vp3wJgZXAfXjcZFmtxhz6PtCuPFeMQeIFiG	2132
77	In	2016-06-02 08:03:42.138167+08	2016-06-02 08:03:42.138167+08	YOp5ZVcJ8CYu6Wc6b3znxP3clTH4izKHOAMxfyHoCpjILNOwPN	2133
61	In	2016-06-02 08:04:11.411809+08	2016-06-02 08:04:11.411809+08	kOmo1YHIc0IxHg8dendvcpkN86jV4AtoXgdYFuqrv8oDowqTlU	2134
17	In	2016-06-02 08:04:13.421313+08	2016-06-02 08:04:13.421313+08	POKAlRHVxKfq9DXmlmhbddjTpYQh2CBRaVbMwsruDXlNjJAV6r	2135
23	In	2016-06-02 08:05:01.201261+08	2016-06-02 08:05:01.201261+08	7jVrDLQe3SqEtRjWnhPfccDOzwh9Sn1ZYWRlrrQuKH9EiskXZA	2136
12	In	2016-06-02 08:05:47.659156+08	2016-06-02 08:05:47.659156+08	DCmQalNIvp6wQeTrQLiqG47PIpI3NrDa4y1ekOwgE3ddh7V7SE	2137
62	In	2016-06-02 08:19:52.398887+08	2016-06-02 08:19:52.398887+08	xiI58avQdJIpsMpt0aIwHV0uAh2foVtmECrMmnlQ64GzQ6tQgB	2138
13	In	2016-06-02 08:38:12.267815+08	2016-06-02 08:38:12.267815+08	NxhNsq5uWtPQgddY0QMmqSq7SGDLgsX5qESi6XdcR338hggh73	2139
58	In	2016-06-02 08:38:48.13566+08	2016-06-02 08:38:48.13566+08	UwVL4wbGJJApN14pjANNmoQpw8WdpcfKaBfd8HuRa5Hx5MooWC	2140
55	In	2016-06-02 08:39:24.613137+08	2016-06-02 08:39:24.613137+08	CI0c8wleabIGvrRcWZtR1UVJTaeHPBTbTTFcQ0H1bZHYRiAwI4	2141
31	In	2016-06-02 08:44:10.195918+08	2016-06-02 08:44:10.195918+08	OJYtc2VIJuTmWwHlZhlqiOP0wqi7o1BDKj7xmcG6Wis4gApGrb	2142
47	In	2016-06-02 08:56:02.59707+08	2016-06-02 08:56:02.59707+08	6azWavNJ3CKEOfyVdk8sqebjiItXYlAeN9Bx6YH9jbN9HMeu7l	2143
29	In	2016-06-02 09:14:12.991914+08	2016-06-02 09:14:12.991914+08	nxQPi9hcgGOqul06j6e1FOccXuyCo6xc5O2mXkPE1o5vZ62JCg	2144
57	In	2016-06-02 09:15:43.28223+08	2016-06-02 09:15:43.28223+08	KR5w4cr3ogAlJEAM2h6Rv7G23q74AJkUkpRoSJrHz23JGDfIul	2145
56	In	2016-06-02 09:39:39.976385+08	2016-06-02 09:39:39.976385+08	krs1svq1z1KkU5avt4FlKFnOY4bDNWz7Or8InyInycYUh9QbDf	2146
54	In	2016-06-02 09:44:17.592952+08	2016-06-02 09:44:17.592952+08	NXtBvSFXgc4fjSYqkMp4ApgiJOrjy5PMcKXYmm5SOA88cgyN2p	2147
28	In	2016-06-02 11:08:20.078188+08	2016-06-02 11:08:20.078188+08	RCe7uyVliUq8qTSO1FA7hZGphsWgGYWhkBpfALRspI1glT5miG	2148
84	In	2016-06-02 12:20:17.143401+08	2016-06-02 12:20:17.143401+08	tPoAGW4mDKLi27trm4DEv3WwjIQp695zYtAoQDbdXwMa4GSpKe	2149
28	Out	2016-07-07 13:22:24.177143+08	2016-07-07 13:22:24.177143+08	4GhbDSteHynMyMH9BhMmKtjgUnwvdHbhXJJklCP3CDQAZgJkOf	2150
28	In	2016-07-27 00:05:55.239821+08	2016-07-27 00:05:55.239821+08	XiZHP44N1hebPCviwhuMk7ZBH8sasGGQzphPtlmuTQXscSbZAX	2151
28	Out	2016-07-27 00:10:17.877287+08	2016-07-27 00:10:17.877287+08	uvdU7vcyWVGmvFddeXPRSsrzmUSO4cuyYZTfV6e2buoXASBoza	2152
28	In	2016-07-27 00:10:36.32215+08	2016-07-27 00:10:36.32215+08	HST9SGduegXZf699leFPgrKUPUwaJwCaOfjqvMla4JAjPKsAy9	2153
28	Out	2016-07-27 00:10:45.366469+08	2016-07-27 00:10:45.366469+08	Ze0tAPO61i3DISs2JoP4PSNZDlt6vsFWXFQgfpngXqsqIlsbZH	2154
12	Out	2016-08-31 13:47:32.036818+08	2016-08-31 13:47:32.036818+08	DCmQalNIvp6wQeTrQLiqG47PIpI3NrDa4y1ekOwgE3ddh7V7SE	2197
12	In	2016-08-31 07:59:25.023207+08	2016-08-31 07:59:25.023207+08	gExxsYMDqUTwJeDWOBdQwFFIuFhetQOKskgVh1xHVodDDSxqrK	2198
12	Out	2016-08-31 20:16:06.415078+08	2016-08-31 20:16:06.415078+08	undefined	2199
12	In	2016-08-31 07:30:03.045071+08	2016-08-31 07:30:03.045071+08	jBDsvdzgYSQl6jkw5MpjBvsV2112cjewWSZp4xG1numuOG-Tso	2200
12	Out	2016-08-31 21:30:41.111782+08	2016-08-31 21:30:41.111782+08	undefined	2201
12	In	2016-08-31 07:31:41.61245+08	2016-08-31 07:31:41.61245+08	4-CjFXZuza7xpbZaXllUU4EZLbwjLkcQkP8_J6sigAQFMORH7a	2202
12	Out	2016-08-31 03:34:56.311126+08	2016-08-31 03:34:56.311126+08	undefined	2203
12	In	2016-08-31 07:30:02.436371+08	2016-08-31 07:30:02.436371+08	uBqCWCvyygq4sx-uBFr-VhrrBkTpW9IoL70GKweiMEmdbmHO08	2204
12	In	2016-08-31 07:30:14.874558+08	2016-08-31 07:30:14.874558+08	9fgBejzajVLoLWXFDOcm_9-klW2j4ROd42QimosGhd317-HLMU	2205
12	In	2016-09-01 07:31:00.660223+08	2016-09-01 07:31:00.660223+08	HxqEzH4QaG25q2M8lehDqCSAXYXP-1PGzdk7WpY44_9u0XDmaV	2206
12	Out	2016-09-01 21:34:57.237122+08	2016-09-01 21:34:57.237122+08	HxqEzH4QaG25q2M8lehDqCSAXYXP-1PGzdk7WpY44_9u0XDmaV	2207
12	In	2016-09-02 07:13:48.984502+08	2016-09-02 07:13:48.984502+08	74dtByt7oD_8f4CU13mEYoEEQFth9YWg07KCGdJ3RIb5OOZPSk	2208
12	Out	2016-09-02 21:13:57.285993+08	2016-09-02 21:13:57.285993+08	74dtByt7oD_8f4CU13mEYoEEQFth9YWg07KCGdJ3RIb5OOZPSk	2209
12	In	2016-09-03 07:18:46.908011+08	2016-09-03 07:18:46.908011+08	C1ieOxMVbW3GmOKTKuTpQnRCm-JLELlgODvzahtlcw1yiMp2fg	2210
12	Out	2016-09-03 19:19:11.570979+08	2016-09-03 19:19:11.570979+08	C1ieOxMVbW3GmOKTKuTpQnRCm-JLELlgODvzahtlcw1yiMp2fg	2211
12	In	2016-09-04 07:15:01.375539+08	2016-09-04 07:15:01.375539+08	yPKJ9ULim5oyvr6wDa3rizVCluTX3rACekkoc4Gz947Ewda9oe	2212
12	Out	2016-09-04 19:15:06.181622+08	2016-09-04 19:15:06.181622+08	yPKJ9ULim5oyvr6wDa3rizVCluTX3rACekkoc4Gz947Ewda9oe	2213
12	In	2016-09-05 07:15:25.423559+08	2016-09-05 07:15:25.423559+08	wZc29r7x-LBHAv-wDa3JW25nFi26n0bU_oX7R2EQOfvnKvUmFY	2214
12	Out	2016-09-05 21:15:34.376834+08	2016-09-05 21:15:34.376834+08	wZc29r7x-LBHAv-wDa3JW25nFi26n0bU_oX7R2EQOfvnKvUmFY	2215
12	In	2016-09-06 07:59:13.092788+08	2016-09-06 07:59:13.092788+08	a5HEmIR1QWaXn4RLMdmCi1fT-GX4s0xC5efrX5tL0EHnIw8uKu	2216
12	Out	2016-09-06 21:59:18.882502+08	2016-09-06 21:59:18.882502+08	a5HEmIR1QWaXn4RLMdmCi1fT-GX4s0xC5efrX5tL0EHnIw8uKu	2217
12	In	2016-09-09 07:08:15.098007+08	2016-09-09 07:08:15.098007+08	cGCFawguMMfQfzZW-wDn5HOru2bX4rWh6xXh2bLQZ-DdzB8y6M	2218
12	Out	2016-09-09 21:08:43.632579+08	2016-09-09 21:08:43.632579+08	cGCFawguMMfQfzZW-wDn5HOru2bX4rWh6xXh2bLQZ-DdzB8y6M	2219
28	Out	2016-09-13 10:22:45.947751+08	2016-09-13 10:22:45.947751+08	1k2etzoK1DQCVzLCPUkWtYAiRSHib3tdovrS3RB4tqHm_r_Oki	2220
12	In	2016-09-19 15:02:03.597016+08	2016-09-19 15:02:03.597016+08	e4Dx9hZwlP_E6ubFiuXP7fW8vEurJPMZUpu1Gsy0fwFl0R0jkY	2221
12	Out	2016-09-19 15:13:12.427282+08	2016-09-19 15:13:12.427282+08	e4Dx9hZwlP_E6ubFiuXP7fW8vEurJPMZUpu1Gsy0fwFl0R0jkY	2222
12	In	2016-09-22 09:25:51.211754+08	2016-09-22 09:25:51.211754+08	Om644mQlrEAdnM_dTpkl4osrmonXAp6nLcsRzga0WLdhxbvpBQ	2223
\.


--
-- Data for Name: time_log_new; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY time_log_new (pk, employees_pk, time_in, time_out, date_created) FROM stdin;
\.


--
-- Name: time_log_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('time_log_pk_seq', 1, false);


--
-- Name: time_log_pk_seq1; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('time_log_pk_seq1', 2223, true);


--
-- Data for Name: titles; Type: TABLE DATA; Schema: public; Owner: chrs
--

COPY titles (pk, title, created_by, date_created, archived) FROM stdin;
1	Owner & Managing Director	28	2016-04-01 10:47:22.39449+08	f
2	Accounting Consultant	28	2016-04-01 10:47:22.39449+08	f
3	Accounting Supervisor	28	2016-04-01 10:47:22.39449+08	f
4	Assistant HR Manager	28	2016-04-01 10:47:22.39449+08	f
5	Assistant Recruitment & Client Specialist	28	2016-04-01 10:47:22.39449+08	f
6	Business Development Associate	28	2016-04-01 10:47:22.39449+08	f
7	Cashier/Skin Care Advisor	28	2016-04-01 10:47:22.39449+08	f
8	Client & Recruitment Supervisor	28	2016-04-01 10:47:22.39449+08	f
9	Client & Recruitment Manager	28	2016-04-01 10:47:22.39449+08	f
10	Clinic Consultant	28	2016-04-01 10:47:22.39449+08	f
11	Corporate Quality Supervisor	28	2016-04-01 10:47:22.39449+08	f
13	HR Associate Intern	28	2016-04-01 10:47:22.39449+08	f
14	IT Associate	28	2016-04-01 10:47:22.39449+08	f
15	IT Project Manager	28	2016-04-01 10:47:22.39449+08	f
16	Liaison Associate	28	2016-04-01 10:47:22.39449+08	f
17	Talent Acquisition Associate	28	2016-04-01 10:47:22.39449+08	f
18	HR & Admin Associate	28	2016-04-01 10:47:22.39449+08	f
19	Assistant Client & Recruitment Manager	28	2016-04-01 11:25:10.42375+08	f
20	Business Development Officer	28	2016-04-01 11:26:08.856986+08	f
21	Programmer Trainee	28	2016-04-12 16:06:27.615282+08	f
22	Office Support Intern	28	2016-04-25 16:39:08.265271+08	f
23	Business Development Trainee	28	2016-04-25 16:47:25.875086+08	f
24	Corporate Quality Trainee	28	2016-04-25 16:51:50.051687+08	f
12	Human Resource Associate	28	2016-04-01 10:47:22.39449+08	f
\.


--
-- Name: titles_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: chrs
--

SELECT pg_catalog.setval('titles_pk_seq', 24, true);


--
-- Name: allowances_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY allowances
    ADD CONSTRAINT allowances_pkey PRIMARY KEY (pk);


--
-- Name: attritions_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY attritions
    ADD CONSTRAINT attritions_pkey PRIMARY KEY (pk);


--
-- Name: calendar_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY calendar
    ADD CONSTRAINT calendar_pkey PRIMARY KEY (pk);


--
-- Name: civil_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY civil_statuses
    ADD CONSTRAINT civil_statuses_pkey PRIMARY KEY (pk);


--
-- Name: cutoff_types_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY cutoff_types
    ADD CONSTRAINT cutoff_types_pkey PRIMARY KEY (pk);


--
-- Name: daily_pass_slip_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY daily_pass_slip
    ADD CONSTRAINT daily_pass_slip_pkey PRIMARY KEY (pk);


--
-- Name: default_values_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY default_values
    ADD CONSTRAINT default_values_pkey PRIMARY KEY (pk);


--
-- Name: departments_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (pk);


--
-- Name: employee_types_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY employee_types
    ADD CONSTRAINT employee_types_pkey PRIMARY KEY (pk);


--
-- Name: employees_backup_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY employees_backup
    ADD CONSTRAINT employees_backup_pkey PRIMARY KEY (pk);


--
-- Name: employees_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (pk);


--
-- Name: employment_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY employment_statuses
    ADD CONSTRAINT employment_statuses_pkey PRIMARY KEY (pk);


--
-- Name: feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (pk);


--
-- Name: gender_type_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY gender_type
    ADD CONSTRAINT gender_type_pkey PRIMARY KEY (pk);


--
-- Name: holidays_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY holidays
    ADD CONSTRAINT holidays_pkey PRIMARY KEY (pk);


--
-- Name: leave_filed_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY leave_filed
    ADD CONSTRAINT leave_filed_pkey PRIMARY KEY (pk);


--
-- Name: leave_types_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY leave_types
    ADD CONSTRAINT leave_types_pkey PRIMARY KEY (pk);


--
-- Name: levels_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY levels
    ADD CONSTRAINT levels_pkey PRIMARY KEY (pk);


--
-- Name: manual_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY manual_logs
    ADD CONSTRAINT manual_logs_pkey PRIMARY KEY (pk);


--
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (pk);


--
-- Name: overtime_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY overtime
    ADD CONSTRAINT overtime_pkey PRIMARY KEY (pk);


--
-- Name: payroll_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY payroll
    ADD CONSTRAINT payroll_pkey PRIMARY KEY (pk);


--
-- Name: salary_types_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY salary_types
    ADD CONSTRAINT salary_types_pkey PRIMARY KEY (pk);


--
-- Name: suspension_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY suspension
    ADD CONSTRAINT suspension_pkey PRIMARY KEY (pk);


--
-- Name: time_log_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY time_log_new
    ADD CONSTRAINT time_log_pkey PRIMARY KEY (pk);


--
-- Name: time_log_pkey1; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY time_log
    ADD CONSTRAINT time_log_pkey1 PRIMARY KEY (pk);


--
-- Name: titles_pkey; Type: CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY titles
    ADD CONSTRAINT titles_pkey PRIMARY KEY (pk);


--
-- Name: code_unique_idx; Type: INDEX; Schema: public; Owner: chrs
--

CREATE UNIQUE INDEX code_unique_idx ON departments USING btree (code);


--
-- Name: department_unique_idx; Type: INDEX; Schema: public; Owner: chrs
--

CREATE UNIQUE INDEX department_unique_idx ON departments USING btree (department);


--
-- Name: employee_id_idx; Type: INDEX; Schema: public; Owner: chrs
--

CREATE INDEX employee_id_idx ON employees USING btree (employee_id);


--
-- Name: employee_id_unique_idx; Type: INDEX; Schema: public; Owner: chrs
--

CREATE UNIQUE INDEX employee_id_unique_idx ON employees USING btree (employee_id);


--
-- Name: employees_permissions_idx; Type: INDEX; Schema: public; Owner: chrs
--

CREATE UNIQUE INDEX employees_permissions_idx ON employees_permissions USING btree (employees_pk);


--
-- Name: first_name_idx; Type: INDEX; Schema: public; Owner: chrs
--

CREATE INDEX first_name_idx ON employees USING btree (first_name);


--
-- Name: groupings_unique_idx; Type: INDEX; Schema: public; Owner: chrs
--

CREATE UNIQUE INDEX groupings_unique_idx ON groupings USING btree (employees_pk, supervisor_pk);


--
-- Name: last_name_idx; Type: INDEX; Schema: public; Owner: chrs
--

CREATE INDEX last_name_idx ON employees USING btree (last_name);


--
-- Name: middle_name_idx; Type: INDEX; Schema: public; Owner: chrs
--

CREATE INDEX middle_name_idx ON employees USING btree (middle_name);


--
-- Name: attritions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY attritions
    ADD CONSTRAINT attritions_created_by_fkey FOREIGN KEY (created_by) REFERENCES employees(pk);


--
-- Name: attritions_employees_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY attritions
    ADD CONSTRAINT attritions_employees_pk_fkey FOREIGN KEY (employees_pk) REFERENCES employees(pk);


--
-- Name: calendar_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY calendar
    ADD CONSTRAINT calendar_created_by_fkey FOREIGN KEY (created_by) REFERENCES employees(pk);


--
-- Name: cutoff_dates_cutoff_types_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY cutoff_dates
    ADD CONSTRAINT cutoff_dates_cutoff_types_pk_fkey FOREIGN KEY (cutoff_types_pk) REFERENCES cutoff_types(pk);


--
-- Name: daily_pass_slip_employees_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY daily_pass_slip
    ADD CONSTRAINT daily_pass_slip_employees_pk_fkey FOREIGN KEY (employees_pk) REFERENCES employees(pk);


--
-- Name: daily_pass_slip_status_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY daily_pass_slip_status
    ADD CONSTRAINT daily_pass_slip_status_created_by_fkey FOREIGN KEY (created_by) REFERENCES employees(pk);


--
-- Name: daily_pass_slip_status_daily_pass_slip_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY daily_pass_slip_status
    ADD CONSTRAINT daily_pass_slip_status_daily_pass_slip_pk_fkey FOREIGN KEY (daily_pass_slip_pk) REFERENCES daily_pass_slip(pk);


--
-- Name: default_values_logs_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY default_values_logs
    ADD CONSTRAINT default_values_logs_created_by_fkey FOREIGN KEY (created_by) REFERENCES employees(pk);


--
-- Name: default_values_logs_default_values_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY default_values_logs
    ADD CONSTRAINT default_values_logs_default_values_pk_fkey FOREIGN KEY (default_values_pk) REFERENCES default_values(pk);


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
-- Name: employees_permissions_employees_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY employees_permissions
    ADD CONSTRAINT employees_permissions_employees_pk_fkey FOREIGN KEY (employees_pk) REFERENCES employees(pk);


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
-- Name: holidays_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY holidays
    ADD CONSTRAINT holidays_created_by_fkey FOREIGN KEY (created_by) REFERENCES employees(pk);


--
-- Name: leave_filed_employees_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY leave_filed
    ADD CONSTRAINT leave_filed_employees_pk_fkey FOREIGN KEY (employees_pk) REFERENCES employees(pk);


--
-- Name: leave_filed_leave_types_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY leave_filed
    ADD CONSTRAINT leave_filed_leave_types_pk_fkey FOREIGN KEY (leave_types_pk) REFERENCES leave_types(pk);


--
-- Name: leave_status_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY leave_status
    ADD CONSTRAINT leave_status_created_by_fkey FOREIGN KEY (created_by) REFERENCES employees(pk);


--
-- Name: leave_status_leave_filed_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY leave_status
    ADD CONSTRAINT leave_status_leave_filed_pk_fkey FOREIGN KEY (leave_filed_pk) REFERENCES leave_filed(pk);


--
-- Name: manual_logs_employees_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY manual_logs
    ADD CONSTRAINT manual_logs_employees_pk_fkey FOREIGN KEY (employees_pk) REFERENCES employees(pk);


--
-- Name: manual_logs_status_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY manual_logs_status
    ADD CONSTRAINT manual_logs_status_created_by_fkey FOREIGN KEY (created_by) REFERENCES employees(pk);


--
-- Name: notifications_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_created_by_fkey FOREIGN KEY (created_by) REFERENCES employees(pk);


--
-- Name: notifications_employees_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_employees_pk_fkey FOREIGN KEY (employees_pk) REFERENCES employees(pk);


--
-- Name: overtime_employees_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY overtime
    ADD CONSTRAINT overtime_employees_pk_fkey FOREIGN KEY (employees_pk) REFERENCES employees(pk);


--
-- Name: overtime_status_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY overtime_status
    ADD CONSTRAINT overtime_status_created_by_fkey FOREIGN KEY (created_by) REFERENCES employees(pk);


--
-- Name: overtime_status_overtime_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY overtime_status
    ADD CONSTRAINT overtime_status_overtime_pk_fkey FOREIGN KEY (overtime_pk) REFERENCES overtime(pk);


--
-- Name: suspension_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY suspension
    ADD CONSTRAINT suspension_created_by_fkey FOREIGN KEY (created_by) REFERENCES employees(pk);


--
-- Name: time_log_employees_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrs
--

ALTER TABLE ONLY time_log_new
    ADD CONSTRAINT time_log_employees_pk_fkey FOREIGN KEY (employees_pk) REFERENCES employees(pk);


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

