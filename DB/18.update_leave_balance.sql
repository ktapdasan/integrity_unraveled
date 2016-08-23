CREATE or replace FUNCTION update_leave_balance(employees_pk int, leave_types_pk int) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

DECLARE

old_value int;

begin
if employees_pk is null or leave_types_pk is null then
 	return FALSE;
end if;

select leave_balances->'1'::int from employees where pk = employees_pk into old_value;

update employees set leave_balances=jsonb_set(leave_balances, '{' + leave_types_pk + '}', '" ' + old_value++ + ' "', true) where pk = employees_pk;

return TRUE;

end;
$$;


ALTER FUNCTION public.update_leave_balance(employees_pk int, leave_types_pk int) OWNER TO chrs;
