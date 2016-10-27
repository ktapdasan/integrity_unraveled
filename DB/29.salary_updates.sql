create table rate_types (
	pk serial primary key,
	type text not null,
	archived boolean default false
);
alter table rate_types owner to chrs;

create table pay_periods (
	pk serial primary key,
	period text not null,
	archived boolean default false
);

alter table pay_periods owner to chrs;

insert into rate_types
(
	type
)
values
(
	'Hourly'
),
(
	'Daily'
),
(
	'Monthly'
)
;

insert into pay_periods
(
	period
)
values
(
	'Daily'
),
(
	'Weekly'
),
(
	'Semi-Monthly'
),
(
	'Monthly'
),
(
	'Annually'
)
;