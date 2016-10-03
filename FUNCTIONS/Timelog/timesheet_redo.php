<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');
require_once('../../CLASSES/Leave.php');
require_once('../../CLASSES/ManualLog.php');
require_once('../../CLASSES/Overtime.php');
require_once('../../CLASSES/DailyPassSlip.php');
require_once('../../CLASSES/Holidays.php');
require_once('../../CLASSES/Suspension.php');
require_once('../../CLASSES/Default_values.php');

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
		
		$status = '<div class="holiday-blue">Rest Day</div>';
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
                        NULL,
                        NULL,
        				$_POST['employees_pk'],
        				NULL,
                        NULL
        			);

$data4 = $class4->filed_overtimes($date_range);
$filed_overtimes = $data4['result'];

$class5 = new DailyPassSlip(
                        NULL,
        				$_POST['employees_pk'],
        				NULL,
        				NULL,
                        NULL
        			);

$data5 = $class5->approved_dps($date_range);
$approved_dps = $data5['result'];

$class6 = new Holidays(
	                        NULL,
	        				NULL,
	        				NULL,
	        				NULL,
	                        NULL
	        			);

$data6 = $class6->get_active_holidays($date_range);
$holidays = $data6['result'];

$class7 = new Suspension(
	                        NULL,
	        				$_POST['newdatefrom'],
	        				$_POST['newdateto'],
	        				NULL,
	        				NULL,
	                        NULL
	        			);

$data7 = $class7->fetch(array('status'=>'Active'));
$suspension = $data7['result'];

$class8 = new Default_values(
	                        NULL,
	        				'working_hours',
	        				NULL,
	                        NULL
	        			);

$data8 = $class8->fetch();
$working_hours_data = $data8['result'][0]['details'];
$working_hours = (array)json_decode($working_hours_data);

$class9 = new Default_values(
	                        NULL,
	        				'overtime_leave',
	        				NULL,
	                        NULL
	        			);

