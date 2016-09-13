app.controller('Analytics', function(
  										$scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        LeaveFactory,
                                        md5
  									){


    $scope.profile = {};

    //////////////////////////////////
    //////////////////////////////////
    //////////////////////////////////
    //////////////////////////////////
    $scope.labels = ["January", "February", "March", "April", "May", "June", "July"];
        //$scope.series = ['Series A', 'Series B'];
        $scope.series = [];
        $scope.data = [
            [65, 59, 80, 81, 56, 55, 40],
            [28, 48, 40, 19, 86, 27, 90]
        ];
        $scope.onClick = function (points, evt) {
            console.log(points, evt);
        };
        //$scope.datasetOverride = [{ yAxisID: 'y-axis-1' }, { yAxisID: 'y-axis-2' }];
        $scope.datasetOverride = [{ yAxisID: 'y-axis-1' }];
        // $scope.options = {
        //     scales: {
        //         yAxes: [
        //         {
        //             id: 'y-axis-1',
        //             type: 'linear',
        //             display: true,
        //             position: 'left'
        //         },
        //         {
        //             id: 'y-axis-2',
        //             type: 'linear',
        //             display: true,
        //             position: 'right'
        //         }]
        //     }
        // };
        $scope.options = {
            scales: {
                yAxes: [
                {
                    id: 'y-axis-1',
                    type: 'linear',
                    display: true,
                    position: 'left'
                }]
            }
        };
        //////////////////////////////////
        //////////////////////////////////
        //////////////////////////////////
        //////////////////////////////////

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
            
            get_leaves();
        })   
    } 

    function get_leaves(){
        var filter = {
            employees_pk : $scope.profile.pk
        }

        var promise = LeaveFactory.leaves_analytics(filter);
        promise.then(function(data){
            var a = data.data.result;
            for(var i in a){
                $scope.series.push(a[i].name);    
            }
            
        })
        .then(null, function(data){
            
            


        });
    }

    
    
});