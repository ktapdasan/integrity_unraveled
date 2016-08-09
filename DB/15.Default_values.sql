create table default_values(
	pk serial primary key,
	name text not null,
	details jsonb not null
);
alter table default_values owner to chrs;

create table default_values_logs (
	default_values_pk int references default_values(pk),
	log text not null,
	created_by int references employees(pk),
	date_created timestamptz default now()
);
alter table default_values_logs owner to chrs;

insert into default_values
(
	name,
	details
)
values
(
	'leave',
	'{
		"regularization" : 180,
		"staggered" : "Staggered monthly"
	}'::jsonb
);

alter table leave_types add column details jsonb not null;

update leave_types set details = '{
		"regularization" : 180,
		"staggered" : "Staggered monthly"
	}'::jsonb;