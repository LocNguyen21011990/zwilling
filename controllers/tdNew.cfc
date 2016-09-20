component accessors=true {

	property framework;
    property td_newService;

    function getTdNewByProductItemNo(string ProductItemNo) {
        var obj = createObject("component","api/general");
        sql = "select * from td_new where product_item_no = :productItemNo";
        paramset['productItemNo'] = {value=ProductItemNo, CFSQLType="string"};
        VARIABLES.framework.renderData('JSON', obj.queryToObject(queryExecute(sql, paramset)));
    }
    
    function execute() {

        switch(cgi.request_method) { 
            case "put": 
                    //editOrder(GetHttpRequestData().content); 
                    break; 
            case "post": 
                //saveInspection(GetHttpRequestData().content);
                break; 
            case "delete":
                if(StructKeyExists(URL, 'id')){
                    //deleteAccess(GetHttpRequestData().headers.token, URL.id);
                    break; 
                }
            case "get": 
                if(StructKeyExists(URL, 'id')){
                    getTdNewByProductItemNo(URL.id);
                    break;
                }
                //oSearch(); 
                break;        
        } //end switch
    }
        
}
