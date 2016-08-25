<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');

$class =    new Employees(
                            $_POST['pk'],
                            $_POST['employee_id'],
                            $_POST['first_name'],
                            $_POST['middle_name'],
                            $_POST['last_name'],
                            $_POST['email_address'],
                            $_POST['business_email_address'],
                            $_POST['titles_pk'],
                            $_POST['levels_pk'],
                            $_POST['departments_pk'],
                            NULL,
                            NULL,
                            NULL
      );

$company = array();
$personal = array();

if ($_POST['levels_pk'] == 3){
    $company['levels_pk']              = pg_escape_string(strip_tags(trim($_POST['levels_pk'])));
    $company['hours']                  = pg_escape_string(strip_tags(trim($_POST['intern_hours'])));
    $company['titles_pk']              = pg_escape_string(strip_tags(trim($_POST['titles_pk'])));
    $company['email_address']          = pg_escape_string(strip_tags(trim($_POST['email_address'])));
    $company['business_email_address'] = pg_escape_string(strip_tags(trim($_POST['business_email_address'])));
    $company['departments_pk']         = pg_escape_string(strip_tags(trim($_POST['departments_pk'])));
    $company['supervisor']             = pg_escape_string(strip_tags(trim($_POST['supervisor_pk'])));

    $personal['first_name']            = pg_escape_string(strip_tags(trim($_POST['first_name'])));
    $personal['middle_name']           = pg_escape_string(strip_tags(trim($_POST['middle_name'])));
    $personal['last_name']             = pg_escape_string(strip_tags(trim($_POST['last_name'])));
}
else{
    $company['levels_pk']              = pg_escape_string(strip_tags(trim($_POST['levels_pk'])));
    $company['titles_pk']              = pg_escape_string(strip_tags(trim($_POST['titles_pk'])));
    $company['email_address']          = pg_escape_string(strip_tags(trim($_POST['email_address'])));
    $company['business_email_address'] = pg_escape_string(strip_tags(trim($_POST['business_email_address'])));
    $company['departments_pk']         = pg_escape_string(strip_tags(trim($_POST['departments_pk'])));
    $company['supervisor']             = pg_escape_string(strip_tags(trim($_POST['supervisor_pk'])));

    $personal['first_name']            = pg_escape_string(strip_tags(trim($_POST['first_name'])));
    $personal['middle_name']           = pg_escape_string(strip_tags(trim($_POST['middle_name'])));
    $personal['last_name']             = pg_escape_string(strip_tags(trim($_POST['last_name'])));
}

$details = array();

$details['company'] = $company;
$details['personal'] = $personal;

$extra['details'] = $details;
$extra['supervisor_pk'] = $_POST['supervisor_pk'];
$data = $class -> update_employees($extra);

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
    header("HTTP/1.0 200 OK");
}                  

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 