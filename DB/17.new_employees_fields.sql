/*****
employees table new jsonb fields
*****/

create table employees_backup
(
	pk serial primary key,
	details jsonb,
	leave_balances jsonb,
	date_created timestamptz default now(),
	archived boolean default false
);
alter table employees_backup owner to chrs;

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

create table civil_statuses
(
	pk serial primary key,
	status text not null,
	archived boolean default false
);
alter table civil_statuses owner to chrs;

insert into civil_statuses (status)
values
(
	'Married'
),
(
	'Single'
),
(
	'Divorce'
),
(
	'Living Common Law'
),
(
	'Widowed'
)
;

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
	'bank'
),
(
	'cash'
),
(
	'wire'
);

create table gender_type
(
	pk serial primary key,
	type text not null,
	archived boolean default false
);
alter table gender_type owner to chrs;

insert into gender_type
(
	type
)
values
(
	'Male'
),
(
	'Female'
);

/*IMPORTANT!*/
-- For profile pic upload please create folder on - ASSETS/uploads/profile for it to save!
-- Then on terminal go cd (change directory) to ASSETS and type chmod 775 -R uploads/

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
	"departments_pk": "26",
	"employee_id": "201400072",
	"date_started": "03/01/2016",
	"levels_pk": "8",
	"titles_pk": "8",
	"supervisor": "17",
	"employee_status_pk": "3",
	"employment_type_pk": "1",
	"email_address": "ktapdasan.chrs@gmail.com",
	"business_email_address": "ken.tapdasan@chrsglobal.com",
	"salary": 
	{
	"salary_type": "cash",
	"amount": "55555555"
	},
	"work_schedules": {
		"sunday": {
			"ins": "null",
			"out": "null"
		},
		"monday": {
			"ins": "2016-09-29 09:00",
			"out": "2016-09-29 18:00"
		},
		"tuesday": {
			"ins": "2016-09-29 09:00",
			"out": "2016-09-29 18:00"
		},
		"wednesday": {
			"ins": "2016-09-29 09:00",
			"out": "2016-09-29 18:00"
		},
		"thursday": {
			"ins": "2016-09-29 09:00",
			"out": "2016-09-29 18:00"
		},
		"friday": {
			"ins": "2016-09-29 09:00",
			"out": "2016-09-29 18:00"
		},
		"saturday": {
			"ins": "null",
			"out": "null"
		}
	},
	"company_work_schedule": {
		"friday": {
			"ins": "09:00",
			"out": "18:00"
		},
		"monday": {
			"ins": "09:00",
			"out": "18:00"
		},
		"sunday": null,
		"tuesday": {
			"ins": "09:00",
			"out": "18:00"
		},
		"saturday": null,
		"thursday": {
			"ins": "09:00",
			"out": "18:00"
		},
		"wednesday": {
			"ins": "09:00",
			"out": "18:00"
		}
	}
	

}
', true);
where pk = 12;


update employees set
details = jsonb_set(details, '{government}', ' 
{
"data_sss": "N/A", 
"data_tin": "N/A", 
"data_phid": "N/A", 
"data_pagmid": "N/A"
}
', true);

update employees set
details = jsonb_set(details, '{personal}', ' 
{
"first_name": "Ken", 
"middle_name": "Villanueva", 
"last_name": "Tapdasan", 
"email_address": "ktapdasan.chrs@gmail.com",
"gender_pk": "1",
"civilstatus_pk": "2",
"religion": "Catholic",
"present_address": "Mandaluyong",
"permanent_address": "Dasmarinas",
"birth_date": "1995-07-27",
"contact_number": "09504151950",
"landline_number": "5340368",
"profile_picture": "./ASSETS/uploads/profile/Ken/profile.jpg"
}
', true)
where pk = 12;

update employees set
details = jsonb_set(details, '{education}', ' 
{
"school_type": 
	    [{"educ_level": "Primary", 
		"school_name": "Elem School", 
		"date_to_school": "1995-07-27", 
		"school_location": "Where", 
		"date_from_school": "1995-07-27"}, 
		{"educ_level": "Tertiary", 
		"school_name": "Tertiary School", 
		"date_to_school": "1992-03-22", 
		"school_location": "Where", 
		"date_from_school": "1992-03-22"}]
}
', true)
where pk = 12;



