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
                                    $date_from,
                                    $date_to,
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

    public function overtime($data,$extra){

        $where = "";
        if($this->employees_pk && $this->employees_pk != 'null'){
            $where .= "and employees_pk = '$this->employees_pk'";
        }
        
        $supervisor_pk = $extra['supervisor_pk'];
        $date_from = $data['datefrom'] ;
        $date_to = $data['dateto'];
        $where .= "and employees_pk in (select employees_pk from groupings where supervisor_pk = '$supervisor_pk')";
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
                where (time_from::date between '$date_from' and '$date_to' or time_to::date between '$date_from' and '$date_to')
                and archived = false
                $where
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function timesheet_overtime($data){
        
        $employees_pk = $this->employees_pk;
        $date_from = $data['datefrom'] ;
        $date_to = $data['dateto'];

        $sql = <<<EOT
                select
                    pk, 
                    employees_pk,
                    time_to :: time as timeto,
                    time_from :: time as timefrom,
                    date_created::date as datecreated,
                    (select status from overtime_status where pk = overtime_pk order by date_created desc limit 1) as status,
                    (
                        select 
                            array_to_string(array_agg('<div>' || remarks || '</div> <div><span>' || date_created::timestamp(0) || '</span></div>' order by date_created desc), '<hr />') 
                            from overtime_status 
                            where overtime_pk = pk
                            order by pk desc limit 1
                            ) as remarks
                from overtime
                where date_created::date between '$date_from' and '$date_to'
                and archived = 'f' and employees_pk='$this->employees_pk'
                ;
EOT;

        return ClassParent::get($sql);

    }

    public function cancel($info){
        foreach($info as $k=>$v){
            $info[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $employees_pk=$info['employees_pk'];
        $overtime_pk=$info['overtime_pk'];
        $remarks=$info['remarks'];
        $status=$info['status'];

        $sql .= <<<EOT
                INSERT INTO overtime_status
                (
                    overtime_pk,
                    created_by,
                    remarks,
                    status
                )
                values
                (
                    $overtime_pk,
                    $employees_pk,
                    '$remarks',
                    '$status'
                )
                ;
EOT;
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
        $remarks=$info['remarks'];

        $remarks="";
        if($status=='Approved'){
            $remarks = "APPROVED";
        }
        else {
            $remarks = $remarks;
        }

        $sql = <<<EOT
            insert into overtime_status
            (
                overtime_pk,
                created_by,
                status,
                remarks          
            )
            values
            (    
                $overtime_pk,
                $created_by,
                '$status',
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
                    'Overtime $status',
                    'overtime_result',
                    $overtime_pk,
                    $employees_pk,
                    $created_by
                )
                ;
EOT;

        return ClassParent::insert($sql);

    }

    public function insert($data){
        $remarks = pg_escape_string(strip_tags(trim($data['remarks'])));

        //$time_from = date('Y-m-d') . " " . $this->time_from;
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
                    '$this->time_from',
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
                    'Overtime filed',
                    'overtime',
                    currval('overtime_pk_seq'),
                    (select supervisor_pk from groupings where employees_pk= $this->employees_pk),
                    $this->employees_pk
                )
                ;
EOT;
        $sql .= "commit;";

        return ClassParent::insert($sql);
    }


    
}

?>