<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');
//require_once('../../CLASSES/PHPMailerAutoload.php');

$education = json_decode($_POST['education'], true);

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
    $_POST['date_started'],
    $_POST['data_sss'],
    $_POST['data_tin'],
    $_POST['data_pagmid'],
    $_POST['data_phid'],
    $_POST['education'],
    $_POST['salary_type'],
    $_POST['bank_name'],
    $_POST['account_number'],
    $_POST['amount'],
    $_POST['mode_payment'],
    $_POST['timein_sunday'],
    $_POST['timein_monday'],
    $_POST['timein_tuesday'],
    $_POST['timein_wednesday'],
    $_POST['timein_thursday'],
    $_POST['timein_friday'],
    $_POST['timein_saturday'],
    $_POST['timeout_sunday'],
    $_POST['timeout_monday'],
    $_POST['timeout_tuesday'],
    $_POST['timeout_wednesday'],
    $_POST['timeout_thursday'],
    $_POST['timeout_friday'],
    $_POST['timeout_saturday'],
    $_POST['profile_picture'],
    $_POST['permanent_address'],
    $_POST['present_address'],
    $_POST['emergency_name'],
    $_POST['emergency_contact_number'],
    $_POST['contact_number'],
    $_POST['landline_number'],
    NULL,
    NULL,
    NULL
    );


//Company Array! Ken
$company = array();
$company['employee_id']              = pg_escape_string(strip_tags(trim($_POST['employee_id'])));
$company['employee_status']          = pg_escape_string(strip_tags(trim($_POST['employee_status'])));
$company['employment_type']          = pg_escape_string(strip_tags(trim($_POST['employment_type'])));
$company['departments_pk']           = pg_escape_string(strip_tags(trim($_POST['departments_pk'])));
$company['titles_pk']                = pg_escape_string(strip_tags(trim($_POST['titles_pk'])));
$company['supervisor_pk']            = pg_escape_string(strip_tags(trim($_POST['supervisor_pk'])));
$company['date_started']             = pg_escape_string(strip_tags(trim($_POST['date_started'])));
$company['business_email_address']   = pg_escape_string(strip_tags(trim($_POST['business_email_address'])));

//Salary Type
if ($_POST['salary_type'] == 'bank'){
    $company['salary_type']['bank']['bank_name']            = pg_escape_string(strip_tags(trim($_POST['bank_name'])));
    $company['salary_type']['bank']['account_number']       = pg_escape_string(strip_tags(trim($_POST['account_number'])));
    $company['salary_type']['bank']['amount']               = pg_escape_string(strip_tags(trim($_POST['amount'])));
}
if ($_POST['salary_type'] == 'wire'){
    $company['salary_type']['wire']['mode_payment']         = pg_escape_string(strip_tags(trim($_POST['mode_payment'])));
    $company['salary_type']['wire']['account_number']       = pg_escape_string(strip_tags(trim($_POST['account_number'])));
    $company['salary_type']['wire']['amount']               = pg_escape_string(strip_tags(trim($_POST['amount'])));
}
if ($_POST['salary_type'] == 'cash'){
    $company['salary_type']['cash']['amount']               = pg_escape_string(strip_tags(trim($_POST['amount'])));
}

//TIMEIN and OUT
$company['work_schedule']['sunday']['in']           = pg_escape_string($_POST['timein_sunday']);
$company['work_schedule']['sunday']['out']          = pg_escape_string($_POST['timeout_sunday']);
$company['work_schedule']['monday']['in']           = pg_escape_string($_POST['timein_monday']);
$company['work_schedule']['monday']['out']          = pg_escape_string($_POST['timeout_monday']);
$company['work_schedule']['tuesday']['in']          = pg_escape_string($_POST['timein_tuesday']);
$company['work_schedule']['tuesday']['out']         = pg_escape_string($_POST['timeout_tuesday']);
$company['work_schedule']['wednesday']['in']        = pg_escape_string($_POST['timein_wednesday']);
$company['work_schedule']['wednesday']['out']       = pg_escape_string($_POST['timeout_wednesday']);
$company['work_schedule']['thursday']['in']         = pg_escape_string($_POST['timein_thursday']);
$company['work_schedule']['thursday']['out']        = pg_escape_string($_POST['timeout_thursday']);
$company['work_schedule']['friday']['in']           = pg_escape_string($_POST['timein_friday']);
$company['work_schedule']['friday']['out']          = pg_escape_string($_POST['timeout_friday']);
$company['work_schedule']['saturday']['in']         = pg_escape_string($_POST['timein_saturday']);
$company['work_schedule']['saturday']['out']        = pg_escape_string($_POST['timeout_saturday']);

if ($_POST['levels_pk'] == 3){
    $company['levels_pk']            = pg_escape_string(strip_tags(trim($_POST['levels_pk'])));
    $company['hours']                = pg_escape_string(strip_tags(trim($_POST['intern_hours'])));
}
if ($_POST['levels_pk'] != 3){
    $company['levels_pk']            = pg_escape_string(strip_tags(trim($_POST['levels_pk'])));
}

//Personal Array!
$personal = array();
$personal['civilstatus']             = pg_escape_string(strip_tags(trim($_POST['civilstatus'])));
$personal['first_name']              = pg_escape_string(strip_tags(trim($_POST['first_name'])));
$personal['middle_name']             = pg_escape_string(strip_tags(trim($_POST['middle_name'])));
$personal['last_name']               = pg_escape_string(strip_tags(trim($_POST['last_name'])));
$personal['gender']                  = pg_escape_string(strip_tags(trim($_POST['gender'])));
$personal['religion']                = pg_escape_string(strip_tags(trim($_POST['religion'])));
$personal['birth_date']              = pg_escape_string(strip_tags(trim($_POST['birth_date'])));
$personal['profile_picture']         = pg_escape_string(strip_tags(trim($_POST['profile_picture'])));
$personal['permanent_address']       = pg_escape_string(strip_tags(trim($_POST['permanent_address'])));
$personal['present_address']         = pg_escape_string(strip_tags(trim($_POST['present_address'])));
$personal['emergency_contact_name']  = pg_escape_string(strip_tags(trim($_POST['emergency_name'])));
$personal['emergency_contact_number']= pg_escape_string(strip_tags(trim($_POST['emergency_contact_number'])));
$personal['contact_number']          = pg_escape_string(strip_tags(trim($_POST['contact_number'])));
$personal['landline_number']         = pg_escape_string(strip_tags(trim($_POST['landline_number'])));

//Government Array!
$government = array();
$government['SSS']                   = pg_escape_string(strip_tags(trim($_POST['data_sss'])));
$government['TIN']                   = pg_escape_string(strip_tags(trim($_POST['data_tin'])));
$government['PAG-IBIG']              = pg_escape_string(strip_tags(trim($_POST['data_pagmid'])));
$government['PHILHEALTH']            = pg_escape_string(strip_tags(trim($_POST['data_phid'])));

$educations['school_type']           = $education;

$details = array();
$details['company']                  = $company;
$details['personal']                 = $personal; 
$details['education']                = $educations; 
$details['government']               = $government; 
$extra['details']                    = $details; 

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