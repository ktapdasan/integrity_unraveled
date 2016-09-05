<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');
require_once('../../CLASSES/Leave.php');
require_once('../../CLASSES/ManualLog.php');
require_once('../../CLASSES/Overtime.php');

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
		$cutoff[$k]['status'] = $status;
		$cutoff[$k]['work_schedule'] = $z;

	}

	$employees[$value['employee_id']] = $cutoff;
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

$class4 = new Overtime(
        				NULL,
                        NULL,
                        NULL,
        				$_POST['employees_pk'],
        				NULL,
                        NULL
        			);

$data4 = $class4->approved_overtimes($date_range);
$approved_overtimes = $data4['result'];


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
			$value[$v['log_date']]['login_time'] 	= date('h:i:s A', strtotime($v['log_in']));
			$value[$v['log_date']]['logout_time'] 	= date('h:i:s A', strtotime($v['log_out']));
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

		$y['schedule'] = $y['work_schedule'][trim(strtolower($y['log_day']))]->in ." - ".$y['work_schedule'][trim(strtolower($y['log_day']))]->out;

		if(
			$y['work_schedule'][trim(strtolower($y['log_day']))]->in && 
			$y['logout'] && 
			$y['logout'] != 'None' && 
			$y['logout'] != 'Pending' && 
			$y['login'] && 
			$y['login'] != 'None' && 
			$y['login'] != 'Pending' && 
			strtotime($y['login']) > strtotime(date('Y-m-d',strtotime($y['login'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->in.":00")
		){
			$tardiness = (strtotime($y['login']) - strtotime(date('Y-m-d',strtotime($y['login'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->in.":00")) / 60;
			$y['tardiness'] = round($tardiness) . " mins";
		}

		if(
			$y['work_schedule'][trim(strtolower($y['log_day']))]->out && 
			$y['logout'] && 
			$y['logout'] != 'None' && 
			$y['logout'] != 'Pending' && 
			$y['login'] && 
			$y['login'] != 'None' && 
			$y['login'] != 'Pending' && 
			strtotime($y['logout']) < strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00")
		){
			$undertime = (strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00") - strtotime($y['logout'])) / 60;
			$y['undertime'] = round($undertime) . " mins";
		}

		if(
			$y['logout'] && 
			$y['logout'] != 'None' && 
			$y['logout'] != 'Pending' && 
			$y['login'] && 
			$y['login'] != 'None' && 
			$y['login'] != 'Pending' && 
			strtotime($y['login']) <= strtotime(date('Y-m-d',strtotime($y['login'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->in.":00") &&
			strtotime($y['logout']) > strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00") &&
			(strtotime($y['logout']) - strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00")) >= 7200
		){

			$overtime = (strtotime($y['logout']) - strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00")) / 60;

			$y['overtime_value'] = round($overtime) . " mins";
			$y['overtime'] = 'false';

			foreach ($approved_overtimes as $a => $b) {
				//echo $y['employees_pk']." == ".$b['employees_pk']." && ".$y['log_date']." >= ".$b['datefrom']." && ".$y['log_date']." <= ".$b['dateto'];
				if($y['employees_pk'] == $b['employees_pk'] && $y['log_date'] >= $b['datefrom'] && $y['log_date'] <= $b['dateto']){
					$y['overtime'] = 'true';
				}
			}
		}

		$employees[$employee_id][$x] = $y;
	}

	
}

header("HTTP/1.0 500 Internal Server Error");
if($employees){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($employees));
?>