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
    
    $government['data_sss']            = pg_escape_string(strip_tags(trim($_POST['data_sss'])));
    $government['data_tin']            = pg_escape_string(strip_tags(trim($_POST['data_tin'])));
    $government['data_pagmid']         = pg_escape_string(strip_tags(trim($_POST['data_pagmid'])));
    $government['data_phid']           = pg_escape_string(strip_tags(trim($_POST['data_phid'])));

    $company['work_schedule']['sunday']['ins']          = pg_escape_string($_POST['timein_sunday']);
    $company['work_schedule']['sunday']['out']          = pg_escape_string($_POST['timeout_sunday']);
    $company['work_schedule']['monday']['ins']          = pg_escape_string($_POST['timein_monday']);
    $company['work_schedule']['monday']['out']          = pg_escape_string($_POST['timeout_monday']);
    $company['work_schedule']['tuesday']['ins']         = pg_escape_string($_POST['timein_tuesday']);
    $company['work_schedule']['tuesday']['out']         = pg_escape_string($_POST['timeout_tuesday']);
    $company['work_schedule']['wednesday']['ins']       = pg_escape_string($_POST['timein_wednesday']);
    $company['work_schedule']['wednesday']['out']       = pg_escape_string($_POST['timeout_wednesday']);
    $company['work_schedule']['thursday']['ins']        = pg_escape_string($_POST['timein_thursday']);
    $company['work_schedule']['thursday']['out']        = pg_escape_string($_POST['timeout_thursday']);
    $company['work_schedule']['friday']['ins']          = pg_escape_string($_POST['timein_friday']);
    $company['work_schedule']['friday']['out']          = pg_escape_string($_POST['timeout_friday']);
    $company['work_schedule']['saturday']['ins']        = pg_escape_string($_POST['timein_saturday']);
    $company['work_schedule']['saturday']['out']        = pg_escape_string($_POST['timeout_saturday']);
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
    
    $government['data_sss']            = pg_escape_string(strip_tags(trim($_POST['data_sss'])));
    $government['data_tin']            = pg_escape_string(strip_tags(trim($_POST['data_tin'])));
    $government['data_pagmid']         = pg_escape_string(strip_tags(trim($_POST['data_pagmid'])));
    $government['data_phid']           = pg_escape_string(strip_tags(trim($_POST['data_phid'])));

    $company['work_schedule']['sunday']['ins']          = pg_escape_string($_POST['timein_sunday']);
    $company['work_schedule']['sunday']['out']          = pg_escape_string($_POST['timeout_sunday']);
    $company['work_schedule']['monday']['ins']          = pg_escape_string($_POST['timein_monday']);
    $company['work_schedule']['monday']['out']          = pg_escape_string($_POST['timeout_monday']);
    $company['work_schedule']['tuesday']['ins']         = pg_escape_string($_POST['timein_tuesday']);
    $company['work_schedule']['tuesday']['out']         = pg_escape_string($_POST['timeout_tuesday']);
    $company['work_schedule']['wednesday']['ins']       = pg_escape_string($_POST['timein_wednesday']);
    $company['work_schedule']['wednesday']['out']       = pg_escape_string($_POST['timeout_wednesday']);
    $company['work_schedule']['thursday']['ins']        = pg_escape_string($_POST['timein_thursday']);
    $company['work_schedule']['thursday']['out']        = pg_escape_string($_POST['timeout_thursday']);
    $company['work_schedule']['friday']['ins']          = pg_escape_string($_POST['timein_friday']);
    $company['work_schedule']['friday']['out']          = pg_escape_string($_POST['timeout_friday']);
    $company['work_schedule']['saturday']['ins']        = pg_escape_string($_POST['timein_saturday']);
    $company['work_schedule']['saturday']['out']        = pg_escape_string($_POST['timeout_saturday']);
}   

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
$company['date_started']                       = pg_escape_string(strip_tags(trim($_POST['date_started'])));
$personal['birth_date']                        = pg_escape_string(strip_tags(trim($_POST['birth_date'])));

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