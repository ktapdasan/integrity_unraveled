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
                order by pk desc
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function read(){  
        $read = $this->read;
        $sql = <<<EOT
                UPDATE notifications
                set read = true
                where pk = $this->pk;
EOT;

          return ClassParent::update($sql);
    }

}
?>
