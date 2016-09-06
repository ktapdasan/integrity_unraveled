create table daily_pass_slip (
	pk serial primary key,
	type text default 'Official',
	employees_pk int references employees(pk),
	time_from timestamptz,
	time_to timestamptz,
	date_created timestamptz default now(),
	archived boolean default false
);
alter table daily_pass_slip owner to chrs;

create table daily_pass_slip_status (
	daily_pass_slip_pk int references daily_pass_slip(pk),
	status text default 'Pending',
	created_by int references employees(pk),
	remarks text not null,
	date_created timestamptz default now()
);
alter table daily_pass_slip_status owner to chrs;