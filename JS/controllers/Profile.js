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
            // get_supervisors();
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

         $scope.genders = [
                { pk:'1', gender:'Male'},
                { pk:'2', gender:'Female'}
            ];
            $scope.civils = [
                { pk:'1', civilstatus:'Married'},
                { pk:'2', civilstatus:'Single'},
                { pk:'3', civilstatus:'Divorced'},
                { pk:'4', civilstatus:'Living Common Law'},
                { pk:'5', civilstatus:'Widowed'}
            ];
            $scope.estatus = [
                { pk:'1', emstatus:'Probationary'},
                { pk:'2', emstatus:'Trainee'},
                { pk:'3', emstatus:'Contractual'},
                { pk:'4', emstatus:'Regular'},
                { pk:'5', emstatus:'Consultant'}
            ];
            $scope.etype = [
                { pk:'1', emtype:'Exempt'},
                { pk:'2', emtype:'Non-Exempt'}
            ];
        var filters = { 
            'pk' : $scope.pk
        };


        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){

            $scope.profile = data.data.result[0];
            
            $scope.profile.details = JSON.parse($scope.profile.details);
            $scope.profile.permission = JSON.parse($scope.profile.permission);
            $scope.profile.leave_balances = JSON.parse($scope.profile.leave_balances);
            
            if ($scope.profile.details.personal.profile_picture === undefined || $scope.profile.details.personal.profile_picture === null) {
                $scope.profile.details.personal.profile_picture = './ASSETS/img/blank.gif';
            }

            $scope.minus = 1;
            $scope.minus_20 = 20;

            $scope.profile.details.company.titles_pk = parseInt($scope.profile.details.company.titles_pk) - parseInt($scope.minus);
            $scope.profile.titles = $scope.titles.data[$scope.profile.details.company.titles_pk].title;
            
            $scope.profile.details.company.levels_pk = parseInt($scope.profile.details.company.levels_pk) - parseInt($scope.minus);
            $scope.profile.levels = $scope.level_title.data[$scope.profile.details.company.levels_pk].level_title;
            
            $scope.profile.details.company.departments_pk = parseInt($scope.profile.details.company.departments_pk) - parseInt($scope.minus_20);
            $scope.profile.deparments = $scope.department.data[$scope.profile.details.company.departments_pk].department;

            $scope.profile.details.company.employment_type_pk = parseInt($scope.profile.details.company.employment_type_pk) - parseInt($scope.minus);
            $scope.profile.employment_typess = $scope.etype[$scope.profile.details.company.employment_type_pk].emtype;
            
            $scope.profile.details.company.employee_status_pk = parseInt($scope.profile.details.company.employee_status_pk) - parseInt($scope.minus);
            $scope.profile.employment_status = $scope.estatus[$scope.profile.details.company.employee_status_pk].emstatus;

            $scope.profile.details.personal.civilstatus_pk = parseInt($scope.profile.details.personal.civilstatus_pk) - parseInt($scope.minus);
            $scope.profile.civil_types = $scope.civils[$scope.profile.details.personal.civilstatus_pk].civilstatus;

            var a = $scope.profile.leave_balances;
            $scope.profile.leave_balances = {};

             for(var i in $scope.leave_types.data){
                if(a[$scope.leave_types.data[i].pk] === undefined){
                    a[$scope.leave_types.data[i].pk] = 0;
                }s
                $scope.profile.leave_balances[$scope.leave_types.data[i].name] = a[$scope.leave_types.data[i].pk];
               
            }
            
        })   
    } 

    
});