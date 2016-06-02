<?php
require_once('../../CLASSES/ClassParent.php');
class Levels extends ClassParent {

    var $pk = NULL;
    var $level_title = NULL;

    public function __construct(
                                    $pk='',
                                    $level_title=''
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
        $level_title = pg_escape_string(strip_tags(trim($post['get_levels'])));

        $sql = <<<EOT
                select
                    pk, 
                    level_title
                from levels
                order by pk
                ;
EOT;

        return ClassParent::get($sql);
    }
}

?>