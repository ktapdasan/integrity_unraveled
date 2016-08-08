app.controller('EmployeesPermissions', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        ngDialog,
                                        UINotification,
                                        md5
                                    ){
    $scope.profile = {};

    $scope.employee = {};

    $scope.employees={};
    $scope.employees.filters={};
    $scope.employeesheet_data = [];
    
    $scope.modal = {};
    $scope.level_class = 'orig_width';
    $scope.show_hours = false;

    $scope.titles = {};
    $scope.department = {};
    $scope.level_title = {};

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
            //employees();
            get_positions();
            get_department();
            get_levels();
        })   
    } 

    $scope.show_employees = function(){

       employees();
    }

    function employees(){
        var promise = EmployeesFactory.fetch_all($scope.filter);
        promise.then(function(data){
            $scope.employees.status = true;
            
            var a = data.data.result;
            for(var i in a){
                a[i].details = JSON.parse(a[i].details);
            }

            $scope.employees.data = a;

            
        })
        .then(null, function(data){
            $scope.employees.status = false;
        });

    }

    function get_positions(){
        var promise = EmployeesFactory.get_positions();
        promise.then(function(data){
            var a = data.data.result;

            $scope.titles.data = [];
            for(var i in a){
                $scope.titles.data.push({
                                            pk: a[i].pk,
                                            name: a[i].title,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            
        });
    }

    function get_department(){
        var promise = EmployeesFactory.get_department();
        promise.then(function(data){
            var a = data.data.result;

            $scope.department.data = [];
            for(var i in a){
                $scope.department.data.push({
                                            pk: a[i].pk,
                                            name: a[i].department,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            
        });
    }

    function get_levels(){
        var promise = EmployeesFactory.get_levels();
        promise.then(function(data){
            var a = data.data.result;

            $scope.level_title.data = [];
            for(var i in a){
                $scope.level_title.data.push({
                                            pk: a[i].pk,
                                            name: a[i].level_title,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            
        });
    }
       
    $scope.update_access = function(){
        console.log('asdf');
    }

});