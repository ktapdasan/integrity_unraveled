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
                            $_POST['time_insunday'],
                            $_POST['time_inmonday'],
                            $_POST['time_intuesday'],
                            $_POST['time_inwednesday'],
                            $_POST['time_inthursday'],
                            $_POST['time_infriday'],
                            $_POST['time_insaturday'],
                            $_POST['time_outsunday'],
                            $_POST['time_outmonday'],
                            $_POST['time_outtuesday'],
                            $_POST['time_outthursday'],
                            $_POST['time_outfriday'],
                            $_POST['time_outsaturday'],
                            $_POST['time_outwednesday'],
                            $_POST['profile_picture'],
                            $_POST['permanent_address'],
                            $_POST['present_address'],
                            $_POST['emergency_name'],
                            $_POST['emergency_contact_number'],
                            $_POST['contact_number'],
                            $_POST['flexi_sunday'],
                            $_POST['flexi_monday'],
                            $_POST['flexi_tuesday'],
                            $_POST['flexi_wednesday'],
                            $_POST['flexi_thursday'],
                            $_POST['flexi_friday'],
                            $_POST['flexi_saturday'],
                            NULL,
                            NULL,
                            NULL
    );


//Company Array! Ken
$company = array();
$company['employee_id']              = pg_escape_string(strip_tags(trim($_POST['employee_id'])));
$company['employee_status_pk']       = pg_escape_string(strip_tags(trim($_POST['employee_status'])));
$company['employment_type_pk']       = pg_escape_string(strip_tags(trim($_POST['employment_type'])));
$company['departments_pk']           = pg_escape_string(strip_tags(trim($_POST['departments_pk'])));
$company['titles_pk']                = pg_escape_string(strip_tags(trim($_POST['titles_pk'])));
$company['supervisor_pk']            = pg_escape_string(strip_tags(trim($_POST['supervisor_pk'])));
$company['date_started']             = pg_escape_string(strip_tags(trim($_POST['date_started'])));
$company['business_email_address']   = pg_escape_string(strip_tags(trim($_POST['business_email_address'])));

