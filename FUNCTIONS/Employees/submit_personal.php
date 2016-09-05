<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');
//require_once('../../CLASSES/PHPMailerAutoload.php');

$class = new Employees(
    NULL,
    $_POST['employee_id'],
    $_POST['first_name'],
    $_POST['middle_name'],
    $_POST['last_name'],
    $_POST['email_address'],
    NULL,
    NULL,
    NULL
    );

//Personal Array!
$personal = array();
$personal['civilstatus']             = pg_escape_string(strip_tags(trim($_POST['civilstatus'])));
$personal['first_name']              = pg_escape_string(strip_tags(trim($_POST['first_name'])));
$personal['middle_name']             = pg_escape_string(strip_tags(trim($_POST['middle_name'])));
$personal['last_name']               = pg_escape_string(strip_tags(trim($_POST['last_name'])));
$personal['gender']                  = pg_escape_string(strip_tags(trim($_POST['gender'])));
$personal['religion']                = pg_escape_string(strip_tags(trim($_POST['religion'])));
$personal['email_address']           = pg_escape_string(strip_tags(trim($_POST['email_address'])));

$details = array();//Details Array
$details['personal'] = $personal; //Declared!

$extra['details'] = $details; //Declared!

$data = $class-> createp($extra);

setcookie('commented', 'commented', time()+43200000, '/');

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
    header("HTTP/1.0 200 OK");
}                  

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 