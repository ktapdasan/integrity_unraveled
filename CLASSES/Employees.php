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
                and accounts.employee_id = $empid
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
                    date_created::date as date,
                    date_created::time(0) as time
                from time_log
                where employees_pk = $pk
                order by date_created desc limit 1
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
                    date_created::date as date,
                    date_created::time(0) as time
                from time_log
                where employees_pk = $pk
                and date_created::date = '$today'
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
                select 
                    date_created::date as date,
                    (
                        case when type = 'In'
                        then date_created::time(0)
                        else date_created::time(0) end
                    ) as login,
                    (
                        case when type = 'Out'
                        then date_created::time(0)
                        else date_created::time(0) end
                    ) as logout
                from time_log
                where employees_pk = $pk
                and date_created between '$datefrom' and '$dateto'
                order by date_created
                ;
EOT;

        return ClassParent::get($sql);
    }

}
?>