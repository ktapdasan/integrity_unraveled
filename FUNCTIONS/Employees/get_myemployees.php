<?php
require_once('../connect.php');
require_once('../../CLASSES/Groupings.php');

$class = new Groupings(
                            NULL,
                            $_POST['pk']
                        );

$data = $class->fetch_group();

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
	header("HTTP/1.0 200 OK");
}                  

header('Content-Type: application/json');
print(json_encode($data));
?>