<?php 
require_once('../../CLASSES/ClassParent.php');
class Notifications extends ClassParent {
	
    var $pk = NULL;
	var $notification = NULL;
	var $table_from = NULL;
	var $table_from_pk = NULL;
	var $read = NULL;
	var $archived= NULL;

	 public function __construct(
                                    $pk='',
                                    $notification='',
                                    $table_from = '',
									$table_from_pk = '',
									$read= '',
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

	public function fetch(){

        $sql = <<<EOT
                select
                    pk, 
                    notification,
                    read
                    from notifications
                    order by pk
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function read(){  
        $read = $this->read;
        $sql = <<<EOT
                UPDATE  notifications
                set read = true
                where pk = $this->pk;
EOT;

          return ClassParent::update($sql);
    }

}
?>