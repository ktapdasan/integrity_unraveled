<?php
require_once('../../CLASSES/ClassParent.php');
class Request extends ClassParent {

	var $pk = NULL;
	var $type = NULL;
    var $recipient = NULL;
	var $archived = NULL;


	public function __construct(
                                    $pk,
    								$type,
                                    $recipient,
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

    public function get_request_type($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $str=$data['searchstring'];

        if ($str){
            $where = " AND (type ILIKE '$str%')";
        }
        
        $sql = <<<EOT
                 select 
                 pk,
                 type,
                 recipient,
                 archived,
                 (
                    select array_to_string(array_agg(details->'personal'->>'first_name'), ',') 
                    from employees where employees.pk = any( request_type.recipient)
                 ) as recipients
                from request_type
                where archived = $this->archived
                $where
                order by pk
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function add_request_type($data){
        
    	$dat=implode(',', $data);
        $dat="{".$dat."}";


		 $sql = <<<EOT
                insert into request_type
                (    
                    type,
                    recipient
                )  
                values
                (
                    '$this->type',
                    '$dat'
                );
EOT;
        return ClassParent::insert($sql);
    }


    public function update_request_type($data){

        $dat=implode(',', $data);
        $dat="{".$dat."}";

        $sql = <<<EOT
                UPDATE request_type set
                (
                    type,
                    recipient
                )
                =
                (
                    '$this->type',
                    '$dat'
                )
                WHERE pk = $this->pk
                ;
EOT;

        return ClassParent::update($sql);
    }


    public function deactivate_request_type(){

        $sql = <<<EOT
                update request_type set 
                archived = true
                where pk = $this->pk;
EOT;

          return ClassParent::update($sql);
    }

    public function reactivate_request_type(){

        $sql = <<<EOT
                update request_type set 
                archived = false
                where pk = $this->pk;
EOT;

          return ClassParent::update($sql);
    }
}
?>