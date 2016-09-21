<?php

$tempPath = $_FILES[ 'file' ][ 'tmp_name' ];
$newFileName = randomPrefix(50).".".end(explode(".", $_FILES['file']['name']));
$additionaldir = date('Ymd');
// $uploadPath = dirname( __FILE__ ) . DIRECTORY_SEPARATOR . '../../ASSETS/uploads' . DIRECTORY_SEPARATOR . $_FILES[ 'file' ][ 'name' ];
$dir = dirname( __FILE__ ) . DIRECTORY_SEPARATOR . '../../ASSETS/uploads/birthday/' . $additionaldir;
if (!is_dir('../../ASSETS/uploads/birthday/' . $additionaldir)) {
	mkdir('../../ASSETS/uploads/birthday/' . $additionaldir, 0777);
}
$uploadPath = $dir . DIRECTORY_SEPARATOR . $newFileName;

$a = move_uploaded_file( $tempPath, $uploadPath );

if($a){
	$answer = array( 'answer' => 'File transfer completed', 'file' => 'ASSETS/uploads/birthday/' . $additionaldir . DIRECTORY_SEPARATOR . $newFileName );
}
else {
	$answer = array( 'answer' => 'File transfer incompleted' );
}

echo $json = json_encode( $answer );

function randomPrefix($length){
	$random= "";
	srand((double)microtime()*1000000);

	$data = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

	for($i = 0; $i < $length; $i++){
		$random .= substr($data, (rand()%(strlen($data))), 1);
	}

	return $random;
}


?>
