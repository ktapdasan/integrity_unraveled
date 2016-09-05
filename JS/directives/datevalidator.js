app.directive('validDate', function () {
    return {
        restrict: 'A',
        require: 'ngModel',
        link: function (scope, element, attrs, control) {
            control.$parsers.push(function (viewValue) {
                var newDate = model.$viewValue;
                control.$setValidity("invalidDate", true);  
                if (typeof newDate === "object" || newDate == "") return newDate;  // pass through if we clicked date from popup
                if (!newDate.match(/^\d{1,2}\/\d{1,2}\/((\d{2})|(\d{4}))$/))
                    control.$setValidity("invalidDate", false);
                return viewValue;
            });
        }
    };
})