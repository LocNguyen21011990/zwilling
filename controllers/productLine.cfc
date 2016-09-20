component accessors=true {

	property framework;
    property product_lineService;
    property product_segmentService;
    property brandService;
    property qlService;
    
    function getProductLineById(string product_line_no) {
        var obj = createObject("component","api/general");
        result = obj.queryToObject(product_lineService.getProductLineById(product_line_no));
        VARIABLES.framework.renderData('JSON', result);
    }

    function getProductLineList() {
        var obj = createObject("component","api/general");
        result = obj.queryToArray(product_lineService.getProductLines());
        VARIABLES.framework.renderData('JSON', result);
    }
    

    function addProductLine(string data) {
        var success = false;
        var message = "Insert data fail.";
        var info = deserializeJSON(data);
        var update_date = now();
        if(product_lineService.getProductLineById(info.product_line_no).recordCount > 0){
            message="The Product line number is existed already!";
        }else{
            var new_productLine = entityNew('product_line');
            new_productLine.setProduct_line_no(info.product_line_no);
            new_productLine.setProduct_line_name_english(info.product_line_name_english);
            new_productLine.setProduct_line_name_german(info.product_line_name_german);
            new_productLine.setLastupdate(update_date);
            new_productLine.setUpdateby(info.updateby);
            new_productLine.setProduct_segment_id(info.product_segment_id);
            new_productLine.setQl(info.ql);
            new_productLine.setBrandid(info.brandid);
            entitySave(new_productLine);
            success = true;
            message = "Insert data success.";
        }
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    function editProductItem(string data) {
        var success = false;
        var message = "Update data fail.";
        var info = deserializeJSON(data);
        var update_date = now();
        
        var productLine = entityLoad('product_line', {product_line_no=info.product_line_no}, true);
        productLine.setProduct_line_name_english(info.product_line_name_english);
        productLine.setProduct_line_name_german(info.product_line_name_german);
        productLine.setLastupdate(update_date);
        productLine.setUpdateby(info.updateby);
        productLine.setProduct_segment_id(info.product_segment_id);
        productLine.setQl(info.ql);
        productLine.setBrandid(info.brandid);
        success = true;
        message = "Update data success.";
       
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    function getBrands() {
        var obj = createObject("component","api/general");
        VARIABLES.framework.renderData('JSON', obj.queryToArray(brandService.getBrands()));
    }

    function getProductSegments() {
        var obj = createObject("component","api/general");
        VARIABLES.framework.renderData('JSON', obj.queryToArray(product_segmentService.getListProductSegment()));
    }

    function getQls() {
        var obj = createObject("component","api/general");
        VARIABLES.framework.renderData('JSON', obj.queryToArray(qlService.getQlList()));
    }
    
    function execute() {

        switch(cgi.request_method) { 
            case "put": 
                    editProductItem(GetHttpRequestData().content);
                    break; 
            case "post": 
                addProductLine(GetHttpRequestData().content); 
                break; 
            case "delete":
                if(StructKeyExists(URL, 'id')){
                    //deleteAccess(GetHttpRequestData().headers.token, URL.id);
                    break; 
                }
            case "get": 
                if(StructKeyExists(URL, 'id')){
                    getProductLineById(URL.id);
                    break;
                }
                getProductLineList();
                break;          
        } //end switch
    }
}