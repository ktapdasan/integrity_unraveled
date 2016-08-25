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
    

    $scope.permissions = {};
    $scope.permissions.home = {
        timeinout : true
    };

    $scope.permissions.mytimesheet = {
        timesheet : true,
        leaves : true
    };

    $scope.permissions.employees = {
        new : false,
        list : false,
        timelogs : false
    };

    $scope.permissions.management = {
        manuallogs : false,
        leaves : false,
        attrition : false
    };

    $scope.permissions.administration = {
        departments : false,
        positions : false,
        levels : false,
        permissions : false,
        cutoff : false,
        leaves : false
    };

    $scope.employees={};
    $scope.employees.count=0;
    $scope.employees.filters={};
    $scope.employeesheet_data = [];
    
    $scope.modal = {};

    $scope.titles = {};
    $scope.department = {};
    $scope.level_title = {};

    $scope.filter = {};
    $scope.filter.status = "Active";

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            get_profile();
            employees();
            
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
            
            get_positions();
            get_department();
            get_levels();
        })   
    } 

    $scope.show_employees = function(){
       employees();
    }

    function employees(){
        $scope.filter.archived = 'false';
        
        var promise = EmployeesFactory.fetch_all($scope.filter);
        promise.then(function(data){
            $scope.employees.status = true;
            $scope.employees.count = data.data.result.length;
            
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
        var filter = {
            archived : false
        };
        var promise = EmployeesFactory.get_department(filter);
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

    $scope.show_list = function(){
        list();        
    }

    function list(){
        $scope.filter.pk = $scope.profile.pk;
        
        delete $scope.filter.departments_pk;
        if($scope.filter.department.length > 0){
            $scope.filter.departments_pk = $scope.filter.department[0].pk;  
        }
 
        delete $scope.filter.titles_pk;
        if($scope.filter.titles.length > 0){
            $scope.filter.titles_pk = $scope.filter.titles[0].pk;
        }

        delete $scope.filter.levels_pk;
        if($scope.filter.level_title.length > 0){
            $scope.filter.levels_pk = $scope.filter.level_title[0].pk;
        }

        employees();
    }
       
    $scope.update_access = function(k){
        $scope.permissions = {};
        $scope.permissions.home = {
            timeinout : false
        };

        $scope.permissions.mytimesheet = {
            timesheet : false,
            leaves : false
        };

        $scope.permissions.employees = {
            new : false,
            list : false,
            timelogs : false
        };

        $scope.permissions.management = {
            manuallogs : false,
            leaves : false,
            attrition : false
        };

        $scope.permissions.administration = {
            departments : false,
            positions : false,
            levels : false,
            permissions : false,
            cutoff : false,
            leaves : false
        };

        if($scope.employees.data[k].permission){
            var a = JSON.parse($scope.employees.data[k].permission);
            
            for(var i in a){   
                for(var x in a[i]){
                    if(a[i][x]){
                        a[i][x] = true;
                    }
                    else {
                        a[i][x] = false;  
                    }
                }
            }

            $scope.permissions = a;
        }

        $scope.modal = {
            title : 'Employees Permissions',
            save : 'Apply Changes',
            close : 'CLOSE',
        };

        ngDialog.openConfirm({
            template: 'PermissionModal',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;

                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want to apply changes to this employee account?</p>' +
                                '<div class="ngdialog-buttons">' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">No' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">Yes' +
                                '</button></div>',
                        plain: true,
                        className: 'ngdialog-theme-plain'
                    });

                return nestedConfirmDialog;
            },
            scope: $scope,
            showClose: false
        })
        .then(function(value){
            return false;
        }, function(value){

            var permissions = {
                data : JSON.stringify($scope.permissions),
                employees_pk : $scope.employees.data[k].pk
            };

            var promise = EmployeesFactory.update_permissions(permissions);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully updated ' + $scope.employees.data[k].first_name + "'s system access.", 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                employees();


            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to save changes, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    }

});