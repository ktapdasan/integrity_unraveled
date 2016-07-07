create table manual_log_statuses (
	pk serial primary key,
	status text not null,
	archived boolean default false
);
ALTER TABLE manual_log_statuses owner to chrs;

insert into manual_log_statuses
(
	status
)
values 
(
	'Approved'
),
(
	'Disapproved'
);

create table manual_log(
	pk serial primary key,
	employees_pk int references employees(pk),
	time_log timestamptz NOT NULL,
	reason text NOT NULL,
	date_created timestamptz default now(),
	archived boolean default false
);

ALTER TABLE manual_log owner to chrs;


create table manual_log_approvers(
	manual_log_pk int references manual_log(pk),
	employees_pk int references employees(pk),
	status int references manual_log_statuses(pk),
	date_created timestamptz default now()
);

ALTER TABLE manual_log_approvers owner to chrs;
