app.controller('admin_Holidays', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        ngDialog,
                                        UINotification,
                                        HolidaysFactory,
                                        md5
                                    ){
    $scope.holiday = {};
    $scope.modal = {};
    $scope.holiday={};
    $scope.filter= {};
    $scope.filter.status= 'Active';

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];
            
            get_profile();
            holiday();
        });
    }

    function get_profile(){
        var filters = { 
            'pk' : $scope.pk
        };

        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){
            $scope.profile = data.data.result[0];

           
        })         
    } 



    $scope.show_holiday = function(){
        holiday();
    }
   

    function holiday(){

        $scope.holiday.status = false;
        $scope.holiday.data= '';

        if ($scope.filter.status == 'Active')
            {
                $scope.filter.archived = 'false';  
            }
        else 
            {
                $scope.filter.archived = 'true';   
            }

      
        var promise = HolidaysFactory.get_holiday($scope.filter);
        promise.then(function(data){
            $scope.holiday.status = true;
            $scope.holiday.data = data.data.result;
            var count = data.data.result.length;

            if (count==0) {
                $scope.holiday.count="";
            }
            else{
                $scope.holiday.count="Total: " + count;
            }
             

        })
        .then(null, function(data){
            $scope.holiday.status = false;
        });
    }




    $scope.add_holiday = function(k){
     
        $scope.modal = {

            title : 'Add New Holiday',
            save : 'Add',
            close : 'Cancel',

           
        };


        ngDialog.openConfirm({
            template: 'HolidayNewModal',
            className: 'ngdialog-theme-plain custom-widththreefifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;

                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want to add this Holiday?</p>' +
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

            $scope.holiday.creator_pk = $scope.profile.pk;
            $scope.holiday.holiday_name = $scope.modal.holiday_name;
            $scope.holiday.holiday_type = $scope.modal.holiday_type;

            var date = new Date($scope.modal.holiday_date);
            var dd = date.getDate();
            var mm = date.getMonth()+1; 
            var yyyy = date.getFullYear();

            $scope.holiday.new_date=yyyy +"-"+ mm +"-"+ dd;
           
           
            var promise = HolidaysFactory.save($scope.holiday);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully added new department', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                holiday();
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

    
    $scope.edit_holiday = function(k){
        
        
        $scope.modal = {

            title : 'Edit Holiday',
            save : 'Apply Changes',
            close : 'Cancel',
            name : $scope.holiday.data[k].name,
            datex : $scope.holiday.data[k].datex,
            archived : $scope.holiday.data[k].archived,
            pk: $scope.holiday.data[k].pk
        };

        ngDialog.openConfirm({
            template: 'EditHolidayModal',
            className: 'ngdialog-theme-plain custom-widththreefifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;

                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want to apply changes to this Holiday?</p>' +
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

            var promise = HolidaysFactory.update_holiday($scope.modal);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully applied changes to this hol.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                holiday();
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
    

     $scope.delete_holiday = function(k){
       
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to delete this holiday?',
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

            
            var promise = HolidaysFactory.delete_holiday($scope.holiday.data[k]);
            promise.then(function(data){
                

                $scope.archived=true;
                UINotification.success({
                                        message: 'You have successfully deleted department', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                holiday();

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


    $scope.restore_holiday = function(k){
       
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to restore this holiday?',
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

            
            var promise = HolidaysFactory.restore_holiday($scope.holiday.data[k]);
            promise.then(function(data){
                

                $scope.archived=true;
                UINotification.success({
                                        message: 'You have successfully restored holiday', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                holiday();

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


});