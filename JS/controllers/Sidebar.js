app.controller('Sidebar', function(
  										$scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        NotificationsFactory,
                                        md5,
                                        $timeout,
                                        ngDialog
  									){


    $scope.profile = {}; 

    $scope.switcher = {};
    $scope.switcher.main = "";

    $scope.notifications = {};

    $scope.read_notifs = {};

    $scope.notifications.count ="";

    $scope.stop = true; //how to stop the shaking
    
    $scope.animation_arrow = {
        stop : '0' ,
        opacity : '1'
    }

    $scope.animation = {
        stop : '0' ,
        duration : '2.6s' 
    }

    $scope.sidebar_menu = {
        notifications : true,
        memo : false,
        calendar : false
    }

    $scope.memo={};
    $scope.memo.count ="";
    $scope.modal = {};

    $scope.calendar={};
    $scope.calendar.count ="";

    $scope.read_memo={};
    $scope.read_memo.count="";
    $scope.modal2 = {};
   

    init();

    function init(){
        var promise = SessionFactory.getsession();
        promise.then(function(data){
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];

            get_profile();

        })
    }

    function get_profile(){
        var filters = { 
            'pk' : $scope.pk
        };

        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){
            $scope.profile = data.data.result[0];
            
            get_notifications();
            get_memo();
            get_calendar();
           
        })   
    } 

    $scope.toggle_switcher = function(){
        var hid = $('#hidden-text').val();
        //if($scope.switcher.main == ""){
        if(hid == 'false'){
            $scope.switcher.status = true;
            $('#rightSidebar').addClass('open');
            $('#hidden-text').val('true');
            //$scope.switcher.main = "open";
            $scope.switcher.content = true;
            $scope.stop = true;    
            
        }
        else {
            $scope.switcher.status = false;
            $('#rightSidebar').removeClass('open');
            $('#hidden-text').val('false');
            //$scope.switcher.main = "";   
            $scope.switcher.content = true;
            $scope.stop = true;
            
        }
    }

    $scope.getStop = function(){
        if($scope.stop == true){
            $scope.stop = false;  
        }


    }

    $scope.getStop = function(){
        if($scope.stop == true)
        {

            return $scope.animation.stop;
        }
        else {
            return $scope.animation.duration;
        }
    }

    $scope.get_arrowstop = function(){
         if($scope.stop == true)
        {

            return $scope.animation_arrow.opacity;
        }
        else {
            return $scope.animation_arrow.stop;
        }

    }
   

    function get_notifications(){
        var filter = {
            employees_pk : $scope.profile.pk
        }


        var promise = NotificationsFactory.get_notifications(filter);
        promise.then(function(data){

            $scope.notifications.data = data.data.result;
            $scope.notifications.status = true;
            $scope.notifications.hide = true;
            var count = data.data.result.length;
            

            
            if (count==0) {

                return $scope.notifications.count=" ";
            }
            else
            {   
                document.title = "Integrity ("+count+")";
                return $scope.notifications.count="(" +count +")";
            };

            $scope.animation_arrow.stop = '0';
            $scope.animation_arrow.opacity = '1';

            
           
        })
        .then(null, function(data){

            $scope.notifications.status = false;

            $scope.animation.stop = '0s';
            $scope.animation.duration = '2.6s';

            $scope.animation_arrow.stop = '0';
            $scope.animation_arrow.opacity = '0';
          


        });
    }




    $scope.goto = function(k){

        var location="";
       

            $timeout(function(){
                $scope.notifications.data[k].read='t';
            }, 2000);
           
       
        

        if($scope.notifications.data[k].table_from == "attritions"){
            location = "#/management/attrition";
       
        }
        else if($scope.notifications.data[k].table_from == "leave_filed"){
            location = "#/management/leaves";
        }
        else if($scope.notifications.data[k].table_from == "leave_filed_result"){
            location = "#/timesheet/leaves";
        }
        else if($scope.notifications.data[k].table_from == "manual_log"){
            location = "#/management/manual_logs";
        }
        else if($scope.notifications.data[k].table_from == "manual_log_result"){
            location = "#/timesheet";
        }
        else if($scope.notifications.data[k].table_from == "overtime"){
            location = "#/management/overtime";
        }
        else if($scope.notifications.data[k].table_from == "overtime_result"){
            location = "#/timesheet/overtime";
        }
        else if($scope.notifications.data[k].table_from == "leave_cancellation"){
            location = "#/management/leaves";
        }
        else if($scope.notifications.data[k].table_from == "request_result"){
            location = "#/timesheet/request";
        }
        var data=$scope.notifications.data[k];

        read_notifs(data);
        
        
        window.location = location;
        
    }

    function read_notifs(data){
        $scope.startFade=false;
        if (data.read == 'f') {

                $scope.read_notifs.status = true;   
                          
            }

        else{

                $scope.read_notifs.status = false;
            }

        var promise = NotificationsFactory.read_notifs(data);
        promise.then(function(data){

           
        })
        .then(null, function(data){
            
            $scope.read_notifs.status = false;

        });
    }

    $scope.change_menu = function(menu){
        for(var i in $scope.sidebar_menu){
            $scope.sidebar_menu[i] = false;
        }

        $scope.sidebar_menu[menu] = true;
    }


    function get_memo(){

        var promise = NotificationsFactory.get_memo();
        promise.then(function(data){

            $scope.memo.data = data.data.result;
            $scope.memo.status = true;
            $scope.memo.hide = true;
            
            $scope.animation_arrow.stop = '0';
            $scope.animation_arrow.opacity = '1';
           
            
           
        })
        .then(null, function(data){

            $scope.memo.status = false;

            $scope.animation.stop = '0s';
            $scope.animation.duration = '2.6s';

            $scope.animation_arrow.stop = '0';
            $scope.animation_arrow.opacity = '0';
          


        });
    }

    function memo_tracker(){


        var promise = NotificationsFactory.get_read_memo($scope.modal);
        promise.then(function(data){

            $scope.read_memo.data = data.data.result;
            $scope.read_memo.status = true;
            $scope.read_memo.hide = true;

            $scope.modal.count = data.data.result.length;

        })
        .then(null, function(data){

            $scope.memo.status = false;

        });
    }



    $scope.show_memo = function(k){

        $scope.modal = {

            title        : 'Memo',
            close        : 'Close',
            pk           : $scope.memo.data[k].pk,
            created_by_pk: $scope.memo.data[k].created_by_pk,
            memo         : $scope.memo.data[k].memo,
            created_by   : $scope.memo.data[k].created_by,
            date_created : $scope.memo.data[k].date_created,
            employees_pk : $scope.profile.pk
        };

        var promise = NotificationsFactory.read_memo($scope.modal);

        
        memo_tracker();


        ngDialog.openConfirm({
            template: 'ShowMemoModal',
            className: 'ngdialog-theme-plain custom-widtheightfifty',
           
            scope: $scope,
            showClose: false
        })
        
    }

    $scope.memo_tracker = function(){

        memo_tracker();

        $scope.modal2 = {

                title        : '',
                close        : 'Close',
                read_memo    : $scope.read_memo.data

            };

            ngDialog.openConfirm({
                template: 'ShowReadMemoModal',
                className: 'ngdialog-theme-plain custom-widthfoursixty',
                
                scope: $scope,
                showClose: false
            });

        
    }

    

    function get_calendar(){

        var promise = NotificationsFactory.get_calendar();
        promise.then(function(data){

            $scope.calendar.data = data.data.result;
            $scope.calendar.status = true;
            $scope.calendar.hide = true;
            var count = data.data.result.length;
            
            $scope.animation_arrow.stop = '0';
            $scope.animation_arrow.opacity = '1';

            
           
        })
        .then(null, function(data){

            $scope.calendar.status = false;

            $scope.animation.stop = '0s';
            $scope.animation.duration = '2.6s';

            $scope.animation_arrow.stop = '0';
            $scope.animation_arrow.opacity = '0';
          


        });
    }

    $scope.show_calendar = function(k){

       window.location = "#/calendar";
        
    }



});