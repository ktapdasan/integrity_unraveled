<?php
require_once('../../CLASSES/ClassParent.php');
class Attritions extends ClassParent 
{
    var $pk = NULL;
    var $employees_pk = NULL;
    var $hr_details = NULL;
    var $supervisor_details = NULL;
    var $created_by = NULL;
    var $date_created = NULL;
    var $archived = NULL;

    public function __construct(
                                    $pk,
                                    $employees_pk,
                                    $hr_details,
                                    $supervisor_details,
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


    public function fetch_all($data){
        foreach($data as $k=>$v){
            $data[$k] = pg_escape_string(trim(strip_tags($v)));
        }

        $where="";
        if(!empty($data['titles']) && $data['titles_pk'] != 'undefined'){
            $where .= " and employees.details->'company'->'titles_pk' = '" . $data['titles_pk'] . "'";
        }

        if(!empty($data['level_titles']) && $data['levels_pk'] != 'undefined'){
            $where .= " and employees.details->'company'->'levels_pk' = '" . $data['levels_pk'] . "'";
        }

        // search function
        $str=$data['searchstring'];
        $lvl=$data['levels_pk'];
        $posi=$data['titles_pk'];

        $where = "";

        if ($str){
            $where .= " AND (first_name ILIKE '$str%' OR middle_name ILIKE '$str%' 
                OR last_name ILIKE '$str%' OR employee_id ILIKE '$str%' )";
        }

        if($lvl){
            $where.=" AND levels_pk = '$lvl'";
        }
        
        if($posi){
            $where.=" AND titles_pk = '$posi'";
        }

        $status = $data['status'];
        if ($status){
            if ($status == 'Active'){
                $status = 'false';
            }
            else {
                $status = 'true';
            }
            $where .= " AND employees.archived = $status";
        }



        $supervisor_pk = $data['pk'];
        $sql = <<<EOT
                select
                    attritions.pk,
                    employees_pk,
                    employees.employee_id,
                    employees.details->'personal' as personal,
                    employees.details->'company' as company,
                    attritions.hr_details,
                    attritions.supervisor_details,
                    attritions.created_by
                from attritions
                left join employees on (attritions.employees_pk = employees.pk)
                where 
                    employees_pk in (select employees_pk from groupings where supervisor_pk = $supervisor_pk) 
                    $where
                order by attritions.pk desc

                ;
EOT;
    
        return ClassParent::get($sql);
       
    }

    public function update_SupervisorDetails($data, $extra){
        
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

         $hr_pk = $extra['hr_pk'];
         $apprv = $extra['apprv_pk'];
        $sup_details = json_encode($data);

           $sql = 'begin;';
          $sql .= <<<EOT
                UPDATE attritions set
                supervisor_details = '$sup_details'

                where pk = $this->pk;

EOT;
              // return ClassParent::update($sql);
  
         
             $sql .= <<<EOT
                insert into notifications(

                  notification,
                  table_from,
                  table_from_pk,
                  employees_pk,
                  created_by

                  )
                 values
                 (
                 'Attrition response',
                 'attrition',
                 $this->pk,
                 $hr_pk,
                 $apprv

                    );

EOT;
         $sql.="commit;";
              return ClassParent::insert($sql);
             }

}


?>