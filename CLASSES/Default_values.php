<?php
require_once('../../CLASSES/ClassParent.php');
class Default_values extends ClassParent {

    var $pk         = NULL;
    var $name       = NULL;
    var $details    = NULL;
    var $archived    = NULL;

    public function __construct(
                                    $pk,
                                    $name,
                                    $details,
                                    $archived
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

    public function fetch_default_values(){
        $sql = <<<EOT
                select 
                    pk,
                    name,
                    details
                from default_values
                where pk = '2'
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function get_work_days(){
        $sql = <<<EOT
                select 
                    name,
                    details
                from default_values
                where name = 'work_days'
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

    public function update_work_days($data){

        foreach($data as $k=>$v){
            if(is_array($v)){
                foreach($v as $key=>$val){
                    $data[$k][$key] = pg_escape_string(trim(strip_tags($val)));
                }
            }
            else {
                $data[$k] = pg_escape_string(trim(strip_tags($v)));    
            }
        }  

        $new_data ['sunday'] = $data ['sunday'];
        $new_data ['monday'] = $data ['monday'];
        $new_data ['tuesday'] = $data ['tuesday'];
        $new_data ['wednesday'] = $data ['wednesday'];
        $new_data ['thursday'] = $data ['thursday'];
        $new_data ['friday'] = $data ['friday'];
        $new_data ['saturday'] = $data ['saturday'];

        $data = json_encode($new_data);
         $sql = <<<EOT
                update default_values
                set details = '$data' 
                where name = 'work_days'
                ;
EOT;

        return ClassParent::update($sql);
    }

}

?>