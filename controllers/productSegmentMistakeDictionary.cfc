component accessors=true {

    property framework;
    property product_segment_mistake_dictionaryService;

    public function getMistakeListByProductSegmentId(numeric product_segment_id) {
        var obj = createObject("component","api/general");
        result = product_segment_mistake_dictionaryService.getMistakeList(product_segment_id);
        variables.framework.renderData('JSON', obj.queryToArray(result));
    }

    function execute() {

        switch(cgi.request_method) { 
            case "put": 
                if(StructKeyExists(URL, 'id')){
                    editAccess(GetHttpRequestData().headers.token, GetHttpRequestData().content); 
                    break; 
                }
            case "post": 
                addAccess(GetHttpRequestData().headers.token, GetHttpRequestData().content);
                break; 
            case "delete":
                if(StructKeyExists(URL, 'id')){
                    deleteAccess(GetHttpRequestData().headers.token, URL.id);
                    break; 
                }
            case "get": 
                if(StructKeyExists(URL, 'id')){
                    getAccessById(URL.id);
                    break;
                }
                if(StructKeyExists(URL, 'product_segment_id')){
                    getMistakeListByProductSegmentId(URL.product_segment_id);
                    break;
                }
                //getMistakeList(URL.); 
                break;          
        } //end switch
    }
 
}