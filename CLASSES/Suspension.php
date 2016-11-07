<?php
require_once('../../CLASSES/ClassParent.php');
class Suspension extends ClassParent {

	var $pk            = NULL;
    var $time_from     = NULL;
	var $time_to       = NULL;
    var $remarks       = NULL;
    var $created_by    = NULL;
	var $archived      = NULL;


	public function __construct(
                                    $pk,
    								$time_from,
                                    $time_to,
                                    $remarks,
    								$created_by,
    								$archived
                                ){
        
        $fields = get_defined_vars();
        
        if(empty($fields)){
            return(FALSE);
        }

        //sanitize
        foreach($fields as $k=>$v){
            $this->$k = pg_escape_string(trim(strip_tags($v)));
        }

        return(true);
    }

    public function fetch($extra,$data){

        $status = $extra['status'];

        $str=$data['searchstring'];

        if ($str){
            $where = " AND (remarks ILIKE '$str%')";
        }

        if($extra['status'] == "Active"){
            $status = 'false';
        }
        else {
            $status = 'true';   
        }

        $sql = <<<EOT
                select 
                    pk,
                    time_from::timestamp(0) as time_from,
                    to_char(time_from, 'DD-Mon-YYYY<br/>HH12:MI:SS AM') as datefrom_html,
                    time_to::timestamp(0) as time_to,
                    to_char(time_to, 'DD-Mon-YYYY<br/>HH12:MI:SS AM') as dateto_html,
                    created_by,
                    remarks,
                    archived
                from suspension
                where archived = $status
                $where
                order by pk
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function fetch_all(){

        $status = $this->archived;
        $date1 = $this->time_from;
        $date2 = $this->time_to;
        $where = "and time_from between '$date1' and '$date2' and time_to between '$date1' and '$date2'";

        $sql = <<<EOT
                select 
                    pk,
                    time_from::timestamp(0) as time_from,
                    time_to::timestamp(0) as time_to,
                    created_by,
                    remarks,
                    archived
                from suspension
                where archived = $status
                $where
                order by pk
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function save_suspension($extra){
        foreach($extra as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $creator_pk=$extra['creator_pk'];
        $time_from=$extra['time_from'];
        $time_to=$extra['time_to'];
        $date_from = $extra['date_from'] . " " . $time_from;
        $date_to = $extra['date_to'] . " " . $time_to;
        $remarks=$extra['remarks'];
        $sql = <<<EOT
                INSERT INTO suspension
                (
                    created_by,
                    time_from,
                    time_to,
                    remarks
                )
                values
                (
                    $creator_pk,
                    '$date_from',
                    '$date_to',
                    '$remarks'
                )
                ;
EOT;
        return ClassParent::insert($sql);
    }

    public function edit_suspension($extra){

        $pk=$extra['pk'];
        $creator_pk=$extra['creator_pk'];
        $time_from=$extra['time_from'];
        $time_to=$extra['time_to'];
        $date_from = $extra['date_from'] . " " . $time_from;
        $date_to = $extra['date_to'] . " " . $time_to;
        $remarks=$extra['remarks'];

        $sql = <<<EOT
                UPDATE suspension set
                (
                    time_from,
                    time_to,
                    remarks,
                    created_by
                )
                =
                (
                    '$date_from',
                    '$date_to',
                    '$remarks',
                    '$creator_pk'
                )
                WHERE pk = $pk
                ;
EOT;

        return ClassParent::update($sql);
    }

    public function delete_suspension($extra){

        $pk=$extra['pk'];

        $sql = <<<EOT
                UPDATE suspension set
                (
                    archived
                )
                =
                (
                    't'
                )
                WHERE pk = $pk
                ;
EOT;

        return ClassParent::update($sql);
    }

    public function restore_suspension($extra){

        $pk=$extra['pk'];

        $sql = <<<EOT
                UPDATE suspension set
                (
                    archived
                )
                =
                (
                    'f'
                )
                WHERE pk = $pk
                ;
EOT;

        return ClassParent::update($sql);
    }

    
}
?>