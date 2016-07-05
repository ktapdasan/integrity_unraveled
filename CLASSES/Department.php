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
                    department,
                    code
                from departments
                where archived = $this->archived
                order by pk
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function deactivate(){

        $sql = <<<EOT
                update departments set 
                archived = true
                where pk = $this->pk;
EOT;

          return ClassParent::update($sql);
    }


    public function update_department(){
        $department = $this->department;
        $code = $this->code;


        $sql = <<<EOT
                UPDATE departments set
                (
                    department,
                    code
                )
                =
                (
                    '$department',
                    '$code'
                )
                WHERE pk = $this->pk
                ;
EOT;

        return ClassParent::update($sql);
    }

    public function add_department(){
        $department = $this->department;
        $code = $this->code;
        
        $sql = <<<EOT
                insert into departments
                (
                    department,
                    code
                )
                values
                (
                    '$department',
                    '$code'
                )
                ;
EOT;
        

        return ClassParent::insert($sql);
    }
}

?>