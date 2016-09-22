<?php
require_once('../connect.php');
require_once('../../CLASSES/Default_values.php');
require_once('../../CLASSES/Employees.php');

$class = new Default_values(
                            NULL,
                            'leave',
                            NULL,
                            NULL
            			);


$leave_per_month_data = $class->fetch();
$leave_per_month = json_decode($leave_per_month_data['result'][0]['details'])->leave_per_month;

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
    $leave_balances = (array)json_decode($value['leave_balances']);

    $new_leave_balances=array();
    foreach ($leave_balances as $k => $v) {
        $new_leave_balances[$k] = $v;
    }

    foreach ($leave_per_month as $k => $v) {
        foreach($leave_balances as $x => $y){
            if(intval($k) == intval($x)){
                $new_leave_balances[$k] = floatval($y) + floatval($v);
            }
        }
    }

    $lb=json_encode($new_leave_balances);
    $pk=$value['pk'];
    $sql .= <<<EOT
            update employees set leave_balances = '$lb' where pk = $pk;
EOT;

}
$sql .= 'commit;';

$employees_update = $class->auto_update_leave_balances($sql);
print(json_encode($employees_update));
?>