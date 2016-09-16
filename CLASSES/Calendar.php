<?php
require_once('../../CLASSES/ClassParent.php');
class Calendar extends ClassParent {

    var $pk = NULL;
    var $location = NULL;
    var $description = NULL;
    var $time_from = NULL;
    var $time_to = NULL;
    var $color = NULL;
    var $created_by = NULL;
    var $date_created = NULL;
    var $archived = NULL;

    public function __construct(
                                    $pk,
                                    $location,    
                                    $description,    
                                    $time_from,    
                                    $time_to,    
                                    $color,    
                                    $created_by,    
                                    $date_created,    
                                    $archived
                                )
        {
        
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

    public function fetch_events($extra){
        foreach($extra as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $sql = <<<EOT
                select
                    pk, 
                    location,
                    description,
                    time_from::timestamp(0) as time_from,
                    time_to::timestamp(0) as time_to,
                    color,
                    created_by,
                    (select first_name||' '||last_name from employees where pk = created_by) as employee,
                    date_created::timestamp(0) as date_created,
                    archived
                from calendar
                where archived = false
                order by time_from desc
                ;
EOT;

        return ClassParent::get($sql);
    }
}

?>