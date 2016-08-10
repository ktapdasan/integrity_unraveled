/*****
employees table new jsonb fields
*****/

create table employment_types
(
	pk serial primary key,
	type text not null,
	archived boolean default false
);
alter table employment_type owner to chrs;

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


/*start of details fields*/
/*
personal - {
	birthday
	gender
	religion
	civil_statuses_pk - Single/Married/Widowed	
}

company - {
	start_date
	employment_types_pk - Regular/Probationary/Trainee	
	salary - {
		bank
		account_number
		amount
		allowances - {
			allowances_pk - amount * can be multiple
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