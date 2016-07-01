app.controller('Department', function(
  										$scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        DepartmentsFactory,
                                        ngDialog,
                                        UINotification,
                                        md5
  									){

    
    $scope.department={};
    $scope.filter= {};
    
    $scope.modal = {};

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            get_profile();
            get_department();
            
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



    function get_department(){
        var promise = DepartmentsFactory.get_department();
        promise.then(function(data){
            $scope.department.data = data.data.result;
        })
        .then(null, function(data){
            
        });
    }

    
    $scope.edit_department = function(k){
        //$scope.employee = $scope.employees.data[k];

        $scope.modal = {

            title : 'Edit Department',
            save : 'Apply Changes',
            close : 'Cancel',
            department : $scope.department.data[k].department,
            code : $scope.department.data[k].code,
            archived : $scope.department.data[k].archived,
            pk: $scope.department.data[k].pk
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
                                        message: 'You have successfully applied changes to this employee account.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                $scope.department.data[k].department =  $scope.modal.department;
                $scope.department.data[k].code = $scope.modal.code;
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
            var promise = DepartmentsFactory.delete_department($scope.department);
            promise.then(function(data){
                

                $scope.archived=true;

                UINotification.success({
                                        message: 'You have successfully deleted department', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                employees();

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

});