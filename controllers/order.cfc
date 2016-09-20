/* @author : duy */

component accessors=true {

	property framework;

    property purchase_orderService;
	property order_documentService;
    property product_item_qlService;
    property product_itemService;
    property companyService;
    property import_historyService;
    property currencyService;
    public function init(required any fw){
        
        variables.fw = arguments.fw;
        return this;
    }

    function oSearch() {
        var obj = createObject("component","api/general");
        // var current         = now();
        // var current_month   = Month(current);
        // var current_year    = Year(current);

        // var startDate = DateFormat( CreateDate(current_year, current_month, 1), 'yyyy-mm-dd' );
        // var endDate = DateFormat( CreateDate(current_year, current_month, DaysInMonth(current)), 'yyyy-mm-dd' );
        var startDate = "";
        var endDate = "";
        var supplier = 0;
        var customer = 0;
        var finish = 1;
        // var product_item_no = "";
        // var product_line_name_english = "";
        // var product_item_name_english = "";
        if(StructKeyExists(URL, 'start')){
            startDate = DateFormat( URL.start, 'yyyy-mm-dd' );
        }
        if(StructKeyExists(URL, 'end')){
            endDate = DateFormat( URL.end, 'yyyy-mm-dd' );
        }
        if(StructKeyExists(URL, 'cusid')){
            customer = URL.cusid;
        }
        if(StructKeyExists(URL, 'supid')){
            supplier = URL.supid;
        }
        if(StructKeyExists(URL, 'finish')){
            finish = URL.finish;
        }
        // if(StructKeyExists(URL, 'opitem')){
        //     product_item_no = URL.opitem;
        // }
        // if(StructKeyExists(URL, 'opname')){
        //     product_line_name_english = URL.opname;
        // }
        // if(StructKeyExists(URL, 'opitemname')){
        //     product_item_name_english = URL.opitemname;
        // }
 
        var purchase_orders = VARIABLES.purchase_orderService.getOrderSearch(startDate, endDate, finish).filter(
            function(row, rowNr, qrData){   
                var sup_filter = supplier ? (row.supid == supplier) : true ;
                var cus_filter = customer ? (row.cusid == customer) : true ;
                // var opitem_filter = (product_item_no !="")? (row.product_item_no == product_item_no) : true ;
                // var opname_filter = (product_line_name_english !="")? (row.product_line_name_english == product_line_name_english) : true ;
                // var opitemname_filter = (product_item_name_english !="")? (row.product_item_name_english == product_item_name_english) : true ;
                
                return sup_filter && cus_filter; 
        }); 

        var result = obj.queryToArray(purchase_orders);   
        VARIABLES.framework.renderData('JSON', result);
    }

    function addOrderPosition(required string data,required numeric typeReturn) {
        var obj = createObject("component","api/general");
            var info = deserializeJSON(data);
            var update_date = now();
            var abIdArr=[];
            var flag = true;
            var message ="";
            var success = true;
            var new_position = entityNew('order_position');
            new_position.setProduct_item_no(info.product_item_no);
            new_position.setPosition_no(info.position_no);
            new_position.setOrdered_quantity(lsParseNumber(info.ordered_quantity));
            new_position.setInspected_quantity(0);
            new_position.setExported_quantity(0);
            new_position.setUnit_price(info.unit_price);
            new_position.setTotal_price(info.total_price);
            new_position.setLastupdate(update_date);
            var qlExist = product_item_qlService.getQlByItemno(info.product_item_no);
            var ql ="";
            if(!isEmpty(qlExist)){
                new_position.setQl(qlExist.ql);
                ql= qlExist.ql;
            }else{
                pql = product_itemService.getQl(info.product_item_no);
                new_position.setQl(pql.ql);
                ql= pql.ql;
            }
            if(structKeyExists(info, "orderid"))
            {
                var positionNo = purchase_orderService.checkPositionNo(info.orderid, info.position_no);
                if(positionNo.recordCount > 0){
                    flag = false;
                    message = "position no is exists";
                    success = false;
                }
                new_position.setOrderid(info.orderid);
                new_position.setTmp(0);
                var purchase_order  = entityLoad("purchase_order", info.orderid, true);
                var exchange_rate = getcurrencyByCodeYear(purchase_order.getCurrency(), purchase_order.getOrder_date()).exchange_rate;
                new_position.setTotal_price_usd(info.total_price * exchange_rate);
            }
            if(flag){
                entitySave(new_position);
                var aqArr = [];
                var qls=obj.queryToArray(product_item_qlService.getQl(info.product_item_no));
                for(q in qls){
                    arrayAppend(aqArr, q.ql);
                }
            
                for (item in info.ab) { 
                    var structId ={};
                    var new_ab = entityNew('ab');
                    new_ab.setPositionid(new_position.getPositionid());
                    new_ab.setAbno(lsParseNumber(item.abno));
                    new_ab.setShipped_quantity(lsParseNumber(item.shipped_quantity));
                    new_ab.setShipment_method(item.shipment_method);
                    new_ab.setExpected_shipping_date(DateFormat(item.expected_shipping_date, "yyyy-mm-dd"));
                    new_ab.setConfirmed_shipping_date(DateFormat(item.confirmed_shipping_date, "yyyy-mm-dd"));
                    new_ab.setLastupdate(update_date);
                    new_ab.setshipping_date(DateFormat(item.shipping_date, "yyyy-mm-dd"));
                    new_ab.setZA_date(DateFormat(item.za_date, "yyyy-mm-dd"));
                    new_ab.setETA_date(DateFormat(item.eta_date, "yyyy-mm-dd"));
                    new_ab.setRelevant_due_date(DateFormat(item.relevant_due_date, "yyyy-mm-dd"));
                    new_ab.setWarehouse_book_date(DateFormat(item.warehouse_book_date, "yyyy-mm-dd"));
                    entitySave(new_ab);
                    structId.abid=new_ab.getAbid();
                    var new_schedule = entityNew('inspection_schedule');
                    new_schedule.setAbid(new_ab.getAbid());
                    new_schedule.setPlan_date(dateAdd('d',-7,item.confirmed_shipping_date));
                    new_schedule.setLastupdate(update_date);
                    entitySave(new_schedule);
                    structId.id=new_schedule.getId();
                    arrayAppend(abIdArr, structId);
                }
                
                message = "Insert data success";
                if(typeReturn == 1 ){
                     VARIABLES.framework.renderData('JSON', {'success': success, 
                                                        'message': message, 
                                                        'positionid':new_position.getPositionid(),
                                                        'ab':abIdArr,
                                                        'qls': aqArr,
                                                        'ql': ql
                                                        }); 
            }else{
                return true;
            }
            }else{
                if (typeReturn == 1)
                    VARIABLES.framework.renderData('JSON', {'success': success, 'message': message}); 
                else
                    return false;
            }
            
    }  
    
  
    function editOrderPosition(string data) {
            var info = deserializeJSON(data);
            var update_date = now();
            var abIdArr=[];
            
            entity_position = entityLoad( "order_position", info.positionid, true );
            entity_position.setProduct_item_no(info.product_item_no);
            entity_position.setPosition_no(info.position_no);
            entity_position.setOrdered_quantity(lsParseNumber(info.ordered_quantity));
            entity_position.setInspected_quantity(0);
            entity_position.setExported_quantity(0);
            entity_position.setUnit_price(info.unit_price);
            entity_position.setTotal_price(info.total_price);
            entity_position.setLastupdate(update_date);
            entity_position.setQl(info.ql);
            if(!isnull(entity_position.getOrderid())){
                var purchase_order  = entityLoad("purchase_order", entity_position.getOrderid(), true);
                var exchange_rate = getcurrencyByCodeYear(purchase_order.getCurrency(), purchase_order.getOrder_date()).exchange_rate;
                entity_position.setTotal_price_usd(info.total_price * exchange_rate);
            }
            
            for (ab_item in info.ab) {
                var structId ={};
                if(structKeyExists(ab_item, "abid"))
                {
                    entity_ab = entityLoad( "ab", ab_item.abid, true );
                    entity_ab.setPositionid(info.positionid);
                    entity_ab.setAbno(lsParseNumber(ab_item.abno));
                    entity_ab.setShipped_quantity(lsParseNumber(ab_item.shipped_quantity));
                    entity_ab.setShipment_method(ab_item.shipment_method);
                    entity_ab.setExpected_shipping_date(DateFormat(ab_item.expected_shipping_date, "yyyy-mm-dd"));
                    entity_ab.setConfirmed_shipping_date(DateFormat(ab_item.confirmed_shipping_date, "yyyy-mm-dd"));
                    entity_ab.setLastupdate(update_date);
                    entity_ab.setshipping_date(DateFormat(ab_item.shipping_date, "yyyy-mm-dd"));
                    entity_ab.setZA_date(DateFormat(ab_item.za_date, "yyyy-mm-dd"));
                    entity_ab.setETA_date(DateFormat(ab_item.eta_date, "yyyy-mm-dd"));
                    entity_ab.setETD_date(DateFormat(ab_item.etd_date, "yyyy-mm-dd"));
                    entity_ab.setRelevant_due_date(DateFormat(ab_item.relevant_due_date, "yyyy-mm-dd"));
                    entity_ab.setWarehouse_book_date(DateFormat(ab_item.warehouse_book_date, "yyyy-mm-dd"));
                    
                    entity_schedule = entityLoad( "inspection_schedule", ab_item.id, true );
                    entity_schedule.setAbId(ab_item.abid);
                    entity_schedule.setPlan_date(dateAdd('d',-7,ab_item.confirmed_shipping_date));
                    entity_schedule.setLastupdate(update_date);
                    structId.abid=ab_item.abid;
                    structId.id=ab_item.id;
                    structId.abno=ab_item.abno;
                }else{
                    var new_ab = entityNew('ab');
                    new_ab.setPositionid(info.positionid);
                    new_ab.setAbno(lsParseNumber(ab_item.abno));
                    new_ab.setShipped_quantity(lsParseNumber(ab_item.shipped_quantity));
                    new_ab.setShipment_method(ab_item.shipment_method);
                    new_ab.setExpected_shipping_date(DateFormat(ab_item.expected_shipping_date, "yyyy-mm-dd"));
                    new_ab.setConfirmed_shipping_date(DateFormat(ab_item.confirmed_shipping_date, "yyyy-mm-dd"));
                    new_ab.setLastupdate(update_date);
                    new_ab.setshipping_date(DateFormat(ab_item.shipping_date, "yyyy-mm-dd"));
                    new_ab.setZA_date(DateFormat(ab_item.za_date, "yyyy-mm-dd"));
                    new_ab.setETA_date(DateFormat(ab_item.eta_date, "yyyy-mm-dd"));
                    new_ab.setETD_date(DateFormat(ab_item.etd_date, "yyyy-mm-dd"));
                    new_ab.setRelevant_due_date(DateFormat(ab_item.relevant_due_date, "yyyy-mm-dd"));
                    new_ab.setWarehouse_book_date(DateFormat(ab_item.warehouse_book_date, "yyyy-mm-dd"));
                    entitySave(new_ab);
                    structId.abid=new_ab.getAbid();
                    structId.abno=ab_item.abno;
                    var new_schedule = entityNew('inspection_schedule');
                    new_schedule.setAbid(new_ab.getAbid());
                    new_schedule.setPlan_date(dateAdd('d',-7,ab_item.confirmed_shipping_date));
                    new_schedule.setLastupdate(update_date);
                    entitySave(new_schedule);
                    structId.id=new_schedule.getId();
                }
                arrayAppend(abIdArr, structId);
            }
            var success = true;
            var message = "Update data success";
            VARIABLES.framework.renderData('JSON', {'success': success, 
                                                        'message': message,
                                                        'ab':abIdArr
                                                        });
    }

    function deleteOrderPosition(numeric positionid) {
        if(cgi.request_method == "delete"){
            var success = false;
            var message = "Can't delete because exist in inspection report";
            var idChild = purchase_orderService.getPositionDelete(positionid, 0);
            if(idChild.tmp eq 1){
                for(item in idChild){
                    entity_ab = entityLoad( "ab", item.abid, true );
                    entityDelete( entity_ab );
                    entity_inspection_schedule = entityLoad( "inspection_schedule", item.id, true );
                    entityDelete( entity_inspection_schedule );
                }
                entity_position = entityLoad( "order_position", positionid, true );
                entityDelete( entity_position );
                success = true;
                message = "Delete data success";
            }
            VARIABLES.framework.renderData('JSON', {'success': success, 
                                                        'message': message});
        }  
    }

    function getOrderPositionById(numeric positionid) {
        var obj = createObject("component","api/general");
        var result = obj.queryToArray(purchase_orderService.getPosition(positionid, 0));
        VARIABLES.framework.renderData('JSON', result);
    }

    function getOrderPositionList(any positionid) { 
        var obj = createObject("component","api/general");
        var result = obj.queryToArray(purchase_orderService.getPositionList(positionid));
        VARIABLES.framework.renderData('JSON', result);
    }

    function orderExist(required string order_no) {
        var success = false;
        var message = "The order number isn't existed";
        var orderid = 0;
        var check = purchase_orderService.getOrderByOrderno(order_no);
        if (check.recordCount > 0){
            success = true;
            message="The order number is existed already!";
            orderid = check.orderid;
        }
        return {'success': success, 'message': message, 'orderid': orderid};
    }
    
    function saveOrder(string data) {
        var success = false;
        var message = "";
        var info = deserializeJSON(data); 
        var check = purchase_orderService.getOrder(0,info.order_no);
        var orderid = 0;
        if (check.recordCount > 0){
            message="The order number is existed already!";
            orderid = check.orderid;
        } else {
            var flag = true;
            var supplier = 0;
            var customer = 0;
            if(!structKeyExists(info, "supplier_id") && !structKeyExists(info, "supplier_no"))
            {
                flag = false;
                message="Supplier isn't empty";
            }else{
                if(structKeyExists(info, "supplier_id")){
                    supplier = info.supplier_id;
                }else{
                    sups = companyService.getCompanyByCompanyNo(info.supplier_no, 2, 0);
                    if(!isEmpty(sups)){
                        supplier = sups.companyid;
                    }else{
                        flag = false;
                        var message = "Supplier isn't exist";
                    } 
                }
            }
            if(!structKeyExists(info, "customer_id") && !structKeyExists(info, "customer_no"))
            {
                flag = false;
                message="Customer isn't empty";
            }else{
                if(structKeyExists(info, "customer_id")){
                    customer = info.customer_id;
                }else{
                    cus = companyService.getCompanyByCompanyNo(info.customer_no, 3, 0);
                    if(!isEmpty(cus)){
                        customer = cus.companyid;
                    }else{
                        flag = false;
                        var message = "Customer isn't exist";
                    }   
                }
            }
            if(flag){
                var update_date = now();
                var new_order = entityNew('purchase_order');
                new_order.setOrder_no(info.order_no);
                new_order.setOrder_date(info.order_date);
                new_order.setSupplier_companyid(supplier);
                new_order.setBuyer_companyid(customer);
                new_order.setInspector_companyid(customer);
                new_order.setLastupdate(update_date);
                new_order.setCurrency(info.currency);
                entitySave(new_order);
                orderid = new_order.getOrderid();
                var exchange_rate = getcurrencyByCodeYear(info.currency, info.order_date).exchange_rate;
                for(item in info.position){
                    entity_position = entityLoad( "order_position", item, true );
                    entity_position.setOrderid(new_order.getOrderid());
                    entity_position.setTotal_price_usd(entity_position.getTotal_price() * exchange_rate);
                    entity_position.setTmp(0);
                }
                if(structKeyExists(info, "document"))
                {
                    for(id_document in info.document){
                        order_documentService.editorder_Document(id_document, new_order.getOrderid());
                    }
                }
                success = true;
                message="Insert data success.";
            }
        }
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message, 'orderid': orderid});
    }

     function saveImportOrder(string data) {
        var success = false;
        var info = deserializeJSON(data); 
        var check = purchase_orderService.getOrder(0,info.order_no);
        var orderid = 0;
        var order_date = "";
        var currency = "";
        var message="";
        if (check.recordCount > 0){
            orderid = check.orderid;
            order_date = check.order_date;
            currency = check.currency;
        } else {
            var flag = true;
            var supplier = 0;
            var customer = 0;
            if(!structKeyExists(info, "supplier_id") && !structKeyExists(info, "supplier_no"))
            {
                flag = false;
            }else{
                if(structKeyExists(info, "supplier_id")){
                    supplier = info.supplier_id;
                }else{
                    sups = companyService.getCompanyByCompanyNo(info.supplier_no, 2,0);
                    if(!isEmpty(sups)){
                        supplier = sups.companyid;
                    }else{
                        flag = false;
                        message &= "Supplier isn't exist,";
                    } 
                }
            }
            if(!structKeyExists(info, "customer_id") && !structKeyExists(info, "customer_no"))
            {
                flag = false;
            }else{
                if(structKeyExists(info, "customer_id")){
                    customer = info.customer_id;
                }else{
                    cus = companyService.getCompanyByCompanyNo(info.customer_no, 3,0);
                    if(!isEmpty(cus)){
                        customer = cus.companyid;
                    }else{
                        flag = false;
                         message &= "Customer isn't exist";
                    }   
                }
            }
            if(flag){
                var update_date = now();
                var new_order = entityNew('purchase_order');
                new_order.setOrder_no(info.order_no);
                new_order.setOrder_date(info.order_date);
                new_order.setSupplier_companyid(supplier);
                new_order.setBuyer_companyid(customer);
                new_order.setInspector_companyid(customer);
                new_order.setLastupdate(update_date);
                new_order.setCurrency(info.currency);
                entitySave(new_order);
                orderid = new_order.getOrderid();
                order_date = new_order.getOrder_date();
                currency = new_order.getcurrency();
                var exchange_rate = getcurrencyByCodeYear(info.currency, info.order_date).exchange_rate;
                for(item in info.position){
                    entity_position = entityLoad( "order_position", item, true );
                    entity_position.setOrderid(new_order.getOrderid());
                    entity_position.setTotal_price_usd(entity_position.getTotal_price() * exchange_rate);
                    entity_position.setTmp(0);
                }
                if(structKeyExists(info, "document"))
                {
                    for(id_document in info.document){
                        order_documentService.editorder_Document(id_document, new_order.getOrderid());
                    }
                }
                success = true;
            }
        }
        return {'success': success,'orderid': orderid,'message':message, 'order_date':order_date , 'currency': currency };
    }

    function editOrder(string data) {
        var success = false;
        var message = "";
        var info = deserializeJSON(data); 
        if (VARIABLES.purchase_orderService.checkOrderNoEdit(info.orderid ,info.order_no).recordCount > 0){
            message="The order number is existed already!";
        } else {
            var update_date = now();
            entity_order = entityLoad( "purchase_order", info.orderid, true );
            entity_order.setOrder_no(info.order_no);
            entity_order.setOrder_date(info.order_date);
            entity_order.setSupplier_companyid(info.supplier_id);
            entity_order.setBuyer_companyid(info.customer_id);
            entity_order.setInspector_companyid(info.customer_id);
            entity_order.setLastupdate(update_date);
            entity_order.setCurrency(info.currency);
            var exchange_rate = getcurrencyByCodeYear(info.currency, info.order_date).exchange_rate;
            if(structKeyExists(info, "position"))
            {
                for(item in info.position){
                    entity_position = entityLoad( "order_position", item, true );
                    entity_position.setOrderid(info.orderid);
                    entity_position.setTotal_price_usd(entity_position.getTotal_price() * exchange_rate);
                    entity_position.setTmp(0);
                }
            }
            if(ArrayLen(info.document) > 0)
            {
                for(id_document in info.document){
                    order_documentService.editorder_Document(id_document, info.orderid);
                }
            }
            success = true;
            message="Update data success.";
        }
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    function addImportHistory() {
        var user = deserializeJSON(GetHttpRequestData().content).user; 
        var new_importHistory = entityNew('import_history');
            new_importHistory.setCreateTime(now());
            new_importHistory.setUserId(user);
            entitySave(new_importHistory);
        return  new_importHistory.getImport_id();
    }

    function editImportHistory(numeric importid, numeric countR, numeric countF) {
        var importHistory = entityLoad( "import_history", importid, true );
        importHistory.setSuccess(countR);
        importHistory.setFail(countF);
    }

    function getImportHistoryByUser() {
        var obj = createObject("component","api/general");
        VARIABLES.framework.renderData('JSON', obj.queryToArray(import_historyService.getImportHistory(URL.userid)));
    }

    function getImportHistoryDetailById() {
        var obj = createObject("component","api/general");
        VARIABLES.framework.renderData('JSON', obj.queryToArray(import_historyService.getImportHistoryDetail(URL.importid)));
    }
    
    function addImportHistoryDetail(struct order, numeric import_id, boolean status, string message) {
        var new_importHistoryDetail = entityNew('import_history_detail');
            new_importHistoryDetail.setOrder_no(order['Order Nr.'].trim());
            new_importHistoryDetail.setOrder_date(order['Order Date'].trim());
            new_importHistoryDetail.setCustomer_no(order['Customer Nr.'].trim());
            new_importHistoryDetail.setSupplier_no(order['Supplier Nr.'].trim());
            new_importHistoryDetail.setPosition_no(order['Position Nr.'].trim());
            new_importHistoryDetail.setProductitem_no(order['Product Item'].trim());
            new_importHistoryDetail.setQuantity(order['Quantity'].trim());
            new_importHistoryDetail.setUnitprice(order['Unit Price'].trim());
            new_importHistoryDetail.setCurrency(order['Currency'].trim());
            new_importHistoryDetail.setTransport(order['Transport by'].trim());
            new_importHistoryDetail.setExpected_date(order['Expected Shipping Date'].trim());
            new_importHistoryDetail.setComfirmed_date(order['Confirmed Shipping Date'].trim());
            new_importHistoryDetail.setStatus((status eq true)? 1 : 0);
            new_importHistoryDetail.setImport_id(import_id);
            new_importHistoryDetail.setMessage(message);
            entitySave(new_importHistoryDetail);
            return new_importHistoryDetail.getimport_detailid();
    }
    
    function importOrder(){
        var orders = deserializeJSON(GetHttpRequestData().content).data; 
        var ordersDisplay = [];
        var import_id = addImportHistory();
        var countTrue = 0;
        var countFalse = 0;
        for(order in orders)
        {
            var productlinename="";
            var productitemname="";
            var reason = '';
            var status = true;

            var product = product_itemService.getProductItemNoExist(order['Product Item'].trim());
            if(product.recordCount > 0 ){
                productlinename= product.product_line_name_english;
                productitemname= product.product_item_name_english;
                var check = purchase_orderService.getOrder(0,order['Order Nr.'].trim());
                if (check.recordCount > 0){
                    var exchange_rate = getcurrencyByCodeYear(check.currency, check.order_date);
                    if(isEmpty(exchange_rate)){
                        reason='Exchange rate '&check.currency&" in "&check.order_date&" doesn't exist";
                        status = false;
                        countFalse += 1;
                    }else{
                         var checkPosition = purchase_orderService.checkPositionNo(check.orderid,order['Position Nr.'].trim());
                        if(checkPosition.recordCount>0)
                        {
                            reason='Error when save Position, Position exist in systerm';
                            status = false;
                            countFalse += 1;
                        }else{
                            var position = {
                                "orderid":check.orderid,
                                "product_item_no": order['Product Item'].trim(),
                                "position_no":order['Position Nr.'].trim(),
                                "ordered_quantity": order['Quantity'].trim(),
                                "unit_price": order['Unit Price'].trim(),
                                "total_price": Round((LSParseNumber(order['Quantity'].trim())*LSParseNumber(order['Unit Price'].trim())) * 100) / 100,
                                "ab":  [{
                                    abno:1,
                                    shipped_quantity:order['Quantity'].trim(),
                                    shipment_method:order['Transport by'].trim(),
                                    expected_shipping_date:order['Expected Shipping Date'].trim(),
                                    confirmed_shipping_date:order['Confirmed Shipping Date'].trim(),
                                    shipping_date:'',
                                    za_date:'',
                                    eta_date:order['Confirmed Shipping Date'].trim(),
                                    relevant_due_date:order['Confirmed Shipping Date'].trim(),
                                    warehouse_book_date:''
                                }]
                            
                            };
                            var resultPosition = addOrderPosition(SerializeJSON(position),2);
                            if(resultPosition){
                                reason='Save order successful';
                                countTrue += 1;
                            }else{
                                reason='Error when save Position, Position exist in systerm';
                                status = false;
                                countFalse += 1;
                            }
                        }
                     }
                }else{
                    var exchange_rate = getcurrencyByCodeYear(order['Currency'].trim(), order['Order Date'].trim());
                    if(isEmpty(exchange_rate)){
                        reason='Exchange rate '&order['Currency'].trim()&" in "&order['Order Date'].trim()&" doesn't exist";
                        status = false;
                        countFalse += 1;
                    }else{
                        var purchase_order = {
                        "order_no":order['Order Nr.'].trim(),
                        "order_date":order['Order Date'].trim(),
                        "supplier_no":order['Supplier Nr.'].trim(),
                        "customer_no":order['Customer Nr.'].trim(),
                        "currency": order['Currency'].trim(),
                        "position":[],
                        "document":[]
                    };
                    var result = saveImportOrder(SerializeJSON(purchase_order));
                    if(result.orderid != 0){
                        var position = {
                            "orderid":result.orderid,
                            "product_item_no": order['Product Item'].trim(),
                            "position_no":order['Position Nr.'].trim(),
                            "ordered_quantity": order['Quantity'].trim(),
                            "unit_price": order['Unit Price'].trim(),
                            "total_price": Round((LSParseNumber(order['Quantity'].trim())*LSParseNumber(order['Unit Price'].trim())) * 100) / 100,
                            "ab":  [{
                                abno:1,
                                shipped_quantity:order['Quantity'].trim(),
                                shipment_method:order['Transport by'].trim(),
                                expected_shipping_date:order['Expected Shipping Date'].trim(),
                                confirmed_shipping_date:order['Confirmed Shipping Date'].trim(),
                                shipping_date:'',
                                za_date:'',
                                eta_date:order['Confirmed Shipping Date'].trim(),
                                relevant_due_date:order['Confirmed Shipping Date'].trim(),
                                warehouse_book_date:''
                            }]
                            
                        };
                        var resultPosition = addOrderPosition(SerializeJSON(position),2);
                        if(resultPosition){
                            reason='Save order successful';
                            countTrue += 1;
                        }else{
                            reason='Error when save Position, Position exist in systerm';
                            status = false;
                            countFalse += 1;
                        }
                    }else{
                        reason=result.message;
                        status = false;
                        countFalse += 1;
                    }
                }
             }   
                     
            }else{
                    reason='"Product Item No" does not exist in systerm';
                    status = false;
                    countFalse += 1;
            }
            var id = addImportHistoryDetail(order, import_id, status, reason);
            var display = {
                    'id':id,
                    'order_no': order['Order Nr.'].trim(),
                    'position_no' : order['Position Nr.'].trim(),
                    'ab_no':1,
                    'product_item_no':order['Product Item'].trim(),
                    'product_line' : productlinename,
                    'product_item_name': productitemname,
                    'order_qty':order['Quantity'].trim(),
                    'ab_qty':order['Quantity'].trim(),
                    'reason':reason,
                    'confirmed_shipping_date':order['Confirmed Shipping Date'].trim(),
                    'status' : status
                };
            ArrayAppend(ordersDisplay, display)
        }
        editImportHistory(import_id, countTrue, countFalse);
        VARIABLES.framework.renderData('JSON', {'success': true, 'data': ordersDisplay});
    }

    function reImportOrder(){

        var data = entityLoad('import_history_detail', URL.id, true);
        
            var productlinename="";
            var productitemname="";
            var reason = '';
            var status = true;
            
            var purchase_order = {
                "order_no":data.getorder_no(),
                "order_date":data.getorder_date(),
                "supplier_no":data.getsupplier_no(),
                "customer_no":data.getcustomer_no(),
                "currency": data.getcurrency(),
                "position":[],
                "document":[]
            };
            var result = saveImportOrder(SerializeJSON(purchase_order));
            if(result.orderid != 0){
                var exchange_rate = getcurrencyByCodeYear(result.currency, result.order_date);
                if(isEmpty(exchange_rate)){
                    reason='Exchange rate '&result.currency&" in "&result.order_date&" doesn't exist";
                    status = false;
                }else{
                    var product = product_itemService.getProductItemNoExist(data.getproductitem_no());
                    if(product.recordCount > 0 ){
                        productlinename= product.product_line_name_english;
                        productitemname= product.product_item_name_english;
                         var position = {
                            "orderid":result.orderid,
                            "product_item_no": data.getproductitem_no(),
                            "position_no":data.getposition_no(),
                            "ordered_quantity": data.getquantity(),
                            "unit_price": data.getunitprice(),
                            "total_price": Round((LSParseNumber(data.getquantity())*LSParseNumber(data.getunitprice())) * 100) / 100,
                            "ab":  [{
                                abno:1,
                                shipped_quantity:data.getquantity(),
                                shipment_method:data.gettransport(),
                                expected_shipping_date:data.getexpected_date(),
                                confirmed_shipping_date:data.getcomfirmed_date(),
                                shipping_date:'',
                                za_date:'',
                                eta_date:data.getcomfirmed_date(),
                                relevant_due_date:data.getcomfirmed_date(),
                                warehouse_book_date:''
                            }]
                            
                        };
                        var resultPosition = addOrderPosition(SerializeJSON(position),2);
                        if(resultPosition){
                            reason='Save order successful';
                        }else{
                            reason='Error when save Position, Position exist in systerm';
                            status = false;
                        }
                    }else{
                        reason='"Product Item No" does not exist in systerm';
                        status = false;
                    }
                }
            }else{
                reason=result.message;
                status = false;
            }
            var importHistory = entityLoad("import_history", data.getimport_id(), true);
            if(status){
                importHistory.setSuccess(importHistory.getSuccess() + 1);
                importHistory.setFail(importHistory.getFail() - 1);
                data.setstatus(status);
            }
            data.setmessage(reason);
         VARIABLES.framework.renderData('JSON', {'success': true});
    }

    function getOrderById(numeric id) {
            var obj = createObject("component","api/general");
            orderDetail = obj.queryToObject(purchase_orderService.getOrder(id, "")); 
            positions = obj.queryToArray(purchase_orderService.getIdPositionByOrderId(orderDetail.orderid));
            positionIds = [];
            
            for(pos in positions){
                aqArr = [];
                pos.ab = obj.queryToArray(purchase_orderService.getAbByPositionId(pos.positionid));
                arrayAppend(positionIds, pos.positionid);
                qls=obj.queryToArray(product_item_qlService.getQl(pos.product_item_no));
                for(q in qls){
                    arrayAppend(aqArr, q.ql);
                }
                pos.qls = aqArr;
            }
            orderDetail.position = positionIds;
            documents = obj.queryToArray(order_documentService.getListDocByIdOrder(orderDetail.orderid));

            documentIds = [];
            for(doc in documents){
                arrayAppend(documentIds, doc.id);
            }
            orderDetail.document = documentIds; 
            VARIABLES.framework.renderData('JSON', {
                                                    'purchase_order': orderDetail, 
                                                    'order_position': positions
                                                    });
    }
    function transport() { 
        var obj = createObject("component","api/general");
        result = purchase_orderService.getTransportList();
        VARIABLES.framework.renderData('JSON', obj.queryToArray(result));
    }

    function deleteAb() {
        if(cgi.request_method == "delete"){
            var success = false;
            var message = "";
            checkAbExist = entityLoad( "inspection_report", {abid=URL.id}, true );
            if(isNull(checkAbExist)){
                entity_ab = entityLoad( "ab", URL.id, true );
                entityDelete( entity_ab );
                entity_inspection_schedule = entityLoad( "inspection_schedule", {abid=URL.id}, true );
                entityDelete( entity_inspection_schedule );
                success = true;
                message = "Delete success";
            }else{
                message = "Can't delete because exist in inspection report";
            }
            VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
        }
    }

    function getOrderNo() {
        var obj = createObject("component","api/general");
        VARIABLES.framework.renderData('JSON', obj.queryToArray(purchase_orderService.getOrderNoList()));
    }

    function getCurrencyByYear() {
        var obj = createObject("component","api/general");
        var year    = Year(DateFormat(URL.order_date, 'yyyy-mm-dd'));
        VARIABLES.framework.renderData('JSON', obj.queryToArray(currencyService.getCurrencyByYear(year)));
    }

    function getcurrencyByCodeYear(string code, string order_date) {
        var year    = Year(DateFormat(order_date, 'yyyy-mm-dd'));
        return currencyService.getRateByCodeAndYear(code, year);
    }
    
    function position() {
        switch(cgi.request_method) { 
            case "put": 
                    editOrderPosition(GetHttpRequestData().content); 
                    break; 
            case "post": 
                addOrderPosition(GetHttpRequestData().content,1);
                break; 
            case "delete":
                if(StructKeyExists(URL, 'id')){
                    deleteOrderPosition(URL.id);
                }
                break;
            case "get": 
                if(StructKeyExists(URL, 'id')){
                    getOrderPositionById(URL.id);
                    break;
                }
                getOrderPositionList(GetHttpRequestData().headers.id);  
                break;          
        }
    }
    
    function execute() {

        switch(cgi.request_method) { 
            case "put": 
                    editOrder(GetHttpRequestData().content); 
                    break; 
            case "post": 
                saveOrder(GetHttpRequestData().content);
                break; 
            case "delete":
                if(StructKeyExists(URL, 'id')){
                    //deleteAccess(GetHttpRequestData().headers.token, URL.id);
                    break; 
                }
            case "get": 
                if(StructKeyExists(URL, 'id')){
                    getOrderById(URL.id);
                    break;
                }
                oSearch(); 
                break;          
        } //end switch
    }

}