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
	date_created timestamptz default now(),
	remarks text not null
);
alter table overtime_status owner to chrs;