$data9 = $class9->fetch();
$overtime_leave_data = $data9['result'][0]['details'];
$overtime_leave = (array)json_decode($overtime_leave_data);


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
			$value[$v['log_date']]['login_time'] 	= date('H:i:s', strtotime($v['log_in']));
			$value[$v['log_date']]['logout_time'] 	= date('H:i:s', strtotime($v['log_out']));
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
		
		//print($y['work_schedule'][trim(strtolower($y['log_day']))]->flexible);
		$y['schedule'] = $y['work_schedule'][trim(strtolower($y['log_day']))]->in ." - ".$y['work_schedule'][trim(strtolower($y['log_day']))]->out;

		//TARDINESS
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
			if($y['work_schedule'][trim(strtolower($y['log_day']))]->flexible == "false"){
				$tardiness = (strtotime($y['login']) - strtotime(date('Y-m-d',strtotime($y['login'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->in.":00")) / 60;
				$y['tardiness'] = round($tardiness) . " mins";
			}
		}

		// echo $y['login'];
		// echo $y['logout'];
		//UNDERTIME
		if(
			$y['work_schedule'][trim(strtolower($y['log_day']))]->out && 
			$y['logout'] && 
			$y['logout'] != 'None' && 
			$y['logout'] != 'Pending' && 
			$y['login'] && 
			$y['login'] != 'None' && 
			$y['login'] != 'Pending'
			
		){
			//strtotime($y['logout']) < strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00")
			$is_undertime=false;
			if(
				$y['work_schedule'][trim(strtolower($y['log_day']))]->flexible == "false" && 
				strtotime($y['logout']) < strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00")
			){
				$is_undertime=true;
			}

			if(
				$y['work_schedule'][trim(strtolower($y['log_day']))]->flexible == "true" && 
				(strtotime($y['hrs']) < strtotime($working_hours['hrs'] . ":00:00"))
			){
				$is_undertime=true;
			}			

			if($is_undertime){
				$hrs = $working_hours['hrs'];
				$mins = $working_hours['hrs'] * 60;
				
				$undertime = (strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00") - strtotime($y['logout'])) / 60;
				$y['undertime'] = round($undertime) . " mins";
			}
				
		}

		//OVERTIME
		if(
			$y['logout'] && 
			$y['logout'] != 'None' && 
			$y['logout'] != 'Pending' && 
			$y['login'] && 
			$y['login'] != 'None' && 
			$y['login'] != 'Pending'
		){
			//ALLOW TARDY == TRUE
			//there is no need to check if the employee came in earlier than schedule
			if(
				$overtime_leave['allow_tardy'] == "true"
			){
				//$overtime = strtotime($y['hrs']) - strtotime($working_hours['hrs'] . ":00:00");

				//if not flexible, employee login should be <= sched log in
				//and logout should be >= sched log out and total mins of overtime must be >= 7200
				if(
					$y['work_schedule'][trim(strtolower($y['log_day']))]->flexible == "false" &&
					strtotime($y['login']) <= strtotime(date('Y-m-d',strtotime($y['login'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->in.":00") &&
					strtotime($y['logout']) > strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00") &&
					(strtotime($y['logout']) - strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00")) >= 7200
				){
					$overtime = (strtotime($y['logout']) - strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00"));
					
					$z = round($overtime) / 60;
					$z = $z / 4;
					
					$whole = floor($z);
					$fraction = (float)$z - (int)$whole;
						
					$overtime = ((int)$whole * 3) + (4 * (float)$fraction);

					$y['overtime_value'] = $overtime . " hrs";
					$y['overtime'] = 'false';

					foreach ($filed_overtimes as $a => $b) {
						if($y['employees_pk'] == $b['employees_pk'] && $y['log_date'] >= $b['datefrom'] && $y['log_date'] <= $b['dateto']){
							$y['overtime'] = $b['status'];
						}
					}
				}
				//if flexible, overtime is equals to total # of hrs minus default working hrs
				else if(
					$y['work_schedule'][trim(strtolower($y['log_day']))]->flexible == "true" &&
					(strtotime($y['hrs']) - strtotime($working_hours['hrs'] . ":00:00")) >= 7200
				){
					// echo $y['hrs'];
					// echo "\n";
					$overtime = strtotime($y['hrs']) - strtotime($working_hours['hrs'] . ":00:00");

					$z = round($overtime) / 60;
					$z = $z / 4;
					
					$whole = floor($z);
					$fraction = (float)$z - (int)$whole;
						
					$overtime = ((int)$whole * 3) + (4 * (float)$fraction);

					$y['overtime_value'] = $overtime . " hrs";
					$y['overtime'] = 'false';

					foreach ($filed_overtimes as $a => $b) {
						if($y['employees_pk'] == $b['employees_pk'] && $y['log_date'] >= $b['datefrom'] && $y['log_date'] <= $b['dateto']){
							$y['overtime'] = $b['status'];
						}
					}
				}
				
				
				// if($overtime >= 7200){
				// 	$z = round($overtime) / 60;
				// 	$z = $z / 4;
					
				// 	$whole = floor($z);
				// 	$fraction = (float)$z - (int)$whole;
						
				// 	$overtime = ((int)$whole * 3) + (4 * (float)$fraction);

				// 	$y['overtime_value'] = $overtime . " hrs";
				// 	$y['overtime'] = 'false';

				// 	foreach ($filed_overtimes as $a => $b) {
				// 		if($y['employees_pk'] == $b['employees_pk'] && $y['log_date'] >= $b['datefrom'] && $y['log_date'] <= $b['dateto']){
				// 			$y['overtime'] = $b['status'];
				// 		}
				// 	}
				// }
			}
			else {

			}

			


			// if(
			// 	$y['work_schedule'][trim(strtolower($y['log_day']))]->flexible == "false" &&
			// 	strtotime($y['login']) <= strtotime(date('Y-m-d',strtotime($y['login'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->in.":00") &&
			// 	strtotime($y['logout']) > strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00") &&
			// 	(strtotime($y['logout']) - strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00")) >= 7200
			// ){
			// 	$overtime = (strtotime($y['logout']) - strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00")) / 60;

			// 	//compute overtime number of hours
			// 	//$overtime is the difference between actual log out and scheduled log out
			// 	//situation: for every 3 hrs the next 1 hr will be considered as break.
			// 	//in this equation we round off the overtime (currently in minutes)
			// 	//divide by 60 to get the # of hours
			// 	//divide by 4 because for every 4 hrs we have 3 valid hrs
			// 	//the result will be multiplied to 3 to get the actual # of hrs
			// 	//for example:
			// 	//6 hrs of overtime will divided by 4 = 1.5
			// 	//1 * 3 = 3
			// 	//we now have 3 valid overtime hrs
			// 	//the remainder will be converted and treated as percentage
			// 	//since we are dividing by 4, the remainders are only limited to .25, .5, .75 and 0
			// 	//.25 = 1 hr
			// 	//.5 = 2 hrs
			// 	//.75 = 3 hrs
			// 	//in this case we have 3 valid hrs + 2
			// 	//the total overtime hrs is 5

			// 	$z = round($overtime) / 60;
			// 	$z = $z / 4;
				
			// 	$whole = floor($z);
			// 	$fraction = (float)$z - (int)$whole;
					
			// 	$overtime = ((int)$whole * 3) + (4 * (float)$fraction);

			// 	$y['overtime_value'] = $overtime . " hrs";
			// 	$y['overtime'] = 'false';

			// 	foreach ($filed_overtimes as $a => $b) {
			// 		if($y['employees_pk'] == $b['employees_pk'] && $y['log_date'] >= $b['datefrom'] && $y['log_date'] <= $b['dateto']){
			// 			$y['overtime'] = $b['status'];
			// 		}
			// 	}
			// }
			// else {
				
				
			// }	
		}



		
		foreach ($approved_dps as $a => $b) {
			if($y['employees_pk'] == $b['employees_pk'] && $y['log_date'] == date('Y-m-d', strtotime($b['time_from']))){
				$y['dps'] = date('H:i', strtotime($b['time_from']))." - ".date('H:i', strtotime($b['time_to']));
			}
		}

		foreach ($holidays as $a => $b) {
			if($y['log_date'] == date('Y-m-d', strtotime($b['datex']))){
				$y['status'] = '<div class="holiday-yellow">'. $b['name'] . '</div>';
				
				if(!$y['login'] && !$y['logout'] && !empty($y['work_schedule'][trim(strtolower($y['log_day']))]->in) && !empty($y['work_schedule'][trim(strtolower($y['log_day']))]->out)){
					$y['login'] = $y['work_schedule'][trim(strtolower($y['log_day']))]->in.":00";
					$y['login_time'] = $y['work_schedule'][trim(strtolower($y['log_day']))]->in.":00";

					$y['logout'] = $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00";
					$y['logout_time'] = $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00";

					$y['hrs'] = '09:00:00';
				}
			}
		}

		foreach ($suspension as $a => $b) {
			if($y['log_date'] >= date('Y-m-d', strtotime($b['time_from'])) && $y['log_date'] <= date('Y-m-d', strtotime($b['time_to']))){
				
				//change if actual date is > suspension start date
				if($y['log_date'] > date('Y-m-d', strtotime($b['time_from']))){
					$b['time_from'] = $y['work_schedule'][trim(strtolower($y['log_day']))]->in.":00";
				}

				//change if actual date is < suspension end date
				if($y['log_date'] < date('Y-m-d', strtotime($b['time_to']))){
					$b['time_to'] = $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00";
				}

				//default values
				$y['suspension'] = date('H:i', strtotime($b['time_from'])). " - " .date('H:i', strtotime($b['time_to']));
			}
		}

		foreach ($approved_leaves as $a => $b) {
			//print_r($b);
			if($y['employees_pk'] == $b['employees_pk'] && $y['log_date'] >= $b['date_started'] && $y['log_date'] <= $b['date_ended']){
				$y['status'] = $b['name'];
				
				$y['login'] = $y['work_schedule'][trim(strtolower($y['log_day']))]->in.":00";
				$y['login_time'] = $y['work_schedule'][trim(strtolower($y['log_day']))]->in.":00";
				$y['logout'] = $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00";
				$y['logout_time'] = $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00";

				$y['hrs'] = '09:00:00';
				$y['tardiness'] = "";
				$y['undertime'] = "";
				$y['overtime'] = "";
				$y['dps'] = "";
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