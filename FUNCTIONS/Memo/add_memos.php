<?php
require_once('../connect.php');
require_once('../../CLASSES/Memo.php');
// print_r($_POST);
$class = new Memo(
								NULL,
		                        $_POST['memo'],
		                        $_POST['created_by'],
		                        NULL,
		                        NULL,
		                        NULL
							);

$data = $class->add_memos($_POST);

header("HTTP/1.0 404 Error saving content");
if($data['status']){
    header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>