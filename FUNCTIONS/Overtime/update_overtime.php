<?php
require_once('../connect.php');
require_once('../../CLASSES/Overtime.php');
require_once('../../CLASSES/Cutoff.php');
require_once('../../CLASSES/Default_values.php');
require_once('../../CLASSES/Employees.php');

$default_values_max_overtime_class = new Default_values(
									                        NULL,
									        				'overtime_leave',
									        				NULL,
									                        NULL
									        			);

$default_values_max_overtime_data = $default_values_max_overtime_class->fetch();

$default_max_overtime = json_decode($default_values_max_overtime_data['result'][0]['details']);
$default_max_overtime = $default_max_overtime->maximum;

$default_values_overtime_leave_class = new Default_values(
											NULL,
											'overtime_leave',
											NULL,
											NULL
										);

$default_values_overtime_leave_data = $default_values_overtime_leave_class->fetch();
$leave_pk = json_decode($default_values_overtime_leave_data['result'][0]['details']);
$leave_filed_pk = $leave_pk->leave_filed_pk;

$cutoff_class = new Cutoff(
								NULL,
								NULL,
								NULL
							);

$cut_off_data = $cutoff_class->fetch_dates();

$cutoff = json_decode($cut_off_data['result'][0]['dates']);

//GET the cutoff first to get the date range
//use the cutoff date range to get all the approved overtime
if($cut_off_data['result'][0]['cutoff_type'] == 'Bi-Monthly'){
	if($cutoff->first->from > $cutoff->second->to){
		$date_from = date('Y-m-') . $cutoff->first->from;
		$date_to = date('Y-m-') . $cutoff->second->to;

		$date_range =  array(
								"from" => date('Y-m-d', strtotime($date_from)), 
								"to" => date('Y-m-d', strtotime('+1 month', strtotime($date_to)))
							);	
	}
	else {
		$date_range = array(
								"from" => date('Y-m-') . $cutoff->first->from,
								"to" => date('Y-m-') . $cutoff->second->to
							);
	}
	
}
else {
	$date_from = date('Y-m-') . $cutoff->from;
	$date_to = date('Y-m-') . $cutoff->to;

	$date_range =  array(
							"from" => $date_from, 
							"to" => $date_to
						);
}

$approved_class = new Overtime(	
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								$_POST['employees_pk'],
								NULL,
								NULL
							);

$date_r = array(
        		"date_from" => $date_range['from'],
        		"date_to" => $date_range['to']
    		);

$approved_data = $approved_class->count_approved_overtimes($date_r);

$month = (float)$approved_data['result'][0]['amount'] + (float)$_POST['hours'];
$year = (float)$approved_data['result'][1]['amount'] + (float)$_POST['hours'];

$employees_class = new Employees(	
									md5($_POST['employees_pk']),
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

$employees_data = $employees_class->profile();
$leave_balances = (array)json_decode($employees_data['result'][0]['leave_balances']);
$details = (array)json_decode($employees_data['result'][0]['details']);

if($_POST['type'] == "Paid"){
	//if employee is exempt
	//all leaves will be converted to
	//leave credits
	//employee_types
	//1 Exempt
	//2 Non-exempt
	if($details['company']->employee_types_pk == 1){
		//add overtime to leave balances

		//re-assign leave balances to a new array
		$new_leave_balances=array();
		foreach ($leave_balances as $key => $value) {
			$new_leave_balances[(int) $key] = $value;
		}

		$leave_filed_pk = (int) $leave_filed_pk;
		if(!isset($new_leave_balances[$leave_filed_pk])){
			$new_leave_balances[$leave_filed_pk] = 0;
		}

		$new_hours = (float)$_POST['hours'];

		$new_leave_balances[$leave_filed_pk] += $new_hours;

		$employees_class2 = new Employees(	
											$_POST['employees_pk'],
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

		$info = array('leave_balances' => $new_leave_balances);
		$update_employees_data = $employees_class2->update_leave_balances($info);
	}
	//if Non-exempt and if overtime hours exceeds maximum - hours will be added to the default leave
	else if($month > $default_max_overtime->month || $year > $default_max_overtime->year){
		$month_remainder = $month - $default_max_overtime->month;
		$year_remainder = $year - $default_max_overtime->year;

		//hours more than 40 will be deducted 
		//and saved as leave credit
		//$leave_filed_pk
		$hours_for_convertion = 0;
		if($month_remainder < $default_max_overtime->month){
			$hours_for_convertion = $month_remainder;
		}
		else {
			$hours_for_convertion = $month;
		}

		//add the excess overtime to leave balance
		if(!isset($leave_balances[$leave_filed_pk])){
			$leave_balances[$leave_filed_pk] = 0;
		}

		$leave_balances[$leave_filed_pk] += round($hours_for_convertion / 9,2);

		$employees_class2 = new Employees(	
											$_POST['employees_pk'],
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

		$info = array('leave_balances' => $leave_balances);
		$update_employees_data = $employees_class2->update_leave_balances($info);
	}
}
else {
	//add overtime to leave balances

	//re-assign leave balances to a new array
	$new_leave_balances=array();
	foreach ($leave_balances as $key => $value) {
		$new_leave_balances[(int) $key] = $value;
	}

	$leave_filed_pk = (int) $leave_filed_pk;
	if(!isset($new_leave_balances[$leave_filed_pk])){
		$new_leave_balances[$leave_filed_pk] = 0;
	}

	$new_hours = (float)$_POST['hours'];

	$new_leave_balances[$leave_filed_pk] += $new_hours;

	$employees_class2 = new Employees(	
										$_POST['employees_pk'],
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

	$info = array('leave_balances' => $new_leave_balances);
	$update_employees_data = $employees_class2->update_leave_balances($info);
}

//return false;

$class = new Overtime(	
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL
					);

$info = array(
        		"overtime_pk" => $_POST['pk'],
        		"created_by" => $_POST['approver_pk'],
        		"status" => $_POST['status'],
        		"remarks" => $_POST['remarks'],
        		"employees_pk"=>$_POST['employees_pk']
    		);


$data = $class->update_overtime($info);

header("HTTP/1.0 404 User Not Found");
if($data['status']){


	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>