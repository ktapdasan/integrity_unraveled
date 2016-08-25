<?php
require_once('../connect.php');
require_once('../../CLASSES/Cutoff.php');

$class = new Cutoff(
				$_POST['pk'],
                Null,
                Null
			);

$extra['pk'] = $_POST['status'];
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

$data = $class-> submit_type($extra);

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
       header("HTTP/1.0 200 OK");
 }                  

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 