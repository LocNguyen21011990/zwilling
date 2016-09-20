component accessors=true {

	property framework;
    property user_activityService;

    function getUserActivity() {
        var obj = createObject("component","api/general");
        var data = {};
        data.master = obj.queryToArray(user_activityService.getMasterData());
        data.order = obj.queryToArray(user_activityService.getOrderData());
        data.inspection = obj.queryToArray(user_activityService.getInspectionData());
        VARIABLES.framework.renderData('JSON', data);
    }
    
    function execute() {
        switch(cgi.request_method) { 
            case "put": 
                    //editCompany(GetHttpRequestData().content);
                    break; 
            case "post": 
                //addCompany(GetHttpRequestData().content);
                break; 
            case "delete":
                    //delCompany(URL.id);
                    break;
            case "GET":
                getUserActivity();
                break;         
        } //end switch
    }
}