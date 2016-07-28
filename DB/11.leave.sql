CREATE TABLE leave_filed (
	pk serial primary key,
	employees_pk int references employees(pk),
	leave_types_pk int references leave_types(pk),
	date_started timestamptz NOT NULL,
	date_ended timestamptz NOT NULL,
	date_created timestamptz default now(),
	reason text NOT NULL,
	archived boolean default false
);

ALTER TABLE leave_filed owner to chrs;

CREATE TABLE leave_types(
	pk serial primary key,
	name text NOT NULL,
	code text NOT NULL,
	archived boolean default false
);

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




