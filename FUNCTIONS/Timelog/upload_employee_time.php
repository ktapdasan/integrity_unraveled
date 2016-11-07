<?php
require_once('../connect.php');

if ( !empty( $_FILES ) ) {

    $tempPath = $_FILES[ 'file' ][ 'tmp_name' ];
    $csvFile = file($tempPath);
    $sql = "begin;";
    $count=0;
    foreach ($csvFile as $line) {
        if($count>0){
            $data = str_getcsv($line);

            $employee_id    = $data[0];
            $time_in        = $data[1]." ".$data[2];
            $time_out       = $data[3]." ".$data[4];

            $random_hash = randomPrefix(50);

            /*
            delete from time_log
                    where type = 'In' 
                        and employees_pk in (select pk from employees where employee_id = '$employee_id')
                        and time_log::date = '$time_in'::date
                    ;

                    delete from time_log
                    where type = 'Out' 
                        and employees_pk in (select pk from employees where employee_id = '$employee_id')
                        and time_log::date = '$time_in'::date
                    ;
            */

            if($data[1]){
                $sql .= <<<EOT
                    insert into time_log
                    (
                        employees_pk,
                        type,
                        time_log,
                        random_hash
                    )
                    values
                    (
                        (select pk from employees where employee_id = '$employee_id'),
                        'In',
                        '$time_in'::timestamptz,
                        '$random_hash'
                    );
EOT;
            }
            

            if($data[3]){
                $sql .= <<<EOT
                        insert into time_log
                        (
                            employees_pk,
                            type,
                            time_log,
                            random_hash
                        )
                        values
                        (
                            (select pk from employees where employee_id = '$employee_id'),
                            'Out',
                            '$time_out'::timestamptz,
                            '$random_hash'
                        );
EOT;
            }
        }

        $count++;
    }

    $sql .= "commit;";

    $query = pg_query($sql);
    if($query){
        header("HTTP/1.0 200 OK");
        $return = array( 'status' => true );
    }
    else {
        header("HTTP/1.0 404 User Internal Server Error");
        $return = array( 'status' => false );
    }
    pg_free_result($query);
    
    header('Content-Type: application/json');
    print(json_encode($return));
    

    exit();

	$filename = date('Ymd_His');
    $tempPath = $_FILES[ 'file' ][ 'tmp_name' ];
    $newFileName = date('YmdHi').randomPrefix(20).".".end(explode(".", $_FILES['file']['name']));
    $additionaldir = date('Ymd');
	// $uploadPath = dirname( __FILE__ ) . DIRECTORY_SEPARATOR . '../../ASSETS/uploads' . DIRECTORY_SEPARATOR . $_FILES[ 'file' ][ 'name' ];
	$dir = dirname( __FILE__ ) . DIRECTORY_SEPARATOR . '../../ASSETS/uploads/' . $additionaldir;
	if (!is_dir('../../ASSETS/uploads/' . $additionaldir)) {
    	mkdir('../../ASSETS/uploads/' . $additionaldir, 0777);
	}
    $uploadPath = $dir . DIRECTORY_SEPARATOR . $newFileName;

    $a = move_uploaded_file( $tempPath, $uploadPath );
    
    if($a){
    	$answer = array( 'answer' => 'File transfer completed', 'file' => 'ASSETS/uploads/' . $additionaldir . DIRECTORY_SEPARATOR . $newFileName );
    }
    else {
    	$answer = array( 'answer' => 'File transfer incompleted' );
    }
    
    echo $json = json_encode( $answer );

} else {

    echo 'No files';

}

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