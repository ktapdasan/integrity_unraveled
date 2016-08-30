create table holidays(
	pk serial primary key,
	name text not null,
	datex timestamptz,
	archived boolean default false
);
alter table holidays owner to chrs;