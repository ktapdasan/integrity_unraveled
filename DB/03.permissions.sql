create table employees_permissions (
	employees_pk int references employees(pk),
	permission json not null,
	archived boolean default false
);

alter table employees_permissions owner to chrs;
create unique index employees_permissions_idx on employees_permissions (employees_pk);

insert into employees_permissions
(employees_pk,permission)
values
(
	28,
	'{ 
		"employees" : {
			"list" : true,
			"employees" : true
		} 
	}'
);