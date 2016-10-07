app.controller('Header', function(
  										$scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        md5,
                                        ngDialog,
                                        UINotification,
                                        $location
  									){

    init();

    $scope.menu = {
        home : 'active',
        employees : '',
        payroll : '',
        timesheet : '',
        admin : '',
        manual : '',
        leave : '',
        management : ''
        
    }

    $scope.pk = null;
    $scope.profile = {};

    $scope.modal = {};

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

    $scope.logout = function(){
        var promise = SessionFactory.logout();
        promise.then(function(data){
            window.location = './login.html';
        })
    }

    function get_profile(){
        var filters = { 
            'pk' : $scope.pk
        };

        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){
            $scope.profile = data.data.result[0];



            $scope.profile.details = JSON.parse($scope.profile.details);
            $scope.profile.permission = JSON.parse($scope.profile.permission);
            $scope.profile.leave_balances = JSON.parse($scope.profile.leave_balances);

            menuselect($location.$$path.replace(/\//,''));
        })   
    }

    $scope.change_password = function(){
        $scope.modal = {
            title : 'Change Password',
            save : 'Update',
            close : 'Cancel'
        };

        ngDialog.openConfirm({
            template: 'PasswordModal',
            className: 'ngdialog-theme-plain',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;

                if($scope.modal.data.new_password != $scope.modal.data.confirm_password){
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p>New Password and Confirm Password does not match?</p>' +
                                '<div class="ngdialog-buttons">' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">OK' +
                                '</button></div>',
                        plain: true,
                        className: 'ngdialog-theme-plain'
                    });                    
                }
                else {
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p>Are you sure you want to change your password?</p>' +
                                '<div class="ngdialog-buttons">' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">No' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">Yes' +
                                '</button></div>',
                        plain: true,
                        className: 'ngdialog-theme-plain'
                    });
                }

                return nestedConfirmDialog;
            },
            scope: $scope,
            showClose: false
        })
        .then(function(value){
            return false;
        }, function(value){
            var filter = {
                employee_id : $scope.profile.employee_id,
                old_password : $scope.modal.data.old_password,
                new_password : $scope.modal.data.new_password,
                confirm_password : $scope.modal.data.confirm_password
            };

            var promise = EmployeesFactory.auth({ empid : $scope.profile.employee_id, password : $scope.modal.data.old_password });
            promise.then(function(data){
                var promise = EmployeesFactory.change_password(filter);
                promise.then(function(data){
                    UINotification.success({
                                        message: 'You have successfully changed your password.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                })
            })
            .then(null, function(data){
                UINotification.error({
                                        message: 'Changing password failed.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });            

                            
        });
    }

    $scope.manual_log = function(){
        $scope.modal = {
            title : 'Manual Log',
            save : 'Save',
            close : 'Cancel'
        };

        ngDialog.openConfirm({
            template: 'ManualLogModal',
            className: 'ngdialog-theme-plain',
            preCloseCallback: function(value) {
                var nestedConfirmDialog = ngDialog.openConfirm({
                    template:
                            '<p>Are you sure you want to file a manual log?</p>' +
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
            // var filter = {
            //     employee_id : $scope.profile.employee_id,
            //     old_password : $scope.modal.data.old_password,
            //     new_password : $scope.modal.data.new_password,
            //     confirm_password : $scope.modal.data.confirm_password
            // };

            // var promise = EmployeesFactory.change_password(filter);
            // promise.then(function(data){
            //     console.log(data.data);
            // })
            // .then(null, function(data){
                
            // });
        });
    }

    $scope.menuclicked = function(menu){
        menuselect(menu);
    }

    function menuselect(menu){
        if(menu == ''){
            menu = 'home';
        }
        
        for(var i in $scope.menu){
            $scope.menu[i] = '';
        }

        $scope.menu[menu.split('/')[0]] = 'active';
    }
});