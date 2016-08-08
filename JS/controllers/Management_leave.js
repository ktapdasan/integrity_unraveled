app.controller('Management_leave', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        LevelsFactory,
                                        LeaveFactory,
                                        ngDialog,
                                        UINotification,
                                        md5
                                    ){

    $scope.pk='';
    $scope.leave_types={};
    $scope.profile= {};

    $scope.filter= {};
    $scope.filter.status= "Active";

    $scope.modal = {};

    $scope.leaves_filed = {};

    $scope.myemployees={};

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            leavetypes();
            get_profile();
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
            leaves_filed();
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

    function leavetypes(){
        $scope.leave_types.status = false;
        $scope.leave_types.data= '';
        
        if ($scope.filter.status == 'Active')
        {
            $scope.filter.archived = 'false';  
        }
        else 
        {
            $scope.filter.archived = 'true';   
        }
        
        var promise = LeaveFactory.get_leave_types($scope.filter);
        promise.then(function(data){
            var a = data.data.result;
            $scope.leave_types=[];
            for(var i in a){
                $scope.leave_types.push({
                                            pk: a[i].pk,
                                            name: a[i].name,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            $scope.leave_types.status = false;
        });
    }

    $scope.leaves_filed = function(){
        leaves_filed();        
    }

    function leaves_filed() {
        // console.log($scope.filter);
        var filter = {};
        filter.archived = $scope.filter.archived;
        filter.employees_pk = $scope.filter.employees_pk;
        filter.status = $scope.filter.status;
        filter.supervisor_pk = $scope.profile.pk;

        var from_date = new Date($scope.filter.date_from);
        var fromd = from_date.getDate();
        var fromm = from_date.getMonth()+1; //January is 0!
        var fromy = from_date.getFullYear();

        var to_date = new Date($scope.filter.date_to);
        var tod = to_date.getDate();
        var tom = to_date.getMonth()+1; //January is 0!
        var toy = to_date.getFullYear();

        filter.date_from = fromy +"-"+ fromm +"-"+ fromd;
        filter.date_to = toy +"-"+ tom +"-"+ tod;

        filter.employees_pk = null;
        if($scope.filter.myemployees && $scope.filter.myemployees[0]){
            filter.employees_pk = $scope.filter.myemployees[0].pk
        }

        filter.leave_types_pk = null;
        if($scope.filter.leave_type && $scope.filter.leave_type[0]){
            filter.leave_types_pk = $scope.filter.leave_type[0].pk
        }
        
        var promise = LeaveFactory.employees_leaves_filed(filter);
        promise.then(function(data){
            $scope.leaves_filed.status = true;
            $scope.leaves_filed.data = data.data.result;
        })
        .then(null, function(data){
            $scope.leaves_filed.status = false;
        }); 
    }

    
    $scope.approve = function(k){
       $scope.leaves_filed["employees_pk"] = $scope.profile.pk;
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to approve this leave?',
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

            //$scope.leaves_filed.reason = "Approved";
            $scope.leaves_filed["employees_pk"] = $scope.leaves_filed.data[k].employees_pk;
            $scope.leaves_filed.pk =  $scope.leaves_filed.data[k].pk;
            $scope.leaves_filed.created_by = $scope.profile.pk;
            $scope.leaves_filed.status = 'Approved';
  
            var promise = LeaveFactory.approve($scope.leaves_filed);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully approved filed leave.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });  
                leaves_filed();    

            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to approve, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });                                  
        });
    }

    $scope.disapprove = function(k){
        $scope.modal = {
                title : '',
                message: 'Are you sure you want to disapprove this leave?',
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

            //$scope.leaves_filed.reason = "Disapproved";
            $scope.leaves_filed["employees_pk"] = $scope.leaves_filed.data[k].employees_pk;
            $scope.leaves_filed.pk =  $scope.leaves_filed.data[k].pk;
            $scope.leaves_filed.created_by = $scope.profile.pk;
            $scope.leaves_filed.status = 'Disapproved';
            
            var promise = LeaveFactory.disapprove($scope.leaves_filed);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully diapproved filed leave.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });  
                leaves_filed();
            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to disapprove, please try again.', 
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
            
        });
    }
});