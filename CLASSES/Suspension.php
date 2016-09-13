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

    public function fetch(){
        $sql = <<<EOT
                select 
                    pk,
                    time_from::timestamp(0) as time_from,
                    time_to::timestamp(0) as time_to,
                    created_by,
                    remarks,
                    archived
                from suspension
                where archived = false
                    and (
                            time_from between '$this->time_from' and '$this->time_to' or 
                            time_to between '$this->time_from' and '$this->time_to'
                        )
                order by time_from
                ;
EOT;

        return ClassParent::get($sql);
    }

    
}
?>