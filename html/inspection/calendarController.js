"use strict";
app.filter("asDate", function () {
    return function (input) {
        return new Date(input);
    }
});

app.controller('inspectionCalendar', function($scope,$compile,$log,$filter,$timeout,$http, ENV,companyService,userService){
    
    // calendar
    var date = new Date();
    var d = date.getDate();
    var m = date.getMonth() +1;
    var y = date.getFullYear();
    var events = [];
    var currentMonth = m;
    var currentYear = y;
    $scope.supplierId ='';
    $scope.inspectorid ='';
    $scope.locationId ='';

    $http.get(ENV.domain+'inspection.getInspectionCalendar?month='+m+'&year='+y).then(function(res){
        events = res.data;
        $('#calendar').fullCalendar({
            lang: 'en',
            header:{
                 left: 'prev',
                 center: 'title',
                 right: 'next'
            },
            eventSources: [
                {
                    events: events
                }
            ]
            ,
          eventRender: function(event, element) {
            if(event.icon){
              element.find(".fc-title").prepend(event.icon+"<br>");
            }
          }  
        });

        $('.fc-next-button, .fc-prev-button').click(function(){
            getEvent();
            return false;
        });
    });

    $scope.locations = [];
    companyService.getLocations().then(function(res){
        $scope.locations = res;
    });

    $scope.suppliers = [];
    companyService.getByType(window.globalVariable.company_kind.supplier).then(function(res){
        $scope.suppliers = res;
    });

    $scope.inspectors = [];
    userService.listInspection().then(function(res){
        $scope.inspectors = res;
    });

     $scope.changeLocation = function(){
        $scope.supplierId ='';
        //bug select2
            $('#supplierId').select2('val',"");
        //
        $http.get(ENV.domain+'dashboard.getSupplier?locationid='+$scope.locationId).then(function(res){
            $scope.suppliers = res.data;
        });
    };

    $scope.searchEvents = getEvent;
    function getEvent(){
        var date =  new Date($('.calendar').fullCalendar( 'getDate' ));
        currentMonth = date.getMonth() + 1;
        currentYear =  date.getFullYear();
        var api = ENV.domain+'inspection.getInspectionCalendar?month='+currentMonth+'&year='+currentYear;
         if($scope.locationId != ''){
            api =api + "&location=" + $scope.locationId;
        }
        if($scope.supplierId !=''){
                api =api + "&supplier=" + $scope.supplierId;
        }
        if($scope.inspectorid !=''){
                api =api + "&inspector=" + $scope.inspectorid;
        }
        $http.get(api).then(function(res){
            $('.calendar').fullCalendar( 'removeEventSource', events);
            $('.calendar').fullCalendar( 'addEventSource', res.data);  
            events = res.data;       
            $('.calendar').fullCalendar( 'refetchEvents' );
        });
    }

      $timeout(function () {
        pageSetUp();
    }, 100);

});
