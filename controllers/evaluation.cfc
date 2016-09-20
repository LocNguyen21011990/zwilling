component accessors=true {

	property framework;
    property purchase_orderService;
    property companyService;
    property inspection_reportService;

    function getProductLineBySegment() {
        var paramset={};
        var obj = createObject("component","api/general");
        var sql = "select product_line_no, product_line_name_english from product_line where 1 = 1 ";
        if(StructKeyExists(URL, 'id')){
            sql &= " and product_segment_id = :product_segment_id";
            paramset['product_segment_id'] = {value=URL.id, CFSQLType="integer"};
        }
        sql &= " order by product_line_name_english, product_line_name_german";
        VARIABLES.framework.renderData('JSON', obj.queryToArray(queryExecute(sql, paramset)));
    }
    
    function getPerSupplierOrder(struct data) {
        var obj = createObject("component","api/general");
        var result = companyService.getEvaluationSupplier(data); 
        VARIABLES.framework.renderData('JSON', obj.queryToArray(result));
    }

    function getSupplierBility(struct data) {
        var obj = createObject("component","api/general");
        var result = companyService.getBilitySupplier(data); 
        VARIABLES.framework.renderData('JSON', obj.queryToArray(result));
    }

    function getOrderData(struct data) {
        var obj = createObject("component","api/general");
        var result = purchase_orderService.getEvaluationOrder(data); 
        VARIABLES.framework.renderData('JSON', obj.queryToArray(result));
    }

    function getEvaluationReport(struct data) {
        var obj = createObject("component","api/general");
        var result = inspection_reportService.getEvaluations(data); 
        VARIABLES.framework.renderData('JSON', obj.queryToArray(result));
    }

    function getDetailReport(struct data) {
        var obj = createObject("component","api/general");
        var result = inspection_reportService.getEvaluations(data); 
        VARIABLES.framework.renderData('JSON', obj.queryToArray(result));
    }

    function getEvaluationChart(struct data) {
        
    }

    function order() {
        var info = deserializeJSON(GetHttpRequestData().content);
        switch(info.key) { 
            case "perSupplier": 
                    getPerSupplierOrder(info);
                    break; 
            case "supplierBility": 
                    getSupplierBility(info); 
                    break; 
            case "orderData":
                    getOrderData(info);
                    break;     
        } 
    }

    function inspection() {
        var info = deserializeJSON(GetHttpRequestData().content);
        switch(info.key) { 
            case "evaluationReport": 
                    getEvaluationReport(info);
                    break; 
            case "detailReport": 
                    getDetailReport(info); 
                    break; 
            case "evaluationChart":
                    getEvaluationChart(info);
                    break;     
        } 
    }
}