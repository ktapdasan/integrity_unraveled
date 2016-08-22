<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');
require_once('../../CLASSES/Leave.php');

echo "<pre />";

$stop_date="";
$startdate = $_GET['datefrom'];
$enddate = $_GET['dateto'];

$cutoff=array();
$cutoff_count=0;
while(strtotime($startdate) <= strtotime($enddate)){
	$cutoff_count++;
	$date = date('Y-m-d', strtotime($startdate));
	$day = date('l', strtotime($startdate));

	array_push($cutoff, array(
		"employee" => "",
		"employee_id" => "",
		"employees_pk" => "",
		"hrs" => "N/A",
		"log_date" => $date,
		"log_day" => $day,
		"login" => "",
		"logout" => "",
		"status" => ""
	));
	
	$startdate = date('Y-m-d', strtotime($startdate . '+ 1 day'));
}

$data = array(
				"pk" => $_GET['pk'],
				"employees_pk" => $_GET['employees_pk'],
				"datefrom" => $_GET['datefrom'],
				"dateto" => $_GET['dateto']
			);

$class = new Employees(
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL
						);

$data = $class->timelogs($data);

$class2 = new Leave(
        				NULL,
        				$_GET['employees_pk'],
                        NULL,
                        NULL,
        				NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL
        			);

$data2 = $class2->approved_leaves();
$approved_leaves = $data2['result'];

// echo "<pre>";
// print_r($data);
// exit();
$count=1;
$header=	'Employee ID, Employee Name, Day, Date, Time, Type';
$body="";

$timesheet=array();
foreach($data['result'] as $k=>$v){
	//$v['work_schedule'] = (array) json_decode($v['work_schedule']);
	//print_r($v);
	for($i=0;$i<$cutoff_count;$i++){
		//print_r($cutoff[$i]);

		if($cutoff[$i]['log_date'] == $v['log_date']){
			$cutoff[$i]['employee'] = $v['employee'];
			$cutoff[$i]['employee_id'] = $v['employee_id'];
			$cutoff[$i]['employees_pk'] = $v['employees_pk'];
			$cutoff[$i]['hrs'] = $v['hrs'];
			$cutoff[$i]['log_date'] = $v['log_date'];
			$cutoff[$i]['log_day'] = $v['log_day'];
			$cutoff[$i]['login'] = $v['log_in'];
			$cutoff[$i]['logout'] = $v['log_out'];
			$cutoff[$i]['status'] = "";
		}

		// if($cutoff[$i]['log_date'] == $v['log_date']){
		// 	$timesheet[$v['employee_id']][$i]['employee'] = $v['employee'];
		// 	$timesheet[$v['employee_id']][$i]['employee_id'] = $v['employee_id'];
		// 	$timesheet[$v['employee_id']][$i]['employees_pk'] = $v['employees_pk'];
		// 	$timesheet[$v['employee_id']][$i]['hrs'] = "";
		// 	$timesheet[$v['employee_id']][$i]['login'] = $v['log_in'];
		// 	$timesheet[$v['employee_id']][$i]['log_date'] = $cutoff[$i]['log_date'];
		// 	$timesheet[$v['employee_id']][$i]['log_day'] = $cutoff[$i]['log_day'];
		// 	$timesheet[$v['employee_id']][$i]['login'] = $v['log_in'];
		// 	$timesheet[$v['employee_id']][$i]['logout'] = $v['log_out'];
		// 	$timesheet[$v['employee_id']][$i]['status'] = "";
		// }
		// else {
		// 	$timesheet[$v['employee_id']][$i]['employee'] = "";
		// 	$timesheet[$v['employee_id']][$i]['employee_id'] = "";
		// 	$timesheet[$v['employee_id']][$i]['employees_pk'] = "";
		// 	$timesheet[$v['employee_id']][$i]['hrs'] = "";
		// 	$timesheet[$v['employee_id']][$i]['login'] = "";
		// 	$timesheet[$v['employee_id']][$i]['log_date'] = $cutoff[$i]['log_date'];
		// 	$timesheet[$v['employee_id']][$i]['log_day'] = $cutoff[$i]['log_day'];
		// 	$timesheet[$v['employee_id']][$i]['login'] = "";
		// 	$timesheet[$v['employee_id']][$i]['logout'] = "";
		// 	$timesheet[$v['employee_id']][$i]['status'] = "";
		// }

		//$timesheet[$v['employee_id']] = $cutoff;	
	}
	array_push($timesheet, $cutoff);

	

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

print_r($timesheet);
// $filename = "TIMELOGS_".date('Ymd_His').".csv";

// header ("Content-type: application/octet-stream");
// header ("Content-Disposition: attachment; filename=".$filename);
echo $header."\n".$body;
?>