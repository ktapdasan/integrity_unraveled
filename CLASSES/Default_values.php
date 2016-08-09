<?php
require_once('../../CLASSES/ClassParent.php');
class Default_values extends ClassParent {

    var $pk         = NULL;
    var $name       = NULL;
    var $details    = NULL;

    public function __construct(
                                    $pk,
                                    $name,
                                    $details
                                ){
        
        $fields = get_defined_vars();
        
        if(empty($fields)){
            return(FALSE);
        }

        //sanitize
        foreach($fields as $k=>$v){
            if(is_array($v)){
                foreach($v as $key=>$value){
                    $v[$key] = pg_escape_string(trim(strip_tags($value)));
                }
                $this->$k = $v;
            }
            else {
                $this->$k = pg_escape_string(trim(strip_tags($v)));    
            }
        }

        return(true);
    }

    public function fetch(){
        $sql = <<<EOT
                select 
                    pk,
                    name,
                    details
                from default_values
                where name = '$this->name'
                ;
EOT;

        return ClassParent::get($sql);
    }

     public function update($created_by){
        $created_by = pg_escape_string(strip_tags(trim($created_by)));

        $details = json_encode($this->details);
        $sql = "begin;";
        $sql .= <<<EOT
                update default_values set
                (details)
                =
                ('$details')
                where pk = $this->pk
                ;
EOT;
        
        $sql .= <<<EOT
                insert into default_values_logs
                (
                    default_values_pk,
                    log,
                    created_by
                )
                values
                (
                    $this->pk,
                    'Updated Leave default values',
                    $created_by
                );
EOT;

        $sql .= "commit;";

        return ClassParent::update($sql);
    }
}

?>