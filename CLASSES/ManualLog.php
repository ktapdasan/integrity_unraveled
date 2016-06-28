<?php
require_once('../../CLASSES/ClassParent.php');
class ManualLog extends ClassParent {

    var $pk = NULL;
    var $employees_pk = NULL;
    var $time_log = NULL;
    var $reason = NULL;
    var $date_created = NULL;
    var $archived = NULL;
    

    public function __construct(    
                                    $pk ,
                                    $employees_pk ,
                                    $time_log ,
                                    $reason,
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

    public function save_manual_log(){
        $employees_pk = $this->employees_pk;
        $time_log = $this->time_log;
        $reason= $this->reason;


        $sql = <<<EOT
                insert into manual_log
                (
                    employees_pk,
                    time_log,
                    reason
                
                )
                values
                (    
                    $employees_pk,
                    '$time_log',
                    '$reason' 
                )
                ;
EOT;

        return ClassParent::insert($sql);   

    }
}

?>