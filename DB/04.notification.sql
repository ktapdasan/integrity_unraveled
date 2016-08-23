drop table notifications;

create table notifications
(
	pk serial primary key,
	employees_pk int references employees(pk),
	notification text not null,
	table_from text not null,
	table_from_pk int not null,
	read boolean default false,
	date_created timestamptz default now(),
	archived boolean default false
);

alter table notifications owner to chrs;


	



