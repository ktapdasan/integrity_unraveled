<?php
header("HTTP/1.0 200 OK");
header('Content-Type: application/json');

$date = array(
				"date" => date('Y-m-d'),
				"time" => date('H:i:s'),
				"day" => date('l'),
				"num_day" => date('w'),
				"month" => date('F'),
				"num_month" => date('n')
			);

print(json_encode($date));
?>