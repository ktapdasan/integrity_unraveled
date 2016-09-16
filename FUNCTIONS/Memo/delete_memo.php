<?php
require_once('../connect.php');
require_once('../../CLASSES/Memo.php');


$class = new Memo(
				$_POST['pk'],
                Null,
                Null,
                Null,
                Null
			);

$data = $class-> deactivate();





header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
	header("HTTP/1.0 200 OK");
 }                  

header('Content-Type: application/json');
print(json_encode($data));

?>  