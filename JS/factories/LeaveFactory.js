app.factory('LeaveFactory', function($http){
    var factory = {};           
    
    
    factory.get_leavetypes = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Leave/get_leavetypes.php',
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            transformRequest: function(obj) {
                var str = [];
                for(var p in obj)
                str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
                return str.join("&");
            },
            data : data
        })

        return promise;
    };

    
    factory.add_leave = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Leave/add_leave.php',
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            transformRequest: function(obj) {
                var str = [];
                for(var p in obj)
                str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
                return str.join("&");
            },
            data : data
        })

        return promise;
    }; 

    factory.leaves_filed= function(data){
        var promise = $http({
            url:'./FUNCTIONS/Leave/leaves_filed.php',
            method: 'GET'
            
        })

        return promise;
    };       

    
    return factory;
});