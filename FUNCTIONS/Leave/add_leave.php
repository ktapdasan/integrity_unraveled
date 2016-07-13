<?php
require_once('../connect.php');
require_once('../../CLASSES/Leave.php');

$class = new Leave(
	
				null,
				$_POST['employees_pk'],
				$_POST['leave_types_pk'],
                $_POST['date_started'],
                $_POST['date_ended'],
                NULL,
            	$_POST['reason'],
                NULL
			);

$data = $class-> add_leave();

setcookie('commented', 'commented', time()+43200000, '/');

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
       header("HTTP/1.0 200 OK");
}                  

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 