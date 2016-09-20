/* @author : duy */

component accessors=true {

	property framework;
    property purchase_orderService;
	property documentService;

    function saveCustomer(struct rc) { 
        if(cgi.request_method == 'post'){ 
            var customer = entityNew('company');
            customer.setName(rc.name);
            customer.setGildemeisterid(rc.gildemeisterid);
            customer.setAddress(rc.address);
            customer.setMail(rc.mail);
            customer.setPhone(rc.phone);
            customer.setFax(rc.fax);
            customer.setCompany_kind(3);
            customer.setLastupdate(now());
            entitySave(customer);
            id_customer = customer.getCompanyid();
            success = true;
            message = "Insert data success";
            VARIABLES.framework.renderData('JSON', {'success': success, 'message': message, 'id_customer':id_customer});
        }   
    }

    function saveSupplier(struct rc) { 
        if(cgi.request_method == 'post'){ 
            var supplier = entityNew('company');
            supplier.setName(rc.name);
            supplier.setGildemeisterid(rc.gildemeisterid);
            supplier.setAddress(rc.address);
            supplier.setMail(rc.mail);
            supplier.setPhone(rc.phone);
            supplier.setFax(rc.fax);
            supplier.setCompany_kind(2);
            supplier.setLastupdate(now());
            entitySave(supplier);
            id_supplier = supplier.getCompanyid();
            success = true;
            message = "Insert data success";
            VARIABLES.framework.renderData('JSON', {'success': success, 'message': message, 'id_supplier':id_supplier});
        }   
    }

    function getDocumentList() {
        documents = documentService.getDocumentByType(1);
        VARIABLES.framework.renderData('JSON', {'documentList': documents});
    }

    function deleteDocumentList() {
        documents = documentService.deleteDocument(rc.id);
        success = true;
        message = "Delete data success";
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    function inputOrder( struct rc ) {
        var obj = createObject("component","api/general");
        if(structKeyExists(URL, "id"))
        { 
            rc.orderDetail = obj.queryToArray(VARIABLES.purchase_orderService.getOrder(0,URL.id));
            //writeDump(rc.orderDetail);abort;
            rc.customer = obj.queryToArray(VARIABLES.purchase_orderService.getCompany(rc.orderDetail[1].customer,0));
            rc.supplier = obj.queryToArray(VARIABLES.purchase_orderService.getCompany(rc.orderDetail[1].supplier,0));
            rc.orderPosition = obj.queryToArray(VARIABLES.purchase_orderService.getPosition(0,rc.orderDetail[1].orderid));
            rc.buyer = obj.queryToArray(VARIABLES.purchase_orderService.getMember(rc.customer[1].gildemeisterid));
            rc.Purchaser = isNull(rc.Purchaser[1].fullname)?"&nbsp;":rc.buyer[1].fullname;
            rc.documents = documentService.getDocumentByOrderId(rc.orderDetail[1].orderid);
            VARIABLES.framework.renderData('JSON', {
                                                    'orderDetail': rc.orderDetail, 
                                                    'customer': rc.customer,
                                                    'supplier': rc.supplier,
                                                    'orderPosition': rc.orderPosition,
                                                    'buyer': rc.buyer,
                                                    'Purchaser': rc.Purchaser,
                                                    'documents': rc.documents,
                                                    });
        }
    }
    
    function oSearch( struct rc ) {
        var current = now();
        var current_month = Month(current);
        var current_year = Year(current);
        param name='rc.start' default=DateFormat( CreateDate(current_year, current_month, 1), 'yyyy-mm-dd' );
        param name='rc.end' default=DateFormat( CreateDate(current_year, current_month, DaysInMonth(current)), 'yyyy-mm-dd' );
        param name='rc.fdt' default="cm";
        param name='rc.supid' default=0;
        param name='rc.cusid' default=0;
        rc.purchase_orders = VARIABLES.purchase_orderService.getOrderSearch(rc.start,rc.end).filter(function(row, rowNr, qrData)
            {   var sup_filter = rc.supid ? (row.supid == rc.supid) : true ;
                var cus_filter = rc.cusid ? (row.cusid == rc.cusid) : true ;
                return sup_filter && cus_filter;
        });
        rc.customer = VARIABLES.purchase_orderService.getCompany('',3);
        rc.supplier = VARIABLES.purchase_orderService.getCompany('',2);
        //rc.pagetitle = 'List of Orders';
        VARIABLES.framework.renderData('JSON', {
                                                    'purchase_orders': rc.purchase_orders, 
                                                    'customer': rc.customer,
                                                    'supplier': rc.supplier
                                                    });

    }
    
    function orderList( struct rc )
    {
        var current = now();
        var current_month = Month(current);
        var current_year = Year(current);
        var obj = createObject("component","api/general");
        param name='rc.start' default=DateFormat( CreateDate(current_year, current_month, 1), 'yyyy-mm-dd' );
        param name='rc.end' default=DateFormat( CreateDate(current_year, current_month, DaysInMonth(current)), 'yyyy-mm-dd' );
        param name='rc.fdt' default="cm";
        param name='rc.supid' default=0;
        param name='rc.cusid' default=0;
        var orders = VARIABLES.purchase_orderService.getOrderSearch(rc.start,rc.end).filter(function(row, rowNr, qrData)
            {   var sup_filter = rc.supid ? (row.supid == rc.supid) : true ;
                var cus_filter = rc.cusid ? (row.cusid == rc.cusid) : true ;
                return sup_filter && cus_filter;
        });
        VARIABLES.framework.renderData('JSON', obj.queryToArray(orders));
    }
    
    function companyInfo( struct rc ) {
        var obj = createObject("component","api/general");
        param name="rc.name_term" default="";
        var companies = VARIABLES.purchase_orderService.getCompany('', rc.kind).filter( function(row, rowNr, qrData) {
            return rc.name_term eq '' ? true : findNoCase(rc.name_term, row.name ) > 0;
        });
        VARIABLES.framework.renderData('JSON', obj.queryToArray(companies));
    }

    function companyMember( struct rc ) {
        var member = VARIABLES.purchase_orderService.getMember(rc.gid);
        VARIABLES.framework.renderData("JSON", member);
    }

    public any function orderDetail(param) {
        //rc.pagetitle = 'Detail Order';
        if(structKeyExists(URL, "id"))
        {
            // rc.product_item = VARIABLES.purchase_orderService.getProductItem("","");
            var obj = createObject("component","api/general");
            rc.orderDetail = obj.queryToArray(VARIABLES.purchase_orderService.getOrder(0,URL.id));
            rc.customer = obj.queryToArray(VARIABLES.purchase_orderService.getCompany(rc.orderDetail[1].customer,0));
            rc.supplier = obj.queryToArray(VARIABLES.purchase_orderService.getCompany(rc.orderDetail[1].supplier,0));
            rc.orderPosition = obj.queryToArray(VARIABLES.purchase_orderService.getPosition(0,rc.orderDetail[1].orderid));
            rc.Purchaser = obj.queryToArray(VARIABLES.purchase_orderService.getMember(rc.customer[1].gildemeisterid));
            rc.Purchaser = isNull(rc.Purchaser[1].fullname)?"&nbsp;":rc.Purchaser[1].fullname;
            rc.documents = documentService.getDocumentByOrderId(rc.orderDetail[1].orderid);
            VARIABLES.framework.renderData('JSON', {
                                                    'orderDetail': rc.orderDetail, 
                                                    'customer': rc.customer,
                                                    'supplier': rc.supplier,
                                                    'orderPosition': rc.orderPosition,
                                            
                                                    'Purchaser': rc.Purchaser,
                                                    'documents': rc.documents,
                                                    });
        }
    }

    public any function uploadDocument(struct rc) {
        if(structKeyExists(rc, "file"))
        {
            var fc1 = fileupload("#expandpath('/media/detail/files')#", "#file#" ,"application/pdf,application/msword,application/msexcel","makeunique");
        }
    }

    function addOrderPosition(struct rc) {
        if(cgi.request_method == 'post'){
            var info = deserializeJSON(rc.inform);
            var update_date = now();
            
            //var pos = info.position_list;
            var new_position = entityNew('order_position');
            //new_position.setOrderid(new_order.getOrderid());
            new_position.setOrdered_pattern_item(info[1].ordered_pattern_item);
            new_position.setPosition_no(info[1].position_no);
            new_position.setOrdered_quantity(lsParseNumber(info[1].ordered_quantity));
            new_position.setInspected_quantity(0);
            new_position.setExported_quantity(0);
            new_position.setUnit_price(info[1].unit_price);
            new_position.setTotal_price(info[1].total_price);
            new_position.setCurrency(info[1].currency);
            new_position.setLastupdate(update_date);
            entitySave(new_position);
            for (item in info) {
                var new_ab = entityNew('ab');
                new_ab.setPositionid(new_position.getPositionid());
                new_ab.setAbno(lsParseNumber(item.abno));
                new_ab.setShipped_quantity(lsParseNumber(item.shipped_quantity));
                new_ab.setShipment_method(item.shipment_method);
                new_ab.setExpected_shipping_date(DateFormat(item.expected_shipping_date, "yyyy-mm-dd"));
                new_ab.setConfirmed_shipping_date(DateFormat(item.confirmed_shipping_date, "yyyy-mm-dd"));
                new_ab.setLastupdate(update_date);
                entitySave(new_ab);
                var new_schedule = entityNew('inspection_schedule');
                new_schedule.setAbid(new_ab.getAbid());
                new_schedule.setInspection_planDate(DateFormat(item.inspection_plandate, "yyyy-mm-dd"));
                new_schedule.setLastupdate(update_date);
                entitySave(new_schedule);
            }
            success = true;
            message = "Insert data success";
            VARIABLES.framework.renderData('JSON', {'success': success, 
                                                    'message': message, 
                                                    'positionid':new_position.getPositionid()
                                                    });
        }
        
    }

    function editOrderPosition(struct rc) {
        if(cgi.request_method == 'put'){
            var info = deserializeJSON(rc.inform);
            var update_date = now();
            for (item in info) {
                entity_position = entityLoad( "order_position", item.positionid, true );
                entity_position.setOrdered_pattern_item(item.ordered_pattern_item);
                entity_position.setPosition_no(item.position_no);
                entity_position.setOrdered_quantity(lsParseNumber(item.ordered_quantity));
                entity_position.setInspected_quantity(0);
                entity_position.setExported_quantity(0);
                entity_position.setUnit_price(item.unit_price);
                entity_position.setTotal_price(item.total_price);
                entity_position.setCurrency(item.currency);
                entity_position.setLastupdate(update_date);
                
                entity_ab = entityLoad( "ab", item.abid, true );
                entity_ab.setPositionid(item.positionid);
                entity_ab.setAbno(lsParseNumber(item.abno));
                entity_ab.setShipped_quantity(lsParseNumber(item.shipped_quantity));
                entity_ab.setShipment_method(item.shipment_method);
                entity_ab.setExpected_shipping_date(DateFormat(item.expected_shipping_date, "yyyy-mm-dd"));
                entity_ab.setConfirmed_shipping_date(DateFormat(item.confirmed_shipping_date, "yyyy-mm-dd"));
                entity_ab.setLastupdate(update_date);

                entity_schedule = entityLoad( "inspection_schedule", item.id, true );
                
                entity_schedule.setAbid(item.abid);
                entity_schedule.setInspection_planDate(DateFormat(item.inspection_plandate, "yyyy-mm-dd"));
                entity_schedule.setLastupdate(update_date);
            }

            success = true;
            message = "Update data success";
            VARIABLES.framework.renderData('JSON', {'success': success, 
                                                        'message': message
                                                        });
        }else{
           var obj = createObject("component","api/general");
            var orderPosition = purchase_orderService.getPositionEdit(rc.positionid, 0);
            VARIABLES.framework.renderData('JSON', obj.queryToArray(orderPosition)); 
        }
    }


    function deleteOrderPosition(struct rc) {
        if(cgi.request_method == 'delete'){
            var idChild = purchase_orderService.getPositionDelete(rc.positionid, 0);
            for(item in idChild){
                entity_ab = entityLoad( "ab", item.abid, true );
                entityDelete( entity_ab );
                entity_inspection_schedule = entityLoad( "inspection_schedule", item.id, true );
                entityDelete( entity_inspection_schedule );
            }
            entity_position = entityLoad( "order_position", rc.positionid, true );
            entityDelete( entity_position );
            success = true;
            message = "Delete data success";
            VARIABLES.framework.renderData('JSON', {'success': success, 
                                                        'message': message});
        }
    }
    
    function saveOrder(struct rc) {
        if(cgi.request_method == 'post'){
            var success = false;
            var message = "";
            var info = deserializeJSON(rc.inform);
            if (VARIABLES.purchase_orderService.getOrder(0,info.order_no).recordCount > 0){
                message="The order number is existed already!";
            } else {
                var update_date = now();
                var new_order = entityNew('purchase_order');
                new_order.setOrder_no(info.order_no);
                new_order.setOrder_date(now());
                new_order.setSupplier_companyid(info.supplier_id);
                new_order.setBuyer_companyid(info.customer_id);
                new_order.setInspector_companyid(info.customer_id);
                new_order.setLastupdate(update_date);
                new_order.setBuyer_id(LsParseNumber(info.buyer_id));
                entitySave(new_order);
                for(item in info.order_position){
                    entity_position = entityLoad( "order_position", item.positionid, true );
                    entity_position.setOrderid(new_order.getOrderid());
                    entity_position.setTmp(1);
                }
            }
            var success = true;
            message="Insert data success.";
            VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
        }
    }
    
    // function saveOrder_old( struct rc ) {
    //     var success = false;
    //     var message = "";
    //     try {
    //         var info = deserializeJSON(rc.info);
    //         if (VARIABLES.purchase_orderService.getOrder(0,info.order.order_no).recordCount > 0){
    //             message="The order number is existed already!";
    //         } else {
    //             // dump(info); abort;
    //             var update_date = now();
    //             var new_order = entityNew('purchase_order');
    //             new_order.setOrder_no(info.order.order_no);
    //             new_order.setOrder_date(now());
    //             new_order.setSupplier_companyid(info.order.supplier_id);
    //             new_order.setBuyer_companyid(info.order.customer_id);
    //             new_order.setInspector_companyid(info.order.customer_id);
    //             new_order.setLastupdate(update_date);
    //             new_order.setBuyer_id(LsParseNumber(info.order.buyer_id));
    //             entitySave(new_order);
    //             for (pos in info.position_list) {
    //                 var new_position = entityNew('order_position');
    //                 new_position.setOrderid(new_order.getOrderid());
    //                 new_position.setOrdered_pattern_item(pos.item_number);
    //                 new_position.setPosition_no(pos.number);
    //                 new_position.setOrdered_quantity(lsParseNumber(pos.quantity));
    //                 new_position.setInspected_quantity(0);
    //                 new_position.setExported_quantity(0);
    //                 new_position.setUnit_price(pos.unit_price);
    //                 new_position.setTotal_price(pos.total_price);
    //                 new_position.setCurrency(pos.currency);
    //                 new_position.setLastupdate(update_date);
    //                 entitySave(new_position);
    //                 for (ab in pos.ab_list) {
    //                     var new_ab = entityNew('ab');
    //                     new_ab.setPositionid(new_position.getPositionid());
    //                     new_ab.setAbno(lsParseNumber(ab.number));
    //                     new_ab.setShipped_quantity(lsParseNumber(ab.ab_quantity));
    //                     new_ab.setShipment_method(ab.transport);
    //                     new_ab.setExpected_shipping_date(ab.etd);
    //                     new_ab.setConfirmed_shipping_date(ab.confd);
    //                     new_ab.setLastupdate(update_date)
    //                     entitySave(new_ab);
    //                     var new_schedule = entityNew('inspection_schedule');
    //                     new_schedule.setAbid(new_ab.getAbid());
    //                     new_schedule.setInspection_plandate(dateAdd('d',-7,ab.etd));
    //                     new_schedule.setLastupdate(update_date);
    //                     entitySave(new_schedule);
    //                 };
    //             };

    //             success = true;
    //         };

    //     } catch (any e) {
    //         message = "SERVER ERROR!!! " & e.message;
    //     }

    //     VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    // }
    
}