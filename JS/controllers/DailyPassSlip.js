app.controller('DailyPassSlip', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        TimelogFactory,
                                        ngDialog,
                                        UINotification,
                                        md5
                                    ){

    $scope.profile = {};
    $scope.filter = {};
    $scope.filter.status = 'Active';
    $scope.log = {};
    $scope.modal = {};

    $scope.dps = {};
    $scope.dps.status = false;
    $scope.dps.count = 0;

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

            show_list();
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

        $scope.filter.date_from = new Date(yyyy+'-'+mm+'-01'); //getMonday(new Date());
        $scope.filter.date_to = new Date();
        $scope.log.date = new Date(yyyy+'-'+mm+'-'+dd);
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

    $scope.add_dps = function(){
        $scope.log.date = new Date();
        $scope.log.remarks = '';
        $scope.log.type = "Official";
        $scope.modal = {

            title : 'Daily Pass Slip ',
            save : 'Submit',
            close : 'Cancel',
           
        };

        ngDialog.openConfirm({
            template: 'DpsModal',
            className: 'ngdialog-theme-plain custom-widththreefifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Apply Daily pass slip?</p>' +
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

            var time_from = new Date($scope.log.time_from);
            var fromh = time_from.getHours();
            var fromm = time_from.getMinutes(); 

            if(fromh.length == 1){
                fromh = '0' + fromh;
            }
            if(fromm.length == 1){
                fromm = '0' + fromm;
            }
            


            var time_to = new Date($scope.log.time_to);
            var toh = time_to.getHours();
            var tom = time_to.getMinutes();

            if(toh.length == 1){
                toh = '0' + toh;
            }
            if(tom.length == 1){
                tom = '0' + tom;
            }

            
            var date = new Date($scope.log.date);
            var dd = date.getDate();
            var mm = date.getMonth()+1; //January is 0!
            var yyyy = date.getFullYear();
              

            $scope.log["employees_pk"] = $scope.profile.pk;
            $scope.log.type = $scope.log.type;
            $scope.log.time_from = fromh + ':' + fromm ;
            $scope.log.time_to = toh + ':' + tom;
            $scope.log.date = yyyy+'-'+mm+'-'+dd;
                  

            var promise = TimelogFactory.add_dps($scope.log);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully filed Daily pass slip', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'

                                    });
            show_list();
            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to file Daily pass slip, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });

            });  

            
        }); 
    }


    $scope.show_list = function(){
        show_list();
    }
    
    function show_list(){
        var from_date = new Date($scope.filter.date_from);
        var fromd = from_date.getDate();
        var fromm = from_date.getMonth()+1; //January is 0!
        var fromy = from_date.getFullYear();

        var to_date = new Date($scope.filter.date_to);
        var tod = to_date.getDate();
        var tom = to_date.getMonth()+1; //January is 0!
        var toy = to_date.getFullYear();

        var filter = {
            employees_pk : $scope.profile.pk,
            date_from : fromy +"-"+ fromm +"-"+fromd,
            date_to : toy+"-"+tom+"-"+tod,
            remarks : $scope.filter.remarks,
            status : $scope.filter.status,
            type : $scope.filter.type
        }

        
        
        var promise = TimelogFactory.fetch_dps(filter);
        promise.then(function(data){
            $scope.dps.status = true;
            $scope.dps.data = data.data.result;
            $scope.dps.count = data.data.result.length;
        })
        .then(null, function(data){
            $scope.dps.status = false;
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

            
                $scope.dps["employees_pk"] = $scope.profile.pk,
                $scope.dps.pk = $scope.dps.data[k].pk
                $scope.dps.status = "Cancelled";
                if($scope.log.remarks==''){
                    $scope.dps.remarks="Cancelled";
                }else{
                    $scope.dps.remarks =  $scope.log.remarks;
            
            };

            var promise = TimelogFactory.cancel_dps($scope.dps);
            promise.then(function(data){
                UINotification.success({
                                        message: 'You have successfully cancelled your request', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                show_list();
                
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
});