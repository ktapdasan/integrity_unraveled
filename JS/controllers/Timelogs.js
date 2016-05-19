app.controller('Timelogs', function(
  										$scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        TimelogFactory,
                                        md5,
                                        UINotification
  									){

    $scope.profile = {};
    $scope.filter = {};
    $scope.timesheet_data = [];
    $scope.employee = [];
    $scope.employeelist_data = [];


    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            get_profile();
            
        })
        .then(null, function(data){
            window.location = './login.html';
        });
    }

    function get_profile(){
        var filters = { 
            'pk' : $scope.pk
        };

        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){
            $scope.profile = data.data.result[0];
            DEFAULTDATES();
            employees();
            timesheet();
            employee_list();
        })   
    } 

    function DEFAULTDATES(){
        var today = new Date();

        var dd = today.getDate();
        var mm = today.getMonth()+1; //January is 0!
        var yyyy = today.getFullYear();

        if(dd<10) {
            dd='0'+dd
        } 

        if(mm<10) {
            mm='0'+mm
        } 

        today = yyyy+'-'+mm+'-'+dd;

        //$scope.filter.datefrom = getMonday(new Date());
        $scope.filter.datefrom = yyyy+'-'+mm+'-01';
        $scope.filter.dateto = today;

    }

    function getMonday(d) {
        var d = new Date(d);
        var day = d.getDay(),
            diff = d.getDate() - day + (day == 0 ? -6:1); // adjust when day is sunday

        var new_date = new Date(d.setDate(diff));
        var dd = new_date.getDate();
        var mm = new_date.getMonth()+1; //January is 0!
        var yyyy = new_date.getFullYear();

        if(dd<10) {
            dd='0'+dd
        } 

        if(mm<10) {
            mm='0'+mm
        } 

        var monday = yyyy+'-'+mm+'-'+dd;

        return monday;
    }

    function employees(){
        var filter = {
            archived : 'false'
        };

        var promise = EmployeesFactory.fetch(filter);
        promise.then(function(data){
            var a = data.data.result;
            $scope.employees=[];
            for(var i in a){
                $scope.employees.push({
                                            pk: a[i].pk,
                                            name: a[i].last_name +", "+a[i].first_name+" "+a[i].middle_name,
                                            ticked: false
                                        });
            }
        })
    }

    $scope.show_timesheet = function(){
        timesheet();        
    }

    function timesheet(){
        $scope.filter.pk = $scope.profile.pk;
        
        delete $scope.filter.employees_pk;
        if($scope.filter.employee.length > 0){
            $scope.filter.employees_pk = $scope.filter.employee[0].pk;
        }
        
        var promise = TimelogFactory.timelogs($scope.filter);
        promise.then(function(data){
            $scope.timesheet_data = data.data.result;

            
        })   
    }

    $scope.export_timesheet = function(){
        $scope.filter.pk = $scope.profile.pk;
        
        delete $scope.filter.employees_pk;
        if($scope.filter.employee.length > 0){
            $scope.filter.employees_pk = $scope.filter.employee[0].pk;
        }

        window.open('./FUNCTIONS/Timelog/timelogs_export.php?pk='+$scope.filter.pk+'&datefrom='+$scope.filter.datefrom+"&dateto="+$scope.filter.dateto+'&employees_pk='+$scope.filter.employees_pk);

        
    }





    $scope.show_employeelist = function(){
        employeelist();        
    }

    function employeelist(){
        $scope.filter.pk = $scope.profile.pk;
        
        delete $scope.filter.employees_pk;
        if($scope.filter.employee.length > 0){
            $scope.filter.employees_pk = $scope.filter.employee[0].pk;
        }
        
        var promise = TimelogFactory.timelogs($scope.filter);
        promise.then(function(data){
            $scope.employeelist_data = data.data.result;

            
        })   
    }

    $scope.export_employeelist = function(){
        $scope.filter.pk = $scope.profile.pk;
        
        delete $scope.filter.employees_pk;
        if($scope.filter.employee.length > 0){
            $scope.filter.employees_pk = $scope.filter.employee[0].pk;
        }

        window.open('./FUNCTIONS/Timelog/timelogs_export.php?pk='+$scope.filter.pk+'&datefrom='+$scope.filter.datefrom+"&dateto="+$scope.filter.dateto+'&employees_pk='+$scope.filter.employees_pk);

        
    }
});