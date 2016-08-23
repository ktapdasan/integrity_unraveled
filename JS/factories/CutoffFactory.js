app.factory('CutoffFactory', function($http){
    var factory = {};           
    
    
    factory.submit_type = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Cutoff/submit_type.php',
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

    factory.fetch_types = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Cutoff/cutofftypes.php',
            method: 'GET'
        })

        return promise;

    };

    factory.fetch_dates = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Cutoff/fetch_dates.php',
            method: 'GET'
        })

        return promise;
    };

    factory.read_notifs = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Notifications/read_notifs.php',
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

    return factory;
});