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
    $scope.labels = [];
    //$scope.series = ['Series A', 'Series B'];
    $scope.series = [];
    $scope.data = [
    // [65,22],
    // [64,23],
    // [0,1],
    // [6,0],
    // [23,14],
    // [0,1]
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

            var new_data={};
            for(var i in a){
                if(new_data[a[i].employees_pk] === undefined){
                    new_data[a[i].employees_pk] = {};    
                    new_data[a[i].employees_pk].employee = a[i].employee;

                    new_data[a[i].employees_pk].leaves = [];
                }

                new_data[a[i].employees_pk].leaves.push({
                    leave : a[i].name,
                    count : a[i].count
                })
            }

            for(var i in new_data){
                $scope.series.push(new_data[i].employee);

                var new_count=[];
                for(var j in new_data[i].leaves){
                    $scope.labels.push(new_data[i].leaves[j].leave);

                    new_count.push(parseInt(new_data[i].leaves[j].count));
                }

                $scope.data.push(new_count);
            }
        })
        .then(null, function(data){
            
        });
    }

    
    
});