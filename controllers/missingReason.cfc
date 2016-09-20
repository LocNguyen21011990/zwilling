component accessors=true {

	property framework;
	property missing_reasonService;

    function getListMissingReason() {
        var obj = createObject("component","api/general");
        data = missing_reasonService.getMissingReason();
        VARIABLES.framework.renderData('JSON', obj.queryToArray(data));
    }

    function execute() {

        switch(cgi.request_method) { 
            case "put": 
                if(StructKeyExists(URL, 'id')){
                    //editOrder(GetHttpRequestData().content); 
                    break; 
                }
            case "post": 
                //saveOrder(GetHttpRequestData().content);
                break; 
            case "delete":
                if(StructKeyExists(URL, 'id')){
                    //deleteAccess(GetHttpRequestData().headers.token, URL.id);
                    break; 
                }
            case "get": 
                if(StructKeyExists(URL, 'schab') and StructKeyExists(URL, 'itemno')){
                    //getInspectionScheduleInput(URL.schab, URL.itemno);
                    break;
                }
                getListMissingReason(); 
                break;             
        } //end switch
    }
        
}
