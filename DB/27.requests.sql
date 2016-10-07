create table request_type (
	pk serial primary key,
	type text not null,
	recipient int[] not null,
	archived boolean default false
);
alter table request_type owner to chrs;

drop table requests_handlers;
-- create table requests_handlers (
-- 	employees_pk int references employees(pk),
-- 	created_by int references employees(pk),
-- 	date_created timestamptz default now(),
-- 	constraint employees_pk_unique unique(employees_pk)
-- );
-- alter table requests_handlers owner to chrs;

drop table requests;
create table requests (
	pk serial primary key,
	request_type_pk int references request_type(pk),
	created_by int references employees(pk),
	date_created timestamptz default now(),
	archived boolean default false
);
alter table requests owner to chrs;

create table requests_status (
	requests_pk int references requests(pk),
	status text default 'Pending',
	remarks text
);
alter table requests owner to chrs;