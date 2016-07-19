<?php
require_once('../../CLASSES/ClassParent.php');
class Leave extends ClassParent {

    var $pk = NULL;
    var $employees_pk = NULL;
    var $leave_types_pk= NULL;
    var $date_started = NULL;
    var $date_ended= NULL;
    var $date_created = NULL;
    var $reason = NULL;
    var $archived = NULL;

    public function __construct(
                                $pk='',
                                $employees_pk = '',
                                $leave_types_pk= '',
                                $date_started = '',
                                $date_ended= '',
                                $date_created = '',
                                $reason = '',
                                $archived = ''
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




    public function leaves_filed(){
        
        $sql = <<<EOT
                select
                    pk, 
                    (select name from leave_types where pk = leave_types_pk) as leave_type,
                    date_created,
                    date_started,
                    date_ended
                from leave_filed
                where archived = false
                ;
EOT;

        return ClassParent::get($sql);
    }


   public function add_leave($extra){
        foreach($extra as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }   
        $employees_pk = $this->employees_pk;
        $leave_types_pk= $this->leave_types_pk;
        $date_started = $this->date_started;
        $date_ended= $this->date_ended;
        $reason = $this->reason;

        $sql = 'begin;';
        $sql .= <<<EOT
                insert into leave_filed
                (      
                    employees_pk,
                    leave_types_pk,
                    date_started,
                    date_ended,
                    reason
                )
                values
                (
                    '$employees_pk',
                    '$leave_types_pk',
                    '$date_started',
                    '$date_ended',
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
                    'New leave filed.',
                    'leave_filed',
                    currval('leave_filed_pk_seq'),
                    $supervisor_pk
                )
                ;
EOT;
        $sql .= "commit;";
        

        return ClassParent::insert($sql);
    }
}

?>