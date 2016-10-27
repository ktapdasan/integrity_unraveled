<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');

$educationk = json_decode($_POST['educations'], true);


$class =  new Employees(
                            $_POST['pk'],
                            $_POST['employee_id'],
                            $_POST['first_name'],
                            $_POST['middle_name'],
                            $_POST['last_name'],
                            $_POST['email_address'],
                            $_POST['business_email_address'],
                            $_POST['titles_pk'],
                            $_POST['levels_pk'],
                            $_POST['departments_pk'],
                            $_POST['contact_number'],
                            $_POST['landline_number'],
                            $_POST['present_address'],
                            $_POST['permanent_address'],
                            $_POST['data_sss'],
                            $_POST['data_tin'],
                            $_POST['data_pagmid'],
                            $_POST['salary_type'],
                            $_POST['salary_bank_name'],
                            $_POST['salary_mode_payment'],
                            $_POST['salary_account_number'],
                            $_POST['amount'],
                            $_POST['gender'],
                            $_POST['pay_period'],
                            $_POST['landline_number'],
                            $_POST['rate_type'],
                            $_POST['religion'],
                            $_POST['employee_status'],
                            $_POST['employment_type'],
                            $_POST['civilstatus'],
                            $_POST['birth_date'],
                            $_POST['date_started'],
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
                            $_POST['timeout_thursday'],
                            $_POST['timeout_friday'],
                            $_POST['timeout_saturday'],
                            $_POST['timeout_wednesday'],
                            $_POST['profile_picture'],
                            $_POST['emergency_contact_name'],
                            $_POST['emergency_contact_number'],
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

$company = array();
$personal = array();
$government = array();
$education = array();

if ($_POST['levels_pk'] == 3){
    $company['employee_id']            = pg_escape_string(strip_tags(trim($_POST['employee_id'])));
    $company['levels_pk']              = pg_escape_string(strip_tags(trim($_POST['levels_pk'])));
    $company['hours']                  = pg_escape_string(strip_tags(trim($_POST['intern_hours'])));
    $company['titles_pk']              = pg_escape_string(strip_tags(trim($_POST['titles_pk'])));
    $company['business_email_address'] = pg_escape_string(strip_tags(trim($_POST['business_email_address'])));
    $company['supervisor']             = pg_escape_string(strip_tags(trim($_POST['supervisor_pk'])));
    $company['titles_pk']              = pg_escape_string(strip_tags(trim($_POST['titles_pk'])));
    $company['departments_pk']         = pg_escape_string(strip_tags(trim($_POST['departments_pk'])));
    $company['employee_status']     = pg_escape_string(strip_tags(trim($_POST['employee_status'])));
    $company['employment_type']     = pg_escape_string(strip_tags(trim($_POST['employment_type'])));
    $company['date_started']           = pg_escape_string(strip_tags(trim($_POST['date_started'])));

    $personal['first_name']            = pg_escape_string(strip_tags(trim($_POST['first_name'])));
    $personal['middle_name']           = pg_escape_string(strip_tags(trim($_POST['middle_name'])));
    $personal['last_name']             = pg_escape_string(strip_tags(trim($_POST['last_name'])));
    $personal['email_address']         = pg_escape_string(strip_tags(trim($_POST['email_address'])));
    $personal['contact_number']        = pg_escape_string(strip_tags(trim($_POST['contact_number'])));
    $personal['landline_number']       = pg_escape_string(strip_tags(trim($_POST['landline_number'])));
    $personal['present_address']       = pg_escape_string(strip_tags(trim($_POST['present_address'])));
    $personal['permanent_address']     = pg_escape_string(strip_tags(trim($_POST['permanent_address'])));
    $personal['gender']             = pg_escape_string(strip_tags(trim($_POST['gender'])));
    $personal['religion']              = pg_escape_string(strip_tags(trim($_POST['religion'])));
    $personal['civilstatus']        = pg_escape_string(strip_tags(trim($_POST['civilstatus'])));
    $personal['profile_picture']       = pg_escape_string(strip_tags(trim($_POST['profile_picture'])));
    $personal['emergency_contact_name']     = pg_escape_string(strip_tags(trim($_POST['emergency_contact_name'])));
    $personal['emergency_contact_number']   = pg_escape_string(strip_tags(trim($_POST['emergency_contact_number'])));
    $personal['birth_date']                 = pg_escape_string(strip_tags(trim($_POST['birth_date'])));

    $government['data_sss']            = pg_escape_string(strip_tags(trim($_POST['data_sss'])));
    $government['data_tin']            = pg_escape_string(strip_tags(trim($_POST['data_tin'])));
    $government['data_pagmid']         = pg_escape_string(strip_tags(trim($_POST['data_pagmid'])));
    $government['data_phid']           = pg_escape_string(strip_tags(trim($_POST['data_phid'])));

    $educations['school_type']           = $educationk;
}
    
if ($_POST['levels_pk'] != 3){
    $company['employee_id']            = pg_escape_string(strip_tags(trim($_POST['employee_id'])));
    $company['levels_pk']              = pg_escape_string(strip_tags(trim($_POST['levels_pk'])));
    $company['titles_pk']              = pg_escape_string(strip_tags(trim($_POST['titles_pk'])));
    $company['business_email_address'] = pg_escape_string(strip_tags(trim($_POST['business_email_address'])));
    $company['departments_pk']         = pg_escape_string(strip_tags(trim($_POST['departments_pk'])));
    $company['supervisor']             = pg_escape_string(strip_tags(trim($_POST['supervisor_pk'])));
    $company['titles_pk']              = pg_escape_string(strip_tags(trim($_POST['titles_pk'])));
    $company['departments_pk']         = pg_escape_string(strip_tags(trim($_POST['departments_pk'])));
    $company['employee_status']        = pg_escape_string(strip_tags(trim($_POST['employee_status'])));
    $company['employment_type']        = pg_escape_string(strip_tags(trim($_POST['employment_type'])));
    $company['date_started']           = pg_escape_string(strip_tags(trim($_POST['date_started'])));

    $personal['first_name']            = pg_escape_string(strip_tags(trim($_POST['first_name'])));
    $personal['middle_name']           = pg_escape_string(strip_tags(trim($_POST['middle_name'])));
    $personal['last_name']             = pg_escape_string(strip_tags(trim($_POST['last_name'])));
    $personal['email_address']         = pg_escape_string(strip_tags(trim($_POST['email_address'])));
    $personal['contact_number']        = pg_escape_string(strip_tags(trim($_POST['contact_number'])));
    $personal['landline_number']       = pg_escape_string(strip_tags(trim($_POST['landline_number'])));
    $personal['present_address']       = pg_escape_string(strip_tags(trim($_POST['present_address'])));
    $personal['permanent_address']     = pg_escape_string(strip_tags(trim($_POST['permanent_address'])));
    $personal['gender']                = pg_escape_string(strip_tags(trim($_POST['gender'])));
    $personal['religion']              = pg_escape_string(strip_tags(trim($_POST['religion'])));
    $personal['civilstatus']           = pg_escape_string(strip_tags(trim($_POST['civilstatus'])));
    $personal['profile_picture']       = pg_escape_string(strip_tags(trim($_POST['profile_picture'])));
    $personal['emergency_contact_name']     = pg_escape_string(strip_tags(trim($_POST['emergency_contact_name'])));
    $personal['emergency_contact_number']   = pg_escape_string(strip_tags(trim($_POST['emergency_contact_number'])));
    $personal['birth_date']                 = pg_escape_string(strip_tags(trim($_POST['birth_date'])));

    $government['data_sss']            = pg_escape_string(strip_tags(trim($_POST['data_sss'])));
    $government['data_tin']            = pg_escape_string(strip_tags(trim($_POST['data_tin'])));
    $government['data_pagmid']         = pg_escape_string(strip_tags(trim($_POST['data_pagmid'])));
    $government['data_phid']           = pg_escape_string(strip_tags(trim($_POST['data_phid'])));

    $educations['school_type']           = $educationk;

    //Salary Type
    if ($_POST['salary_type'] == 'bank'){
        $company['salary']['salary_type']          = pg_escape_string(strip_tags(trim($_POST['salary_type'])));
        $company['salary']['rate_type_pk']            = pg_escape_string(strip_tags(trim($_POST['rate_type'])));
        $company['salary']['pay_period_pk']            = pg_escape_string(strip_tags(trim($_POST['pay_period'])));
        $company['salary']['details']['bank_name']            = pg_escape_string(strip_tags(trim($_POST['salary_bank_name'])));
        $company['salary']['details']['account_number']       = pg_escape_string(strip_tags(trim($_POST['salary_account_number'])));
        $company['salary']['details']['amount']               = pg_escape_string(strip_tags(trim($_POST['amount'])));

    }
    if ($_POST['salary_type'] == 'wire'){
       $company['salary']['salary_type']           = pg_escape_string(strip_tags(trim($_POST['salary_type'])));
       $company['salary']['rate_type_pk']             = pg_escape_string(strip_tags(trim($_POST['rate_type'])));
       $company['salary']['pay_period_pk']            = pg_escape_string(strip_tags(trim($_POST['pay_period'])));
       $company['salary']['details']['mode_payment']          = pg_escape_string(strip_tags(trim($_POST['salary_mode_payment'])));
       $company['salary']['details']['account_number']        = pg_escape_string(strip_tags(trim($_POST['salary_account_number'])));
       $company['salary']['details']['amount']                = pg_escape_string(strip_tags(trim($_POST['amount'])));

    }
    if ($_POST['salary_type'] == 'cash'){
       $company['salary']['salary_type']           = pg_escape_string(strip_tags(trim($_POST['salary_type'])));
       $company['salary']['rate_type_pk']            = pg_escape_string(strip_tags(trim($_POST['rate_type'])));
       $company['salary']['pay_period_pk']            = pg_escape_string(strip_tags(trim($_POST['pay_period'])));
       $company['salary']['details']['amount']                = pg_escape_string(strip_tags(trim($_POST['amount'])));
    }
}

if ($_POST['timein_sunday'] != 'data' ) {
    $company['work_schedule']['sunday']['in'] = pg_escape_string($_POST['timein_sunday']);
}
if ($_POST['timeout_sunday'] != 'data' ) {
    $company['work_schedule']['sunday']['out'] = pg_escape_string($_POST['timeout_sunday']);
}
if ($_POST['flexi_sunday'] == 'false' || $_POST['flexi_sunday'] == 'true') {
    $company['work_schedule']['sunday']['flexible'] = pg_escape_string($_POST['flexi_sunday']);
}
if($_POST['timein_sunday'] && $_POST['timeout_sunday'] == 'data' && $_POST['flexi_sunday'] == 'false') {
   $company['work_schedule']['sunday'] = null;
}

if ($_POST['timein_monday'] != 'data' ) {
    $company['work_schedule']['monday']['in'] = pg_escape_string($_POST['timein_monday']);
}
if ($_POST['timeout_monday'] != 'data' ) {
    $company['work_schedule']['monday']['out'] = pg_escape_string($_POST['timeout_monday']);
}
if ($_POST['flexi_monday'] != 'false' || $_POST['flexi_monday'] == 'true') {
    $company['work_schedule']['monday']['flexible'] = pg_escape_string($_POST['flexi_monday']);
}
if($_POST['timein_monday'] && $_POST['timeout_monday'] == 'data' && $_POST['flexi_monday'] == 'false') {
   $company['work_schedule']['monday'] = null;
}

if ($_POST['timein_tuesday'] != 'data' ) {
    $company['work_schedule']['tuesday']['in'] = pg_escape_string($_POST['timein_tuesday']);
}
if ($_POST['timeout_tuesday'] != 'data' ) {
    $company['work_schedule']['tuesday']['out'] = pg_escape_string($_POST['timeout_tuesday']);
}
if ($_POST['flexi_tuesday'] != 'data' ) {
    $company['work_schedule']['tuesday']['flexible'] = pg_escape_string($_POST['flexi_tuesday']);
}
if($_POST['timein_tuesday'] && $_POST['timeout_tuesday'] == 'data' && $_POST['flexi_tuesday'] == 'false') {
   $company['work_schedule']['tuesday'] = null;
}

if ($_POST['timein_wednesday'] != 'data' ) {
    $company['work_schedule']['wednesday']['in'] = pg_escape_string($_POST['timein_wednesday']);
}
if ($_POST['timeout_wednesday'] != 'data' ) {
    $company['work_schedule']['wednesday']['out'] = pg_escape_string($_POST['timeout_wednesday']);
}
if ($_POST['flexi_wednesday'] != 'data' ) {
    $company['work_schedule']['wednesday']['flexible'] = pg_escape_string($_POST['flexi_wednesday']);
}
if($_POST['timein_wednesday'] && $_POST['timeout_wednesday'] == 'data' && $_POST['flexi_wednesday'] == 'false') {
   $company['work_schedule']['wednesday'] = null;
}

if ($_POST['timein_thursday'] != 'data' ) {
    $company['work_schedule']['thursday']['in'] = pg_escape_string($_POST['timein_thursday']);
}
if ($_POST['timeout_thursday'] != 'data' ) {
    $company['work_schedule']['thursday']['out'] = pg_escape_string($_POST['timeout_thursday']);
}
if ($_POST['flexi_thursday'] != 'data' ) {
    $company['work_schedule']['thursday']['flexible'] = pg_escape_string($_POST['flexi_thursday']);
}
if($_POST['timein_thursday'] && $_POST['timeout_thursday'] == 'data' && $_POST['flexi_thursday'] == 'false') {
   $company['work_schedule']['thursday'] = null;
}

if ($_POST['timein_friday'] != 'data' ) {
    $company['work_schedule']['friday']['in'] = pg_escape_string($_POST['timein_friday']);
}
if ($_POST['timeout_friday'] != 'data' ) {
    $company['work_schedule']['friday']['out'] = pg_escape_string($_POST['timeout_friday']);
}
if ($_POST['flexi_friday'] != 'data' ) {
    $company['work_schedule']['friday']['flexible'] = pg_escape_string($_POST['flexi_friday']);
}
if($_POST['timein_friday'] && $_POST['timeout_friday'] == 'data' && $_POST['flexi_friday'] == 'false') {
   $company['work_schedule']['friday'] = null;
}

if ($_POST['timein_saturday'] != 'data' ) {
    $company['work_schedule']['saturday']['in'] = pg_escape_string($_POST['timein_saturday']);
}
if ($_POST['timeout_saturday'] != 'data' ) {
    $company['work_schedule']['saturday']['out'] = pg_escape_string($_POST['timeout_saturday']);
}
if ($_POST['flexi_saturday'] != 'data' ) {
    $company['work_schedule']['saturday']['flexible'] = pg_escape_string($_POST['flexi_saturday']);
}
if($_POST['timein_saturday'] && $_POST['timeout_saturday'] == 'data' && $_POST['flexi_saturday'] == 'false') {
   $company['work_schedule']['saturday'] = null;
}

$details = array();
$details['company'] = $company;
$details['personal'] = $personal;
$details['government'] = $government;
$details['education'] = $educations; 

$extra['details'] = $details;
$extra['supervisor_pk'] = $_POST['supervisor_pk'];
$data = $class -> update_employees($extra);

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
    header("HTTP/1.0 200 OK");
}                  

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 