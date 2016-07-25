/* How to update jsonb
update objects set body=jsonb_set(body, '{name}', '"Mary"', true) where id=1;
*/

begin;
alter table employees add column details jsonb;

update employees set details = '{
	"company" : {
		"levels_pk" : 3,
		"hours" : 250
	}
}'::jsonb where levels_pk = 3;
commit;