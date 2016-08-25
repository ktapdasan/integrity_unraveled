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
                    (select status from manual_log_statuses where pk = manual_log.pk) as status,
                    (select remarks from manual_log_statuses where pk = manual_log.pk) as remarks
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
        $manual_logs_pk=$extra['manual_logs_pk'];
        $type = $extra['type'];
        $time_log= $extra['time_log'];
        $approver_pk= $extra['approver_pk'];

        $remarks=strtoupper($extra['remarks']);
    
        $sql = 'begin;';
        $sql .= <<<EOT
                update manual_logs_status set
                
                    status
                =
                    '$status'
                
               where manual_logs_pk = $pk
                ;
EOT;
        $sql .= <<<EOT
                        update manual_logs_status set
                        
                            remarks
                        =
                            '$remarks'
                        
                       where manual_logs_pk = $pk
                        ;
EOT;

        $sql .= <<<EOT
                        update manual_logs_status set
                        
                            created_by
                        =
                            $approver_pk
                        
                       where manual_logs_pk = $pk
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
                    $approver_pk
                )
                ;
EOT;
        if($status=='Approved'){
            if($type=='In'){
                $random_hash = $this->generateRandomString(50);
                $sql .= <<<EOT
                    insert into time_log
                    (   
                        employees_pk,
                        type,
                        time_log,
                        random_hash         
                    )
                    values
                    (    
                        $employees_pk,
                        '$type',
                        '$time_log',
                        '$random_hash'
                    )
                    ;
EOT;
            }else{
                 $sql .= <<<EOT
                    insert into time_log
                    (   
                        employees_pk,
                        type,
                        time_log,
                        random_hash         
                    )
                    values
                    (    
                        
                        $employees_pk,
                        '$type',
                        '$time_log',
                        (select random_hash from time_log where time_log:: date = '$time_log' and employees_pk=$employees_pk)
                    )
                    ;
EOT;
            }
        }
        
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
                insert into manual_logs
                (
                    employees_pk,
                    time_log,
                    type
                )
                values
                (    
                    $employees_pk,
                    '$time_log',
                    '$type'
                )
                returning pk
                ;
EOT;
        
        $sql .= <<<EOT
                insert into manual_logs_status
                (
                    manual_logs_pk,
                    status,
                    created_by,
                    remarks          
                )
                values
                (    
                    currval('manual_logs_pk_seq'),
                    'Pending',
                    $employees_pk,
                    '$reason'
                )
                ;
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
                    'New manual log filed.',
                    'manual_log',
                    currval('manual_logs_pk_seq'),
                    $supervisor_pk,
                    $employees_pk
                )
                ;
EOT;

        $sql .= "commit;";

        return ClassParent::insert($sql);   

    }

    public function employees_manual_logs($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $where = "";
        if($this->employees_pk){
            $where .= "and manual_logs.employees_pk = ".$this->employees_pk;
        }

        if($data['supervisor_pk']){
            $where .= "and groupings.supervisor_pk = ".$data['supervisor_pk'];
        }

        $datefrom = $data['datefrom'] ;
        $dateto = $data['dateto'];
        $sql = <<<EOT
                select
                    pk, 
                    manual_logs.employees_pk,
                    (select first_name||' '||last_name from employees where pk = manual_logs.employees_pk) as name,
                    time_log :: timestamp as time,
                    date_created::date as datecreated,
                    type,
                    (select status from manual_logs_status where pk = manual_logs_pk) as status,
                    (select remarks from manual_logs_status where pk = manual_logs_pk) as remarks
                from manual_logs
                left join groupings on (manual_logs.employees_pk = groupings.employees_pk)
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

    private function generateRandomString($length) {
        $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ_-';
        $charactersLength = strlen($characters);
        $randomString = '';
        
        for ($i = 0; $i < $length; $i++) {
            $randomString .= $characters[rand(0, $charactersLength - 1)];
        }

        return $randomString;
    }

  



}

?>