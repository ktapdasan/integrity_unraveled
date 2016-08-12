<?php
require_once('../../CLASSES/ClassParent.php');
class ManualLog extends ClassParent {

    var $pk = NULL;
    var $employees_pk = NULL;
    var $time_log = NULL;
    var $reason = NULL;
    var $date_created = NULL;
    var $archived = NULL;
    var $type = NULL;
    

    public function __construct(    
                                    $pk ,
                                    $employees_pk,
                                    $time_log ,
                                    $reason,
                                    $date_created,
                                    $archived,
                                    $type
                                   
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
                    pk, 
                    (select first_name||' '||last_name from employees where pk = employees_pk) as name,
                    time_log :: time as time,
                    date_created::date as datecreated,
                    type,
                    (select status from manual_log_statuses where pk = manual_log.pk) as status
                from manual_log
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
                update manual_log_statuses set
                
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
                    'Manual log filed $status',
                    'manual_log',
                    $pk,
                    $employees_pk
                )
                ;
EOT;
        $sql .= "commit;";
        return ClassParent::insert($sql);

    }

    public function save_manual_log($extra){
        foreach($extra as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }
        $employees_pk = $this->employees_pk;
        $time_log = $this->time_log;
        $reason= $this->reason;
        $type= $this->type;

        $sql = 'begin;';
        $sql .= <<<EOT
                insert into manual_log
                (
                    employees_pk,
                    time_log,
                    reason,
                    type
                )
                values
                (    
                    $employees_pk,
                    '$time_log',
                    '$reason',
                    '$type'
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
        $sql .= <<<EOT
                insert into manual_log_statuses
                (
                    pk,
                    status          
                )
                values
                (    
                    currval('manual_log_pk_seq'),
                    'Pending'
                )
                ;
EOT;
        $sql .= "commit;";



        return ClassParent::insert($sql);   

    }

    public function employees_manual_logs($data)
    {
        $where = "";
        if($this->employees_pk){
            $where .= "and employees_pk = ".$this->employees_pk;
        }
        $datefrom = $data['datefrom'];
        $dateto = $data['dateto'];
        $sql = <<<EOT
                select
                    pk, 
                    (select first_name||' '||last_name from employees where pk = employees_pk) as name,
                    time_log :: time as time,
                    date_created::date as datecreated,
                    type,
                    (select status from manual_log_statuses where pk = manual_log.pk) as status
                from manual_log
                where date_created::date between '$datefrom' and '$dateto'
                $where
                ;
EOT;

        return ClassParent::get($sql);

    }

    public function get_myemployees($extra){
        foreach($data as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $pk = $extra['pk'];

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

  



}

?>