create table overtime(
	pk serial primary key,
	time_from timestamptz not null,
	time_to timestamptz not null,
	employees_pk int references employees(pk),
	date_created timestamptz default now(),
	archived boolean default false
);
alter table overtime owner to chrs;

create table overtime_status(
	overtime_pk int references overtime(pk),
	created_by int references employees(pk),
	status text default 'Pending',
	date_created timestamptz default now(),
	remarks text not null,
	archived boolean default false
);
alter table overtime_status owner to chrs;

insert into overtime
(

	pk,
	time_from,
	time_to,
	employees_pk

)
values
(
	'1',
	'2016-08-22',
	'2016-08-25',
	'12'

);

insert into overtime_status
(
	overtime_pk,
	created_by,
	status,
	date_created,
	remarks
)
values
(
	'1',
	'12',
	'Pending',
	'2016-08-21',
	'PENDING'
);

insert into overtime
(

	pk,
	time_from,
	time_to,
	employees_pk

)
values
(
	'2',
	'2016-08-22',
	'2016-08-25',
	'85'

);

insert into overtime_status
(
	overtime_pk,
	created_by,
	status,
	date_created,
	remarks
)
values
(
	'2',
	'85',
	'Pending',
	'2016-08-21',
	'PENDING'
);