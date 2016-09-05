<?php
require_once('../../CLASSES/ClassParent.php');
class Holidays extends ClassParent {

	var $pk = NULL;
	var $name = NULL;
    var $type = NULL;
	var $datex = NULL;
	var $archived = NULL;


	public function __construct(
                                $pk='',
								$name='',
                                $type='',
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

    public function get_holidays($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $str=$data['searchstring'];

        if ($str){
            $where = " AND (name ILIKE '$str%')";
        }
        
        $sql = <<<EOT
                select 
                    pk,
                    name,
                    type,
                    datex ::date as datex,
                    archived
                from holidays
                where archived = $this->archived
                $where
                order by pk
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function save_holidays($data){
    	
    	$name= $data['holiday_name'];
        $type = $data['holiday_type'];
    	$date= $data['new_date'];
    	$approver = $data['creator_pk'];

		$sql = <<<EOT
                insert into holidays
                (    
                   	name,
                    type,
                   	datex,
                   	created_by
                )  
                values
                (
                    '$name',
                    '$type',
                    '$date',
                    $approver
                );
EOT;

        return ClassParent::insert($sql);
    }


    public function update_holidays(){


        $sql = <<<EOT
                UPDATE holidays set
                (
                    name,
                    type,
                    datex
                )
                =
                (
                    '$this->name',
                    '$this->type',
                    '$this->datex'
                )
                WHERE pk = $this->pk
                ;
EOT;

        return ClassParent::update($sql);
    }


    public function deactivate(){

        $sql = <<<EOT
                update holidays set 
                archived = true
                where pk = $this->pk;
EOT;

          return ClassParent::update($sql);
    }

    public function reactivate(){

        $sql = <<<EOT
                update holidays set 
                archived = false
                where pk = $this->pk;
EOT;

          return ClassParent::update($sql);
    }
}
?>