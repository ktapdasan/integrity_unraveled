app.controller('Management_DailyPassSlip', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        TimelogFactory,
                                        DefaultFactory,
                                        ngDialog,
                                        UINotification,
                                        md5
                                    ){

    $scope.profile = {};
    $scope.filter = {};
    $scope.log = {};
    $scope.filter.status = 'Active';

    $scope.modal = {};

    $scope.dps = {};
    $scope.dps.status = false;
    $scope.dps.count = 0;

    $scope.default_value = {};
    

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
            default_values();
            fetch_myemployees();
            show_list();
        })   
    } 

    function default_values(){
        var filter = {
            name : 'overtime_leave'
        };
        var promise = DefaultFactory.fetch(filter);
        promise.then(function(data){
            $scope.default_value = data.data.result[0];
        })
    }

    function fetch_myemployees(){
        var filter  = {
            pk : $scope.profile.pk
        }
        
        $scope.myemployees=[];
        var promise = EmployeesFactory.get_myemployees(filter);
        promise.then(function(data){
            var a = data.data.result;
            $scope.myemployees=[];
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

        $scope.filter.date_from = new Date(yyyy+'-'+mm+'-01'); //getMonday(new Date());
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

    $scope.show_list = function(){
        show_list();
    }
    
    function show_list(){
        var filter = {};
        
        filter.supervisor_pk =  $scope.profile.pk;
        filter.status = $scope.filter.status;
        
        

        var date_from = new Date($scope.filter.date_from);
        var fromd = date_from.getDate();
        var fromm = date_from.getMonth()+1; //January is 0!
        var fromy = date_from.getFullYear();

        var date_to = new Date($scope.filter.date_to);
        var tod = date_to.getDate();
        var tom = date_to.getMonth()+1; //January is 0!
        var toy = date_to.getFullYear();

        
        filter.date_from = fromy +"-"+ fromm +"-"+fromd;
        filter.date_to = toy+"-"+tom+"-"+tod;

        filter.employees_pk = null;
        if($scope.filter.myemployees && $scope.filter.myemployees[0]){
            filter.employees_pk = $scope.filter.myemployees[0].pk
        }

        
        var promise = TimelogFactory.fetch_employees_dps(filter);
        promise.then(function(data){
            $scope.dps.status = true;
            $scope.dps.data = data.data.result;
            $scope.dps.count = data.data.result.length;
        })
        .then(null, function(data){
            $scope.dps.status = false;
        });
    }

    $scope.respond = function(k, status){
        $scope.dps.employees_pk = $scope.dps.data[k].employees_pk; 
        $scope.dps.approver_pk=$scope.profile.pk;
        $scope.dps.type = $scope.dps.data[k].type;
        
        $scope.modal = {
                title : '',
                message: 'Are you sure you want to '+status+' this daily pass slip ',
                save : 'Yes',
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

            if(status == "approve"){
                $scope.dps.status = "Approved";    
                $scope.dps.remarks= "APPROVED";
            }
            else {
                $scope.dps.status = "Disapproved";
                $scope.dps.remarks =  $scope.log.remarks;
            }
            
            $scope.dps.pk =  $scope.dps.data[k].pk;
            $scope.dps.time_from = $scope.dps.data[k].time_from;
            $scope.dps.time_to = $scope.dps.data[k].time_to;

            var default_value = JSON.parse($scope.default_value.details);
            $scope.dps.leave_pk = default_value.leave_filed_pk;
            
            var promise = TimelogFactory.approve_dps($scope.dps);
            promise.then(function(data){
               
                UINotification.success({
                                        message: 'You have successfully approved overtime', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });  

                $scope.dps.data[k].status = "Approved";
                $scope.dps.data[k].remarks= $scope.dps.remarks;

            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to approve overtime, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });                                  
        });
    }

});