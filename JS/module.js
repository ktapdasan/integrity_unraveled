var app = angular.module('onload', ['ngRoute','ngCookies','angular-md5']);

app.config(function($routeProvider){
    $routeProvider
    .when('/time',
    {
        controller: 'Dashboard',
        templateUrl: 'partials/dashboard/index.html'
    })
    .when('/timesheet',
    {
        controller: 'Timesheet',
        templateUrl: 'partials/timesheet/index.html'
    })
    .otherwise(
    {
        redirectTo: '/time'
    })
})