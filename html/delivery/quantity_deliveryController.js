"use strict";
app.filter("asDate", function () {
    return function (input) {
        return new Date(input);
    }
});
app.controller('quantity_delivery', ['$http','$scope','$timeout','ENV','DTOptionsBuilder','DTColumnBuilder','companyService','$filter', function($http,$scope,$timeout,ENV,DTOptionsBuilder,DTColumnBuilder,companyService,$filter){

	//begin
	$scope.showTable = false;
		$scope.dtOptions = DTOptionsBuilder.fromSource('');
	    $scope.dtColumns = [
	        DTColumnBuilder.newColumn(null)
	    ];
	$scope.dtInstance = {};

    $scope.etd_from ='';
    $scope.etd_to ='';

    $scope.locations = [];
    companyService.getLocations().then(function(res){
        $scope.locations = res;
    });


    function renderQty(data){
        return $filter('number')(data, 0);
    }

    function renderMoney(data){
        return $filter('number')(data,2);
    }

    function renderDate(data){
    	return $filter('date')(new Date(data), 'dd-MMM-yyyy');
    }

    function renderPercent(data, type, full){
    	var percent = $filter('number')(full.re_qty/full.ab_qty * 100,2) + '%';
    	return percent;
    }

    $scope.DetailOrderData = function(evaluationid){
		var url = ENV.domain+'inspectionStatistic.execute';
		var data = {
				"etd_date_from": $scope.etd_from,
				"etd_date_to": $scope.etd_to,
				"key": evaluationid
			};
    	switch(evaluationid){
    		case 'perSupplier':
    			//evaluation for volume per supperlier
    			$scope.showTable = true;
				$http.post(url,data).then(function(res){
    				$scope.listData = res.data; 
    				$scope.temp = [];
    				$scope.data1 = [];
    				$scope.data2 = [];
    				angular.forEach(res.data,function(v){
					$scope.temp.push(v.name);
					$scope.data1.push(v.re_qty);
					$scope.data2.push(v.ac_qty);
    				});
    				$scope.seriestemp = [{
			        	color: 'red',
			            name: 'Rejected',
			            data: $scope.data1
			        }, {
			        	color: 'green',
			            name: 'Accepted',
			            data: $scope.data2
			        }];
        			loadHightChart();

				    $scope.dtOptions    = DTOptionsBuilder.newOptions()
			        .withOption('aaData',$scope.listData)
			        .withOption('bLengthChange', false)
			        .withOption('bPaginate', true)
			        .withOption('bInfo', true)
			        .withOption('createdRow', function(row, data, dataIndex) {
			            // Recompiling so we can bind Angular directive to the DT
			            // $compile(angular.element(row).contents())($scope);
			        })
					.withButtons([
                            'print',
                            'excel'
                        ])
			        .withOption('bFilter', false);

				    $scope.dtColumns = [
				        DTColumnBuilder.newColumn('name').withTitle('Lieferantenname'),
				        DTColumnBuilder.newColumn('re_qty').withTitle('Value Rejected').renderWith(renderMoney).withClass('dt-body-right'),
				        DTColumnBuilder.newColumn('ac_qty').withTitle('Value Accepted').renderWith(renderMoney).withClass('dt-body-right'),
				        DTColumnBuilder.newColumn('ab_qty').withTitle('Value Total').renderWith(renderMoney).withClass('dt-body-right'),
				        DTColumnBuilder.newColumn('ab_qty').withTitle('% Rejected').renderWith(renderPercent).withClass('dt-body-right')
				    ];

				    $scope.dtInstance = {};
				});
					
    		break;
    		case 'supplierBility':
    			//evaluation for supplier's reliability
				$scope.showTable = true;
				$http.post(url,data).then(function(res){
    				$scope.listData = res.data; 
				    $scope.dtOptions    = DTOptionsBuilder.newOptions()
			        .withOption('aaData',$scope.listData)
			        .withOption('bLengthChange', false)
			        .withOption('bPaginate', true)
			        .withOption('bInfo', true)
			        .withOption('createdRow', function(row, data, dataIndex) {
			            // Recompiling so we can bind Angular directive to the DT
			            // $compile(angular.element(row).contents())($scope);
			        })
					.withButtons([
                            'print',
                            'excel'
                        ])
			        .withOption('bFilter', false);

				    $scope.dtColumns = [
				        DTColumnBuilder.newColumn('su_no').withTitle('Supplier No.'),
				        DTColumnBuilder.newColumn('su_name').withTitle('Supplier'),
				        DTColumnBuilder.newColumn('cu_name').withTitle('Customer'),
				        DTColumnBuilder.newColumn('order_no').withTitle('Order No.'),
				        DTColumnBuilder.newColumn('position_no').withTitle('Order Pos.'),
				        DTColumnBuilder.newColumn('product_item_no').withTitle('Item No.'),
				        DTColumnBuilder.newColumn('product_item_name_english').withTitle('Item Name'),
				        DTColumnBuilder.newColumn('product_segment_name_english').withTitle('Product Segment'),
				        DTColumnBuilder.newColumn('brandname').withTitle('Brand'),
				        DTColumnBuilder.newColumn('product_line_name_english').withTitle('Product Line'),
				        DTColumnBuilder.newColumn('ZA_date').withTitle('ZA Date').renderWith(renderDate),
				        DTColumnBuilder.newColumn('confirmed_delivery_date').withTitle('Confirmed Delivery Date').renderWith(renderDate),
				        DTColumnBuilder.newColumn('relevant_due_date').withTitle('Relevant Due Date').renderWith(renderDate),
				        DTColumnBuilder.newColumn('etd_date').withTitle('ETD Date').renderWith(renderDate),
				        DTColumnBuilder.newColumn('days_of_delay').withTitle('Days Of Delay'),
				        DTColumnBuilder.newColumn('days_of_earlier_shipment').withTitle('Days Of Earlier Shipment'),
				        DTColumnBuilder.newColumn('delivered_in_time').withTitle('Delivered In Time'),
				        DTColumnBuilder.newColumn('currency').withTitle('Currency'),
				        DTColumnBuilder.newColumn('due_value').withTitle('Due Value').renderWith(renderMoney),
				        DTColumnBuilder.newColumn('shipped_value').withTitle('Shipped Value(FOB)').renderWith(renderMoney),
				        DTColumnBuilder.newColumn('value_shipped_in_time').withTitle('Value Shipped In Time').renderWith(renderMoney),
				        DTColumnBuilder.newColumn('percent_shipped_in_time').withTitle('% Value Shipped In Time')
				    ];

				    $scope.dtInstance = {};
				});
    		break;
    		case 'orderData':
    				//evaluation for detail order data
    			 	$scope.showTable = true;
    				$http.post(url,data).then(function(res){
	    				$scope.listData = res.data; 
					    $scope.dtOptions    = DTOptionsBuilder.newOptions()
				        .withOption('aaData',$scope.listData)
				        .withOption('bLengthChange', false)
				        .withOption('bPaginate', true)
				        .withOption('bInfo', true)
				        .withOption('createdRow', function(row, data, dataIndex) {
				            // Recompiling so we can bind Angular directive to the DT
				            // $compile(angular.element(row).contents())($scope);
				        })
						.withButtons([
                            'print',
                            'excel'
                        ])
				        .withOption('bFilter', false);

					    $scope.dtColumns = [
					        DTColumnBuilder.newColumn('su_no').withTitle('Supplier No.'),
					        DTColumnBuilder.newColumn('su_name').withTitle('Supplier'),
					        DTColumnBuilder.newColumn('cu_name').withTitle('Customer'),
					        DTColumnBuilder.newColumn('order_no').withTitle('Order No.'),
					        DTColumnBuilder.newColumn('position_no').withTitle('Order Pos.'),
					        DTColumnBuilder.newColumn('product_item_no').withTitle('Item No.'),
					        DTColumnBuilder.newColumn('product_item_name_english').withTitle('Item Name'),
					        DTColumnBuilder.newColumn('product_segment_name_english').withTitle('Product Segment'),
					        DTColumnBuilder.newColumn('brandname').withTitle('Brand'),
					        DTColumnBuilder.newColumn('product_line_name_english').withTitle('Product Line'),
					        DTColumnBuilder.newColumn('order_date').withTitle('Order Date').renderWith(renderDate),
					        DTColumnBuilder.newColumn('request_delivery_date').withTitle('Requested Delivery Date').renderWith(renderDate),
					        DTColumnBuilder.newColumn('ZA_date').withTitle('ZA Date').renderWith(renderDate),
					        DTColumnBuilder.newColumn('confirmed_delivery_date').withTitle('Confirmed Delivery Date').renderWith(renderDate),
					        DTColumnBuilder.newColumn('relevant_due_date').withTitle('Relevant Due Date').renderWith(renderDate),
					        DTColumnBuilder.newColumn('confirmed_quantity').withTitle('Confirmed Quantity').renderWith(renderQty),
					        DTColumnBuilder.newColumn('etd_date').withTitle('ETD Date').renderWith(renderDate),
					        DTColumnBuilder.newColumn('shipped_quantity').withTitle('Shipped Quantity').renderWith(renderQty),
					        DTColumnBuilder.newColumn('unit_price').withTitle('Net Price/Unit').renderWith(renderMoney),
					        DTColumnBuilder.newColumn('currency').withTitle('Currency'),
					        DTColumnBuilder.newColumn('shipped_value').withTitle('Shipped Value(FOB)').renderWith(renderMoney),
					        DTColumnBuilder.newColumn('ETA_date').withTitle('ETA Date').renderWith(renderDate)
					    ];

					    $scope.dtInstance = {};
    				});
    		break;
    	}
    }
	//end
	// $scope.temp =['Apples1', 'Oranges', 'Pears', 'Grapes', 'Bananas','Apples', 'Oranges', 'Pears', 'Grapes', 'Bananas'];

function loadHightChart(){
	    $('#container').highcharts({
        chart: {
            type: 'column'
        },
        title: {
            text: '% rejected value / delivered value in 2015'
        },
        xAxis: {
            categories: $scope.temp
        },
        yAxis: {
            min: 0,
            title: {
                text: 'Value x'
            },
            stackLabels: {
                enabled: true,
                style: {
                    fontWeight: 'bold',
                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                }
            }
        },
        legend: {
            align: 'right',
            x: -30,
            verticalAlign: 'top',
            y: 25,
            floating: true,
            backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
            borderColor: '#CCC',
            borderWidth: 1,
            shadow: false
        },
        tooltip: {
            headerFormat: '<b>{point.x}</b><br/>',
            pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                dataLabels: {
                    enabled: true,
                    color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
                    style: {
                        textShadow: '0 0 3px black'
                    }
                }
            }
        },
        series: $scope.seriestemp
    });
}
  $timeout(function () {
  	    $("#etd_from").datepicker({ dateFormat: "dd-M-yy" }).val();
        $("#etd_to").datepicker({ dateFormat: "dd-M-yy" }).val();
        $( ".datepicker" ).datepicker( "option", "prevText", "<" );
        $( ".datepicker" ).datepicker( "option", "nextText", ">" );
        $( ".datepicker" ).datepicker( "option", "firstDay", 1 );
      pageSetUp();
  }, 100);

}]);


