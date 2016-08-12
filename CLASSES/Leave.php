<?php
require_once('../../CLASSES/ClassParent.php');
class Leave extends ClassParent {

    var $pk = NULL;
    var $employees_pk = NULL;
    var $leave_types_pk= NULL;
    var $duration = NULL;
    var $category = NULL;
    var $date_started = NULL;
    var $date_ended= NULL;
    var $date_created = NULL;
    var $archived = NULL;

    public function __construct(
                                    $pk,
                                    $employees_pk,
                                    $leave_types_pk,
                                    $duration,
                                    $category,
                                    $date_started,
                                    $date_ended,
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
            if(is_array($v)){
                foreach($v as $key=>$value){
                    $v[$key] = pg_escape_string(trim(strip_tags($value)));
                }
                $this->$k = $v;
            }
            else {
                $this->$k = pg_escape_string(trim(strip_tags($v)));    
            }
        }

        return(true);
    }

    public function leaves_filed(){
        $where = "";
        if($this->employees_pk && $this->employees_pk != 'null'){
            $where .= "and employees_pk = '$this->employees_pk'";
        }

        if($this->leave_types_pk && $this->leave_types_pk != 'null'){
            $where .= "and leave_types_pk = '$this->leave_types_pk'";
        }  
        
        $sql = <<<EOT
                select
                    pk,
                    duration,
                    category,
                    (select first_name||' '||last_name from employees where pk = employees_pk) as name,
                    (select name from leave_types where pk = leave_types_pk) as leave_type,
                    date_created::timestamp(0) as date_created,
                    date_started:: date as date_started,
                    date_ended:: date as date_ended,
                    (
                        select status from leave_status where leave_filed_pk = leave_filed.pk order by date_created desc limit 1
                    ) as status
                from leave_filed
                where archived = false
                and date_created::date between '$this->date_started' and '$this->date_ended'
                $where 
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function employees_leaves_filed($supervisor_pk){
        $supervisor_pk = pg_escape_string(strip_tags(trim($supervisor_pk)));

        $where = "";
        if($this->employees_pk && $this->employees_pk != 'null'){
            $where .= "and employees_pk = '$this->employees_pk'";
        }

        if($this->leave_types_pk && $this->leave_types_pk != 'null'){
            $where .= "and leave_types_pk = '$this->leave_types_pk'";
        }

        $where .= "and employees_pk in (select employees_pk from groupings where supervisor_pk = '$supervisor_pk')";
        
        $sql = <<<EOT
                select
                    pk, 
                    employees_pk,
                    duration,
                    category,
                    (select first_name||' '||last_name from employees where pk = employees_pk) as name,
                    (select name from leave_types where pk = leave_types_pk) as leave_type,
                    date_created::timestamp(0) as date_created,
                    date_started:: date as date_started,
                    date_ended:: date as date_ended,
                    (
                        select status from leave_status where leave_filed_pk = leave_filed.pk order by date_created desc limit 1
                    ) as status,
                    (
                        select remarks from leave_status where leave_filed_pk = leave_filed.pk order by date_created desc limit 1
                    ) as reason
                from leave_filed
                where archived = false
                and date_created::date between '$this->date_started' and '$this->date_ended'
                $where 
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function update($extra){
        foreach($extra as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $pk             = $extra['pk'];
        $status         = $extra['status'];
        $employees_pk   = $extra['employees_pk'];
        $created_by     = $extra['created_by'];
        $status         = $extra['status'];

        $sql = 'begin;';
        $sql .= <<<EOT
                insert into leave_status
                (
                    leave_filed_pk,
                    status,
                    created_by,
                    remarks
                )
                values
                (    
                    $pk,
                    '$status',
                    $created_by,
                    'REPLACE THIS BY REASON'
                )
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
        $duration= $this->duration;
        $category= $this->category;
        $date_started = $this->date_started;
        $date_ended= $this->date_ended;
        $reason = $this->reason;

        $a = $this->get_leave_balances($employees_pk);

        $balances = json_decode($a['result'][0]['leave_balances']);
        $balances = (array) $balances;

        $new_balances = array();
        foreach($balances as $k=>$v){
            $new_balances[(int)$k] = (int)$v;
        }

        $new_balances[$leave_types_pk] = $new_balances[$leave_types_pk] - 1;

        $sql = 'begin;';
        $sql .= <<<EOT
                insert into leave_filed
                (      
                    employees_pk,
                    leave_types_pk,
                    duration,
                    category,
                    date_started,
                    date_ended
                )
                values
                (
                    $employees_pk,
                    $leave_types_pk,
                    '$duration',
                    '$category',
                    '$date_started',
                    '$date_ended'   
                )
                returning pk
                ;
EOT;
        $sql .= <<<EOT
                insert into leave_status
                (
                    leave_filed_pk,
                    created_by,
                    remarks
                )
                values
                (    
                    currval('leave_filed_pk_seq'),
                    $employees_pk,
                    '$reason'
                )
                ;
EOT;

        $leave_balances = json_encode($new_balances);
        $sql .= <<<EOT
                update employees set leave_balances = '$leave_balances'
                where pk = $employees_pk;
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

    private function get_leave_balances($employees_pk){
        $sql = <<<EOT
                select
                    leave_balances
                from employees
                where pk = $employees_pk
                ;
EOT;
    
        return ClassParent::get($sql);
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
         foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $where="";
       
        if($this->employees_pk){
            $where .="where employees_pk=".$this->employees_pk ;
        }

        $datefrom = $data['datefrom'];
         $dateto = $data['dateto'];
    
         $sql = <<<EOT
                select 
                pk,
                (select first_name||' '||last_name from employees where pk = employees_pk) as name,
                (select name from leave_types where pk = leave_types_pk) as leave_type,
                (select status from leave_statuses where pk = leave_filed.pk) as status,
                date_created:: date as datecreated,
                date_started:: date as datestarted,
                date_ended:: date as dateended
                
                from leave_filed
                
                
                $where
                and date_created::date between '$datefrom' and '$dateto'
                ;                
EOT;

        return ClassParent::get($sql);
    }

    public function delete($info){

        $leave_filed_pk = $info['leave_filed_pk'];
        $created_by = $info['created_by'];

        $sql = 'begin;';
        $sql .= <<<EOT
                UPDATE  leave_filed
                set archived = True
                where pk = $this->pk;
EOT;

        $sql .= <<<EOT
                insert into leave_status
                (
                    leave_filed_pk,
                    status,
                    created_by,
                    remarks
                )
                values
                (
                    $leave_filed_pk,
                    'Deleted',
                    $created_by,
                    'DELETED'
                ) 
                ;
EOT;

        $sql .= "commit;";
        return ClassParent::insert($sql);

    }


    public function admin_leave_delete($info){


        $leave_types_pk = $info['leave_types_pk'];


        $sql .= <<<EOT
                UPDATE  leave_types
                set archived = True
                where pk = $this->pk;
EOT;
        return ClassParent::insert($sql);

    }

}

?>