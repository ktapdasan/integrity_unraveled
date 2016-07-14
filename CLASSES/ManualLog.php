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

    public function save_manual_log($extra){
        foreach($extra as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }
        $employees_pk = $this->employees_pk;
        $time_log = $this->time_log;
        $reason= $this->reason;
       

        $sql = 'begin;';
        $sql .= <<<EOT
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
                returning pk
                ;
EOT;
        $supervisor_pk = $extra['supervisor_pk'];
        $sql .= <<<EOT
                insert into notifications
                (   
                    notification,
                    table_from,
                    table_from_pk,
                    employees_pk
                
                )
                values
                (    
                    'New manual log filed.',
                    'manual_log',
                    currval('manual_log_pk_seq'),
                    $supervisor_pk
                )
                ;
EOT;
        $sql .= "commit;";

        return ClassParent::insert($sql);   

    }
}

?>