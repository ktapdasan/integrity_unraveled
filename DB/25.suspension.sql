create table suspension(
	pk serial primary key,
	time_from timestamptz,
	time_to timestamptz,
	remarks text,
	created_by int references employees(pk),
	archived boolean default false
);
alter table suspension owner to chrs;