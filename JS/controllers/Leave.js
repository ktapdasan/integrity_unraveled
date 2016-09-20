app.controller('Leave', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        LevelsFactory,
                                        LeaveFactory,
                                        TimelogFactory,
                                        ngDialog,
                                        UINotification,
                                        md5
                                    ){

    //$scope.pk='';
    $scope.leave_types={}; 
    $scope.leave_balances={};
    $scope.profile= {};

    $scope.filter= {};
    $scope.filter.status= "Active";

    $scope.modal = {};

    $scope.leaves_filed = {};
    $scope.leaves_filed.count = 0;

    $scope.myemployees={};

    $scope.modal.remaining = {
        status : false,
        count : 0
    }
    

    $scope.modal.total = {
        status : false,
        count : 0   
    }

    $scope.isEndDate = true;

    $scope.workdays = [];

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
            $scope.profile.details = JSON.parse($scope.profile.details);
            $scope.profile.permission = JSON.parse($scope.profile.permission);
            $scope.profile.leave_balances = JSON.parse($scope.profile.leave_balances);

            DEFAULTDATES();
            workdays();
            leave_types();
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

        $scope.modal.date_started = new Date(yyyy+'-'+mm+'-'+dd); 
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

    $scope.check_balance = function(){
        var leave_name="";
        for(var i in $scope.leave_types.data){
            if($scope.leave_types.data[i].pk == $scope.modal.leave_types_pk){
                leave_name = $scope.leave_types.data[i].name;
            }
        }

        if($scope.modal.category == "Paid"){
            if(parseInt($scope.leave_balances[leave_name]) > 0){
                
                $scope.modal.save_status = false;
                $scope.modal.save_class = 'ngdialog-button-primary'; //modal_save_disabled
                $scope.modal.remaining = {
                    status : true,
                    count : $scope.leave_balances[leave_name]
                }
            }
            else {
                $scope.modal.save_status = true;
                $scope.modal.save_class = 'modal_save_disabled';// 'ngdialog-button-primary'; //modal_save_disabled
                $scope.modal.remaining = {
                    status : true,
                    count : $scope.leave_balances[leave_name]
                }
            }
        }
        else {
            $scope.modal.save_status = false;
            $scope.modal.save_class = 'ngdialog-button-primary'; //modal_save_disabled
            $scope.modal.remaining = {
                status : true,
                count : $scope.leave_balances[leave_name]
            }
        }
    }

    $scope.check_leave_count = function(){
        
        var date_started= new Date($scope.modal.date_started);
        var date_ended= new Date($scope.modal.date_ended);

        // $scope.modal.total.status = false;
        // $scope.modal.total.count = 0;
        
        if($scope.modal.category == "Paid"){
            var d = countCertainDays($scope.workdays,date_started,date_ended);

            $scope.modal.total.count = d;

            if($scope.modal.duration != "Whole Day"){
                $scope.modal.total.count = .5;
            }   
        }
        else {
            $scope.modal.total.count = 0;   
        }

        if(isNaN($scope.modal.total.count)){
            $scope.modal.total.count = 0;            
        }
    }

    $scope.duration_changed = function(){
        if($scope.modal.duration == "Whole Day"){
            $scope.isEndDate = true;
        }
        else {
            $scope.isEndDate = false;

            $scope.modal.date_ended = $scope.modal.date_started;
        }
    }

    function countCertainDays( days, d0, d1 ) {
        var ndays = 1 + Math.round((d1-d0)/(24*3600*1000));
        var sum = function(a,b) {
            return a + Math.floor( ( ndays + (d0.getDay()+6-b) % 7 ) / 7 ); 
        };

        return days.reduce(sum,0);
    }

    $scope.add_leave = function(){
        $scope.modal.leave_types_pk = '';
        $scope.modal.remaining.status = false;

        $scope.modal.total.status = false;
        $scope.modal.total.count = 0;

        $scope.modal.title = 'File a Leave';
        $scope.modal.save = 'Submit';
        $scope.modal.close = 'Cancel';
        $scope.modal.save_status = false;
        $scope.modal.save_class = 'ngdialog-button-primary'; //modal_save_disabled
        $scope.modal.category = "Paid";
        $scope.modal.duration = "Whole Day";
        $scope.modal.reason = '';
        $scope.modal.date_started = new Date();
        $scope.modal.date_ended = new Date();

        ngDialog.openConfirm({
            template: 'LeaveModal',
            className: 'ngdialog-theme-plain custom-widthfourfifty',
            preCloseCallback: function(value) {
                
                $scope.duration_changed();
                $scope.check_leave_count();
                
                if($scope.modal.total.count > $scope.modal.remaining.count){
                    alert("You don't have enough balance to file this leave.");
                    return false;
                }
                
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
                    className: 'ngdialog-theme-plain custom-widthfourfifty'
                });

                return nestedConfirmDialog;
            },
            scope: $scope,
            showClose: false
        })
        .then(function(value){
            return false;
        }, function(value){
            var date_started= new Date($scope.modal.date_started);
                var dd = date_started.getDate();
                var mm= date_started.getMonth()+1;
                var yyyy = date_started.getFullYear();
            var date_ended= new Date($scope.modal.date_ended);
                var DD= date_ended.getDate();
                var MM = date_ended.getMonth()+1; 
                var YYYY = date_ended.getFullYear(); 
               
            $scope.modal.date_started = yyyy+'-'+mm+'-'+dd;
            $scope.modal.date_ended = YYYY+'-'+MM+'-'+DD;
            $scope.modal.employees_pk = $scope.profile.pk;
            $scope.modal.supervisor_pk = $scope.profile.supervisor_pk;
            $scope.modal.leave_balance = $scope.modal.remaining.count;
            $scope.modal.total_days = $scope.modal.total.count;


            // var workdays = countCertainDays($scope.workdays,date_started,date_ended);
            // console.log($scope.modal.remaining.count);
            // console.log(satsun);
            //return false;

            // if($scope.modal.category == "Paid"){
            //     if($scope.modal.duration == "Whole Day"){
            //         if(workdays > $scope.modal.remaining.count){

            //         }
            //     }
            // }

            var promise = LeaveFactory.add_leave($scope.modal);
            promise.then(function(data){
                UINotification.success({
                                        message: 'You have successfully filed a leave.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });

                var filters = { 
                    'pk' : $scope.pk
                };
                var promise = EmployeesFactory.profile(filters);
                promise.then(function(data){
                    $scope.profile = data.data.result[0];

                    $scope.profile.leave_balances = JSON.parse(data.data.result[0].leave_balances);
                    leaves_filed();
                    leave_types();
                })
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

    function leave_types(){  
        var filter = {
            archived : false,
            employees_pk : $scope.profile.pk
        };
        
        $scope.leave_types.data = [];
        var promise = LeaveFactory.get_leave_types(filter);
        promise.then(function(data){
            $scope.leave_types.status = true;
            $scope.leave_types.data = data.data.result;

            var leave_obj = {};
            var a = data.data.result;
            $scope.leave_types.obj=[];
            for(var i in a){
                leave_obj[a[i].pk] = a[i].name;
                $scope.leave_types.obj.push({
                                            pk: a[i].pk,
                                            name: a[i].name,
                                            ticked: false
                                        });
            }

            var a = $scope.profile.leave_balances;
            
            $scope.leave_balances = {};
            for(var i in $scope.leave_types.data){
                if(a[$scope.leave_types.data[i].pk] === undefined){
                    a[$scope.leave_types.data[i].pk] = 0;
                }
                $scope.leave_balances[$scope.leave_types.data[i].name] = a[$scope.leave_types.data[i].pk];
            }
        })
        .then(null, function(data){
            $scope.leave_types.status = false;
        });
    }

    $scope.delete = function(k){
        check_filed_leave(k);

        var date1 = new Date($scope.leaves_filed.data[k].date_started);
        var date2 = new Date($scope.leaves_filed.data[k].date_ended);

        var workdays = countCertainDays($scope.workdays,date1,date2);
       
        $scope.modal = {
                title : '',
                message: 'Are you sure you want to delete your request',
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
                leave_filed_pk : $scope.leaves_filed.data[k].pk,
                created_by : $scope.profile.pk,
                employees_pk : $scope.leaves_filed.data[k].employees_pk,
                workdays : workdays,
                leave_types_pk : $scope.leaves_filed.data[k].leave_types_pk,
                leave_type : $scope.leaves_filed.data[k].leave_type,
                leave_balances : JSON.stringify($scope.profile.leave_balances),
                duration : $scope.leaves_filed.data[k].duration,
                category : $scope.leaves_filed.data[k].category
            };

            var promise = LeaveFactory.delete(filter);
            promise.then(function(data){
                $scope.leaves_filed.status = true;
                $scope.leaves_filed.data = data.data.result;
                $scope.archived=false;

                UINotification.success({
                                        message: 'You have successfully Deleted your request', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                var filters = { 
                    'pk' : $scope.pk
                };
                var promise = EmployeesFactory.profile(filters);
                promise.then(function(data){
                    $scope.profile = data.data.result[0];

                    for(var i in $scope.leave_types.data){
                        $scope.leave_balances[$scope.leave_types.data[i].name] = a[$scope.leave_types.data[i].pk];
                    }

                    $scope.leave_balances = JSON.parse(data.data.result[0].leave_balances);

                    $scope.leaves_filed.data.splice(k, 1);

                    if($scope.leaves_filed.data.length < 1){
                        $scope.leaves_filed.status = false;
                    }
                })
            })
            .then(null, function(data){
                $scope.leaves_filed.status = false;
                UINotification.error({
                                        message: 'An error occured, unable to Delete, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    }

    function check_filed_leave(k){
        var filter = {
            pk : $scope.leaves_filed.data[k].pk
        };
        var promise = LeaveFactory.get_filed_leave(filter);
        promise.then(function(data){
            var a = data.data.result[0];

            if(a.status != "Pending"){
                UINotification.error({
                                        message: 'You are no longer allowed to delete your request because it has already been ' + a.status, 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });

                $scope.leaves_filed.data[k].status = a.status;   
                return false;
            }
        })
    }

    $scope.leaves_filed = function(){
        leave_types();
        leaves_filed();        
    }

    function leaves_filed() {
        var from_date = new Date($scope.filter.date_from);
        var fromd = from_date.getDate();
        var fromm = from_date.getMonth()+1; //January is 0!
        var fromy = from_date.getFullYear();

        var to_date = new Date($scope.filter.date_to);
        var tod = to_date.getDate();
        var tom = to_date.getMonth()+1; //January is 0!
        var toy = to_date.getFullYear();

        var filter = {};
        filter.employees_pk = $scope.profile.pk;
        filter.archived = $scope.filter.archived;
        filter.date_from = fromy +"-"+ fromm +"-"+ fromd;
        filter.date_to = toy +"-"+ tom +"-"+ tod;
        filter.status = $scope.filter.status;
        filter.duration = $scope.filter.duration;
        filter.category = $scope.filter.category;

        if($scope.filter.leave_type && $scope.filter.leave_type[0]){
            filter.leave_types_pk = $scope.filter.leave_type[0].pk;
        }
        
        var promise = LeaveFactory.leaves_filed(filter);
        promise.then(function(data){
            $scope.leaves_filed.status = true;
            $scope.leaves_filed.data = data.data.result;
            $scope.leaves_filed.count = data.data.result.length;
        })
        .then(null, function(data){
            $scope.leaves_filed.status = false;
        }); 
    }

    function workdays(){
        var a = $scope.profile.details.company.work_schedule;

        for(var i in a){
            if(a[i] != null){
                $scope.workdays.push(get_day_num(i));
            }
        }
    }

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


    $scope.cancel_leave = function(k){
       var pk = $scope.leaves_filed.data[k].pk;
        
        $scope.modal = {
                        title : '',
                        message: 'Are you sure you want to cancel your request',
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
                        leave_types();
                        leaves_filed(); 


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

    

});