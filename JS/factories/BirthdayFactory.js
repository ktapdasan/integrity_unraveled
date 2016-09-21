app.factory('BirthdayFactory', function($http){
    var factory = {};           

    factory.get_birthday_theme = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Birthday/get_birthday_theme.php',
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

    factory.add_birthday_theme = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Birthday/add_birthday_theme.php',
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

    factory.update_birthday_theme = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Birthday/update_birthday_theme.php',
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

    factory.delete_birthday_theme = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Birthday/delete_birthday_theme.php',
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

    factory.restore_birthday_theme = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Birthday/restore_birthday_theme.php',
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