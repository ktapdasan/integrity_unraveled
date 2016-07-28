-- alter table time_log rename to time_log_bck;

-- create table time_log (
-- 	pk serial primary key,
-- 	employees_pk int references employees(pk),
-- 	time_in time,
-- 	time_out time,
-- 	date_created timestamptz default now()
-- );
-- alter table time_log owner to chrs;

-- INSTEAD OF CHANGING THE WHOLE TIME_LOG TABLE
-- I ADDED A NEW COLUMN THAT WILL SAVE THE HASH

create or replace function random_string(length integer) returns text as 
$$
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
$$ language plpgsql;
alter function random_string(length integer) owner to chrs;

alter table time_log add column random_hash text;
with Q as
(
    select
    	pk,
        employees_pk,
        (select employee_id from employees where pk = employees_pk) as employee_id,
        (select first_name ||' '|| middle_name ||' '|| last_name from employees where pk = employees_pk) as employee,
        type,
        time_log::date as log_date,
        time_log::time(0) as log_time,
        date_created,
        random_hash
    from time_log
),
R as
(
	select
	    employees_pk,
	    log_date,
	    to_char(log_date, 'Day') as log_day,
	    (
	        coalesce((select
	            min(log_time)
	        from Q where Q.employees_pk = logs.employees_pk
	        and Q.log_date = logs.log_date and Q.type = 'In')::text,'None')
	    ) as login,
	    (
	        coalesce((select
	            min(log_time)
	        from Q where Q.employees_pk = logs.employees_pk
	        and Q.log_date = logs.log_date and Q.type = 'Out')::text,'None')
	    ) as logout,
	    array_agg(pk) as pks,
	    array_agg(random_hash) as hash
	from Q as logs
	group by employees_pk, employee, employee_id, log_date, log_day
	order by logs.log_date
)
select
	array_to_string(pks, ',')
from R
;
-- update time_log set 
-- 	(
-- 		random_hash
-- 	) 
-- 	=
-- 	(
-- 		random_string(50)
-- 	)
-- 	where pk in (select unnest(pks) from R)
-- ;