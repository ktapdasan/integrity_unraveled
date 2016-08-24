app.controller('Analytics', function(
  										$scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        LeaveFactory,
                                        md5
  									){


    $scope.profile = {};

    

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            get_profile();
        })
    }

    function get_profile(){
        var filters = { 
            'pk' : $scope.pk
        };

        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){
            $scope.profile = data.data.result[0];
            
            //get_notifications();
        })   
    } 

    function get_notifications(){
        var filter = {
            employees_pk : $scope.profile.pk
        }

        var promise = LeaveFactory.leaves_filed(filter);
        promise.then(function(data){
            console.log(data.data.result);
           
        })
        .then(null, function(data){
            $scope.notifications.status = false;
            


        });
    }

    
    
});