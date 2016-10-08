<?php
require_once('../../CLASSES/ClassParent.php');
class Request extends ClassParent {

	var $pk = NULL;
	var $type = NULL;
    var $recipient = NULL;
	var $archived = NULL;


	public function __construct(
                                    $pk,
    								$type,
                                    $recipient,
    								$archived

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

    public function get_request_type($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $str=$data['searchstring'];

        if ($str){
            $where = " AND (type ILIKE '$str%')";
        }
        
        $sql = <<<EOT
                with Q as
                (
                    select pk, type, unnest(recipient) as employees_pk from request_type
                    where archived = $this->archived
                    $where
                ),
                R as
                (
                    select
                        pk,
                        type,
                        employees_pk || '|' || (select (details->'personal'->>'first_name')::text ||' '|| (details->'personal'->>'last_name')::text from employees where employees.pk = Q.employees_pk) as recipient
                    from Q
                )
                select
                    pk,
                    type,
                    array_to_string(array_agg(recipient), ',') as recipients
                from R
                group by pk, type
                order by type
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function add_request_type($data){
        
    	$dat=implode(',', $data);
        $dat="{".$dat."}";


		 $sql = <<<EOT
                insert into request_type
                (    
                    type,
                    recipient
                )  
                values
                (
                    '$this->type',
                    '$dat'
                );
EOT;
        return ClassParent::insert($sql);
    }


    public function update_request_type($data){

        $dat=implode(',', $data);
        $dat="{".$dat."}";

        $sql = <<<EOT
                UPDATE request_type set
                (
                    type,
                    recipient
                )
                =
                (
                    '$this->type',
                    '$dat'
                )
                WHERE pk = $this->pk
                ;
EOT;

        return ClassParent::update($sql);
    }


    public function deactivate_request_type(){

        $sql = <<<EOT
                update request_type set 
                archived = true
                where pk = $this->pk;
EOT;

          return ClassParent::update($sql);
    }

    public function reactivate_request_type(){

        $sql = <<<EOT
                update request_type set 
                archived = false
                where pk = $this->pk;
EOT;

          return ClassParent::update($sql);
    }

    public function get_request($data){

        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $date_from = $data['datefrom'] ;
        $date_to = $data['dateto'];
        
        $sql = <<<EOT
                select
                pk,
                request_type_pk,
                created_by,
                date_created:: date as datecreated,
                (select type from request_type where pk = requests.request_type_pk order by date_created desc limit 1) as type,
                (select remarks from requests_status where requests_pk = requests.pk order by date_created desc limit 1) as reason,
                (select status from requests_status where requests_pk = requests.pk order by date_created desc limit 1) as status
                from requests
                where
                date_created::date between '$date_from' and '$date_to'
                and
                created_by = $this->pk 
                and
                archived = 'false'
                ;
EOT;

        return ClassParent::get($sql);
    }

    public function add_request($extra){
        
        $remarks = $extra['remarks'];
        $request_type_pk = $extra['request_type_pk'];

        $sql = 'begin;';

        $sql .= <<<EOT
                insert into requests
                (    
                    request_type_pk,
                    created_by

                )  
                values
                (
                    '$request_type_pk',
                    '$this->pk'
                );
EOT;

        $sql .= <<<EOT
                insert into requests_status
                (
                    requests_pk,
                    remarks,
                    created_by   
                )
                values
                (    
                    currval('requests_pk_seq'),
                    '$remarks',
                    '$this->pk'
                )
                ;
EOT;
        $sql .= "commit;";
        return ClassParent::insert($sql);
    }


     public function cancel_request($data){

        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }
        
        $sql = <<<EOT
                    update requests 
                    set archived = 'true'
                    where 
                    pk = '$this->pk'
                    ;
EOT;

        return ClassParent::insert($sql);
    }

        public function update_request($extra){
        
        $remarks = $extra['remarks'];
        $status = $extra['status'];
        $created_by = $extra['created_by'];
        $employees_pk = $extra['employees_pk'];


        $sql = 'begin;';

        $sql .= <<<EOT
                insert into requests_status
                (    
                    requests_pk,
                    status,
                    remarks,
                    created_by

                )  
                values
                (
                    '$this->pk',
                    '$status',
                    '$remarks',
                    $created_by
                );
EOT;
        $sql .= <<<EOT
               insert into notifications
                (   
                    notification,
                    table_from,
                    table_from_pk,
                    employees_pk,
                    created_by      
                )
                values
                (    
                    'Request',
                    'request_result',
                    '$this->pk',
                    $employees_pk,
                    $created_by
                )
                ;
EOT;

        
        $sql .= "commit;";
        return ClassParent::insert($sql);
    }

}
?>