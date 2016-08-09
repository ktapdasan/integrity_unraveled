app.controller('Leave', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        LevelsFactory,
                                        LeaveFactory,
                                        ngDialog,
                                        UINotification,
                                        md5
                                    ){

    //$scope.pk='';
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
            leave_types();
            leaves_filed();
            //fetch_myemployees(); 
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

    $scope.add_leave = function(k){
        $scope.modal.reason = '';
        $scope.modal.date_started = new Date;
        $scope.modal.date_ended = new Date;

        $scope.modal = {

            title : 'File a Leave',
            save : 'Submit',
            close : 'Cancel'

        };

        ngDialog.openConfirm({
            template: 'LeaveModal',
            className: 'ngdialog-theme-plain custom-widththreefifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;
                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want file leave?</p>' +
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
            var date_started= new Date($scope.modal.date_started);
                var dd = date_started.getDate();
                var mm= date_started.getMonth();
                var yyyy = date_started.getFullYear();
            var date_ended= new Date($scope.modal.date_ended);
                var DD= date_ended.getDate();
                var MM = date_ended.getMonth(); 
                var YYYY = date_ended.getFullYear(); 
               
            $scope.modal.date_started = yyyy+'-'+mm+'-'+dd;
            $scope.modal.date_ended = YYYY+'-'+MM+'-'+DD;
            $scope.modal["employees_pk"] = $scope.profile.pk;
            $scope.modal["supervisor_pk"] = $scope.profile.supervisor_pk;

            
            var promise = LeaveFactory.add_leave($scope.modal);
            promise.then(function(data){
                UINotification.success({
                                        message: 'You have successfully filed a leave.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
               
                leaves_filed();
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

    function leave_types(){
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

        $scope.filter.employees_pk = $scope.profile.pk;
        
        var promise = LeaveFactory.get_leave_types($scope.filter);
        promise.then(function(data){
            $scope.leave_types.status = true;
            $scope.leave_types.data = data.data.result;
            
            var a = data.data.result;
            $scope.leave_types.obj=[];
            for(var i in a){
                $scope.leave_types.obj.push({
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

    $scope.delete = function(k){
       
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to delete your request',
                save : 'Delete',
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
            var filter = {
                leave_filed_pk : $scope.leaves_filed.data[k].pk,
                created_by : $scope.profile.pk
            };

            var promise = LeaveFactory.delete(filter);
            promise.then(function(data){
                
                $scope.archived=false;

                UINotification.success({
                                        message: 'You have successfully Deleted your request', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });

            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to Delete, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    }


    $scope.leaves_filed = function(){
        leave_types();
        leaves_filed();        
    }

    function leaves_filed() {
        var from_date = new Date($scope.filter.date_from);
        var fromd = from_date.getDate();
        var fromm = from_date.getMonth()+1; //January is 0!
        var fromy = from_date.getFullYear();

        var to_date = new Date($scope.filter.date_to);
        var tod = to_date.getDate();
        var tom = to_date.getMonth()+1; //January is 0!
        var toy = to_date.getFullYear();

        var filter = {};
        filter.employees_pk = $scope.profile.pk;
        filter.archived = $scope.filter.archived;
        filter.date_from = fromy +"-"+ fromm +"-"+ fromd;
        filter.date_to = toy +"-"+ tom +"-"+ tod;
        filter.status = $scope.filter.status;

        if($scope.filter.leave_type && $scope.filter.leave_type[0]){
            filter.leave_types_pk = $scope.filter.leave_type[0].pk;
        }

        var promise = LeaveFactory.leaves_filed(filter);
        promise.then(function(data){
            $scope.leaves_filed.status = true;
            $scope.leaves_filed.data = data.data.result;
        })
        .then(null, function(data){
            $scope.leaves_filed.status = false;
        }); 
    }

    
});