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
$header=	'Employee ID, Employee Name, Day, Date, Time, Type';
$body="";

foreach($data['result'] as $k=>$v){
	if($v['log_in']=='None'){
		$v['log_in']='';
	}

	if($v['log_out']=='None'){
		$v['log_out']='';
	}

	//login
	$body .= 
			$v['employee_id'].',"'.
			$v['employee'].'","'.
			$v['log_day'].'","'.
			$v['log_date2'].'",'.
			$v['log_in'].','.
			"In\n";
	//logout
	$body .= 
			$v['employee_id'].',"'.
			$v['employee'].'","'.
			$v['log_day'].'","'.
			$v['log_date2'].'",'.
			$v['log_out'].','.
			"Out\n";

	$count++;
}

$filename = "TIMELOGS_".date('Ymd_His').".csv";

header ("Content-type: application/octet-stream");
header ("Content-Disposition: attachment; filename=".$filename);
echo $header."\n".$body;
?>