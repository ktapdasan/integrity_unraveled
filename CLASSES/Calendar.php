<?php
require_once('../../CLASSES/ClassParent.php');
class Calendar extends ClassParent {

    var $pk = NULL;
    var $location = NULL;
    var $description = NULL;
    var $time_from = NULL;
    var $time_to = NULL;
    var $color = NULL;
    var $created_by = NULL;
    var $date_created = NULL;
    var $archived = NULL;

    public function __construct(
                                    $pk,
                                    $location,    
                                    $description,    
                                    $time_from,    
                                    $time_to,    
                                    $color,    
                                    $created_by,    
                                    $date_created,    
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

    public function fetch_events($extra){
        foreach($extra as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $sql = <<<EOT
                select
                    pk, 
                    location,
                    description,
                    time_from::timestamp(0) as time_from,
                    time_to::timestamp(0) as time_to,
                    color,
                    created_by,
                    (select first_name||' '||last_name from employees where pk = created_by) as employee,
                    date_created::timestamp(0) as date_created,
                    archived
                from calendar
                where archived = false
                order by time_from desc
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function save_events($extra){
        foreach($extra as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $created_by=$extra['created_by'];
        $date_from=$extra['date_from'];
        $date_to=$extra['date_to'];
        $description=$extra['description'];
        $location=$extra['location'];
        $colors=$extra['colors'];
        $sql = <<<EOT
                INSERT INTO calendar
                (
                    created_by,
                    time_from,
                    time_to,
                    description,
                    location,
                    color
                )
                values
                (
                    $created_by,
                    '$date_from 00:00:00',
                    '$date_to 23:59:59',
                    '$description',
                    '$location',
                    '$colors'
                )
                ;
EOT;

        return ClassParent::insert($sql);
    }

     public function save_myevents($extra){
        foreach($extra as $k=>$v){
            $extra[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $created_by=$extra['created_by'];
        $date_from=$extra['date_from'];
        $date_to=$extra['date_to'];
        $time_from=$extra['time_from'];
        $time_to=$extra['time_to'];
        $description=$extra['description'];
        $location=$extra['location'];
        $colors=$extra['colors'];
        $rec=$extra['recipient'];

        // $dat=implode(',', $rec);
        $recipient="{".$rec."}";

        $sql = <<<EOT
                INSERT INTO calendar
                (
                    created_by,
                    time_from,
                    time_to,
                    description,
                    location,
                    color,
                    recipients
                )
                values
                (
                    '$created_by',
                    '$date_from $time_from',
                    '$date_to $time_to',
                    '$description',
                    '$location',
                    '$colors',
                    '$recipient'
                )
                ;
EOT;

        return ClassParent::insert($sql);
    }
}

?>