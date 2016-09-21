"use strict";
app.filter("asDate", function () {
    return function (input) {
        return new Date(input);
    }
});
app.controller('inspectionSchedule', ['$window','Notification','$scope','Storage','$timeout','ENV','DTOptionsBuilder', 'DTColumnBuilder','DTColumnDefBuilder','companyService','userService','$http','$state', function($window,Notification,$scope,Storage,$timeout,ENV,DTOptionsBuilder, DTColumnBuilder,DTColumnDefBuilder,companyService,userService,$http,$state){


    //define model of page
    var OI = this;
    OI.customer = '';
    OI.supplier = '';
    OI.customers = [];
    OI.suppliers = [];
    
    // OI.dtInstance = {};

    OI.ObjectCustomer = {};
    OI.ObjectSupplier = {};
    companyService.getByType(window.globalVariable.company_kind.customer).then(function(data){
        OI.customers = data
    });
    companyService.getByType(window.globalVariable.company_kind.supplier).then(function(data){
        OI.suppliers = data;
    });
   
    OI.selectCustomer = function(){
        OI.cusNum = OI.customer;
    }
    OI.selectSupplier = function(){
        OI.supNum = OI.supplier;
    }

    var date_shown = "dd-M-yy";
    var date_range = {};
   
    $scope.sizes = [ {value: 'cw', name: 'This Week'},
    {value: 'lw', name: 'Last Week'},
    {value: 'cm', name: 'This Month'},
    {value: 'lm', name: 'Last Month'},
    {value: 'cq', name: 'This Quarter'},
    {value: 'lq', name: 'Last Quarter'},
    {value: 'dr', name: 'Input Dates'}];

    $scope.item = $scope.sizes[2];

    $scope.tFromDate="";
    $scope.tEndDate="";
     var today = new Date();
    date_range  = {
                    start: new Date(today.getFullYear(), today.getMonth(), 1),
                    end: Date.getLastMonthDate()
                };
    $scope.tFromDate=date_range.start.toFormat(date_shown);
    $scope.tEndDate=date_range.end.toFormat(date_shown);
    $scope.update = function() {
        var today = new Date();
        switch($scope.item.value) {
            case 'cw': date_range = today.getCurrentWeek(); break;
            case 'cm':
                date_range = {
                    start: new Date(today.getFullYear(), today.getMonth(), 1),
                    end: Date.getLastMonthDate()
                };
                break;
            case 'cq': date_range = Date.getQuarterRange(today.getCurrentQuarter()); break;
            case 'lw':
                var last = new Date();
                last.setDate(today.getDate() - 7);
                date_range = last.getCurrentWeek();
                break;
            case 'lm':
                date_range = {
                    start: new Date(today.getFullYear(), today.getMonth() - 1, 1),
                    end: Date.getLastMonthDate(today.getMonth() - 1)
                };
                break;
            case 'lq': date_range = Date.getQuarterRange(today.getCurrentQuarter() - 1); break;
            case 'dr':
                $('#tFromDate').attr('disabled', false);
                $('#tEndDate').attr('disabled', false);
                break;
        };

        if (this.value != 'dr') {
            $scope.tFromDate=date_range.start.toFormat(date_shown);
            $scope.tEndDate=date_range.end.toFormat(date_shown);
        };
      }

    $scope.selected = {};

    $scope.dtInstance = {};

    //begin
        $scope.dtOptions = DTOptionsBuilder
                            .newOptions()
                             .withButtons([
                            'print',
                            'excel'
                        ])
                            .withPaginationType('full_numbers')
                            .withColumnFilter({
                                sPlaceHolder: 'head:before',
                                aoColumns: [{
                                    type: 'text'
                                }, {
                                    type: 'text'
                                     
                                }, {
                                    type: 'text'
                                }, {
                                    type: 'text'
                                }, {
                                    type: 'text'
                                }, {
                                    type: 'text'
                                }, {
                                    type: 'text'
                                }, {
                                    type: 'text'
                                }, {
                                    type: 'text'
                                }, {
                                    type: 'text'
                                }, {
                                    type: 'text'
                                }, {
                                    type: 'text'
                                }]
            });


    $scope.dtColumnDefs = [];


    $scope.ListInspectionSchedule = [];
    initListInspectionSchedule();

    $scope.searchOrder = function(){
        initListInspectionSchedule();
    };

    function initListInspectionSchedule(){

        var s1='';
        var s2='';
        var s3='';
        var s4='';
        
        if($scope.tFromDate != ''){
            s1= 'start='+$scope.tFromDate+'&';
        }

        if($scope.tEndDate != ''){
            s2= 'end='+$scope.tEndDate+'&';
        }

        if(OI.customer != ''){
            s3= 'cusid='+OI.customer+'&';
        }

        if(OI.supplier != ''){
            s4= 'supid='+OI.supplier+'&';
        }

        var sSearch = s1+s2+s3+s4;
         $http.get(ENV.domain+'inspection.execute?'+sSearch).then(function(data){
            $scope.ListInspectionSchedule = data.data;
        });
    }
    //end

    $scope.listInspection =[];

    userService.listInspection().then(function(data){
       $scope.listInspection  = data;

    });


    function getInspectorName1(id){
        if(id == '')return $scope.inspectorname1 ='';
        angular.forEach($scope.listInspection,function(data){
            if(data.id_user == id){
                return $scope.inspectorname1 = data.user_name;
            }
        })
    }

      function getInspectorName2(id){
        if(id == '')return $scope.inspectorname2 ='';
        angular.forEach($scope.listInspection,function(data){
            if(data.id_user == id){
                return $scope.inspectorname2 = data.user_name;
            }
        })
    }


    $scope.inspection_schedule_id = null;

    $scope.setInspectionSchedule = function(inspector1,inspector2,plan_date,inspection_schedule_id){
        
        $scope.inspector1 =   inspector1;
        $scope.inspector2 = inspector2;
        $scope.plan_date = new Date(plan_date).toFormat(date_shown);
        $scope.inspection_schedule_id  = inspection_schedule_id ;

        $("#inspector2").select2('val',$scope.inspector2);
        $("#inspector1").select2('val',$scope.inspector1);
    }

    // ui-sref="home.inspection.report({pid:orderItem.product_item_no,abid:orderItem.abid})" data-toggle="modal" data-target="#itemInspected"
    $scope.choiseInspectionReport = function(index){
        $http.get(ENV.domain+'inspection.execute?id='+$scope.ListInspectionSchedule[index].inspection_schedule_id).then(function(res){
            if(res.data.length > 0){
                $scope.listItemSet= res.data;
                console.log($scope.listItemSet)
                getInspectorName1($scope.listItemSet[0].inspector1);
                getInspectorName2($scope.listItemSet[0].inspector2);
                $('#itemInspected').modal('show');
            }
            else{
                if($scope.ListInspectionSchedule[index].list_ins_no == ''){
                    //go to create new inspection report
                    $state.go('home.inspection.report',{pid:$scope.ListInspectionSchedule[index].product_item_no,abid:$scope.ListInspectionSchedule[index].abid,quantity:1});

                }else{
                    //show modal list inspection report
                    $http.get(ENV.domain+'inspection.execute?abid='+$scope.ListInspectionSchedule[index].abid).then(function(res){
                    console.log(res);
                    if(res.data.length >0){
                        $scope.listInspectionReport = res.data;
                        $('#listInspected').modal('show');
                    }
                    })
                }
                
            }
        })

    }

    $scope.goReportEdit = function(index){
        $state.go('home.inspection.report',{pid:$scope.listInspectionReport[index].inspected_product_item_no,abid:$scope.listInspectionReport[index].abid,quantity:1,insid:$scope.listInspectionReport[index].inspectionid});
        $('#listInspected').modal('hide');
        $('body').removeClass('modal-open');
        $('.modal-backdrop').remove();
    }


    $scope.goReport = function(index){
        $state.go('home.inspection.report',{pid:$scope.listItemSet[index].product_item_no,abid:$scope.listItemSet[index].abid,quantity:$scope.listItemSet[index].quantity_product_item_set,parent:$scope.listItemSet[index].parent});
        $('#itemInspected').modal('hide');
        $('body').removeClass('modal-open');
        $('.modal-backdrop').remove();
    }

    $scope.saveInspectionSchedule = function(){
        // console.log(Storage.get('user'));
         var data = {id:$scope.inspection_schedule_id,inspector1:$scope.inspector1,inspector2:$scope.inspector2,plan_date:$scope.plan_date,updateby:'rasia'};
          $http.put(ENV.domain+'inspection.editSchedule',data).then(function(data){
            if(data.data.success){
                $('#editSchedule').modal('hide');
                Notification.success({message : data.data.message,delay : 2000});
                initListInspectionSchedule();

            }else{
                 Notification.error({message : data.data.message,delay : 2000});
            }
        });
    }

    $scope.goPDF = function(index){
        $window.open('fileUpload/inspectionReport/'+$scope.ListInspectionSchedule[index].inspection_no+".pdf");
    }

    $scope.goSubPDF = function(index){
        $window.open('fileUpload/inspectionReport/'+$scope.listItemSet[index].inspection_no+".pdf");
    }



    $timeout(function () {
        $("#tFromDate").datepicker({ dateFormat: "dd-M-yy" }).val();
        $("#tEndDate").datepicker({ dateFormat: "dd-M-yy" }).val();
        $("#plan_date").datepicker({ dateFormat: "dd-M-yy" }).val();
        $( ".datepicker" ).datepicker( "option", "prevText", "<" );
        $( ".datepicker" ).datepicker( "option", "nextText", ">" );
        $( ".datepicker" ).datepicker( "option", "firstDay", 1 );
        pageSetUp();
    }, 100)


}]);

