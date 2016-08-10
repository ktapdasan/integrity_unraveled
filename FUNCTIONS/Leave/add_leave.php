<?php
require_once('../connect.php');
require_once('../../CLASSES/Leave.php');

$class = new Leave(
	
				null,
				$_POST['employees_pk'],
                $_POST['leave_types_pk'],
                $_POST['duration'],
				$_POST['category'],
                $_POST['date_started'],
                $_POST['date_ended'],
                NULL,
                NULL
			);

$extra['supervisor_pk'] = $_POST['supervisor_pk'];
$data = $class-> add_leave($extra);

setcookie('commented', 'commented', time()+43200000, '/');

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
       header("HTTP/1.0 200 OK");
}                  

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 