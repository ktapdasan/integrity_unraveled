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

$date_range = array(
	"date_from" => $_POST['newdatefrom'],
	"date_to" => $_POST['newdateto']
);

//fetch all employees.. if accessed using HRIS > Timelogs 
//no employees_pk will be passed here, hence all employees will be fetched

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

$class2 = new Leave(
        				NULL,
        				$data['employees_pk'],
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
        				$data['employees_pk'],
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
        				$data['employees_pk'],
        				NULL,
                        NULL
        			);

$data4 = $class4->filed_overtimes($date_range);
$filed_overtimes = $data4['result'];

$class5 = new DailyPassSlip(
                        NULL,
        				$data['employees_pk'],
        				NULL,
        				NULL,
                        NULL
        			);

$data5 = $class5->fetch_all_dps($date_range);
$all_dps = $data5['result'];

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
	        				$data['newdatefrom'],
	        				$data['newdateto'],
	        				NULL,
	        				NULL,
	                        'false'
	        			);

$data7 = $class7->fetch_all();
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

$class10 = new Default_values(
	                        NULL,
	        				'multiple_logs',
	        				NULL,
	                        NULL
	        			);

$data10 = $class10->fetch();
$multiple_logs_data = $data10['result'][0]['details'];
$multiple_logs = (array)json_decode($multiple_logs_data);

//let's loop through the list of employees and
//distribute all time logs



