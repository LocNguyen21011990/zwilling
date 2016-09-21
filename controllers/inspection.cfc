component accessors=true {

	property framework;
	property inspection_reportService;
    property product_item_setService;
    property inspection_scheduleService;
    property product_item_qlService;
    property product_itemService;
    property product_segment_documentService;
    property product_item_documentService;
    property purchase_orderService;
    property companyService;
    property inspection_report_mistakeService;
    
	public function init(required any fw){
		variables.fw =arguments.fw;
		var weekStart = now() - DayOfWeek( now() ) + 1;
		var weekEnd = weekStart + 6;
		session.frmDate = weekStart;
		session.toDate = weekEnd;
		session.slDurationTime = "cw";
		session.slSupplier = 0;
		session.slCustomer = 0;
		return this;
	}

    function oSearch() {
        var obj = createObject("component","api/general");

        var startDate = "";
        var endDate = "";
        var supplier = 0;
        var customer = 0;
        
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
 
        var inspection = VARIABLES.inspection_scheduleService.search(startDate, endDate).filter(
            function(row, rowNr, qrData){   
                var sup_filter = supplier ? (row.supid == supplier) : true ;
                var cus_filter = customer ? (row.cusid == customer) : true ;
                return sup_filter && cus_filter; 
        }); 

        result = obj.queryToArray(inspection);
        VARIABLES.framework.renderData('JSON', result);
    }

    function getProductItemSet() {
        var product_item_set = product_item_setService.getProductItemSet(URL.id);
        var arrayProductItemSet = [];
        if(!isEmpty(product_item_set)){
            for(item in product_item_set){
                if(item.is_general_report == 0 and item.parent == 1){
                    arrayAppend(arrayProductItemSet, item);
                    break;
                }else{
                    arrayAppend(arrayProductItemSet, item);
                }
            }
        }
        VARIABLES.framework.renderData('JSON', arrayProductItemSet);
    }
    
    function getInspectionScheduleInput(numeric schab, string itemno) {
        var obj = createObject("component","api/general");
        var inspection_order = inspection_scheduleService.getInspection_order(schab, itemno);
        data = obj.queryToObject(inspection_order);
        data.product_item_no = itemno;
        check = product_item_qlService.getProductItenQl(itemno); 
        product_segment_id = 0;
        if(!isEmpty(check)){
            data.quality_level = check.ql;
            ql = product_itemService.getQl(check.product_item_no);
            data.product_line = ql.product_line_name_english;
            data.product_item_name = ql.product_item_name_english;
            data.product_segment_id = ql.product_segment_id;
        }else{
            pql = product_itemService.getQl(itemno);
            data.quality_level = pql.ql;
            data.product_line = pql.product_line_name_english;
            data.product_item_name = pql.product_item_name_english;
            data.product_segment_id = pql.product_segment_id;
        }
        sub_size = 1;
        if(StructKeyExists(URL, 'quantity')){
            sub_size = URL.quantity;
        }
        lot_size = sub_size * lsParseNumber(data.shipped_quantity);
        ql_specs = inspection_reportService.getQualityLevel(data.quality_level, lot_size);
        if(!isEmpty(ql_specs)){
            data.major_allow = ql_specs.major_accepted;
            data.major_reject = ql_specs.major_rejected;
            data.minor_allow = ql_specs.minor_accepted;
            data.minor_reject = ql_specs.minor_rejected;
        }
        data.item_lost_size = lot_size;
        data.inspected_quantity = ql_specs.inspection_lot;
        //mistakes = inspection_reportService.getMistakeList(product_segment_id);
        VARIABLES.framework.renderData('JSON', data);
    }
    
    function editSchedule() {
        /*{id:1, inspector1: "inspector1", inspector2: "inspector2", plan_date: "2015-11-23", updateby:"kyu"}*/
        var success = false;
        var message = "Update data fail";
        if(cgi.request_method eq "put")
        {
            var info = deserializeJSON(GetHttpRequestData().content);
            var update_date = now();
            
            inspection_schedule = entityLoad( "inspection_schedule", info.id, true );
            inspection_schedule.setInspector1(info.inspector1);
            inspection_schedule.setInspector2(info.inspector2);
            inspection_schedule.setPlan_date(DateFormat(info.plan_date, "yyyy-mm-dd"));
            inspection_schedule.setLastupdate(now());
            inspection_schedule.setUpdateby(info.updateby);
            success = true;
            message = "Update data success";
        }
        
        VARIABLES.framework.renderData('JSON', {'success': success, 
                                                        'message': message
                                                        });
    }  

    function saveInspection(string data)
    {
        var success = false;
        var message = "Insert data fail";
        var info = deserializeJSON(data);
        var update_date = dateFormat(now(),'yyyy-mm-dd');
        var inspectionNo = inspection_reportService.checkInspectionNoExist(info.inspection_no); 
        var id = 0;
        if(!isEmpty(inspectionNo)){
            message="The inspection number is existed already!";
        }else{
            var new_report = entityNew("inspection_report");
            new_report.setAbid(info.abid);
            new_report.setInspection_no(info.inspection_no);
            new_report.setInspection_date(info.inspection_date);
            new_report.setSet_item_lot_size(lsParseNumber(info.set_item_lot_size));
            new_report.setItem_lot_size(lsParseNumber(info.item_lot_size));
            new_report.setInspected_quantity(lsParseNumber(info.inspected_quantity));
            new_report.setInspected_ql(info.inspected_ql);
            // new_report.setStandard_inspected_quantity(lsParseNumber(report_info.std_ins_quantity));
            // new_report.setMajor_defect_acceptable(lsParseNumber(report_info.major_accepted));
            // new_report.setMinor_defect_acceptable(lsParseNumber(report_info.minor_accepted));
            
            new_report.setInspected_product_item_no(info.product_item_no);
            new_report.setInspector1(info.inspector1);
            new_report.setInspector2(info.inspector2);
            new_report.setLast_change_person(info.last_change_person);
            new_report.setSeal_from1(info.sealfrom1);
            new_report.setSeal_from2(info.sealfrom2);
            new_report.setSeal_to1(info.sealto1);
            new_report.setSeal_to2(info.sealto2);
            if (info.td_materials == 'no' && structKeyExists(info,"missing_td")) {
                new_report.setMissing_td(lsParseNumber(info.missing_td));
            };
            if (info.ss_materials == 'no' && structKeyExists(info,"missing_ss")) {
                new_report.setMissing_ss(lsParseNumber(info.missing_ss));
            };
            new_report.setCarton_info(info.carton_info);
            new_report.setResult(info.result);
            new_report.setQuantity_accepted(info.quantity_accepted);
            new_report.setComment(info.comment);
            new_report.setIs_general_report(info.is_general_report);
            new_report.setLastupdate(update_date);
            entitySave(new_report);
            id = new_report.getInspectionid();
            if(structKeyExists(info, "mistake"))
            {
                for (ins_mis in info.mistake){
                    entity_mistake = entityLoad( "inspection_report_mistake", ins_mis, true );
                    entity_mistake.setInspectionid(id);
                }
            }
            var success = true;
            var message = "Insert data success";
            reportEXP(info);
        }
        
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message,'id':id});
    }

    function editInspection(string data)
    {
        var success = false;
        var message = "Update data fail";
        var info = deserializeJSON(data);
        var update_date = dateFormat(now(),'yyyy-mm-dd');
        //var new_report = entityNew("inspection_report");
        var inspectionNo = inspection_reportService.checkInspectionNoExist(info.inspection_no, info.inspectionid); 
        if(!isEmpty(inspectionNo)){
            message="The inspection number is existed already!";
        }else{
            var entity_report = entityLoad( "inspection_report", info.inspectionid, true );
            entity_report.setAbid(info.abid);
            entity_report.setInspection_no(info.inspection_no);
            entity_report.setInspection_date(info.inspection_date);
            entity_report.setSet_item_lot_size(lsParseNumber(info.set_item_lot_size));
            entity_report.setItem_lot_size(lsParseNumber(info.item_lot_size));
            entity_report.setInspected_quantity(lsParseNumber(info.inspected_quantity));
            entity_report.setInspected_ql(info.inspected_ql);
            entity_report.setInspected_product_item_no(info.product_item_no);
            entity_report.setInspector1(info.inspector1);
            entity_report.setInspector2(info.inspector2);
            entity_report.setLast_change_person(info.last_change_person);
            entity_report.setSeal_from1(info.sealfrom1);
            entity_report.setSeal_from2(info.sealfrom2);
            entity_report.setSeal_to1(info.sealto1);
            entity_report.setSeal_to2(info.sealto2);
            if (info.td_materials == 'no' && structKeyExists(info,"missing_td")) {
                entity_report.setMissing_td(lsParseNumber(info.missing_td));
            };
            if (info.ss_materials == 'no' && structKeyExists(info,"missing_ss")) {
                entity_report.setMissing_ss(lsParseNumber(info.missing_ss));
            };
            entity_report.setCarton_info(info.carton_info);
            entity_report.setResult(info.result);
            entity_report.setQuantity_accepted(info.quantity_accepted);
            entity_report.setComment(info.comment);
            entity_report.setIs_general_report(info.is_general_report);
            entity_report.setLastupdate(update_date);
            
            // if(structKeyExists(info, "mistake"))
            // {
            //     entity_irm = entityLoad( "inspection_report_mistake", {inspectionid=info.inspectionid}, true );
            //     entityDelete(entity_irm);
            //     for (ins_mis in info.mistake){
            //         entity_mistake = entityLoad( "inspection_report_mistake", ins_mis, true );
            //         entity_mistake.setInspectionid(info.inspectionid);
            //     }
            // }
            var success = true;
            var message = "Update data success";
            reportEXP(info);
        }
        
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    function getListDocument() {
        var obj = createObject("component","api/general");
        document = obj.queryToArray(product_segment_documentService.getListByproductSegmentId(URL.product_segment_id));
        items = obj.queryToArray(product_item_documentService.getListByitemno(URL.itemno));
        document.addAll(items);
        variables.framework.renderData('JSON', document);
    }
    
    function getInspectionNo() {
        var obj = createObject("component","api/general");
        VARIABLES.framework.renderData('JSON', obj.queryToArray(inspection_reportService.getInspectionNoList()));
    }

    function getListInspectionByAbid() {
        var obj = createObject("component","api/general");
        var data = obj.queryToArray(inspection_reportService.getListInspectionByAbid(URL.abid));
        variables.framework.renderData('JSON', data);
    }
    
    function getLocationList() {
        var obj = createObject("component","api/general");
        VARIABLES.framework.renderData('JSON', obj.queryToArray(companyService.getLocationList()));
    }

    function getInspectionCalendar() {
        var obj             = createObject("component","api/general");
        var startDate       = DateFormat( CreateDate(URL.year, URL.month, 1), 'yyyy-mm-dd' );
        var endDate         = DateFormat( CreateDate(URL.year, URL.month, DaysInMonth(startDate)), 'yyyy-mm-dd' );
        var calendar        = [];
        var supplier = 0;
        var inspector = 0;
        var location = 0;
        var dateCurrent = DateFormat(now(), "yyyy-mm-dd");
        if(StructKeyExists(URL, 'supplier') && URL.supplier != ''){
            supplier = URL.supplier;
        }
        if(StructKeyExists(URL, 'inspector') && URL.inspector != ''){
            inspector = URL.inspector;
        }
        if(StructKeyExists(URL, 'location') && URL.location != ''){
            location = URL.location;
        }
        var result          = purchase_orderService.getInspectionCalendar(startDate, endDate).filter(
            function(row, rowNr, qrData){   
                var sup_filter = supplier ? (row.supplier_companyid == supplier) : true;
                var inp_filter = inspector ? (row.inspector1 == inspector || row.inspector2 == inspector) : true;
                var loc_filter = location ? (row.locationid == location) : true ;
                return sup_filter && inp_filter && loc_filter;
            });
        
        for(item in result)
        {
            var structCalendar = {};
            structCalendar.title = item.shipped_quantity&" x "&item.product_line_name_english&" - "&item.product_item_name_english;
            structCalendar.start = DateFormat(item.plan_date, "yyyy-mm-dd");
            structCalendar.stick = true;
            var color = "";
            var mdate = DateDiff("d", dateCurrent, structCalendar.start);
            if(!isEmpty(item.inspection_no)){
                color = "green";
            }else{
                if(mdate <= 7){
                    color = "red";
                }else{
                    color = "orange";
                }
            }
            structCalendar.icon  = "<i class='fa fa-file-text-o "&color&"'></i>";
            arrayAppend(calendar, structCalendar);
        }
        VARIABLES.framework.renderData('JSON', calendar);
    }
    
    //==============================================


    
    public function save_config_user_control(struct rc) {

    	var obj = createObject("component","api/general");
     	var check = obj.config_user(obj.getIdPage(CGI.path_info));
     	var conf = [];
     	var confTruct ={};
        /*{"jsonControl":jsonControl, "func": func} */
        var info = DeserializeJSON(GetHttpRequestData().content);
     	if(!isEmpty(check)){ 
     		conf = deserializeJSON(check.config);
            flag = 0;
     		for(item in conf){
                if(item.action eq info.func){
                    item.control = deserializeJSON(info.jsonControl);
                    flag = 1;
                }
	      	}
            if(flag eq 0){
                confTruct.language= "";
                confTruct.control= deserializeJSON(info.jsonControl);
                confTruct.favorite= [];
                confTruct.action= info.func;
                ArrayAppend(conf, confTruct);
            }
	      	
     	}else{
     		confTruct.language= "";
     		confTruct.control= deserializeJSON(info.jsonControl);
     		confTruct.favorite= [];
            confTruct.action= info.func;
     		ArrayAppend(conf, confTruct);
     	}
     	obj.save_config_user(obj.getIdPage(CGI.path_info), serializeJSON(conf));
    	success = true;
        message = "Save config data success!";
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }
    
    public function save_config_user_favorite(struct rc) {

    	var obj = createObject("component","api/general");
     	var check = obj.config_user(obj.getIdPage(CGI.path_info));
     	var conf = [];
     	var confTruct ={};
        /*{"favorite":favorite, "func": func} */
        var info = DeserializeJSON(GetHttpRequestData().content);
     	if(!isEmpty(check)){
     		conf = deserializeJSON(check.config);
            flag = 0;
     		for(item in conf){
                if(item.action eq info.func){
                    ArrayAppend(item.favorite, info.favorite);  
                    flag = 1;
                }    			
	      	}
            if(flag eq 0){
                confTruct.language= "";
                confTruct.control= {};
                confTruct.favorite= [info.favorite];
                confTruct.action= info.func;
                ArrayAppend(conf, confTruct);
            }
     	}else{
     		confTruct.language= "";
     		confTruct.control= {};
     		confTruct.favorite= [info.favorite];
            confTruct.action= info.func;
            ArrayAppend(conf, confTruct);
     	}
     	obj.save_config_user(obj.getIdPage(CGI.path_info), serializeJSON(conf));
    	success = true;
        message = "Save config data success!";
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    public function delete_config_user_favorite(struct rc) {
    	var obj = createObject("component","api/general");
     	var check = obj.config_user(obj.getIdPage(CGI.path_info));
     	var conf = [];
        /*{"id":1, "func": func} */
        var info = DeserializeJSON(GetHttpRequestData().content);
     	if(!isEmpty(check)){
     		conf = deserializeJSON(check.config);
     		for(item in conf){
                if(item.action eq info.func){
     			    ArrayDeleteAt(item.favorite, info.id);
                }
	      	}
            obj.save_config_user(obj.getIdPage(CGI.path_info), serializeJSON(conf)); 
     	}
        success = true;
        message = "Delete config data success!";
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    public function userConfig() {
        switch(cgi.request_method) { 
            case "put": 
                if(StructKeyExists(URL, 'id')){
                    var success = false;
                    var message = "Save config data error";
                    var obj = createObject("component","api/general");
                    var result=obj.save_config_user(
                                            URL.id,
                                            GetHttpRequestData().content
                                        );
                    if(result){
                        success = true;
                        message = "Save config data success";
                    }
                    VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
                    break; 
                }
            case "get": 
                var obj = createObject("component","api/general");
                conf=obj.config_user(
                                        obj.getIdUserByToken(GetHttpRequestData().headers.Authorization), 
                                        obj.getIdPage(CGI.path_info), 
                                        GetHttpRequestData().headers.act
                                    );
                VARIABLES.framework.renderData('JSON', conf);
                break;          
        }
    }
    
    function calendarSearch() {
        var obj = createObject("component","api/general");
        if(StructKeyExists(URL, 'start')){
            startDate = DateFormat( URL.start, 'yyyy-mm-dd' );
        }
        if(StructKeyExists(URL, 'end')){
            endDate = DateFormat( URL.end, 'yyyy-mm-dd' );
        }
        inspection = VARIABLES.inspection_scheduleService.search(startDate, endDate); 
        var result = [];
        for(item in inspection){
            var structCalendar = {};
            structCalendar.title = item.order_no&"::"&item.abid;
            structCalendar.start = DateFormat(item.plan_date, "yyyy-mm-dd");
            structCalendar.stick = true;
            arrayAppend(result, structCalendar)
        }
        VARIABLES.framework.renderData('JSON', result);
    }
    
    function execute() {

        switch(cgi.request_method) { 
            case "put": 
                    editInspection(GetHttpRequestData().content); 
                    break; 
            case "post": 
                saveInspection(GetHttpRequestData().content);
                break; 
            case "delete":
                if(StructKeyExists(URL, 'id')){
                    //deleteAccess(GetHttpRequestData().headers.token, URL.id);
                    break; 
                }
            case "get": 
                if(StructKeyExists(URL, 'id')){
                    getProductItemSet(URL.id);
                    break;
                }
                if(StructKeyExists(URL, 'schab') and StructKeyExists(URL, 'itemno')){
                    getInspectionScheduleInput(URL.schab, URL.itemno);
                    break;
                }
                if(StructKeyExists(URL, 'start') and StructKeyExists(URL, 'end') and StructKeyExists(URL, 'calendar')){
                    calendarSearch(URL.start, URL.end);
                    break;
                }
                if(StructKeyExists(URL, 'abid')){
                    getListInspectionByAbid(URL.abid);
                    break;
                }
                oSearch(); 
                break;        
        } //end switch
    }
    
    function reportEXP(struct data) {
        var obj = createObject("component","api/general");
        var exp = createObject("component","report");
        data.company = obj.queryToObject(inspection_scheduleService.getInspection_order(data.abid, data.product_item_no));
        var check = product_item_qlService.getProductItenQl(data.product_item_no); 
        var product_segment_id = 0;
        if(!isEmpty(check)){
            var ql = product_itemService.getQl(check.product_item_no);
            data.product_line = ql.product_line_name_english;
            data.product_item_name = ql.product_item_name_english;
        }else{
            var pql = product_itemService.getQl(data.product_item_no);
            data.product_line = pql.product_line_name_english;
            data.product_item_name = pql.product_item_name_english;
        }
        ql_specs = inspection_reportService.getQualityLevel(data.inspected_ql, data.item_lot_size);
        if(!isEmpty(ql_specs)){
            data.major_allow = ql_specs.major_accepted;
            data.major_reject = ql_specs.major_rejected;
            data.minor_allow = ql_specs.minor_accepted;
            data.minor_reject = ql_specs.minor_rejected;
        }
        if(data.inspectionid != ""){
            data.report_mistakes = obj.queryToArray(inspection_report_mistakeService.getInsReportMisByInspectionid(data.inspectionid));
        }else{
            if(ArrayLen(data.mistake) > 0){
                var ids = ArrayToList(data.mistake, ",");
                data.report_mistakes = obj.queryToArray(inspection_report_mistakeService.getInsReportMisByListId(ids));
            }else{
                data.report_mistakes = [];
            }
        }
        var rData = "false"; 
        rData = exp.exportReport(data);
        VARIABLES.framework.renderData('JSON', rData);
    }
}
