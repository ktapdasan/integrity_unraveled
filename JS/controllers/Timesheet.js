
app.controller('Timesheet', function(
  										$scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        TimelogFactory,
                                        ngDialog,
                                        UINotification,
                                        CutoffFactory,
                                        md5
  									){

    $scope.profile = {};
    $scope.filter = {};
    $scope.timesheet_data = [];
    $scope.log = {};
    $scope.log.time_log = new Date;

    $scope.cutoff = {};

    $scope.modal = {};


    init();

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

    function get_profile(){
        var filters = { 
            'pk' : $scope.pk
        };
        
        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){
            $scope.profile = data.data.result[0];
            DEFAULTDATES();
            fetch_myemployees();
            timesheet();
        })   
    } 
    function fetch_myemployees(){
       $scope.filter.pk = $scope.profile.pk;
        var promise = TimelogFactory.get_myemployees($scope.filter);
        promise.then(function(data){
        
            var a = data.data.result;
            $scope.myemployees=[];
            for(var i in a){
                $scope.myemployees.push({
                                            pk: a[i].pk,
                                            name: a[i].myemployees,
                                            ticked: false
                                        });
            }
           
        })
        

        .then(null, function(data){
            
        });
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

        $scope.filter.datefrom = new Date(yyyy+'-'+mm+'-01'); //getMonday(new Date());
        $scope.filter.dateto = new Date();

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

    // function fetch_cutoff(){  
    //     var promise = CutoffFactory.fetch_dates();
    //     promise.then(function(data){
    //         $scope.cutoff.data = data.data.result[0];
    //         $scope.cutoff.data.dates = JSON.parse($scope.cutoff.data.dates);
    //         console.log($scope.cutoff.data);

    //         var new_date = new Date();
    //         var dd = new_date.getDate();
    //         var mm = new_date.getMonth()+1; //January is 0!
    //         var yyyy = new_date.getFullYear();

    //         if($scope.cutoff.data.cutoff_types_pk == "1"){
    //             // if(){
                
    //             // }
    //             // $scope.filter.datefrom = yyyy+'-'+mm+'-'+
    //         }
    //         else {
    //             if(dd > parseInt($scope.cutoff.data.dates.first.from) && dd < parseInt($scope.cutoff.data.dates.first.from)){
    //                 console.log($scope.cutoff.data.dates.first);
    //                 $scope.filter.datefrom = yyyy+'-'+mm+'-'+parseInt($scope.cutoff.data.dates.first.from);
    //                 $scope.filter.dateto = yyyy+'-'+mm+'-'+parseInt($scope.cutoff.data.dates.first.to);
    //             }
    //             else {
    //                 $scope.filter.datefrom = yyyy+'-'+mm+'-'+parseInt($scope.cutoff.data.dates.second.from);
    //                 $scope.filter.dateto = yyyy+'-'+mm+'-'+parseInt($scope.cutoff.data.dates.second.to);
    //             }
    //         }
         
    //         timesheet();
    //     })
    //     .then(null, function(data){

    //         timesheet();
    //     });
    // }

    $scope.show_timesheet = function(){
        timesheet();
    }

    function timesheet(){


        var datefrom = new Date($scope.filter.datefrom);
        var dd = datefrom.getDate();
        var mm = datefrom.getMonth()+1; //January is 0!
        var yyyy = datefrom.getFullYear();

        $scope.filter.newdatefrom=yyyy+'-'+mm+'-01';

        var dateto = new Date($scope.filter.dateto);
        var Dd = dateto.getDate();
        var Mm = dateto.getMonth()+1; //January is 0!
        var Yyyy = dateto.getFullYear();

        $scope.filter.newdateto=Yyyy+'-'+Mm+'-'+Dd;

        $scope.filter.pk = $scope.profile.pk;

        var promise = TimelogFactory.timesheet($scope.filter);
        promise.then(function(data){
            $scope.timesheet_data = data.data.result;
            $scope.timesheet_data.status = true;

        })  
        .then(null, function(data){
            $scope.timesheet_data.status = false;
            
        });

       


    }

    $scope.show_myemployees = function(){
        myemployees();    
    }

    function myemployees() {
        $scope.manual_logs.status = false;
        $scope.manual_logs.data= {};
        
    
        var promise = TimelogFactory.myemployees($scope.filter);
        promise.then(function(data){
            $scope.manual_logs.data = data.data.result;
            $scope.manual_logs.status = true;
        }) 
        .then(null, function(data){
            $scope.manual_logs.status = false;
        });
    
    }


    $scope.export_timesheet = function(){
        window.open('./FUNCTIONS/Timelog/timesheet_export.php?pk='+$scope.filter.pk+'&datefrom='+$scope.filter.datefrom+"&dateto="+$scope.filter.dateto);
    }

    $scope.savelog = function(k){
       
        $scope.modal = {
                        title : '',
                        message: 'Are you sure you want to deactivate this employee?',
                        save : 'Deactivate',
                        close : 'Cancel'
                    };
       
        ngDialog.openConfirm({
            template: 'ConfirmLogModal',
            className: 'ngdialog-theme-plain',
            
            scope: $scope,
            showClose: false
        })

        
        .then(function(value){
            return false;
        }, function(value){
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
        
    $scope.add_manual_logs = function(k){
        $scope.log.reason = '';
        $scope.log.time_log = new Date;

        $scope.log.date_log = $scope.timesheet_data[key].log_date;
        $scope.log.selectedTimeAsString;
        //$scope.employee = $scope.timesheet_data[key];
        $scope.modal = {

            title : 'Manual Log ' + type,
            save : 'Submit',
            close : 'Cancel',
           
        };

        ngDialog.openConfirm({
            template: 'ManualLogModal',
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
            var a = new Date($scope.log.time_log);
            var H = a.getHours();
            var M = a.getMinutes(); 

            $scope.log["employees_pk"] = $scope.profile.pk;
            $scope.log["supervisor_pk"] = $scope.profile.supervisor_pk;
            $scope.log.time_log = H + ":" +M ;
            $scope.log.type = type;

        
            var promise = TimelogFactory.save_manual_log($scope.log);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully filed manual log', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'

                                    });
            
            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to file manual log, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });  

            
        }); 
    }

    


    $scope.show_approve = function(k){
        $scope.manual_logs["employees_pk"] = $scope.profile.pk;
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to approve manual log?',
                save : 'Yes',
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

            $scope.manual_logs.status = "Approved";
            $scope.manual_logs.pk =  $scope.manual_logs.data[k].pk;

            
            var promise = TimelogFactory.approve($scope.manual_logs);
            promise.then(function(data){
            
           

                UINotification.success({
                                        message: 'You have successfully approve manual log', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });  
                manual_logs();
                       

            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to approve, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });                                  
        });
    }

    $scope.show_disapprove = function(k){
        $scope.manual_logs["employees_pk"] = $scope.profile.pk; 
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to disapprove manual log?',
                save : 'Yes',
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

            $scope.manual_logs.status = "Disapproved";
            $scope.manual_logs.pk =  $scope.manual_logs.data[k].pk;

            
            var promise = TimelogFactory.disapprove($scope.manual_logs);
            promise.then(function(data){
            
           

                UINotification.success({
                                        message: 'You have successfully diapproved manual log', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });  
                manual_logs();
                     

            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to disapprove, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });                                  
        });
    }

    $scope.open_manual_log = function(type, key){
        $scope.log.reason = '';
        $scope.log.time_log = new Date;

        $scope.log.date_log = $scope.timesheet_data[key].log_date;
        $scope.log.selectedTimeAsString;
        //$scope.employee = $scope.timesheet_data[key];
        $scope.modal = {

            title : 'Manual Log ' + type,
            save : 'Submit',
            close : 'Cancel',
           
        };

        ngDialog.openConfirm({
            template: 'ManualLogModal',
            className: 'ngdialog-theme-plain custom-widththreefifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Apply Manual Log?</p>' +
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
            var a = new Date($scope.log.time_log);
            var Y = a.getFullYear();
            var month = a.getMonth();
            var day = a.getDay();
            var H = a.getHours();
            var M = a.getMinutes(); 

            $scope.log["employees_pk"] = $scope.profile.pk;
            $scope.log["supervisor_pk"] = $scope.profile.supervisor_pk;
            $scope.log.time_log = Y + "-" + month + "-" + day + " " + H + ":" + M ;
            $scope.log.type = type;

            
        
            var promise = TimelogFactory.save_manual_log($scope.log);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully filed manual log', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'

                                    });
                manual_logs();
            
            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to file manual log, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });  

            
        }); 
    }
    
});