app.controller('Dashboard', function(
  										$scope,
                                        SessionFactory,
                                        TimelogFactory,
                                        EmployeesFactory,
                                        NotificationsFactory,
                                        LeaveFactory,
                                        md5,
                                        $timeout,
                                        ngDialog,
                                        UINotification
  									){


    $scope.switcher = {};
    $scope.switcher.main = "";

    $scope.profile = {};
    $scope.greetings = "Good Morning";
    $scope.logtype = "login";
    $scope.lastlog = {};
    $scope.logbutton = false;
    $scope.overtime = false;

    $scope.pk={};
    //$scope.notification = {};
    $scope.filter = {};
    $scope.result;
    $scope.font;
    $scope.read={};
    $scope.headerBackground="stop";

    $scope.current_date={};

    $scope.approved_leaves = {};

    $scope.buttons = {
        login:true,
        loginhover:false,
        logout:true,
        logouthover:false
    };

    

    init();
    //get_notifs();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            get_profile();
            set_greetings();
        })
        .then(null, function(data){
            window.location = './login.html';
        });
    }

    $scope.toggle_switcher = function(){
        if($scope.switcher.main == ""){
            $scope.switcher.main = "open";
            $scope.switcher.content = true;
        }
        else {
            $scope.switcher.main = "";   
            $scope.switcher.content = false;
        }
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
            //console.log($scope.profile);
            get_last_log_today();
            get_current_date();
            get_approved_leaves();
        })   
    }

    function get_current_date(){
        var promise = TimelogFactory.get_current_date();
        promise.then(function(data){
            $scope.current_date = data.data;
        });
    }

    function set_greetings(){
        var date = moment(new Date());

        var hour = date.format('HH');
        if(parseInt(hour) >= 12 && parseInt(hour) < 18){
            $scope.greetings = "Good Afternoon";
        }
        else if(parseInt(hour) >= 18 && parseInt(hour) <= 23){
            $scope.greetings = "Good Evening";   
        }
    }

    function get_last_log(){
        var filter = { 'pk' : $scope.profile.pk };
        var promise = TimelogFactory.last_log(filter);
        promise.then(function(data){
            var log = data.data.result[0];

            var date = moment(new Date(log.date));

            $scope.lastlog.date = log.date + " " + log.time;
            if(log.type == 'In'){
                $scope.logtype = "logout";

                $scope.lastlog.message = "Your last log in was on " + date.format('dddd, MMMM Do YYYY') + " " + log.time;
            }
            else {
                $scope.logtype = "login";

                $scope.lastlog.message = "Your last log out was on " + date.format('dddd, MMMM Do YYYY') + " " + log.time;
            }

        })
        .then(null, function(data){
            $scope.logtype = "login";
        });
    }

    function get_last_log_today(){
        var filter = { 'pk' : $scope.profile.pk };
        var promise = TimelogFactory.log_today(filter);
        promise.then(function(data){
            var log = data.data.result[0];
            
            $scope.lastlog.pk = log.pk;
            $scope.lastlog.date = log.date + " " + log.time;
            if(log.type == 'In'){
                $scope.logtype = "logout";
                $scope.random_hash = log.random_hash;
                $scope.lastlog.message = "Your last log in was today " + log.time;
            }
            else {
                $scope.logtype = "login";

                $scope.lastlog.message = "Your last log out was today " + log.time;
            }

        })
        .then(null, function(data){
            get_last_log();
        });
    }

    $scope.submitlog = function(type){
        
        var filter = {
            'type' : type,
            'employees_pk' : $scope.profile.pk
        };

        if(type == "Out"){
            var logout_msg = 'Are you sure you want to log out?';
            $scope.modal = {
                title : '',
                message: logout_msg,
                save : 'Log out',
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
                $scope.logbutton = true;
                filter.random_hash = $scope.random_hash;

                var promise = TimelogFactory.submit_log(filter);
                promise.then(function(data){
                    console.log($scope.lastlog.date);
                    get_last_log_today();

                    UINotification.success({
                                    message: 'You have successfully logged out.', 
                                    title: 'SUCCESS', 
                                    delay : 5000,
                                    positionY: 'top', positionX: 'right'
                                });

                    is_overtime();

                    var to = $timeout(function() {
                        $timeout.cancel(to);
                        $scope.logbutton = false;
                    }, 5000);
                })
                .then(null, function(data){
                    UINotification.error({
                                    message: 'An error occurred while saving your log out. Please try again.', 
                                    title: 'ERROR', 
                                    delay : 5000,
                                    positionY: 'top', positionX: 'right'
                                });
                });
            });
        }
        else {
            var is_leave_today = {
                status : false
            }

            var pk="";

            for(var i in $scope.approved_leaves.data){
                if($scope.current_date.date >= $scope.approved_leaves.data[i].date_started && $scope.current_date.date <= $scope.approved_leaves.data[i].date_ended){
                    is_leave_today.status = true;
                    is_leave_today.leave = $scope.approved_leaves.data[i].name
                    pk = $scope.approved_leaves.data[i].pk;
                }
            }

            
            if(is_leave_today.status == true){
                $scope.modal = {
                        title : '',
                        message: 'Today, you are on ' + is_leave_today.leave + ". Would you like to request for cancellation?",
                        save : 'Request now',
                        close : 'Request later'
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
                    $scope.modal = {
                        title : '',
                        message: 'Please state the reason why you are cancelling your leave.',
                        save : 'Save',
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
                            
                            $scope.modal["pk"] = pk;
                            $scope.modal["employees_pk"] = $scope.profile.pk;
                            $scope.modal["supervisor_pk"] = $scope.profile.supervisor_pk;
                        
                            var promise = TimelogFactory.cancel_leave($scope.modal);
                            promise.then(function(data){
                
                            $scope.archived=true;

                                UINotification.success({
                                                        message: 'You have successfully cancel your leave.', 
                                                        title: 'SUCCESS', 
                                                        delay : 5000,
                                                        positionY: 'top', positionX: 'right'
                                                    });
                                employees();


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
                });
            }

            
            $scope.logbutton = true;
            var promise = TimelogFactory.submit_log(filter);
            promise.then(function(data){
                get_last_log_today();

                UINotification.success({
                                message: 'You have successfully logged in.', 
                                title: 'SUCCESS', 
                                delay : 5000,
                                positionY: 'top', positionX: 'right'
                            });

                var to = $timeout(function() {
                    $timeout.cancel(to);
                    $scope.logbutton = false;
                }, 5000);
            })
            .then(null, function(data){
                UINotification.error({
                                message: 'An error occurred while saving your log in. Please try again.', 
                                title: 'ERROR',
                                delay : 5000,
                                positionY: 'top', positionX: 'right'
                            });
            });
        }

        
    }

    $scope.switch = function(logtype){
        if(logtype == 'logout'){
            $scope.logtype = "login";
        }
        else {
            $scope.logtype = "logout";
        }
    }

    function is_overtime(){
        var filter = {
            pk : $scope.lastlog.pk
        };

        var promise = TimelogFactory.paired_log(filter);
        promise.then(function(data){
            var a = data.data.result;
            var z = $scope.profile.details.company.work_schedule;
            
            var timeFrom = new Date(a[0].time_log);
            var timeTo = new Date(a[1].time_log);
            
            var difference = timeTo.getTime() - timeFrom.getTime();
            var hours = (((difference / 1000) / 60) /60).toFixed(1);

            var fromdd = timeFrom.getDate();
            var frommm = timeFrom.getMonth()+1; //January is 0!
            var fromyyyy = timeFrom.getFullYear();

            var schedule_from = fromyyyy+"-"+frommm+"-"+fromdd + " " + z[$scope.current_date.day.toLowerCase()]['in'];

            if(timeFrom <= new Date(schedule_from) && parseFloat(hours) >= 11){
                $scope.modal = {
                    title : 'The system detected that you have '+(parseFloat(hours) - 9).toFixed(1)+' excess hours for today, would you like to file an overtime now?',
                    save : 'File Overtime',
                    close : 'Later'
                };

                ngDialog.openConfirm({
                    template: 'OvertimeModal',
                    className: 'ngdialog-theme-plain',
                    scope: $scope,
                    showClose: false
                })
                .then(function(value){
                    return false;
                }, function(value){

                    var todd = timeTo.getDate();
                    var tomm = timeTo.getMonth()+1; //January is 0!
                    var toyyyy = timeTo.getFullYear();

                    var filter = {
                        employees_pk : $scope.profile.pk,
                        remarks : $scope.modal.remarks,
                        time_from : toyyyy+"-"+tomm+"-"+todd + " " + z[$scope.current_date.day.toLowerCase()].out,
                        time_to : a[1].time_log
                    };
                    
                    var promise = TimelogFactory.file_overtime(filter);
                    promise.then(function(data){
                        UINotification.success({
                                        message: 'Your overtime has been filed.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                    })
                    .then(null, function(data){
                        UINotification.error({
                                        message: 'An error occurred while saving your overtime. Please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                    });
                });
            }
        })
        .then(null, function(data){
            
        }); 
    }

    function get_approved_leaves(){
        var filter = {
            employees_pk : $scope.profile.pk
        };

        var promise = LeaveFactory.approved_leaves(filter);
        promise.then(function(data){
            $scope.approved_leaves.status = true;
            $scope.approved_leaves.data = data.data.result;
        })
        .then(null, function(data){
            $scope.approved_leaves.status = false;
        });
    }

    $scope.button_hover = function(type){
        $scope.buttons = {
            login:false,
            loginhover:true,
            logout:false,
            logouthover:true
        };
    }

    $scope.button_mouseout = function(type){
        $scope.buttons = {
            login:true,
            loginhover:false,
            logout:true,
            logouthover:false
        };
    }

    



    // $scope.show_notifs = function(){
    //         get_notifs();
    // }

    // function get_notifs(){
    //     $scope.read=true;

    //     $scope.notification.data='';
    //     var promise = NotificationsFactory.get_notifs($scope.notification);
    //     promise.then(function(data){
    //         $scope.notification.data = data.data.result;
    //     })
    //     .then(null, function(data){
    //     });
    // }

    // $scope.getState = function (number){
    //     if(number === 0){
    //         return '0s';
    //     }else{
    //         return '0.5s';
    //     }
    // };


    // $scope.read_notification = function(k){
    //     var promise = NotificationsFactory.read_notifs($scope.notification.data[k]);
    //     promise.then(function(data){
    //         $scope.notification.data[k].read='t';
    //         pending_notifs($scope.notification.data.length);
    //     })
    // };

    // $scope.pending_notifs = function(number){
    //     $scope.add=0;
    //     $scope.num=0;
    //     while($scope.num<(number)){
    //         if($scope.notification.data[$scope.num].read==='f'){
    //             $scope.add+=1;
    //         }$scope.num+=1;
    //     }
    //     return $scope.add;
    //     console.log($scope.add)
    // }
});