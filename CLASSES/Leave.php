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
    var $employees = NULL;

    public function __construct(
                                $pk='',
                                $employees_pk = '',
                                $leave_types_pk= '',
                                $date_started = '',
                                $date_ended= '',
                                $date_created = '',
                                $reason = '',
                                $archived = '',
                                $employees=''
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
                    (select first_name||' '||last_name from employees where pk = employees_pk) as name,
                    (select name from leave_types where pk = leave_types_pk) as leave_type,
                    date_created:: date as datecreated,
                    date_started:: date as datestarted,
                    date_ended:: date as dateended,
                    (select status from leave_statuses where pk = leave_filed.pk) as status
                from leave_filed
                where archived = false
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function update($extra){
    foreach($extra as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }
    $pk = $extra['pk'];
    $status = $extra['status'];
    $employees_pk=$extra['employees_pk'];

        $sql = 'begin;';
        $sql .= <<<EOT
                update leave_statuses set
                    status
                =
                    '$status'
                where pk = $pk;
                ;
EOT;
       
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
                    'Leave $status',
                    'leave_filed',
                    $pk,
                    $employees_pk
                )
                ;
EOT;
        $sql .= "commit;";
        return ClassParent::insert($sql);

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

        $sql .= <<<EOT
                insert into leave_statuses
                (
                    pk,
                    status          
                )
                values
                (    
                    currval('leave_filed_pk_seq'),
                    'Pending'
                )
                ;
EOT;
        $sql .= "commit;";
        

        return ClassParent::insert($sql);
    }


    public function get_myemployees($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }
        $pk=$data['pk'];

       
        
        $sql = <<<EOT
                select 
                    employees_pk as pk,
                (select first_name||' '||last_name from employees where pk = groupings.employees_pk) as myemployees
                from groupings
                where supervisor_pk = $pk
                ;
EOT;

        return ClassParent::get($sql);
    }


    public function myemployees($data){
        $where="";
        
        if($_POST['employees_pk']){
            $where .="where employees_pk=".$_POST['employees_pk'];
        }
        
        $sql = <<<EOT
                select 
                (select first_name||' '||last_name from employees where pk = employees_pk) as name,
                (select name from leave_types where pk = leave_types_pk) as leave_type,
                (select status from leave_statuses where pk = leave_filed.pk) as status,
                date_created:: date as datecreated,
                date_started:: date as datestarted,
                date_ended:: date as dateended
                
                from leave_filed
                $where
                ;


                
EOT;

        return ClassParent::get($sql);
    }



}

?>