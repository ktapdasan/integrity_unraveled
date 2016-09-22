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

$birthday_leave_data = $class->fetch();
$birthday_leave_pk = (int)json_decode($birthday_leave_data['result'][0]['details'])->birthday_leave;

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

$employees_data = $class->fetch_birthday_celebrants();
$employees = $employees_data['result'];

$sql = 'begin;';
foreach ($employees as $key => $value) {
    $leave_balances = (array)json_decode($value['leave_balances']);

    $new_leave_balances=array();
    foreach ($leave_balances as $k => $v) {
        $new_leave_balances[$k] = $v;
    }

    if(!array_key_exists($birthday_leave_pk, $new_leave_balances)){
        $new_leave_balances[$birthday_leave_pk] = 0;
    }

    if($value['bday_month'] == $value['month_now']){
        $new_leave_balances[$birthday_leave_pk] = 1;    
    }
    else {
        $new_leave_balances[$birthday_leave_pk] = 0;
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