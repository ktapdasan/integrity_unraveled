app.controller('New_Employees', function(
                                            $scope,
                                            SessionFactory,
                                            EmployeesFactory,
                                            md5,
                                            UINotification,
                                            FileUploader,
                                            $filter
                                        ){

    $scope.pk='';
    $scope.employee={
        school_type:''
    };
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


    $scope.employees={
        profile_picture:'./ASSETS/img/blank.gif',
        first_name:'',
        middle_name:'',
        last_name:'',
        email_address:'',
        gender:'',
        religion:'',
        civilstatus:'',
        employee_id:'',
        date_started: new Date(),
        business_email_address:'',
        birth_date:'',
        titles_pk:'',
        levels_pk:'',
        supervisor_pk:'',
        departments_pk:'',
        employee_status:'',
        employment_type:'',
        data_sss: null,
        data_phid: null,
        data_pagmid: null,
        data_tin: null,
        intern_hours:'',
        salary_type:'bank',
        bank_name:'',
        account_number:'',
        amount:'',
        mode_payment:'',
        timein_sunday:null,
        timein_monday:null,
        timein_tuesday:null,
        timein_wednesday:null,
        timein_thursday:null,
        timein_friday:null,
        timein_saturday:null,
        timeout_sunday:null,
        timeout_monday:null,
        timeout_tuesday:null,
        timeout_wednesday:null,
        timeout_thursday:null,
        timeout_friday:null,
        timeout_saturday:null,
        permanent_address:'No Data',
        present_address:'No Data',
        emergency_contact_number:null,
        emergency_name:'No Data',
        contact_number:null,
        landline_number:null,
        flexi_sunday:false,
        flexi_monday:false,
        flexi_tuesday:false,
        flexi_wednesday:false,
        flexi_thursday:false,
        flexi_friday:false,
        flexi_saturday:false
    };

    $scope.employees.education = [{educ_level: "Primary"}];
    
    $scope.filter={};

    $scope.level_class = 'orig_width';
    $scope.show_hours = false;
    $scope.data_data = {
        fname:'',
        lname1:''
    };


    $scope.uploader = {};
    $scope.uploader.queue = {};

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

    function get_gender(){
        var promise = EmployeesFactory.get_gender();
        promise.then(function(data){
            $scope.type.data = data.data.result;
            
        })

        .then(null, function(data){

        });
    }

    $scope.addNewChoice = function() {
        if ($scope.employee.school_type == 1){
            $scope.employees.education.push({educ_level: "Primary"});
        }
        else if ($scope.employee.school_type == 2){
            $scope.employees.education.push({educ_level: "Secondary" });
        }
        else if ($scope.employee.school_type == 3){
            $scope.employees.education.push({educ_level: "Tertiary" });
        }
    };
    
    $scope.submit_employees = function(){
        get_supervisors();
        for(var i in $scope.employees.education){
            $scope.employees.education[i].date_from_school = $filter('date')($scope.employees.education[i].date_from_school, "yyyy-MM-dd");
            $scope.employees.education[i].date_to_school = $filter('date')($scope.employees.education[i].date_to_school, "yyyy-MM-dd");
        }
        $scope.employees.date_started = $filter('date')($scope.employees.date_started, "MM-dd-yyyy");
        $scope.employees.birth_date = $filter('date')($scope.employees.birth_date, "MM-dd-yyyy");
        
        $scope.employees.timein_monday = $filter('date')($scope.employees.timein_monday, "yyyy-MM-dd HH:mm");
        $scope.employees.timein_tuesday = $filter('date')($scope.employees.timein_tuesday, "yyyy-MM-dd HH:mm");
        $scope.employees.timein_wednesday = $filter('date')($scope.employees.timein_wednesday, "yyyy-MM-dd HH:mm");
        $scope.employees.timeout_wednesday = $filter('date')($scope.employees.timein_wednesday, "yyyy-MM-dd HH:mm");
        $scope.employees.timein_thursday = $filter('date')($scope.employees.timein_thursday, "yyyy-MM-dd HH:mm");
        $scope.employees.timein_friday = $filter('date')($scope.employees.timein_friday, "yyyy-MM-dd HH:mm");
        $scope.employees.timein_saturday = $filter('date')($scope.employees.timein_saturday, "yyyy-MM-dd HH:mm");
        $scope.employees.timein_sunday = $filter('date')($scope.employees.timein_sunday, "yyyy-MM-dd HH:mm");
        $scope.employees.timeout_sunday = $filter('date')($scope.employees.timeout_sunday, "yyyy-MM-dd HH:mm");
        $scope.employees.timeout_monday = $filter('date')($scope.employees.timeout_monday, "yyyy-MM-dd HH:mm");
        $scope.employees.timeout_tuesday = $filter('date')($scope.employees.timeout_tuesday, "yyyy-MM-dd HH:mm");
        $scope.employees.timeout_thursday = $filter('date')($scope.employees.timeout_thursday, "yyyy-MM-dd HH:mm");
        $scope.employees.timeout_friday = $filter('date')($scope.employees.timeout_friday, "yyyy-MM-dd HH:mm");
        $scope.employees.timeout_saturday = $filter('date')($scope.employees.timeout_saturday, "yyyy-MM-dd HH:mm");
        
        $scope.employees.education = JSON.stringify($scope.employees.education);
       
        var promise = EmployeesFactory.submit_employees($scope.employees);
        promise.then(function(data){

            UINotification.success({
                message: $scope.data_data.fname + ' ' + $scope.data_data.lname1 + ' was successfully added.', 
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

        $scope.employees={
            profile_picture:'./ASSETS/img/blank.gif',
            employee_id:'',
            first_name:'',
            middle_name:'',
            last_name:'',
            email_address:'',
            gender:'',
            birth_date:'',
            religion:'',
            civilstatus:'',
            employee_id:'',
            business_email_address:'',
            titles_pk:'',
            date_started:'',
            levels_pk:'',
            supervisor_pk:'',
            departments_pk:'',
            employee_type:'',
            employment_type:'',
            education: [{educ_level: "Primary"}],
            data_sss: null,
            data_phid: null,
            data_pagmid: null,
            data_tin: null,
            intern_hours:'',
            salary_type:'bank',
            bank_name:'',
            account_number:'',
            amount:'',
            mode_payment:'',
            timein_sunday:null,
            timein_monday:null,
            timein_tuesday:null,
            timein_wednesday:null,
            timein_thursday:null,
            timein_friday:null,
            timein_saturday:null,
            timeout_sunday:null,
            timeout_monday:null,
            timeout_tuesday:null,
            timeout_wednesday:null,
            timeout_thursday:null,
            timeout_friday:null,
            timeout_saturday:null,
            permanent_address:'',
            present_address:'',
            emergency_contact_number:'',
            emergency_name:'',
            contact_number:null,
            landline_number:null,
            flexi_sunday:false,
            flexi_monday:false,
            flexi_tuesday:false,
            flexi_wednesday:false,
            flexi_thursday:false,
            flexi_friday:false,
            flexi_saturday:false
        };
    }

    $scope.level_changed = function(){
        level_changed();
    }

    function level_changed(){
        if ($scope.employees.levels_pk == 3) {
            $scope.level_class = 'hours';
            $scope.show_hours = true;
        }
        else{
            $scope.level_class = 'orig_width';
            $scope.show_hours = false;
        }

    }

    $scope.isShown = function(salarys_type) {
        return salarys_type === $scope.employees.salary_type;
    };

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