
CREATE TABLE levels (
	pk serial PRIMARY KEY,
	levels varchar NOT NULL,
	archived boolean DEFAULT false
);
ALTER TABLE levels OWNER TO chrs;

ALTER TABLE employees ADD COLUMN levels_pk integer REFERENCES levels;

INSERT INTO levels (levels)
VALUES 
	('C-Level'),
	('Specialist'), 
	('Intern'), 
	('Manager'), 
	('Officer'), 
	('Assistant Manager'), 
	('Associate'), 
	('Supervisor')
; 
ALTER TABLE levels RENAME COLUMN levels TO level_title;