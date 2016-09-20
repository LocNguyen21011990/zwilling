component accessors="true"  {

	property product_item_documentService;
	property product_itemService;
	property product_segmentService;
	property product_segment_documentService;
	property document_itemService;
	property framework;
	public function init(required any fw){
		variables.fw = arguments.fw;
		return this;
	}

	function getDocumentTypeList() {
		var obj = createObject("component","api/general");
		var data = obj.queryToArray(document_itemService.getListDocumentType());
		variables.framework.renderData('JSON', data);
	}
	
	function updateDocument(string data) {
		var success = false;
        var message = "Update data fail.";
		var info = deserializeJSON(data);
		var product = document_itemService.getDocumentTypeByCode(info.code);
		if(product.typeId eq 1){
			for(product_document_id in info.documentId){
                var entity_product_document = entityLoad( "product_item_document", product_document_id, true );
                entity_product_document.setProduct_item_no(info.productId);
                entity_product_document.setFileName(info.documentName);
            }
		}
		if(product.typeId eq 2){
			for(item in info.documentId){ 
                var psDocument = entityLoad("product_segment_document", item, true);
                psDocument.setProduct_segment_id(info.productId);
                psDocument.setFileName(info.documentName);
            }
		}
		success = true;
        message = "Update data success";
		VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
	}
	
	function getListDocument() {
		var obj = createObject("component","api/general");
		var data = [];
		var product = document_itemService.getDocumentTypeByCode(URL.codes);
		if(product.typeId eq 1)
			data = obj.queryToArray(product_item_documentService.getItemDocument(codes));
		if(product.typeId eq 2)
			data = obj.queryToArray(product_segment_documentService.getSegmentDocument(codes));
		variables.framework.renderData('JSON', data);
	}
	
	function getDocumentById(numeric id, numeric type) {
		var obj = createObject("component","api/general");
		var data = [];
		if(type eq 1){  
			data = obj.queryToObject(product_item_documentService.getItemDocumentById(id));
		}	
		if(type eq 2){
			data = obj.queryToArray(product_segment_documentService.getSegmentDocumentById(id));
		}
		variables.framework.renderData('JSON', {'data': data});
	}

	function getProduct() { 
        var obj = createObject("component","api/general");
        var data = [];
        var product = document_itemService.getDocumentTypeByCode(URL.code);
        if(product.typeId eq 1){
        	var items = obj.queryToArray(product_itemService.getProductItemList());
        	for(item in items){
	            var productItemStruct = {};
	            productItemStruct.value = item.product_item_no;
	            productItemStruct.label = item.product_item_no&"::"&item.product_item_name_english;
	            arrayAppend(data, productItemStruct);
	        }
        }
        if(product.typeId eq 2){
        	var segs = obj.queryToArray(product_segmentService.getListProductSegment());
        	for(item in segs){
	            var productSegStruct = {};
	            productSegStruct.value = item.product_segment_id;
	            productSegStruct.label = item.product_segment_id&"::"&item.product_segment_name_english;
	            arrayAppend(data, productSegStruct);
	        }
        }  
        VARIABLES.framework.renderData('JSON', data);
    }
	
	function execute(){
		switch(cgi.request_method){
			case "POST":
				//updateProductItemNo(GetHttpRequestData().content);
			break;
			case "PUT":
				updateDocument(GetHttpRequestData().content);
				break;
			case "GET":
				if(StructKeyExists(URL, 'code')){
                    getProduct(URL.code);
                    break;
                }
                if(StructKeyExists(URL, 'id') && StructKeyExists(URL, 'docType')){
                    getDocumentById(URL.id, URL.docType);
                    break;
                }
                if(StructKeyExists(URL, 'codes')){
                    getListDocument(URL.codes);
                    break;
                }
            getDocumentTypeList();
            break;
		}
	}

}