<?php
require_once('../connect.php');
require_once('../../CLASSES/ManualLog.php');

$class = new ManualLog(	
						NULL,	
						$_POST["employees_pk"],
						$_POST["date_log"] ." ". $_POST["time_log"],
						$_POST["reason"],
						NULL,
						NULL
					);

$data = $class->save_manual_log();

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?> 

