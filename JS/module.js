var app = angular.module('onload', ['ngRoute','ngCookies','angular-md5']);

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
    .otherwise(
    {
        redirectTo: '/'
    })
})