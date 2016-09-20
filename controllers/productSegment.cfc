component accessors=true {

	property framework;
	property product_segmentService;
    property product_segment_documentService;

	function getProductSegmentList() {
		var obj = createObject("component","api/general");
        VARIABLES.framework.renderData('JSON', obj.queryToArray(product_segmentService.getListProductSegment()));
    }

    function getProductSegmentById(numeric id) {
        var obj = createObject("component","api/general");
        var productSeg = obj.queryToObject(product_segmentService.getProductSegmentById(id));
        var psdArr = obj.queryToArray(product_segment_documentService.getProductSegmentByPSId(URL.id));
        productSeg.document = psdArr;
        VARIABLES.framework.renderData('JSON', productSeg);
    }

    function addProductSegment(string data) {
        var success = false;
        var message = "Insert data fail.";
        var info = deserializeJSON(data);
        var update_date = now();
        var new_productSegment = entityNew('product_segment'); 
        new_productSegment.setProduct_segment_name_english(info.product_segment_name_english);
        new_productSegment.setProduct_segment_name_german(info.product_segment_name_german);
        new_productSegment.setLastupdate(update_date);
        new_productSegment.setUpdateby(info.updateby);
        entitySave(new_productSegment);
        var id = new_productSegment.getProduct_segment_id();
        if(structKeyExists(info, "documentSegment"))
        {
            for(item in info.documentSegment){ 
                var psDocument = entityLoad("product_segment_document", item, true);
                psDocument.setProduct_segment_id(id);
            }
        }
        var success = true;
        var message = "Insert data success.";
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message, 'product_segment_id': id});
    }
    
    function editProductSegment(string data) {
        var success = false;
        var message = "Update data fail.";
        var info = deserializeJSON(data);
        var update_date = now();
        var productSegment = entityLoad('product_segment', info.product_segment_id, true); 
        productSegment.setProduct_segment_name_english(info.product_segment_name_english);
        productSegment.setProduct_segment_name_german(info.product_segment_name_german);
        productSegment.setLastupdate(update_date);
        productSegment.setUpdateby(info.updateby);
        if(structKeyExists(info, "documentSegment"))
        {
            for(item in info.documentSegment){ 
                var psDocument = entityLoad("product_segment_document", item, true);
                psDocument.setProduct_segment_id(info.product_segment_id);
            }
        }
        var success = true;
        var message = "Update data success.";
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }
    
	function execute() {

        switch(cgi.request_method) { 
            case "put": 
                    editProductSegment(GetHttpRequestData().content);
                    break; 
            case "post": 
                    addProductSegment(GetHttpRequestData().content); 
                    break; 
            case "delete":
                if(StructKeyExists(URL, 'id')){
                    //deleteAccess(GetHttpRequestData().headers.token, URL.id);
                    break; 
                }
            case "get": 
                if(StructKeyExists(URL, 'id')){
                    getProductSegmentById(URL.id);
                    break;
                }
                getProductSegmentList();
                break;          
        } //end switch
    }
}