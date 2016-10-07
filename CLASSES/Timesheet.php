<?php
require_once('../../CLASSES/ClassParent.php');
class Timesheet extends ClassParent {

    var $pk            = NULL;
	var $employees_pk  = NULL;
	var $cutoff        = NULL;
    var $datex         = NULL;
    var $schedule      = NULL;
    var $login         = NULL;
    var $logout        = NULL;
    var $hrs           = NULL;
    var $tardiness     = NULL;
    var $undertime     = NULL;
    var $overtime      = NULL;
    var $dps           = NULL;
    var $suspension    = NULL;
	var $status        = NULL;


	public function __construct(
                                    $pk,
                                    $employees_pk,
    								$cutoff,
                                    $datex,
                                    $schedule,
                                    $login,
                                    $logout,
    								$hrs,
                                    $tardiness,
                                    $undertime,
                                    $overtime,
                                    $dps,
                                    $suspension,
                                    $status
                                ){
        
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

    public function count(){
        $sql = <<<EOT
            with Q as
            (
                select
                    employees_pk
                from timesheet where cutoff = '$this->cutoff'
                group by employees_pk
            )
            select count(employees_pk) from Q
            ;
EOT;

        return ClassParent::get($sql);
    }

    public function list($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }
        
        $order = $data['order'];

        if($data['column'] == 'Employee Name'){
            $col = "employees.details->'personal'->'last_name' ".$order.", employees.details->'personal'->'first_name' ".$order.", employees.details->'personal'->'middle_name' ".$order;
        }
        else if($data['column'] == 'Employee ID'){
            $col = "employees.employee_id ".$order;
        }
        else if($data['column'] == 'Gross'){
            $col = "employees.details->'company'->'salary'->'details'->'amount' ".$order;
        }

        $sql = <<<EOT
            with Q as
            (
                select
                    employees_pk,
                    coalesce(sum(hrs), 0) as hrs,
                    coalesce(sum(tardiness), 0) as tardiness,
                    coalesce(sum(undertime), 0) as undertime,
                    coalesce(sum(overtime), 0) as overtime,
                    0 as dps,
                    count(*) as days,
                    sum(case when status = 'Absent' then 1 else 0 end) as absent,
                    array_agg(EXTRACT(WEEK FROM datex::date)) as week_num
                from timesheet where cutoff = '$this->cutoff'
                group by employees_pk
            )
            select 
                employees_pk,
                employees.employee_id,
                employees.details,
                (select type from rate_types where rate_types.pk = cast(employees.details->'company'->'salary'->>'rate_types_pk' as integer)) as rate_type,
                (select period from pay_periods where pay_periods.pk = cast(employees.details->'company'->'salary'->>'pay_periods_pk' as integer)) as pay_period,
                Q.hrs,
                Q.tardiness,
                Q.undertime,
                Q.overtime,
                Q.dps,
                Q.days,
                absent,
                week_num
            from Q
            left join employees on (Q.employees_pk = employees.pk)
            order by $col
            ;
EOT;

        return ClassParent::get($sql);
    }

    public function accept($data){
        $sql = "begin;";
        $sql .= <<<EOT
                insert into timesheet
                (
                    employees_pk,
                    cutoff,
                    datex,
                    schedule,
                    login,
                    logout,
                    hrs,
                    tardiness,
                    undertime,
                    overtime,
                    dps,
                    suspension,
                    status
                )
                values
EOT;

        $values=array();
        foreach ($data as $key => $value) {
            $z = json_decode($value);
            
            $z->login_time = $this->checkstr($z->login_time);
            $z->logout_time = $this->checkstr($z->logout_time);

            $z->hrs = $this->checknum($z->hrs);
            $z->tardiness = $this->checknum($z->tardiness);
            $z->undertime = $this->checknum($z->undertime);

            if($z->overtime_status == "Approved"){
                $z->overtime = $this->checknum($z->overtime);
            }
            else {
                $z->overtime = 'null';
            }
            
            if($z->dps == "Approved"){
                $z->dps = "'".$this->checknum($z->dps)."'";
            }
            else {
                $z->dps = 'null';
            }

            if($z->schedule != 'No Schedule'){
                $value = <<<EOT
                        (
                            $z->employees_pk,
                            '$z->cutoff',
                            '$z->datex',
                            '$z->schedule',
                            $z->login_time,
                            $z->logout_time,
                            $z->hrs,
                            $z->tardiness,
                            $z->undertime,
                            $z->overtime,
                            $z->dps,
                            '$z->suspension',
                            '$z->status'
                        )
EOT;
                array_push($values, $value);
            }
        }

        $sql .= implode(',', $values);

        $sql .= ";commit;";

        return ClassParent::insert($sql);
    }

    private function checknum($z){
        if($z){
            return $z;
        }
        else {
            return 'null';
        }
    }

    private function checkstr($z){
        if($z){
            return "'".$z."'";
        }
        else {
            return 'null';
        }
    }
}
?>