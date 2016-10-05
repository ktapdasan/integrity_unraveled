app.controller('Admin_request', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        ngDialog,
                                        UINotification,
                                        RequestFactory,
                                        md5,
                                        $filter
                                    ){
    $scope.request_type = {};
    $scope.modal = {};
    $scope.filter= {};
    $scope.filter.status= 'Active';
    $scope.employees={};

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];
            
            get_profile();
            request_type();
        });
    }

    function get_profile(){
        var filters = { 
            'pk' : $scope.pk
        };

        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){
            $scope.profile = data.data.result[0];
            employees();
           
        })         
    } 



    $scope.show_request_type = function(){
        request_type();
    }
   

    function request_type(){

        $scope.request_type.status = false;
        $scope.request_type.data= '';

        if ($scope.filter.status == 'Active')
            {
                $scope.filter.archived = 'false';  
            }
        else 
            {
                $scope.filter.archived = 'true';   
            }

        
        var promise = RequestFactory.get_request_type($scope.filter);
        promise.then(function(data){
            $scope.request_type.status = true;
            $scope.request_type.data = data.data.result;

            for(var i in $scope.request_type.data){
                var recipients = $scope.request_type.data[i].recipients.split(',');
                var new_recipients = [];
                for(var j in recipients){
                    var z = recipients[j].split('|');
                    new_recipients.push({
                        pk : z[0],
                        name : z[1]
                    })
                }

                $scope.request_type.data[i].obj_recipients = new_recipients;
            }

            var count = data.data.result.length;

            if (count==0) {
                $scope.request_type.count="";
            }
            else{
                $scope.request_type.count="Total: " + count;
            }
             

        })
        .then(null, function(data){
            $scope.request_type.status = false;
        });
    }
  

    
    $scope.add_Recipients = function(){
      
          $scope.modal.obj_recipients.push({
            pk   : $scope.employees.data[$scope.modal.addRecipients].pk,
            name : $scope.employees.data[$scope.modal.addRecipients].details.personal.first_name + " " + $scope.employees.data[$scope.modal.addRecipients].details.personal.last_name
        });
    }

    $scope.removeRecipients = function (x) {
        $scope.modal.obj_recipients.splice(x, 1);
    }

    $scope.add_request_type = function(k){
     
        $scope.modal = {

            title           : 'Add New Request type',
            save            : 'Add',
            close           : 'Cancel',
            obj_recipients  : []

           
        };

        ngDialog.openConfirm({
            template: 'RequestTypeModal',
            className: 'ngdialog-theme-plain custom-widththreefifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;

                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want to add this Request Type?</p>' +
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
            
            $scope.modal.obj_recipients = JSON.stringify($scope.modal.obj_recipients);
            
            
            var promise = RequestFactory.add_request_type($scope.modal);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully added new Request Type', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                request_type();
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

    
    $scope.edit_request_type = function(k){
        $scope.modal = {
            title           : 'Edit Request type',
            save            : 'Apply Changes',
            close           : 'Cancel',
            type            : $scope.request_type.data[k].type,
            pk              : $scope.request_type.data[k].pk,
            obj_recipients  : $scope.request_type.data[k].obj_recipients
        };

        ngDialog.openConfirm({
            template: 'RequestTypeModal',
            className: 'ngdialog-theme-plain custom-widththreefifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;
                
                nestedConfirmDialog = ngDialog.openConfirm({
                    template:
                            '<p></p>' +
                            '<p>Are you sure you want to apply changes to this  Request type?</p>' +
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

            $scope.modal.obj_recipients = JSON.stringify($scope.modal.obj_recipients);
            var promise = RequestFactory.update_request_type($scope.modal);
            promise.then(function(data){

                UINotification.success({
                                        message: 'You have successfully applied changes to this Request type.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                request_type();
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
    

    $scope.delete_request_type = function(k){
       
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to delete this Request type?',
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

            
            var promise = RequestFactory.delete_request_type($scope.request_type.data[k]);
            promise.then(function(data){
                

                $scope.archived=true;
                UINotification.success({
                                        message: 'You have successfully deleted Request type', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                request_type();

            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to delete, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    }


    $scope.restore_request_type = function(k){
       
        $scope.modal = {
                title : '',
                message: 'Are you sure you want to restore this Request type?',
                save : 'restore',
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

            
            var promise = RequestFactory.restore_request_type($scope.request_type.data[k]);
            promise.then(function(data){
                

                $scope.archived=true;
                UINotification.success({
                                        message: 'You have successfully restored Request_request_type', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                request_type();

            })
            .then(null, function(data){
                
                UINotification.error({
                                        message: 'An error occured, unable to restore, please try again.', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
            });         

                            
        });
    }

    $scope.show_employees = function(){

       employees();

    }

    function employees(){
        
        $scope.filter.archived = 'false';
        
        var promise = EmployeesFactory.fetch_all($scope.filter);
        promise.then(function(data){
            $scope.employees.status = true;
            //$scope.employees.data = data.data.result;
            
            //$scope.employees.data

            var a = data.data.result;
            for(var i in a){
                a[i].details = JSON.parse(a[i].details);
            }

            $scope.employees.data = a;
            $scope.employees.count = data.data.result.length;
            
        })
        .then(null, function(data){
            $scope.employees.status = false;
        });



    }


});