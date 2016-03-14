<?php
require_once('../../CLASSES/ClassParent.php');
class Employees extends ClassParent {

    var $pk = NULL;
    var $employee_id = NULL;
    var $first_name = NULL;
    var $middle_name = NULL;
    var $last_name = NULL;
    var $email_address = NULL;
    var $archived = NULL;

    public function __construct(
                                    $pk,
                                    $employee_id,
                                    $first_name,
                                    $middle_name,
                                    $last_name,
                                    $email_address,
                                    $archived
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

    public function auth($post){
        $empid = pg_escape_string(strip_tags(trim($post['empid'])));
        $password = pg_escape_string(strip_tags(trim($post['password'])));

        $sql = <<<EOT
                select 
                    employees.*
                from accounts
                left join employees on (accounts.employee_id = employees.employee_id)
                where employees.archived = false
                and accounts.employee_id = '$empid'
                and accounts.password = md5('$password')
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function fetch($post){
        $title = pg_escape_string(strip_tags(trim($post['title'])));

        $sql = <<<EOT
                with A as
                (
                    select 
                        employees.pk,
                        employees.employee_id,
                        employees.first_name,
                        employees.middle_name,
                        employees.last_name,
                        employees.email_address,
                        employees_titles.title_pk
                    from employees
                    left join employees_titles on (employees.pk = employees_titles.employees_pk)
                    where employees.archived = false
                )
                select
                    *
                from A
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function profile(){
        $sql = <<<EOT
                select 
                    pk,
                    employee_id,
                    first_name,
                    middle_name,
                    last_name,
                    email_address
                from employees
                where archived = false
                and md5(pk::text) = '$this->pk'
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function last_log($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $pk = $data['pk'];
        $sql = <<<EOT
                select 
                    employees_pk,
                    type,
                    time_log::date as date,
                    time_log::time(0) as time,
                    date_created
                from time_log
                where employees_pk = $pk
                order by time_log desc limit 1
                ;
EOT;

        return ClassParent::get($sql);   
    }

    public function log_today($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $today = date('Y-m-d');
        $pk = $data['pk'];
        $sql = <<<EOT
                select 
                    employees_pk,
                    type,
                    time_log::date as date,
                    time_log::time(0) as time,
                    date_created
                from time_log
                where employees_pk = $pk
                and time_log::date = '$today'
                order by date_created desc limit 1
                ;
EOT;

        return ClassParent::get($sql);   
    }

    public function submit_log($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $pk = $data['employees_pk'];
        $type = $data['type'];

        $sql = <<<EOT
                insert into time_log
                (
                    employees_pk,
                    type
                )
                values
                (
                    $pk,
                    '$type'
                )
                ;
EOT;

        return ClassParent::insert($sql);   
    }

    public function timesheet($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $datefrom = $data['datefrom'];
        $dateto = $data['dateto'];
        $pk = $data['pk'];

        $sql = <<<EOT
                with Q as
                (
                    select
                        employees_pk,
                        (select employee_id from employees where pk = employees_pk) as employee_id,
                        (select first_name ||' '|| middle_name ||' '|| last_name from employees where pk = employees_pk) as employee,
                        type,
                        time_log::date as log_date,
                        time_log::time(0) as log_time,
                        date_created
                    from time_log
                    where employees_pk = $pk
                    and time_log::date between '$datefrom' and '$dateto'
                )
                select
                    employees_pk,
                    employee_id,
                    employee,
                    log_date,
                    to_char(log_date, 'Day') as log_day,
                    (
                        coalesce((select
                            min(log_time)
                        from Q where Q.employees_pk = logs.employees_pk
                        and Q.log_date = logs.log_date and Q.type = 'In')::text,'None')
                    ) as login,
                    (
                        coalesce((select
                            min(log_time)
                        from Q where Q.employees_pk = logs.employees_pk
                        and Q.log_date = logs.log_date and Q.type = 'Out')::text,'None')
                    ) as logout,
                    coalesce(((
                        select
                            min(log_time)
                        from Q where Q.employees_pk = logs.employees_pk
                        and Q.log_date = logs.log_date and Q.type = 'Out'
                    ) -
                    (
                        select
                            min(log_time)
                        from Q where Q.employees_pk = logs.employees_pk
                        and Q.log_date = logs.log_date and Q.type = 'In'
                    ))::text,'N/A') as hrs
                from Q as logs
                group by employees_pk, employee, employee_id, log_date, log_day
                order by logs.log_date
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function timelogs($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $where='';
        if($data['employees_pk']){
            $where .= "and employees_pk = ". $data['employees_pk']; 
        }

        $datefrom = $data['datefrom'];
        $dateto = $data['dateto'];

        $sql = <<<EOT
                with Q as
                (
                    select
                        employees_pk,
                        (select employee_id from employees where pk = employees_pk) as employee_id,
                        (select last_name ||', '|| first_name ||' '|| middle_name from employees where pk = employees_pk) as employee,
                        type,
                        time_log::date as log_date,
                        time_log::time(0) as log_time,
                        date_created
                    from time_log
                    where time_log::date between '$datefrom' and '$dateto'
                    $where
                )
                select
                    employees_pk,
                    employee_id,
                    employee,
                    log_date,
                    to_char(log_date, 'dd-Mon-YYYY') as log_date2,
                    to_char(log_date, 'Day') as log_day,
                    (
                        coalesce((select
                            min(log_time)
                        from Q where Q.employees_pk = logs.employees_pk
                        and Q.log_date = logs.log_date and Q.type = 'In')::text,'None')
                    ) as log_in,
                    (
                        coalesce((select
                            min(log_time)
                        from Q where Q.employees_pk = logs.employees_pk
                        and Q.log_date = logs.log_date and Q.type = 'Out')::text,'None')
                    ) as log_out,
                    coalesce(((
                        select
                            min(log_time)
                        from Q where Q.employees_pk = logs.employees_pk
                        and Q.log_date = logs.log_date and Q.type = 'Out'
                    ) -
                    (
                        select
                            min(log_time)
                        from Q where Q.employees_pk = logs.employees_pk
                        and Q.log_date = logs.log_date and Q.type = 'In'
                    ))::text,'N/A') as hrs
                from Q as logs
                group by employees_pk, employee, employee_id, log_date
                order by logs.log_date,logs.employee
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function change_password($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $employee_id = $data['employee_id'];
        $old_password = $data['old_password'];
        $password = md5($data['new_password']);

        $sql = <<<EOT
                update accounts set
                (password)
                =
                ('$password')
                where employee_id = '$employee_id'
                and password = md5('$old_password')
                ;
EOT;

        return ClassParent::update($sql);
    }

    public function submit_comment($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $tool = $data['tool'];
        $feedback = $data['feedback'];

        $sql = <<<EOT
                insert into feedbacks
                (
                    feedback,
                    tool
                )
                values
                (
                    '$feedback',
                    '$tool'
                );
EOT;

        return ClassParent::insert($sql);
    }

}

/*
select
                            case when logs.type = 'In' then
                            min(log_time)
                            else max(log_time) end
                        from Q where Q.employees_pk = logs.employees_pk
                        and Q.log_date = logs.log_date and Q.type = 'In'
                    ) as log_time,
*/
?>