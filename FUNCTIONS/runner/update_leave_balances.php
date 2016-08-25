<?php
require_once('../connect.php');

$sql = <<<EOT
            select
            	pk,
                name,
                code,
                days
            from leave_types
            where archived = false
            ;
EOT;

$query = pg_query($sql);

if(pg_numrows($query)){
	$balances=array();
	while($data = pg_fetch_assoc($query)){
		$balances[$data['pk']] = $data['days'];
	}
}

$balances = json_encode($balances);

$update = <<<EOT
			update employees set leave_balances = '$balances';
EOT;

$update_query = pg_query($update);

print_r($update_query);
?>