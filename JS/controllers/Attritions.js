app.controller('Attritions', function(
                                        $scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        AttritionsFactory,
                                        TimelogFactory,
                                        ngDialog,
                                        UINotification,
                                        md5,
                                        $filter
                                    ){

    $scope.pk='';
    $scope.profile = {};
    $scope.filter = {};
    $scope.filter.status = 'Active';


    $scope.titles={};
    $scope.level_title={};

    $scope.employees={};
    $scope.employees.count = 0;
    $scope.employees.filters = {};
    
    $scope.modal = {};
    $scope.attrition = {};
    

    $scope.attrition.data = {
            yes : false
        }
   
    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            get_profile();
            get_positions();
            get_levels();

            fetch_levels();
            fetch_titles();
            
            

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

            $scope.filter.pk = $scope.profile.pk;

            DEFAULTDATES();
            employees();
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



    $scope.show_employees = function(){

       employees();
    }

    function employees(){

        var datefrom =  $filter('date')($scope.filter.date_from, "yyyy-MM-dd");
        var dateto =  $filter('date')($scope.filter.date_to, "yyyy-MM-dd");

        $scope.filter.date_from = datefrom;
        $scope.filter.date_to = dateto;

        $scope.filter.archived = 'false';

        var promise = AttritionsFactory.fetch_all($scope.filter);
        promise.then(function(data){
            $scope.employees.status = true;

            $scope.employees.data = data.data.result;
            $scope.employees.count = data.data.result.length;
            
            for(var i in $scope.employees.data){
                $scope.employees.data[i].personal = JSON.parse($scope.employees.data[i].personal);
                $scope.employees.data[i].company = JSON.parse($scope.employees.data[i].company);
                $scope.employees.data[i].hr_details = JSON.parse($scope.employees.data[i].hr_details);
                $scope.employees.data[i].supervisor_details = JSON.parse($scope.employees.data[i].supervisor_details);

       
               /* if($scope.employees.data[i].supervisor_details.elig === true){
                      $scope.employees.data[i].elig_status = 'yes';

                }else if($scope.employees.data[i].supervisor_details.elig === false ){
                    $scope.employees.data[i].elig_status = 'no';
                }else{
                     $scope.employees.data[i].elig_status = "N/A";
                 }*/
            }

            console.log($scope.employees.data);
        })
        .then(null, function(data){
            $scope.employees.status = false;
        });
       

    }

    function get_positions(){
        var promise = EmployeesFactory.get_positions();
        promise.then(function(data){
            $scope.titles.data = data.data.result;
        })
        .then(null, function(data){
            
        });
    }

    function get_levels(){
        var promise = EmployeesFactory.get_levels();
        promise.then(function(data){
            $scope.level_title.data = data.data.result;
        })
        .then(null, function(data){
            
        });
    }

    function get_supervisors(){
        var promise = EmployeesFactory.get_supervisors();
        promise.then(function(data){
            $scope.employees.supervisors = data.data.result;
        })
        .then(null, function(data){
            
        });
    }

   $scope.show_list = function(){
        list();        
    }

    function list(){
        

 
        delete $scope.filter.titles_pk;
        if($scope.filter.titles.length > 0){
            $scope.filter.titles_pk = $scope.filter.titles[0].pk;
        }

        delete $scope.filter.levels_pk;
        if($scope.filter.level_title.length > 0){
            $scope.filter.levels_pk = $scope.filter.level_title[0].pk;
        }

        
        employees();
    }

    function fetch_levels(){
        var promise = EmployeesFactory.get_levels();
        promise.then(function(data){
            var a = data.data.result;
            $scope.employees.filters.level_title=[];
            for(var i in a){
                $scope.employees.filters.level_title.push({
                                            pk: a[i].pk,
                                            name: a[i].level_title,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            
        });
    }


    function fetch_titles(){
        var promise = EmployeesFactory.get_positions();
        promise.then(function(data){
             var a = data.data.result;
            $scope.employees.filters.titles=[];
            for(var i in a){
                $scope.employees.filters.titles.push({
                                            pk: a[i].pk,
                                            name: a[i].title,
                                            ticked: false
                                        });
            }
        })
        .then(null, function(data){
            
        });
    }
         //modal for attrition
    $scope.attrition_modal = function(k){

        $scope.modal = {
                title : '',
                message: 'Supervisor details',
                save : 'Done',
                close : 'Cancel'
                
            };
    
       ngDialog.openConfirm({
            template: 'AttritionsModal',
            className: 'ngdialog-theme-plain',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;
                
                    nestedConfirmDialog = ngDialog.openConfirm({
                        template:
                                '<p></p>' +
                                '<p>Done?</p>' +
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
            
            // get the value of Reason and Remark textarea.
              console.log($scope.modal.reason);
              console.log($scope.modal.remark);
             console.log($scope.attrition.data.yes);
             console.log($scope.employees.data[k].employees_pk);

              $scope.modal.attritions_pk = $scope.employees.data[k].pk;
              $scope.modal.elig = $scope.attrition.data.yes;
              $scope.modal.employees_pk = $scope.employees.data[k].employees_pk ;
              $scope.modal.created_by = $scope.employees.data[k].created_by ;
              $scope.modal.apprv_pk = $scope.profile.pk;
            var promise = AttritionsFactory.attrition_modal($scope.modal);
            promise.then(function(data){

                UINotification.success({
                                       message: 'Successfully saved attritions response.',
                                       title: 'SUCCESS',
                                       delay: 5000,
                                       positionY: 'top', positionX: 'right'

                                   });

                $scope.employees.data[k].supervisor_details.reason = $scope.modal.reason;
                $scope.employees.data[k].supervisor_details.remark = $scope.modal.remark;
                $scope.employees.data[k].supervisor_details.elig = $scope.modal.elig.toString();

            })
             .then(null, function(data){
                UINotification.error({
                                      message: 'An error occured, unable to save changes, please try again.',
                                       title: 'ERROR',
                                       delay: 5000,
                                       positionY: 'top', positionX: 'right'
                                   });
            });
          });
    }
});
   

            





       