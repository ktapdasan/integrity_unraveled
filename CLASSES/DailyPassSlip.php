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

    public function fetch($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $date_from = $data['date_from'];
        $date_to = $data['date_to'];

        if($data['status'] == "Active"){
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
                        (select first_name ||' '||last_name from employees where pk = employees_pk) as employee,
                        time_from::timestamp(0) as time_from,
                        time_to::timestamp(0) as time_to,
                        date_created::timestamp(0) as date_created,
                        (select status from daily_pass_slip_status where daily_pass_slip.pk = daily_pass_slip_status.daily_pass_slip_pk order by pk desc limit 1) as status,
                        (
                            select 
                                array_to_string(array_agg('<div>' || remarks || '</div> <div><span>' || date_created::timestamp(0) || '</span></div>'), '<br />')
                            from daily_pass_slip_status 
                            where daily_pass_slip.pk = daily_pass_slip_status.daily_pass_slip_pk 
                            order by pk desc
                        ) as reason
                    from daily_pass_slip
                    where archived = $status
                )
                select
                    pk,
                    employees_pk,
                    employee,
                    time_from,
                    time_to,
                    date_created,
                    status,
                    reason
                from Q
                where (time_from >= '$date_from 0000' and time_from <= '$date_to 2359' or time_to >= '$date_from 0000' and time_to <= '$date_to 2359')
                    and employees_pk = $this->employees_pk
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function myemployees_fetch($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $date_from = $data['date_from'];
        $date_to = $data['date_to'];

        if($data['status'] == "Active"){
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
                        (select first_name ||' '||last_name from employees where pk = employees_pk) as employee,
                        time_from::timestamp(0) as time_from,
                        time_to::timestamp(0) as time_to,
                        date_created::timestamp(0) as date_created,
                        (select status from daily_pass_slip_status where daily_pass_slip.pk = daily_pass_slip_status.daily_pass_slip_pk order by pk desc limit 1) as status,
                        (
                            select 
                                remarks || ' <br /> ' || date_created::timestamp(0)
                            from daily_pass_slip_status 
                            where daily_pass_slip.pk = daily_pass_slip_status.daily_pass_slip_pk 
                            order by pk desc
                        ) as reason
                    from daily_pass_slip
                    where archived = $status
                )
                select
                    pk,
                    employees_pk,
                    employee,
                    time_from,
                    time_to,
                    date_created,
                    status,
                    reason
                from Q
                where (time_from >= '$date_from 0000' and time_from <= '$date_to 2359' or time_to >= '$date_from 0000' and time_to <= '$date_to 2359')
                    and employees_pk in (select employees_pk from groupings where supervisor_pk = $this->employees_pk)
                ;
EOT;

        return ClassParent::get($sql);
    }

    
}

?>