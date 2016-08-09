<?php
require_once('../../CLASSES/ClassParent.php');
class LeaveTypes extends ClassParent {

    var $pk = NULL;
    var $name = NULL;
    var $code = NULL;
    var $days= NULL;
    var $details = NULL;
    var $archived = NULL;

    public function __construct(
                                    $pk,
                                    $name,
                                    $code,
                                    $days,
                                    $details,
                                    $archived
                                )
        {
        
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

    public function fetch($employees_pk){
        $employees_pk = pg_escape_string(strip_tags(trim($employees_pk)));

        $sql = <<<EOT
                select
                    pk, 
                    name,
                    code,
                    days,
                    details,
                    (
                        select 
                            count(*) 
                        from leave_filed 
                        where leave_filed.leave_types_pk = leave_types.pk 
                            and leave_filed.employees_pk = $employees_pk
                            and 'Approved' in (select status from leave_status where leave_filed_pk = leave_filed.pk order by date_created desc limit 1)
                    ) as count
                from leave_types
                where archived = '$this->archived'
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

        $details = json_encode($this->details);

        $sql = <<<EOT
                update leave_types set
                (   
                    name,
                    code,
                    days,
                    details
                )
                =
                (   
                    '$name',
                    '$code',
                    $days,
                    '$details'
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

        $details = json_encode($this->details);

        $sql = <<<EOT
                insert into leave_types
                (   
                    name,
                    code,
                    days,
                    details
                )
                values
                (
                    '$name',
                    '$code',
                    $days,
                    '$details'
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