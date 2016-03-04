<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');

$data=array();
foreach($_GET as $k=>$v){
	$data[$k] = $v;
}

$class = new Employees($data);
$data = $class->timelogs($data);
// echo "<pre>";
// print_r($data);
// exit();
$count=1;
$header=	'Employee ID, Employee Name, Date, Day, Time, Type';
$body="";

foreach($data['result'] as $k=>$v){
	$body .= 
			$v['employee_id'].',"'.
			$v['employee'].'","'.
			$v['log_date'].'","'.
			$v['log_day'].'",'.
			$v['log_time'].','.
			$v['log_type']."\n";

	$count++;
}

$filename = "TIMELOGS_".date('Ymd_His').".csv";

header ("Content-type: application/octet-stream");
header ("Content-Disposition: attachment; filename=".$filename);
echo $header."\n".$body;
?>