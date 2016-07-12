app.controller('Leave', function(
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

    $scope.filter= {};
    $scope.filter.status= "Active";

    $scope.modal = {};
   


    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            leavetypes();
            
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

    $scope.add_leave = function(k){

    $scope.modal = {

        title : 'File for Leave',
        save : 'Submit',
        close : 'Cancel'

    };

    ngDialog.openConfirm({
        template: 'SubmitLeaveModal',
        className: 'ngdialog-theme-plain custom-widththreefifty',
        preCloseCallback: function(value) {
            var nestedConfirmDialog;

            
                nestedConfirmDialog = ngDialog.openConfirm({
                    template:
                            '<p></p>' +
                            '<p>Are you sure you want file leave?</p>' +
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
        var promise = LeaveFactory.add_leave($scope.modal);
        promise.then(function(data){

            UINotification.success({
                                    message: 'You have successfully added level.', 
                                    title: 'SUCCESS', 
                                    delay : 5000,
                                    positionY: 'top', positionX: 'right'
                                });
            leavetypes();
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

    $scope.show_leavetypes = function(){
        leavetypes();
    }
   

    function leavetypes(){

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
        
        var promise = LeaveFactory.get_leavetypes($scope.filter);
        promise.then(function(data){
            $scope.leave_types.status = true;
            $scope.leave_types.data = data.data.result;

        })
        .then(null, function(data){
            $scope.leave_types.status = false;
        });
    }

        $scope.today = function() {
            $scope.dt = new Date();
          };
        $scope.today();

            $scope.clear = function() {
            $scope.dt = null;
          };

        $scope.inlineOptions = {
            customClass: getDayClass,
            minDate: new Date(),
            showWeeks: true
          };

        $scope.dateOptions = {
            dateDisabled: disabled,
            formatYear: 'yy',
            maxDate: new Date(2020, 5, 22),
            minDate: new Date(),
            startingDay: 1
          };

          // Disable weekend selection
        function disabled(data) {
            var date = data.date,
              mode = data.mode;
            return mode === 'day' && (date.getDay() === 0 || date.getDay() === 6);
          }

        $scope.toggleMin = function() {
            $scope.inlineOptions.minDate = $scope.inlineOptions.minDate ? null : new Date();
            $scope.dateOptions.minDate = $scope.inlineOptions.minDate;
          };

        $scope.toggleMin();

        $scope.open1 = function() {
            $scope.popup1.opened = true;
          };

        $scope.open2 = function() {
            $scope.popup2.opened = true;
          };

        $scope.setDate = function(year, month, day) {
            $scope.dt = new Date(year, month, day);
          };

        $scope.popup1 = {
        opened: false
        };

        $scope.popup2 = {
        opened: false
        };

        var tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        var afterTomorrow = new Date();
        afterTomorrow.setDate(tomorrow.getDate() + 1);
        $scope.events = [
        {
          date: tomorrow,
          status: 'full'
        },
        {
          date: afterTomorrow,
          status: 'partially'
        }
        ];

        function getDayClass(data) {
        var date = data.date,
          mode = data.mode;
        if (mode === 'day') {
          var dayToCheck = new Date(date).setHours(0,0,0,0);

          for (var i = 0; i < $scope.events.length; i++) {
            var currentDay = new Date($scope.events[i].date).setHours(0,0,0,0);

            if (dayToCheck === currentDay) {
              return $scope.events[i].status;
            }
          }
        }

        return '';
        }
});