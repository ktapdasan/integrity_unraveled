app.controller('Work_days', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        ngDialog,
                                        UINotification,
                                        WorkdaysFactory,
                                        md5
                                    ){
    $scope.default_values = {};
    $scope.work = {};
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


            //fetch_myemployees(); 
        })         
    } 


    $scope.save = function(){  

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
            

            


            var promise = WorkdaysFactory.save($scope.work.data);
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
        
        var promise = WorkdaysFactory.get_work_days();
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
    

});