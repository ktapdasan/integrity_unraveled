<?php
require_once('../../CLASSES/ClassParent.php');
class Groupings extends ClassParent {

    var $employees_pk = NULL;
    var $supervisor_pk = NULL;

    public function __construct(
                                    $employees_pk,
                                    $supervisor_pk
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
                    supervisor_pk,
                    employees.first_name||' '||employees.last_name as name,
                    employees.email_address,
                    employees.business_email_address
                from groupings
                left join employees on (groupings.supervisor_pk = employees.pk)
                where employees_pk = $this->employees_pk
                ;
EOT;
        return ClassParent::get($sql);
    }
}
?>