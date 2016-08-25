begin;
create table cutoff_types (
	pk serial primary key,
	type text not null,
	archived boolean default false
);
alter table cutoff_types owner to chrs;
create unique index cutoff_types_idx on cutoff_types(type);

create table cutoff_dates (
	cutoff_types_pk int references cutoff_types(pk),
	dates jsonb not null,
	archived boolean default false
);
alter table cutoff_dates owner to chrs;

insert into cutoff_types
(
	type
)
values
(
	'Monthly'
),
(
	'Bi-Monthly'
);

insert into cutoff_dates
(
	cutoff_types_pk,
	dates
)
values
(
	2,
	'{
		"cutoff" : [
					 {
						"from" : 1,
						"to" : 15
					},
					{
						"from" : 16,
						"to" : 30
					}
				]
	}'
);

/*
values
(
	1,
	'{
		"cutoff" : [
					 {
						"from" : 1,
						"to" : 30
					}
				]
	}'
)
*/

commit;