create table leave_types
(
	pk serial primary key,
	name text not null,
	code text not null,
	days int not null,
	archived boolean default false
);
alter table leave_types owner to chrs;
