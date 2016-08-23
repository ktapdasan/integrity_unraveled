
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
    $scope.manual_logs.count = 0;

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


    $scope.show_myemployees = function(){
        employees_manual_logs();
    }

    function employees_manual_logs() {
        var filter = {};

        var datefrom = new Date($scope.filter.datefrom);
        var dd = datefrom.getDate();
        var mm = datefrom.getMonth()+1; //January is 0!
        var yyyy = datefrom.getFullYear();

        filter.datefrom=yyyy+'-'+mm+'-'+dd;

        var dateto = new Date($scope.filter.dateto);
        var Dd = dateto.getDate();
        var Mm = dateto.getMonth()+1; //January is 0!
        var Yyyy = dateto.getFullYear();

       
        filter.dateto=Yyyy+'-'+Mm+'-'+Dd;
        
        delete $scope.filter.myemployees_pk;
        if($scope.filter.myemployees && $scope.filter.myemployees.length > 0){
            filter.employees_pk = $scope.filter.myemployees[0].pk;
        }
        var promise = TimelogFactory.myemployees_manual_logs(filter);
        promise.then(function(data){
            $scope.manual_logs.data = data.data.result;
            $scope.manual_logs.count = data.data.result.length;
            $scope.manual_logs.status = true;
            // console.log($scope.manual_logs.data);
        }) 
        .then(null, function(data){
            $scope.manual_logs.status = false;
        });
     
    }

    $scope.approve = function(k){
        $scope.manual_logs["employees_pk"] = $scope.manual_logs.data[k].employees_pk; 
        $scope.manual_logs["approver_pk"]=$scope.profile.pk;
        $scope.modal = {
                title : '',
                message: 'Are you sure you want to approve manual log '+ $scope.manual_logs.data[k].type.toLowerCase()+' of '+ $scope.manual_logs.data[k].name+'?',
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
            $scope.manual_logs.remarks= "APPROVED";
            $scope.manual_logs.type= $scope.manual_logs.data[k].type;
            $scope.manual_logs.time_log=$scope.manual_logs.data[k].time;
            console.log( $scope.manual_logs.data[k].status);
            
            var promise = TimelogFactory.approve($scope.manual_logs);
            promise.then(function(data){
            
           
               
                UINotification.success({
                                        message: 'You have successfully approve manual log', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });  
                $scope.manual_logs.data[k].status = "Approved";
                $scope.manual_logs.data[k].remarks= $scope.manual_logs.remarks;

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
        $scope.manual_logs["employees_pk"] = $scope.manual_logs.data[k].employees_pk; 
        $scope.log.remarks = '';
        $scope.manual_logs["approver_pk"]=$scope.profile.pk;
        // console.log($scope.profile.pk);


       $scope.modal = {
                title : 'Disapprove Log ' + $scope.manual_logs.data[k].type,
                save : 'Disapprove',
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
                                '<p>Disapprove manual log '+ $scope.manual_logs.data[k].type.toLowerCase()+' of '+ $scope.manual_logs.data[k].name+'?</p>' +
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

            $scope.manual_logs.status = "Disapproved";
            $scope.manual_logs.pk =  $scope.manual_logs.data[k].pk;
            if($scope.log.remarks==''){
                $scope.manual_logs.remarks="Disapproved";
            }else{
                $scope.manual_logs.remarks =  $scope.log.remarks;
            }
            


            var promise = TimelogFactory.disapprove($scope.manual_logs);
            promise.then(function(data){
            
           

                UINotification.success({
                                        message: 'You have successfully diapproved manual log', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });  
                $scope.manual_logs.data[k].status = "Disapproved";
                $scope.manual_logs.data[k].remarks= $scope.manual_logs.remarks.toUpperCase();
                     

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