<?php
require_once('../connect.php');
require_once('../../CLASSES/LeaveTypes.php');

$class = new LeaveTypes(
	
                Null,
                $_POST['name'],
                $_POST['code'],
                Null,
                $_POST['days']
                
			);


$data = $class-> add();

setcookie('commented', 'commented', time()+43200000, '/');

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
       header("HTTP/1.0 200 OK");
}                  

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 