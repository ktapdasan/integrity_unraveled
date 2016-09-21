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

    $scope.modal = {};

    $scope.colors = ['#dc2127','#7bd148','#5484ed','#fbd75b','#ffb878','#7ae7bf'];
    
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
        //alert.show('Clicked', event);
        console.log(event);

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

    $scope.add_event = function(){
        var date_from = new Date();
            var ddf = date_from.getDate();
            var mmf = date_from.getMonth()+1; 
            var yyyyf = date_from.getFullYear();

        var date_to = new Date();
            var ddt = date_to.getDate();
            var mmt = date_to.getMonth()+1; 
            var yyyyt = date_to.getFullYear();

        $scope.date_from = new Date(mmf+"-"+ddf+"-"+yyyyf);
        $scope.date_to = new Date(mmt+"-"+ddt+"-"+yyyyt);

        $scope.color='';
        $scope.modal = {
            title : 'Add Event',
            save : 'Save',
            close : 'Cancel',
            color : '#dc2127', 
            date_from : $scope.date_from,
            date_to : $scope.date_to

        };

        ngDialog.openConfirm({
            template: 'CalendarModal',
            className: 'ngdialog-theme-plain custom-widththreefifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;

                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want to add this Event?</p>' +
                                '<div class="ngdialog-buttons">' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">No' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">Yes' +
                                '</button></div>',
                        plain: true,
                        className: 'ngdialog-theme-plain custom-widththreefifty'
                    });

                return nestedConfirmDialog;
            },
            scope: $scope,
            showClose: false
        })
        .then(function(value){
            return false;
        }, function(value){



            var date_from = new Date($scope.modal.date_from);
            var ddf = date_from.getDate();
            var mmf = date_from.getMonth()+1; //January is 0!
            var yyyyf = date_from.getFullYear();

            var date_to = new Date($scope.modal.date_to);
            var ddt = date_to.getDate();
            var mmt = date_to.getMonth()+1; //January is 0!
            var yyyyt = date_to.getFullYear();
           
            $scope.modal.created_by = $scope.profile.pk;
            $scope.modal.description = $scope.modal.description;
            $scope.modal.location = $scope.modal.location;
            $scope.modal.date_from = yyyyf+'-'+mmf+'-'+ddf;
            $scope.modal.date_to = yyyyt+'-'+mmt+'-'+ddt;
           
            var promise = CalendarFactory.save_event($scope.modal);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully added new event', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                get_all_events();
            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to save changes, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    }

    $scope.color_picked = function(color){
        $scope.modal.color = color;
    }
});