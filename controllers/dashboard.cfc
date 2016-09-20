component accessors=true {

	property framework;
	property purchase_orderService;
    property companyService;

    function getDashBoardCalendar(numeric month, numeric year) {
        var obj             = createObject("component","api/general");
        var startDate       = DateFormat( CreateDate(year, month, 1), 'yyyy-mm-dd' );
        var endDate         = DateFormat( CreateDate(year, month, DaysInMonth(startDate)), 'yyyy-mm-dd' );
        
        var dashboard        = [];
        var supplier = 0;
        var segment = 0;
        var location = 0;
        var data = {};
        if(StructKeyExists(URL, 'supplier') && URL.supplier != ''){
            supplier = URL.supplier;
        }
        if(StructKeyExists(URL, 'segment') && URL.segment != ''){
            segment = URL.segment;
        }
        if(StructKeyExists(URL, 'location') && URL.location != ''){
            location = URL.location;
        }

        var inspection = purchase_orderService.getOrderInspection(startDate, endDate).filter(
            function(row, rowNr, qrData){   
                var sup_filter = supplier ? (row.supplier_companyid == supplier) : true ;
                var seg_filter = segment ? (row.product_segment_id == segment) : true ;
                var loc_filter = location ? (row.locationid == location) : true ;
                return sup_filter && seg_filter && loc_filter; 
            });
        for(ins in inspection)
        {
            var structIns = {};
            structIns.title = ins.shipped_quantity&" x "&ins.product_line_name_english&" - "&ins.product_item_name_english;
            structIns.start = DateFormat(ins.plan_date, "yyyy-mm-dd");
            structIns.stick = true;
            structIns.color = "##ec1f26";
            arrayAppend(dashboard, structIns);
        }

        var delivery = purchase_orderService.getOrderDelivery(startDate, endDate).filter(
            function(row, rowNr, qrData){   
                var sup_filter = supplier ? (row.supplier_companyid == supplier) : true ;
                var seg_filter = segment ? (row.product_segment_id == segment) : true ;
                var loc_filter = location ? (row.locationid == location) : true ;
                return sup_filter && seg_filter && loc_filter; 
            });
        for(deli in delivery)
        {
            var structDeli = {};
            structDeli.title = deli.shipped_quantity&" x "&deli.product_line_name_english&" - "&deli.product_item_name_english;
            structDeli.start = DateFormat(deli.confirmed_shipping_date, "yyyy-mm-dd");
            structDeli.stick = true;
            structDeli.color = "##000000";
            arrayAppend(dashboard, structDeli);
        }
        data.calendar=dashboard;

        //data chart supplier
        var current         = now();
        var current_date = DatePart("d", current);
        var current_month   = Month(current);
        var current_year    = Year(current);
        var old_month = 1;
        var old_year = current_year;
        if(current_month < 12){
            old_month = current_month + 1;
            old_year = current_year - 1;
        }
        
        var endChart       = DateFormat( CreateDate(current_year, current_month, current_date), 'yyyy-mm-dd' );
        var startChart        = DateFormat( CreateDate(old_year, old_month, 1), 'yyyy-mm-dd' );
        var supplierCharts = purchase_orderService.getOrderChart(2, startChart, endChart).filter(
            function(row, rowNr, qrData){   
                var sup_filter = supplier ? (row.supplier_companyid == supplier) : true ;
                var seg_filter = segment ? (row.product_segment_id == segment) : true ;
                var loc_filter = location ? (row.locationid == location) : true ;
                return sup_filter && seg_filter && loc_filter; 
            });
        //var supl = 0;
        var suppliers = [];
        var totalAll = 0;
        var totaltop = 0;
        var total = 0;
        totalAll = purchase_orderService.getOrderChartTotal(startChart, endChart, supplier, segment, location).total_price_usd;
        if(isNull(totalAll)){
            totalAll = 0;
        }
        for(supChart in supplierCharts)
        {
            //supl++;
            //if(supl <= 5){
                totaltop += supChart.total_price_usd;
                var structsupChart = {};
                structsupChart.title = supChart.name;
                structsupChart.price = supChart.total_price_usd;
                arrayAppend(suppliers, structsupChart);
            //}
        }
        total = totalAll - totaltop;
        arrayAppend(suppliers, {price = total, title = "Others"});
        data.supplier=suppliers;
        //data chart product
        var productCharts = purchase_orderService.getOrderChart(1, startChart, endChart).filter(
            function(row, rowNr, qrData){   
                var sup_filter = supplier ? (row.supplier_companyid == supplier) : true ;
                var seg_filter = segment ? (row.product_segment_id == segment) : true ;
                var loc_filter = location ? (row.locationid == location) : true ;
                return sup_filter && seg_filter && loc_filter; 
            });
        var products = [];
        //lpro = 0;
        var ptotaltop = 0;
        var ptotal = 0;
        for(proChart in productCharts)
        {
            //lpro++;
            //if(lpro <= 5){
                ptotaltop += proChart.total_price_usd;
                var structproChart = {};
                structproChart.title = proChart.product_line_name_english;
                structproChart.price = proChart.total_price_usd;
                arrayAppend(products, structproChart);
            //}
        }
        ptotal = totalAll - ptotaltop;
        arrayAppend(products, {price = ptotal, title = "Others"});
        data.product=products;

        //data chart order
        var orderCharts = purchase_orderService.getOrderChart(3, startChart, endChart).filter(
            function(row, rowNr, qrData){   
                var sup_filter = supplier ? (row.supplier_companyid == supplier) : true ;
                var seg_filter = segment ? (row.product_segment_id == segment) : true ;
                var loc_filter = location ? (row.locationid == location) : true ;
                return sup_filter && seg_filter && loc_filter; 
            });
        var orders = [];
        
        for(ordChart in orderCharts)
        {
            var structorderChart = {};
            structorderChart.title = DateFormat(ordChart.order_date, "mmm/yy");
            structorderChart.price = ordChart.total_price_usd;
            arrayAppend(orders, structorderChart);
        }
        data.order=orders;
        VARIABLES.framework.renderData('JSON', data);
    }

    function getLocationList() {
        var obj = createObject("component","api/general");
        VARIABLES.framework.renderData('JSON', obj.queryToArray(companyService.getLocationList()));
    }

    function getSupplier() {
        var obj = createObject("component","api/general");
        VARIABLES.framework.renderData('JSON', obj.queryToArray(companyService.getCompanyByLocation(URL.locationid, 2)));
    }
    
    function execute() {

        switch(cgi.request_method) { 
            case "put": 
                    //editMistakeDictionary(GetHttpRequestData().content); 
                    break; 
            case "post": 
                    //addMistakeDictionary(GetHttpRequestData().content);
                    break; 
            case "delete":
                if(StructKeyExists(URL, 'id')){
                    //deleteAccess(GetHttpRequestData().headers.token, URL.id);
                    break; 
                }
            case "get": 
                if(StructKeyExists(URL, 'month') && StructKeyExists(URL, 'year')){
                    getDashBoardCalendar(URL.month, URL.year);
                    break;
                }
                //getMistakeDictionaryList(); 
                break;             
        } //end switch
    }
        
}
