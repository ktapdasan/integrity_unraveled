<?php
require_once('../connect.php');
require_once('../../CLASSES/Default_values.php');

$class = new Default_values(
								NULL,
		                        NULL,
		                        NULL,
		                        NULL
							);

$extra['type'] = $_POST['status'];
if($_POST['status'] == 1){
	$extra['cutoffdate'] = array(
									"from" => $_POST['start_m'],
									"to" => $_POST['end_m']
								);
}
else {
	$extra['cutoffdate'] = array(
									"first" => array(
														"from" => $_POST['start_bf'],
														"to" => $_POST['end_bf']
													),
									"second" => array(
														"from" => $_POST['start_bs'],
														"to" => $_POST['end_bs']
													)
								);
}

$data = $class->update_work_cutoff($extra);

header("HTTP/1.0 404 Error saving contact");
if($data['status']){
    header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>