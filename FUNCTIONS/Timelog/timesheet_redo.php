<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');
require_once('../../CLASSES/Leave.php');
require_once('../../CLASSES/ManualLog.php');

$data = array(
				"employees_pk" => $_POST['employees_pk'],
				"newdatefrom" => $_POST['newdatefrom'],
				"newdateto" => $_POST['newdateto']
			);

$startdate = $_POST['newdatefrom'];
$enddate = $_POST['newdateto'];
$cutoff=array();
while(strtotime($startdate) <= strtotime($enddate)){
	$date = date('Y-m-d', strtotime($startdate));
	$day = date('l', strtotime($startdate));

	$cutoff[$date] = array(
		"employee" => "",
		"employee_id" => "",
		"employees_pk" => "",
		"hrs" => "N/A",
		"log_date" => $date,
		"log_day" => $day,
		"login" => "",
		"logout" => "",
		"status" => "",
		"current_status" => ""
	);
	$data['date']=$date;
	
	$startdate = date('Y-m-d', strtotime($startdate . '+ 1 day'));
}

$employees_class = new Employees(
									md5($data['employees_pk']),
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

$employees_data = $employees_class->fetch_for_timesheet($data);

$employees=array();
foreach($employees_data['result'] as $key=>$value){

	$z = (array)json_decode($value['work_schedule']);
	
	$work_schedule = array();
	foreach ($z as $a => $b) {
		$b = (array) $b;

		if(count($b) > 0){
			$work_schedule[$a] = true;
		}
		else {
			$work_schedule[$a] = false;
		}
	}

	foreach ($cutoff as $k => $v) {
		$status = "Rest Day";
		if($work_schedule[strtolower($v['log_day'])]){
			$status = "Regular";
		}

		$cutoff[$k]['employee'] = $value['last_name'].", ".$value['first_name']. " ". $value['middle_name'];
		$cutoff[$k]['employee_id'] = $value['employee_id'];
		$cutoff[$k]['employees_pk'] = $value['pk'];
		//$cutoff[$k]['work_schedule'] = $work_schedule;
		$cutoff[$k]['status'] = $status;
		$cutoff[$k]['work_schedule'] = $z;
		//$cutoff[$k]['current_status'] = $value['current_status'];

	}

	$employees[$value['employee_id']] = $cutoff;
	//$employees[$value['employee_id']]['work_schedule'] = $z;
}

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

$date_range = array(
	"date_from" => $_POST['newdatefrom'],
	"date_to" => $_POST['newdateto']
);
$class2 = new Leave(
        				NULL,
        				$_POST['employees_pk'],
                        NULL,
                        NULL,
        				NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL
        			);

$data2 = $class2->approved_leaves($date_range);
$approved_leaves = $data2['result'];

$class3 = new ManualLog(
        				NULL,
        				$_POST['employees_pk'],
                        NULL,
                        NULL,
        				NULL,
        				NULL,
                        NULL
        			);

$data3 = $class3->pending_manuallogs($date_range);
$pending_manuallogs = $data3['result'];

foreach ($employees as $employee_id => $value) {
	foreach ($data['result'] as $k => $v) {
		//print_r($v);
		if($employee_id == $v['employee_id']){
			$value[$v['log_date']]['employee'] 		= $v['employee'];
			$value[$v['log_date']]['employee_id'] 	= $v['employee_id'];
			$value[$v['log_date']]['employees_pk'] 	= $v['employees_pk'];
			$value[$v['log_date']]['hrs'] 			= $v['hrs'];
			$value[$v['log_date']]['log_date'] 		= $v['log_date'];
			$value[$v['log_date']]['log_day'] 		= $v['log_day'];
			$value[$v['log_date']]['login'] 		= $v['log_in'];
			$value[$v['log_date']]['logout'] 		= $v['log_out'];
		}
	}

	$employees[$employee_id] = $value;
	
	foreach ($employees[$employee_id] as $x => $y) {
		
		foreach ($pending_manuallogs as $a => $b) {
			$z = explode(' ', $b['time_log']);
			
			if($y['employees_pk'] == $b['employees_pk'] && $y['log_date'] == $z[0]){

				if($b['type'] == "In"){
					$y['login'] = "Pending";
				}
				else {
					$y['logout'] = "Pending";
				}
			}
		}
		
		foreach ($approved_leaves as $a => $b) {
			//print_r($b);
			if($y['employees_pk'] == $b['employees_pk'] && $y['log_date'] >= $b['date_started'] && $y['log_date'] <= $b['date_ended']){
				$y['status'] = $b['name'];
				
				$y['login'] = $y['work_schedule'][trim(strtolower($y['log_day']))]->in;
				$y['logout'] = $y['work_schedule'][trim(strtolower($y['log_day']))]->out;
			}
		}

		// echo $y['login'];
		// echo "\n";
		// echo $y['logout'];
		// echo "\n";
		// echo $y['work_schedule'][trim(strtolower($y['log_day']))]->in;
		// echo "\n";
		// echo $y['work_schedule'][trim(strtolower($y['log_day']))]->out;
		// echo "\n";
		// echo "\n";

		$y['schedule'] = $y['work_schedule'][trim(strtolower($y['log_day']))]->in ." - ".$y['work_schedule'][trim(strtolower($y['log_day']))]->out;

		if($y['work_schedule'][trim(strtolower($y['log_day']))]->in && strtotime($y['login']) > strtotime($y['work_schedule'][trim(strtolower($y['log_day']))]->in)){
			//echo strtotime($y['login'])." - ".strtotime($y['work_schedule'][trim(strtolower($y['log_day']))]->in);
			$tardiness = (strtotime($y['login']) - strtotime($y['work_schedule'][trim(strtolower($y['log_day']))]->in.":00")) / 60;
			//
			$y['tardiness'] = $tardiness . " mins";
		}

		if($y['work_schedule'][trim(strtolower($y['log_day']))]->out && strtotime($y['logout']) < strtotime($y['work_schedule'][trim(strtolower($y['log_day']))]->out)){
			//echo strtotime($y['login'])." - ".strtotime($y['work_schedule'][trim(strtolower($y['log_day']))]->in);
			$undertime = (strtotime($y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00") - strtotime($y['logout'])) / 60;
			//
			$y['undertime'] = $undertime . " mins";
		}
		// foreach ($employees[$employee_id][$x] as $key => $value) {
		// 	//print_r($employees[$employee_id][$x][$key]);
		// 	//echo trim(strtolower($employees[$employee_id][$x]['log_day']));
		// 	//print_r($employees[$employee_id][$x]['work_schedule']);
		// 	print_r((array)$employees[$employee_id][$x]['work_schedule'][trim(strtolower($employees[$employee_id][$x]['log_day']))]);
		// 	echo "<hr />\n";

		// 	if($employees[$employee_id][$x][$key]['work_schedule'][trim(strtolower($y[$employees[$employee_id][$x][$key]['log_day']]))]){

		// 	}
		// }

		$employees[$employee_id][$x] = $y;
	}

	
}

//print_r($employees);

header("HTTP/1.0 500 Internal Server Error");
if($employees){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($employees));
?>