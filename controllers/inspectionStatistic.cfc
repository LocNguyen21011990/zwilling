component accessors=true {

    property framework;
    property inspection_statisticService;

    function getInspectStatic() { 
        var obj = createObject("component","api/general");
        var inspectStatics = obj.queryToArray(inspection_statisticService.getInspectionStatic());
        variables.framework.renderData('JSON', inspectStatics);  
    }

    function execute() {

        switch(cgi.request_method) { 
            case "PUT": 
                    //editUser(GetHttpRequestData().content); 
                    break; 
            case "POST": 
                    getInspectStatic();
                    break; 
            case "DELETE":
                if(StructKeyExists(URL, 'id')){
                    //deleteUser(GetHttpRequestData().headers.Authorization, URL.id);
                    break; 
                }
            case "GET": 
                //getInspectStatic(); 
                break;         
        } //end switch
    }
}