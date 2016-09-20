app
.filter("asDate", function () {
    return function (input) {
        return new Date(input);
    }
});
app.controller('orderList', ['$scope','$q','$filter','$compile','$timeout','ENV','DTOptionsBuilder', 'DTColumnBuilder','DTColumnDefBuilder','companyService','$http', function($scope,$q,$filter,$compile,$timeout,ENV,DTOptionsBuilder, DTColumnBuilder,DTColumnDefBuilder,companyService,$http){


    //define model of page
    var OL = this;
    OL.customer = '';
    OL.supplier = '';
    OL.customers = [];
    OL.suppliers = [];
    
    // OL.dtInstance = {};

    OL.ObjectCustomer = {};
    OL.ObjectSupplier = {};
    companyService.getByType(window.globalVariable.company_kind.customer).then(function(data){
        OL.customers = data
    });
    companyService.getByType(window.globalVariable.company_kind.supplier).then(function(data){
        OL.suppliers = data;
    });
   
    OL.selectCustomer = function(){
        OL.cusNum = OL.customer;
    }
    OL.selectSupplier = function(){
        OL.supNum = OL.supplier;
    }

    var date_shown = "dd-M-yy";
    var date_range = {};
   
    $scope.sizes = [ 
    {value: 'td', name: 'Today'},
    {value: 'cw', name: 'This Week'},
    {value: 'lw', name: 'Last Week'},
    {value: 'cm', name: 'This Month'},
    {value: 'lm', name: 'Last Month'},
    {value: 'cq', name: 'This Quarter'},
    {value: 'lq', name: 'Last Quarter'},
    {value: 'cy', name: 'This Year'},
    {value: 'ly', name: 'Last Year'},
    {value: 'dr', name: 'Input Dates'}
    ];

    $scope.item = $scope.sizes[9];

    $scope.tFromDate="";
    $scope.tEndDate="";
     var today = new Date();
    // date_range = today.getCurrentWeek();
    // $scope.tFromDate=date_range.start.toFormat(date_shown);
    // $scope.tEndDate=date_range.end.toFormat(date_shown);
    $scope.update = function() {
        var today = new Date();
        switch($scope.item.value) {
            case 'td': 
                date_range = {
                    start: today,
                    end: today
                }; 
                break;
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
            case 'cy':
                date_range = {
                    start: new Date(today.getFullYear(),0, 1),
                    end: Date.getLastMonthDate(11)
                };
                break;
            case 'ly':
                date_range = {
                    start: new Date(today.getFullYear()-1,0, 1),
                    end: Date.getLastMonthDate(11,today.getFullYear()-1)
                };
                break;
            case 'dr':
                $scope.tFromDate='';
                $scope.tEndDate='';
                $('#tFromDate').val('');
                $('#tEndDate').val('');
                break;
        };
        if ($scope.item.value != 'dr') {
            $scope.tFromDate=date_range.start.toFormat(date_shown);
            $scope.tEndDate=date_range.end.toFormat(date_shown);
        }else{
            $scope.tFromDate='';
            $scope.tEndDate='';
        }
      }

     $scope.selected = {};


    var listOrder = [];
    

    $scope.dtOptions  = DTOptionsBuilder.fromFnPromise(function() {return initListOrder()})
           .withOption('createdRow', function(row, data, dataIndex) {
                            // Recompiling so we can bind Angular directive to the DT
                            $compile(angular.element(row).contents())($scope);
                        })
                        .withPaginationType('full_numbers')
                        .withButtons([
                            'print',
                            'excel'
                        ])
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
                            }]
    });

    $scope.dtColumns = [
        DTColumnBuilder.newColumn('order_no').withTitle('Order No.').withClass('dt-body-left'),
        DTColumnBuilder.newColumn('position_no').withTitle('Pos.').withClass('dt-body-center'),
        DTColumnBuilder.newColumn('abno').withTitle('AB').withClass('dt-body-center'),
        DTColumnBuilder.newColumn('product_item_no').withTitle('Product Item No.').withClass('dt-body-left'),
        DTColumnBuilder.newColumn('product_line_name_english').withTitle('Product Line').withClass('dt-body-left'),
        DTColumnBuilder.newColumn('product_item_name_english').withTitle('Product Item Name').withClass('dt-body-left'),
        DTColumnBuilder.newColumn('ordered_quantity').withTitle('Order Q\'ty').renderWith(renderQty).withClass('dt-body-right'),
        DTColumnBuilder.newColumn('shipped_quantity').withTitle('AB Q\'ty').renderWith(renderQty).withClass('dt-body-right'),
        DTColumnBuilder.newColumn('accepted').withTitle('Accepted Q\'ty').renderWith(renderQty).withClass('dt-body-right'),
        DTColumnBuilder.newColumn('remain').withTitle('Remain Qty.').renderWith(renderQty).withClass('dt-body-right'),
        DTColumnBuilder.newColumn('confirmed_shipping_date').withTitle('Conf. Ship. Date').renderWith(dateFormat).withClass('dt-body-center'),
        DTColumnBuilder.newColumn(null).withTitle('Edit').notSortable().renderWith(function(data,type,full,meta){return '<td class="btn_edit"><a class="cursor" ui-sref="home.order.edit({id: '+data.orderid+'})"><i class="fa fa-pencil-square-o"></i></a></td>'})
    ];
   
  	$scope.dtColumnDefs = [];
    $scope.dtInstance = {};
   
    function dateFormat(data){
        return $filter('date')(new Date(data), 'dd-MMM-yyyy');
    } 

    function renderQty(data){
        return $filter('number')(data, 0);
    }

    function renderMoney(data){
        return $filter('number')(data,2);
    }


    $scope.unfinishedab = true;


    $scope.searchOrder = function(){
        initListOrder();
        $scope.dtInstance.reloadData();
    };

    function initListOrder(){
        var deferred = $q.defer();
        var s1='';
        var s2='';
        var s3='';
        var s4='';
        var s5='finish=0';
        
        if($scope.tFromDate != ''){
            s1= 'start='+$scope.tFromDate+'&';
        }

        if($scope.tEndDate != ''){
            s2= 'end='+$scope.tEndDate+'&';
        }

        if(OL.customer != ''){
            s3= 'cusid='+OL.customer+'&';
        }

        if(OL.supplier != ''){
            s4= 'supid='+OL.supplier+'&';
        }

        if($scope.unfinishedab){
            s5= 'finish=1';
        }

        var sSearch = s1+s2+s3+s4+s5;
        $http.get(ENV.domain+'order.execute?'+sSearch).then(function(data){
            listOrder = data.data;
            deferred.resolve(listOrder);
        });
        return deferred.promise;
        
    }
    //end


    $timeout(function () {
   
        $("#tFromDate").datepicker({ dateFormat: "dd-M-yy" }).val();
        $("#tEndDate").datepicker({ dateFormat: "dd-M-yy" }).val();
        $( ".datepicker" ).datepicker( "option", "prevText", "<" );
        $( ".datepicker" ).datepicker( "option", "nextText", ">" );
        $( ".datepicker" ).datepicker( "option", "firstDay", 1 );
        pageSetUp();
    }, 100)


}]);