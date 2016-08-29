app.controller('Employees_overtime', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        TimelogFactory,
                                        ngDialog,
                                        UINotification,
                                        CutoffFactory,
                                        md5
                                    ){

    $scope.profile = {};
    $scope.filter = {};
    $scope.log = {};
    $scope.log.time_log = new Date;
   
    
    $scope.overtime = {};
    $scope.overtime.count= 0 ;

    $scope.modal = {};

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

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
            DEFAULTDATES();
            fetch_myemployees();
            timesheet_overtime();
            
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


    $scope.timesheet_overtime = function(){
        timesheet_overtime();
    }

    function timesheet_overtime() {
        var filter = {};
        filter.employees_pk =  $scope.profile.pk;

        var datefrom = new Date($scope.filter.datefrom);
        var dd = datefrom.getDate();
        var mm = datefrom.getMonth()+1; //January is 0!
        var yyyy = datefrom.getFullYear();


        var dateto = new Date($scope.filter.dateto);
        var Dd = dateto.getDate();
        var Mm = dateto.getMonth()+1; //January is 0!
        var Yyyy = dateto.getFullYear();

       
        filter.datefrom=yyyy+'-'+mm+'-'+dd;
        filter.dateto=Yyyy+'-'+Mm+'-'+Dd;

        var promise = TimelogFactory.timesheet_overtime(filter);
        promise.then(function(data){
            $scope.overtime.status = true;
            $scope.overtime.data = data.data.result;
            $scope.overtime.count = data.data.result.length;
            
            /*console.log($scope.overtime.data);*/
        }) 
        .then(null, function(data){
            $scope.overtime.status = false;
        });
     
    }

    $scope.cancel = function(k){
        $scope.log.remarks = '';
        $scope.modal = {
                title : '',
                message: 'Are you sure you want to cancel your request',
                save : 'Delete',
                close : 'Cancel'
            };
        
        ngDialog.openConfirm({
            template: 'DisapproveModal',
            className: 'ngdialog-theme-plain custom-widththreefifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Cancel Overtime' +
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

            
                $scope.overtime["employees_pk"] = $scope.profile.pk,
                $scope.overtime.pk = $scope.overtime.data[k].pk
                $scope.overtime.status = "Cancelled";
                $scope.overtime.pk =  $scope.overtime.data[k].pk;
                if($scope.log.remarks==''){
                    $scope.overtime.remarks="Cancelled";
                }else{
                    $scope.overtime.remarks =  $scope.log.remarks;
            
            };

            var promise = TimelogFactory.cancel_overtime($scope.overtime);
            promise.then(function(data){
                UINotification.success({
                                        message: 'You have successfully cancelled your request', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });

                $scope.overtime.data.splice(k, 1);

                if($scope.overtime.data.length < 1){
                    $scope.overtime.status = false;
                }
            })
            .then(null, function(data){
                UINotification.error({
                                        message: 'An error occured, unable to cancel, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    }

    function fetch_myemployees(){
        var filter  = {
            pk : $scope.profile.pk
        }
        
        $scope.myemployees=[];
        var promise = EmployeesFactory.get_myemployees(filter);
        promise.then(function(data){
            var a = data.data.result;
            $scope.myemployees.data=[];
            for(var i in a){
                $scope.myemployees.push({
                                            pk: a[i].employees_pk,
                                            name: a[i].name,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            $scope.myemployees = [];
        });
    }
    
});