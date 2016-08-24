app.controller('Timelogs', function(
  										$scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        TimelogFactory,
                                        CutoffFactory,
                                        md5,
                                        UINotification,
                                        ngDialog,
                                        FileUploader
  									){

    $scope.profile = {};
    $scope.filter = {};
    $scope.timesheet = {};
    $scope.timesheet.count = 0;
    $scope.employee = [];
    $scope.employeelist_data = [];
    $scope.titles={};
    $scope.department={};
    $scope.levels={};

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

            //employeelist();
            get_profile();
            
        })
        .then(null, function(data){
            window.location = './login.html';
        });
    }

    function get_profile(){
        var filters = { 
            'pk' : $scope.pk

        };

        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){
            $scope.profile = data.data.result[0];
            $scope.profile.details = JSON.parse($scope.profile.details);
            $scope.profile.permission = JSON.parse($scope.profile.permission);
            $scope.profile.leave_balances = JSON.parse($scope.profile.leave_balances);
            //DEFAULTDATES();
            
            fetch_cutoff();
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

        $scope.filter.datefrom = new Date(yyyy+'-'+mm+'-01'); //getMonday(new Date());
        $scope.filter.dateto = new Date();

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

    function fetch_cutoff(){  
        var promise = CutoffFactory.fetch_dates();
        promise.then(function(data){
            var a = data.data.result[0];
            a.dates = JSON.parse(a.dates);
            
            var new_date = new Date();
            var dd = new_date.getDate();
            var mm = new_date.getMonth()+1; //January is 0!
            var yyyy = new_date.getFullYear();

            if(a.cutoff_types_pk == "2"){ //bimonthly
                var first = a.dates.first;
                var second = a.dates.second;
                
                if(dd >= parseInt(second.from)){
                    $scope.filter.datefrom = new Date(mm+"/"+second.from+"/"+yyyy);
                    mm++;
                    $scope.filter.dateto = new Date(mm+"/"+second.to+"/"+yyyy);
                }
                else {
                    $scope.filter.datefrom = new Date(mm+"/"+first.from+"/"+yyyy);
                    $scope.filter.dateto = new Date(mm+"/"+first.to+"/"+yyyy);   
                }
            }
            else { //monthly
                $scope.filter.datefrom = new Date(mm+"/"+a.dates.from+"/"+yyyy);
                $scope.filter.dateto = new Date(mm+"/"+a.dates.to+"/"+yyyy);
            }

            //fetch_myemployees();
            //timesheet();
        })
        .then(null, function(data){

            //timesheet();
        });
    }

    function employees(){
        var filter = {
            archived : 'false'
        };

        var promise = EmployeesFactory.fetch(filter);
        promise.then(function(data){
            var a = data.data.result;
            $scope.employees=[];
            for(var i in a){
                $scope.employees.push({
                                            pk: a[i].pk,
                                            name: a[i].last_name +", "+a[i].first_name+" "+a[i].middle_name,
                                            ticked: false
                                        });
            }
        })
    }

    $scope.show_timesheet = function(){
        timesheet();    
    }

    function timesheet(){
        var datefrom = new Date($scope.filter.datefrom);
        var dd = datefrom.getDate();
        var mm = datefrom.getMonth()+1; //January is 0!
        var yyyy = datefrom.getFullYear();

        var dateto = new Date($scope.filter.dateto);
        var Dd = dateto.getDate();
        var Mm = dateto.getMonth()+1; //January is 0!
        var Yyyy = dateto.getFullYear();

        $scope.filter.newdatefrom=yyyy+'-'+mm+'-'+dd;
        $scope.filter.newdateto=Yyyy+'-'+Mm+'-'+Dd;

        

        $scope.timesheet.data = [];
        var promise = TimelogFactory.timesheet($scope.filter);
        promise.then(function(data){
            $scope.timesheet.status = true;

            $scope.timesheet.data = [];
            for(var i in data.data){
                for(j in data.data[i]){
                    $scope.timesheet.data.push(data.data[i][j]);
                }
            }

            //$scope.timesheet.data = data.data;

            $scope.timesheet.count=0;
            for(var i in data.data[$scope.profile.employee_id]){
                $scope.timesheet.count++;                
            }
        })
        .then(null, function(data){
            $scope.timesheet.status = false;
        });

    }

    function timesheet2(){

        var datefrom = new Date($scope.filter.datefrom);
        var dd = datefrom.getDate();
        var mm = datefrom.getMonth()+1; //January is 0!
        var yyyy = datefrom.getFullYear();

        var dateto = new Date($scope.filter.dateto);
        var Dd = dateto.getDate();
        var Mm = dateto.getMonth()+1; //January is 0!
        var Yyyy = dateto.getFullYear();

        $scope.filter.newdatefrom=yyyy+'-'+mm+'-'+dd;
        $scope.filter.newdateto=Yyyy+'-'+Mm+'-'+Dd;


        $scope.filter.pk = $scope.profile.pk;
        
        
        delete $scope.filter.employees_pk;
        if($scope.filter.employee && $scope.filter.employee.length > 0){
            $scope.filter.employees_pk = $scope.filter.employee[0].pk;
        }

        delete $scope.filter.departments_pk;
        if($scope.filter.department && $scope.filter.department.length > 0){
            $scope.filter.departments_pk = $scope.filter.department[0].pk;
        }

        delete $scope.filter.titles_pk;
        if($scope.filter.titles && $scope.filter.titles.length > 0){
            $scope.filter.titles_pk = $scope.filter.titles[0].pk;
        }

        delete $scope.filter.levels_pk;
        if($scope.filter.levels && $scope.filter.levels.length > 0){
            $scope.filter.levels_pk = $scope.filter.levels[0].pk;
        }

        var promise = TimelogFactory.timelogs($scope.filter);
        promise.then(function(data){
            $scope.timesheet.data = data.data.result;
            $scope.timesheet.count = data.data.result.length;
            $scope.timesheet.status = true;

            var a = getDates( datefrom, dateto );
            var new_timesheet=[];

            for(var i in a){
                mm = a[i].getMonth()+1;
                date = a[i].getFullYear() +"-"+ mm +"-"+ a[i].getDate();

                for(var j in $scope.timesheet.data){
                    console.log($scope.timesheet.data[j]);
                }
            }


        })  
        .then(null, function(data){
            $scope.timesheet.status = false;
            
        });
    }

    function getDates( d1, d2 ){
        var oneDay = 24*3600*1000;
        for (var d=[],ms=d1*1,last=d2*1;ms<=last;ms+=oneDay){
            d.push( new Date(ms) );
        }
        return d;
    }


    $scope.export_timesheet = function(){
        $scope.filter.pk = $scope.profile.pk;
        
        delete $scope.filter.employees_pk;
        if($scope.filter.employee.length > 0){
            $scope.filter.employees_pk = $scope.filter.employee[0].pk;
        }

        var datefrom = new Date($scope.filter.datefrom);
        var dd = datefrom.getDate();
        var mm = datefrom.getMonth()+1; //January is 0!
        var yyyy = datefrom.getFullYear();

        var dateto = new Date($scope.filter.dateto);
        var Dd = dateto.getDate();
        var Mm = dateto.getMonth()+1; //January is 0!
        var Yyyy = dateto.getFullYear();

        $scope.filter.datefrom=yyyy+'-'+mm+'-'+dd;
        $scope.filter.dateto=Yyyy+'-'+Mm+'-'+Dd;
        window.location = './FUNCTIONS/Timelog/timelogs_export.php?pk='+$scope.filter.pk+'&datefrom='+$scope.filter.datefrom+"&dateto="+$scope.filter.dateto+'&newdatefrom='+$scope.filter.datefrom+"&newdateto="+$scope.filter.dateto+'&employees_pk='+$scope.filter.employees_pk;
        //window.open('./FUNCTIONS/Timelog/timelogs_export.php?pk='+$scope.filter.pk+'&datefrom='+$scope.filter.datefrom+"&dateto="+$scope.filter.dateto+'&newdatefrom='+$scope.filter.datefrom+"&newdateto="+$scope.filter.dateto+'&employees_pk='+$scope.filter.employees_pk);
    }


    $scope.show_employeelist = function(){
        employeelist();        
    }

    function employeelist(){
        $scope.filter.pk = $scope.profile.pk;
        
        delete $scope.filter.employees_pk;
        if($scope.filter.employee && $scope.filter.employee.length > 0){
            $scope.filter.employees_pk = $scope.filter.employee[0].pk;
        }
        
        var promise = TimelogFactory.timelogs($scope.filter);
        promise.then(function(data){
            $scope.employeelist_data = data.data.result;

            
        })   
    }

    $scope.export_employeelist = function(){
        $scope.filter.pk = $scope.profile.pk;
        
        delete $scope.filter.employees_pk;
        if($scope.filter.employee.length > 0){
            $scope.filter.employees_pk = $scope.filter.employee[0].pk;
        }

        window.open('./FUNCTIONS/Timelog/timelogs_export.php?pk='+$scope.filter.pk+'&datefrom='+$scope.filter.datefrom+"&dateto="+$scope.filter.dateto+'&employees_pk='+$scope.filter.employees_pk);

        
    }

    function get_positions(){
        var promise = TimelogFactory.get_positions();
        promise.then(function(data){
             var a = data.data.result;
            $scope.titles.data=[];
            for(var i in a){
                $scope.titles.data.push({
                                            pk: a[i].pk,
                                            name: a[i].title,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            
        });
    }

    function get_department(){
        var filter = {
            archived : 'false'
        };

        var promise = TimelogFactory.get_department(filter);
        promise.then(function(data){
            var a = data.data.result;
            $scope.department.data=[];
            for(var i in a){
                $scope.department.data.push({
                                            pk: a[i].pk,
                                            name: a[i].department,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            
        });
    }

    function get_levels(){
        var promise = TimelogFactory.get_levels();
        promise.then(function(data){
            var a = data.data.result;
            $scope.levels.data=[];
            for(var i in a){
                $scope.levels.data.push({
                                            pk: a[i].pk,
                                            name: a[i].level_title,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            
        });
    }

    $scope.upload_excel = function(){
        $scope.modal = {
            title : 'Upload Employees Timesheet',
            save : 'Apply Changes',
            close : 'CLOSE',
        };

        ngDialog.openConfirm({
            template: 'UploadModal',
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
            
        
            var promise = EmployeesFactory.edit_employees($scope.employees.data[k]);
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


    var uploader = $scope.uploader = new FileUploader({
        url: 'FUNCTIONS/Timelog/upload_employee_time.php'
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
        console.log(response);
    };
    uploader.onCompleteAll = function() {
        console.info('onCompleteAll');
    };


});