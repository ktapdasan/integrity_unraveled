app.controller('Employees', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        TimelogFactory,
                                        ngDialog,
                                        UINotification,
                                        FileUploader,
                                        md5,
                                        $filter
                                    ){

    $scope.pk='';
    $scope.profile = {};
    $scope.filter = {};
    $scope.filter.status = 'Active';

    $scope.uploader = {};
    $scope.uploader.queue = {};
 

    $scope.titles={};
    $scope.department={};
    $scope.level_title={};
    $scope.groupings= {};

    $scope.employee = {};
    $scope.employees = {};
    $scope.employees.count = 0;
    $scope.employees.filters={};
    $scope.employeesheet_data = [];
    $scope.employee.education = [];
    
    $scope.modal = {};
    $scope.level_class = 'orig_width';
    $scope.show_hours = false;

    $scope.tab = {
        personal : true,
        education : false,
        company : false,
        government : false
    };

    $scope.current = {
        personal : 'current',
        education : '',
        company : '',
        government : ''
    };

    $scope.genders = [
        { pk:'1', gender:'Male'},
        { pk:'2', gender:'Female'}
    ];
    $scope.civils = [
        { pk:'1', civilstatus:'Married'},
        { pk:'2', civilstatus:'Single'},
        { pk:'3', civilstatus:'Divorced'},
        { pk:'4', civilstatus:'Living Common Law'},
        { pk:'5', civilstatus:'Widowed'}
    ];
    $scope.estatus = [
        { pk:'1', emstatus:'Probationary'},
        { pk:'2', emstatus:'Trainee'},
        { pk:'3', emstatus:'Contractual'},
        { pk:'4', emstatus:'Regular'},
        { pk:'5', emstatus:'Consultant'}
    ];
    $scope.etype = [
        { pk:'1', emtype:'Exempt'},
        { pk:'2', emtype:'Non-Exempt'}
    ];

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            get_profile();
            get_positions();
            get_department();
            get_levels();
            get_supervisors();
            //select
            fetch_department();
            fetch_levels();
            fetch_titles();


            
        })
        .then(null, function(data){
            window.location = './login.html';
        });
    }

     $scope.change_tab = function(tab){
        for(var i in $scope.tab){
            $scope.tab[i] = false
            $scope.current[i] = '';
        }

        $scope.tab[tab] = true;
        $scope.current[tab] = 'current';
    }
    
    function get_profile(){
        var filters = { 
            'pk' : $scope.pk
        };

        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){
            $scope.profile = data.data.result[0];
            DEFAULTDATES();
            employees();
            
        })   
    } 


     function DEFAULTDATES(){
        var today = new Date();

        var dd = today.getDate();
        var mm = today.getMonth()+1; //January is 0!
        var yyyy = today.getFullYear();

        if(dd<10) {
            dd='0'+dd
        } 

        if(mm<10) {
            mm='0'+mm
        } 

        today = yyyy+'-'+mm+'-'+dd;

        $scope.filter.date_from = new Date(yyyy+'-'+mm+'-01'); 
        $scope.filter.date_to = new Date();

    }

    function getMonday(d) {
        var d = new Date(d);
        var day = d.getDay(),
            diff = d.getDate() - day + (day == 0 ? -6:1); // adjust when day is sunday

        var new_date = new Date(d.setDate(diff));
        var dd = new_date.getDate();
        var mm = new_date.getMonth()+1; //January is 0!
        var yyyy = new_date.getFullYear();

        if(dd<10) {
            dd='0'+dd
        } 

        if(mm<10) {
            mm='0'+mm
        } 

        var monday = yyyy+'-'+mm+'-'+dd;

        return monday;
    }



    $scope.show_employees = function(){

       employees();
    }

    function employees(){
        
        $scope.filter.archived = 'false';


        var promise = EmployeesFactory.fetch_all($scope.filter);
        promise.then(function(data){
            $scope.employees.status = true;
            //$scope.employees.data = data.data.result;
            
            //$scope.employees.data
            var a = data.data.result;
            for(var i in a){
                a[i].details = JSON.parse(a[i].details);
            }

            $scope.employees.data = a;
            $scope.employees.count = data.data.result.length;
        })
        .then(null, function(data){
            $scope.employees.status = false;
        });

    }

    function get_positions(){
        var promise = EmployeesFactory.get_positions();
        promise.then(function(data){
            $scope.titles.data = data.data.result;
        })
        .then(null, function(data){
            
        });
    }

    function get_department(){
        var filter = {
            archived : false
        }

        var promise = EmployeesFactory.get_department(filter);
        promise.then(function(data){
            $scope.department.data = data.data.result;
        })
        .then(null, function(data){
            
        });
    }

    function get_levels(){
        var promise = EmployeesFactory.get_levels();
        promise.then(function(data){
            $scope.level_title.data = data.data.result;
        })
        .then(null, function(data){
            
        });
    }

    function get_supervisors(){
        var promise = EmployeesFactory.get_supervisors();
        promise.then(function(data){
            $scope.employees.supervisors = data.data.result;
        })
        .then(null, function(data){
            
        });
    }
       
    $scope.export_employees = function(){
        window.open('./FUNCTIONS/Timelog/employees_export.php?pk='+$scope.filter.pk+'&datefrom='+$scope.filter.datefrom+"&dateto="+$scope.filter.dateto);
    }

    // $scope.delete_employees = function(k){

       
    //    $scope.modal = {
    //             title : '',
    //             message: 'Are you sure you want to deactivate this employee?',
    //             save : 'Deactivate',
    //             close : 'Cancel'
    //         };
    //    ngDialog.openConfirm({
    //         template: 'ConfirmModal',
    //         className: 'ngdialog-theme-plain',
            
    //         scope: $scope,
    //         showClose: false
    //     })

        
    //     .then(function(value){
    //         return false;
    //     }, function(value){
    //         var promise = EmployeesFactory.delete_employees($scope.employees.data[k]);
    //         promise.then(function(data){
                
    //             $scope.archived=true;

    //             UINotification.success({
    //                                     message: 'You have successfully deactivated an employees account.', 
    //                                     title: 'SUCCESS', 
    //                                     delay : 5000,
    //                                     positionY: 'top', positionX: 'right'
    //                                 });
    //             employees();

    //         })
    //         .then(null, function(data){
                
    //             UINotification.error({
    //                                     message: 'An error occured, unable to deactivate, please try again.', 
    //                                     title: 'ERROR', 
    //                                     delay : 5000,
    //                                     positionY: 'top', positionX: 'right'
    //                                 });
    //         });         

                            
    //     });
    // }




    $scope.delete_employees = function(k){

       
       $scope.modal = {
                title : '',
                message: 'Deactivate Accounts',
                save : 'Deactivate',
                close : 'Cancel'
            };
    
       ngDialog.openConfirm({
            template: 'DeactivateModal',
            className: 'ngdialog-theme-plain',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;
                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want deactivate?</p>' +
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

            var last_day_work= new Date($scope.modal.last_day_work);
                var dd = last_day_work.getDate();
                var mm= last_day_work.getMonth();
                var yyyy = last_day_work.getFullYear();
            var effective_date= new Date($scope.modal.effective_date);
                var DD= effective_date.getDate();
                var MM = effective_date.getMonth(); 
                var YYYY = effective_date.getFullYear(); 
            

            
            $scope.modal.last_day_work = yyyy+'-'+mm+'-'+dd;
            $scope.modal.effective_date = YYYY+'-'+MM+'-'+DD;
            $scope.modal["created_by"] = $scope.profile.pk;
            $scope.modal["supervisor_pk"] = $scope.profile.supervisor_pk;
            $scope.modal["pk"] =  $scope.employees.data[k].pk;


            var promise = EmployeesFactory.delete_employees($scope.modal);
            promise.then(function(data){
                
                $scope.archived=true;

                UINotification.success({
                                        message: 'You have successfully applied changes to this employee account.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                employees();


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







    $scope.activate_employees = function(k){
       
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to reactivate this employee?',
                save : 'Reactivate',
                close : 'Cancel'
            };
       ngDialog.openConfirm({
            template: 'ConfirmModal',
            className: 'ngdialog-theme-plain',
            
            scope: $scope,
            showClose: false
        })

        
        .then(function(value){
            return false;
        }, function(value){
            var promise = EmployeesFactory.activate_employees($scope.employees.data[k]);
            promise.then(function(data){
                
                $scope.archived=true;

                UINotification.success({
                                        message: 'You have successfully deactivated an employees account.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                employees();

            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to deactivate, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    }

    $scope.edit_employees = function(k){
        get_supervisors();
        $scope.employee = $scope.employees.data[k];
        
        if ($scope.employees.data[k].details.company.work_schedule === undefined) {
            $scope.employees.data[k].details.company.work_schedule = null;
        }
        if($scope.employees.data[k].details.company.work_schedule != null){
            $scope.employee.timein_sunday = $scope.employees.data[k].details.company.work_schedule.sunday.ins;
            $scope.employee.timein_monday = $scope.employees.data[k].details.company.work_schedule.monday.ins;
            $scope.employee.timein_tuesday = $scope.employees.data[k].details.company.work_schedule.tuesday.ins;
            $scope.employee.timein_wednesday = $scope.employees.data[k].details.company.work_schedule.wednesday.ins;
            $scope.employee.timein_thursday = $scope.employees.data[k].details.company.work_schedule.thursday.ins;
            $scope.employee.timein_friday = $scope.employees.data[k].details.company.work_schedule.friday.ins;
            $scope.employee.timein_saturday = $scope.employees.data[k].details.company.work_schedule.saturday.ins;
            $scope.employee.timeout_sunday = $scope.employees.data[k].details.company.work_schedule.sunday.out;
            $scope.employee.timeout_monday = $scope.employees.data[k].details.company.work_schedule.monday.out;
            $scope.employee.timeout_tuesday = $scope.employees.data[k].details.company.work_schedule.tuesday.out;
            $scope.employee.timeout_wednesday = $scope.employees.data[k].details.company.work_schedule.wednesday.out;
            $scope.employee.timeout_thursday = $scope.employees.data[k].details.company.work_schedule.thursday.out;
            $scope.employee.timeout_friday = $scope.employees.data[k].details.company.work_schedule.friday.out;
            $scope.employee.timeout_saturday = $scope.employees.data[k].details.company.work_schedule.saturday.out;

            if ($scope.employees.data[k].details.company.work_schedule.sunday.flexi == 'true') {
                $scope.employee.flexi_sunday = true;
            }
            if ($scope.employees.data[k].details.company.work_schedule.sunday.flexi == 'false') {
                $scope.employee.flexi_sunday = false;
            }
            if ($scope.employees.data[k].details.company.work_schedule.monday.flexi == 'true') {
                $scope.employee.flexi_monday = true;
            }
            if ($scope.employees.data[k].details.company.work_schedule.monday.flexi == 'false') {
                $scope.employee.flexi_monday = false;
            }
            if ($scope.employees.data[k].details.company.work_schedule.tuesday.flexi == 'true') {
                $scope.employee.flexi_tuesday = true;
            }
             if ($scope.employees.data[k].details.company.work_schedule.tuesday.flexi == 'false') {
                $scope.employee.flexi_tuesday = false;
            }
            if ($scope.employees.data[k].details.company.work_schedule.wednesday.flexi == 'true') {
                $scope.employee.flexi_wednesday = true;
            }
            if ($scope.employees.data[k].details.company.work_schedule.wednesday.flexi == 'false') {
                $scope.employee.flexi_wednesday = false;
            }
            if ($scope.employees.data[k].details.company.work_schedule.thursday.flexi == 'true') {
                $scope.employee.flexi_thursday = true;
            }
            if ($scope.employees.data[k].details.company.work_schedule.thursday.flexi == 'false') {
                $scope.employee.flexi_thursday = false;
            }
            if ($scope.employees.data[k].details.company.work_schedule.friday.flexi == 'true') {
                $scope.employee.flexi_friday = true;
            }
            if ($scope.employees.data[k].details.company.work_schedule.friday.flexi == 'false') {
                $scope.employee.flexi_friday = false;
            }
            if ($scope.employees.data[k].details.company.work_schedule.saturday.flexi == 'true') {
                $scope.employee.flexi_saturday = true;
            }
            if ($scope.employees.data[k].details.company.work_schedule.saturday.flexi == 'false') {
                $scope.employee.flexi_saturday = false;
            }
        }
        if ($scope.employees.data[k].details.government === undefined){
            $scope.employees.data[k].details.government = null;
        }
        if($scope.employees.data[k].details.government !== null){
            $scope.employee.data_sss = $scope.employees.data[k].details.government.data_sss;
            $scope.employee.data_tin = $scope.employees.data[k].details.government.data_tin;
            $scope.employee.data_pagmid = $scope.employees.data[k].details.government.data_pagmid;
            $scope.employee.data_phid = $scope.employees.data[k].details.government.data_phid;
        }

        if ($scope.employees.data[k].details.company.hours === undefined) {
            $scope.employees.data[k].details.company.hours = null;
        }
        if ($scope.employees.data[k].details.company.employee_id === undefined) {
            $scope.employees.data[k].details.company.employee_id = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.email_address === undefined) {
            $scope.employees.data[k].details.personal.email_address = 'No Data';
        }
        if ($scope.employees.data[k].details.company.business_email_address === undefined) {
            $scope.employees.data[k].details.company.business_email_address = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.first_name === undefined) {
            $scope.employees.data[k].details.personal.first_name = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.middle_name === undefined) {
            $scope.employees.data[k].details.personal.middle_name = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.last_name === undefined) {
            $scope.employees.data[k].details.personal.last_name = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.gender_pk === undefined) {
            $scope.employees.data[k].details.personal.gender_pk = null;
        }
        if ($scope.employees.data[k].details.personal.religion === undefined) {
            $scope.employees.data[k].details.personal.religion = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.profile_picture === undefined) {
            $scope.employees.data[k].details.personal.profile_picture = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.birth_date === undefined) {
            $scope.employees.data[k].details.personal.birth_date = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.contact_number === undefined) {
            $scope.employees.data[k].details.personal.contact_number = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.profile_picture === undefined) {
            $scope.employees.data[k].details.personal.profile_picture = './ASSETS/img/blank.gif';
        }
        if ($scope.employees.data[k].details.personal.landline_number === undefined) {
            $scope.employees.data[k].details.personal.landline_number = 'No Data';
        }
        if ($scope.employees.data[k].details.company.salary === undefined) {
            $scope.employees.data[k].details.company.salary = null;
        }
        if($scope.employees.data[k].details.company.salary !== null){
            $scope.employee.salary_type            = $scope.employees.data[k].details.company.salary.salary_type;
            $scope.employee.salary_bank_name       = $scope.employees.data[k].details.company.salary.bank_name;
            $scope.employee.salary_account_number  = $scope.employees.data[k].details.company.salary.account_number;
            $scope.employee.salary_mode_payment    = $scope.employees.data[k].details.company.salary.mode_payment;
            $scope.employee.salary_amount          = $scope.employees.data[k].details.company.salary.amount;
        }

        if ($scope.employees.data[k].details.company.employee_status_pk === undefined){
            $scope.employees.data[k].details.company.employee_status_pk = null;
        }
        if ($scope.employees.data[k].details.company.employment_type_pk === undefined){
            $scope.employees.data[k].details.company.employment_type_pk = null;
        }
        if ($scope.employees.data[k].details.company.date_started === undefined){
            $scope.employees.data[k].details.company.date_started = null;
        }
        if ($scope.employees.data[k].details.personal.present_address === undefined){
            $scope.employees.data[k].details.personal.present_address = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.permanent_address === undefined){
            $scope.employees.data[k].details.personal.permanent_address = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.emergency_contact_name === undefined){
            $scope.employees.data[k].details.personal.emergency_contact_name = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.emergency_contact_number === undefined){
            $scope.employees.data[k].details.personal.emergency_contact_number = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.civilstatus_pk === undefined){
            $scope.employees.data[k].details.personal.civilstatus_pk = null;
        }

        $scope.employee.intern_hours           = $scope.employees.data[k].details.company.hours;
        $scope.employee.employee_id            = $scope.employees.data[k].details.company.employee_id;
        $scope.employee.email_address          = $scope.employees.data[k].details.personal.email_address;
        $scope.employee.business_email_address = $scope.employees.data[k].details.company.business_email_address; 
        $scope.employee.first_name             = $scope.employees.data[k].details.personal.first_name;
        $scope.employee.middle_name            = $scope.employees.data[k].details.personal.middle_name;
        $scope.employee.last_name              = $scope.employees.data[k].details.personal.last_name;
        $scope.employee.contact_number         = $scope.employees.data[k].details.personal.contact_number;
        $scope.employee.landline_number        = $scope.employees.data[k].details.personal.landline_number;
        $scope.employee.present_address        = $scope.employees.data[k].details.personal.present_address;
        $scope.employee.permanent_address      = $scope.employees.data[k].details.personal.permanent_address;
        $scope.employee.profile_picture        = $scope.employees.data[k].details.personal.profile_picture;
        $scope.employee.departments_pk         = $scope.employees.data[k].details.company.departments_pk;
        $scope.employee.levels_pk              = $scope.employees.data[k].details.company.levels_pk;
        $scope.employee.titles_pk              = $scope.employees.data[k].details.company.titles_pk;
        $scope.employee.gender_pk              = $scope.employees.data[k].details.personal.gender_pk;
        $scope.employee.religion               = $scope.employees.data[k].details.personal.religion;
        $scope.employee.employee_status_pk     = $scope.employees.data[k].details.company.employee_status_pk;
        $scope.employee.employment_type_pk     = $scope.employees.data[k].details.company.employment_type_pk;
        $scope.employee.civilstatus_pk         = $scope.employees.data[k].details.personal.civilstatus_pk;
        $scope.employee.birth_date             = new Date($scope.employees.data[k].details.personal.birth_date);
        $scope.employee.date_started           = new Date($scope.employees.data[k].details.company.date_started);
        $scope.employee.emergency_name         = $scope.employees.data[k].details.personal.emergency_contact_name;
        $scope.employee.emergency_contact_number  = $scope.employees.data[k].details.personal.emergency_contact_number;

        $scope.isShown = function(salarys_type) {
            return salarys_type === $scope.employee.salary_type;
        };
       
        level_changed();
        $scope.modal = {
            title : 'Edit ' + $scope.employees.data[k].first_name,
            save : 'Apply Changes',
            close : 'Cancel',
        };
        ngDialog.openConfirm({
            template: 'EditModal',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;

                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want to apply changes to this employee account?</p>' +
                                '<div class="ngdialog-buttons">' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">No' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">Yes' +
                                '</button></div>',
                        plain: true,
                        className: 'ngdialog-theme-plain'
                    });

                return nestedConfirmDialog;
            },
            scope: $scope,
            showClose: false
        })
        .then(function(value){
            return false;
        }, function(value){
            
            //Date Started Filter
            var dated = new Date($scope.employee.date_started);
            var dds = dated.getDate();
            var mms = dated.getMonth()+1;
            var yyyys = dated.getFullYear();
            $scope.employee.date_started = mms+'-'+dds+'-'+yyyys;

            //Birth Date Filter
            var dateb = new Date($scope.employee.birth_date);
            var ddk = dateb.getDate();
            var mmk = dateb.getMonth()+1;
            var yyyyk = dateb.getFullYear();
            $scope.employee.birth_date = mmk+'-'+ddk+'-'+yyyyk;

            //WorkHours Monday
            $scope.employee.timein_monday = $filter('date')($scope.employee.timein_monday, "yyyy-MM-dd HH:mm");
            $scope.employee.timein_tuesday = $filter('date')($scope.employee.timein_tuesday, "yyyy-MM-dd HH:mm");
            $scope.employee.timein_wednesday = $filter('date')($scope.employee.timein_wednesday, "yyyy-MM-dd HH:mm");
            $scope.employee.timeout_wednesday = $filter('date')($scope.employee.timein_wednesday, "yyyy-MM-dd HH:mm");
            $scope.employee.timein_thursday = $filter('date')($scope.employee.timein_thursday, "yyyy-MM-dd HH:mm");
            $scope.employee.timein_friday = $filter('date')($scope.employee.timein_friday, "yyyy-MM-dd HH:mm");
            $scope.employee.timein_saturday = $filter('date')($scope.employee.timein_saturday, "yyyy-MM-dd HH:mm");
            $scope.employee.timein_sunday = $filter('date')($scope.employee.timein_sunday, "yyyy-MM-dd HH:mm");
            $scope.employee.timeout_sunday = $filter('date')($scope.employee.timeout_sunday, "yyyy-MM-dd HH:mm");
            $scope.employee.timeout_monday = $filter('date')($scope.employee.timeout_monday, "yyyy-MM-dd HH:mm");
            $scope.employee.timeout_tuesday = $filter('date')($scope.employee.timeout_tuesday, "yyyy-MM-dd HH:mm");
            $scope.employee.timeout_thursday = $filter('date')($scope.employee.timeout_thursday, "yyyy-MM-dd HH:mm");
            $scope.employee.timeout_friday = $filter('date')($scope.employee.timeout_friday, "yyyy-MM-dd HH:mm");
            $scope.employee.timeout_saturday = $filter('date')($scope.employee.timeout_saturday, "yyyy-MM-dd HH:mm");
            
            var promise = EmployeesFactory.edit_employees($scope.employee);
            promise.then(function(data){
                

                $scope.archived=true;

                UINotification.success({
                                        message: 'You have successfully applied changes to ' + $scope.employee.first_name + ' ' + $scope.employee.last_name, 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                employees();


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
     $scope.view_employees = function(k){

        get_supervisors();

       $scope.employee = $scope.employees.data[k];
        
        if ($scope.employees.data[k].details.company.work_schedule === undefined) {
            $scope.employees.data[k].details.company.work_schedule = null;
        }
        if($scope.employees.data[k].details.company.work_schedule != null){
            $scope.employee.timein_sunday = $scope.employees.data[k].details.company.work_schedule.sunday.ins;
            $scope.employee.timein_monday = $scope.employees.data[k].details.company.work_schedule.monday.ins;
            $scope.employee.timein_tuesday = $scope.employees.data[k].details.company.work_schedule.tuesday.ins;
            $scope.employee.timein_wednesday = $scope.employees.data[k].details.company.work_schedule.wednesday.ins;
            $scope.employee.timein_thursday = $scope.employees.data[k].details.company.work_schedule.thursday.ins;
            $scope.employee.timein_friday = $scope.employees.data[k].details.company.work_schedule.friday.ins;
            $scope.employee.timein_saturday = $scope.employees.data[k].details.company.work_schedule.saturday.ins;
            $scope.employee.timeout_sunday = $scope.employees.data[k].details.company.work_schedule.sunday.out;
            $scope.employee.timeout_monday = $scope.employees.data[k].details.company.work_schedule.monday.out;
            $scope.employee.timeout_tuesday = $scope.employees.data[k].details.company.work_schedule.tuesday.out;
            $scope.employee.timeout_wednesday = $scope.employees.data[k].details.company.work_schedule.wednesday.out;
            $scope.employee.timeout_thursday = $scope.employees.data[k].details.company.work_schedule.thursday.out;
            $scope.employee.timeout_friday = $scope.employees.data[k].details.company.work_schedule.friday.out;
            $scope.employee.timeout_saturday = $scope.employees.data[k].details.company.work_schedule.saturday.out;

            if ($scope.employees.data[k].details.company.work_schedule.sunday.flexi == 'true') {
                $scope.employee.flexi_sunday = true;
            }
            if ($scope.employees.data[k].details.company.work_schedule.sunday.flexi == 'false') {
                $scope.employee.flexi_sunday = false;
            }
            if ($scope.employees.data[k].details.company.work_schedule.monday.flexi == 'true') {
                $scope.employee.flexi_monday = true;
            }
            if ($scope.employees.data[k].details.company.work_schedule.monday.flexi == 'false') {
                $scope.employee.flexi_monday = false;
            }
            if ($scope.employees.data[k].details.company.work_schedule.tuesday.flexi == 'true') {
                $scope.employee.flexi_tuesday = true;
            }
             if ($scope.employees.data[k].details.company.work_schedule.tuesday.flexi == 'false') {
                $scope.employee.flexi_tuesday = false;
            }
            if ($scope.employees.data[k].details.company.work_schedule.wednesday.flexi == 'true') {
                $scope.employee.flexi_wednesday = true;
            }
            if ($scope.employees.data[k].details.company.work_schedule.wednesday.flexi == 'false') {
                $scope.employee.flexi_wednesday = false;
            }
            if ($scope.employees.data[k].details.company.work_schedule.thursday.flexi == 'true') {
                $scope.employee.flexi_thursday = true;
            }
            if ($scope.employees.data[k].details.company.work_schedule.thursday.flexi == 'false') {
                $scope.employee.flexi_thursday = false;
            }
            if ($scope.employees.data[k].details.company.work_schedule.friday.flexi == 'true') {
                $scope.employee.flexi_friday = true;
            }
            if ($scope.employees.data[k].details.company.work_schedule.friday.flexi == 'false') {
                $scope.employee.flexi_friday = false;
            }
            if ($scope.employees.data[k].details.company.work_schedule.saturday.flexi == 'true') {
                $scope.employee.flexi_saturday = true;
            }
            if ($scope.employees.data[k].details.company.work_schedule.saturday.flexi == 'false') {
                $scope.employee.flexi_saturday = false;
            }
        }
        if ($scope.employees.data[k].details.government === undefined){
            $scope.employees.data[k].details.government = null;
        }
        if($scope.employees.data[k].details.government !== null){
            $scope.employee.data_sss = $scope.employees.data[k].details.government.data_sss;
            $scope.employee.data_tin = $scope.employees.data[k].details.government.data_tin;
            $scope.employee.data_pagmid = $scope.employees.data[k].details.government.data_pagmid;
            $scope.employee.data_phid = $scope.employees.data[k].details.government.data_phid;
        }

        if ($scope.employees.data[k].details.company.hours === undefined) {
            $scope.employees.data[k].details.company.hours = null;
        }
        if ($scope.employees.data[k].details.company.employee_id === undefined) {
            $scope.employees.data[k].details.company.employee_id = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.email_address === undefined) {
            $scope.employees.data[k].details.personal.email_address = 'No Data';
        }
        if ($scope.employees.data[k].details.company.business_email_address === undefined) {
            $scope.employees.data[k].details.company.business_email_address = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.first_name === undefined) {
            $scope.employees.data[k].details.personal.first_name = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.middle_name === undefined) {
            $scope.employees.data[k].details.personal.middle_name = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.last_name === undefined) {
            $scope.employees.data[k].details.personal.last_name = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.gender_pk === undefined) {
            $scope.employees.data[k].details.personal.gender_pk = null;
        }
        if ($scope.employees.data[k].details.personal.religion === undefined) {
            $scope.employees.data[k].details.personal.religion = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.profile_picture === undefined) {
            $scope.employees.data[k].details.personal.profile_picture = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.birth_date === undefined) {
            $scope.employees.data[k].details.personal.birth_date = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.contact_number === undefined) {
            $scope.employees.data[k].details.personal.contact_number = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.profile_picture === undefined) {
            $scope.employees.data[k].details.personal.profile_picture = './ASSETS/img/blank.gif';
        }
        if ($scope.employees.data[k].details.personal.landline_number === undefined) {
            $scope.employees.data[k].details.personal.landline_number = 'No Data';
        }
        if ($scope.employees.data[k].details.company.salary === undefined) {
            $scope.employees.data[k].details.company.salary = null;
        }
        if($scope.employees.data[k].details.company.salary !== null){

            $scope.employee.salary_type            = $scope.employees.data[k].details.company.salary.salary_type;
            $scope.employee.salary_bank_name       = $scope.employees.data[k].details.company.salary.bank_name;
            $scope.employee.salary_account_number  = $scope.employees.data[k].details.company.salary.account_number;
            $scope.employee.salary_mode_payment    = $scope.employees.data[k].details.company.salary.mode_payment;
            $scope.employee.salary_amount          = $scope.employees.data[k].details.company.salary.amount;
        }

        if ($scope.employees.data[k].details.company.employee_status_pk === undefined){
            $scope.employees.data[k].details.company.employee_status_pk = null;
        }
        if ($scope.employees.data[k].details.company.employment_type_pk === undefined){
            $scope.employees.data[k].details.company.employment_type_pk = null;
        }
        if ($scope.employees.data[k].details.company.date_started === undefined){
            $scope.employees.data[k].details.company.date_started = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.present_address === undefined){
            $scope.employees.data[k].details.personal.present_address = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.permanent_address === undefined){
            $scope.employees.data[k].details.personal.permanent_address = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.emergency_contact_name === undefined){
            $scope.employees.data[k].details.personal.emergency_contact_name = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.emergency_contact_number === undefined){
            $scope.employees.data[k].details.personal.emergency_contact_number = 'No Data';
        }
        if ($scope.employees.data[k].details.personal.civilstatus_pk === undefined){
            $scope.employees.data[k].details.personal.civilstatus_pk = null;
        }

        $scope.employee.intern_hours           = $scope.employees.data[k].details.company.hours;
        $scope.employee.employee_id            = $scope.employees.data[k].details.company.employee_id;
        $scope.employee.email_address          = $scope.employees.data[k].details.personal.email_address;
        $scope.employee.business_email_address = $scope.employees.data[k].details.company.business_email_address; 
        $scope.employee.first_name             = $scope.employees.data[k].details.personal.first_name;
        $scope.employee.middle_name            = $scope.employees.data[k].details.personal.middle_name;
        $scope.employee.last_name              = $scope.employees.data[k].details.personal.last_name;
        $scope.employee.contact_number         = $scope.employees.data[k].details.personal.contact_number;
        $scope.employee.landline_number        = $scope.employees.data[k].details.personal.landline_number;
        $scope.employee.present_address        = $scope.employees.data[k].details.personal.present_address;
        $scope.employee.permanent_address      = $scope.employees.data[k].details.personal.permanent_address;
        $scope.employee.profile_picture        = $scope.employees.data[k].details.personal.profile_picture;
        $scope.employee.departments_pk         = $scope.employees.data[k].details.company.departments_pk;
        $scope.employee.levels_pk              = $scope.employees.data[k].details.company.levels_pk;
        $scope.employee.titles_pk              = $scope.employees.data[k].details.company.titles_pk;
        $scope.employee.gender_pk              = $scope.employees.data[k].details.personal.gender_pk;
        $scope.employee.religion               = $scope.employees.data[k].details.personal.religion;
        $scope.employee.employee_status_pk     = $scope.employees.data[k].details.company.employee_status_pk;
        $scope.employee.employment_type_pk     = $scope.employees.data[k].details.company.employment_type_pk;
        $scope.employee.civilstatus_pk         = $scope.employees.data[k].details.personal.civilstatus_pk;
        $scope.employee.birth_date             = $scope.employees.data[k].details.personal.birth_date;
        $scope.employee.date_started           = $scope.employees.data[k].details.company.date_started;
        $scope.employee.emergency_name         = $scope.employees.data[k].details.personal.emergency_contact_name;
        $scope.employee.emergency_contact_number  = $scope.employees.data[k].details.personal.emergency_contact_number;

        if ($scope.employee.salary_type != null || $scope.employee.salary_type != undefined){
        $scope.isShown = function(salarys_type) {
            return salarys_type === $scope.employee.salary_type;
            };
        }
        //Ken can only understand this below:D
        $scope.minus = 1;
        $scope.minus_20 = 20;

        console.log($scope.level_title.data[$scope.employee.levels_pk].level_title);
        $scope.employee.titles_pk = parseInt($scope.employee.titles_pk) - parseInt($scope.minus);
        $scope.employee.titles = $scope.titles.data[$scope.employee.titles_pk].title;
        
        $scope.employee.levels_pk = parseInt($scope.employee.levels_pk) - parseInt($scope.minus);
        $scope.employee.levels = $scope.level_title.data[$scope.employee.levels_pk].level_title;
        
        $scope.employee.departments_pk = parseInt($scope.employee.departments_pk) - parseInt($scope.minus_20);
        $scope.employee.departments = $scope.department.data[$scope.employee.departments_pk].department;
        
        if ($scope.employee.employee_status_pk != null) {
            $scope.employee.employee_status_pk = parseInt($scope.employee.employee_status_pk) - parseInt($scope.minus);
            $scope.employee.employee_statuses = $scope.estatus[$scope.employee.employee_status_pk].emstatus;
        }
        else if ($scope.employee.employee_status_pk == null) {
            $scope.employee.employee_statuses = 'No Data';
        }

        if ($scope.employee.employment_type_pk != null) {
            $scope.employee.employment_type_pk = parseInt($scope.employee.employment_type_pk) - parseInt($scope.minus);
            $scope.employee.employment_types = $scope.etype[$scope.employee.employment_type_pk].emtype;
        }
        else if ($scope.employee.employment_type_pk == null) {
            $scope.employee.employment_types = 'No Data';
        }
        if ($scope.employee.gender_pk != null) {
            $scope.employee.gender_pk = parseInt($scope.employee.gender_pk) - parseInt($scope.minus);
            $scope.employee.gender_types = $scope.genders[$scope.employee.gender_pk].gender;
        }
        else if ($scope.employee.gender_pk == null) {
            $scope.employee.gender_types = 'No Data';
        }

        if ($scope.employee.civilstatus_pk != null) {
            $scope.employee.civilstatus_pk = parseInt($scope.employee.civilstatus_pk) - parseInt($scope.minus);
            $scope.employee.civil_statuses = $scope.civils[$scope.employee.civilstatus_pk].civilstatus;
        }
        else if ($scope.employee.civilstatus_pk == null) {
            $scope.employee.civil_statuses = 'No Data';
        }
        
        $scope.modal = {
            title : 'View ' + $scope.employees.data[k].first_name,
            close : 'Close',
        };
        ngDialog.openConfirm({
            template: 'ViewModal',
            scope: $scope,
            showClose: false
        })
    }
    
    $scope.export_employeelist = function(){
        //var flag = true;
        //list();
        // $scope.url ="./FUNCTIONS/Employees/employeelist_export.php?&status=Active &department="+$scope.filter.department+'&titles='+$scope.filter.title+'&level_title='+$scope.filter.level_title;
        
        var filters=[];
        if($scope.filter.department[0]){
            filters.push('&departments_pk=' + $scope.filter.department[0].pk);
        }

        if($scope.filter.level_title[0]){
            filters.push('&levels_pk=' + $scope.filter.level_title[0].pk);
        }

        if($scope.filter.titles[0]){
            filters.push('&titles_pk=' + $scope.filter.titles[0].pk);
        }

        window.open('./FUNCTIONS/Employees/employeelist_export.php?&status=Active' + filters.join(''));
   
    }

    $scope.level_changed = function(){
        level_changed();
    }

    function level_changed(){
        if ($scope.employee.levels_pk == 3) {
            $scope.level_class = 'hours';
            $scope.show_hours = true;
        }
        else{
           $scope.level_class = 'orig_width';
            $scope.show_hours = false;
        }
    
    }

    $scope.show_list = function(){
        list();        
    }

    function list(){
        $scope.filter.pk = $scope.profile.pk;
 /*       
        delete $scope.filter.employees_pk;
        if($scope.filter.employee.length > 0){
            $scope.filter.employees_pk = $scope.filter.employee[0].pk;
        }*/
        
        delete $scope.filter.departments_pk;
        if($scope.filter.department.length > 0){
            $scope.filter.departments_pk = $scope.filter.department[0].pk;  
        }
 
        delete $scope.filter.titles_pk;
        if($scope.filter.titles.length > 0){
            $scope.filter.titles_pk = $scope.filter.titles[0].pk;
        }

        delete $scope.filter.levels_pk;
        if($scope.filter.level_title.length > 0){
            $scope.filter.levels_pk = $scope.filter.level_title[0].pk;
        }

        
        employees();
    }
    
    function fetch_department(){
        var filter = {
            archived : false
        }

        var promise = EmployeesFactory.get_department(filter);
        promise.then(function(data){
            var a = data.data.result;
            $scope.employees.filters.department=[];
            for(var i in a){
                $scope.employees.filters.department.push({
                                            pk: a[i].pk,
                                            name: a[i].department,
                                            ticked: false
                                        });
            }

        })
        .then(null, function(data){
            
        });
    }


    function fetch_levels(){
        var promise = EmployeesFactory.get_levels();
        promise.then(function(data){
            var a = data.data.result;
            $scope.employees.filters.level_title=[];
            for(var i in a){
                $scope.employees.filters.level_title.push({
                                            pk: a[i].pk,
                                            name: a[i].level_title,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            
        });
    }


    function fetch_titles(){
        var promise = EmployeesFactory.get_positions();
        promise.then(function(data){
             var a = data.data.result;
            $scope.employees.filters.titles=[];
            for(var i in a){
                $scope.employees.filters.titles.push({
                                            pk: a[i].pk,
                                            name: a[i].title,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            
        });
    }

    /*
    UPLOADER
    */
    var uploader = $scope.uploader = new FileUploader({
        url: 'FUNCTIONS/Employees/upload_profile_pic.php'
    });

    // FILTERS

    uploader.filters.push({
        name: 'customFilter',
        fn: function(item /*{File|FileLikeObject}*/, options) {
            return this.queue.length < 10;
        }
    });

    // CALLBACKS

    uploader.onWhenAddingFileFailed = function(item /*{File|FileLikeObject}*/, filter, options) {
        //console.info('onWhenAddingFileFailed', item, filter, options);
    };
    uploader.onAfterAddingFile = function(fileItem) {
        //console.info('onAfterAddingFile', fileItem);
    };
    uploader.onAfterAddingAll = function(addedFileItems) {
        //console.info('onAfterAddingAll', addedFileItems);
    };
    uploader.onBeforeUploadItem = function(item) {
        //console.info('onBeforeUploadItem', item);
    };
    uploader.onProgressItem = function(fileItem, progress) {
        //console.info('onProgressItem', fileItem, progress);
    };
    uploader.onProgressAll = function(progress) {
        //console.info('onProgressAll', progress);
    };
    uploader.onSuccessItem = function(fileItem, response, status, headers) {
        //console.info('onSuccessItem', fileItem, response, status, headers);
    };
    uploader.onErrorItem = function(fileItem, response, status, headers) {
        //console.info('onErrorItem', fileItem, response, status, headers);
    };
    uploader.onCancelItem = function(fileItem, response, status, headers) {
        //console.info('onCancelItem', fileItem, response, status, headers);
    };
    uploader.onCompleteItem = function(fileItem, response, status, headers) {
        //console.info('onCompleteItem', fileItem, respsonse, status, headers);
        //$scope.data.quotationmodal.attachment = response.file;
        $scope.employees.profile_picture = response.file;
        //console.log(response);
    };
    uploader.onCompleteAll = function() {
        //console.info('onCompleteAll');
    };
    /*
    END OF UPLOADER
    */

});