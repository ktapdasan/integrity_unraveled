create table memo (
	pk serial primary key,
	memo text,
	created_by int references employees(pk),
	date_created timestamptz default now(),
	read boolean default false,
	archived boolean default false
);
alter table memo owner to chrs;

create table memo_tracker (
	memo_pk int references memo(pk),
	employees_pk int references employees(pk),
	date_created timestamptz default now(),
	constraint employees_pk_unique unique(employees_pk)
);
alter table memo_tracker owner to chrs;

create table calendar (
	pk serial primary key,
	recipients int[],
	location text not null,
	description text not null,
	time_from timestamptz,
	time_to timestamptz,
	color text not null,
	created_by int references employees(pk),
	date_created timestamptz default now(),
	archived boolean default false
);
alter table calendar owner to chrs;