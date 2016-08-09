<?php
require_once('../connect.php');
require_once('../../CLASSES/Leave.php');

$class = new LeaveTypes(
						$_POST['pkey'],
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        $_POST['leave_filed_pk'],
                        $_POST['created_by']
					);

$data = $class-> delete();

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
	header("HTTP/1.0 200 OK");
 }                  

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 