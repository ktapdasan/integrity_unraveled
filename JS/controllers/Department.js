app.controller('Department', function(
  										$scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        DepartmentsFactory,
                                        ngDialog,
                                        UINotification,
                                        md5
  									){

    $scope.pk='';
    $scope.filter= {};
    $scope.filter.status= 'Active';
    $scope.department={};
    $scope.departments={};
    $scope.departments.count=0;
    $scope.modal = {};
    
 
    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            get_profile();
            departments();
            
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
          /*  employees();*/
        })   
    } 


   /* function get_department(){
        var promise = DepartmentsFactory.get_department();
        promise.then(function(data){
            $scope.departments.data = data.data.result;
        })
        .then(null, function(data){
            
        });
    }*/

    
    $scope.edit_department = function(k){
        //$scope.employee = $scope.employees.data[k];
        
        $scope.modal = {

            title : 'Edit Department',
            save : 'Apply Changes',
            close : 'Cancel',
            department : $scope.departments.data[k].department,
            code : $scope.departments.data[k].code,
            archived : $scope.departments.data[k].archived,
            pk: $scope.departments.data[k].pk
        };

        ngDialog.openConfirm({
            template: 'DepartmentModal',
            className: 'ngdialog-theme-plain custom-widththreefifty',
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
            var promise = DepartmentsFactory.update($scope.modal);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully applied changes to this department.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                $scope.departments.data[k].department =  $scope.modal.department;
                $scope.departments.data[k].code = $scope.modal.code;
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

    $scope.delete_department = function(k){
       
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to delete this department?',
                save : 'Delete',
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

            
            var promise = DepartmentsFactory.delete_department($scope.departments.data[k]);
            promise.then(function(data){
                

                $scope.archived=true;
                UINotification.success({
                                        message: 'You have successfully deleted department', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                $scope.departments.data.splice(k,1);

            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to delete, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    }

    $scope.restore_department = function(k){
       
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to restore this department?',
                save : 'restore',
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

            
            var promise = DepartmentsFactory.restore_department($scope.departments.data[k]);
            promise.then(function(data){
                

                $scope.archived=true;
                UINotification.success({
                                        message: 'You have successfully restored department', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                $scope.departments.data.splice(k,1);

            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to restore, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    }

    $scope.add_department = function(k){
     
        $scope.modal = {

            title : 'Add New Department',
            save : 'Apply Changes',
            close : 'Cancel',

           
        };

        ngDialog.openConfirm({
            template: 'DepartmentNewModal',
            className: 'ngdialog-theme-plain custom-widththreefifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;

                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want to add this department?</p>' +
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
            var promise = DepartmentsFactory.add_department($scope.modal);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully added new department', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
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
    
    $scope.show_departments = function(){
        departments();
    }
   

    function departments(){

        $scope.departments.status = false;
        $scope.departments.data= '';

        if ($scope.filter.status == 'Active')
        {
            $scope.filter.archived = 'false';  
        }
        else 
        {
            $scope.filter.archived = 'true';   
        }
       
        var promise = DepartmentsFactory.get_department($scope.filter);
        promise.then(function(data){
            $scope.departments.status = true;
            $scope.departments.data = data.data.result;
            $scope.departments.count = data.data.result.length;

        })
        .then(null, function(data){
            $scope.departments.status = false;
        });
    }

 });