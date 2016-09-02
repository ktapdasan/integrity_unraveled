app.controller('New_Employees', function(
                                            $scope,
                                            SessionFactory,
                                            EmployeesFactory,
                                            md5,
                                            UINotification
                                        ){

    $scope.pk='';

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

    $scope.titles={};
    $scope.level_title={};
    $scope.department={};
    $scope.employee={
        employee_id:'',
        first_name:'',
        middle_name:'',
        last_name:'',
        titles_pk:'',
        business_email_address:'',
        email_address:'',
        departments_pk:'',
        levels_pk:'',
        supervisor_pk:'',
        civilstatus_pk:'',
        gender_pk:'',
        religion_pk:'',
        employee_type:'',
        employment_type:'',
        data_sss:'',
        data_tin:'',
        data_pagmid:'',
        data_phid:'',
        forms: [{educ_level: "Primary"}]
    };

    $scope.employees = {};
    $scope.filter={};

    $scope.level_class = 'orig_width';
    $scope.show_hours = false;
    $scope.fname1 = '';
    $scope.lname1 = '';

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            get_positions();
            get_department();
            get_levels();
            employees();
            get_supervisors();
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

    function get_positions(){
        var promise = EmployeesFactory.get_positions();
        promise.then(function(data){
            $scope.titles.data = data.data.result;
        })
        .then(null, function(data){

        });
    }

    function get_department(){
        var filter = {archived:false};
        var promise = EmployeesFactory.get_department(filter);
        promise.then(function(data){
            $scope.department.data = data.data.result;
        })
        .then(null, function(data){

        });
    }
    
    function get_genders(){
        var promise = EmployeesFactory.get_genders();
        promise.then(function(data){
            $scope.genders.data = data.data.result;
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


    function employees(){
        $scope.filter.archived = 'false';
        var promise = EmployeesFactory.fetch_all($scope.filter);
        promise.then(function(data){
            $scope.employees.status = true;
            $scope.employees.data = data.data.result;
        })
        .then(null, function(data){
            $scope.employees.status = false;
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

    $scope.addNewChoice = function() {
        if ($scope.employee.school_type == 1){
            $scope.employee.forms.push({educ_level: "Primary"});
            
            }
        else if ($scope.employee.school_type == 2){
            $scope.employee.forms.push({educ_level: "Secondary" });
             
            }
        else if ($scope.employee.school_type == 3){
            $scope.employee.forms.push({educ_level: "Tertiary" });
             
            }
    };

    $scope.submit_employee = function(){

        get_supervisors();

        var promise = EmployeesFactory.submit_employee($scope.employee);
        promise.then(function(data){

            UINotification.success({
                message: $scope.fname1 + ' ' + $scope.lname1 + ' was successfully added.', 
                title: 'SUCCESS', 
                delay : 5000,
                positionY: 'top', positionX: 'right'
            });

        })
        .then(null, function(data){

            UINotification.error({
                message: 'An error occured, please try again.', 
                title: 'ERROR', 
                delay : 5000,
                positionY: 'top', positionX: 'right'
            });
        });

        $scope.employee={
            employee_id:'',
            first_name:'',
            middle_name:'',
            last_name:'',
            titles_pk:'',
            business_email_address:'',
            email_address:'',
            departments_pk:'',
            levels_pk:'',
            supervisor_pk: '',
            civilstatus_pk:'',
            gender_pk:'',
            religion_pk:'',
            employee_type:'',
            employment_type:'',
            data_sss:'',
            data_tin:'',
            data_pagmid:'',
            data_phid:'',
            forms: [{educ_level: "Primary"}]
        };
    }

    $scope.employees.date_started = new Date();
   

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

    $scope.genders = [
    {
        pk:'1',
        gender:'Male'
    },
    {
        pk:'2',
        gender:'Female'
    }
    ];

    $scope.civils = [
    {
        pk:'1',
        civilstatus:'Married'
    },
    {
        pk:'2',
        civilstatus:'Single'
    },
    {
        pk:'3',
        civilstatus:'Divorced'
    },
    {
        pk:'4',
        civilstatus:'Living Common Law'
    },
    {
        pk:'5',
        civilstatus:'Widowed'
    }
    ];

    $scope.estatus = [
    {
        pk:'1',
        emstatus:'Probationary'
    },
    {
        pk:'2',
        emstatus:'Trainee'
    },
    {
        pk:'3',
        emstatus:'Contractual'
    },
    {
        pk:'4',
        emstatus:'Regular'
    },
    {
        pk:'5',
        emstatus:'Consultant'
    }
    ];

    $scope.etype = [
    {
        pk:'1',
        emtype:'Exempt'
    },
    {
        pk:'2',
        emtype:'Non-Exempt'
    }
    ];
    
    $scope.stype = [
    {
        pk:'1',
        sctype:'Primary'
    },
    {
        pk:'2',
        sctype:'Secondary'
    },
     {
        pk:'3',
        sctype:'Tertiary'
    }
    ];
});