create table attritions (
	pk serial primary key,
	employees_pk int references employees(pk),
	hr_details jsonb not null,
	supervisor_details jsonb,
	date_created timestamptz default now(),
	archived boolean default false
);

alter table attritions owner to chrs;
/*
sample hr_details

{
	"last_day" : "",
	"effective_date_of_resignation" : "",
	"employee_reason" : "",
	"supervisor_reason" : ""
}

sample supervisor_details

{
	"supervisor_reason" : "",
	"eligibility_for_rehire" : true,
	"remarks" : ""
}
*/