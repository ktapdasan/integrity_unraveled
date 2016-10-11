<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');

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
                            $_POST['salary_amount'],
                            $_POST['gender_pk'],
                            $_POST['religion'],
                            $_POST['employee_status_pk'],
                            $_POST['employment_type_pk'],
                            $_POST['civilstatus_pk'],
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
                            $_POST['timeout_wednesday'],
                            $_POST['timeout_thursday'],
                            $_POST['timeout_friday'],
                            $_POST['timeout_saturday'],
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

if ($_POST['levels_pk'] == 3){
    $company['employee_id']            = pg_escape_string(strip_tags(trim($_POST['employee_id'])));
    $company['levels_pk']              = pg_escape_string(strip_tags(trim($_POST['levels_pk'])));
    $company['hours']                  = pg_escape_string(strip_tags(trim($_POST['intern_hours'])));
    $company['titles_pk']              = pg_escape_string(strip_tags(trim($_POST['titles_pk'])));
    $company['business_email_address'] = pg_escape_string(strip_tags(trim($_POST['business_email_address'])));
    $company['supervisor']             = pg_escape_string(strip_tags(trim($_POST['supervisor_pk'])));
    $company['levels_pk']              = pg_escape_string(strip_tags(trim($_POST['levels_pk'])));
    $company['titles_pk']              = pg_escape_string(strip_tags(trim($_POST['titles_pk'])));
    $company['departments_pk']         = pg_escape_string(strip_tags(trim($_POST['departments_pk'])));
    $company['employee_status_pk']     = pg_escape_string(strip_tags(trim($_POST['employee_status_pk'])));
    $company['employment_type_pk']     = pg_escape_string(strip_tags(trim($_POST['employment_type_pk'])));
    $company['date_started']           = pg_escape_string(strip_tags(trim($_POST['date_started'])));

    $personal['first_name']            = pg_escape_string(strip_tags(trim($_POST['first_name'])));
    $personal['middle_name']           = pg_escape_string(strip_tags(trim($_POST['middle_name'])));
    $personal['last_name']             = pg_escape_string(strip_tags(trim($_POST['last_name'])));
    $personal['email_address']         = pg_escape_string(strip_tags(trim($_POST['email_address'])));
    $personal['contact_number']        = pg_escape_string(strip_tags(trim($_POST['contact_number'])));
    $personal['landline_number']       = pg_escape_string(strip_tags(trim($_POST['landline_number'])));
    $personal['present_address']       = pg_escape_string(strip_tags(trim($_POST['present_address'])));
    $personal['permanent_address']     = pg_escape_string(strip_tags(trim($_POST['permanent_address'])));
    $personal['gender_pk']             = pg_escape_string(strip_tags(trim($_POST['gender_pk'])));
    $personal['religion']              = pg_escape_string(strip_tags(trim($_POST['religion'])));
    $personal['civilstatus_pk']        = pg_escape_string(strip_tags(trim($_POST['civilstatus_pk'])));
    $personal['profile_picture']       = pg_escape_string(strip_tags(trim($_POST['profile_picture'])));
    $personal['emergency_contact_name']     = pg_escape_string(strip_tags(trim($_POST['emergency_contact_name'])));
    $personal['emergency_contact_number']   = pg_escape_string(strip_tags(trim($_POST['emergency_contact_number'])));
    $personal['birth_date']                 = pg_escape_string(strip_tags(trim($_POST['birth_date'])));

    $government['data_sss']            = pg_escape_string(strip_tags(trim($_POST['data_sss'])));
    $government['data_tin']            = pg_escape_string(strip_tags(trim($_POST['data_tin'])));
    $government['data_pagmid']         = pg_escape_string(strip_tags(trim($_POST['data_pagmid'])));
    $government['data_phid']           = pg_escape_string(strip_tags(trim($_POST['data_phid'])));

    if ($_POST['timein_sunday'] == 'null' || $_POST['timein_sunday'] == 'undefined') {
        $company['work_schedule']['sunday'] = null;
    }
    elseif ($_POST['timein_sunday'] != 'null' || $_POST['timein_sunday'] != 'undefined') {
        $company['work_schedule']['sunday']['in']          = pg_escape_string($_POST['timein_sunday']);
    }
    if ($_POST['timeout_sunday'] == 'null' || $_POST['timeout_sunday'] == 'undefined') {
        $company['work_schedule']['sunday'] = null;
    }
    elseif ($_POST['timeout_sunday'] != 'null' || $_POST['timeout_sunday'] !== 'undefined') {
       $company['work_schedule']['sunday']['out']          = pg_escape_string($_POST['timeout_sunday']);
    }
    if ($_POST['flexi_sunday'] == 'false' || $_POST['flexi_sunday'] == 'undefined') {
        $company['work_schedule']['sunday'] = null;
    }
    else if ($_POST['flexi_sunday'] != 'false' || $_POST['flexi_sunday'] != 'undefined') {
        $company['work_schedule']['sunday']['flexi']        = pg_escape_string($_POST['flexi_sunday']);
    }
    if ($_POST['timein_monday'] == 'null' || $_POST['timein_monday'] == 'undefined') {
        $company['work_schedule']['monday'] = null;
    }
    elseif ($_POST['timein_monday'] != 'null' || $_POST['timein_monday'] != 'undefined') {
        $company['work_schedule']['monday']['in']          = pg_escape_string($_POST['timein_monday']);
    }
    if ($_POST['timeout_monday'] == 'null' || $_POST['timeout_monday'] == 'undefined') {
        $company['work_schedule']['monday'] = null;
    }
    elseif ($_POST['timeout_monday'] != 'null' || $_POST['timeout_monday'] !== 'undefined') {
       $company['work_schedule']['monday']['out']          = pg_escape_string($_POST['timeout_monday']);
    }
    if ($_POST['flexi_monday'] == 'false' || $_POST['flexi_monday'] == 'undefined') {
        $company['work_schedule']['monday'] = null;
    }
    else if ($_POST['flexi_monday'] != false || $_POST['flexi_monday'] != 'undefined') {
        $company['work_schedule']['monday']['flexi']        = pg_escape_string($_POST['flexi_monday']);
    }
    if ($_POST['timein_tuesday'] == 'null' || $_POST['timein_tuesday'] == 'undefined') {
        $company['work_schedule']['sunday'] = null;
    }
    elseif ($_POST['timein_tuesday'] != 'null' || $_POST['timein_tuesday'] != 'undefined') {
        $company['work_schedule']['tuesday']['in']          = pg_escape_string($_POST['timein_tuesday']);
    }
    if ($_POST['timeout_tuesday'] == 'null' || $_POST['timeout_tuesday'] == 'undefined') {
        $company['work_schedule']['tuesday'] = null;
    }
    elseif ($_POST['timeout_tuesday'] != 'null' || $_POST['timeout_tuesday'] !== 'undefined') {
       $company['work_schedule']['tuesday']['out']          = pg_escape_string($_POST['timeout_tuesday']);
    }
    if ($_POST['flexi_tuesday'] == 'false' || $_POST['flexi_tuesday'] == 'undefined') {
        $company['work_schedule']['sunday'] = null;
    }
    else if ($_POST['flexi_tuesday'] != 'false' || $_POST['flexi_tuesday'] != 'undefined') {
        $company['work_schedule']['tuesday']['flexi']        = pg_escape_string($_POST['flexi_tuesday']);
    }
    if ($_POST['timein_wednesday'] == 'null' || $_POST['timein_wednesday'] == 'undefined') {
        $company['work_schedule']['wednesday'] = null;
    }
    elseif ($_POST['timein_wednesday'] != 'null' || $_POST['timein_wednesday'] != 'undefined') {
        $company['work_schedule']['wednesday']['in']       = pg_escape_string($_POST['timein_wednesday']);
    }
    if ($_POST['timeout_wednesday'] == 'null' || $_POST['timeout_wednesday'] == 'undefined') {
        $company['work_schedule']['wednesday'] = null;
    }
    elseif ($_POST['timeout_wednesday'] != 'null' || $_POST['timeout_wednesday'] != 'undefined') {
        $company['work_schedule']['wednesday']['out']       = pg_escape_string($_POST['timeout_wednesday']);
    }
    if ($_POST['flexi_wednesday'] == 'false' || $_POST['flexi_wednesday'] == 'undefined') {
        $company['work_schedule']['wednesday'] = null;
    }
    elseif ($_POST['flexi_wednesday'] != 'false' || $_POST['flexi_wednesday'] != 'undefined') {
        $company['work_schedule']['wednesday']['flexi']     = pg_escape_string($_POST['flexi_wednesday']);
    }
    if ($_POST['timein_thursday'] == 'null' || $_POST['timein_thursday'] == 'undefined') {
        $company['work_schedule']['thursday'] = null;
    }
    elseif ($_POST['timein_thursday'] != 'null' || $_POST['timein_thursday'] != 'undefined') {
        $company['work_schedule']['thursday']['in']        = pg_escape_string($_POST['timein_thursday']);
    }
    if ($_POST['timeout_thursday'] == 'null' || $_POST['timeout_thursday'] == 'undefined') {
        $company['work_schedule']['thursday'] = null;
    }
    elseif ($_POST['timeout_thursday'] != 'null' || $_POST['timeout_thursday'] != 'undefined') {
        $company['work_schedule']['thursday']['out']        = pg_escape_string($_POST['timeout_thursday']);
    }
    if ($_POST['flexi_thursday'] == 'false' || $_POST['flexi_thursday'] == 'undefined') {
        $company['work_schedule']['thursday'] = null;
    }
    elseif ($_POST['flexi_thursday'] != 'false' || $_POST['flexi_thursday'] != 'undefined') {
        $company['work_schedule']['thursday']['flexi']      = pg_escape_string($_POST['flexi_thursday']);
    }
    if ($_POST['timein_friday'] == 'null' || $_POST['timein_friday'] == 'undefined') {
        $company['work_schedule']['friday'] = null;
    }
    elseif ($_POST['timein_friday'] != 'null' || $_POST['timein_friday'] != 'undefined') {
        $company['work_schedule']['friday']['in']          = pg_escape_string($_POST['timein_friday']);
    }
    if ($_POST['timeout_friday'] == 'null' || $_POST['timeout_friday'] == 'undefined') {
        $company['work_schedule']['friday'] = null;
    }
    elseif ($_POST['timeout_friday'] != 'null' || $_POST['timeout_friday'] != 'undefined') {
        $company['work_schedule']['friday']['out']          = pg_escape_string($_POST['timeout_friday']);
    }
    if ($_POST['flexi_friday'] == 'false' || $_POST['flexi_friday'] == 'undefined') {
        $company['work_schedule']['friday'] = null;
    }
    elseif ($_POST['flexi_friday'] != 'false' || $_POST['flexi_friday'] != 'undefined') {
        $company['work_schedule']['friday']['flexi']        = pg_escape_string($_POST['flexi_friday']);
    }
    if ($_POST['timein_saturday'] == 'null' || $_POST['timein_saturday'] == 'undefined') {
        $company['work_schedule']['saturday'] = null;
    }
    elseif ($_POST['timein_saturday'] != 'null' || $_POST['timein_saturday'] != 'undefined') {
        $company['work_schedule']['saturday']['in']        = pg_escape_string($_POST['timein_saturday']);
    }
    if ($_POST['timeout_saturday'] == 'null' || $_POST['timeout_saturday'] == 'undefined') {
        $company['work_schedule']['saturday'] = null;
    }
    elseif ($_POST['timeout_saturday'] != 'null' || $_POST['timeout_saturday'] != 'undefined') {
        $company['work_schedule']['saturday']['out']        = pg_escape_string($_POST['timeout_saturday']);
    }
    if ($_POST['flexi_saturday'] == 'false' || $_POST['flexi_saturday'] == 'undefined') {
        $company['work_schedule']['saturday'] = null;
    }
    elseif ($_POST['flexi_saturday'] != 'false' || $_POST['flexi_saturday'] != 'undefined') {
        $company['work_schedule']['saturday']['flexi']      = pg_escape_string($_POST['flexi_saturday']);
    }
}
    
