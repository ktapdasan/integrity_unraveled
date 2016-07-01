app.controller('Position', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        TitlesFactory,
                                        ngDialog,
                                        UINotification,
                                        md5
                                    ){

    $scope.pk='';
    $scope.titles={};
    $scope.modal = {};

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            get_positions();
            
            
        })
        .then(null, function(data){
            window.location = './login.html';
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

    $scope.edit_position = function(k){
    //$scope.employee = $scope.employees.data[k];

    $scope.modal = {

        title : 'Edit Position',
        save : 'Apply Changes',
        close : 'Cancel',
        fields : {
            pk : $scope.titles.data[k].pk,
            title : $scope.titles.data[k].title
        }

    };

    ngDialog.openConfirm({
        template: 'PositionModal',
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
        var promise = TitlesFactory.update($scope.modal.fields);
        promise.then(function(data){

            UINotification.success({
                                    message: 'You have successfully applied changes.', 
                                    title: 'SUCCESS', 
                                    delay : 5000,
                                    positionY: 'top', positionX: 'right'
                                });
            $scope.titles.data[k].title =  $scope.modal.fields.title;
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

    $scope.delete_position = function(k){
       
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to delete this position?',
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
            var promise = TitlesFactory.delete_position($scope.title);
            promise.then(function(data){
                

                $scope.archived=true;

                UINotification.success({
                                        message: 'You have successfully deleted position', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });

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