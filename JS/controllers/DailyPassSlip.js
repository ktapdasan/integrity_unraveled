app.controller('DailyPassSlip', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        TimelogFactory,
                                        ngDialog,
                                        UINotification,
                                        md5
                                    ){

    $scope.profile = {};
    $scope.filter = {};
    $scope.filter.status = 'Active';

    $scope.modal = {};

    $scope.dps = {};
    $scope.dps.status = false;
    $scope.dps.count = 0;

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            get_profile();
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
            DEFAULTDATES();

            show_list();
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

        $scope.filter.date_from = new Date(yyyy+'-'+mm+'-01'); //getMonday(new Date());
        $scope.filter.date_to = new Date();
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

    $scope.show_list = function(){
        show_list();
    }
    
    function show_list(){
        var from_date = new Date($scope.filter.date_from);
        var fromd = from_date.getDate();
        var fromm = from_date.getMonth()+1; //January is 0!
        var fromy = from_date.getFullYear();

        var to_date = new Date($scope.filter.date_to);
        var tod = to_date.getDate();
        var tom = to_date.getMonth()+1; //January is 0!
        var toy = to_date.getFullYear();

        var filter = {
            employees_pk : $scope.profile.pk,
            date_from : fromy +"-"+ fromm +"-"+fromd,
            date_to : toy+"-"+tom+"-"+tod,
            status : $scope.filter.status
        }
        
        var promise = TimelogFactory.fetch_dps(filter);
        promise.then(function(data){
            $scope.dps.status = true;
            $scope.dps.data = data.data.result;
        })
        .then(null, function(data){
            $scope.dps.status = false;
        });
    }

    $scope.cancel = function(k){
        console.log($scope.dps.data[k]);
    }
});