$employees=array();
foreach ($employees_data['result'] as $k => $v) {
	//print_r($v);
	$work_schedule_data = json_decode($v['work_schedule']);	
	
	//rearray work schedule because it is a php object
	$work_schedule=array();
	foreach ($work_schedule_data as $key => $value) {
		if($value){
			$work_schedule[$key] = array(
										'in' => $value->in,
										'out' => $value->out,
										'flexible' => $value->flexible
									);
		}
		else {
			$work_schedule[$key] = array(
										'in' => NULL,
										'out' => NULL,
										'flexible' => NULL
									);
		}	
			
	}

	//construct the timesheet array based on the date from and date to from dropdown
	//print_r($work_schedule);

	$timesheet=array();
	$i = $_POST['newdatefrom'];
	$dateto = $_POST['newdateto'];
	while (strtotime($i) <= strtotime($dateto)) {
		//get lowercase day of week
		$day = strtolower(date('l', strtotime($i)));

		$sched = "No Schedule";
		if($work_schedule[$day]['in']){
			$sched = $work_schedule[$day]['in']. " - " . $work_schedule[$day]['out'];
		}

		$date_range="";
		$z = array(
			"employees_pk" => $v['pk'],
			"employee_id" => $v['employee_id'],
			"date" => date('M d', strtotime($i)),
			"datex" => date('Y-m-d', strtotime($i)),
			"day" => date('D', strtotime($i)),
			"dayx" => strtolower(date('l', strtotime($i))),
			"login_time_arr" => array(),
			"login_time" => "",
			"logout_time_arr" => array(),
			"logout_time" => "",
			"schedule" => $sched,
			"status" => "Regular",
			"status_html" => "Regular",
			"toggle" => false
		);
		//$hourdiff = round((strtotime($time1) - strtotime($time2))/3600, 1);
		
		$timesheet[$i] = $z;

		$i = date ("Y-m-d", strtotime($i."+1 day"));
	}
	// for($i=date($_POST['newdatefrom']); $i<=date($_POST['newdateto']); $i++){
		
	// 	//get lowercase day of week
	// 	$day = strtolower(date('l', strtotime($i)));

	// 	$sched = "No Schedule";
	// 	if($work_schedule[$day]['in']){
	// 		$sched = $work_schedule[$day]['in']. " - " . $work_schedule[$day]['out'];
	// 	}

	// 	$date_range="";
	// 	$z = array(
	// 		"employees_pk" => $v['pk'],
	// 		"employee_id" => $v['employee_id'],
	// 		"date" => date('M d', strtotime($i)),
	// 		"datex" => date('Y-m-d', strtotime($i)),
	// 		"day" => date('D', strtotime($i)),
	// 		"dayx" => strtolower(date('l', strtotime($i))),
	// 		"login_time_arr" => array(),
	// 		"login_time" => "",
	// 		"logout_time_arr" => array(),
	// 		"logout_time" => "",
	// 		"schedule" => $sched,
	// 		"status" => "Regular",
	// 		"status_html" => "Regular",
	// 		"toggle" => false
	// 	);
	// 	//$hourdiff = round((strtotime($time1) - strtotime($time2))/3600, 1);
		
	// 	$timesheet[$i] = $z;
	// }

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

	$previous_work_schedule=$work_schedule['monday'];
	foreach ($data['result'] as $key => $value) {
		//$timesheet[$value['date_log']]['employees_pk'] = $value['employees_pk'];

		$i="";
		if($value['type'] == "In"){
			$i = $value['date_log'];

			array_push($timesheet[$i]['login_time_arr'], $value['time_log']);
		}

		if($value['type'] == "Out"){
			if(empty($work_schedule[trim(strtolower($value['day_log']))]['out'])){
				$i = date('Y-m-d', strtotime($value['date_log'] . ' -1 day'));
			}
			else {
				if($work_schedule[trim(strtolower($value['day_log']))]['in'] > $work_schedule[trim(strtolower($value['day_log']))]['out']){
					$i = date('Y-m-d', strtotime($value['date_log'] . ' -1 day'));
				}
				else {
					$i = $value['date_log'];
				}
			}	

			array_push($timesheet[$i]['logout_time_arr'], $value['time_log']);
		}

		if(isset($work_schedule[trim(strtolower($value['day_log']))])){
			$previous_work_schedule = array(
				"in" => $work_schedule[trim(strtolower($value['day_log']))]['in'],
				"out" => $work_schedule[trim(strtolower($value['day_log']))]['out'],
				"flexible" => $work_schedule[trim(strtolower($value['day_log']))]['flexible']
			);
		}
	}
	
	foreach ($timesheet as $key => $value) {

		$timesheet[$key]['employees_pk'] = $value['employees_pk'];

		if($multiple_logs['in'] == "first"){
			if(!empty($value['login_time_arr'])){
				$time_in = strtotime(min($value['login_time_arr']));
				$value['login_time'] = min($value['login_time_arr']);
				$value['login_time_html'] = date('d M Y', $time_in) . "<br />" . date('H:i:s', $time_in);
			}
			else {
				$value['login_time'] = "";
				$value['login_time_html'] = "";	
			}
		}
		else {
			if(!empty($value['login_time_arr'])){
				$time_in = strtotime(max($value['login_time_arr']));
				$value['login_time'] = date('Y-m-d H:i:s', $time_in);
				$value['login_time_html'] = date('d M Y', $time_in) . "<br />" . date('H:i:s', $time_in);
			}
			else {
				$value['login_time'] = "";
				$value['login_time_html'] = "";
			}
		}

		//if($multiple_logs['out'] == "first"){
		if(!empty($value['logout_time_arr'])){
			//if there are multiple logout, select the right one
			foreach ($value['logout_time_arr'] as $a => $b) {
				//check if log out is earlier than actual log in or scheduled log in
				//then log out is from yesterday
				if( //logout      < login
					strtotime($b) < strtotime($value['login_time']) ||
					//logout      < scheduled login
					strtotime($b) < strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['in'])
				){
					$timesheet[date('Y-m-d',strtotime($key. '-1 day'))]['logout_time'] = $b;
					$timesheet[date('Y-m-d',strtotime($key. '-1 day'))]['logout_time_html'] = date('d M Y', strtotime($b)) . "<br />" . date('H:i:s', strtotime($b));
					$timesheet[date('Y-m-d',strtotime($key. '-1 day'))]['hrs'] = round((strtotime($b) - strtotime($timesheet[date('Y-m-d',strtotime($key. '-1 day'))]['login_time']))/3600, 1);
				}
				else {
					if(!$value['logout_time']){
						$value['logout_time'] = $b;
						$value['logout_time_html'] = date('d M Y', strtotime($b)) . "<br />" . date('H:i:s', strtotime($b));
					}
					else {
						if(strtolower($multiple_logs['out']) == "first"){
							if(strtotime($value['logout_time']) > strtotime($b)){
								$value['logout_time'] = $b;
								$value['logout_time_html'] = date('d M Y', strtotime($b)) . "<br />" . date('H:i:s', strtotime($b));
							}
						}
						else {
							if(strtotime($value['logout_time']) < strtotime($b)){
								$value['logout_time'] = $b;
								$value['logout_time_html'] = date('d M Y', strtotime($b)) . "<br />" . date('H:i:s', strtotime($b));
							}	
						}
					}
				}
			}
		}
		else {
			$value['logout_time'] = "";
			$value['logout_time_html'] = "";
			$value['hrs'] = "";
		}

		if($value['login_time'] && $value['logout_time']){
			$value['hrs'] = round((strtotime($value['logout_time']) - strtotime($value['login_time']))/3600, 1);
		}

		//MANUAL LOGS
		if(!empty($pending_manuallogs)){
			foreach ($pending_manuallogs as $a => $b) {
				$z = explode(' ', $b['time_log']);
				
				if($value['employees_pk'] == $b['employees_pk'] && $value['datex'] == $z[0]){

					if($b['type'] == "In"){
						$value['login'] = "Pending";
					}
					else {
						$value['logout'] = "Pending";
					}
				}
			}
		}

		//TARDINESS
		if(
			$work_schedule[trim(strtolower($value['dayx']))]['flexible'] == 'false' &&
			$work_schedule[trim(strtolower($value['dayx']))]['in'] && 
			$value['login_time'] &&
			strtotime($value['login_time']) > strtotime(date('Y-m-d',strtotime($value['login_time'])) ." ". $work_schedule[trim(strtolower($value['dayx']))]['in'])
		){
			$tardiness = (strtotime($value['login_time']) - strtotime(date('Y-m-d',strtotime($value['login_time'])) ." ". $work_schedule[trim(strtolower($value['dayx']))]['in'])) / 60;
			$value['tardiness'] = round(round($tardiness) / 60, 1);
		}
		
		//UNDERTIME
		if(
			$work_schedule[trim(strtolower($value['dayx']))]['out'] && 
			$value['login_time'] &&
			$value['logout_time']
		){
			$is_undertime=false;

			//if employee is not flexible
			//undertime is work schedule time out minus actual time out
			if(
				$work_schedule[trim(strtolower($value['dayx']))]['flexible'] == 'false' && 
				strtotime($value['logout_time']) < strtotime(date('Y-m-d', strtotime($value['logout_time'])) ." ". $work_schedule[trim(strtolower($value['dayx']))]['out'])
			){
				$is_undertime=true;
				$undertime = ((strtotime(date('Y-m-d', strtotime($value['logout_time'])) ." ". $work_schedule[trim(strtolower($value['dayx']))]['out']) - strtotime($value['logout_time'])) / 60) / 60;
			}

			//if employee is flexible
			//undertime is working hours minus actual time spent
			if(
				$work_schedule[trim(strtolower($value['dayx']))]['flexible'] == 'true' && 
				(float)$value['hrs'] < (float)$working_hours['hrs']
			){
				$is_undertime=true;
				$undertime = (float)$working_hours['hrs'] - (float)$value['hrs'];
			}			

			if($is_undertime){
				$value['undertime'] = round($undertime,1);
			}
				
		}

		//OVERTIME
		if(
			$value['login_time'] &&
			$value['logout_time']
		){
			//ALLOW TARDY == TRUE
			//there is no need to check if the employee came in earlier than schedule

			if(
				$overtime_leave['allow_tardy'] == "true"
			){
				$is_overtime=false;

				//if not flexible, employee login should be <= sched log in
				//and logout should be >= sched log out and total mins of overtime must be >= 7200
				if(
					$work_schedule[trim(strtolower($value['dayx']))]['flexible'] == "false" &&
					strtotime($value['logout_time']) > strtotime(date('Y-m-d', $value['logout_time']) ." ". $work_schedule[trim(strtolower($value['dayx']))]['out']) &&
					(strtotime($value['logout_time']) - strtotime(date('Y-m-d',strtotime($value['logout_time'])) ." ". $work_schedule[trim(strtolower($value['dayx']))]['out'].":00")) >= 7200
				){
					$overtime = round((strtotime($value['logout_time']) - strtotime(date('Y-m-d',strtotime($value['logout_time'])) ." ". $work_schedule[trim(strtolower($value['dayx']))]['out'].":00")) / 60, 1);
					
					$is_overtime=true;
				}
				//if flexible, overtime is equals to total # of hrs minus default working hrs
				else if(
					$work_schedule[trim(strtolower($value['dayx']))]['flexible'] == 'true' &&
					((float)$value['hrs'] - (float)$working_hours['hrs']) >= 2
				){
					$overtime = round((float)$value['hrs'] - (float)$working_hours['hrs'], 1);

					$is_overtime=true;
				}
			}
			else {
				$is_overtime=false;
				if(
					$work_schedule[trim(strtolower($value['dayx']))]['flexible'] == "false" &&
					strtotime($value['login_time']) <= strtotime(date('Y-m-d',strtotime($value['login_time'])) ." ". $work_schedule[trim(strtolower($value['dayx']))]['in'].":00") &&
					strtotime($value['logout_time']) > strtotime(date('Y-m-d', $value['logout_time']) ." ". $work_schedule[trim(strtolower($value['dayx']))]['out']) &&
					(strtotime($value['logout_time']) - strtotime(date('Y-m-d',strtotime($value['logout_time'])) ." ". $work_schedule[trim(strtolower($value['dayx']))]['out'].":00")) >= 7200
				){
					$overtime = round((strtotime($value['logout_time']) - strtotime(date('Y-m-d',strtotime($value['logout_time'])) ." ". $work_schedule[trim(strtolower($value['dayx']))]['out'].":00")) / 60, 1);

					$is_overtime=true;
				}
				else if(
					$work_schedule[trim(strtolower($value['dayx']))]['flexible'] == "true" &&
					($value['hrs'] - $working_hours['hrs']) >= 2
				){
					$overtime = round((float)$value['hrs'] - (float)$working_hours['hrs'], 1);

					$is_overtime=true;
				}
			}

			if($is_overtime){
				//compute overtime number of hours
			 	//$overtime is the difference between actual log out and scheduled log out
			 	//if not flexi,
			 	//difference between log out and log in if flexi
			 	//situation: for every 3 hrs the next 1 hr will be considered as break.
			 	//in this equation we round off the overtime (currently in minutes)
			 	//divide by 60 to get the # of hours
			 	//divide by 4 because for every 4 hrs we have 3 valid hrs
			 	//the result will be multiplied to 3 to get the actual # of hrs
			 	//for example:
			 	//6 hrs of overtime will divided by 4 = 1.5
			 	//1 * 3 = 3
			 	//we now have 3 valid overtime hrs
			 	//the remainder will be converted and treated as percentage
			 	//since we are dividing by 4, the remainders are only limited to .25, .5, .75 and 0
			 	//.25 = 1 hr
			 	//.5 = 2 hrs
			 	//.75 = 3 hrs
			 	//in this case we have 3 valid hrs + 2
			 	//the total overtime hrs is 5
			 	
				$z = round($overtime) / 60;
				$z = $z / 4;
				
				$whole = floor($z);
				$fraction = (float)$z - (int)$whole;
					
				$overtime = ((int)$whole * 3) + (4 * (float)$fraction);

				$value['overtime'] = round($overtime, 1);
				$value['overtime_status'] = 'false';
				
				foreach ($filed_overtimes as $a => $b) {
					//print_r($b);
					//echo $value['employees_pk']." == ".$b['employees_pk']." && ".$value['datex']." >= ".$b['datefrom']." && ".$value['datex']." <= ".$b['dateto']."\n";
					
					if(strtotime(date('H:i:s', $value['login_time'])) > date('H:i:s', strtotime($value['logout_time']))){
						if($value['employees_pk'] == $b['employees_pk'] && strtotime($value['datex']. "+1 day") >= strtotime($b['datefrom']) && strtotime($value['datex']."+1 day") <= strtotime($b['dateto'])){
							$value['overtime'] = $b['status'];
							$value['overtime_status'] = $b['status'];
						}
					}
					else {
						if($value['employees_pk'] == $b['employees_pk'] && strtotime($value['datex']) >= strtotime($b['datefrom']) && strtotime($value['datex']) <= strtotime($b['dateto'])){
							$value['overtime'] = $b['status'];
							$value['overtime_status'] = $b['status'];
						}
					}
						
				}
			}
		}

		//DAILY PASS SLIP
		foreach ($all_dps as $a => $b) {
			if($value['employees_pk'] == $b['employees_pk'] && date('Y-m-d', strtotime($value['datex'])) == date('Y-m-d', strtotime($b['time_from']))){
				$value['dps_status'] = $b['status'];
				$value['dps'] = date('Y-m-d H:i', strtotime($b['time_from']))."-".date('Y-m-d H:i', strtotime($b['time_to']));
				$value['dps_html'] = date('Y-m-d H:i', strtotime($b['time_from']))."<br />".date('Y-m-d H:i', strtotime($b['time_to']));
			}
		}

		//HOLIDAYS
		foreach ($holidays as $a => $b) {
			if(date('Y-m-d', strtotime($value['datex'])) == date('Y-m-d', strtotime($b['datex']))){
				$value['status'] = $b['type'] . " Holiday";
				$value['status_html'] = '<div class="holiday-yellow">'.$b['type'].' Holiday:</div><div>'. $b['name'] . '</div>';
				
				//echo strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['in'])." > ".strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['out']);
				//echo $value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['out'].":00"." - ".$value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['in'].":00";
				//$work_hrs=strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['out'].":00") - strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['in'].":00");
				$work_hrs=round((strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['out'].":00") - strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['in'].":00"))/3600, 1);
				$date_from = $value['datex'];
				$date_to = $value['datex'];
				if(strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['in']) > strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['out'])){
					//+ 1 day
					$work_hrs=round((strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['out'].":00 +1 day") - strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['in'].":00"))/3600, 1);
					$date_from = $value['datex'];
					$date_to = date('Y-m-d', strtotime($value['datex']." +1 day"));
				}
				
				if(!$value['login_time'] && !$value['logout_time'] && !empty($work_schedule[trim(strtolower($value['dayx']))]['in']) && !empty($work_schedule[trim(strtolower($value['dayx']))]['out'])){
					$value['login_time'] = $date_from." ".$work_schedule[trim(strtolower($value['dayx']))]['in'].":00";
					$value['login_time_html'] = $date_from."<br />".$work_schedule[trim(strtolower($value['dayx']))]['in'].":00";

					$value['logout_time'] = $date_to." ".$work_schedule[trim(strtolower($value['dayx']))]['out'].":00";
					$value['logout_time_html'] = $date_to."<br />".$work_schedule[trim(strtolower($value['dayx']))]['out'].":00";

					$value['hrs'] = $work_hrs;
					$value['tardiness'] = "";
					$value['undertime'] = "";
					$value['overtime_status'] = "";
				}
			}
		}

		//SUSPENSIONS
		foreach ($suspension as $a => $b) {
			if(date('Y-m-d', strtotime($value['datex'])) >= date('Y-m-d', strtotime($b['time_from'])) && date('Y-m-d', strtotime($value['datex'])) <= date('Y-m-d', strtotime($b['time_to']))){
				
				//change if actual date is > suspension start date
				if(date('Y-m-d', strtotime($value['datex'])) > date('Y-m-d', strtotime($b['time_from']))){
					$b['time_from'] = $work_schedule[trim(strtolower($value['dayx']))]['in'].":00";
				}

				//change if actual date is < suspension end date
				if(date('Y-m-d', strtotime($value['datex'])) < date('Y-m-d', strtotime($b['time_to']))){
					$b['time_to'] = $work_schedule[trim(strtolower($value['dayx']))]['out'].":00";
				}

				//default values
				$value['suspension'] = $value['datex']." ".date('H:i', strtotime($b['time_from'])). "-" .$value['datex']." ".date('H:i', strtotime($b['time_to']));
				$value['suspension_html'] = $value['datex']." ".date('H:i', strtotime($b['time_from'])). "<br />" .$value['datex']." ".date('H:i', strtotime($b['time_to']));
			}
		}

		//APPROVED LEAVES
		foreach ($approved_leaves as $a => $b) {
			if($value['employees_pk'] == $b['employees_pk'] && date('Y-m-d', strtotime($value['datex'])) >= date('Y-m-d', strtotime($b['date_started'])) && date('Y-m-d', strtotime($value['datex'])) <= date('Y-m-d', strtotime($b['date_ended']))){
				$value['status'] = $b['name'];
				$value['status_html'] = '<div class="red">Leave:</div><div>'. $b['name'] . '</div>';
				
				$value['login'] = $work_schedule[trim(strtolower($value['dayx']))]['in'].":00";
				$value['login_time'] = $value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['in'].":00";
				$value['logout'] = $work_schedule[trim(strtolower($value['dayx']))]['out'].":00";
				$value['logout_time'] = $value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['out'].":00";

				$work_hrs=round((strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['out'].":00") - strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['in'].":00"))/3600, 1);
				$date_from = $value['datex'];
				$date_to = $value['datex'];
				if(strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['in']) > strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['out'])){
					//+ 1 day
					$work_hrs=round((strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['out'].":00 +1 day") - strtotime($value['datex']." ".$work_schedule[trim(strtolower($value['dayx']))]['in'].":00"))/3600, 1);
				}

				$value['hrs'] = $work_hrs;
				$value['tardiness'] = "";
				$value['undertime'] = "";
				$value['overtime'] = "";
				$value['dps'] = "";
			}
		}

		//change status based on present data
		if($value['status']=='Regular' && $value['login_time '] != '' && $value['logout_time'] != ''){
			$value['status'] = "Regular";
			$value['status_html'] = "Regular";
		}
		else if($value['status'] == 'Regular' && $value['schedule'] == 'No Schedule'){
			$value['status'] = "Rest Day";
			$value['status_html'] = "<span class='restday-green'>Rest Day</span>";
		}
		else if(($value['login_time'] == '' || $value['logout_time'] == '') && $value['schedule'] != 'No Schedule' && $value['status'] == 'Regular'){
			$value['status'] = "Absent";
			$value['status_html'] = "<span class='red'>Absent</span>";
		}
		else if($value['status'] != 'Regular'){
			//skip
		}
		
		$timesheet[$key] = $value;
	}

	$employees[$v['pk']] = $timesheet;
}

