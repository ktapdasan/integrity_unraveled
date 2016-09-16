create table request_type (
	pk serial primary key,
	type text not null,
	archived boolean default false
);
alter table request_type owner to chrs;

create table requests_handlers (
	employees_pk int references employees(pk),
	created_by int references employees(pk),
	date_created timestamptz default now(),
	constraint employees_pk_unique unique(employees_pk)
);
alter table requests_handlers owner to chrs;

create table requests (
	pk serial primary key,
	request_type_pk int references request_type(pk),
	reason text not null,
	created_by int references employees(pk),
	date_created timestamptz default now(),
	archived boolean default false
);
alter table requests owner to chrs;