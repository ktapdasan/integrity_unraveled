app.controller('HRIS_Request', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        TimelogFactory,
                                        ngDialog,
                                        UINotification,
                                        RequestFactory,
                                        md5
                                    ){

    $scope.profile = {};
    $scope.filter = {};

    $scope.modal = {};
    $scope.request = {};

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
            $scope.profile.details = JSON.parse($scope.profile.details);
            $scope.profile.permission = JSON.parse($scope.profile.permission);
            $scope.profile.leave_balances = JSON.parse($scope.profile.leave_balances);

            DEFAULTDATES();
            request();
            
            
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

    
    $scope.show_request = function(){
        
        request();
    }
   

    function request(){

        var filter={};

        var datefrom = new Date($scope.filter.datefrom);
        var dd = datefrom.getDate();
        var mm = datefrom.getMonth()+1; //January is 0!
        var yyyy = datefrom.getFullYear();

        var filter={};
        var dateto = new Date($scope.filter.dateto);
        var Dd = dateto.getDate();
        var Mm = dateto.getMonth()+1; //January is 0!
        var Yyyy = dateto.getFullYear();


        filter.datefrom=yyyy+'-'+mm+'-'+dd;
        filter.dateto=Yyyy+'-'+Mm+'-'+Dd;
        filter.pk = $scope.profile.pk;

        
        var promise = RequestFactory.get_request(filter);
        promise.then(function(data){
            $scope.request.status = true;
            $scope.request.data = data.data.result;
            var count = data.data.result.length;

            if (count==0) {
                $scope.request.count="";
            }
            else{
                $scope.request.count="Total: " + count;
            }
             
        })
        .then(null, function(data){
            $scope.request.status = false;
            $scope.request.count="";
        });

    }


    $scope.update_request = function(k){
     
        $scope.modal = {

            title           : 'Update Status',
            save            : 'Save',
            close           : 'Cancel',
            pk              : $scope.request.data[k].pk,
            created_by      : $scope.profile.pk,
            employees_pk    : $scope.request.data[k].created_by
        };

        ngDialog.openConfirm({
            template: 'UpdateRequestModal',
            className: 'ngdialog-theme-plain custom-widththreefifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;

                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want to '+ $scope.modal.status +' this Request?</p>' +
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
            
            var promise = RequestFactory.update_request($scope.modal);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully added new Request', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                request();
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




});