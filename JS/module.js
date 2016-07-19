var app = angular.module('onload', [
                                    'ngRoute',
                                    'ngCookies',
                                    'angular-md5',
                                    'ngDialog',
                                    'isteven-multi-select',
                                    'ui-notification',
                                    'ngSanitize',
                                    'mgcrea.ngStrap'
                                            
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
    .when('/timesheet/manual_logs_filed',
    {
        controller: 'Timesheet',
        templateUrl: 'partials/timesheet/manual_logs_filed.html'
    })
    .when('/timesheet/leaves_filed',
    {
        controller: 'Leave',
        templateUrl: 'partials/timesheet/leaves_filed.html'
    })
    .when('/employees/list',
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
    .when('/employees/timesheet',
    {
        controller: 'Timelogs',
        templateUrl: 'partials/timelogs/index.html'
    })
    .when('/admin/departments',
    {
        controller: 'Department',
        templateUrl: 'partials/admin/department/index.html'
    }) 
    .when('/admin/positions',
    {
        controller: 'Position',
        templateUrl: 'partials/admin/position/index.html'
    })
    .when('/employees/permissions',
    {
        controller: 'EmployeesPermissions',
        templateUrl: 'partials/employees/permission.html'
    })
    .when('/admin/levels',
    {
        controller: 'Levels',
        templateUrl: 'partials/admin/levels/index.html'
    })
    .when('/management/leaves',
    {
        controller: 'Leave',
        templateUrl: 'partials/management/leaves.html'
    })
    .when('/management/manual_logs',
    {
        controller: 'Timesheet',
        templateUrl: 'partials/management/manual_logs.html'
    })
    .otherwise(
    {
        redirectTo: '/'
    })
})