//Salary Type
if ($_POST['salary_type'] == 'bank'){
    $company['salary']['salary_type']          = pg_escape_string(strip_tags(trim($_POST['salary_type'])));
    $company['salary']['bank_name']            = pg_escape_string(strip_tags(trim($_POST['bank_name'])));
    $company['salary']['account_number']       = pg_escape_string(strip_tags(trim($_POST['account_number'])));
    $company['salary']['amount']               = pg_escape_string(strip_tags(trim($_POST['amount'])));

}
if ($_POST['salary_type'] == 'wire'){
   $company['salary']['salary_type']           = pg_escape_string(strip_tags(trim($_POST['salary_type'])));
   $company['salary']['mode_payment']          = pg_escape_string(strip_tags(trim($_POST['mode_payment'])));
   $company['salary']['account_number']        = pg_escape_string(strip_tags(trim($_POST['account_number'])));
   $company['salary']['amount']                = pg_escape_string(strip_tags(trim($_POST['amount'])));

}
if ($_POST['salary_type'] == 'cash'){
   $company['salary']['salary_type']           = pg_escape_string(strip_tags(trim($_POST['salary_type'])));
   $company['salary']['amount']                = pg_escape_string(strip_tags(trim($_POST['amount'])));
}

    if ($_POST['time_inmonday'] == 'null' || $_POST['time_inmonday'] == 'undefined') {
        $company['work_schedule']['monday'] = null;
    }
    elseif ($_POST['time_inmonday'] != 'null' || $_POST['time_inmonday'] != 'undefined') {
        $company['work_schedule']['monday']['in']          = pg_escape_string($_POST['time_inmonday']);
    }
    if ($_POST['time_outmonday'] == 'null' || $_POST['time_outmonday'] == 'undefined') {
        $company['work_schedule']['monday'] = null;
    }
    elseif ($_POST['time_outmonday'] != 'null' || $_POST['time_outmonday'] != 'undefined') {
       $company['work_schedule']['monday']['out']          = pg_escape_string($_POST['time_outmonday']);
    }
    if ($_POST['flexi_monday'] == 'false' || $_POST['flexi_monday'] == 'undefined') {
        $company['work_schedule']['monday'] = null;
    }
    elseif ($_POST['flexi_monday'] != false || $_POST['flexi_monday'] != 'undefined') {
        $company['work_schedule']['monday']['flexi']        = pg_escape_string($_POST['flexi_monday']);
    }
    if ($_POST['time_intuesday'] == 'null' || $_POST['time_intuesday'] == 'undefined') {
        $company['work_schedule']['sunday'] = null;
    }
    elseif ($_POST['time_intuesday'] != 'null' || $_POST['time_intuesday'] != 'undefined') {
        $company['work_schedule']['tuesday']['in']          = pg_escape_string($_POST['time_intuesday']);
    }
    if ($_POST['time_outtuesday'] == 'null' || $_POST['time_outtuesday'] == 'undefined') {
        $company['work_schedule']['tuesday'] = null;
    }
    elseif ($_POST['time_outtuesday'] != 'null' || $_POST['time_outtuesday'] != 'undefined') {
       $company['work_schedule']['tuesday']['out']          = pg_escape_string($_POST['time_outtuesday']);
    }
    if ($_POST['flexi_tuesday'] == 'false' || $_POST['flexi_tuesday'] == 'undefined') {
        $company['work_schedule']['sunday'] = null;
    }
    elseif ($_POST['flexi_tuesday'] != 'false' || $_POST['flexi_tuesday'] != 'undefined') {
        $company['work_schedule']['tuesday']['flexi']        = pg_escape_string($_POST['flexi_tuesday']);
    }
    if ($_POST['time_inwednesday'] == 'null' || $_POST['time_inwednesday'] == 'undefined') {
        $company['work_schedule']['wednesday'] = null;
    }
    elseif ($_POST['time_inwednesday'] != 'null' || $_POST['time_inwednesday'] != 'undefined') {
        $company['work_schedule']['wednesday']['in']       = pg_escape_string($_POST['time_inwednesday']);
    }
    if ($_POST['time_outwednesday'] == 'null' || $_POST['time_outwednesday'] == 'undefined') {
        $company['work_schedule']['wednesday'] = null;
    }
    elseif ($_POST['time_outwednesday'] != 'null' || $_POST['time_outwednesday'] != 'undefined') {
        $company['work_schedule']['wednesday']['out']       = pg_escape_string($_POST['time_outwednesday']);
    }
    if ($_POST['flexi_wednesday'] == 'false' || $_POST['flexi_wednesday'] == 'undefined') {
        $company['work_schedule']['wednesday'] = null;
    }
    elseif ($_POST['flexi_wednesday'] != 'false' || $_POST['flexi_wednesday'] != 'undefined') {
        $company['work_schedule']['wednesday']['flexi']     = pg_escape_string($_POST['flexi_wednesday']);
    }
    if ($_POST['time_inthursday'] == 'null' || $_POST['time_inthursday'] == 'undefined') {
        $company['work_schedule']['thursday'] = null;
    }
    elseif ($_POST['time_inthursday'] != 'null' || $_POST['time_inthursday'] != 'undefined') {
        $company['work_schedule']['thursday']['in']        = pg_escape_string($_POST['time_inthursday']);
    }
    if ($_POST['time_outthursday'] == 'null' || $_POST['time_outthursday'] == 'undefined') {
        $company['work_schedule']['thursday'] = null;
    }
    elseif ($_POST['time_outthursday'] != 'null' || $_POST['time_outthursday'] != 'undefined') {
        $company['work_schedule']['thursday']['out']        = pg_escape_string($_POST['time_outthursday']);
    }
    if ($_POST['flexi_thursday'] == 'false' || $_POST['flexi_thursday'] == 'undefined') {
        $company['work_schedule']['thursday'] = null;
    }
    elseif ($_POST['flexi_thursday'] != 'false' || $_POST['flexi_thursday'] != 'undefined') {
        $company['work_schedule']['thursday']['flexi']      = pg_escape_string($_POST['flexi_thursday']);
    }
    if ($_POST['time_infriday'] == 'null' || $_POST['time_infriday'] == 'undefined') {
        $company['work_schedule']['friday'] = null;
    }
    elseif ($_POST['time_infriday'] != 'null' || $_POST['time_infriday'] != 'undefined') {
        $company['work_schedule']['friday']['in']          = pg_escape_string($_POST['time_infriday']);
    }
    if ($_POST['time_outfriday'] == 'null' || $_POST['time_outfriday'] == 'undefined') {
        $company['work_schedule']['friday'] = null;
    }
    elseif ($_POST['time_outfriday'] != 'null' || $_POST['time_outfriday'] != 'undefined') {
        $company['work_schedule']['friday']['out']          = pg_escape_string($_POST['time_outfriday']);
    }
    if ($_POST['flexi_friday'] == 'false' || $_POST['flexi_friday'] == 'undefined') {
        $company['work_schedule']['friday'] = null;
    }
    elseif ($_POST['flexi_friday'] != 'false' || $_POST['flexi_friday'] != 'undefined') {
        $company['work_schedule']['friday']['flexi']        = pg_escape_string($_POST['flexi_friday']);
    }
    if ($_POST['time_insaturday'] == 'null' || $_POST['time_insaturday'] == 'undefined') {
        $company['work_schedule']['saturday'] = null;
    }
    elseif ($_POST['time_insaturday'] != 'null' || $_POST['time_insaturday'] != 'undefined') {
        $company['work_schedule']['saturday']['in']        = pg_escape_string($_POST['time_insaturday']);
    }
    if ($_POST['time_outsaturday'] == 'null' || $_POST['time_outsaturday'] == 'undefined') {
        $company['work_schedule']['saturday'] = null;
    }
    elseif ($_POST['time_outsaturday'] != 'null' || $_POST['time_outsaturday'] != 'undefined') {
        $company['work_schedule']['saturday']['out']        = pg_escape_string($_POST['time_outsaturday']);
    }
    if ($_POST['flexi_saturday'] == 'false' || $_POST['flexi_saturday'] == 'undefined') {
        $company['work_schedule']['saturday'] = null;
    }
    elseif ($_POST['flexi_saturday'] != 'false' || $_POST['flexi_saturday'] != 'undefined') {
        $company['work_schedule']['saturday']['flexi']      = pg_escape_string($_POST['flexi_saturday']);
    }
    if ($_POST['time_insunday'] != 'null' || $_POST['time_insunday'] != 'undefined') {
        $company['work_schedule']['sunday']['in']          = pg_escape_string($_POST['time_insunday']);
    }
    elseif ($_POST['time_insunday'] == 'null' || $_POST['time_insunday'] == 'undefined') {
        $company['work_schedule']['sunday'] = null;
    }
    if ($_POST['time_outsunday'] != 'null' || $_POST['time_outsunday'] != 'undefined') {
       $company['work_schedule']['sunday']['out']          = pg_escape_string($_POST['time_outsunday']);
    }
    elseif ($_POST['time_outsunday'] == 'null' || $_POST['time_outsunday'] == 'undefined') {
        $company['work_schedule']['sunday'] = null;
    }
    
    if ($_POST['flexi_sunday'] == 'false' || $_POST['flexi_sunday'] == 'undefined') {
        $company['work_schedule']['sunday'] = null;
    }
    elseif ($_POST['flexi_sunday'] != 'false' || $_POST['flexi_sunday'] != 'undefined') {
        $company['work_schedule']['sunday']['flexi']        = pg_escape_string($_POST['flexi_sunday']);
    }   