header("HTTP/1.0 500 Internal Server Error");
if($employees){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($employees));
//print_r($employees);
return false;



	

	

print_r($timesheet);
return false;
echo "+++++++++++++++++++++";
print_r($timesheet);
$employees = $data;
header("HTTP/1.0 500 Internal Server Error");
if($employees){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($employees));
return false;
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
		$y['schedule'] = $y['work_schedule'][trim(strtolower($y['log_day']))]->in ." - ".$y['work_schedule'][trim(strtolower($y['log_day']))]->out;

		//MANUAL LOGS
		if(!empty($pending_manuallogs)){
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
		}
		
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
				$is_overtime=false;

				//if not flexible, employee login should be <= sched log in
				//and logout should be >= sched log out and total mins of overtime must be >= 7200
				if(
					$y['work_schedule'][trim(strtolower($y['log_day']))]->flexible == "false" &&
					strtotime($y['logout']) > strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00") &&
					(strtotime($y['logout']) - strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00")) >= 7200
				){
					$overtime = (strtotime($y['logout']) - strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00"));
					
					$is_overtime=true;
				}
				//if flexible, overtime is equals to total # of hrs minus default working hrs
				else if(
					$y['work_schedule'][trim(strtolower($y['log_day']))]->flexible == "true" &&
					(strtotime($y['hrs']) - strtotime($working_hours['hrs'] . ":00:00")) >= 7200
				){
					// echo $y['hrs'];
					// echo "\n";
					$overtime = strtotime($y['hrs']) - strtotime($working_hours['hrs'] . ":00:00");

					$is_overtime=true;
				}
			}
			else {
				$is_overtime=false;
				if(
					$y['work_schedule'][trim(strtolower($y['log_day']))]->flexible == "false" &&
					strtotime($y['login']) <= strtotime(date('Y-m-d',strtotime($y['login'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->in.":00") &&
					strtotime($y['logout']) > strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00") &&
					(strtotime($y['logout']) - strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00")) >= 7200
				){
					$overtime = (strtotime($y['logout']) - strtotime(date('Y-m-d',strtotime($y['logout'])) ." ". $y['work_schedule'][trim(strtolower($y['log_day']))]->out.":00"));

					$is_overtime=true;
				}
				else if(
					$y['work_schedule'][trim(strtolower($y['log_day']))]->flexible == "true" &&
					(strtotime($y['hrs']) - strtotime($working_hours['hrs'] . ":00:00")) >= 7200
				){
					$overtime = strtotime($y['hrs']) - strtotime($working_hours['hrs'] . ":00:00");

					$is_overtime=true;
				}
			}

			if($is_overtime){
				//compute overtime number of hours
			 	//$overtime is the difference between actual log out and scheduled log out
			 	//if not flexi,
			 	//difference between log out and log in if flexi
			 	//situation: for every 3 hrs the next 1 hr will be considered as break.
			 	//in this equation we round off the overtime (currently in minutes)
			 	//divide by 60 to get the # of hours
			 	//divide by 4 because for every 4 hrs we have 3 valid hrs
			 	//the result will be multiplied to 3 to get the actual # of hrs
			 	//for example:
			 	//6 hrs of overtime will divided by 4 = 1.5
			 	//1 * 3 = 3
			 	//we now have 3 valid overtime hrs
			 	//the remainder will be converted and treated as percentage
			 	//since we are dividing by 4, the remainders are only limited to .25, .5, .75 and 0
			 	//.25 = 1 hr
			 	//.5 = 2 hrs
			 	//.75 = 3 hrs
			 	//in this case we have 3 valid hrs + 2
			 	//the total overtime hrs is 5
			 	
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
		}

		//DAILY PASS SLIP
		foreach ($approved_dps as $a => $b) {
			if($y['employees_pk'] == $b['employees_pk'] && $y['log_date'] == date('Y-m-d', strtotime($b['time_from']))){
				$y['dps'] = date('H:i', strtotime($b['time_from']))." - ".date('H:i', strtotime($b['time_to']));
			}
		}

		//HOLIDAYS
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

		//SUSPENSIONS
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

		//APPROVED LEAVES
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

		$y['toggle'] = false;
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