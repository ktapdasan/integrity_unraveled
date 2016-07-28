
create table leave_filed_approvers(
	leave_filed_pk int references leave_filed(pk),
	employees_pk int references employees(pk),
	date_created timestamptz default now(),
	status boolean not null,
	remarks text not null
);

ALTER TABLE manual_log_approvers owner to chrs;