<?php
require_once('../connect.php');
require_once('../../CLASSES/Leave.php');

$class = new Leave(
						$_POST['leave_filed_pk'],
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL
					);
$info = array(
					"leave_filed_pk" => $_POST['leave_filed_pk'],
					"created_by" => $_POST['created_by']
				);

$data = $class-> delete($info);

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
	header("HTTP/1.0 200 OK");
 }                  

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 