app.controller('Dashboard', function(
  										$scope,
                                        SessionFactory,
                                        TimelogFactory,
                                        EmployeesFactory,
                                        md5
  									){

    $scope.profile = {};
    $scope.greetings = "Good Morning";
    $scope.logtype = "login";
    $scope.lastlog = "";
    $scope.logbutton = false;
    init();

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

    function get_profile(){
        var filters = { 
            'pk' : $scope.pk
        };

        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){
            $scope.profile = data.data.result[0];

            get_last_log_today();
        })   
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

            if(log.type == 'In'){
                $scope.logtype = "logout";

                $scope.lastlog = "Your last log in was on " + date.format('dddd, MMMM Do YYYY') + " " + log.time;
            }
            else {
                $scope.logtype = "login";

                $scope.lastlog = "Your last log out was on " + date.format('dddd, MMMM Do YYYY') + " " + log.time;
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
            
            if(log.type == 'In'){
                $scope.logtype = "logout";

                $scope.lastlog = "Your last log in was today " + log.time;
            }
            else {
                $scope.logtype = "login";

                $scope.lastlog = "Your last log out was today " + log.time;
            }
        })
        .then(null, function(data){
            get_last_log();
        });
    }

    $scope.submitlog = function(type){
        $scope.logbutton = true;

        var filter = {
            'type' : type,
            'employees_pk' : $scope.profile.pk
        };

        var promise = TimelogFactory.submit_log(filter);
        promise.then(function(data){
            get_last_log_today();

            setTimeout(function(){
                $scope.logbutton = false;
            }, 2000)
        })
    }
});