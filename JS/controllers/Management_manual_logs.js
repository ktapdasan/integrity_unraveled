
app.controller('Management_manual_logs', function(
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
   
    $scope.manual_logs = {};

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
            employees_manual_logs();
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

    function fetch_myemployees(){
        var filter  = {
            pk : $scope.profile.pk 
        }
        
        var promise = TimelogFactory.get_myemployees(filter);
        promise.then(function(data){
        
            var a = data.data.result;
            $scope.myemployees=[];
            for(var i in a){
                $scope.myemployees.push({
                                            pk: a[i].pk,
                                            name: a[i].myemployees,
                                            ticked: false
                                        });
            }
        })
        

        .then(null, function(data){
            
        });
    }

    $scope.show_myemployees = function(){
        employees_manual_logs();
    }

    function employees_manual_logs() {

        var datefrom = new Date($scope.filter.datefrom);
        var dd = datefrom.getDate();
        var mm = datefrom.getMonth()+1; //January is 0!
        var yyyy = datefrom.getFullYear();

        $scope.filter.newdatefrom=yyyy+'-'+mm+'-'+dd;

        var dateto = new Date($scope.filter.dateto);
        var Dd = dateto.getDate();
        var Mm = dateto.getMonth()+1; //January is 0!
        var Yyyy = dateto.getFullYear();

        $scope.filter.newdateto=Yyyy+'-'+Mm+'-'+Dd;
        
        var filter = {};

        if($scope.filter.myemployees && $scope.filter.myemployees !== 'undefined'){
            filter.employees_pk = $scope.filter.myemployees[0].pk
            filter.datefrom = $scope.filter.newdatefrom
            filter.dateto = $scope.filter.newdateto
        }

        var promise = TimelogFactory.myemployees_manual_logs(filter);
        promise.then(function(data){
            $scope.manual_logs.data = data.data.result;
            $scope.manual_logs.status = true;
        }) 
        .then(null, function(data){
            $scope.manual_logs.status = false;
        });
    
    }

    $scope.approve = function(k){
        $scope.manual_logs["employees_pk"] = $scope.profile.pk;
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to approve manual log?',
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

            $scope.manual_logs.status = "Approved";
            $scope.manual_logs.pk =  $scope.manual_logs.data[k].pk;

            
            var promise = TimelogFactory.approve($scope.manual_logs);
            promise.then(function(data){
            
           

                UINotification.success({
                                        message: 'You have successfully approve manual log', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });  
                manual_logs();
                       

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
        $scope.manual_logs["employees_pk"] = $scope.profile.pk; 
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to disapprove manual log?',
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

            $scope.manual_logs.status = "Disapproved";
            $scope.manual_logs.pk =  $scope.manual_logs.data[k].pk;

            
            var promise = TimelogFactory.disapprove($scope.manual_logs);
            promise.then(function(data){
            
           

                UINotification.success({
                                        message: 'You have successfully diapproved manual log', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });  
                manual_logs();
                     

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
    
});