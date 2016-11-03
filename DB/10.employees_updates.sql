/* How to update jsonb
update objects set body=jsonb_set(body, '{name}', '"Mary"', true) where id=1;
*/

create table employees
(
	pk serial primary key,
	details jsonb,
	leave_balances jsonb,
	date_created timestamptz default now(),
	archived boolean default false
);

alter table employees_backup owner to chrs;

-- begin;
-- alter table employees add column details jsonb;

-- update employees set details = '{
-- 	"company" : {
-- 		"levels_pk" : 3,
-- 		"hours" : 250
-- 	}
-- }'::jsonb where levels_pk = 3;
-- commit;