app.factory('NotificationsFactory', function($http){
    var factory = {};           
    
    
    factory.get_notifications = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Notifications/get_notifications.php',
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

    factory.read_notifs = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Notifications/read_notifications.php',
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

    factory.get_birthday = function(){
        var promise = $http({
            url:'./FUNCTIONS/Notifications/get_birthday.php',
            method: 'GET'
            
        })

        return promise;
    };

    factory.get_memo = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Notifications/get_memo.php',
            method: 'GET'
        })

        return promise;

    };

    factory.get_calendar = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Notifications/get_calendar.php',
            method: 'GET'
        })

        return promise;

    };

    factory.read_memo = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Notifications/read_memo.php',
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

    factory.get_read_memo = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Notifications/get_read_memo.php',
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