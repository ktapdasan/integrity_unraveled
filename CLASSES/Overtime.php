<?php
require_once('../../CLASSES/ClassParent.php');
class Overtime extends ClassParent {

    var $pk             = NULL;
    var $time_from      = NULL;
    var $time_to        = NULL;
    var $employees_pk   = NULL;
    var $date_created   = NULL;
    var $archived       = NULL;

    public function __construct(
                                    $pk,
                                    $time_from,
                                    $time_to,
                                    $employees_pk,
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

    public function fetch(){
       
        $sql = <<<EOT
                select
                    *
                from overtime
                where archived = $this->archived
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function insert($data){
        $remarks = pg_escape_string(strip_tags(trim($data['remarks'])));

        $time_from = date('Y-m-d') . " " . $this->time_from;
        $sql = "begin;";
        $sql .= <<<EOT
                insert into overtime
                (
                    time_from,
                    time_to,
                    employees_pk
                )
                values
                (
                    '$time_from',
                    '$this->time_to',
                    $this->employees_pk
                )
                ;
EOT;
        $sql .= <<<EOT
                insert into overtime_status
                (
                    overtime_pk,
                    created_by,
                    remarks
                )
                values
                (
                    currval('overtime_pk_seq'),
                    $this->employees_pk,
                    '$remarks'
                );
EOT;

        $sql .= "commit;";

        return ClassParent::insert($sql);
    }


    
}

?>