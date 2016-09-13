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

    public function fetch(){        
        $sql = <<<EOT
                select
                    pk,
                    duration,
                    category,
                    employees_pk,
                    (select first_name||' '||last_name from employees where pk = employees_pk) as name,
                    leave_types_pk,
                    (select name from leave_types where pk = leave_types_pk) as leave_type,
                    date_created::timestamp(0) as date_created,
                    date_started:: date as date_started,
                    date_ended:: date as date_ended,
                    (
                        select status from leave_status where leave_filed_pk = leave_filed.pk order by date_created desc limit 1
                    ) as status,
                    archived
                from leave_filed
                where archived = false
                and pk = $this->pk
                ;
EOT;

        return ClassParent::get($sql);
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
                    employees_pk,
                    (select first_name||' '||last_name from employees where pk = employees_pk) as name,
                    leave_types_pk,
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
                    leave_types_pk,
                    (select name from leave_types where pk = leave_types_pk) as leave_type,
                    date_created::timestamp(0) as date_created,
                    date_started:: date as date_started,
                    date_ended:: date as date_ended,
                    (
                        select status from leave_status where leave_filed_pk = leave_filed.pk order by date_created desc limit 1
                    ) as status,
                    (
                        select remarks from leave_status where leave_filed_pk = leave_filed.pk order by date_created desc limit 1
                    ) as reason,
                    (
                        select details->'company'->'work_schedule' from employees where pk = leave_filed.employees_pk
                    ) as work_schedule
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
        
        
        $employees_pk   = $extra['employees_pk'];
        $created_by     = $extra['created_by'];
        $status         = $extra['status'];
        $category       = $extra['category'];
        $duration       = $extra['duration'];
        $workdays       = $extra['workdays'];
        $leave_types_pk = $extra['leave_types_pk'];
        $remarks = $extra['remarks'];
        $created_by = $extra['created_by'];


        $sql = 'begin;';

        if($status == "Disapproved"){
            $a = $this->get_leave_balances($employees_pk);

            $balances = json_decode($a['result'][0]['leave_balances']);
            $balances = (array) $balances;
            
            $amount = $workdays;
            if($duration != "Whole Day"){
                $amount=0.5;    
            }

            if($category != "Paid"){
                $amount = 0;
            }

            $new_balances=array();
            foreach($balances as $k=>$v){
                if($k == $leave_types_pk){
                    $new_balances[$k] = $v + $amount;
                }
                else {
                    $new_balances[$k] = $v;   
                }
            }

            $new_balances = json_encode($new_balances);
            $sql .= <<<EOT
                    update employees set leave_balances = '$new_balances'
                    where pk = $employees_pk;
EOT;
        }

        if($status == "Approved"){

            $remarks="Approved";
        }

        
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
                    $this->pk,
                    '$status',
                    $created_by,
                    '$remarks'
                )
                ;
EOT;
       
        $sql .= <<<EOT
                insert into notifications
                (
                    notification,
                    table_from,
                    table_from_pk,
                    employees_pk,
                    created_by        
                )
                values
                (    
                    'Leave $status',
                    'leave_filed',
                    $this->pk,
                    $employees_pk,
                    $created_by

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
        $reason = $extra['reason'];

        $a = $this->get_leave_balances($employees_pk);

        $balances = json_decode($a['result'][0]['leave_balances']);
        $balances = (array) $balances;

        //$new_balances[(int)$extra['leave_types_pk']] = $extra['remaining'];
        $new_balances = array();
        foreach($balances as $k=>$v){
            if($k == $this->leave_types_pk){
                $v = $extra['remaining'];
            }

            $new_balances[$k] = $v;
        }

        if($extra['duration'] != "Whole Day"){
            $date_ended = $date_started;
        }

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

//         if($extra['category'] == "Paid"){
//             if($extra['duration'] == "Whole Day"){
//                 if($this->date_started == $this->date_ended){
//                     $new_balances[$leave_types_pk] = $new_balances[$leave_types_pk] - 1;    
//                 }
//                 else {
//                     $new_balances[$leave_types_pk] = $new_balances[$leave_types_pk] - 1;
//                 }
//             }
//             else {

//             }

//             $leave_balances = json_encode($new_balances);
//             $sql .= <<<EOT
//                     update employees set leave_balances = '$leave_balances'
//                     where pk = $employees_pk;
// EOT;
//         }

        //print_r($leave_balances);
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
                    employees_pk,
                    created_by      
                )
                values
                (    
                    'New leave filed.',
                    'leave_filed',
                    currval('leave_filed_pk_seq'),
                    $supervisor_pk,
                    $employees_pk
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
        $info['leave_balances'] = (array) json_decode($info['leave_balances']);
        
        $new_balances=array();
        foreach($info['leave_balances'] as $k=>$v){
            if($k == $info['leave_types_pk'] && $info['category'] == "Paid"){
                
                if($info['duration'] == "Whole Day"){
                    $new_balances[$k] = $v + $info['workdays'];
                }
                else {
                    $new_balances[$k] = $v + 0.5;
                }
            }
            else {
                $new_balances[$k] = $v;
            }
        }
        
        $pk = $info['pk'];
        $created_by = $info['created_by'];
        $leave_balances = json_encode($new_balances);

        
       $sql = <<<EOT
                UPDATE  leave_filed
                set archived = True
                where pk = $pk
                ;
EOT;

        $sql .= <<<EOT
                update employees set leave_balances = '$leave_balances' where pk = $created_by;
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
                    $pk,
                    'Deleted',
                    $created_by,
                    'DELETED'
                ) 
                ;
