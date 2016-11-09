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
        school_type:'',
        seminar:''
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
    $scope.max_employee_id={};
    $scope.add_one_employee_id={};
    $scope.employment_type={};
    $scope.employee_status={};
    $scope.rate_type={};
    $scope.pay_period={};

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
        salary_type:'4',
        bank_name:'',
        pay_period:'',
        rate_type:'',
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
        emergency_contact_number:null,
        emergency_name:'',
        leave_balance:'{"1": "0", "3": "0", "4": "0", "5": "0", "7": "0"}',
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
    $scope.employees.seminar_training = [];

    $scope.filter={};

    $scope.level_class = 'orig_width';
    $scope.show_hours = false;
    $scope.data_data = {
        fname:'',
        lname1:''
    };


    $scope.uploader = {};
    $scope.uploader.queue = {};

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
            get_employment_type();
            get_employment_statuses();
            get_rate_type();
            get_pay_period();
            get_positions();
            get_department();
            get_levels();
            employees();
            get_supervisors();
            get_max_employee_id();
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

    function get_max_employee_id(){
        var promise = EmployeesFactory.get_max_employee_id();
        promise.then(function(data){
            $scope.max_employee_id.data = data.data.result;
            $scope.add_one_employee_id = parseInt($scope.max_employee_id.data[0].employee_id) + 1;
            $scope.employees.employee_id = $scope.add_one_employee_id.toString();
        })
        .then(null, function(data){

        });
    }

    function get_employment_type(){
        var promise = EmployeesFactory.get_employment_type();
        promise.then(function(data){
            $scope.employment_type.data = data.data.result;
        })
        .then(null, function(data){

        });
    }

    function get_employment_statuses(){
        var promise = EmployeesFactory.get_employment_statuses();
        promise.then(function(data){
            $scope.employee_status.data = data.data.result;
        })
        .then(null, function(data){

        });
    }

    function get_rate_type(){
        var promise = EmployeesFactory.get_rate_type();
        promise.then(function(data){
            $scope.rate_type.data = data.data.result;
        })
        .then(null, function(data){

        });
    }

    function get_pay_period(){
        var promise = EmployeesFactory.get_pay_period();
        promise.then(function(data){
            $scope.pay_period.data = data.data.result;
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
    $scope.addNewChoice1 = function() {
        if ($scope.employee.seminar == 1){
            $scope.employees.seminar_training.push({type: "Seminar"});
        }
        else if ($scope.employee.seminar == 2){
            $scope.employees.seminar_training.push({type: "Training" });
        }
    };

    $scope.removeChoice = function (z) {
        //var lastItem = $scope.choiceSet.choices.length - 1;
        $scope.employees.education.splice(z,1);
    };
    $scope.removeChoice1 = function (z) {
        //var lastItem = $scope.choiceSet.choices.length - 1;
        $scope.employees.seminar_training.splice(z,1);
    };

    $scope.submit_employees = function(){
        get_supervisors();
        get_employment_type();
        get_employment_statuses();
        get_rate_type();
        get_pay_period();
        
        for(var i in $scope.employees.education){
            $scope.employees.education[i].date_from_school = $filter('date')($scope.employees.education[i].date_from_school, "yyyy-MM-dd");
            $scope.employees.education[i].date_to_school = $filter('date')($scope.employees.education[i].date_to_school, "yyyy-MM-dd");
        }

        if ($scope.employees.data_sss == null) {
            $scope.employees.data_sss = 'No Data';
        }
        if ($scope.employees.data_phid == null) {
            $scope.employees.data_phid = 'No Data';
        }
        if ($scope.employees.data_pagmid == null) {
            $scope.employees.data_pagmid = 'No Data';
        }
        if ($scope.employees.data_tin == null) {
            $scope.employees.data_tin = 'No Data';
        }

        var dated = new Date($scope.employees.date_started);
        var dds = dated.getDate();
        var mms = dated.getMonth()+1;
        var yyyys = dated.getFullYear();
        $scope.employees.date_started = mms+'-'+dds+'-'+yyyys;

        var dateb = new Date($scope.employees.birth_date);
        var ddk = dateb.getDate();
        var mmk = dateb.getMonth()+1;
        var yyyyk = dateb.getFullYear();
        $scope.employees.birth_date = mmk+'-'+ddk+'-'+yyyyk;

        $scope.employees.timein_sunday = $filter('date')($scope.employees.timein_sunday, "HH:mm");
        $scope.employees.timein_monday = $filter('date')($scope.employees.timein_monday, "HH:mm");
        $scope.employees.timein_tuesday = $filter('date')($scope.employees.timein_tuesday, "HH:mm");
        $scope.employees.timein_wednesday = $filter('date')($scope.employees.timein_wednesday, "HH:mm");
        $scope.employees.timein_thursday = $filter('date')($scope.employees.timein_thursday, "HH:mm");
        $scope.employees.timein_friday = $filter('date')($scope.employees.timein_friday, "HH:mm");
        $scope.employees.timein_saturday = $filter('date')($scope.employees.timein_saturday, "HH:mm");

        $scope.employees.timeout_sunday = $filter('date')($scope.employees.timeout_sunday, "HH:mm");
        $scope.employees.timeout_monday = $filter('date')($scope.employees.timeout_monday, "HH:mm");
        $scope.employees.timeout_tuesday = $filter('date')($scope.employees.timeout_tuesday, "HH:mm");
        $scope.employees.timeout_wednesday = $filter('date')($scope.employees.timeout_wednesday, "HH:mm");
        $scope.employees.timeout_thursday = $filter('date')($scope.employees.timeout_thursday, "HH:mm");
        $scope.employees.timeout_friday = $filter('date')($scope.employees.timeout_friday, "HH:mm");
        $scope.employees.timeout_saturday = $filter('date')($scope.employees.timeout_saturday, "HH:mm");

        if ($scope.employees.timein_sunday == 'null' || $scope.employees.timein_sunday == undefined || $scope.employees.flexi_sunday == true) {$scope.employees.timein_sunday = 'data'};
        if ($scope.employees.timein_monday == 'null' || $scope.employees.timein_monday == undefined || $scope.employees.flexi_monday == true) {$scope.employees.timein_monday = 'data'};
        if ($scope.employees.timein_tuesday == 'null'|| $scope.employees.timein_tuesday == undefined || $scope.employees.flexi_tuesday == true) {$scope.employees.timein_tuesday = 'data'};
        if ($scope.employees.timein_wednesday == 'null'|| $scope.employees.timein_wednesday == undefined || $scope.employees.flexi_wednesday == true) {$scope.employees.timein_wednesday = 'data'};
        if ($scope.employees.timein_thursday == 'null' || $scope.employees.timein_thursday == undefined || $scope.employees.flexi_thursday == true) {$scope.employees.timein_thursday = 'data'};
        if ($scope.employees.timein_friday == 'null' || $scope.employees.timein_friday == undefined || $scope.employees.flexi_friday == true) {$scope.employees.timein_friday = 'data'};
        if ($scope.employees.timein_saturday == 'null' || $scope.employees.timein_saturday == undefined || $scope.employees.flexi_saturday == true) {$scope.employees.timein_saturday = 'data'};

        if ($scope.employees.timeout_sunday == 'null' || $scope.employees.timeout_sunday == undefined || $scope.employees.flexi_sunday == true) {$scope.employees.timeout_sunday = 'data'};
        if ($scope.employees.timeout_monday == 'null' || $scope.employees.timeout_monday == undefined || $scope.employees.flexi_monday == true) {$scope.employees.timeout_monday = 'data'};
        if ($scope.employees.timeout_tuesday == 'null' || $scope.employees.timeout_tuesday == undefined || $scope.employees.flexi_tuesday == true) {$scope.employees.timeout_tuesday = 'data'};
        if ($scope.employees.timeout_wednesday == 'null' || $scope.employees.timeout_wednesday == undefined || $scope.employees.flexi_wednesday == true) {$scope.employees.timeout_wednesday = 'data'};
        if ($scope.employees.timeout_thursday == 'null' || $scope.employees.timeout_thursday == undefined || $scope.employees.flexi_thursday == true) {$scope.employees.timeout_thursday = 'data'};
        if ($scope.employees.timeout_friday == 'null' || $scope.employees.timeout_friday == undefined || $scope.employees.flexi_friday == true) {$scope.employees.timeout_friday = 'data'};
        if ($scope.employees.timeout_saturday == 'null' || $scope.employees.timeout_saturday == undefined || $scope.employees.flexi_saturday == true) {$scope.employees.timeout_saturday = 'data'};

        if ($scope.employees.flexi_sunday == 'null' || $scope.employees.flexi_sunday == false || $scope.employees.flexi_sunday == undefined) {$scope.employees.flexi_sunday = 'false'};
        if ($scope.employees.flexi_monday == 'null' || $scope.employees.flexi_monday == false || $scope.employees.flexi_monday == undefined) {$scope.employees.flexi_monday = 'false'};
        if ($scope.employees.flexi_tuesday == 'null'|| $scope.employees.flexi_tuesday == false || $scope.employees.flexi_tuesday == undefined) {$scope.employees.flexi_tuesday = 'false'};
        if ($scope.employees.flexi_wednesday == 'null' || $scope.employees.flexi_wednesday == false || $scope.employees.flexi_wednesday == undefined) {$scope.employees.flexi_wednesday = 'false'};
        if ($scope.employees.flexi_thursday == 'null' || $scope.employees.flexi_thursday == false || $scope.employees.flexi_thursday == undefined) {$scope.employees.flexi_thursday = 'false'};
        if ($scope.employees.flexi_friday == 'null' || $scope.employees.flexi_friday == false || $scope.employees.flexi_friday == undefined) {$scope.employees.flexi_friday = 'false'};
        if ($scope.employees.flexi_saturday == 'null' || $scope.employees.flexi_saturday == false || $scope.employees.flexi_saturday == undefined) {$scope.employees.flexi_saturday = 'false'};

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
            salary_type:'',
            bank_name:'',
            pay_period:'',
            rate_type:'',
            account_number:'',
            education: [{educ_level: "Primary"}],
            amount:'',
            leave_balance:'{"1": "0", "3": "0", "4": "0", "5": "0", "7": "0"}',
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
            emergency_contact_number:null,
            emergency_name:'',
            contact_number:null,
            landline_number:null,
            flexi_sunday:false,
            flexi_monday:false,
            flexi_tuesday:false,
            flexi_wednesday:false,
            flexi_thursday:false,
            flexi_friday:false,
            flexi_saturday:false,
            seminar_training:''
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