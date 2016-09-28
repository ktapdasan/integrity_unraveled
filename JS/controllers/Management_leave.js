app.controller('Management_leave', function(
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

    $scope.leaves_filed = {};
    $scope.cancellation_leave = {};
    $scope.leaves_filed.count = 0;
    $scope.cancellation_leave.count =0;
    $scope.workdays = [];

    $scope.myemployees={};

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            leavetypes();
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
            DEFAULTDATES();
            cancellation_leave();
            fetch_myemployees();
            leaves_filed();
            
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

        $scope.filter.date_from = new Date(yyyy+'-'+mm+'-01'); 
        $scope.filter.date_to = new Date();

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
        
        var promise = LeaveFactory.get_leave_types($scope.filter);
        promise.then(function(data){
            var a = data.data.result;
            $scope.leave_types=[];
            for(var i in a){
                $scope.leave_types.push({
                                            pk: a[i].pk,
                                            name: a[i].name,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            $scope.leave_types.status = false;
        });
    }

    $scope.leaves_filed = function(){
        leaves_filed();        
    }

    function leaves_filed() {
        var filter = {};
        filter.archived = $scope.filter.archived;
        filter.employees_pk = $scope.filter.employees_pk;
        filter.status = $scope.filter.status;
        filter.supervisor_pk = $scope.profile.pk;
        filter.duration = $scope.filter.duration;
        filter.category = $scope.filter.category;

        var from_date = new Date($scope.filter.date_from);
        var fromd = from_date.getDate();
        var fromm = from_date.getMonth()+1; //January is 0!
        var fromy = from_date.getFullYear();

        var to_date = new Date($scope.filter.date_to);
        var tod = to_date.getDate();
        var tom = to_date.getMonth()+1; //January is 0!
        var toy = to_date.getFullYear();

        filter.date_from = fromy +"-"+ fromm +"-"+ fromd;
        filter.date_to = toy +"-"+ tom +"-"+ tod;

        filter.employees_pk = null;
        if($scope.filter.myemployees && $scope.filter.myemployees[0]){
            filter.employees_pk = $scope.filter.myemployees[0].pk
        }

        filter.leave_types_pk = null;
        if($scope.filter.leave_type && $scope.filter.leave_type[0]){
            filter.leave_types_pk = $scope.filter.leave_type[0].pk
        }
        
        var promise = LeaveFactory.employees_leaves_filed(filter);
        promise.then(function(data){
            $scope.leaves_filed.status = true;
            $scope.leaves_filed.data = data.data.result;
            $scope.leaves_filed.count = data.data.result.length;
        })
        .then(null, function(data){
            $scope.leaves_filed.status = false;
        }); 
    }

    function countCertainDays( days, d0, d1 ) {
        var ndays = 1 + Math.round((d1-d0)/(24*3600*1000));
        var sum = function(a,b) {
            return a + Math.floor( ( ndays + (d0.getDay()+6-b) % 7 ) / 7 ); 
        };

        return days.reduce(sum,0);
    }

    // $scope.respond = function(k, type){
    //     check_filed_leave(k);
        
    //     $scope.leaves_filed["employees_pk"] = $scope.profile.pk;
    //     $scope.modal = {
    //             title : '',
    //             message: 'Are you sure you want to '+type+' this leave?',
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
    //         var workdays = countCertainDays([1,2,3,4,5],new Date($scope.leaves_filed.data[k].date_started),new Date($scope.leaves_filed.data[k].date_ended)); //CODE_0001
            
    //         var leaves_filed = {
    //             pk              : $scope.leaves_filed.data[k].pk,
    //             employees_pk    : $scope.leaves_filed.data[k].employees_pk,
    //             duration        : $scope.leaves_filed.data[k].duration,
    //             category        : $scope.leaves_filed.data[k].category,
    //             leave_types_pk  : $scope.leaves_filed.data[k].leave_types_pk,
    //             created_by      : $scope.profile.pk,
    //             workdays        : workdays
    //         };

    //         if(type == "approve"){
    //             leaves_filed.status = 'Approved';
    //         }
    //         else {
    //             leaves_filed.status = 'Disapproved';
    //         }
            
    //         var promise = LeaveFactory.leave_respond(leaves_filed);
    //         promise.then(function(data){
    //             UINotification.success({
    //                                     message: 'You have successfully approved filed leave.', 
    //                                     title: 'SUCCESS', 
    //                                     delay : 5000,
    //                                     positionY: 'top', positionX: 'right'
    //                                 });
    //             leaves_filed();
    //         })
    //         .then(null, function(data){
    //             UINotification.error({
    //                                     message: 'An error occured, unable to approve, please try again.', 
    //                                     title: 'ERROR', 
    //                                     delay : 5000,
    //                                     positionY: 'top', positionX: 'right'
    //                                 });
    //         });                                  
    //     });
    // }

    function get_day_num(day){
        var num;
        if(day == "sunday"){
            num = 0;
        }
        else if(day == "monday"){
            num = 1;
        }
        else if(day == "tuesday"){
            num = 2;
        }
        else if(day == "wednesday"){
            num = 3;
        }
        else if(day == "thursday"){
            num = 4;
        }
        else if(day == "friday"){
            num = 5;
        }
        else if(day == "saturday"){
            num = 6;
        }
        return num;
    }

    $scope.respond = function(k, type){
        var a = JSON.parse($scope.leaves_filed.data[k].work_schedule);

        var work_schedule=[];
        for(var i in a){
            if(a[i] != null){
                work_schedule.push(get_day_num(i));
            }
        }

        if(type == "approve"){
            check_filed_leave(k);
            
            $scope.leaves_filed["employees_pk"] = $scope.profile.pk;
            $scope.modal = {
                    title : '',
                    message: 'Are you sure you want to '+type+' this leave?',
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
                var workdays = countCertainDays(work_schedule,new Date($scope.leaves_filed.data[k].date_started),new Date($scope.leaves_filed.data[k].date_ended)); //CODE_0001
                 
                var leaves_filed = {
                    pk              : $scope.leaves_filed.data[k].pk,
                    employees_pk    : $scope.leaves_filed.data[k].employees_pk,
                    duration        : $scope.leaves_filed.data[k].duration,
                    category        : $scope.leaves_filed.data[k].category,
                    leave_types_pk  : $scope.leaves_filed.data[k].leave_types_pk,
                    created_by      : $scope.profile.pk,
                    workdays        : workdays
                };

                leaves_filed.status = 'Approved';
                
                var promise = LeaveFactory.leave_respond(leaves_filed);
                promise.then(function(data){
                    UINotification.success({
                                            message: 'You have successfully approved filed leave.', 
                                            title: 'SUCCESS', 
                                            delay : 5000,
                                            positionY: 'top', positionX: 'right'
                                        });
                    //leaves_filed();
                  
                    $scope.leaves_filed.data[k].status = leaves_filed.status;
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
        else {

                check_filed_leave(k);
            
                $scope.leaves_filed["employees_pk"] = $scope.profile.pk;
                $scope.modal = {
                    title : '',
                    message: 'Are you sure you want to '+type+' this leave?',
                    save : 'Disapprove',
                    close : 'Cancel'
                };

                ngDialog.openConfirm({
                template: 'DisapprovedModal',
                className: 'ngdialog-theme-plain',
                
                    scope: $scope,
                    showClose: false
                })

                    .then(function(value){
                    return false;
                }, function(value){
                    var workdays = countCertainDays(work_schedule,new Date($scope.leaves_filed.data[k].date_started),new Date($scope.leaves_filed.data[k].date_ended)); //CODE_0001
                    
                    var leaves_filed = {
                        pk              : $scope.leaves_filed.data[k].pk,
                        employees_pk    : $scope.leaves_filed.data[k].employees_pk,
                        duration        : $scope.leaves_filed.data[k].duration,
                        category        : $scope.leaves_filed.data[k].category,
                        leave_types_pk  : $scope.leaves_filed.data[k].leave_types_pk,
                        created_by      : $scope.profile.pk,
                        workdays        : workdays
                    };

                leaves_filed.status = 'Disapproved';
                leaves_filed.remarks=$scope.modal.remarks;

            
                var promise = LeaveFactory.leave_respond(leaves_filed);
                promise.then(function(data){
                    UINotification.success({
                                            message: 'You have successfully approved filed leave.', 
                                            title: 'SUCCESS', 
                                            delay : 5000,
                                            positionY: 'top', positionX: 'right'
                                        });
                    //leaves_filed();
                    $scope.leaves_filed.data[k].status = leaves_filed.status;
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
    }

    function check_filed_leave(k){
        var filter = {
            pk : $scope.leaves_filed.data[k].pk
        };

        var promise = LeaveFactory.get_filed_leave(filter);
        promise.then(function(data){
            var a = data.data.result[0];
            
            if(a.archived == 't'){
                UINotification.error({
                                        message: 'Apologies. An error occurred because the request has already been deleted by ' + a.name, 
                                        title: 'ERROR', 
                                        delay : 10000,
                                        positionY: 'top', positionX: 'right'
                                    });

                $scope.leaves_filed.data[k].status = a.status;   

                $scope.leaves_filed.data.splice(k, 1);
                return false;
            }
        })
    }

    function fetch_myemployees(){
        var filter  = {
            pk : $scope.profile.pk
        }
        
        $scope.myemployees=[];
        var promise = EmployeesFactory.get_myemployees(filter);
        promise.then(function(data){
            var a = data.data.result;
            $scope.myemployees=[];
            for(var i in a){
                $scope.myemployees.push({
                                            pk: a[i].employees_pk,
                                            name: a[i].name,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            $scope.myemployees = [];
        });
    }

    $scope.cancellation_leave = function(){
        cancellation_leave();        
    }

    function cancellation_leave() {
        
         var filters = { 
            'employees_pk' : $scope.profile.pk
        };
       
       
        
        var promise = LeaveFactory.cancellation_leave(filters);
        promise.then(function(data){
            $scope.cancellation_leave.status = true;
            $scope.cancellation_leave.data = data.data.result;
            $scope.cancellation_leave.count = data.data.result.length;
           
        })
        .then(null, function(data){
            $scope.cancellation_leave.status = false;
        }); 
    }

    $scope.cancel_respond = function(k, type){
        
        if(type == "approve"){
           
            $scope.modal = {
                    title : '',
                    message: 'Are you sure you want to '+type+' this cancellation of leave?',
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
                
                var cancellation_leave = {
                    
                    pk          : $scope.cancellation_leave.data[k].pk,
                    created_by  : $scope.profile.pk,
                    remarks     : "Approved",
                    employees_pk: $scope.cancellation_leave.data[k].employees_pk,
                    status      : 'Approved'
                };
                
                var promise = LeaveFactory.cancellation_respond(cancellation_leave);
                promise.then(function(data){
                    UINotification.success({
                                            message: 'You have successfully approved filed leave.', 
                                            title: 'SUCCESS', 
                                            delay : 5000,
                                            positionY: 'top', positionX: 'right'
                                        });
                    //leaves_filed();
                  
                    $scope.cancellation_leave.data[k].status = cancellation_leave.status;
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
        else {

               
                $scope.modal = {
                    title : '',
                    message: 'Are you sure you want to '+type+' cancellation of leave?',
                    save : 'Disapprove',
                    close : 'Cancel'
                };

                ngDialog.openConfirm({
                template: 'DisapprovedModal',
                className: 'ngdialog-theme-plain',
                
                    scope: $scope,
                    showClose: false
                })

                    .then(function(value){
                    return false;
                }, function(value){
                    
                    var cancellation_leave = {
                    
                        pk          : $scope.cancellation_leave.data[k].pk,
                        created_by  : $scope.profile.pk,
                        remarks     : $scope.modal.remarks,
                        employees_pk: $scope.cancellation_leave.data[k].employees_pk,
                        status      : 'Disapproved'
                };


                var promise = LeaveFactory.cancellation_respond(cancellation_leave);
                promise.then(function(data){
                    UINotification.success({
                                            message: 'You have successfully approved filed leave.', 
                                            title: 'SUCCESS', 
                                            delay : 5000,
                                            positionY: 'top', positionX: 'right'
                                        });
                    //leaves_filed();
                    $scope.cancellation_leave.data[k].status = cancellation_leave.status;
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
    }


});