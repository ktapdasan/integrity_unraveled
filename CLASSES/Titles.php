<?php
require_once('../../CLASSES/ClassParent.php');
class Titles extends ClassParent {

    var $pk = NULL;
    var $title = NULL;
    var $created_by = NULL;
    var $date_created = NULL;

    public function __construct(
                                    $pk='',
                                    $title='',
                                    $created_by='',
                                    $date_created=''
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
        $title = pg_escape_string(strip_tags(trim($post['get_positions'])));

        $sql = <<<EOT
                select
                    pk, 
                    title
                from titles
                order by pk
                ;
EOT;

        return ClassParent::get($sql);
    }
}

?>