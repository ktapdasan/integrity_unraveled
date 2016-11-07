create table timesheet(
	pk serial primary key,
	employees_pk int references employees(pk),
	cutoff text not null,
	datex date not null,
	schedule text not null,
	login timestamptz,
	logout timestamptz,
	hrs numeric,
	tardiness numeric,
	undertime numeric,
	overtime numeric,
	dps text,
	suspension text,
	status text not null,
	archived boolean default false
);
alter table timesheet owner to chrs;

create table payroll(
	pk serial primary key,
	employees_pk int references employees(pk),
	cutoff text not null,
	gross numeric not null,
	deductions numeric not null,
	adjustments numeric not null,
	tin numeric not null,
	sss numeric,
	philhealth numeric,
	pagibig numeric
);
alter table payroll owner to chrs;