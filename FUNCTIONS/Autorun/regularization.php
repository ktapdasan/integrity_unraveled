<?php
require_once('../connect.php');
require_once('../../CLASSES/LeaveTypes.php');
require_once('../../CLASSES/Employees.php');

$class = new LeaveTypes(
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            'false'
                        );

$leave_types_data = $class->fetch();
//echo "<pre>";

$leave_types = array();
$staggered = array();
$max_per_year = array();
$leave_regularization_days = array();
$leave_regularization_amount = array();
foreach ($leave_types_data['result'] as $key => $value) {
    $details = (array)json_decode($value['details']);
    
    $leave_types[$value['pk']] = 0;
    $staggered[$value['pk']] = $details['staggered'];
    $max_per_year[$value['pk']] = $value['days'];
    $leave_regularization_days[$value['pk']] = $details['regularization'];
    $leave_regularization_amount[$value['pk']] = $details['leaves_regularization'];
}

$class = new Employees(
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL
                        );

$employees_data = $class->fetch();
$employees = $employees_data['result'];

$sql = 'begin;';
foreach ($employees as $key => $value) {
    $employee_details = (array)json_decode($value['details']);
    $employee_company = (array)$employee_details['company'];
    $leave_balances = (array)json_decode($value['leave_balances']);
    

    $employee_company['start_date'];
    $now = time();

    $start_date = strtotime($employee_company['start_date']);
    $datediff = abs($now - $start_date);
    $days = floor($datediff / (60 * 60 * 24));

    $new_leave_balances=$leave_types;

    $temp_leave_balances=array();
    foreach ($leave_balances as $x => $y) {
        $temp_leave_balances[intval($x)] = $y;
    }
    $leave_balances = $temp_leave_balances;

    
    foreach($new_leave_balances as $x => $y){
        //$max_per_year
        if(intval($days) == intval($leave_regularization_days[$x])){
            if($staggered[$x] == "All at once"){
                //saving the maximum leave per leave per year
                $new_leave_balances[$x] = $max_per_year[$x];
            }   
            else {
                //saving the default leave amount upon regularization
                $new_leave_balances[$x] = $leave_regularization_amount[$x];
            }
        }
        else {
            //saving the current leave count of the employee - nothing will change
            $new_leave_balances[$x] = $leave_balances[$x];
        }
    }

    $lb=json_encode($new_leave_balances);
    $pk=$value['pk'];
    $sql .= <<<EOT
            update employees set leave_balances = '$lb' where pk = $pk;
            \n
EOT;

}
$sql .= 'commit;';
$employees_update = $class->auto_update_leave_balances($sql);

header("HTTP/1.0 200 OK");
header('Content-Type: application/json');
print(json_encode($employees_update));
?>