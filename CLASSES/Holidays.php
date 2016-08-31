<?php
require_once('../../CLASSES/ClassParent.php');
class Holidays extends ClassParent {

	var $pk = NULL;
	var $name = NULL;
	var $datex = NULL;
	var $archived = NULL;

	public function __construct(
                                $pk='',
								$name='',
								$datex='',
								$archived=''
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

    public function save_holidays($data){
    	
    	$name= $data['holiday_name'];
    	$date= $data['new_date'];
    	$approver = $data['creator_pk'];

		$sql = <<<EOT
                insert into holidays
                (    
                   	name,
                   	datex,
                   	created_by
                )  
                values
                (
                    '$name',
                    '$date',
                    $approver
                );
EOT;

        return ClassParent::insert($sql);
    }

    }
?>