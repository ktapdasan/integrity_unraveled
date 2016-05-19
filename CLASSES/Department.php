<?php
require_once('../../CLASSES/ClassParent.php');
class Department extends ClassParent {

    var $pk = NULL;
    var $department = NULL;
    var $code = NULL;
    var $archived = NULL;

    public function __construct(
                                    $pk='',
                                    $department='',
                                    $code='',
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
        $department = pg_escape_string(strip_tags(trim($post['get_department'])));

        $sql = <<<EOT
                select 
                    pk,
                    department
                from departments
                order by department
                ;
EOT;

        return ClassParent::get($sql);
    }
}

?>