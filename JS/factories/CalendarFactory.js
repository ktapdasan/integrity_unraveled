app.factory('CalendarFactory', function($http){
    var factory = {};           
    
    factory.get_events = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Calendar/get_events.php',
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

    factory.save_event = function(data){
        var promise = $http({
            url:'./FUNCTIONS/Calendar/save_event.php',
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

    function show(action, event) {
        return $uibModal.open({
            templateUrl: './partials/admin/modal_content.html',
            controller: function() {
                var vm = this;
                vm.action = action;
                vm.event = event;
            },
            controllerAs: 'vm'
        });
    }

    return factory;
});