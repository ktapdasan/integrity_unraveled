<?php
require_once('../connect.php');
require_once('../../CLASSES/Birthday.php');


$class = new Birthday_theme(
                            $_POST['pk'],
                            $_POST['birthdaymonth'],
                            $_POST['imagevalue'],
                            NULL
    );




$data = $class-> update_birthday_theme();



header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
    header("HTTP/1.0 200 OK");

}                  

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 