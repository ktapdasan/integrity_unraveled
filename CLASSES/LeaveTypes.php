<?php
require_once('../../CLASSES/ClassParent.php');
class LeaveTypes extends ClassParent {

    var $pk = NULL;
    var $name = NULL;
    var $code = NULL;
    var $days= NULL;
    var $archived = NULL;

    public function __construct(
                                    $pk,
                                    $name,
                                    $code,
                                    $days,
                                    $archived
                                )
        {
        
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
       

        $sql = <<<EOT
                select
                    pk, 
                    name,
                    code,
                    days
                from leave_types
                where archived = false
                order by pk
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function edit(){
        $name = $this->name;
        $days = $this->days;
        $code = $this->code;
        $pk = $this->pk;

         $sql = <<<EOT
                update leave_types set
                (   
                    name,
                    code,
                    days
                )
                =
                (   
                    '$name',
                    '$code',
                    $days
                )
                where pk = $pk
                ;
EOT;

        return ClassParent::insert($sql);

    }

     public function deactivate(){

        $sql = <<<EOT
                update leave_types 
                set archived = true
                where pk = $this->pk;
EOT;

          return ClassParent::update($sql);
    }


    public function add(){
        $name = $this->name;
        $days = $this->days;
        $code = $this->code;

        $sql = <<<EOT
                insert into leave_types
                (   
                    name,
                    code,
                    days
                )
                values
                (
                    '$name',
                    '$code',
                    $days
                )
                ;
EOT;

        return ClassParent::update($sql);
    }

   public function add_leave(){
      
        $employees_pk = $this->employees_pk;
        $leave_types_pk= $this->leave_types_pk;
        $date_started = $this->date_started;
        $date_ended= $this->date_ended;
        $reason = $this->reason;
        $archived = $this->archived;
        
        $sql = <<<EOT
                insert into leave_filed
                (
                    employees_pk,
                    leave_types_pk,
                    date_started,
                    date_ended,
                    reason,
                    archived
                )
                values
                (
                    '$employees_pk',
                    '$leave_types_pk',
                    '$date_started',
                    '$date_ended',
                    '$reason',
                    '$archived'
                )
                where pk = $this->pk
                ;
EOT;
        

        return ClassParent::insert($sql);
    }
}

?>