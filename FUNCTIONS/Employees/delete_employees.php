<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');

$class = new Employees(
                            $_POST['pk'],
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            $_POST['date_created'],
                            NULL

			            );

print_r($_POST);


$info=json_decode($_POST['info'],true);




$info = array();
$info['last_day']=$_POST['last_day_work'];
$info['effective_date']=$_POST['effective_date'];
$info['reason']=$_POST['reason'];

$extra['supervisor_pk'] = $_POST['supervisor_pk'];



$data=$class->deactivate($info,$extra);



setcookie('commented', 'commented', time()+43200000, '/');

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
	header("HTTP/1.0 200 OK");
}                  

header('Content-Type: application/json');
print(json_encode($data));
?>