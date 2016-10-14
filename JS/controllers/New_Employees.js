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

    $scope.stype = [
        { pk:'1', sctype:'Primary'},
        { pk:'2', sctype:'Secondary'},
        { pk:'3', sctype:'Tertiary'}
    ];

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

    $scope.saveme = function(){
        alert("asdf");
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
        var date1 = new Date();
            var dd1 = date1.getDate();
            var mm1 = date1.getMonth()+1;
            var yyyy1 = date1.getFullYear();
            var addDate1 = mm1+'-'+dd1+'-'+yyyy1;

            var date2 = new Date();
            var dd2 = date2.getDate();
            var mm2 = date2.getMonth()+1;
            var yyyy2 = date2.getFullYear();
            var addDate2 = mm2+'-'+dd2+'-'+yyyy2;

            var date3 = new Date();
            var dd3 = date3.getDate();
            var mm3 = date3.getMonth()+1;
            var yyyy3 = date3.getFullYear();
            var addDate3 = mm3+'-'+dd3+'-'+yyyy3;

            var date4 = new Date();
            var dd4 = date4.getDate();
            var mm4 = date4.getMonth()+1;
            var yyyy4 = date4.getFullYear();
            var addDate4 = mm4+'-'+dd4+'-'+yyyy4;

            var date5 = new Date();
            var dd5 = date5.getDate();
            var mm5 = date5.getMonth()+1;
            var yyyy5 = date5.getFullYear();
            var addDate5 = mm5+'-'+dd5+'-'+yyyy5;

            var date6 = new Date();
            var dd6 = date6.getDate();
            var mm6 = date6.getMonth()+1;
            var yyyy6 = date6.getFullYear();
            var addDate6 = mm6+'-'+dd6+'-'+yyyy6;

            var date7 = new Date();
            var dd7 = date7.getDate();
            var mm7 = date7.getMonth()+1;
            var yyyy7 = date7.getFullYear();
            var addDate7 = mm7+'-'+dd7+'-'+yyyy7;

            var date8 = new Date();
            var dd8 = date8.getDate();
            var mm8 = date8.getMonth()+1;
            var yyyy8 = date8.getFullYear();
            var addDate8 = mm8+'-'+dd8+'-'+yyyy8;

            var date9 = new Date();
            var dd9 = date9.getDate();
            var mm9 = date9.getMonth()+1;
            var yyyy9 = date9.getFullYear();
            var addDate9 = mm9+'-'+dd9+'-'+yyyy9;

            var date10 = new Date();
            var dd10 = date10.getDate();
            var mm10 = date10.getMonth()+1;
            var yyyy10 = date10.getFullYear();
            var addDate10 = mm10+'-'+dd10+'-'+yyyy10;

            var date11 = new Date();
            var dd11 = date11.getDate();
            var mm11 = date11.getMonth()+1;
            var yyyy11 = date11.getFullYear();
            var addDate11 = mm11+'-'+dd11+'-'+yyyy11;

            var date12 = new Date();
            var dd12 = date12.getDate();
            var mm12 = date12.getMonth()+1;
            var yyyy12 = date12.getFullYear();
            var addDate12 = mm12+'-'+dd12+'-'+yyyy12;

            var date13 = new Date();
            var dd13 = date13.getDate();
            var mm13 = date13.getMonth()+1;
            var yyyy13 = date13.getFullYear();
            var addDate13 = mm13+'-'+dd13+'-'+yyyy13;

            var date14 = new Date();
            var dd14 = date14.getDate();
            var mm14 = date14.getMonth()+1;
            var yyyy14 = date14.getFullYear();
            var addDate14 = mm14+'-'+dd14+'-'+yyyy14;

            var dated = new Date($scope.employee.date_started);
            var dds = dated.getDate();
            var mms = dated.getMonth()+1;
            var yyyys = dated.getFullYear();
            $scope.employee.date_started = mms+'-'+dds+'-'+yyyys;

            var dateb = new Date($scope.employee.birth_date);
            var ddk = dateb.getDate();
            var mmk = dateb.getMonth()+1;
            var yyyyk = dateb.getFullYear();
            $scope.employee.birth_date = mmk+'-'+ddk+'-'+yyyyk;

            $scope.employee.timein_sunday = $filter('date')($scope.employee.timein_sunday, "HH:mm");
            $scope.employee.timein_monday = $filter('date')($scope.employee.timein_monday, "HH:mm");
            $scope.employee.timein_tuesday = $filter('date')($scope.employee.timein_tuesday, "HH:mm");
            $scope.employee.timein_wednesday = $filter('date')($scope.employee.timein_wednesday, "HH:mm");
            $scope.employee.timein_thursday = $filter('date')($scope.employee.timein_thursday, "HH:mm");
            $scope.employee.timein_friday = $filter('date')($scope.employee.timein_friday, "HH:mm");
            $scope.employee.timein_saturday = $filter('date')($scope.employee.timein_saturday, "HH:mm");
            
            $scope.employee.timeout_sunday = $filter('date')($scope.employee.timeout_sunday, "HH:mm");
            $scope.employee.timeout_monday = $filter('date')($scope.employee.timeout_monday, "HH:mm");
            $scope.employee.timeout_tuesday = $filter('date')($scope.employee.timeout_tuesday, "HH:mm");
            $scope.employee.timeout_wednesday = $filter('date')($scope.employee.timeout_wednesday, "HH:mm");
            $scope.employee.timeout_thursday = $filter('date')($scope.employee.timeout_thursday, "HH:mm");
            $scope.employee.timeout_friday = $filter('date')($scope.employee.timeout_friday, "HH:mm");
            $scope.employee.timeout_saturday = $filter('date')($scope.employee.timeout_saturday, "HH:mm");
            
            if ($scope.employee.timein_sunday != null) {$scope.employee.time_insunday = addDate1 + ' ' +  $scope.employee.timein_sunday;}
            else{$scope.employee.time_insunday = null;}
            
            if ($scope.employee.timeout_sunday != null) {$scope.employee.time_outsunday = addDate2 + ' ' +  $scope.employee.timeout_sunday;}
            else{$scope.employee.time_outsunday = null; }
            
            if ($scope.employee.timein_monday != null) {$scope.employee.time_inmonday = addDate3 + ' ' +  $scope.employee.timein_monday;}
            else{$scope.employee.time_inmonday = null; }

            if ($scope.employee.timeout_monday != null) {$scope.employee.time_outmonday = addDate4 + ' ' +  $scope.employee.timeout_monday;}
            else{$scope.employee.time_outmonday = null; }

            if ($scope.employee.timein_tuesday != null) {$scope.employee.time_intuesday = addDate5 + ' ' +  $scope.employee.timein_tuesday;}
            else{$scope.employee.time_intuesday = null; }

            if ($scope.employee.timeout_tuesday != null) {$scope.employee.time_intuesday = addDate6 + ' ' +  $scope.employee.timeout_tuesday;}
            else{$scope.employee.time_intuesday = null; }

            if ($scope.employee.timein_wednesday != null) {$scope.employee.time_inwednesday = addDate7 + ' ' +  $scope.employee.timein_wednesday;}
            else{$scope.employee.time_inwednesday = null; }

            if ($scope.employee.timeout_wednesday != null) {$scope.employee.time_outwednesday = addDate8 + ' ' +  $scope.employee.timeout_wednesday;}
            else{$scope.employee.time_outwednesday = null; }

            if ($scope.employee.timein_thursday != null) {$scope.employee.time_inthursday = addDate9 + ' ' +  $scope.employee.timein_thursday;}
            else{$scope.employee.time_inthursday = null; }

            if ($scope.employee.timeout_thursday != null) {$scope.employee.time_outthursday = addDate10 + ' ' +  $scope.employee.timeout_thursday;}
            else{$scope.employee.time_outthursday = null; }

            if ($scope.employee.timein_friday != null) {$scope.employee.time_infriday = addDate11 + ' ' +  $scope.employee.timein_friday;}
            else{$scope.employee.time_infriday = null; }

            if ($scope.employee.timeout_friday != null) {$scope.employee.time_outfriday = addDate12 + ' ' +  $scope.employee.timeout_friday;}
            else{$scope.employee.time_outfriday = null; }

            if ($scope.employee.timein_saturday != null) {$scope.employee.time_insaturday = addDate13 + ' ' +  $scope.employee.timein_saturday;}
            else{$scope.employee.time_insaturday = null; }

            if ($scope.employee.timeout_saturday != null) {$scope.employee.time_outsaturday = addDate14 + ' ' +  $scope.employee.timeout_saturday;}
            else{$scope.employee.time_outsaturday = null; }

        
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
        education:[{educ_level: "Primary"}],
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