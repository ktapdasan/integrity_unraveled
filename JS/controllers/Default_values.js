app.controller('Default_values', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        ngDialog,
                                        CutoffFactory,
                                        UINotification,
                                        DefaultvaluesFactory,
                                        md5
                                    ){
    $scope.pk='';
    $scope.filter= {};
    $scope.cutoff= {};
    $scope.default_values = {};
    $scope.cancel_color = {};
    $scope.calendar = {};
    $scope.leave_default = {};
    $scope.birthday_leave = {};
    $scope.overtime_leave = {};
    $scope.overtime_leave_pk = {};
    $scope.overtime_leave_types = {};
    $scope.birthday_leave_pk = '';
    $scope.leaves_filed = {};
    $scope.leave_types = {};
    $scope.get_leave_types = {};
    $scope.calendar = {};
    $scope.calendar_color = {};
    $scope.color = '';
    $scope.work = {};
    $scope.work_hours = {};
    $scope.type = '';
    
    $scope.cutofftypes = {};
    $scope.cutoffdates = {};

    $scope.days ={};

    $scope.work_hours.data = {
        hrs : null
    };
    $scope.work.data = {
        monday : false,
        tuesday : false,
        wednesday : false,
        thursday : false,
        friday : false,
        saturday : false,
        sunday : false
    };

    $scope.birthday_leave.data = {
        status : false
    };

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];
            
            get_profile();
            cutofftypes();
            show();
            
        });
    }

    function get_profile(){
        var filters = { 
            'pk' : $scope.pk
        };

        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){
            $scope.profile = data.data.result[0];

            get_work_days();
            get_leave_status();
            get_work_hours();
            get_leave_types();
            birthday_leave();
            default_values();
            show_list();
            fetch_cutoff_dates();
            get_overtime_leave();
            get_overtime_leave_status();
            get_overtime_leave_types();
            //fetch_myemployees(); 
        })         
    } 


    $scope.save_workdays = function(){  

        $scope.modal = {
            title : '',
            message: 'Are you sure you want to save these work days?',
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
            

            


            var promise = DefaultvaluesFactory.save($scope.work.data);
            promise.then(function(data){




                UINotification.success({
                                            message: 'You have successfully saved work days.', 
                                            title: 'SUCCESS', 
                                            delay : 5000,
                                            positionY: 'top', positionX: 'right'
                                        });  

            })
            .then(null, function(data){

                UINotification.error({
                                        message: 'An error occured, unable to save, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });
       });
       
    }

    function get_work_days(){
        
        var promise = DefaultvaluesFactory.get_work_days();
        promise.then(function(data){

            var a = data.data.result[0];
            var work_days = JSON.parse(a.details)

            for(var i in work_days)
            {
                if (work_days[i] == "true"){
                    work_days[i] = true;
                }
                else
                {
                    work_days[i] = false;
                }
            }

            $scope.work.data.monday = work_days.monday;
            $scope.work.data.tuesday = work_days.tuesday;
            $scope.work.data.wednesday = work_days.wednesday;
            $scope.work.data.thursday = work_days.thursday;
            $scope.work.data.friday = work_days.friday;
            $scope.work.data.saturday = work_days.saturday;
            $scope.work.data.sunday = work_days.sunday;
            
        })
        .then(null, function(data){
            
        });
    }

    function get_leave_status(){
        
        var promise = DefaultvaluesFactory.get_leave_status();
        promise.then(function(data){

            var a = data.data.result[0];
            var birthday_leave = JSON.parse(a.details)

            for(var i in birthday_leave)
            {
                if (birthday_leave[i] == "true"){
                    birthday_leave[i] = true;
                }
                else
                {
                    birthday_leave[i] = false;
                }
            }

            $scope.birthday_leave.status = birthday_leave.status;
            
        })
        .then(null, function(data){
            
        });
    }

     function get_overtime_leave_status(){
        
        var promise = DefaultvaluesFactory.get_overtime_leave_status();
        promise.then(function(data){

            var a = data.data.result[0];
            var overtime_leave = JSON.parse(a.details)

            for(var i in overtime_leave)
            {
                if (overtime_leave[i] == "true"){
                    overtime_leave[i] = true;
                }
                else
                {
                    overtime_leave[i] = false;
                }
            }

            $scope.overtime_leave.status = overtime_leave.allow_tardy;
            
        })
        .then(null, function(data){
            
        });
    }


    function get_work_hours() {
        var filters = { 
            'name' : 'working_hours'
        };

        var promise = DefaultvaluesFactory.get_work_hours(filters);
        promise.then(function(data){
            $scope.work_hours.status = true;
            $scope.work_hours.data = data.data.result[0];

            $scope.work_hours.data.details = JSON.parse($scope.work_hours.data.details);
            $scope.work_hours.data.hrs = $scope.work_hours.data.details.hrs;

        })
        .then(null, function(data){
            $scope.work_hours.status = false;
        });
    }

    function get_overtime_leave() {
        var filters = { 
            'name' : 'overtime_leave'
        };

        var promise = DefaultvaluesFactory.get_overtime_leave(filters);
        promise.then(function(data){
            
            $scope.overtime_leave.data = data.data.result[0];

            $scope.overtime_leave.details = JSON.parse($scope.overtime_leave.data.details);
            $scope.overtime_leave.pk = $scope.overtime_leave.details.leave_types_pk;
            $scope.overtime_leave.year = $scope.overtime_leave.details.maximum.year;
            $scope.overtime_leave.month = $scope.overtime_leave.details.maximum.month;

        })
        .then(null, function(data){
            
        });
    }

    $scope.save_hrs = function(){  

        $scope.modal = {
            title : '',
            message: 'Are you sure you want to save these working hours?',
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
            

            


            var promise = DefaultvaluesFactory.save_hrs($scope.work_hours.data);
            promise.then(function(data){




                UINotification.success({
                                            message: 'You have successfully saved working hours.', 
                                            title: 'SUCCESS', 
                                            delay : 5000,
                                            positionY: 'top', positionX: 'right'
                                        });  

            })
            .then(null, function(data){

                UINotification.error({
                                        message: 'An error occured, unable to save, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });
       });
       
    }   

    $scope.save_overtime_leave = function(){  

        $scope.modal = {
            title : '',
            message: 'Are you sure you want to save these overtime leave?',
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
            

            


            var promise = DefaultvaluesFactory.save_overtime_leave($scope.overtime_leave);
            promise.then(function(data){




                UINotification.success({
                                            message: 'You have successfully saved overtime leave.', 
                                            title: 'SUCCESS', 
                                            delay : 5000,
                                            positionY: 'top', positionX: 'right'
                                        });  

            })
            .then(null, function(data){

                UINotification.error({
                                        message: 'An error occured, unable to save, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });
       });
       
    }   

    function cutofftypes(){
        $scope.cutoff.types={};
        var promise = CutoffFactory.fetch_types();
        promise.then(function(data){
            $scope.cutoff.types.status = true;
            $scope.cutoff.types.data = data.data.result;
        })
        .then(null, function(data){
            $scope.cutoff.types.status = false;
        });
    }

    $scope.show_type = function(){
        type();
        
    }

    function type(){
        if ($scope.cutoff.cutoff_types_pk == 1) {
            $scope.displayM = true;
            $scope.displayB = false;
        }
        else {
            $scope.displayB = true;
            $scope.displayM = false;
        }           
    }

    $scope.save_cutoff = function(){  
        type();

        $scope.modal = {
            title : '',
            message: 'Are you sure you want to save cutoff days?',
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

            var promise = DefaultvaluesFactory.save_cutoff($scope.cutoff);
            promise.then(function(data){

                UINotification.success({
                                            message: 'You have successfully saved cutoff days.', 
                                            title: 'SUCCESS', 
                                            delay : 5000,
                                            positionY: 'top', positionX: 'right'
                                        });  

            })
            .then(null, function(data){

                UINotification.error({
                                        message: 'An error occured, unable to save, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });
       });
       
    }

    function fetch_cutoff_dates(){        
        $scope.cutoff.dates={};
        var promise = DefaultvaluesFactory.fetch_dates();
        promise.then(function(data){
            $scope.cutoff.dates.data = data.data.result[0];
            
            $scope.cutoff.dates.data.details = JSON.parse($scope.cutoff.dates.data.details);
            
            
            $scope.cutoff.cutoff_types_pk = $scope.cutoff.dates.data.details.cutoff_types_pk;
            

            if ($scope.cutoff.cutoff_types_pk  == "1"){
                $scope.cutoff.start_m = $scope.cutoff.dates.data.details.dates.from;
                $scope.cutoff.end_m = $scope.cutoff.dates.data.details.dates.to;
            }
            else{
                $scope.cutoff.start_bf = $scope.cutoff.dates.data.details.dates.first.from;
                $scope.cutoff.end_bf = $scope.cutoff.dates.data.details.dates.first.to;

                $scope.cutoff.start_bs = $scope.cutoff.dates.data.details.dates.second.from;
                $scope.cutoff.end_bs = $scope.cutoff.dates.data.details.dates.second.to;
            }

            

            type();
        })
        .then(null, function(data){
            if ($scope.cutoff.cutoff_types_pk == "1"){
                $scope.cutoff.start_m = 1;
                $scope.cutoff.end_m = 30;
            }
            else {
                $scope.cutoff.start_bf = 1;
                $scope.cutoff.end_bf = 15;

                $scope.cutoff.start_bs = 16;
                $scope.cutoff.end_bs = 30;
            }

            type();
        });
    }

    $scope.show_days = function(){
        show();
    }

    function show() {
        for(var i=1;i<32;i++){
            $scope.days[i] = i;      
        };

        fetch_cutoff_dates();      
    }

    function default_values() {
        var filters = { 
            'name' : 'leave'
        };

        var promise = DefaultvaluesFactory.get_default_values(filters);
        promise.then(function(data){
            $scope.leave_default.status = true;
            $scope.leave_default.data = data.data.result[0];

            $scope.leave_default.data.details = JSON.parse($scope.leave_default.data.details);
            $scope.leave_default.data.regularization = $scope.leave_default.data.details.regularization;
            $scope.leave_default.data.staggered = $scope.leave_default.data.details.staggered;
            $scope.leave_default.data.carry_over = $scope.leave_default.data.details.carry_over;
            $scope.leave_default.data.leaves_per_month = $scope.leave_default.data.details.leaves_per_month;
            $scope.leave_default.data.max_increase = $scope.leave_default.data.details.max_increase;
            $scope.leave_default.data.leaves_regularization = $scope.leave_default.data.details.leaves_regularization;

        })
        .then(null, function(data){
            $scope.leave_default.status = false;
        });
    }

    function birthday_leave() {
        var filters = { 
            'name' : 'birthday_leave'
        };

        var promise = DefaultvaluesFactory.get_birthday_leave(filters);
        promise.then(function(data){
            
            $scope.birthday_leave.data = data.data.result[0];

            $scope.birthday_leave.details = JSON.parse($scope.birthday_leave.data.details);
            $scope.birthday_leave.count = $scope.birthday_leave.details.count;
            $scope.birthday_leave.pk = $scope.birthday_leave.details.leave_types_pk;
        })
        .then(null, function(data){
            
        });
    }

    // function leaves() {
    //     var filters = { 
    //         'name' : 'leave'
    //     };

    //     var promise = DefaultvaluesFactory.get_default_values(filters);
    //     promise.then(function(data){
    //         $scope.leave_default.status = true;
    //         $scope.leave_default.data = data.data.result[0];

    //         $scope.leave_default.data.details = JSON.parse($scope.leave_default.data.details);
    //         $scope.leave_default.data.regularization = $scope.leave_default.data.details.regularization;
    //         $scope.leave_default.data.staggered = $scope.leave_default.data.details.staggered;
    //         $scope.leave_default.data.carry_over = $scope.leave_default.data.details.carry_over;

    //     })
    //     .then(null, function(data){
    //         $scope.leave_default.status = false;
    //     });
    // }

    function get_leave_types() {
        var promise = DefaultvaluesFactory.get_leave_types();
        promise.then(function(data){
            $scope.leave_types.data = data.data.result;

            $scope.leave_types.data.name = $scope.leave_types.data;
            $scope.leave_types.data.pk = $scope.leave_types.data;
        })
        .then(null, function(data){
        });
    }

    function get_overtime_leave_types() {
        var promise = DefaultvaluesFactory.get_overtime_leave_types();
        promise.then(function(data){
            $scope.overtime_leave_types.data = data.data.result;

            $scope.overtime_leave_types.data.name = $scope.overtime_leave_types.data;
            $scope.overtime_leave_types.data.pk = $scope.overtime_leave_types.data;
        })
        .then(null, function(data){
        });
    }

    /*function leaves_filed() {
        var promise = DefaultvaluesFactory.get_leaves_filed();
        promise.then(function(data){
            $scope.leaves_filed.data = data.data.result;

            $scope.leaves_filed.data[0].details =JSON.parse($scope.leaves_filed.data[0].details);
            $scope.leaves_filed.data[0].details.leave_per_month =$scope.leaves_filed.data[0].details.leave_per_month;

            console.log($scope.leaves_filed.data[0].details.leave_per_month);
        })
        .then(null, function(data){
        });
    }
*/

    $scope.save_default = function(){
        $scope.modal = {
                title : '',
                message: 'Are you sure you want to update these values?',
                save : 'Update',
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
            
            $scope.leave_default.data.employees_pk = $scope.profile.pk;
            
            var promise = DefaultvaluesFactory.update_default_values($scope.leave_default.data);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully updated leave default', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to update, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    }

    $scope.save_leave = function(){
        $scope.modal = {
                title : '',
                message: 'Are you sure you want to update these values?',
                save : 'Update',
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
            
            var promise = DefaultvaluesFactory.update_birthday_leave($scope.birthday_leave);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully updated leave default', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to update, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    }

    $scope.save_color = function(){

        $scope.modal = {
                title : '',
                message: 'Are you sure you want to save these colors?',
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
            
            var filters = { 
            a : $scope.color,
            employees_pk : $scope.profile.pk
        };
            var promise = DefaultvaluesFactory.save_color(filters);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully saved the colors', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to update, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    }

    function show_list(){

        var filter = {
            employees_pk : $scope.profile.pk
        }

        
        
        var promise = DefaultvaluesFactory.fetch_saved_colors(filter);
        promise.then(function(data){
            $scope.calendar_color.status = true;
            $scope.calendar_color.data = data.data.result;
            console.log($scope.calendar_color);
            
        })
        .then(null, function(data){
            $scope.calendar_color.status = false;
        });
    }

    $scope.cancel = function(k){
        $scope.modal = {
                title : 'Cancel Color Saved',
                message: 'Are you sure you want to cancel your saved color',
                save : 'Delete',
                close : 'Cancel'
            };
        
        ngDialog.openConfirm({
            template: 'ColorCancelModal',
            className: 'ngdialog-theme-plain custom-widththreefifty',
            
            scope: $scope,
            showClose: false
        })
        .then(function(value){
            return false;
        }, function(value){

            
                $scope.cancel_color["employees_pk"] = $scope.profile.pk;
                $scope.cancel_color.pk = $scope.calendar_color.data[k].pk;

            var promise = DefaultvaluesFactory.cancel_color($scope.cancel_color);
            promise.then(function(data){
                UINotification.success({
                                        message: 'You have successfully cancelled your request', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                show_list();
            })
            .then(null, function(data){
                UINotification.error({
                                        message: 'An error occured, unable to cancel, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    
    }

    

});
