var app = angular.module('onload', [
                                    'ngRoute',
                                    'ngCookies',
                                    'angular-md5',
                                    'ngDialog',
                                    'isteven-multi-select',
                                    'ui-notification',
                                    'ngSanitize',
                                    'mgcrea.ngStrap',
                                    'angularFileUpload'
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
    /*.when('/timesheet/manual_logs',
    { 
        controller: 'Manual_logs',
        templateUrl: 'partials/timesheet/manual_logs_filed.html'
    })*/
    .when('/timesheet/leaves',
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
    .when('/admin/cutoff',
    {
        controller: 'Cutoff',
        templateUrl: 'partials/admin/cutoff/index.html'
    })
    .when('/admin/leaves',
    {
        controller: 'Admin_leave',
        templateUrl: 'partials/admin/leaves/index.html'
    })
    .when('/admin/work_days',
    {
        controller: 'Work_days',
        templateUrl: 'partials/admin/work_days/index.html'
    })
    .when('/admin/permissions',
    {
        controller: 'EmployeesPermissions',
        templateUrl: 'partials/admin/permissions/index.html'
    })
    .when('/admin/levels',
    {
        controller: 'Levels',
        templateUrl: 'partials/admin/levels/index.html'
    })
    .when('/management/leaves',
    {
        controller: 'Management_leave',
        templateUrl: 'partials/management/leaves.html'
    })
    .when('/management/manual_logs',
    {
        controller: 'Management_manual_logs',
        templateUrl: 'partials/management/manual_logs.html'
    })
    .when('/management/attrition',
    {
        controller: 'Attritions',
        templateUrl: 'partials/management/attrition.html'
    })
    .when('/management/analytics',
    {
        controller: 'Analytics',
        templateUrl: 'partials/management/analytics.html'
    })
    .otherwise(
    {
        redirectTo: '/'
    })
})

function contains(obj, str) {
    var i = obj.length;
    while (i--) {
        if (obj[i] === str) {
            return true;
        }
    }

    return false;
}