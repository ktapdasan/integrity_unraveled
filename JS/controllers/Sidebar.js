app.controller('Sidebar', function(
  										$scope
  									){


    $scope.switcher = {};
    $scope.switcher.main = "";

    //$scope.stop = true; //how to stop the shaking

    $scope.toggle_switcher = function(){
        if($scope.switcher.main == ""){
            $scope.switcher.main = "open";
            $scope.switcher.content = true;
            $scope.stop = true;
       
           
         }
        else {
            $scope.switcher.main = "";   
            $scope.switcher.content = false;
            $scope.stop = false;
            
         }


    }

    $scope.getStop = function(){
        if($scope.stop == true)
        {
          return '0s';
        }
        else
        {

          return '1s';
        }



    }
    
});