create table holidays(
	pk serial primary key,
	name text not null,
	datex timestamptz,
	created_by int references employees(pk),
	archived boolean default false
);
alter table holidays owner to chrs;