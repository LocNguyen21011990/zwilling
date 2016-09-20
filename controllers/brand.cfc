component accessors=true {

	property framework;
    property brandService;
    
    function getBrandById(numeric id) {
        var obj = createObject("component","api/general");
        VARIABLES.framework.renderData('JSON', obj.queryToObject(brandService.getBrandById(id)));
    }

    function getBrandList() {
        var obj = createObject("component","api/general");
        VARIABLES.framework.renderData('JSON', obj.queryToArray(brandService.getBrands()));
    }

    function addBrand(string data) {
        var success = false;
        var message = "Insert data fail.";
        var info = deserializeJSON(data);
        var update_date = now();
        
        var new_brand = entityNew('brand');
        new_brand.setBrandname(info.brandname);
        new_brand.setDescription(info.description);
        new_brand.setLastupdate(update_date);
        new_brand.setUpdateby(info.updateby);
        entitySave(new_brand);
        success = true;
        message = "Insert data success.";
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    function editBrand(string data) {
        var success = false;
        var message = "Update data fail.";
        var info = deserializeJSON(data);
        var update_date = now();
        
        var brand = entityLoad('brand', info.brandid, true);
        brand.setBrandname(info.brandname);
        brand.setDescription(info.description);
        brand.setLastupdate(update_date);
        brand.setUpdateby(info.updateby);
        success = true;
        message = "Update data success.";
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }
    
    function execute() {

        switch(cgi.request_method) { 
            case "put": 
                    editBrand(GetHttpRequestData().content);
                    break; 
            case "post": 
                    addBrand(GetHttpRequestData().content); 
                    break; 
            case "delete":
                if(StructKeyExists(URL, 'id')){
                    //deleteAccess(GetHttpRequestData().headers.token, URL.id);
                    break; 
                }
            case "get": 
                if(StructKeyExists(URL, 'id')){
                    getBrandById(URL.id);
                    break;
                }
                getBrandList();
                break;          
        } //end switch
    }
}