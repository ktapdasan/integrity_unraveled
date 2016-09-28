create table default_values(
	pk serial primary key,
	name text not null,
	details jsonb not null,
	archived boolean default false
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
		"staggered" : "Staggered monthly",
		"carry_over": "5",
		"leave_per_month": {"1": "1", "3": "1"},
		"max_increase": {"status": "true", "details": {"1": "1"}, "run_upon": "regularization"}
	}'::jsonb
);

alter table leave_types add column details jsonb not null;

update leave_types set details = '{
		"regularization" : 180,
		"staggered" : "Staggered monthly"
	}'::jsonb;

insert into default_values
(
	name,
	details
)
values
(
	'work_days',
	'{

			"sunday" : false,
			"monday" : true,
			"tuesday" : true,
			"wednesday" : true,
			"thursday" : true,
			"friday" : true,
			"saturday" : false

}'::jsonb
);


insert into default_values
 (
 name,
 details
 )
 values
 (
 'cutoff_dates',
 '{
 			"first":
 			{
 			"from":"1","to":"15"
 			},
 			"second":
 			{
 			"from":"16","to":"31"
 			},
 			"cutoff_types_pk":
 			"2"}'::jsonb
 );

 insert into default_values
 (
 name,
 details
 )
 values
 (
 'working_hours',
 '{
 			"hrs": "16"

			} '::jsonb
 );

  insert into default_values
 (
 name,
 details
 )
 values
 (
 'birthday_leave',
 '{"status": "false","count": "1","leave_types_pk": "1"}'::jsonb
 );

 insert into default_values
 (
 name,
 details
 )
 values
 (
 'overtime_leave',
 '{"leave_types_pk": "16"} '::jsonb
 );