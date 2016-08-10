app.controller('Sidebar', function(
  										$scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        NotificationsFactory,
                                        md5
  									){


    $scope.profile = {};

    $scope.switcher = {};
    $scope.switcher.main = "";

    $scope.notifications = {};

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
            
            get_notifications();
        })   
    } 

    //$scope.stop = true; //how to stop the shaking

    $scope.toggle_switcher = function(){
        if($scope.switcher.main == ""){
            $scope.switcher.main = "open";
            $scope.switcher.content = true;
            $scope.stop = true;    
        }
        else {
            $scope.switcher.main = "";   
            $scope.switcher.content = false;
            $scope.stop = false;
            
        }
    }

    $scope.getStop = function(){
        if($scope.stop == true){
            return '0s';
        }
        else {
            return '1s';
        }
    }

    function get_notifications(){
        var filter = {
            employees_pk : $scope.profile.pk
        }

        var promise = NotificationsFactory.get_notifications(filter);
        promise.then(function(data){
            $scope.notifications.status = true;
            $scope.notifications.data = data.data.result;
        })
        .then(null, function(data){
            $scope.notifications.status = false;
        });
    }

    $scope.goto = function(k){
        console.log($scope.notifications.data[k]);

        var location="";
        if($scope.notifications.data[k].table_from == "attritions"){
            location = "#/management/attrition";
        }
        else if($scope.notifications.data[k].table_from == "leave_filed"){
            location = "#/management/leaves";
        }
        else if($scope.notifications.data[k].table_from == "manual_log"){
            location = "#/management/manual_logs";
        }

        window.location = location;
    }
    
});