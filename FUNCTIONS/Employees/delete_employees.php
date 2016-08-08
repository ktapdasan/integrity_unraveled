<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');

$class = new Employees(
                            $_POST['pk'],
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

$data = $class-> deactivate();

setcookie('commented', 'commented', time()+43200000, '/');

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
	header("HTTP/1.0 200 OK");
}                  

header('Content-Type: application/json');
print(json_encode($data));
?>