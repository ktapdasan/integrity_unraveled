
app.controller('Timesheet', function(
  										$scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        TimelogFactory,
                                        ngDialog,
                                        UINotification,
                                        CutoffFactory,
                                        WorkdaysFactory,
                                        LeaveFactory,
                                        md5
  									){

    $scope.profile = {};
    $scope.filter = {};
    $scope.timesheet = {};
    $scope.log = {};
    $scope.log.time_log = new Date;

    $scope.cutoff = {};

    $scope.modal = {};

    $scope.date_list = [];

    $scope.workdays = {};
    $scope.approved_leaves = [];

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

            $scope.profile.details = JSON.parse($scope.profile.details);
            $scope.profile.permission = JSON.parse($scope.profile.permission);
            $scope.profile.leave_balances = JSON.parse($scope.profile.leave_balances);

            get_approved_leaves();
            fetch_cutoff();
            workdays();
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

    function get_approved_leaves(){
        var filter = {
            employees_pk : $scope.profile.pk
        }

        var promise = LeaveFactory.approved_leaves(filter);
        promise.then(function(data){
            $scope.approved_leaves = data.data.result;
        })
    }

    function fetch_cutoff(){  
        var promise = CutoffFactory.fetch_dates();
        promise.then(function(data){
            var a = data.data.result[0];
            a.dates = JSON.parse(a.dates);
            
            var new_date = new Date();
            var dd = new_date.getDate();
            var mm = new_date.getMonth()+1; //January is 0!
            var yyyy = new_date.getFullYear();

            if(a.cutoff_types_pk == "2"){ //bimonthly
                var first = a.dates.first;
                var second = a.dates.second;
                
                if(dd >= parseInt(second.from)){
                    $scope.filter.datefrom = new Date(mm+"/"+second.from+"/"+yyyy);
                    $scope.filter.dateto = new Date(mm+"/"+second.to+"/"+yyyy);
                }
                else {
                    $scope.filter.datefrom = new Date(mm+"/"+first.from+"/"+yyyy);
                    $scope.filter.dateto = new Date(mm+"/"+first.to+"/"+yyyy);   
                }
            }
            else { //monthly
                $scope.filter.datefrom = new Date(mm+"/"+a.dates.from+"/"+yyyy);
                $scope.filter.dateto = new Date(mm+"/"+a.dates.to+"/"+yyyy);
            }

            //fetch_myemployees();
            timesheet();
        })
        .then(null, function(data){

            //timesheet();
        });
    }

    function getDates( d1, d2 ){
        var oneDay = 24*3600*1000;
        for (var d=[],ms=d1*1,last=d2*1;ms<=last;ms+=oneDay){
            d.push( new Date(ms) );
        }
        return d;
    }

    $scope.show_timesheet = function(){
        timesheet();
    }

    function timesheet(){
        var datefrom = new Date($scope.filter.datefrom);
        var dd = datefrom.getDate();
        var mm = datefrom.getMonth()+1; //January is 0!
        var yyyy = datefrom.getFullYear();

        var dateto = new Date($scope.filter.dateto);
        var Dd = dateto.getDate();
        var Mm = dateto.getMonth()+1; //January is 0!
        var Yyyy = dateto.getFullYear();

        $scope.filter.newdatefrom=yyyy+'-'+mm+'-'+dd;
        $scope.filter.newdateto=Yyyy+'-'+Mm+'-'+Dd;

        $scope.filter.pk = $scope.profile.pk;

        $scope.timesheet.data = [];
        var promise = TimelogFactory.timesheet($scope.filter);
        promise.then(function(data){
            $scope.timesheet.data = data.data.result;
            $scope.timesheet.status = true;
            
            var a = getDates( datefrom, dateto );
            
            var new_timesheet=[];
            for(var i in a){
                
                mm = a[i].getMonth()+1;
                date = a[i].getFullYear() +"-"+ mm +"-"+ a[i].getDate();

                var done = false;
                for(var j in $scope.timesheet.data){

                    var timesheet_date = new Date($scope.timesheet.data[j].log_date);
                    var dd = timesheet_date.getDate();
                    var mm = timesheet_date.getMonth()+1; //January is 0!
                    var yyyy = timesheet_date.getFullYear();
                    var date1 = yyyy +"-"+ mm +"-"+ dd;

                    var Dd = a[i].getDate();
                    var Mm = a[i].getMonth()+1; //January is 0!
                    var Yyyy = a[i].getFullYear();
                    var date2 = Yyyy +"-"+ Mm +"-"+ Dd;

                    if(date1 == date2){
                        var day_checked = check_day($scope.timesheet.data[j]);

                        if(contains(['Regular','Rest Day'], day_checked)){
                            if(day_checked == "Rest Day"){
                                $scope.timesheet.data[j].login = '';
                                $scope.timesheet.data[j].logout = '';
                                $scope.timesheet.data[j].hrs = '';  
                            }
                        }
                        else {  
                            if($scope.profile.details.company.work_schedule[$scope.timesheet.data[j].log_day.toLowerCase()]){
                                $scope.timesheet.data[j].login = $scope.profile.details.company.work_schedule[$scope.timesheet.data[j].log_day.toLowerCase()]['in'];
                                $scope.timesheet.data[j].logout = $scope.profile.details.company.work_schedule[$scope.timesheet.data[j].log_day.toLowerCase()]['out'];    
                                $scope.timesheet.data[j].hrs = "9";
                            }
                            else {
                                $scope.timesheet.data[j].login = '';
                                $scope.timesheet.data[j].logout = '';    
                                $scope.timesheet.data[j].hrs = '';   
                            }
                        }

                        new_timesheet.push({
                            employee: $scope.timesheet.data[j].employee,
                            employee_id : $scope.timesheet.data[j].employee_id,
                            employees_pk : $scope.timesheet.data[j].employees_pk,
                            hrs : $scope.timesheet.data[j].hrs,
                            log_date : $scope.timesheet.data[j].log_date,
                            log_day : $scope.timesheet.data[j].log_day,
                            login : $scope.timesheet.data[j].login,
                            logout : $scope.timesheet.data[j].logout,
                            status : day_checked
                        });
                        done = true;
                    }
                }

                if(done == false){
                    var z = date.split('-');

                    if(z[1].length < 2){
                        z[1] = "0" + z[1];
                    }

                    if(z[2].length < 2){
                        z[2] = "0" + z[2];
                    }

                    date = z.join('-');

                    var data = {
                        log_date : date,
                        log_day : dayofweek(a[i].getDay())
                    };

                    var day_checked = check_day(data);

                    var login, logout, hrs;
                    if(contains(['Regular','Rest Day'], day_checked)){
                        login = "None";
                        logout = "None";
                        hrs = "N/A";

                        if(day_checked == "Rest Day"){
                            login = '';
                            logout = '';
                            hrs = '';
                        }
                    }
                    else {
                        login = $scope.profile.details.company.work_schedule[dayofweek(a[i].getDay()).toLowerCase()]['in'];
                        logout = $scope.profile.details.company.work_schedule[dayofweek(a[i].getDay()).toLowerCase()]['out'];
                        hrs = "9";
                    }
                    
                    new_timesheet.push({
                            employee: "",
                            employee_id : "",
                            employees_pk : "",
                            hrs : hrs,
                            log_date : date,
                            log_day : dayofweek(a[i].getDay()),
                            login : login,
                            logout : logout,
                            status : day_checked
                        });
                }
            }
            
            $scope.timesheet.data = new_timesheet;
        })  
        .then(null, function(data){

            //$scope.timesheet.status = false;
            var a = getDates( datefrom, dateto );
            
            var new_timesheet=[];
            for(var i in a){
                mm = a[i].getMonth()+1;
                date = a[i].getFullYear() +"-"+ mm +"-"+ a[i].getDate();

                var z = date.split('-');

                if(z[1].length < 2){
                    z[1] = "0" + z[1];
                }

                if(z[2].length < 2){
                    z[2] = "0" + z[2];
                }

                date = z.join('-');

                var data = {
                    log_date : date,
                    log_day : dayofweek(a[i].getDay())
                };

                var day_checked = check_day(data);
                //console.log(day_checked);
                var login, logout, hrs;
                if(contains(['Regular','Rest Day'], day_checked)){
                    login = "None";
                    logout = "None";
                    hrs = "N/A";

                    if(day_checked == "Rest Day"){
                        login = '';
                        logout = '';
                        hrs = '';
                    }
                }
                else {
                    login = $scope.profile.details.company.work_schedule[dayofweek(a[i].getDay()).toLowerCase()]['in'];
                    logout = $scope.profile.details.company.work_schedule[dayofweek(a[i].getDay()).toLowerCase()]['out'];
                    hrs = "9";
                }

                new_timesheet.push({
                                employee: "",
                                employee_id : "",
                                employees_pk : "",
                                hrs : hrs,
                                log_date : date,
                                log_day : dayofweek(a[i].getDay()),
                                login : login,
                                logout : logout,
                                status : day_checked
                            });
            }            
            
            $scope.timesheet.data = new_timesheet;
        });
    }

    function check_day(data){
        var status;
        if($scope.workdays[data.log_day.trim().toLowerCase()] == true){
            status = "Regular";
        }
        else {
            status = "Rest Day";
        }

        for(var i in $scope.approved_leaves){
            if(data.log_date >= $scope.approved_leaves[i].date_started && data.log_date <= $scope.approved_leaves[i].date_ended){
                status = $scope.approved_leaves[i].name;
            }
        }

        return status;
    }

    function dayofweek(num){
        var day = "";
        if(num == 1){
            day = 'Monday';
        }
        else if(num == 2){
            day = 'Tuesday';
        }
        else if(num == 3){
            day = 'Wednesday';
        }
        else if(num == 4){
            day = 'Thursday';
        }
        else if(num == 5){
            day = 'Friday';
        }
        else if(num == 6){
            day = 'Saturday';
        }
        else if(num == 0){
            day = 'Sunday';
        }
        return day;
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
        var datefrom = new Date($scope.filter.datefrom);
        var dd = datefrom.getDate();
        var mm = datefrom.getMonth()+1; //January is 0!
        var yyyy = datefrom.getFullYear();

        var dateto = new Date($scope.filter.dateto);
        var Dd = dateto.getDate();
        var Mm = dateto.getMonth()+1; //January is 0!
        var Yyyy = dateto.getFullYear();

        $scope.filter.newdatefrom=yyyy+'-'+mm+'-'+dd;
        $scope.filter.newdateto=Yyyy+'-'+Mm+'-'+Dd;

        window.open('./FUNCTIONS/Timelog/timesheet_export.php?pk='+$scope.filter.pk+'&newdatefrom='+$scope.filter.newdatefrom+"&newdateto="+$scope.filter.newdateto);
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
        
    // $scope.add_manual_logs = function(k){
    //     $scope.log.reason = '';
    //     $scope.log.time_log = new Date;

    //     $scope.log.date_log = $scope.timesheet.data[key].log_date;
    //     $scope.log.selectedTimeAsString;
    //     //$scope.employee = $scope.timesheet.data[key];
    //     $scope.modal = {

    //         title : 'Manual Log ' + type,
    //         save : 'Submit',
    //         close : 'Cancel',
           
    //     };

    //     ngDialog.openConfirm({
    //         template: 'ManualLogModal',
    //         className: 'ngdialog-theme-plain custom-widththreefifty',
    //         preCloseCallback: function(value) {
    //             var nestedConfirmDialog;                
    //                 nestedConfirmDialog = ngDialog.openConfirm({
    //                     template:
    //                             '<p></p>' +
    //                             '<p>Are you sure you want to apply changes to this employee account?</p>' +
    //                             '<div class="ngdialog-buttons">' +
    //                                 '<button type="button" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">No' +
    //                                 '<button type="button" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">Yes' +
    //                             '</button></div>',
    //                     plain: true,
    //                     className: 'ngdialog-theme-plain custom-widththreefifty'
    //                 });

    //             return nestedConfirmDialog;
    //         },
    //         scope: $scope,
    //         showClose: false
    //     })
    //     .then(function(value){
    //         return false;
    //     }, function(value){
    //         var a = new Date($scope.log.time_log);
    //         var H = a.getHours();
    //         var M = a.getMinutes(); 

    //         $scope.log["employees_pk"] = $scope.profile.pk;
    //         $scope.log["supervisor_pk"] = $scope.profile.supervisor_pk;
    //         $scope.log.time_log = H + ":" +M ;
    //         $scope.log.type = type;

        
    //         var promise = TimelogFactory.save_manual_log($scope.log);
    //         promise.then(function(data){

    //             UINotification.success({
    //                                     message: 'You have successfully filed manual log', 
    //                                     title: 'SUCCESS', 
    //                                     delay : 5000,
    //                                     positionY: 'top', positionX: 'right'

    //                                 });
            
    //         })
    //         .then(null, function(data){
                
    //             UINotification.error({
    //                                     message: 'An error occured, unable to file manual log, please try again.', 
    //                                     title: 'ERROR', 
    //                                     delay : 5000,
    //                                     positionY: 'top', positionX: 'right'
    //                                 });
    //         });  

            
    //     }); 
    // }

// <<<<<<< Updated upstream
//     $scope.show_approve = function(k){
//         $scope.manual_logs["employees_pk"] = $scope.profile.pk;
//        $scope.modal = {
//                 title : '',
//                 message: 'Are you sure you want to approve manual log?',
//                 save : 'Yes',
//                 close : 'Cancel'

//             };
//         ngDialog.openConfirm({
//             template: 'ConfirmModal',
//             className: 'ngdialog-theme-plain',
            
//             scope: $scope,
//             showClose: false
//         })
        
//         .then(function(value){
//             return false;
//         }, function(value){

//             $scope.manual_logs.status = "Approved";
//             $scope.manual_logs.pk =  $scope.manual_logs.data[k].pk;
// =======
    


// >>>>>>> Stashed changes


    // $scope.show_disapprove = function(k){
    //     $scope.manual_logs["employees_pk"] = $scope.profile.pk; 
    //    $scope.modal = {
    //             title : '',
    //             message: 'Are you sure you want to disapprove manual log?',
    //             save : 'Yes',
    //             close : 'Cancel'

    //         };
    //     ngDialog.openConfirm({
    //         template: 'ConfirmModal',
    //         className: 'ngdialog-theme-plain',
            
    //         scope: $scope,
    //         showClose: false
    //     })
        
    //     .then(function(value){
    //         return false;
    //     }, function(value){

    //         $scope.manual_logs.status = "Disapproved";
    //         $scope.manual_logs.pk =  $scope.manual_logs.data[k].pk;

            
    //         var promise = TimelogFactory.disapprove($scope.manual_logs);
    //         promise.then(function(data){
            
           

    //             UINotification.success({
    //                                     message: 'You have successfully diapproved manual log', 
    //                                     title: 'SUCCESS', 
    //                                     delay : 5000,
    //                                     positionY: 'top', positionX: 'right'
    //                                 });  
    //             timesheet();
                     

    //         })
    //         .then(null, function(data){
                
    //             UINotification.error({
    //                                     message: 'An error occured, unable to disapprove, please try again.', 
    //                                     title: 'ERROR', 
    //                                     delay : 5000,
    //                                     positionY: 'top', positionX: 'right'
    //                                 });
    //         });                                  
    //     });
    // }

    $scope.open_manual_log = function(type, key){
        $scope.log.reason = '';
        $scope.log.time_log = new Date;

        $scope.log.date_log = $scope.timesheet.data[key].log_date;
        $scope.log.selectedTimeAsString;
        //$scope.employee = $scope.timesheet.data[key];
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
            $scope.log.time_log = H + ":" + M ;
            $scope.log.type = type;


            

        
            var promise = TimelogFactory.save_manual_log($scope.log);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully filed manual log', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'

                                    });

            if($scope.log.type=="In"){
                $scope.timesheet.data[key].login="Pending";
            }else{
                 $scope.timesheet.data[key].logout="Pending";
            }

            
            
            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to file manual log, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });

               if($scope.log.type=="In"){
                $scope.timesheet.data[key].login="Pending";
            }else{
                 $scope.timesheet.data[key].logout="Pending";
            }
            });  

            
        }); 
    }

    function workdays(){
        var a = $scope.profile.details.company.work_schedule;
        
        for(var i in a){
            if(a[i]){
                $scope.workdays[i] = true;
                // if(i == "monday"){
                //     $scope.workdays.push(1);
                // }
                // else if(i == "tuesday"){
                //     $scope.workdays.push(2);
                // }
                // else if(i == "wednesday"){
                //     $scope.workdays.push(3);
                // }
                // else if(i == "thursday"){
                //     $scope.workdays.push(4);
                // }
                // else if(i == "friday"){
                //     $scope.workdays.push(5);
                // }
                // else if(i == "saturday"){
                //     $scope.workdays.push(6);
                // }
                // else if(i == "sunday"){
                //     $scope.workdays.push(0);
                // }
            }
            else {
                $scope.workdays[i] = false;
            }

        }

        // var promise = WorkdaysFactory.get_work_days();
        // promise.then(function(data){
        //     var a = data.data.result[0];
        //     console.log(a);            
        //     $scope.workdays = JSON.parse(a.details);
        // })
    }
    
});