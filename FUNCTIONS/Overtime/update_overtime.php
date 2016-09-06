<?php
require_once('../connect.php');
require_once('../../CLASSES/Overtime.php');
require_once('../../CLASSES/Cutoff.php');

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
							$_POST['employees_pk'],
							NULL,
							NULL
					);

$date_r = array(
        		"date_from" => $date_range['from'],
        		"date_to" => $date_range['to']
    		);

$approved_data = $approved_class->count_approved_overtimes($date_r);
// print_r($approved_data['result']);

// return false;

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