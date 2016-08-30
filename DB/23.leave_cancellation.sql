create table leave_cancellation(
	pk serial primary key,
	leave_filed_pk int references leave_filed(pk),
	employees_pk int references employees(pk),
	date_created timestamptz default now(),
	archived boolean default false
);
alter table leave_cancellation owner to chrs;

create table leave_cancellation_status (
	leave_cancellation_pk int references leave_cancellation(pk),
	created_by int references employees(pk),
	date_created timestamptz default now(),
	remarks text not null,
	status text default 'Pending'
);
alter table leave_cancellation_status owner to chrs;