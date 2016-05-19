var app = angular.module('onload', [
                                    'ngRoute',
                                    'ngCookies',
                                    'angular-md5',
                                    'ngDialog',
                                    'isteven-multi-select',
                                    'ui-notification'
                                ]);

app.config(function($routeProvider){
    $routeProvider
    .when('/',
    {
        controller: 'Dashboard',
        templateUrl: 'partials/dashboard/index.html'
    })
    .when('/timesheet',
    {
        controller: 'Timesheet',
        templateUrl: 'partials/timesheet/index.html'
    })
    .when('/timelogs',
    {
        controller: 'Timelogs',
        templateUrl: 'partials/timelogs/index.html'
    })
     .when('/employees',
    {
        controller: 'Employees',
        templateUrl: 'partials/employees/list.html'
    })
     .when('/employees/new',
    {
        controller: 'New_Employees',
        templateUrl: 'partials/employees/new.html'
    })
     .when('/employees/edit',
    {
        controller: 'Employees',
        templateUrl: 'partials/employees/edit.html'
    })
    
    .otherwise(
    {
        redirectTo: '/'
    })
})