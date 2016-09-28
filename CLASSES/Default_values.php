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

    public function fetch_all(){
        $sql = <<<EOT
                select 
                    pk,
                    name,
                    details
                from default_values
                where archived = false
                ;
EOT;

        return ClassParent::get($sql);
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

    public function cutoff_types(){
       

        $sql = <<<EOT
                select
                    pk, 
                    type
                from cutoff_types
                where archived = false
                order by pk
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function fetch_dates(){

        $sql = <<<EOT
                select
                    details
                from default_values
                where name = 'cutoff_dates'
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
                where name = 'work_days'
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

    public function get_leave_status(){
        
        $sql = <<<EOT
                select 
                    name,
                    details
                from default_values
                where name = 'birthday_leave'
                ;
EOT;
        
        return ClassParent::get($sql);
    }

    public function get_default_values(){
        
        $sql = <<<EOT
                select 
                    name,
                    details
                from default_values
                where name = '$this->name'
                and pk = '1'
                ;
EOT;
        
        return ClassParent::get($sql);
    }

    public function get_birthday_leave(){
        
        $sql = <<<EOT
                select 
                    name,
                    details
                from default_values
                where name = 'birthday_leave'
                ;
EOT;
        
        return ClassParent::get($sql);
    }

    public function get_leave_types(){
        
        $sql = <<<EOT
                select
                    pk, 
                    name
                from leave_types
                where archived = false
                order by pk
                ;
EOT;
        
        return ClassParent::get($sql);
    }

    public function get_cutoff_types(){
        
        $sql = <<<EOT
                select
                    name, 
                    details
                from default_values
                where name='cutoff_dates'
                ;
EOT;
        
        return ClassParent::get($sql);
    }

    public function get_leaves_filed(){
        
        $sql = <<<EOT
                select
                    name,
                    details
                from default_values
                where name='leave'
                ;
EOT;
        
        return ClassParent::get($sql);
    }

    public function get_work_hours(){
        
        $sql = <<<EOT
                select 
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

    public function save_color($info){
        $info = pg_escape_string(strip_tags(trim($info)));

        $color = $info['color'];

        echo $sql = <<<EOT

                insert into calendar
                (   
                    location,
                    description,
                    description,
                    color
                )
                values
                (
                    '$color'
                );
EOT;
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
         $sql .= <<<EOT
                update default_values
                set details = '$data' 
                where name = 'work_days'
                ;
EOT;
        return ClassParent::update($sql);
    }

    public function update_work_hrs($data){

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

        $new_hrs ['hrs'] = $data ['hrs'];

        $data = json_encode($new_hrs);
        $sql = <<<EOT
                update default_values
                set details = '$data' 
                where name = 'working_hours'
                ;
EOT;
        return ClassParent::update($sql);
    }

    public function update_default_values($data){

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
        $new_data ['regularization'] = $data ['regularization'];
        $new_data ['staggered'] = $data ['staggered'];
        $new_data ['carry_over'] = $data ['carry_over'];
        $new_data ['leaves_per_month'] = $data ['leaves_per_month'];
        $new_data ['leaves_regularization'] = $data ['leaves_regularization'];
        $new_data ['max_increase'] = $data ['max_increase'];

        $data = json_encode($new_data);
        $sql = <<<EOT
                update default_values
                set details = '$data' 
                where name = 'leave'
                ;
EOT;
        return ClassParent::update($sql);
    }

    public function update_birthday_leave($data){

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
        $new_data ['count'] = $data ['count'];
        $new_data ['status'] = $data ['status'];
        $new_data ['leave_types_pk'] = $data ['pk'];

        $data = json_encode($new_data);
        $sql = <<<EOT
                update default_values
                set details = '$data' 
                where name = 'birthday_leave'
                ;
EOT;
        return ClassParent::update($sql);
    }

    public function update_work_cutoff($extra){
        foreach($extra as $k=>$v){
            if(is_array($v)){
               $extra[$k] = $v;
            }
            else{
                $extra[$k] = pg_escape_string(trim(strip_tags($v)));
            }
        }
        if($cutoff_types_pk == 1 ){
                $cutoff_types_pk = 1;    
        }
        else{
            $cutoff_types_pk = 2;
        }      
        $array['dates'] = $extra['dates'];
        $array['cutoff_types_pk'] = $extra['cutoff_types_pk'];
        
        $dates=json_encode($array);
        

        $sql .=<<<EOT
                 update default_values set
                details
                =
                '$dates'
                where name = 'cutoff_dates'
                ;
EOT;
        return ClassParent::insert($sql);
    }

}

?>