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

insert into notifications
(
	notification,
	table_from,
	table_from_pk
)
values
(
	'Test notification 1',
	'Employees',
	1
),
(
	'Test notification 2',
	'Employees',
	1
),
(
	'Test notification 3',
	'Employees',
	1
)
;

