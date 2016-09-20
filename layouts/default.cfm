<!DOCTYPE html>
	<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
	<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
	<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
	<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
	<head>
		<meta charset="utf-8">
		<!--[if IE]> <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> <![endif]-->
		<title>Zwilling</title>
		<meta name="description" content="">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="icon" type="image/png" href="assets/img/favicon.ico" />
		<link rel="stylesheet" type="text/css" href="assets/css/lib/bootstrap.min.css">
		<link rel="stylesheet" type="text/css" href="assets/css/lib/font-awesome.min.css">
		<link rel="stylesheet" type="text/css" href="assets/css/lib/jquery-ui.min.css">
		<link rel="stylesheet" type="text/css" href="assets/css/lib/smartadmin-production.css">
		<link rel="stylesheet" type="text/css" href="assets/css/lib/smartadmin-production-plugins.min.css">
		<link rel="stylesheet" type="text/css" href="assets/css/lib/select.dataTables.min.css">
		<link rel="stylesheet" type="text/css" href="assets/css/lib/jquery.dataTables.min.css">
		<link rel="stylesheet" type="text/css" href="assets/css/lib/notification/angular-ui-notification.min.css">
		<link rel="stylesheet" type="text/css" href="assets/css/lib/calendar/fullcalendar.min.css">
		<link rel="stylesheet" type="text/css" href="assets/css/lib/loading-bar.min.css">
		<link rel="stylesheet" type="text/css" href="assets/css/lib/buttons.dataTables.css">
		<link rel="stylesheet" type="text/css" href="assets/css/main.css">

		<script type="text/javascript" src="assets/js/lib/jquery.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/jquery-ui.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/bootstrap.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/angular.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/angular-ui-router.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/angular-resource.js"></script>
		<script type="text/javascript" src="assets/js/lib/angular-ui.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/angular-locale_en-us.js"></script>
	</head>
	<body ng-app="zwillingApp">
		<div ui-view="login"></div>

	    <div ui-view="header"></div>
	    <div ui-view="leftPanel"></div>
	    <div id="main" role="main" ui-view="content"></div>
	    <div ui-view="footer"></div>

		<script type="text/javascript" src="assets/js/app.module.js"></script>
		<script type="text/javascript" src="assets/js/app.routes.js"></script>
		<script type="text/javascript" src="assets/js/app.controllers.js"></script>
		<script type="text/javascript" src="assets/js/app.constant.js"></script>
		<script type="text/javascript" src="assets/js/lib/app.config.js"></script>
		<script type="text/javascript" src="assets/js/lib/app.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/autocomplete.js"></script>
		<script type="text/javascript" src="assets/js/lib/select2.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/jquery.dataTables.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/dataTables.select.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/datatable/angular-datatables.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/datatable/angular-datatables.columnfilter.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/datatable/dataTables.columnFilter.js"></script>

		<script type="text/javascript" src="assets/js/lib/prototypes.js"></script>
		<script type="text/javascript" src="assets/js/lib/angular-base64-upload.js"></script>
		<script type="text/javascript" src="assets/js/lib/notification/angular-ui-notification.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/select2.js"></script>
		<script type="text/javascript" src="assets/js/lib/select2sortable.js"></script>
		<script type="text/javascript" src="assets/js/lib/chart/chart.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/chart/angular-chart.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/chart/highcharts.js"></script>
		<script type="text/javascript" src="assets/js/lib/loading-bar.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/calendar/moment.min.js"></script>
		<script type="text/javascript" src="assets/js/lib/calendar/fullcalendar.min.js"></script>
		<script src="//cdnjs.cloudflare.com/ajax/libs/angular-filter/0.4.7/angular-filter.js"></script>

		<script lang="javascript" src="assets/js/lib/datatable/xlsx.core.min.js"></script>



		<script type="text/javascript" src="assets/js/lib/datatable/plugins/buttons/dataTables.buttons.js"></script>
		<script type="text/javascript" src="assets/js/lib/datatable/plugins/buttons/buttons.flash.js"></script>
		<script type="text/javascript" src="assets/js/lib/datatable/plugins/buttons/buttons.html5.js"></script>
		<script type="text/javascript" src="assets/js/lib/datatable/plugins/buttons/buttons.print.js"></script>
		<script type="text/javascript" src="assets/js/lib/datatable/plugins/buttons/angular-datatables.buttons.min.js"></script>


		<!--Include Service -->
		<script type="text/javascript" src="assets/js/services/user.service.js"></script>
		<script type="text/javascript" src="assets/js/services/company.service.js"></script>
		<script type="text/javascript" src="assets/js/services/addressBook.service.js"></script>
		<script type="text/javascript" src="assets/js/services/storage.js"></script>
		<script type="text/javascript" src="assets/js/services/productItem.service.js"></script>
		<script type="text/javascript" src="assets/js/services/order.service.js"></script>
		<script type="text/javascript" src="assets/js/services/ql.service.js"></script>
		<script type="text/javascript" src="assets/js/services/aql.service.js"></script>
		<script type="text/javascript" src="assets/js/services/mistake.service.js"></script>
		<script type="text/javascript" src="assets/js/services/file.service.js"></script>
		<script type="text/javascript" src="assets/js/services/productLine.service.js"></script>
		<script type="text/javascript" src="assets/js/services/brand.service.js"></script>
		<script type="text/javascript" src="assets/js/services/productSegment.service.js"></script>
		<script type="text/javascript" src="assets/js/services/currency.service.js"></script>
		<script type="text/javascript" src="assets/js/services/location.service.js"></script>
		<script type="text/javascript" src="assets/js/services/characteristic.service.js"></script>
		<script type="text/javascript" src="assets/js/services/documentItem.service.js"></script>
		<script type="text/javascript" src="assets/js/services/contact.service.js"></script>
		<!-- Include Controller -->
		<script type="text/javascript" src="html/login/loginController.js"></script>
		<script type="text/javascript" src="html/dashboard/dashboardController.js"></script>
		<script type="text/javascript" src="html/order/orderInputController.js"></script>
		<script type="text/javascript" src="html/order/orderListController.js"></script>
		<script type="text/javascript" src="html/order/orderImportController.js"></script>
		<script type="text/javascript" src="html/order/evaluationOrderController.js"></script>
		<script type="text/javascript" src="html/inspection/scheduleController.js"></script>
		<script type="text/javascript" src="html/inspection/evaluationController.js"></script>
		<script type="text/javascript" src="html/inspection/calendarController.js"></script>
		<script type="text/javascript" src="html/inspection/reportController.js"></script>
		<script type="text/javascript" src="html/address_book/addressListController.js"></script>
		<script type="text/javascript" src="html/ql/qlController.js"></script>
		<script type="text/javascript" src="html/aql/aqlController.js"></script>
		<script type="text/javascript" src="html/product/productController.js"></script>
		<script type="text/javascript" src="html/mistake/mistakeController.js"></script>
		<script type="text/javascript" src="html/brand/brandController.js"></script>
		<script type="text/javascript" src="html/product_line/productlineController.js"></script>
		<script type="text/javascript" src="html/product_segment/productsegmentController.js"></script>
		<script type="text/javascript" src="html/product_line/productlineController.js"></script>
		<script type="text/javascript" src="html/brand/brandController.js"></script>
		<script type="text/javascript" src="html/currency/currencyController.js"></script>
		<script type="text/javascript" src="html/location/locationController.js"></script>
		<script type="text/javascript" src="html/characteristic/characteristicController.js"></script>
		<script type="text/javascript" src="html/document_item/documentItemController.js"></script>
		<script type="text/javascript" src="html/delivery/quantity_deliveryController.js"></script>
		<script type="text/javascript" src="html/user/userController.js"></script>
		<script type="text/javascript" src="html/shared/leftPanelController.js"></script>
		<script type="text/javascript" src="html/contact/contactController.js"></script>
		<script src='https://www.google.com/recaptcha/api.js'></script>
	</body>

</html>
