create table memo (
	pk serial primary key,
	memo text,
	created_by int references employees(pk),
	date_created timestamptz default now(),
	read boolean default false,
	archived boolean default false
);
alter table memo owner to chrs;

create table calendar (
	pk serial primary key,
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