<?php
require_once('../connect.php');
require_once('../../CLASSES/LeaveTypes.php');

$details = array(
					"regularization" 		=> $_POST['regularization'],
					"staggered"		 		=> $_POST['staggered'],
					"carry_over" 			=> $_POST['carry_over'],
					"leaves_regularization" => $_POST['leaves_regularization'],
					"max_increase" 			=> $_POST['max_increase'],
					"leaves_per_month" 		=> $_POST['leaves_per_month']
				);

$class = new LeaveTypes(
			                NULL,
			                $_POST['name'],
			                $_POST['code'],
			                $_POST['days'],
			                $details,
			                NULL
						);

$data = $class-> add_leave_type();

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
       header("HTTP/1.0 200 OK");
}                  

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 