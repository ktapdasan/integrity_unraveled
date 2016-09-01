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

    $scope.read_notifs = {};

    $scope.notifications.count =0;

    $scope.stop = false; //how to stop the shaking
    
    $scope.animation_arrow = {
        stop : '0' ,
        opacity : '1'
    }

    $scope.animation = {
        stop : '0' ,
        duration : '2.6s' 
    }


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

 


    $scope.toggle_switcher = function(){
        if($scope.switcher.main == ""){
            $scope.switcher.main = "open";
            $scope.switcher.content = true;
            $scope.stop = true;    
            
        }
        else {
            $scope.switcher.main = "";   
            $scope.switcher.content = false;
            $scope.stop = true;
            
        }
    }

    $scope.getStop = function(){
        if($scope.stop == true){
            $scope.stop = false;  
        }


    }

    $scope.getStop = function(){
        if($scope.stop == true)
        {

            return $scope.animation.stop;
        }
        else {
            return $scope.animation.duration;
        }
    }

    $scope.get_arrowstop = function(){
         if($scope.stop == true)
        {

            return $scope.animation_arrow.stop;
        }
        else {
            return $scope.animation_arrow.opacity;
        }

    }
   

    function get_notifications(){
        var filter = {
            employees_pk : $scope.profile.pk
        }


        var promise = NotificationsFactory.get_notifications(filter);
        promise.then(function(data){

            $scope.notifications.data = data.data.result;
            $scope.notifications.status = true;
            var count = data.data.result.length;
            var counts=count;

           for (var i = 0; i < count; i++) {

               if ($scope.notifications.data[i].read=='t') {
                    counts--;
               };
               
           };
   
            if (counts<=0) {

                return $scope.notifications.count="";
            }
            else
            {
                return $scope.notifications.count="(" +counts +")";
            }

            $scope.animation_arrow.stop = '1';
            $scope.animation_arrow.opacity = '1';

            
           
        })
        .then(null, function(data){
            $scope.notifications.status = false;

            $scope.animation.stop = '0s';
            $scope.animation.duration = '2.6s';

            $scope.animation_arrow.stop = '0';
            $scope.animation_arrow.opacity = '1';
            
            $scope.animation.stop = '0s';
            $scope.animation.duration = '2.6s';

            $scope.animation_arrow.stop = '0';
            $scope.animation_arrow.opacity = '1';


        });
    }




    $scope.goto = function(k){

        var location="";
        $scope.notifications.data[k].read='t';

        if($scope.notifications.data[k].table_from == "attritions"){
            location = "#/management/attrition";
       
        }
        else if($scope.notifications.data[k].table_from == "leave_filed"){
            location = "#/management/leaves";
        }
        else if($scope.notifications.data[k].table_from == "leave_filed_result"){
            location = "#/timesheet/leaves";
        }
        else if($scope.notifications.data[k].table_from == "manual_log"){
            location = "#/management/manual_logs";
        }
        else if($scope.notifications.data[k].table_from == "manual_log_result"){
            location = "#/timesheet";
        }
        else if($scope.notifications.data[k].table_from == "overtime"){
            location = "#/management/overtime";
        }
        else if($scope.notifications.data[k].table_from == "overtime_result"){
            location = "#/timesheet/overtime";
        }
        else if($scope.notifications.data[k].table_from == "leave_cancellation"){
            location = "#/management/leaves";
        }

        var data=$scope.notifications.data[k];

        read_notifs(data);
        
        
        window.location = location;
        
    }

    function read_notifs(data){
        
        if (data.read == 'f') {

                $scope.read_notifs.status = true;               
            }

        else{

                $scope.read_notifs.status = false;
            }

        var promise = NotificationsFactory.read_notifs(data);
        promise.then(function(data){
           
        })
        .then(null, function(data){
            
            $scope.read_notifs.status = false;

        });
    }

    
});