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
    $scope.default_values = {};
    $scope.calendar = {};
    $scope.leave_default = {};
    $scope.birthday_leave = {};
    $scope.leaves_filed = {};
    $scope.leave_types = {};
    $scope.calendar.data = {
        color : null
    };
    $scope.work = {};
    $scope.work_hours = {};
    $scope.type = '';
    
    $scope.cutofftypes = {};

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

            get_work_hours();
            leave_types();
            birthday_leave();
            default_values();
            cutofftypes();
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

    function cutofftypes(){
        $scope.cutofftypes.status = false;
        $scope.cutofftypes.data= '';

        
        var promise = CutoffFactory.fetch_types();
        promise.then(function(data){
            $scope.cutofftypes.status = true;
            $scope.cutofftypes.data = data.data.result;
        })
        .then(null, function(data){
            $scope.cutofftypes.status = false;
        });
    }

    $scope.show_type = function(){
        type();
        
    }

    function type(){
        if ($scope.filter.status == 1) {
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

            var promise = DefaultvaluesFactory.save_cutoff($scope.filter);
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

    function fetch_dates(){        
        var promise = DefaultvaluesFactory.fetch_dates();
        promise.then(function(data){
            $scope.default_values.data = data.data.result;

            $scope.default_values.data[0].details = JSON.parse($scope.default_values.data[0].details);
            
            $scope.filter.status = $scope.default_values.data[0].details;

            if ($scope.default_values.data[0].details.type == "1"){
                $scope.filter.start_m = $scope.default_values.data[0].details.from;
                $scope.filter.end_m = $scope.default_values.data[0].details.to;
            }
            else{
                $scope.filter.start_bf = $scope.default_values.data[0].details.first.from;
                $scope.filter.end_bf = $scope.default_values.data[0].details.first.to;

                $scope.filter.start_bs = $scope.default_values.data[0].details.second.from;
                $scope.filter.end_bs = $scope.default_values.data[0].details.second.to;
            }

            console.log($scope.default_values);

            type();
        })
        .then(null, function(data){
            if ($scope.default_values.data[0].cutoff_types_pk == "1"){
                $scope.filter.start_m = 1;
                $scope.filter.end_m = 30;
            }
            else {
                $scope.filter.start_bf = 1;
                $scope.filter.end_bf = 15;

                $scope.filter.start_bs = 16;
                $scope.filter.end_bs = 30;
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

        fetch_dates();      
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
            $scope.birthday_leave.status = true;
            $scope.birthday_leave.data = data.data.result[0];

            $scope.birthday_leave.data.details = JSON.parse($scope.birthday_leave.data.details);
            $scope.birthday_leave.data.count = $scope.birthday_leave.data.details.count;
        })
        .then(null, function(data){
            $scope.birthday_leave.status = false;
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

    function leave_types() {
        var promise = DefaultvaluesFactory.get_leave_types();
        promise.then(function(data){
            $scope.leave_types.data = data.data.result;

            $scope.leave_types.data.name = $scope.leave_types.data;

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
            console.log($scope.leave_default.data);
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
        $scope.birthday_leave.data.status = 'true';
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
            
            $scope.birthday_leave.data.employees_pk = $scope.profile.pk;
            console.log($scope.birthday_leave.data);
            var promise = DefaultvaluesFactory.update_birthday_leave($scope.birthday_leave.data);
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
            
            var promise = DefaultvaluesFactory.save_color($scope.calendar.data);
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

});
