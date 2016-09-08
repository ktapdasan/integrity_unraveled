/*****
employees table new jsonb fields
*****/

create table employment_statuses
(
	pk serial primary key,
	status text not null,
	archived boolean default false
);
alter table employment_statuses owner to chrs;

insert into employment_statuses (status)
values
(
	'Probationary'
),
(
	'Trainee'
),
(
	'Contractual'
),
(
	'Regular'
),
(
	'Consultant'
);

create table gender_type
(
	pk serial primary key,
	genders text not null,
	archived boolean default false
);

alter table gender_type owner to chrs;

insert into gender_type (genders)
values
(
	'Male'
),
(
	'Female'
);

create table employee_types
(
	pk serial primary key,
	type text not null,
	archived boolean default false
);
alter table employee_types owner to chrs;

insert into employee_types (type)
values
(
	'Exempt'
),
(
	'Non-exempt'
);

create table allowances
(
	pk serial primary key,
	allowance text not null,
	archived boolean default false
);
alter table employment_type owner to chrs;

create table civil_statuses
(
	pk serial primary key,
	status text not null,
	archived boolean default false
);
alter table civil_statuses owner to chrs;

create table allowances
(
	pk serial primary key,
	allowance text not null,
	archived boolean default false
);
alter table allowances owner to chrs;

insert into allowances
(
	allowance
)
values
(
	'Transportation'
),
(
	'Food'
);

create table salary_types
(
	pk serial primary key,
	type text not null,
	archived boolean default false
);
alter table salary_types owner to chrs;

insert into salary_types
(
	type
)
values
(
	'Bank'
),
(
	'Cash'
),
(
	'Wire Transfer'
);

create table religions
(
	pk serial primary key,
	religion text not null,
	archived boolean default false
);
alter table religions owner to chrs;

insert into religions
(
	religion
)
values
(
	'Roman Catholic'
),
(
	'Iglesia Ni Cristo'
),
(
	'Jehovah Witness'
);

insert into employees
(
	details
)
values
(
	'Bank'
),
(
	'Cash'
),
(
	'Wire Transfer'
);

ALTER TABLE employees DROP COLUMN civilstatus_pk, DROP COLUMN gender_pk, DROP COLUMN religion_pk, DROP COLUMN employment_type; 
/*start of details fields*/
/*
personal - {
	first_name
	middle_name
	last_name
	birthday
	gender
	religion
	civil_statuses_pk - Single/Married/Widowed	
}

company - {
	start_date
	employment_statuses_pk - Regular/Probationary/Contractual/Consultant/Trainee
	employment_types_pk - Exempt/Non-exempt
	salary - {
		salary_types_pk

		//if type is bank//
		details - {
			bank
			account_number
			amount
		}
		//end of if type is bank//
		
		//if type is cash//
		details - {
			amount
		}
		//end of if type is cash//

		//if type is wire transfer//
		details - {
			mode_of_payment
			account_number
			amount
		}
		//end of if type is wire transfer//

		allowances - {
			allowances_pk - amount * can be multiple
		}
	}
	work_schedule - {
		sunday : {
			in 
			out
		}
		monday : {
			in 
			out
		}
		tuesday : {
			in 
			out
		}
		wednesday : {
			in 
			out
		}
		thursday : {
			in 
			out
		}
		friday : {
			in 
			out
		}
		saturday : {
			in 
			out
		}
	}
}

government - {
	sss
	pagibig
	philhealth
	tin
}

education - {
	doctoral - {
		school
		major
		location
		from
		to
	},
	masteral - {
		school
		major
		location
		from
		to
	},
	tertiary - {
		school
		course
		location
		from
		to
	},
	secondary - {
		school
		location
		from
		to
	},
	primary - {
		school
		location
		from
		to
	}
}
*/

/*
EXAMPLES
update employees set
details = jsonb_set(details, '{company}', ' {
	"start_date": "2015-02-16",
	"employment_statuses_pk": "3",
	"employee_types_pk": "2",
	"departments_pk": "26",
	"levels_pk": "7",
	"titles_pk": "18",
	"supervisor": "28",
	"email_address": "ktapdasan.chrs@gmail.com",
	"business_email_address": "ken.tapdasan@chrsglobal.com",
	"salary": {
		"details": {
			"bank": "BDO",
			"amount": "13000",
			"account_number": "100010001"
		},
		"allowances": {
			"1": "1000",
			"2": "1000"
		},
		"salary_types_pk": "1"
	},
	"work_schedule": {
		"sunday": null,
		"monday": {
			"in": "08:00",
			"out": "17:00"
		},
		"tuesday": {
			"in": "08:00",
			"out": "17:00"
		},
		"wednesday": {
			"in": "08:00",
			"out": "17:00"
		},
		"thursday": {
			"in": "08:00",
			"out": "17:00"
		},
		"friday": {
			"in": "08:00",
			"out": "17:00"
		},
		"saturday": null
	},
	"company.work_schedule": {
		"friday": {
			"in": "08:00",
			"out": "17:00"
		},
		"monday": {
			"in": "08:00",
			"out": "17:00"
		},
		"sunday": null,
		"tuesday": {
			"in": "08:00",
			"out": "17:00"
		},
		"saturday": null,
		"thursday": {
			"in": "08:00",
			"out": "17:00"
		},
		"wednesday": {
			"in": "08:00",
			"out": "17:00"
		}
	}

}
', true) 
where pk = 12;