if ($_POST['levels_pk'] != 3){
    $company['employee_id']            = pg_escape_string(strip_tags(trim($_POST['employee_id'])));
    $company['levels_pk']              = pg_escape_string(strip_tags(trim($_POST['levels_pk'])));
    $company['titles_pk']              = pg_escape_string(strip_tags(trim($_POST['titles_pk'])));
    $company['business_email_address'] = pg_escape_string(strip_tags(trim($_POST['business_email_address'])));
    $company['departments_pk']         = pg_escape_string(strip_tags(trim($_POST['departments_pk'])));
    $company['supervisor']             = pg_escape_string(strip_tags(trim($_POST['supervisor_pk'])));
    $company['levels_pk']              = pg_escape_string(strip_tags(trim($_POST['levels_pk'])));
    $company['titles_pk']              = pg_escape_string(strip_tags(trim($_POST['titles_pk'])));
    $company['departments_pk']         = pg_escape_string(strip_tags(trim($_POST['departments_pk'])));
    $company['employee_status_pk']     = pg_escape_string(strip_tags(trim($_POST['employee_status_pk'])));
    $company['employment_type_pk']     = pg_escape_string(strip_tags(trim($_POST['employment_type_pk'])));

    $personal['first_name']            = pg_escape_string(strip_tags(trim($_POST['first_name'])));
    $personal['middle_name']           = pg_escape_string(strip_tags(trim($_POST['middle_name'])));
    $personal['last_name']             = pg_escape_string(strip_tags(trim($_POST['last_name'])));
    $personal['email_address']         = pg_escape_string(strip_tags(trim($_POST['email_address'])));
    $personal['contact_number']        = pg_escape_string(strip_tags(trim($_POST['contact_number'])));
    $personal['landline_number']       = pg_escape_string(strip_tags(trim($_POST['landline_number'])));
    $personal['present_address']       = pg_escape_string(strip_tags(trim($_POST['present_address'])));
    $personal['permanent_address']     = pg_escape_string(strip_tags(trim($_POST['permanent_address'])));
    $personal['gender_pk']             = pg_escape_string(strip_tags(trim($_POST['gender_pk'])));
    $personal['religion']              = pg_escape_string(strip_tags(trim($_POST['religion'])));
    $personal['civilstatus_pk']        = pg_escape_string(strip_tags(trim($_POST['civilstatus_pk'])));
    $personal['profile_picture']       = pg_escape_string(strip_tags(trim($_POST['profile_picture'])));
    $personal['emergency_contact_name']     = pg_escape_string(strip_tags(trim($_POST['emergency_contact_name'])));
    $personal['emergency_contact_number']   = pg_escape_string(strip_tags(trim($_POST['emergency_contact_number'])));
    $personal['birth_date']                 = pg_escape_string(strip_tags(trim($_POST['birth_date'])));

    $government['data_sss']            = pg_escape_string(strip_tags(trim($_POST['data_sss'])));
    $government['data_tin']            = pg_escape_string(strip_tags(trim($_POST['data_tin'])));
    $government['data_pagmid']         = pg_escape_string(strip_tags(trim($_POST['data_pagmid'])));
    $government['data_phid']           = pg_escape_string(strip_tags(trim($_POST['data_phid'])));

    //FALSE
    if ($_POST['timein_sunday'] == 'null' || $_POST['timein_sunday'] == 'undefined') {
        $company['work_schedule']['sunday'] = null;
    }
    elseif ($_POST['timein_sunday'] != 'null' || $_POST['timein_sunday'] != 'undefined') {
        $company['work_schedule']['sunday']['in']          = pg_escape_string($_POST['timein_sunday']);
    }
    if ($_POST['timeout_sunday'] == 'null' || $_POST['timeout_sunday'] == 'undefined') {
        $company['work_schedule']['sunday'] = null;
    }
    elseif ($_POST['timeout_sunday'] != 'null' || $_POST['timeout_sunday'] !== 'undefined') {
       $company['work_schedule']['sunday']['out']          = pg_escape_string($_POST['timeout_sunday']);
    }
    if ($_POST['flexi_sunday'] == 'false' || $_POST['flexi_sunday'] == 'undefined') {
        $company['work_schedule']['sunday'] = null;
    }
    else if ($_POST['flexi_sunday'] != 'false' || $_POST['flexi_sunday'] != 'undefined') {
        $company['work_schedule']['sunday']['flexi']        = pg_escape_string($_POST['flexi_sunday']);
    }
    if ($_POST['timein_monday'] == 'null' || $_POST['timein_monday'] == 'undefined') {
        $company['work_schedule']['monday'] = null;
    }
    elseif ($_POST['timein_monday'] != 'null' || $_POST['timein_monday'] != 'undefined') {
        $company['work_schedule']['monday']['in']          = pg_escape_string($_POST['timein_monday']);
    }
    if ($_POST['timeout_monday'] == 'null' || $_POST['timeout_monday'] == 'undefined') {
        $company['work_schedule']['monday'] = null;
    }
    elseif ($_POST['timeout_monday'] != 'null' || $_POST['timeout_monday'] !== 'undefined') {
       $company['work_schedule']['monday']['out']          = pg_escape_string($_POST['timeout_monday']);
    }
    if ($_POST['flexi_monday'] == 'false' || $_POST['flexi_monday'] == 'undefined') {
        $company['work_schedule']['monday'] = null;
    }
    else if ($_POST['flexi_monday'] != false || $_POST['flexi_monday'] != 'undefined') {
        $company['work_schedule']['monday']['flexi']        = pg_escape_string($_POST['flexi_monday']);
    }
    if ($_POST['timein_tuesday'] == 'null' || $_POST['timein_tuesday'] == 'undefined') {
        $company['work_schedule']['sunday'] = null;
    }
    elseif ($_POST['timein_tuesday'] != 'null' || $_POST['timein_tuesday'] != 'undefined') {
        $company['work_schedule']['tuesday']['in']          = pg_escape_string($_POST['timein_tuesday']);
    }
    if ($_POST['timeout_tuesday'] == 'null' || $_POST['timeout_tuesday'] == 'undefined') {
        $company['work_schedule']['tuesday'] = null;
    }
    elseif ($_POST['timeout_tuesday'] != 'null' || $_POST['timeout_tuesday'] !== 'undefined') {
       $company['work_schedule']['tuesday']['out']          = pg_escape_string($_POST['timeout_tuesday']);
    }
    if ($_POST['flexi_tuesday'] == 'false' || $_POST['flexi_tuesday'] == 'undefined') {
        $company['work_schedule']['sunday'] = null;
    }
    else if ($_POST['flexi_tuesday'] != 'false' || $_POST['flexi_tuesday'] != 'undefined') {
        $company['work_schedule']['tuesday']['flexi']        = pg_escape_string($_POST['flexi_tuesday']);
    }
    if ($_POST['timein_wednesday'] == 'null' || $_POST['timein_wednesday'] == 'undefined') {
        $company['work_schedule']['wednesday'] = null;
    }
    elseif ($_POST['timein_wednesday'] != 'null' || $_POST['timein_wednesday'] != 'undefined') {
        $company['work_schedule']['wednesday']['in']       = pg_escape_string($_POST['timein_wednesday']);
    }
    if ($_POST['timeout_wednesday'] == 'null' || $_POST['timeout_wednesday'] == 'undefined') {
        $company['work_schedule']['wednesday'] = null;
    }
    elseif ($_POST['timeout_wednesday'] != 'null' || $_POST['timeout_wednesday'] != 'undefined') {
        $company['work_schedule']['wednesday']['out']       = pg_escape_string($_POST['timeout_wednesday']);
    }
    if ($_POST['flexi_wednesday'] == 'false' || $_POST['flexi_wednesday'] == 'undefined') {
        $company['work_schedule']['wednesday'] = null;
    }
    elseif ($_POST['flexi_wednesday'] != 'false' || $_POST['flexi_wednesday'] != 'undefined') {
        $company['work_schedule']['wednesday']['flexi']     = pg_escape_string($_POST['flexi_wednesday']);
    }
    if ($_POST['timein_thursday'] == 'null' || $_POST['timein_thursday'] == 'undefined') {
        $company['work_schedule']['thursday'] = null;
    }
    elseif ($_POST['timein_thursday'] != 'null' || $_POST['timein_thursday'] != 'undefined') {
        $company['work_schedule']['thursday']['in']        = pg_escape_string($_POST['timein_thursday']);
    }
    if ($_POST['timeout_thursday'] == 'null' || $_POST['timeout_thursday'] == 'undefined') {
        $company['work_schedule']['thursday'] = null;
    }
    elseif ($_POST['timeout_thursday'] != 'null' || $_POST['timeout_thursday'] != 'undefined') {
        $company['work_schedule']['thursday']['out']        = pg_escape_string($_POST['timeout_thursday']);
    }
    if ($_POST['flexi_thursday'] == 'false' || $_POST['flexi_thursday'] == 'undefined') {
        $company['work_schedule']['thursday'] = null;
    }
    elseif ($_POST['flexi_thursday'] != 'false' || $_POST['flexi_thursday'] != 'undefined') {
        $company['work_schedule']['thursday']['flexi']      = pg_escape_string($_POST['flexi_thursday']);
    }
    if ($_POST['timein_friday'] == 'null' || $_POST['timein_friday'] == 'undefined') {
        $company['work_schedule']['friday'] = null;
    }
    elseif ($_POST['timein_friday'] != 'null' || $_POST['timein_friday'] != 'undefined') {
        $company['work_schedule']['friday']['in']          = pg_escape_string($_POST['timein_friday']);
    }
    if ($_POST['timeout_friday'] == 'null' || $_POST['timeout_friday'] == 'undefined') {
        $company['work_schedule']['friday'] = null;
    }
    elseif ($_POST['timeout_friday'] != 'null' || $_POST['timeout_friday'] != 'undefined') {
        $company['work_schedule']['friday']['out']          = pg_escape_string($_POST['timeout_friday']);
    }
    if ($_POST['flexi_friday'] == 'false' || $_POST['flexi_friday'] == 'undefined') {
        $company['work_schedule']['friday'] = null;
    }
    elseif ($_POST['flexi_friday'] != 'false' || $_POST['flexi_friday'] != 'undefined') {
        $company['work_schedule']['friday']['flexi']        = pg_escape_string($_POST['flexi_friday']);
    }
    if ($_POST['timein_saturday'] == 'null' || $_POST['timein_saturday'] == 'undefined') {
        $company['work_schedule']['saturday'] = null;
    }
    elseif ($_POST['timein_saturday'] != 'null' || $_POST['timein_saturday'] != 'undefined') {
        $company['work_schedule']['saturday']['in']        = pg_escape_string($_POST['timein_saturday']);
    }
    if ($_POST['timeout_saturday'] == 'null' || $_POST['timeout_saturday'] == 'undefined') {
        $company['work_schedule']['saturday'] = null;
    }
    elseif ($_POST['timeout_saturday'] != 'null' || $_POST['timeout_saturday'] != 'undefined') {
        $company['work_schedule']['saturday']['out']        = pg_escape_string($_POST['timeout_saturday']);
    }
    if ($_POST['flexi_saturday'] == 'false' || $_POST['flexi_saturday'] == 'undefined') {
        $company['work_schedule']['saturday'] = null;
    }
    elseif ($_POST['flexi_saturday'] != 'false' || $_POST['flexi_saturday'] != 'undefined') {
        $company['work_schedule']['saturday']['flexi']      = pg_escape_string($_POST['flexi_saturday']);
    }

    $company['date_started']                            = pg_escape_string(strip_tags(trim($_POST['date_started'])));
    
    //Salary Type
    if ($_POST['salary_type'] == 'bank'){
        $company['salary']['salary_type']          = pg_escape_string(strip_tags(trim($_POST['salary_type'])));
        $company['salary']['bank_name']            = pg_escape_string(strip_tags(trim($_POST['salary_bank_name'])));
        $company['salary']['account_number']       = pg_escape_string(strip_tags(trim($_POST['salary_account_number'])));
        $company['salary']['amount']               = pg_escape_string(strip_tags(trim($_POST['salary_amount'])));

    }
    if ($_POST['salary_type'] == 'wire'){
       $company['salary']['salary_type']           = pg_escape_string(strip_tags(trim($_POST['salary_type'])));
       $company['salary']['mode_payment']          = pg_escape_string(strip_tags(trim($_POST['salary_mode_payment'])));
       $company['salary']['account_number']        = pg_escape_string(strip_tags(trim($_POST['salary_account_number'])));
       $company['salary']['amount']                = pg_escape_string(strip_tags(trim($_POST['salary_amount'])));

    }
    if ($_POST['salary_type'] == 'cash'){
       $company['salary']['salary_type']           = pg_escape_string(strip_tags(trim($_POST['salary_type'])));
       $company['salary']['amount']                = pg_escape_string(strip_tags(trim($_POST['salary_amount'])));
    } 
}   

$details = array();
$details['company'] = $company;
$details['personal'] = $personal;
$details['government'] = $government;

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