<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');

$data=array();
foreach($_GET as $k=>$v){
	$data[$k] = $v;
}

$class = new Employees($data);
$data = $class->employeelist($data);

$count=1;
$header=	'#,Employee ID, Employee Name, Log In, Log Out, # of Hours';
$body="";

foreach($data['result'] as $k=>$v){
	$body .= $count.','.
			$v['employee_id'].',"'.
			$v['employee'].'",'.
			$v['login'].',"'.
			$v['logout'].'",'.
			$v['hrs']."\n";

	$count++;
}

$filename = "EMPLOYEELIST_".date('Ymd_His').".csv";

header ("Content-type: application/octet-stream");
header ("Content-Disposition: attachment; filename=".$filename);
echo $header."\n".$body;
?>