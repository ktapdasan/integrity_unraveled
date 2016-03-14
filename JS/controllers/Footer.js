app.controller('Footer', function(
  										$scope,
                                        $cookies,
                                        SessionFactory,
                                        EmployeesFactory,
                                        md5,
                                        UINotification
  									){

    init();

    $scope.pk = null;
    $scope.profile = {};

    $scope.comments = {
        comment : ''
    };

    var audio1 = new Audio('./ASSETS/tts/1.mp3');
    var audio2 = new Audio('./ASSETS/tts/2.mp3');
    var audio3 = new Audio('./ASSETS/tts/3.mp3');
    var audio4 = new Audio('./ASSETS/tts/4.mp3');
    var audio5 = new Audio('./ASSETS/tts/5.mp3');
    var audio6 = new Audio('./ASSETS/tts/6.mp3');
    var audio7 = new Audio('./ASSETS/tts/7.mp3');
    var audio8 = new Audio('./ASSETS/tts/8.mp3');
    var audio9 = new Audio('./ASSETS/tts/9.mp3');

    $scope.done = true;
    $scope.comment = false;
    $scope.counter = 0;
    $scope.current_msg = "";
    $scope.messages = [
        "Hi, My name is Ken.",
        "We at IIT are requesting everyone",
        "to share your comments,",
        "suggestions and violent reactions. ",
        "Whether positive or negative, ",
        "to help us improve our system.",
        "Your comment will be saved anonymously,",
        "so do not be afraid to share.",
        "Let's start now ^_^"
    ];

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

    $scope.logout = function(){
        var promise = SessionFactory.logout();
        promise.then(function(data){
            window.location = './login.html';
        })
    }

    function get_profile(){
        var filters = { 
            'pk' : $scope.pk
        };

        var promise = EmployeesFactory.profile(filters);
        promise.then(function(data){
            $scope.profile = data.data.result[0];

            var commented = $cookies.get('commented');
            
            if(commented){
                $scope.counter = 7;
                $scope.next_slide();
            }
            else {
                $scope.current_msg = $scope.messages[$scope.counter];
                audio1.play();    
            }
        })   
    }

    $scope.next_slide = function(){
        $scope.counter++;
        if($scope.counter == 0){
            audio1.play();
        }
        else if($scope.counter == 1){
            audio2.play();
        }
        else if($scope.counter == 2){
            audio3.play();
        }
        else if($scope.counter == 3){
            audio4.play();
        }
        else if($scope.counter == 4){
            audio5.play();
        }
        else if($scope.counter == 5){
            audio6.play();
        }
        else if($scope.counter == 6){
            audio7.play();
        }
        else if($scope.counter == 7){
            audio8.play();
        }
        else if($scope.counter == 8){
            audio9.play();
        }

        if($scope.counter > $scope.messages.length - 1){
            $scope.comment = true;
        }
        $scope.current_msg = $scope.messages[$scope.counter];
        
        
    }

    $scope.submit_comment = function(){
        if($scope.comments.comment.replace(/\s/g,'') == ""){
            return false;
        }

        var filter = {
            tool : 'Integrity',
            feedback : $scope.comments.comment
        };

        var promise = EmployeesFactory.submit_comment(filter);
        promise.then(function(data){
            $scope.comments.comment = "";
            $scope.done = false;

            UINotification.success({
                                        message: 'Your comment has been successfully saved.', 
                                        title: 'SUCCESS', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });

        })
        .then(null, function(data){
            UINotification.error({
                                        message: 'An error occurred while saving your comment.', 
                                        title: 'FAILED', 
                                        delay : 5000,
                                        positionY: 'top', positionX: 'right'
                                    });
        });
    }
});