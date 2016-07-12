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
(name, code)
VALUES

('Home Based', 'HB'),

('Paid Time off', 'PTO'),

('Birthday Leave', 'BL'),

('Emergency Leave', 'BL'),

('Leave Without Pay','LWOP'),

('Compensatory Time Off', 'CTO'),

('Under Time' , 'UT');




