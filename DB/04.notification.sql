create table notifications
(
	pk serial primary key,
	notification text not null,
	table_from text not null,
	table_from_pk int not null,
	read boolean default false,
	archived boolean default false
);

alter table notifications owner to chrs;