if ($_POST['levels_pk'] == 3){
    $company['levels_pk']            = pg_escape_string(strip_tags(trim($_POST['levels_pk'])));
    $company['hours']                = pg_escape_string(strip_tags(trim($_POST['intern_hours'])));
}
if ($_POST['levels_pk'] != 3){
    $company['levels_pk']            = pg_escape_string(strip_tags(trim($_POST['levels_pk'])));
}

//Personal Array!
$personal = array();
$personal['civilstatus_pk']          = pg_escape_string(strip_tags(trim($_POST['civilstatus'])));
$personal['first_name']              = pg_escape_string(strip_tags(trim($_POST['first_name'])));
$personal['middle_name']             = pg_escape_string(strip_tags(trim($_POST['middle_name'])));
$personal['last_name']               = pg_escape_string(strip_tags(trim($_POST['last_name'])));
$personal['gender_pk']               = pg_escape_string(strip_tags(trim($_POST['gender'])));
$personal['religion']                = pg_escape_string(strip_tags(trim($_POST['religion'])));
$personal['email_address']           = pg_escape_string(strip_tags(trim($_POST['email_address'])));
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
$government['data_sss']              = pg_escape_string(strip_tags(trim($_POST['data_sss'])));
$government['data_tin']              = pg_escape_string(strip_tags(trim($_POST['data_tin'])));
$government['data_pagmid']           = pg_escape_string(strip_tags(trim($_POST['data_pagmid'])));
$government['data_phid']             = pg_escape_string(strip_tags(trim($_POST['data_phid'])));

$educations['school_type']           = $education;

$details = array();
$details['company']                  = $company;
$details['personal']                 = $personal; 
$details['education']                = $educations; 
$details['government']               = $government; 
$extra['details']                    = $details; 
$extra['supervisor_pk'] = $_POST['supervisor_pk'];

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