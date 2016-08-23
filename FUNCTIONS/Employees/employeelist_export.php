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
$header=	'#,Employee ID,First Name,Middle Name,Last Name,E-mail Address,Business E-mail Address,Position,Level,Department';
$body="";

foreach($data['result'] as $k=>$v){

	$body .= $count.','.
			$v['employee_id'].','.
			$v['first_name'].','.
			$v['middle_name'].','.
			$v['last_name'].','.
			$v['email_address'].','.
			$v['business_email_address'].','.
			$v['titles_pk'].','.
			$v['levels_pk'].','.
			$v['department']."\n";

	$count++;
}

$filename = "EMPLOYEELIST_".date('Ymd_His').".csv";

header ("Content-type: application/octet-stream");
header ("Content-Disposition: attachment; filename=".$filename);
echo $header."\n".$body;
?>