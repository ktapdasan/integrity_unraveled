app.controller('admin_suspension', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        ngDialog,
                                        UINotification,
                                        SuspensionFactory,
                                        md5,
                                        $filter
                                    ){
    $scope.suspension = {};
    $scope.modal = {};
    $scope.filter= {};
    $scope.filter.status= 'Active';
    $scope.suspension.count = 0;

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];
            
            get_profile();
            suspension();
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
             suspension();
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

        $scope.filter.date_from = new Date(yyyy+'-'+mm+'-01'); //getMonday(new Date());
        $scope.filter.date_to = new Date();
        $scope.modal.date_from = new Date(yyyy+'-'+mm+'-'+dd);
        $scope.modal.date_to = new Date(yyyy+'-'+mm+'-'+dd);
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



    $scope.show_suspension = function(){
        suspension();
    }
   

    function suspension(){

        $scope.suspension.status = false;
        $scope.suspension.data= '';

        if ($scope.filter.status == 'Active')
            {
                $scope.filter.archived = 'false';  
            }
        else 
            {
                $scope.filter.archived = 'true';   
            }

      
        var promise = SuspensionFactory.get_suspension($scope.filter);
        promise.then(function(data){
            $scope.suspension.status = true;
            $scope.suspension.data = data.data.result;
            var count = data.data.result.length;

            if (count==0) {
                $scope.suspension.count="";
            }
            else{
                $scope.suspension.count= count;
            }
             

        })
        .then(null, function(data){
            $scope.suspension.status = false;
        });
    }




    $scope.add_suspension = function(k){
        $scope.modal.date_from = new Date();
        $scope.modal.date_to = new Date();
        $scope.modal.remarks = '';
        $scope.modal = {

            title : 'Add New Suspension',
            save : 'Add',
            close : 'Cancel',

           
        };


        ngDialog.openConfirm({
            template: 'SuspensionModal',
            className: 'ngdialog-theme-plain custom-widththreefifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;

                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want to add this suspension?</p>' +
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

            

            var time_from = new Date($scope.modal.time_from);
            var fromh = time_from.getHours();
            var fromm = time_from.getMinutes(); 

            if(fromh.length == 1){
                fromh = '0' + fromh;
            }
            if(fromm.length == 1){
                fromm = '0' + fromm;
            }
            


            var time_to = new Date($scope.modal.time_to);
            var toh = time_to.getHours();
            var tom = time_to.getMinutes();

            if(toh.length == 1){
                toh = '0' + toh;
            }
            if(tom.length == 1){
                tom = '0' + tom;
            }

            
            var date_from = new Date($scope.modal.date_from);
            var ddf = date_from.getDate();
            var mmf = date_from.getMonth()+1; //January is 0!
            var yyyyf = date_from.getFullYear();

            var date_to = new Date($scope.modal.date_to);
            var ddt = date_to.getDate();
            var mmt = date_to.getMonth()+1; //January is 0!
            var yyyyt = date_to.getFullYear();
           
            $scope.suspension.creator_pk = $scope.profile.pk;
            $scope.suspension.time_from = fromh + ':' + fromm ;
            $scope.suspension.time_to = toh + ':' + tom;
            $scope.suspension.date_from = yyyyf+'-'+mmf+'-'+ddf;
            $scope.suspension.date_to = yyyyt+'-'+mmt+'-'+ddt;
            $scope.suspension.remarks = $scope.modal.remarks;
           
            var promise = SuspensionFactory.save($scope.suspension);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully added new suspension', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                suspension();
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

    
    $scope.edit_suspension = function(k){
        $scope.modal.date_from = new Date();
        $scope.modal.date_to = new Date();
        $scope.modal.remarks = '';
        $scope.modal = {

            title : 'Edit Suspension',
            save : 'Save',
            close : 'Cancel',

           
        };


        ngDialog.openConfirm({
            template: 'SuspensionModal',
            className: 'ngdialog-theme-plain custom-widththreefifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;

                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want to edit this suspension?</p>' +
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

            

            var time_from = new Date($scope.modal.time_from);
            var fromh = time_from.getHours();
            var fromm = time_from.getMinutes(); 

            if(fromh.length == 1){
                fromh = '0' + fromh;
            }
            if(fromm.length == 1){
                fromm = '0' + fromm;
            }
            


            var time_to = new Date($scope.modal.time_to);
            var toh = time_to.getHours();
            var tom = time_to.getMinutes();

            if(toh.length == 1){
                toh = '0' + toh;
            }
            if(tom.length == 1){
                tom = '0' + tom;
            }

            
            var date_from = new Date($scope.modal.date_from);
            var ddf = date_from.getDate();
            var mmf = date_from.getMonth()+1; //January is 0!
            var yyyyf = date_from.getFullYear();

            var date_to = new Date($scope.modal.date_to);
            var ddt = date_to.getDate();
            var mmt = date_to.getMonth()+1; //January is 0!
            var yyyyt = date_to.getFullYear();
           
            $scope.suspension.pk = $scope.suspension.data[k].pk
            $scope.suspension.creator_pk = $scope.profile.pk;
            $scope.suspension.time_from = fromh + ':' + fromm ;
            $scope.suspension.time_to = toh + ':' + tom;
            $scope.suspension.date_from = yyyyf+'-'+mmf+'-'+ddf;
            $scope.suspension.date_to = yyyyt+'-'+mmt+'-'+ddt;
            $scope.suspension.remarks = $scope.modal.remarks;

            var promise = SuspensionFactory.edit_suspension($scope.suspension);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully edited suspension', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                suspension();
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
    

     $scope.delete_suspension = function(k){
       
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to delete this suspension?',
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

            $scope.suspension.pk = $scope.suspension.data[k].pk

            var promise = SuspensionFactory.delete_suspension($scope.suspension);
            promise.then(function(data){
                

                $scope.archived=true;
                UINotification.success({
                                        message: 'You have successfully deleted suspension', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                suspension();

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