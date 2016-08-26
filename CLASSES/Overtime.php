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

    public function overtime($data){

        $where = "";
        if($this->employees_pk){
            $where .= "and employees_pk = ".$this->employees_pk;
        }
        $datefrom = $data['datefrom'] ;
        $dateto = $data['dateto'];
        $sql = <<<EOT
                select
                    pk, 
                    employees_pk,
                    (select first_name||' '||last_name from employees where pk = employees_pk) as name,
                    time_to :: time as timeto,
                    time_from :: time as timefrom,
                    date_created::date as datecreated,
                    (select status from overtime_status where pk = overtime_pk order by date_created desc limit 1) as status,
                    (select remarks from overtime_status where pk = overtime_pk order by date_created desc limit 1) as remarks
                from overtime
                where date_created::date between '$datefrom' and '$dateto'
                and archived = 'f'
                $where
                ;
EOT;

        return ClassParent::get($sql);

    }

    public function cancel($info){

        $overtime_pk=$info['overtime_pk'];
        $sql = 'begin;';
        $sql .= <<<EOT
                UPDATE overtime_status
                set archived = true
                where overtime_pk = $overtime_pk
                ;
EOT;
         $sql .= <<<EOT
                UPDATE overtime
                set archived = true
                where pk = $overtime_pk
                ;
EOT;

        $sql .= "commit;";
        return ClassParent::update($sql);
    }

    public function insert_overtime($info){
        foreach($info as $k=>$v){
            $info[$k] = pg_escape_string(trim(strip_tags($v)));
        }
    
        
        $employees_pk=$info['employees_pk'];
        $overtime_pk=$info['overtime_pk'];
        $created_by=$info['created_by'];
        $status=$info['status'];
        $remarks=strtoupper($info['remarks']);
    
        $sql = 'begin;';

        $sql .= <<<EOT
                        update overtime_status set
                        
                            remarks
                        =
                            '$remarks'
                        
                       where overtime_pk = $overtime_pk
                        ;
EOT;
        $sql .= <<<EOT
                        update overtime_status set
                        
                            archived
                        =
                            't'
                        
                       where overtime_pk = $overtime_pk
                        ;
EOT;
        if($status=='Approved'){
            $sql .= <<<EOT

                insert into overtime_status
                (
                    overtime_pk,
                    created_by,
                    status,
                    remarks,
                    archived          
                )
                values
                (    
                    $overtime_pk,
                    $created_by,
                    'Approved',
                    'APPROVED',
                    'f'
                )
                ;
EOT;
        }else{

            $sql .= <<<EOT

                insert into overtime_status
                (
                    overtime_pk,
                    created_by,
                    status,
                    remarks,
                    archived           
                )
                values
                (    
                    $overtime_pk,
                    $created_by,
                    'Disapproved',
                    '$remarks',
                    'f'
                )
                ;
EOT;
        }
    

    $sql .= "commit;";
        return ClassParent::insert($sql);

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