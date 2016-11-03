app.controller('Profile', function(
  										$scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        LeaveFactory,
                                        md5
  									){


    $scope.profile = {};  
    $scope.titles = {};
    $scope.department = {};
    $scope.level_title = {};
    $scope.leave_types ={};
    $scope.leave_balances = {};
    $scope.employees = {
        education:[{educ_level: "Primary"}]
    };


            


    init();


    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            get_profile();
            get_positions();
            get_department();
            get_levels();
            leave_types();
            
        })
    }

      function get_positions(){
        var promise = EmployeesFactory.get_positions();
        promise.then(function(data){
            $scope.titles.data = data.data.result;
        })
        .then(null, function(data){
            
        });
    }

    function get_department(){
        var filter = {
            archived : false
        }

        var promise = EmployeesFactory.get_department(filter);
        promise.then(function(data){
            $scope.department.data = data.data.result;
        })
        .then(null, function(data){
            
        });
    }

    function get_levels(){
        var promise = EmployeesFactory.get_levels();
        promise.then(function(data){
            $scope.level_title.data = data.data.result;
        })
        .then(null, function(data){
            
        });
    }
     $scope.addNewChoice = function() {
        if ($scope.employee.school_type == 1){
            $scope.employees.education.push({educ_level: "Primary"});
        }
        else if ($scope.employee.school_type == 2){
            $scope.employees.education.push({educ_level: "Secondary" });
        }
        else if ($scope.employee.school_type == 3){
            $scope.employees.education.push({educ_level: "Tertiary" });
        }
    };

    function leave_types(){
         var filter = {
            archived : false,
            employees_pk : $scope.profile.pk
        };
        
        $scope.leave_types.data = [];
        var promise = LeaveFactory.get_leave_types(filter);
        promise.then(function(data){
            $scope.leave_types.status = true;
            $scope.leave_types.data = data.data.result;

        
        })
        .then(null, function(data){
            
        });
    }

    function get_profile(){
         get_levels();
         get_department();
         get_positions();
         leave_types();


        var filters = { 
            'pk' : $scope.pk
        };


        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){

            $scope.profile = data.data.result[0];
            
            $scope.profile.details = JSON.parse($scope.profile.details);
            $scope.profile.permission = JSON.parse($scope.profile.permission);
            $scope.profile.leave_balances = JSON.parse($scope.profile.leave_balances);
           
            if ($scope.profile.details.personal.profile_picture === undefined || $scope.profile.details.personal.profile_picture === null
                || $scope.profile.details.personal.profile_picture == 'No Data') {
                $scope.profile.details.personal.profile_picture = './ASSETS/img/blank.gif';
            }
            if ($scope.profile.details.personal.contact_number == 'undefined'  || $scope.profile.details.personal.birth_date == undefined){
                $scope.profile.details.personal.contact_number = 'No Data';
            }
            if ($scope.profile.details.personal.present_address == 'Undefined' || $scope.profile.details.personal.present_address == undefined){
                $scope.profile.details.personal.present_address = 'No Data';
                
            }    
            if ($scope.profile.details.personal.permanent_address == 'Undefined' || $scope.profile.details.personal.permanent_address == undefined){
                $scope.profile.details.personal.permanent_address = 'No Data';
            }    
        

            if ($scope.profile.details.personal.religion == 'Undefined' || $scope.profile.details.personal.religion == undefined ){
                 $scope.profile.details.personal.religion = 'No Data';
            }


            if ($scope.profile.details.personal.emergency_contact_name == 'Undefined' || $scope.profile.details.personal.emergency_contact_name == undefined){
                 $scope.profile.details.personal.emergency_contact_name = 'No Data';
            }

            if ($scope.profile.details.personal.emergency_contact_number == 'Undefined' || $scope.profile.details.personal.emergency_contact_number == undefined){
                $scope.profile.details.personal.emergency_contact_number = 'No Data';
            }

            if ($scope.profile.details.personal.birth_date == null){
                $scope.profile.details.personal.birth_date ='No Data';
            }
            else{
                $scope.profile.details.personal.birth_date = new Date($scope.profile.details.personal.birth_date);
            }

            if ($scope.profile.details.personal.email_address == undefined){
                $scope.profile.details.personal.email_address = 'No Data';
            }

            if ($scope.profile.details.company.date_started == undefined){
                $scope.profile.details.company.date_started = 'No data';
            }
            else{
                $scope.profile.details.company.date_started = new Date($scope.profile.details.company.date_started);
            }

            if ($scope.profile.supervisor == undefined){
                $scope.profile.supervisor = 'No Data';
            }

            if ($scope.profile.deparments == undefined){
                $scope.profile.deparments = 'No Data';
            }
            if ($scope.profile.levels == undefined){
                $scope.profile.levels = 'No Data';
            }

            if ($scope.profile.titles == undefined){
                $scope.profile.titles = 'No Data';
            }

            if ($scope.profile.details.company.business_email_address == undefined){
                $scope.profile.details.company.business_email_address = 'No Data';
            }
            
            if ($scope.profile.details.company.employee_id == undefined){
                $scope.profile.details.company.employee_id = 'No Data';
            }

    

            var a = $scope.profile.leave_balances;
            $scope.profile.leave_balances = {};

             for(var i in $scope.leave_types.data){
                if(a[$scope.leave_types.data[i].pk] === undefined){
                    a[$scope.leave_types.data[i].pk] = 0;
                }
                $scope.profile.leave_balances[$scope.leave_types.data[i].name] = a[$scope.leave_types.data[i].pk];
               
            }

            if ($scope.profile.details.company.salary == undefined) {
                $scope.profile.details.company.salary = null;
            }
            else if ($scope.profile.details.company.salary != null) {
            $scope.isShown = function(salarys_type) {

            return salarys_type === $scope.profile.details.company.salary.salary_type;
            };
            }
            
            $scope.minus = 1;
            $scope.minus_20 = 20;

            $scope.profile.details.company.titles_pk = parseInt($scope.profile.details.company.titles_pk) - parseInt($scope.minus);
            $scope.profile.titles = $scope.titles.data[$scope.profile.details.company.titles_pk].title;
            
            $scope.profile.details.company.levels_pk = parseInt($scope.profile.details.company.levels_pk) - parseInt($scope.minus);
            $scope.profile.levels = $scope.level_title.data[$scope.profile.details.company.levels_pk].level_title;
            
            $scope.profile.details.company.departments_pk = parseInt($scope.profile.details.company.departments_pk) - parseInt($scope.minus_20);
            $scope.profile.deparments = $scope.department.data[$scope.profile.details.company.departments_pk].department;

            if ($scope.profile.details.company.employment_type == undefined){
                 $scope.profile.employment_typess = 'No Data';
            }
            else{
                $scope.profile.employment_typess = $scope.profile.details.company.employment_type;
            }


            if ($scope.profile.details.company.employee_status == undefined){
                $scope.profile.details.company.employee_status = 'No Data';
            }
            else{
                $scope.profile.employment_status = $scope.profile.details.company.employee_status;
            }


            if($scope.profile.details.personal.civilstatus == undefined){
                 $scope.profile.details.personal.civilstatus = 'No Data';
            }
            else{
                
                $scope.profile.civil_types = $scope.profile.details.personal.civilstatus;

            }
            if($scope.profile.details.personal.gender == undefined){
                $scope.profile.gender = 'No Data';
            }
            else{
                
                $scope.profile.gender_type = $scope.profile.details.personal.gender;
            }

            
    
        })   
    } 

    
});