EOT;

        
        return ClassParent::insert($sql);
    }

    public function approved_leaves($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $date_from = $data['date_from'];
        $date_to = $data['date_to'];

        $where = "where";
        if($data['date_from'] && $data['date_to']){
            $where .= "
                    (
                        (date_started::date >= '$date_from' and date_started::date <= '$date_to') or 
                        (date_ended::date >= '$date_from' and date_ended::date <= '$date_to')
                    ) and
                ";
        }

        if($this->employees_pk && $this->employees_pk != 'undefined'){
            $where .= " employees_pk = ".$this->employees_pk;
        }

        $sql = <<<EOT
                with Q as
                (
                    select
                        leave_filed.pk,
                        employees_pk,
                        date_started::date as date_started,
                        date_ended::date as date_ended,
                        (select name from leave_types where pk = leave_filed.leave_types_pk) as name,
                        (select status from leave_status where leave_filed_pk = leave_filed.pk order by date_created desc limit 1) as status
                    from leave_filed
                    $where 
                )
                select
                    pk,
                    employees_pk,
                    date_started,
                    date_ended,
                    name,
                    status
                from Q where status = 'Approved'
                ;
EOT;

        return ClassParent::get($sql);

    }

    public function cancel_leave($extra){
        foreach($extra as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }
        
        $supervisor_pk  = $extra['supervisor_pk'];
        $remarkss        = $extra['remarks'];
        
        


        $sql = 'begin;';

        
        $sql .= <<<EOT
                insert into leave_cancellation
                (
                    leave_filed_pk,
                    employees_pk
                )
                values
                (    
                    $this->pk,
                    $this->employees_pk
                )
                ;
EOT;

        $sql .= <<<EOT
                insert into leave_cancellation_status
                (
                    leave_cancellation_pk,
                    created_by,
                    remarks,
                    status       
                )
                values
                (    
                    currval('leave_cancellation_pk_seq'),
                    $this->employees_pk,
                    '$remarkss',
                    'Pending'

                )
                ;
EOT;
       
        $sql .= <<<EOT
                insert into notifications
                (
                    notification,
                    table_from,
                    table_from_pk,
                    employees_pk,
                    created_by        
                )
                values
                (    
                    'Cancel Leave',
                    'leave_cancellation',
                    $this->pk,
                    $supervisor_pk,
                    $this->employees_pk

                )
                ;
EOT;
        $sql .= "commit;";
        return ClassParent::insert($sql);
    }

    public function cancellation_leave(){
        
        
//          $sql = <<<EOT
//                     select
//                     leave_cancellation_pk,
//                     created_by,
//                     (select first_name||' '||last_name from employees where pk = created_by) as name,
//                     date_created::timestamp(0) as date_created,
//                     remarks,
//                     status
//                     from 
//                     leave_cancellation_status 
//                     where 
//                     created_by in 
//                     (select employees_pk from groupings where supervisor_pk = '$this->employees_pk');
   
// EOT;

        $sql = <<<EOT
                    select
                    pk,
                    employees_pk,
                    (select first_name||' '||last_name from employees where pk = employees_pk) as name,
                    date_created::timestamp(0) as date_created,
                    (
                        select remarks from leave_cancellation_status where leave_cancellation_pk = leave_cancellation.pk order by date_created desc limit 1
                    ) as remarks,
                    (
                        select status from leave_cancellation_status where leave_cancellation_pk = leave_cancellation.pk order by date_created desc limit 1
                    ) as status
                    from 
                    leave_cancellation
                    where 
                    employees_pk in 
                    (select employees_pk from groupings where supervisor_pk = '$this->employees_pk');
   
EOT;

        return ClassParent::get($sql);
    }

    public function cancellation_respond($extra){

        foreach($extra as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }
        
        $created_by  = $extra['created_by'];
        $remarkss    = $extra['remarks'];
        $status      = $extra['status'];
        
        $sql = 'begin;';

        $sql .= <<<EOT

                insert into leave_cancellation_status
                (
                    leave_cancellation_pk,
                    created_by,
                    remarks,
                    status       
                )
                values
                (    
                    $this->pk,
                    $created_by,
                    '$remarkss',
                    '$status'

                )
                ;
EOT;
       
        $sql .= <<<EOT
                insert into notifications
                (
                    notification,
                    table_from,
                    table_from_pk,
                    employees_pk,
                    created_by        
                )
                values
                (    
                    'Cancel Leave $status',
                    'leave_cancellation',
                    $this->pk,
                    $this->employees_pk,
                    $created_by

                )
                ;
EOT;
        $sql .= "commit;";

        return ClassParent::insert($sql);
    }

    public function leave_analytics(){
        $sql = <<<EOT
                select
                    employees_pk,
                    (select first_name||' '||last_name from employees where pk = leave_filed.employees_pk) as employee,
                    leave_types_pk,
                    name,
                    count(*) as count
                from leave_filed
                left join leave_types on (leave_filed.leave_types_pk = leave_types.pk)
                where employees_pk in (select employees_pk from groupings where supervisor_pk = $this->employees_pk)
                group by employees_pk,employee,leave_types_pk, name
                ;
EOT;

        return ClassParent::get($sql);   
    }
}

?>