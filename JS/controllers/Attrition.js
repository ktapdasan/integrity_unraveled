app.controller('Attritions', function(
  										$scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        ngDialog,
                                        UINotification,
                                        md5
  									){

    $scope.filter= {};
    $scope.filter.status= 'Active';

    $scope.profile = {};

    $scope.titles={};
    $scope.level_title={};

    $scope.modal = {};
    
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

            fetch_levels();
            fetch_titles();

            search_attritions();
        })   
    } 
  
    function fetch_levels(){
        var promise = EmployeesFactory.get_levels();
        promise.then(function(data){
            var a = data.data.result;
            $scope.employees.filters.level_title=[];
            for(var i in a){
                $scope.filters.level_title.push({
                                            pk: a[i].pk,
                                            name: a[i].level_title,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            
        });
    }

    function fetch_titles(){
        var promise = EmployeesFactory.get_positions();
        promise.then(function(data){
             var a = data.data.result;
            $scope.employees.filters.titles=[];
            for(var i in a){
                $scope.filters.titles.push({
                                            pk: a[i].pk,
                                            name: a[i].title,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            
        });
    }

    function search_attritions() {

    }

 });