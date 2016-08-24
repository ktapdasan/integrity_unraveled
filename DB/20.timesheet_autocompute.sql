/*
Not yet working
*/
CREATE or replace FUNCTION fetch_timesheet(
													date_from text, 
													date_to text, 
													employees_pk int, 
													departments_pk int, 
													levels_pk int, 
													titles_pk int
												) RETURNS VOID
AS $BODY$

if employees_pk == None:
	employees = plpy.execute("select * from employees where archived = false")
else:
	employees = plpy.execute("select * from employees where pk = " + str(employees_pk))

for i in employees:
	plpy.execute("insert into payroll(first_name) values ($$"+i['first_name']+"$$);")

$BODY$
LANGUAGE plpythonu;


ALTER FUNCTION public.fetch_timesheet(date_from text, date_to text, employees_pk int, departments_pk int, levels_pk int, titles_pk int) OWNER TO chrs;


/*
create table payroll(
	pk serial primary key,
	date_created timestamptz default now(),
	first_name text
);
alter table payroll owner to chrs;
*/