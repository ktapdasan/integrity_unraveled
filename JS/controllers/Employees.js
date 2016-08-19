app.controller('Employees', function(
  										$scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        TimelogFactory,
                                        ngDialog,
                                        UINotification,
                                        md5
  									){

    $scope.pk='';
    $scope.profile = {};
    $scope.filter = {};
    $scope.filter.status = 'Active';


    $scope.titles={};
    $scope.department={};
    $scope.level_title={};
    $scope.groupings= {};

    $scope.employee = {};
    $scope.employees={};
    $scope.employees.filters={};
    $scope.employeesheet_data = [];
    
    $scope.modal = {};
    $scope.level_class = 'orig_width';
    $scope.show_hours = false;


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
            get_supervisors();
            //select
            fetch_department();
            fetch_levels();
            fetch_titles();


            
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
            //employees_fetch();
            //list();
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

        $scope.filter.date_from = new Date(yyyy+'-'+mm+'-01'); 
        $scope.filter.date_to = new Date();

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



    $scope.show_employees = function(){

       employees();
    }

    function employees(){
        
        $scope.filter.archived = 'false';


        var promise = EmployeesFactory.fetch_all($scope.filter);
        promise.then(function(data){
            $scope.employees.status = true;
            //$scope.employees.data = data.data.result;
            
            //$scope.employees.data
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
            $scope.titles.data = data.data.result;
        })
        .then(null, function(data){
            
        });
    }

    function get_department(){
        var promise = EmployeesFactory.get_department();
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

    function get_supervisors(){
        var promise = EmployeesFactory.get_supervisors();
        promise.then(function(data){
            $scope.employees.supervisors = data.data.result;
        })
        .then(null, function(data){
            
        });
    }
       
    $scope.export_employees = function(){
        window.open('./FUNCTIONS/Timelog/employees_export.php?pk='+$scope.filter.pk+'&datefrom='+$scope.filter.datefrom+"&dateto="+$scope.filter.dateto);
    }

    // $scope.delete_employees = function(k){

       
    //    $scope.modal = {
    //             title : '',
    //             message: 'Are you sure you want to deactivate this employee?',
    //             save : 'Deactivate',
    //             close : 'Cancel'
    //         };
    //    ngDialog.openConfirm({
    //         template: 'ConfirmModal',
    //         className: 'ngdialog-theme-plain',
            
    //         scope: $scope,
    //         showClose: false
    //     })

        
    //     .then(function(value){
    //         return false;
    //     }, function(value){
    //         var promise = EmployeesFactory.delete_employees($scope.employees.data[k]);
    //         promise.then(function(data){
                
    //             $scope.archived=true;

    //             UINotification.success({
    //                                     message: 'You have successfully deactivated an employees account.', 
    //                                     title: 'SUCCESS', 
    //                                     delay : 5000,
    //                                     positionY: 'top', positionX: 'right'
    //                                 });
    //             employees();

    //         })
    //         .then(null, function(data){
                
    //             UINotification.error({
    //                                     message: 'An error occured, unable to deactivate, please try again.', 
    //                                     title: 'ERROR', 
    //                                     delay : 5000,
    //                                     positionY: 'top', positionX: 'right'
    //                                 });
    //         });         

                            
    //     });
    // }




    $scope.delete_employees = function(k){

       
       $scope.modal = {
                title : '',
                message: 'Deactivate Accounts',
                save : 'Deactivate',
                close : 'Cancel'
            };
    
       ngDialog.openConfirm({
            template: 'DeactivateModal',
            className: 'ngdialog-theme-plain',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;
                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want deactivate?</p>' +
                                '<div class="ngdialog-buttons">' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">No' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">Yes' +
                                '</button></div>',
                        plain: true,
                        className: 'ngdialog-theme-plain custom-widththreefifty'
                    });

                return nestedConfirmDialog;
            },
            scope: $scope,
            showClose: false
        })

        
         .then(function(value){
            return false;
        }, function(value){
            var last_day_work= new Date($scope.modal.last_day_work);
                var dd = last_day_work.getDate();
                var mm= last_day_work.getMonth();
                var yyyy = last_day_work.getFullYear();
            var effective_date= new Date($scope.modal.effective_date);
                var DD= effective_date.getDate();
                var MM = effective_date.getMonth(); 
                var YYYY = effective_date.getFullYear(); 
               
            $scope.modal.last_day_work = yyyy+'-'+mm+'-'+dd;
            $scope.modal.effective_date = YYYY+'-'+MM+'-'+DD;
            $scope.modal["pk"] = $scope.profile.pk;
            $scope.modal["supervisor_pk"] = $scope.profile.supervisor_pk;

            
            var promise = EmployeesFactory.delete_employees($scope.employees.data[k]);
            promise.then(function(data){
                
                $scope.archived=true;

                UINotification.success({
                                        message: 'You have successfully deactivated an employees account.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                employees();

            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to deactivate, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });             
                            
        });
    }







    $scope.activate_employees = function(k){
       
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to reactivate this employee?',
                save : 'Reactivate',
                close : 'Cancel'
            };
       ngDialog.openConfirm({
            template: 'ConfirmModal',
            className: 'ngdialog-theme-plain',
            
            scope: $scope,
            showClose: false
        })

        
        .then(function(value){
            return false;
        }, function(value){
            var promise = EmployeesFactory.activate_employees($scope.employees.data[k]);
            promise.then(function(data){
                
                $scope.archived=true;

                UINotification.success({
                                        message: 'You have successfully deactivated an employees account.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                employees();

            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to deactivate, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    }

    $scope.edit_employees = function(k){
        get_supervisors();

        $scope.employee = $scope.employees.data[k];

        if($scope.employees.data[k].details){
            $scope.employee.intern_hours = $scope.employees.data[k].details.company.hours;    
        }

        level_changed();
        $scope.modal = {
            title : 'Edit ' + $scope.employees.data[k].first_name,
            save : 'Apply Changes',
            close : 'Cancel',
        };

        ngDialog.openConfirm({
            template: 'EditModal',
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
            
        
            var promise = EmployeesFactory.edit_employees($scope.employees.data[k]);
            promise.then(function(data){
                

                $scope.archived=true;

                UINotification.success({
                                        message: 'You have successfully applied changes to this employee account.', 
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
    
    $scope.export_employeelist = function(){
        //var flag = true;
        //list();
        // $scope.url ="./FUNCTIONS/Employees/employeelist_export.php?&status=Active &department="+$scope.filter.department+'&titles='+$scope.filter.title+'&level_title='+$scope.filter.level_title;
        
        var filters=[];
        if($scope.filter.department[0]){
            filters.push('&departments_pk=' + $scope.filter.department[0].pk);
        }

        if($scope.filter.level_title[0]){
            filters.push('&levels_pk=' + $scope.filter.level_title[0].pk);
        }

        if($scope.filter.titles[0]){
            filters.push('&titles_pk=' + $scope.filter.titles[0].pk);
        }

        window.open('./FUNCTIONS/Employees/employeelist_export.php?&status=Active' + filters.join(''));
   
    }

    $scope.level_changed = function(){
        level_changed();
    }

    function level_changed(){
        if ($scope.employee.levels_pk == 3) {
            $scope.level_class = 'hours';
            $scope.show_hours = true;
        }
        else{
           $scope.level_class = 'orig_width';
            $scope.show_hours = false;
        }
    
    }

    $scope.show_list = function(){
        list();        
    }

    function list(){
        $scope.filter.pk = $scope.profile.pk;
 /*       
        delete $scope.filter.employees_pk;
        if($scope.filter.employee.length > 0){
            $scope.filter.employees_pk = $scope.filter.employee[0].pk;
        }*/
        
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
    
    function fetch_department(){
        var filter = {
            archived : false
        }

        var promise = EmployeesFactory.get_department(filter);
        promise.then(function(data){
            var a = data.data.result;
            $scope.employees.filters.department=[];
            for(var i in a){
                $scope.employees.filters.department.push({
                                            pk: a[i].pk,
                                            name: a[i].department,
                                            ticked: false
                                        });
            }

        })
        .then(null, function(data){
            
        });
    }


    function fetch_levels(){
        var promise = EmployeesFactory.get_levels();
        promise.then(function(data){
            var a = data.data.result;
            $scope.employees.filters.level_title=[];
            for(var i in a){
                $scope.employees.filters.level_title.push({
                                            pk: a[i].pk,
                                            name: a[i].level_title,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            
        });
    }


    function fetch_titles(){
        var promise = EmployeesFactory.get_positions();
        promise.then(function(data){
             var a = data.data.result;
            $scope.employees.filters.titles=[];
            for(var i in a){
                $scope.employees.filters.titles.push({
                                            pk: a[i].pk,
                                            name: a[i].title,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            
        });
    }

});