<?php
require_once('../../CLASSES/ClassParent.php');
class Cutoff extends ClassParent {

    var $pk = NULL;
    var $type = NULL;
    var $archived = NULL;

    public function __construct(
                                $pk='',
                                $type='',
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

    public function fetch_types(){
       

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
                    cutoff_types_pk, 
                    dates
                from cutoff_dates
                ;
EOT;
        return ClassParent::get($sql);

    }


    public function submit_type($extra){
        foreach($extra as $k=>$v){
            if(is_array($v)){
               $extra[$k] = $v;
            }
            else{
                $extra[$k] = pg_escape_string(trim(strip_tags($v)));
            }
        }
        
        $dates = json_decode($extra['cutoffdate']);
        $sql = 'begin;';
        
        $sql .=<<<EOT
                delete from cutoff_dates
                ;
EOT;
        $pk = $extra['pk'];
        $array = $extra['cutoffdate'];
        
        $dates=json_encode($array);
        

        $sql .=<<<EOT
                insert into cutoff_dates
                (
                    cutoff_types_pk,
                    dates
                )
                values
                (
                    $pk,
                    '$dates'
                );
EOT;
        $sql .= "commit;";

        return ClassParent::insert($sql);
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