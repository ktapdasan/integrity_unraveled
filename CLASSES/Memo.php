<?php
require_once('../../CLASSES/ClassParent.php');
class Memo extends ClassParent {

	var $pk = NULL;
	var $memo = NULL;
    var $created_by = NULL;
    var $date_created = NULL;
	var $read = NULL;
	var $archived = NULL;


	public function __construct(
                                    $pk,
    								$memo,
                                    $created_by,
                                    $date_created,
    								$read,
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

    public function get_memos($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $str=$data['searchstring'];

        if ($str){
            $where = " AND (memo ILIKE '$str%')";
        }
        
        $sql = <<<EOT
                select 
                    pk,
                    memo,
                    (select last_name ||', '|| first_name ||' '|| middle_name from employees where pk = created_by) as created_by,
                    date_created ::date as date_created,
                    archived
                from memo
                where archived = $this->archived
                $where
                order by pk
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function add_memos(){
    	
		$sql = <<<EOT
                insert into memo
                (    
                    memo,
                    created_by
                )  
                values
                (
                    '$this->memo',
                    '$this->created_by'
                );
EOT;
        return ClassParent::insert($sql);
    }


    public function update_memo(){


        $sql = <<<EOT
                UPDATE memo set
                (
                    memo
                )
                =
                (
                    '$this->memo'
                )
                WHERE pk = $this->pk
                ;
EOT;

        return ClassParent::update($sql);
    }


    public function deactivate(){

        $sql = <<<EOT
                update memo set 
                archived = true
                where pk = $this->pk;
EOT;

          return ClassParent::update($sql);
    }

    public function reactivate(){

        $sql = <<<EOT
                update memo set 
                archived = false
                where pk = $this->pk;
EOT;

          return ClassParent::update($sql);
    }
}
?>