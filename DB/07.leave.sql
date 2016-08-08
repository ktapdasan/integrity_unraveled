create table leave_types
(
	pk serial primary key,
	name text not null,
	code text not null,
	days int not null,
	archived boolean default false
);
alter table leave_types owner to chrs;

INSERT into leave_types 
(name, code, days)
VALUES

('Home Based', 'HB', 7),

('Paid Time off', 'PTO', 7),

('Birthday Leave', 'BL', 7),

('Emergency Leave', 'BL', 7),

('Leave Without Pay','LWOP', 7),

('Compensatory Time Off', 'CTO', 7),

('Under Time' , 'UT', 7);


CREATE TABLE leave_filed (
	pk serial primary key,
	employees_pk int references employees(pk),
	leave_types_pk int references leave_types(pk),
	date_started timestamptz NOT NULL,
	date_ended timestamptz NOT NULL,
	date_created timestamptz default now(),
	archived boolean default false
);

ALTER TABLE leave_filed owner to chrs;

create table leave_status (
	leave_filed_pk int references leave_filed(pk),
	status text default 'Pending',
	created_by int references employees(pk),
	date_created timestamptz default now(),
	remarks text not null,
	archived boolean default false
);
ALTER TABLE leave_status owner to chrs;
