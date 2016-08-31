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

           
        })         
    } 


    $scope.submit_holiday = function(){  
        $scope.holiday.creator_pk=$scope.profile.pk;

        var date = new Date($scope.holiday.date);
        var dd = date.getDate();
        var mm = date.getMonth()+1; 
        var yyyy = date.getFullYear();

        $scope.holiday.new_date=yyyy +"-"+ mm +"-"+ dd;

        $scope.modal = {
            title : '',
            message: 'Are you sure you want to save this holiday?',
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
            
            var promise = HolidaysFactory.save($scope.holiday);

            promise.then(function(data){




                UINotification.success({
                                            message: 'You have successfully saved a holiday.', 
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

    
    

});