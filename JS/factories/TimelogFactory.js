app.factory('TimelogFactory', function($http){
    var factory = {};           

    factory.last_log = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Timelog/last_log.php',
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

    factory.log_today = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Timelog/log_today.php',
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

    factory.submit_log = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Timelog/submit.php',
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

    factory.timesheet = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Timelog/timesheet.php',
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

    factory.timelogs = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Timelog/timelogs.php',
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