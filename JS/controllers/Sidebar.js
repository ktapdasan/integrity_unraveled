app.controller('Sidebar', function(
  										$scope
  									){


    $scope.switcher = {};
    $scope.switcher.main = "";

    $scope.toggle_switcher = function(){
        if($scope.switcher.main == ""){
            $scope.switcher.main = "open";
            $scope.switcher.content = true;
        }
        else {
            $scope.switcher.main = "";   
            $scope.switcher.content = false;
        }
    }

    
});