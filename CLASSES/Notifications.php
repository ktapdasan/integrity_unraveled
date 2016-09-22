<?php 
require_once('../../CLASSES/ClassParent.php');
class Notifications extends ClassParent {
	
    var $pk = NULL;
    var $employees_pk = NULL;
	var $notification = NULL;
	var $table_from = NULL;
	var $table_from_pk = NULL;
	var $read = NULL;
	var $archived= NULL;

	 public function __construct(
                                    $pk,
                                    $employees_pk,
                                    $notification,
                                    $table_from,
									$table_from_pk,
									$read,
									$archived
                                ){
        
        $fields = get_defined_vars();
        
        if(empty($fields)){
            return(FALSE);
        }

        //sanitize
        foreach($fields as $k=>$v){
            $this->$k = pg_escape_string(trim(strip_tags($v)));
        }

        return(true);
    }

	public function fetch(){

        $sql = <<<EOT
                select
                    pk, 
                    (select last_name ||', '|| first_name ||' '|| middle_name from employees where pk = employees_pk) as employee,
                    notification,
                    table_from,
                    table_from_pk,
                    read,
                    (select last_name ||', '|| first_name ||' '|| middle_name from employees where pk = created_by) as created_by,
                    date_created::timestamp (0) as date_created
                from notifications
                where employees_pk = $this->employees_pk
                and read='f'
                order by pk desc
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function read_notifs(){  

        $read = $this->read;

        $sql = <<<EOT
                UPDATE notifications
                set read = true
                where pk = $this->pk;
EOT;

          return ClassParent::update($sql);
    }


    public function get_birthday(){

         $sql = <<<EOT
                select 
                pk,
                (select last_name ||', '|| first_name ||' '|| middle_name) as name,
                to_char((employees.details->'personal'->>'birth_date')::date,'Mon DD')AS birthday,
                to_char(now()::date,'Mon DD')AS now
                from employees
                where
                to_char((employees.details->'personal'->>'birth_date')::date,'MM')=
                to_char(now()::date,'MM')
                order by employees.details->'personal'->'birth_date'
                ;
EOT;
            return ClassParent::get($sql);

    }

    public function get_memo(){

        $sql = <<<EOT
                select
                pk,
                memo,
                (select last_name ||', '|| first_name ||' '|| middle_name from employees where pk = created_by) as created_by,
                substring(memo for 25)||'...' as limitedmemo,
                date_created::timestamp (0) as date_created,
                read
                from memo
                where
                archived=false
                order by date_created 
                desc 
                limit 6
                ;
EOT;
            return ClassParent::get($sql);

    }

    public function get_calendar(){

        $sql = <<<EOT
                select 
                pk,
                location,
                description,
                to_char((time_from)::date,'Mon DD YYYY')AS time_from,
                to_char((time_to)::date,'Mon DD YYYY')AS time_to,
                color,
                (select last_name ||', '|| first_name ||' '|| middle_name from employees where pk = created_by) as created_by,
                date_created::timestamp (0) as date_created
                from calendar
                order by date_created 
                desc 
                limit 6
                ;
EOT;
            return ClassParent::get($sql);

    }

    public function read_memo(){  

        $read = $this->read;
                
        $sql = <<<EOT
                insert into memo_tracker
                (    
                    memo_pk,
                    employees_pk
                )  
                values
                (
                    '$this->pk',
                    '$this->employees_pk'
                );
EOT;

          return ClassParent::update($sql);
    }

    public function get_read_memo(){

        $sql = <<<EOT
                select 
                memo_pk,
                employees_pk,
                (select last_name ||', '|| first_name ||' '|| middle_name from employees where pk = employees_pk) as name,
                date_created::timestamp (0) as date_created
                from memo_tracker
                where
                memo_pk=$this->pk
                order by date_created 
                desc
                
                ;
EOT;
            return ClassParent::get($sql);

    }
}

?>
