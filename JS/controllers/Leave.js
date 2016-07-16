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

    $scope.pk='';
    $scope.leave_types={};
    $scope.profile= {};

    $scope.filter= {};
    $scope.filter.status= "Active";

    $scope.modal = {};

    $scope.leaves_filed = {};

   


    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            leavetypes();
            get_profile();
            leaves_filed();
            
        });
    }

    function get_profile(){
        var filters = { 
            'pk' : $scope.pk
        };

        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){
            $scope.profile = data.data.result[0];
        })   
    } 

       

    $scope.add_leave = function(k){
    leaves_filed();
    get_profile();
    $scope.modal.reason = '';
    $scope.modal.date_started = new Date;
    $scope.modal.date_ended = new Date;

    $scope.modal = {

        title : 'File for Leave',
        save : 'Submit',
        close : 'Cancel'

    };

    ngDialog.openConfirm({
        template: 'SubmitLeaveModal',
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


        $scope.archived=true;

            UINotification.success({
                                    message: 'You have successfully added level.', 
                                    title: 'SUCCESS', 
                                    delay : 5000,
                                    positionY: 'top', positionX: 'right'
                                });
            leavetypes();
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

                        
    }

    $scope.show_leavetypes = function(){
        leavetypes();
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
        
        var promise = LeaveFactory.get_leavetypes($scope.filter);
        promise.then(function(data){
            $scope.leave_types.status = true;
            $scope.leave_types.data = data.data.result;

        })
        .then(null, function(data){
            $scope.leave_types.status = false;
        });
    }

    $scope.leave_filed = function (){
        leaves_filed();
    }

    function leaves_filed () {

        
        $scope.leaves_filed.status = false;
        $scope.leaves_filed.data= {};
    
        
        var promise = LeaveFactory.leaves_filed($scope.filter);
        promise.then(function(data){
            $scope.leaves_filed.status = true;
            $scope.leaves_filed.data = data.data.result;
        })
        .then(null, function(data){
            $scope.leaves_filed.status = false;
        });

       
    }
       
});