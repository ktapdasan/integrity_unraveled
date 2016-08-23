<?php
require_once('../../CLASSES/ClassParent.php');
class Titles extends ClassParent {

    var $pk = NULL;
    var $title = NULL;
    var $created_by = NULL;
    var $date_created = NULL;
    var $archived = NULL;

    public function __construct(
                                    $pk='',
                                    $title='',
                                    $created_by='',
                                    $date_created='',
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

    public function fetch($data){
       /* $title = pg_escape_string(strip_tags(trim($post['get_positions'])));
*/
       foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }
        $str=$data['searchstring'];

        if ($str){
            $where = " AND (title ILIKE '$str%')";
        }

        $sql = <<<EOT
                select
                    pk, 
                    title
                from titles
                where archived = $this->archived
                $where
                order by pk
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function get_titles(){
       /* $title = pg_escape_string(strip_tags(trim($post['get_positions'])));
*/
        $sql = <<<EOT
                select
                    pk, 
                    title
                from titles
                where archived = false
                order by pk
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function deactivate(){

        $sql = <<<EOT
                update titles
                set archived = True
                where pk = $this->pk;
EOT;

          return ClassParent::update($sql);
    }

    public function reactivate(){

        $sql = <<<EOT
                update titles
                set archived = false
                where pk = $this->pk;
EOT;

          return ClassParent::update($sql);
    }


    public function update(){
        $title = $this->title;

        $sql = <<<EOT
                UPDATE titles set
                (
                    title
                )
                =
                (
                    '$title'
                )
                WHERE pk = $this->pk
                ;
EOT;

        return ClassParent::update($sql);
    }

    public function add_position(){
        $title = $this->title;

        $sql = <<<EOT
                Insert into titles
                (    
                    title
                )  
                values
                (
                    '$title'
                );
EOT;

        return ClassParent::insert($sql);
    }
}
?>