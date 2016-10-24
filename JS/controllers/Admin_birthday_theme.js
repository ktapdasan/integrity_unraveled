app.controller('Admin_birthday_theme', function(
  										$scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        BirthdayFactory,
                                        ngDialog,
                                        UINotification,
                                        md5,
                                        FileUploader
  									){
 
    $scope.pk='';
    $scope.filter= {};
    $scope.filter.status= 'Active';
    $scope.birthday={};
    $scope.modal = {};

    $scope.uploader = {};
    $scope.uploader.queue = {};
    $scope.month=[];



 
    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            get_profile();
            birthday();
            
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
          /*  employees();*/
        })   
    } 

    
    $scope.show_birthday = function(){
        birthday();
    }
   

    function birthday(){

        $scope.birthday.status = false;
        $scope.birthday.data= '';

        if ($scope.filter.status == 'Active')
        {
            $scope.filter.archived = 'false';  
        }
        else 
        {
            $scope.filter.archived = 'true';   
        }
       
        var promise = BirthdayFactory.get_birthday_theme($scope.filter);
        promise.then(function(data){
            $scope.birthday.status = true;
            $scope.birthday.data = data.data.result;
            $scope.birthday.length = data.data.result.length;
             count = data.data.result.length;

            if (count==0) {
                $scope.birthday.count="";
            }
            else{
                $scope.birthday.count="Total: " + count;
            }

        })
        .then(null, function(data){
            $scope.birthday.status = false;
            $scope.birthday.count="";
        });
    }


    var uploader = $scope.uploader = new FileUploader({
        url: 'FUNCTIONS/Birthday/upload_birthday_theme.php'
    });

    // FILTERS

    uploader.filters.push({
        name: 'customFilter',
        fn: function(item /*{File|FileLikeObject}*/, options) {
            return this.queue.length < 10;
        }
    });



      // CALLBACKS

    uploader.onWhenAddingFileFailed = function(item /*{File|FileLikeObject}*/, filter, options) {
        //console.info('onWhenAddingFileFailed', item, filter, options);
    };
    uploader.onAfterAddingFile = function(fileItem) {
        //console.info('onAfterAddingFile', fileItem);
    };
    uploader.onAfterAddingAll = function(addedFileItems) {
        //console.info('onAfterAddingAll', addedFileItems);
    };
    uploader.onBeforeUploadItem = function(item) {
        //console.info('onBeforeUploadItem', item);
    };
    uploader.onProgressItem = function(fileItem, progress) {
        //console.info('onProgressItem', fileItem, progress);
    };
    uploader.onProgressAll = function(progress) {
        //console.info('onProgressAll', progress);
    };
    uploader.onSuccessItem = function(fileItem, response, status, headers) {
        //console.info('onSuccessItem', fileItem, response, status, headers);
    };
    uploader.onErrorItem = function(fileItem, response, status, headers) {
        //console.info('onErrorItem', fileItem, response, status, headers);
    };
    uploader.onCancelItem = function(fileItem, response, status, headers) {
        //console.info('onCancelItem', fileItem, response, status, headers);
    };
    uploader.onCompleteItem = function(fileItem, response, status, headers) {
        //console.info('onCompleteItem', fileItem, respsonse, status, headers);
        //$scope.data.quotationmodal.attachment = response.file;
        // console.log(response.file);
        $scope.modal.imagevalue = response.file;
    };
    uploader.onCompleteAll = function() {
        console.info('onCompleteAll');
    };  


$scope.add_birthday = function(){
 
        $scope.months = ["January", "February" , "March", "April" , "May" , "June" , "July" , "August" , 
        "September" , "October" , "November" , "December"];


        for (var x = 0 ; x < $scope.birthday.length ; x++) {
    
            for (var i = 0; i < 12; i++) {

                if ( $scope.months[i] == $scope.birthday.data[x].month) {
                       
                        $scope.months.splice(i, 1);
                         
                }

            }
                
        } 


        $scope.modal = {
            title           : 'Upload Birthday Image Theme',
            save            : 'Apply Changes',
            close           : 'CLOSE', 
            imagevalue      : '',
            birthdaymonth   : '',
            months          :$scope.months
        };

    

        ngDialog.openConfirm({
            template: 'UploadModal',
            className: 'ngdialog-theme-plain custom-widthfourfifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;

                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want to apply changes to Birthday Theme?</p>' +
                                '<div class="ngdialog-buttons">' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">No' +
                                    '<button type="button" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">Yes' +
                                '</button></div>',
                        plain: true,
                        className: 'ngdialog-theme-plain custom-widthfourfifty'
                    });

                return nestedConfirmDialog;
            },
            scope: $scope,
            showClose: false
        })
        .then(function(value){
            return false;
        }, function(value){
           
            if ($scope.modal.birthdaymonth == null || $scope.modal.birthdaymonth =="" ) {
                

                 UINotification.error({
                                        message: 'Please select birthday month', 
                                        title: 'ERROR', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                return false;

            console.log($scope.modal.birthdaymonth);

             }
        
            var promise = BirthdayFactory.add_birthday_theme($scope.modal);

            promise.then(function(data){
                

                UINotification.success({
                                        message: 'You have successfully applied changes to this Birthday Theme.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                birthday();


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





$scope.edit_birthday = function(k){

    $scope.months = ["January", "February" , "March", "April" , "May" , "June" , "July" , "August" , 
        "September" , "October" , "November" , "December"];


        for (var x = 0 ; x < $scope.birthday.length ; x++) {
    
            for (var i = 0; i < 12; i++) {

                if ( $scope.months[i] == $scope.birthday.data[x].month) {
                       
                        $scope.months.splice(i, 1);
                         
                }

            }
                
        } 

        $scope.months.push($scope.birthday.data[k].month);


        $scope.modal = {
            title           : 'Edit Birthday Image Theme',
            save            : 'Apply Changes',
            close           : 'CLOSE', 
            imagevalue      : $scope.birthday.data[k].location,
            birthdaymonth   : $scope.birthday.data[k].month,
            pk              : $scope.birthday.data[k].pk,
            months          : $scope.months
        };
    

        ngDialog.openConfirm({
            template: 'UploadModal',
            className: 'ngdialog-theme-plain custom-widthfourfifty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;

                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Are you sure you want to apply changes to Birthday Theme?</p>' +
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
           
           
            var promise = BirthdayFactory.update_birthday_theme($scope.modal);
            promise.then(function(data){
                

                UINotification.success({
                                        message: 'You have successfully applied changes to this Birthday Theme.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                birthday();


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





    $scope.delete_birthday = function(k){
       
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to delete this Birthday theme?',
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
      
            
            var promise = BirthdayFactory.delete_birthday_theme($scope.birthday.data[k]);
            promise.then(function(data){
                

                $scope.archived=true;
                UINotification.success({
                                        message: 'You have successfully deleted Birthday Theme', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                birthday();

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
    $scope.restore_birthday = function(k){
       
       $scope.modal = {
                title : '',
                message: 'Are you sure you want to restore this Birthday Theme?',
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

            
            var promise = BirthdayFactory.restore_birthday_theme($scope.birthday.data[k]);
            promise.then(function(data){
                

                $scope.archived=true;
                UINotification.success({
                                        message: 'You have successfully restored Birthday Theme', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
                birthday();

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



 });