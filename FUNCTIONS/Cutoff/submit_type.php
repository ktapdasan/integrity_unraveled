<?php
require_once('../connect.php');
require_once('../../CLASSES/Cutoff.php');

$class = new Cutoff(
				$_POST['pk'],
                Null,
                Null
			);

$pk = $_POST['status'];
$a = json_decode($_POST['new_cutoff']);
//print_r($a->first->from);

$cutoff=array();

$b = $a->from;
$c = $a->to;
$d = $a->first->from;
$e = $a->first->to;
$f =$a->first->from;
$g = $a->first->to;

if($pk == 1){
	$cutoff['cutoff'][0]['from'] = $b;
	$cutoff['cutoff'][0]['to'] = $c;
}
else {
	$cutoff['cutoff'][0]['from'] = $d;
	$cutoff['cutoff'][0]['to'] = $e;
	$cutoff['cutoff'][1]['from'] = $f;
	$cutoff['cutoff'][1]['to'] = $g;	
}


$extra['cutoffdate'] = $cutoff;
$extra['pk'] = $pk;

//print_r($extra['cutoffdate']);

$data = $class-> submit_type($extra);


header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
       header("HTTP/1.0 200 OK");
 }                  

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 