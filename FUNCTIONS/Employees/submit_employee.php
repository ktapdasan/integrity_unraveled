<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');
//require_once('../../CLASSES/PHPMailerAutoload.php');

$class = new Employees(
    NULL,
    $_POST['employee_id'],
    $_POST['first_name'],
    $_POST['middle_name'],
    $_POST['last_name'],
    $_POST['email_address'],
    $_POST['business_email_address'],
    $_POST['titles_pk'],
    $_POST['levels_pk'],
    $_POST['departments_pk'],
    $_POST['employment_type'],
    $_POST['employees.date_started'],
    $_POST['employee_type'],
    NULL,
    NULL,
    NULL
    );

//Company Array! Ken
$company = array();
$company['employee_type']            = pg_escape_string(strip_tags(trim($_POST['employee_type'])));
$company['employment_type']          = pg_escape_string(strip_tags(trim($_POST['employment_type'])));
$company['departments_pk']           = pg_escape_string(strip_tags(trim($_POST['departments_pk'])));
$company['titles_pk']                = pg_escape_string(strip_tags(trim($_POST['titles_pk'])));
$company['supervisor_pk']            = pg_escape_string(strip_tags(trim($_POST['supervisor_pk'])));
$company['employees.date_started']   = pg_escape_string(strip_tags(trim($_POST['employees.date_started'])));
$company['business_email_address']   = pg_escape_string(strip_tags(trim($_POST['business_email_address'])));


//Personal Array!
$personal = array();
$personal['civilstatus_pk']          = pg_escape_string(strip_tags(trim($_POST['civilstatus_pk'])));
$personal['first_name']              = pg_escape_string(strip_tags(trim($_POST['first_name'])));
$personal['middle_name']             = pg_escape_string(strip_tags(trim($_POST['middle_name'])));
$personal['last_name']               = pg_escape_string(strip_tags(trim($_POST['last_name'])));
$personal['gender_pk']               = pg_escape_string(strip_tags(trim($_POST['gender_pk'])));
$personal['religion_pk']             = pg_escape_string(strip_tags(trim($_POST['religion_pk'])));

//Government Array!
$government = array();
$government['data_sss']              = pg_escape_string(strip_tags(trim($_POST['data_sss'])));
$government['data_tin']              = pg_escape_string(strip_tags(trim($_POST['data_tin'])));
$government['data_pagmid']           = pg_escape_string(strip_tags(trim($_POST['data_pagmid'])));
$government['data_phid']             = pg_escape_string(strip_tags(trim($_POST['data_phid'])));

$education['school_type']            = pg_escape_string(strip_tags(trim($_POST['forms'])));

//For intern validation!!
if ($_POST['levels_pk'] == 3){
    $details['company']['levels_pk'] = pg_escape_string(strip_tags(trim($_POST['levels_pk'])));
    $details['company']['hours']     = pg_escape_string(strip_tags(trim($_POST['intern_hours'])));
}
else{
    $details['company']['levels_pk'] = pg_escape_string(strip_tags(trim($_POST['levels_pk'])));
}   

$details = array();//Details Array
$details['company'] = $company; //Declared!
$details['personal'] = $personal; //Declared!
$details['government'] = $government; //Declared!
$details['education'] = $education; //Declared!

$extra['details'] = $details; //Declared!
$extra['supervisor_pk'] = $_POST['supervisor_pk']; //Declared!

$data = $class-> create($extra);

setcookie('commented', 'commented', time()+43200000, '/');

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
    header("HTTP/1.0 200 OK");
/*
$mail = new PHPMailer;

//$mail->SMTPDebug = 3;                               // Enable verbose debug output

$mail->isSMTP();                                      // Set mailer to use SMTP
$mail->Host = 'smtp.gmail.com';                       // Specify main and backup SMTP servers
$mail->SMTPAuth = true;                               // Enable SMTP authentication
$mail->Username = 'rpascual.chrs@gmail.com';          // SMTP username
$mail->Password = '1Loveyou';                         // SMTP password
$mail->SMTPSecure = 'tls';                            // Enable TLS encryption, `ssl` also accepted
$mail->Port = 587;                                    // TCP port to connect to

$mail->setFrom('welcome@chrsglobal.com', 'Mailer');
$mail->addAddress($_POST['email_address'], $_POST['first_name']." ".$_POST['last_name']);     // Add a recipient
//$mail->addReplyTo('info@example.com', 'Information');
$mail->addBCC('rpascual.chrs@gmail.com');

//$mail->addAttachment('/var/tmp/file.tar.gz');         // Add attachments
//$mail->addAttachment('/tmp/image.jpg', 'new.jpg');    // Optional name
$mail->isHTML(true);                                  // Set email format to HTML

$mail->Subject = 'Welcome to CHRS, Inc.';
$mail->Body    = 'Hi ' . $_POST['first_name'] . ",";
$mail->Body    = '<br /><br />';
$mail->Body    = '<b>Welcome!</b>';
$mail->Body    = '<br /><br />';
$mail->Body    = 'Your CHRS account has been created. Please go to <a href="http://192.168.1.10/oneteam/">http://192.168.1.10/oneteam/</a>.';

if(!$mail->send()) {
echo "Mailer Error: " . $mail->ErrorInfo;
header("HTTP/1.0 500 Internal Server Error");
} else {
header('Content-Type: application/json');
print(json_encode($data));
}*/
}                  

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 