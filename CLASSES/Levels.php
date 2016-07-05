<?php
require_once('../../CLASSES/ClassParent.php');
class Levels extends ClassParent {

    var $pk = NULL;
    var $level_title = NULL;

    public function __construct(
                                    $pk='',
                                    $level_title='',
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
        /*$level_title = pg_escape_string(strip_tags(trim($post['get_levels'])));*/

        $sql = <<<EOT
                select
                    pk, 
                    level_title
                from levels
                where archived = $this->archived
                order by pk
                ;
EOT;

        return ClassParent::get($sql);
    }

     public function deactivate(){

        $sql = <<<EOT
                update levels
                set archived = True
                where pk = $this->pk;
EOT;

          return ClassParent::update($sql);
    }


    public function update(){
        $level_title = $this->level_title;
        


        $sql = <<<EOT
                UPDATE levels set
                    level_title
                =
                    '$level_title'
                WHERE pk = $this->pk
                ;
EOT;

        return ClassParent::update($sql);
    }

   public function add_level(){
       $level_title = $this->level_title;
        
        $sql = <<<EOT
                insert into levels
                (
                    level_title
                )
                values
                (
                    '$level_title'   
                )
                ;
EOT;
        

        return ClassParent::insert($sql);
    }
}

?>