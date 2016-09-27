<?php
require_once('../connect.php');
require_once('../../CLASSES/Attrition.php');
// print_r($_POST);
$class = new Attritions(
                            $_POST['attritions_pk'],
                            $_POST['employees_pk'],
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL
                        );


 $arr = array(
 	 "reason" => $_POST['reason'],
 	 "remark" => $_POST['remark'],
 	  "elig" => $_POST['elig']

 	);

$extra['hr_pk'] = $_POST['created_by']; 
$extra['apprv_pk'] = $_POST['apprv_pk']; 
$data = $class->update_SupervisorDetails($arr, $extra);

header("HTTP/1.0 404 User Not Found");
if($data['status']){
    header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));

?>