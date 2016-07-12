<?php
require_once('../../CLASSES/ClassParent.php');
class Leave extends ClassParent {

    var $pk = NULL;
    var $employees_pk = NULL;
    var $leave_types_pk= NULL;
    var $date_started = NULL;
    var $date_ended= NULL;
    var $date_created = NULL;
    var $reason = NULL;
    var $archived = NULL;

    public function __construct(
                                $pk='',
                                $employees_pk = '',
                                $leave_types_pk= '',
                                $date_started = '',
                                $date_ended= '',
                                $date_created = '',
                                $reason = '',
                                $archived = ''
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