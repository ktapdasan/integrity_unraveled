var app = angular.module('onload', [
                                    'ngRoute',
                                    'ngCookies',
                                    'angular-md5',
                                    'ngDialog',
                                    'isteven-multi-select',
                                    'ui-notification',
                                    'ngSanitize',
                                    'mgcrea.ngStrap',
                                    'angularFileUpload',
                                    'chart.js',
                                    'mwl.calendar',
                                    'colorpicker.module'
                                ]);

app.config(function($routeProvider){
    $routeProvider
    .when('/',
    {
        controller: 'Dashboard',
        templateUrl: 'partials/dashboard/index.html'
    })
    .when('/profile',
    {
        controller: 'Profile',
        templateUrl: 'partials/personal/profile.html'
    })
    .when('/calendar',
    {
        controller: 'Admin_calendar',
        templateUrl: 'partials/admin/calendar/admin.html'
    })
    .when('/timesheet',
    {
        controller: 'Timesheet',
        templateUrl: 'partials/timesheet/index.html'
    })
    /*.when('/timesheet/manual_logs',
    { 
        controller: 'Manual_logs',appro
        templateUrl: 'partials/timesheet/manual_logs_filed.html'
    })*/
    .when('/timesheet/leaves',
    {
        controller: 'Leave',
        templateUrl: 'partials/timesheet/leaves_filed.html'
    })
    .when('/timesheet/overtime',
    {
        controller: 'Employees_overtime',
        templateUrl: 'partials/timesheet/overtime.html'
    })
    .when('/timesheet/dps',
    {
        controller: 'DailyPassSlip',
        templateUrl: 'partials/timesheet/dps.html'
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
    // .when('/admin/cutoff',
    // {
    //     controller: 'Cutoff',
    //     templateUrl: 'partials/admin/cutoff/index.html'
    // })
    .when('/admin/leaves',
    {
        controller: 'Admin_leave',
        templateUrl: 'partials/admin/leaves/index.html'
    })
    .when('/admin/default_values',
    {
        controller: 'Default_values',
        templateUrl: 'partials/admin/default_values/index.html'
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
    .when('/admin/holidays',
    {
        controller: 'admin_Holidays',
        templateUrl: 'partials/admin/holidays/index.html'
    })
    .when('/admin/suspension',
    {
        controller: 'admin_suspension',
        templateUrl: 'partials/admin/suspension/index.html'
    })
    .when('/admin/calendar',
    {
        controller: 'Admin_calendar',
        templateUrl: 'partials/admin/calendar/admin.html'
    })
    .when('/admin/memo',
    {
        controller: 'Admin_memo',
        templateUrl: 'partials/admin/memo/index.html'
    })
    .when('/admin/requests',
    {
        controller: 'Admin_request',
        templateUrl: 'partials/admin/requests/index.html'
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
    .when('/management/overtime',
    {
        controller: 'Management_overtime',
        templateUrl: 'partials/management/over_time.html'
    })
    .when('/management/dps',
    {
        controller: 'Management_DailyPassSlip',
        templateUrl: 'partials/management/dps.html'
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