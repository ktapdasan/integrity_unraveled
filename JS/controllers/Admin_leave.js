app.controller('Admin_leave', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        LevelsFactory,
                                        LeaveFactory,
                                        ngDialog,
                                        UINotification,
                                        md5
                                    ){

    $scope.pk='';
    $scope.leave_types={};
    $scope.profile= {};

    $scope.filter= {};
    $scope.filter.status= "Active";

    $scope.modal = {};

    $scope.leave_default = {};

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            get_profile();
        });
    }

    function get_profile(){
        var filters = { 
            'pk' : $scope.pk
        };

        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){
            $scope.profile = data.data.result[0];

            leave_types();
            default_values();
        })           
    }

    $scope.status_changed = function(){
        leave_types();
    }

    function leave_types(){
        $scope.leave_types.status = false;
        $scope.leave_types.data= '';
        
        if ($scope.filter.status == 'Active')
        {
            $scope.filter.archived = 'false';  
        }
        else 
        {
            $scope.filter.archived = 'true';   
        }

        $scope.filter.employees_pk = $scope.profile.pk;
        
        var promise = LeaveFactory.get_leave_types($scope.filter);
        promise.then(function(data){
            $scope.leave_types.status = true;
            $scope.leave_types.data = data.data.result;
        })
        .then(null, function(data){
            $scope.leave_types.status = false;
        });
    }

    $scope.add_leavetype = function(k){

        $scope.modal = {
            title : 'Add New Leave Type',
            save : 'Save',
            close : 'Cancel'
        };

        ngDialog.openConfirm({
            template: 'LeaveTypeModal',
            className: 'ngdialog-theme-plain custom-widtheightfifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;

                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want add this leave type?</p>' +
                                '<div class="ngdialog-buttons">' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">No' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">Yes' +
                                '</button></div>',
                        plain: true,
                        className: 'ngdialog-theme-plain custom-widtheightfifty'
                    });

                return nestedConfirmDialog;
            },
            scope: $scope,
            showClose: false
        })
        .then(function(value){
            return false;
        }, function(value){

            var promise = LeaveFactory.add_leavetype($scope.modal);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully added leave type.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                leave_types();
                
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
    
    $scope.edit_leavetype = function(k){
        $scope.modal = {
            title : 'Edit Leave Type',
            save : 'Apply Changes',
            close : 'Cancel',
            name: $scope.leave_types.data[k].name,
            days: $scope.leave_types.data[k].days,
            code: $scope.leave_types.data[k].code,
            pk: $scope.leave_types.data[k].pk,
            regularization: JSON.parse($scope.leave_types.data[k].details).regularization,
            staggered: JSON.parse($scope.leave_types.data[k].details).staggered
        };

        ngDialog.openConfirm({
            template: 'LeaveTypeModal',
            className: 'ngdialog-theme-plain custom-widtheightfifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;

                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want to apply changes to this leave type?</p>' +
                                '<div class="ngdialog-buttons">' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">No' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">Yes' +
                                '</button></div>',
                        plain: true,
                        className: 'ngdialog-theme-plain custom-widtheightfifty'
                    });

                return nestedConfirmDialog;
            },
            scope: $scope,
            showClose: false
        })
        .then(function(value){
            return false;
        }, function(value){
            var promise = LeaveFactory.edit($scope.modal);
            promise.then(function(data){
                UINotification.success({
                                        message: 'You have successfully applied changes.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });

                $scope.leave_types.data[k].name =  $scope.modal.name;
                $scope.leave_types.data[k].days =  $scope.modal.days;
                $scope.leave_types.data[k].code =  $scope.modal.code;
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

    $scope.delete_leavetype = function(k){
       
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to delete this leave type?',
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
            var filter = {
                leave_types_pk : $scope.leave_types.data[k].pk,
            };
            
            var promise = LeaveFactory.admin_leave_delete(filter);
            promise.then(function(data){
                $scope.leave_types.status = true;
                $scope.leave_types.data = data.data.result;
                $scope.archived=false;

                UINotification.success({
                                        message: 'You have successfully deleted leave type', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                leave_types();
            })
            .then(null, function(data){
                $scope.leave_types.status = false;
                UINotification.error({
                                        message: 'An error occured, unable to delete, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    }

    function default_values() {
        var filters = { 
            'name' : 'leave'
        };

        var promise = LeaveFactory.default_values(filters);
        promise.then(function(data){
            $scope.leave_default.status = true;
            $scope.leave_default.data = data.data.result[0];

            $scope.leave_default.data.details = JSON.parse($scope.leave_default.data.details);
            $scope.leave_default.data.regularization = $scope.leave_default.data.details.regularization
            $scope.leave_default.data.staggered = $scope.leave_default.data.details.staggered;
        })
        .then(null, function(data){
            $scope.leave_default.status = false;
        });
    }

    $scope.save_default = function(){
        $scope.modal = {
                title : '',
                message: 'Are you sure you want to update these values?',
                save : 'Update',
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
            
            $scope.leave_default.data.employees_pk = $scope.profile.pk;

            var promise = LeaveFactory.update_default_values($scope.leave_default.data);
            promise.then(function(data){
                
                $scope.archived=true;

                UINotification.success({
                                        message: 'You have successfully updated leave default', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                leave_types();
            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to update, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    }

    $scope.default_checkbox_toggle = function(){
        if($scope.modal.default_checkbox){
            $scope.modal.regularization = $scope.leave_default.data.regularization;
            $scope.modal.staggered = $scope.leave_default.data.staggered;
        }
        else {
            $scope.modal.regularization = "";
            $scope.modal.staggered = "";
        }
    }
});