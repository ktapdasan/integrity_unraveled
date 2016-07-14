<?php
require_once('../../CLASSES/ClassParent.php');
class Groupings extends ClassParent {

    var $employees_pk = NULL;
    var $supervisor_pk = NULL;

    public function __construct(
                                    $employees_pk,
                                    $supervisor_pk
                                ) 
    {
        
        $fields = get_defined_vars();
        
    }


    public function fetch(){
        //This is a comment
        $sql = <<<EOT
                UPDATE groupings set
                (
                    supervisor_pk
                )
                =
                (   '$this->supervisor_pk')
                ;

EOT;

        return ClassParent::update($sql);
    }

}
?>