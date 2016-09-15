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
	"levels_pk": "7",
	"titles_pk": "13",
	"supervisor": "17",
	"email_address": "ktapdasan.chrs@gmail.com",
	"business_email_address": "ken.tapdasan@chrsglobal.com",
	"work_schedule": {
		"sunday": null,
		"monday": {
			"in": "09:00",
			"out": "18:00"
		},
		"tuesday": {
			"in": "09:00",
			"out": "18:00"
		},
		"wednesday": {
			"in": "09:00",
			"out": "18:00"
		},
		"thursday": {
			"in": "09:00",
			"out": "18:00"
		},
		"friday": {
			"in": "09:00",
			"out": "18:00"
		},
		"saturday": null
	},
	"company.work_schedule": {
		"friday": {
			"in": "09:00",
			"out": "18:00"
		},
		"monday": {
			"in": "09:00",
			"out": "18:00"
		},
		"sunday": null,
		"tuesday": {
			"in": "09:00",
			"out": "18:00"
		},
		"saturday": null,
		"thursday": {
			"in": "09:00",
			"out": "18:00"
		},
		"wednesday": {
			"in": "09:00",
			"out": "18:00"
		}
	}

}
', true) 
where pk = 12;

update employees set
details = jsonb_set(details, '{personal}', ' 
{
"gender": "Male", 
"religion": "Catholic", 
"last_name": "Funtera", 
"birth_date": "1995-07-27", 
"first_name": "Gregory", 
"civilstatus": "Single", 
"middle_name": "None"
}
', true) 
where pk = 51;


