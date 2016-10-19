create table birthday_theme (
	pk serial primary key,
	month text not null,
	location text not null,
	archived boolean default false
);

alter table birthday_theme owner to chrs;