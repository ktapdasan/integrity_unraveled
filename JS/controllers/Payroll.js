app.controller('Payroll', function(
  										$scope,
                                        SessionFactory,
                                        EmployeesFactory,
                                        TimelogFactory,
                                        ngDialog,
                                        UINotification,
                                        CutoffFactory,
                                        DefaultvaluesFactory,
                                        LeaveFactory,
                                        PagerService,
                                        hotkeys,
                                        cfpLoadingBar,
                                        md5,
                                        $filter
  									){

    $scope.profile = {};

    $scope.default_values = [];

    $scope.filter = {};
    $scope.filter.max_count = "10";
    $scope.filter.column = "Employee Name";
    $scope.filter.order = "ASC";

    $scope.cutoff = {};

    $scope.employees = {};
    $scope.items = [];

    $scope.dashboard = {
        active_employees : 0,
        accepted_employees : 0
    };
    
    $scope.pager = {};
    $scope.setPage = setPage;
    $scope.current_page = 1;

    $scope.pay_periods = {
        daily : false,
        weekly : false,
        semimonthly : true,
        monthly : false,
        annually : false
    };

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

            default_values();
            
            
        })   
    } 

    function default_values(){
        var promise = DefaultvaluesFactory.fetch_all();
        promise.then(function(data){
            for(var i in data.data.result){
                if(!$scope.default_values[data.data.result[i].name]){
                    $scope.default_values[data.data.result[i].name] = {};
                }

                $scope.default_values[data.data.result[i].name]['pk'] = data.data.result[i].pk;
                $scope.default_values[data.data.result[i].name]['details'] = JSON.parse(data.data.result[i].details);
            }

            var a = $scope.default_values.cutoff_dates.details;
            //a.dates = JSON.parse(a.dates);
             
            var new_date = new Date();
            var dd = new_date.getDate();
            var mm = new_date.getMonth()+1; //January is 0!
            var yyyy = new_date.getFullYear();

            if(a.cutoff_types_pk == "2"){ //bimonthly
                var first = a.dates.first;
                var second = a.dates.second;
                
                if(dd >= parseInt(second.from)){
                    $scope.filter.datefrom = new Date(mm+"/"+second.from+"/"+yyyy);
                    //mm++;
                    $scope.filter.dateto = new Date(mm+"/"+second.to+"/"+yyyy);
                }
                else {
                    $scope.filter.datefrom = new Date(mm+"/"+first.from+"/"+yyyy);

                    

                    $scope.filter.dateto = new Date(mm+"/"+first.to+"/"+yyyy);   
                }
            }
            else { //monthly
                $scope.filter.datefrom = new Date(mm+"/"+a.dates.from+"/"+yyyy);
                $scope.filter.dateto = new Date(mm+"/"+a.dates.to+"/"+yyyy);
            }

            $scope.cutoff = {
                from: $scope.filter.datefrom,
                from_html: $filter('date')($scope.filter.datefrom, "MMMM dd"),
                from_cutoff: $filter('date')($scope.filter.datefrom, "yyMMdd"),
                to: $scope.filter.dateto,
                to_html: $filter('date')($scope.filter.dateto, "MMMM dd"),
                to_cutoff: $filter('date')($scope.filter.dateto, "yyMMdd")
            };

            active_employees();
            list();
        })
    }

    function active_employees(){
        var promise = EmployeesFactory.count();
        promise.then(function(data){
            $scope.dashboard.active_employees = data.data.result[0].count;

            accepted_employees();
        })
        .then(null, function(data){
            $scope.dashboard.active_employees = 0;
        });
    }

    function accepted_employees(){
        var filter = {
            cutoff: $scope.cutoff.from_cutoff+"-"+$scope.cutoff.to_cutoff
        }

        var promise = EmployeesFactory.accepted_count(filter);
        promise.then(function(data){
            $scope.dashboard.accepted_employees = ((data.data.result[0].count / $scope.dashboard.active_employees) * 100).toFixed(1);
        })
        .then(null, function(data){
            $scope.dashboard.accepted_employees = 0;
        });
    }

    $scope.list = function(){
        list();
    }

    $scope.searchString = function(){
        $scope.employees.status = false;
        $scope.items = [];
        var data = $scope.employees.data;
        var new_data = [];

        if($scope.filter.str != ""){
            var str = $scope.filter.str.toLowerCase();
            for(var i in data){
                if(
                    data[i].details.personal.last_name.toLowerCase().includes(str) ||
                    data[i].details.personal.first_name.toLowerCase().includes(str) ||
                    data[i].details.personal.middle_name.toLowerCase().includes(str)
                ){
                    new_data.push(data[i]);
                    $scope.employees.status = true;
                }
            }
        }
        else {
            $scope.employees.status = true;
            new_data = data;
        }
        
        $scope.items = new_data;
    }

    function list(){
        cfpLoadingBar.start();
        $scope.employees.status = false;
        $scope.employees.data = [];

        var filter = {
            cutoff: $scope.cutoff.from_cutoff+"-"+$scope.cutoff.to_cutoff,
            column: $scope.filter.column,
            order: $scope.filter.order
        }

        var promise = EmployeesFactory.accepted_list(filter);
        promise.then(function(data){

            $scope.employees.status = true;
            $scope.employees.data = data.data.result;

            // $scope.employees.data.push(
            //     {   
            //         employees_pk : 1000,
            //         employee_id : '1',
            //         last_name : 'Pascual',
            //         first_name : 'Freya',
            //         middle_name : 'Cagungao',
            //         details : ''
            //     }
            // );

            // $scope.employees.data.push(
            //     {   
            //         employees_pk : 1001,
            //         employee_id : '2',
            //         last_name : 'Pascual',
            //         first_name : 'Rafael Jr.',
            //         middle_name : 'Cagungao',
            //         details : ''
            //     }
            // );

            var working_hours = $scope.default_values.working_hours.details.hrs;

            $scope.employees.count = 0;
            console.log($scope.employees.data);

            for(var i in $scope.employees.data){
                $scope.employees.count++;
                
                if($scope.employees.data[i].details){
                    $scope.employees.data[i].details = JSON.parse($scope.employees.data[i].details); 
                    //console.log($scope.employees.data[i]);
                    if($scope.employees.data[i].details.company.salary){
                        var rate_type = $scope.employees.data[i].rate_type;
                        var pay_period = $scope.employees.data[i].pay_period;
                        
                        var days=0;
                        for(var j in $scope.employees.data[i].details.company.work_schedule){
                            if($scope.employees.data[i].details.company.work_schedule[j]){
                                days++;
                            }
                        }

                        //313 6 days
                        //261 5 days
                        var divisor = 313; //need to be put in admin soon
                        if(days < 6){
                            divisor = 261; //need to be put in admin soon
                        }

                        var rate = parseFloat($scope.employees.data[i].details.company.salary.details.amount);
                        var daily_rate = 0;

                        if(rate_type == "Monthly"){

                            daily_rate = (rate * 12) / divisor;
                            
                            // if(pay_period == "Annually"){
                            //     rate = rate * 12;
                            // }
                            // else 
                            if(pay_period == "Monthly"){
                                //don't do anything with the rate
                            }
                            else if(pay_period == "Semi-Monthly"){
                                rate = rate / 2;
                            }
                            else if(pay_period == "Weekly"){
                                //rate = rate / 4;

                                //weekly will compute daily rate
                                rate = daily_rate * (parseInt($scope.employees.data[i].days) - parseInt($scope.employees.data[i].absent));
                            }
                            // else if(pay_period == "Daily"){
                            //     rate = rate / 26;
                            // }
                        }
                        else if(rate_type == "Daily"){

                            daily_rate = rate;

                            // if(pay_period == "Annually"){
                            //     rate = rate * divisor;
                            // }
                            // else 
                            if(pay_period == "Monthly"){
                                rate = ((rate * divisor) / 12);
                            }
                            else if(pay_period == "Semi-Monthly"){
                                rate = ((rate * divisor) / 12) / 2;
                            }
                            else if(pay_period == "Weekly"){
                                //rate = rate * days;

                                rate = rate * (parseInt($scope.employees.data[i].days) - parseInt($scope.employees.data[i].absent));
                                //weekly will compute daily rate
                                //don't do anything
                            }
                            // else if(pay_period == "Daily"){
                            //     //Don'
                            // }
                        }
                        else if(rate_type == "Hourly"){

                            daily_rate = rate * working_hours;

                            // if(pay_period == "Annually"){
                            //     rate = (rate * working_hours) * divisor;
                            // }
                            // else 
                            if(pay_period == "Monthly"){
                                rate = ((rate * working_hours) * divisor) / 12;
                            }
                            else if(pay_period == "Semi-Monthly"){
                                rate = (((rate * working_hours) * divisor) / 12) / 2;
                            }
                            else if(pay_period == "Weekly"){
                                //rate = (rate * working_hours) * days;
                                rate = (rate * working_hours) * (parseInt($scope.employees.data[i].days) - parseInt($scope.employees.data[i].absent));
                            }
                            // else if(pay_period == "Daily"){
                            //     rate = rate * working_hours;
                            // }
                        }

                        $scope.employees.data[i].daily_rate = daily_rate;
                        

                        //$scope.employees.data[i].daily_rate = (($scope.employees.data[i].details.company.salary.details.amount * 12) / divisor).toFixed(2);
                        // var amt = 0;
                        // if(pay_period == "Annually"){
                        //     amt = rate / divisor;
                        // }
                        // else if(pay_period == "Monthly"){
                        //     amt = (rate * 12) / divisor;
                        // }
                        // else if(pay_period == "Semi-Monthly"){
                        //     amt = ((rate * 2) * 12) / divisor;
                        // }
                        // else if(pay_period == "Weekly"){
                        //     amt = rate / days;
                        // }
                        // else if(pay_period == "Daily"){
                        //     amt = rate;
                        // }

                        // $scope.employees.data[i].daily_rate = amt.toFixed(2);
                            
                    }

                    var allowances = 0;
                    for(var j in $scope.employees.data[i].details.company.salary.allowances){
                        allowances += parseFloat($scope.employees.data[i].details.company.salary.allowances[j]);
                    };

                    $scope.employees.data[i].absent_amt = $scope.employees.data[i].absent * $scope.employees.data[i].daily_rate;

                    var hour_rate = parseFloat($scope.employees.data[i].daily_rate) / parseFloat(working_hours);
                    
                    //$scope.employees.data[i].cutoff_rate = $scope.employees.data[i].daily_rate * $scope.employees.data[i].days;
                    $scope.employees.data[i].cutoff_rate = rate;

                    $scope.employees.data[i].tardiness = (parseFloat($scope.employees.data[i].tardiness) * parseFloat(hour_rate)).toFixed(2);
                    $scope.employees.data[i].undertime = (parseFloat($scope.employees.data[i].undertime) * parseFloat(hour_rate)).toFixed(2);
                    $scope.employees.data[i].overtime = (parseFloat($scope.employees.data[i].overtime) * parseFloat(hour_rate)).toFixed(2);

                    $scope.employees.data[i].deduction = parseFloat($scope.employees.data[i].tardiness) + parseFloat($scope.employees.data[i].undertime) + parseFloat($scope.employees.data[i].absent);
                    $scope.employees.data[i].adjustment = parseFloat($scope.employees.data[i].overtime) + parseFloat($scope.employees.data[i].dps);
                    $scope.employees.data[i].allowances = allowances;
                    
                    $scope.employees.data[i].gross = (parseFloat($scope.employees.data[i].cutoff_rate) + parseFloat($scope.employees.data[i].adjustment) + parseFloat($scope.employees.data[i].allowances)) - parseFloat($scope.employees.data[i].deduction);
                }
            }

            setPage();
            cfpLoadingBar.complete();
            // console.log($scope.employees.data);
            // console.log($scope.default_values);
        })
        .then(null, function(data){
            $scope.employees.status = false;
            cfpLoadingBar.complete();
        });
    }

    $scope.setPage = function(p){
        $scope.current_page = p;

        setPage();
    }

    function setPage() {
        if($scope.current_page < 1){
            //we should add 1 because once you click
            //the pagination's previous button, current page
            //will be deducted by 1
            $scope.current_page++;
        }
        else if($scope.current_page > $scope.pager.totalPages){
            //we should deduct 1 because once you click
            //the pagination's next button, current page
            //will be added by 1
            $scope.current_page--;
        }
        else {
            // get pager object from service
            $scope.pager = PagerService.GetPager($scope.employees.data.length, $scope.current_page, parseInt($scope.filter.max_count));

            // get current page of items
            $scope.items = $scope.employees.data.slice($scope.pager.startIndex, $scope.pager.endIndex + 1);
        }
    }

    $scope.paginateLeft = function(){
        $scope.current_page--;
        if($scope.current_page < 1){
            $scope.current_page = 1;
        }
        
        setPage();
    }
    $scope.paginateRight = function(){
        $scope.current_page++;

        if($scope.current_page > $scope.employees.data.length){
            $scope.current_page = $scope.employees.data.length
        }

        setPage();
    }

    $scope.descend = function(){
        $scope.filter.order = 'DESC';

        list();
    }

    $scope.accept_timesheet = function(){
        var a = confirm("Are you sure you want generate payroll?");
        if(a){

        }
        else {

        }
    }
});

