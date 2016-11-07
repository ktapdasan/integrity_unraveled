<?php
require_once('../../CLASSES/ClassParent.php');
class DailyPassSlip extends ClassParent {

    var $pk             = NULL;
    var $employees_pk   = NULL;
    var $time_from      = NULL;
    var $time_to        = NULL;
    var $archived       = NULL;

    public function __construct(
                                    $pk,
                                    $employees_pk,
                                    $time_from,
                                    $time_to,
                                    $archived
                                ){
        
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

    public function fetch($extra){
        foreach($extra as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }
        
        $employees_pk = $this->employees_pk;
        $date_from = $extra['date_from'];
        $date_to = $extra['date_to'];
        $status = $extra['status'];
        $type = $extra['type'];
        $remarks = $extra['remarks'];

        if($extra['status'] == "Active"){
            $status = 'false';
        }
        else {
            $status = 'true';   
        }

        $sql = <<<EOT
                with Q as
                (
                    select 
                        pk,
                        employees_pk,
                        type,
                        (select first_name ||' '||last_name from employees where pk = employees_pk) as employee,
                        date_created::timestamp(0) as date_created,
                        to_char(date_created, 'DD-Mon-YYYY<br/>HH12:MI:SS AM') as datecreated_html,
                        time_from::timestamp(0) as time_from,
                        to_char(time_from, 'DD-Mon-YYYY<br/>HH12:MI:SS AM') as timefrom_html,
                        time_to::timestamp(0) as time_to,
                        to_char(time_to, 'DD-Mon-YYYY<br/>HH12:MI:SS AM') as timeto_html,
                        (select status from daily_pass_slip_status where daily_pass_slip.pk = daily_pass_slip_status.daily_pass_slip_pk order by daily_pass_slip_status.date_created desc limit 1) as status,
                        (
                            select 
                            array_to_string(array_agg('<div>' || remarks || '</div> <div><span>' || date_created::timestamp(0) || '</span></div>'), '<hr />')
                            from daily_pass_slip_status 
                            where daily_pass_slip.pk = daily_pass_slip_status.daily_pass_slip_pk 
                            order by pk desc limit 1
                        ) as reason
                    from daily_pass_slip
                    where (time_from::date between '$date_from' and '$date_to' or time_to::date between '$date_from' and '$date_to')
                    and archived = $status 
                )
                select
                    pk,
                    employees_pk,
                    employee,
                    date_created::timestamp(0) as date_created,
                        to_char(date_created, 'DD-Mon-YYYY<br/>HH12:MI:SS AM') as datecreated_html,
                        time_from::timestamp(0) as time_from,
                        to_char(time_from, 'DD-Mon-YYYY<br/>HH12:MI:SS AM') as timefrom_html,
                        time_to::timestamp(0) as time_to,
                        to_char(time_to, 'DD-Mon-YYYY<br/>HH12:MI:SS AM') as timeto_html,
                    status,
                    type,
                    reason
                from Q
                where (time_from >= '$date_from 0000' and time_from <= '$date_to 2359' or time_to >= '$date_from 0000' and time_to <= '$date_to 2359')
                    and employees_pk = $this->employees_pk 
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function cancel($info){
        foreach($info as $k=>$v){
            $info[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $pk=$info['pk'];
        $employees_pk=$info['employees_pk'];
        $daily_pass_slip_pk=$info['daily_pass_slip_pk'];
        $remarks=$info['remarks'];
        $status=$info['status'];

        
        $sql .= <<<EOT
                INSERT INTO daily_pass_slip_status
                (
                    daily_pass_slip_pk,
                    created_by,
                    remarks,
                    status
                )
                values
                (
                    $daily_pass_slip_pk,
                    $employees_pk,
                    '$remarks',
                    '$status'
                )
                ;
EOT;
        
        return ClassParent::update($sql);
    }

    public function update_dps($info){
        foreach($info as $k=>$v){
            $info[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $employees_pk=$info['employees_pk'];
        $daily_pass_slip_pk=$info['dps_pk'];
        $created_by=$info['created_by'];
        $status=$info['status'];
        $remarks=$info['remarks'];
        $leave_pk=$info['leave_pk'];
        $type=$info['type'];
        
        if($status=='Approved'){
            $remarks = "APPROVED";
        }
        else {
            $remarks = $remarks;
        }

        $a = $this->get_leave_balances($employees_pk);
        
        $balances = json_decode($a['result'][0]['leave_balances']);
        $balances = (array) $balances;

        $date_a = new DateTime($info['time_from']);
        $date_b = new DateTime($info['time_to']);
        $interval = date_diff($date_a,$date_b);

        //echo $interval->format('%h');
        $additional_hrs = $interval->format('%h');

        $z=array();
        foreach ($balances as $key => $value) {
            $z[(int)$key] = $value;
        }
        $balances = $z;

        if(!isset($balances[$leave_pk])){
            $balances[$leave_pk] = 0;
        }

        
        $new_balances = array();
        foreach($balances as $k=>$v){
            if((int)$k == (int)$leave_pk){
                $v = (float)$v - round((float)$additional_hrs / 9, 2);
            }

            $new_balances[$k] = $v;
        }

        $new_balances = json_encode($new_balances);

        $sql = "begin;";

        $sql .= <<<EOT
            insert into daily_pass_slip_status
            (
                daily_pass_slip_pk,
                created_by,
                status,
                remarks          
            )
            values
            (    
                $daily_pass_slip_pk,
                $created_by,
                '$status',
                '$remarks'
            )
            ;
EOT;
        if($status=='Approved' && $type == "Personal"){
            $sql .= <<<EOT
                update employees set
                (
                    leave_balances
                )
                =
                (
                    '$new_balances'
                )
                where pk = $employees_pk
                ;
EOT;
        }


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
                    'Daily Pass Slip $status',
                    'daily_pass_slip',
                    $daily_pass_slip_pk,
                    $employees_pk,
                    $created_by
                )
                ;
EOT;

        $sql .= "commit;";
        
        return ClassParent::update($sql);

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

    public function add_dps($extra){
        foreach($extra as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $employees_pk = $this->employees_pk;
        $time_from=$extra['time_from'];
        $time_to=$extra['time_to'];
        $remarks=$extra['remarks'];
        $type=$extra['type'];
        $date = $extra['date'];
        $date_from = $date . " " . $time_from;
        $date_to = $date . " " . $time_to;
        $sql = 'begin;';
        $sql .= <<<EOT
                INSERT INTO daily_pass_slip
                (
                    employees_pk,
                    time_from,
                    time_to,
                    type
                )
                values
                (
                    $employees_pk,
                    '$date_from',
                    '$date_to',
                    '$type'
                )
                ;
EOT;

        $sql .= <<<EOT
                INSERT INTO daily_pass_slip_status
                (
                    daily_pass_slip_pk,
                    status,
                    created_by,
                    remarks
                )
                values
                (
                    currval('daily_pass_slip_pk_seq'),
                    'Pending',
                    $employees_pk,
                    '$remarks'
                )
                ;
EOT;
        $sql .= "commit;";
        return ClassParent::update($sql);
    }

    public function myemployees_fetch($extra){
        

        $where = "";
        if($this->employees_pk && $this->employees_pk != 'null'){
            $where .= "and employees_pk = '$this->employees_pk'";
        }
        $supervisor_pk = $extra['supervisor_pk'];
        $date_from = $extra['date_from'];
        $date_to = $extra['date_to'];
        $status = $extra['status'];
        $type = $extra['type'];
        

        $sql = <<<EOT
                with Q as
                (
                    select 
                        pk,
                        employees_pk,
                        type,
                        (select first_name ||' '||last_name from employees where pk = employees_pk) as employee,
                        date_created::timestamp(0) as date_created,
                        to_char(date_created, 'DD-Mon-YYYY<br/>HH12:MI:SS AM') as datecreated_html,
                        time_from::timestamp(0) as time_from,
                        to_char(time_from, 'DD-Mon-YYYY<br/>HH12:MI:SS AM') as timefrom_html,
                        time_to::timestamp(0) as time_to,
                        to_char(time_to, 'DD-Mon-YYYY<br/>HH12:MI:SS AM') as timeto_html,
                        (select status from daily_pass_slip_status where daily_pass_slip.pk = daily_pass_slip_status.daily_pass_slip_pk order by daily_pass_slip_status.date_created desc limit 1) as status,
                        (
                             select 
                            array_to_string(array_agg('<div>' || remarks || '</div> <div><span>' || date_created::timestamp(0) || '</span></div>'), '<hr />')
                            from daily_pass_slip_status 
                            where daily_pass_slip.pk = daily_pass_slip_status.daily_pass_slip_pk 
                            order by pk desc limit 1
                        ) as reason
                    from daily_pass_slip
                    where (time_from::date between '$date_from' and '$date_to' or time_to::date between '$date_from' and '$date_to')
                    and employees_pk in (select employees_pk from groupings where supervisor_pk = '$supervisor_pk')
                    and archived = false 
                    $where
                ),
                A as
                (
                    select
                        *
                    from Q where status = 'Pending'
                ),
                B as
                (
                    select
                        *
                    from Q
                    where  (
                            time_from::date between '$date_from' and '$date_to' 
                            or 
                            time_to::date between '$date_from' and '$date_to'
                        )
                        and status != 'Pending'
                        
                )
                select * from A union select * from B
                order by time_to desc
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function approved_dps($extra){
        foreach($extra as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $date_from = $extra['date_from'];
        $date_to = $extra['date_to'];

        $sql = <<<EOT
                with Q as
                (
                    select
                        pk,
                        employees_pk,
                        type,
                        time_from::timestamp(0) as time_from,
                        time_to::timestamp(0) as time_to,
                        date_created::timestamp(0) as date_created,
                        (select status from daily_pass_slip_status where daily_pass_slip_pk = daily_pass_slip.pk order by date_created desc limit 1) as status
                    from daily_pass_slip
                    where employees_pk = $this->employees_pk
                        and (time_from >= '$date_from 0000' and time_from <= '$date_to 2359' or time_to >= '$date_from 0000' and time_to <= '$date_to 2359')
                )
                select
                    pk,
                    employees_pk,
                    type,
                    time_from,
                    time_to,
                    status,
                    date_created
                from Q
                where status = 'Approved'
                ;
EOT;
        return ClassParent::get($sql);
    }

    public function fetch_all_dps($extra){
        foreach($extra as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $date_from = $extra['date_from'];
        $date_to = $extra['date_to'];

        $sql = <<<EOT
                with Q as
                (
                    select
                        pk,
                        employees_pk,
                        type,
                        time_from::timestamp(0) as time_from,
                        time_to::timestamp(0) as time_to,
                        date_created::timestamp(0) as date_created,
                        (select status from daily_pass_slip_status where daily_pass_slip_pk = daily_pass_slip.pk order by date_created desc limit 1) as status
                    from daily_pass_slip
                    where employees_pk = $this->employees_pk
                        and (time_from >= '$date_from 0000' and time_from <= '$date_to 2359' or time_to >= '$date_from 0000' and time_to <= '$date_to 2359')
                )
                select
                    pk,
                    employees_pk,
                    type,
                    time_from,
                    time_to,
                    status,
                    date_created
                from Q
                -- where status = 'Approved'
                ;
EOT;
        return ClassParent::get($sql);
    }
}

?>