alter table manual_log
	add type text not null;

create table leave_statuses (
	pk serial primary key references leave_filed(pk),
	status text not null,
	archived boolean default false
);
ALTER TABLE leave_statuses owner to chrs;