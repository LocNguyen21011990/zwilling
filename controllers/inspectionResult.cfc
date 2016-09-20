component accessors=true {

	property framework;
	property inspection_resultService;

   
    
    function getInspectionResult() {
        var obj = createObject("component","api/general");
        var data = inspection_resultService.getInspectionResultList();
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
                if(StructKeyExists(URL, 'id')){
                    //getInspectionScheduleInput(URL.schab, URL.itemno);
                    break;
                }
                getInspectionResult();
                break;
                   
        } //end switch
    }
        
}
