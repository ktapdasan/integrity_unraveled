app.controller('Admin_calendar', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        CalendarFactory,
                                        ngDialog,
                                        UINotification,
                                        md5,
                                        moment,
                                        calendarConfig,
                                        $filter
                                    ){

    $scope.pk='';
    $scope.profile= {};

    $scope.events = [];

    //These variables MUST be set as a minimum for the calendar to work
    $scope.calendarView = 'month';
    $scope.viewDate = new Date();

    var actions = [{
                        label: '<i class=\'glyphicon glyphicon-pencil\'></i>',
                        onClick: function(args) {
                            alert.show('Edited', args.calendarEvent);
                        }
                    }, {
                        label: '<i class=\'glyphicon glyphicon-remove\'></i>',
                        onClick: function(args) {
                            console.log(args.calendarEvent);
                        }
                    }];

    $scope.isCellOpen = true;

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            get_profile();
        });
    }

    function get_profile(){
        var filters = { 
            'pk' : $scope.pk
        };

        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){
            $scope.profile = data.data.result[0];

            $scope.profile.details = JSON.parse($scope.profile.details);
            $scope.profile.permission = JSON.parse($scope.profile.permission);
            $scope.profile.leave_balances = JSON.parse($scope.profile.leave_balances);

            get_all_events();
            
        })           
    }

    function get_all_events(){
        console.log($scope.viewDate);
        var data = {
            date : $filter('date')($scope.viewDate, "yyyy-MM-dd")
        };

        $scope.events = [];
        var promise = CalendarFactory.get_events(data);
        promise.then(function(data){
            
            var z = data.data.result;
            for(var i in z){
                $scope.events.push({
                                        title: z[i].description,
                                        color: {
                                                    primary : z[i].color,
                                                    secondary : z[i].color
                                                },
                                        startsAt: new Date(z[i].time_from),
                                        endsAt: new Date(z[i].time_to),
                                        draggable: true,
                                        resizable: true,
                                        actions: actions
                                    });
            }
        })
        .then(null, function(data){
            $scope.events = [];
        });
    }

    $scope.init_calendar = function(){
        get_all_events();
    }

    $scope.addEvent = function() {
        $scope.events.push({
            title: 'New event',
            startsAt: moment().startOf('day').toDate(),
            endsAt: moment().endOf('day').toDate(),
            color: calendarConfig.colorTypes.important,
            draggable: true,
            resizable: true
        });
    };

    $scope.eventClicked = function(event) {
        alert.show('Clicked', event);
    };

    $scope.eventEdited = function(event) {
        alert.show('Edited', event);
    };

    $scope.eventDeleted = function(event) {
        alert.show('Deleted', event);
    };

    $scope.eventTimesChanged = function(event) {
        alert.show('Dropped or resized', event);
    };

    $scope.toggle = function($event, field, event) {
        $event.preventDefault();
        $event.stopPropagation();
        event[field] = !event[field];
    };

    $scope.change_view = function(view){
        $scope.calendarView = view;
    }
});