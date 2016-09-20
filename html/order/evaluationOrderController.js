"use strict";
app.controller('orderEvaluation', ['$http','$scope','$timeout','ENV','DTOptionsBuilder','DTColumnBuilder','companyService','$filter', function($http,$scope,$timeout,ENV,DTOptionsBuilder,DTColumnBuilder,companyService,$filter){

	$scope.showTable = false;
		$scope.dtOptions = DTOptionsBuilder.fromSource('');
	    $scope.dtColumns = [
	        DTColumnBuilder.newColumn(null)
	    ];
	$scope.dtInstance = {};

    $scope.customer = '';
    $scope.supplier = '';
    $scope.conf_from ='';
    $scope.conf_to ='';
    $scope.etd_from ='';
    $scope.etd_to ='';
    $scope.product_segment = '';
    $scope.product_line = '';
    $scope.customers = [];
    $scope.suppliers = [];
    $scope.ListProductSegment =[];

    companyService.getByType(window.globalVariable.company_kind.customer).then(function(data){
        $scope.customers = data
    });
    companyService.getByType(window.globalVariable.company_kind.supplier).then(function(data){
        $scope.suppliers = data;
    });


   $http.get(ENV.domain+'productSegment.execute').then(function(res){
   		$scope.ListProductSegment =res.data;
   });

   $http.get(ENV.domain+'evaluation.getProductLineBySegment?id='+$scope.product_segment).then(function(res){
   		$scope.ListProductLine = res.data;
   });

   $scope.getProductLine = function(){
	   	$http.get(ENV.domain+'evaluation.getProductLineBySegment?id='+$scope.product_segment).then(function(res){
	   		$scope.ListProductLine = res.data;
	   });
   }

    function renderQty(data){
        return $filter('number')(data, 0);
    }

    function renderMoney(data){
        return $filter('number')(data,2);
    }

    function renderDate(data){
    	return $filter('date')(new Date(data), 'dd-MMM-yyyy');
    }

    $scope.DetailOrderData = function(evaluationid){
		var url = ENV.domain+'evaluation.order';
		var data = {
				"supplier": $scope.supplier,
				"customer": $scope.customer,
				"product_segment": $scope.product_segment,
				"product_line": $scope.product_line,
				"confirmed_shipping_date_from": $scope.conf_from,
				"confirmed_shipping_date_to": $scope.conf_to,
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
				        DTColumnBuilder.newColumn('shipped_value').withTitle('Shipped Value(FOB)').renderWith(renderMoney),
				        DTColumnBuilder.newColumn('currency').withTitle('Currency')
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



    $timeout(function () {
    	$("#conf_from").datepicker({ dateFormat: "dd-M-yy" }).val();
        $("#conf_to").datepicker({ dateFormat: "dd-M-yy" }).val();
        $("#etd_from").datepicker({ dateFormat: "dd-M-yy" }).val();
        $("#etd_to").datepicker({ dateFormat: "dd-M-yy" }).val();
        $( ".datepicker" ).datepicker( "option", "prevText", "<" );
        $( ".datepicker" ).datepicker( "option", "nextText", ">" );
        $( ".datepicker" ).datepicker( "option", "firstDay", 1 );
        pageSetUp();
    }, 100);
}]);