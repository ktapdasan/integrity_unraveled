app.controller('Levels', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        LevelsFactory,
                                        ngDialog,
                                        UINotification,
                                        md5
                                    ){

    $scope.pk='';
    $scope.level_title={};

    $scope.filter= {};
    $scope.filter.status= "Active";

    $scope.modal = {};
    $scope.levels = {};


    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            levels();
            
        });
    }



    $scope.edit_level = function(k){

    $scope.modal = {

        title : 'Edit Level',
        save : 'Apply Changes',
        close : 'Cancel',
        fields : {
                pk : $scope.level_title.data[k].pk,
                level_title : $scope.level_title.data[k].level_title
        }

    };

    ngDialog.openConfirm({
        template: 'LevelModal',
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
        var promise = LevelsFactory.update($scope.modal.fields);
        promise.then(function(data){

            UINotification.success({
                                    message: 'You have successfully applied changes.', 
                                    title: 'SUCCESS', 
                                    delay : 5000,
                                    positionY: 'top', positionX: 'right'
                                });
            $scope.level_title.data[k].level_title =  $scope.modal.fields.level_title;
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

    $scope.delete_level = function(k){
       
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to delete this level?',
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
            
            var promise = LevelsFactory.delete_level($scope.level_title.data[k]);
            promise.then(function(data){
                
                $scope.archived=true;

                UINotification.success({
                                        message: 'You have successfully deleted level', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                $scope.level_title.data.splice(k,1);
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

$scope.restore_level = function(k){
       
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to restore this level?',
                save : 'Restore',
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
            
            var promise = LevelsFactory.restore_level($scope.level_title.data[k]);
            promise.then(function(data){
                
                $scope.archived=false;

                UINotification.success({
                                        message: 'You have successfully restored level', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                $scope.level_title.data.splice(k,1);
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
    $scope.add_level = function(k){

    $scope.modal = {

        title : 'Add New Level',
        save : 'Apply Changes',
        close : 'Cancel'

    };

    ngDialog.openConfirm({
        template: 'LevelNewModal',
        className: 'ngdialog-theme-plain custom-widththreefifty',
        preCloseCallback: function(value) {
            var nestedConfirmDialog;

            
                nestedConfirmDialog = ngDialog.openConfirm({
                    template:
                            '<p></p>' +
                            '<p>Are you sure you want add this level?</p>' +
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
        var promise = LevelsFactory.add_level($scope.modal);
        promise.then(function(data){

            UINotification.success({
                                    message: 'You have successfully added level.', 
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

    $scope.show_levels = function(){
        levels();
    }
   

    function levels(){

        $scope.level_title.status = false;
        $scope.level_title.data= '';
        
        if ($scope.filter.status == 'Active')
        {
            $scope.filter.archived = 'false';  
        }
        else 
        {
            $scope.filter.archived = 'true';   
        }
        
        var promise = LevelsFactory.get_levels($scope.filter);
        promise.then(function(data){
            $scope.level_title.status = true;
            $scope.level_title.data = data.data.result;

        })
        .then(null, function(data){
            $scope.level_title.status = false;
        });
    }
});