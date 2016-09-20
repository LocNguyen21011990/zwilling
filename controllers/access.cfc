component accessors=true {

    property framework;
    property accessService;

    public function listPage() {
        var obj = createObject("component","api/general");
        var listPages = obj.queryToArray(accessService.getListPage());
        VARIABLES.framework.renderData('JSON', listPages);
    }

    public function addAccess(string token, string data) {
        var obj = createObject("component","api/general");
        var accessCheck = obj.checkToken(token, obj.getIdPage(CGI.path_info));
        var message = "Not Access this page"; 
        var success = false;
        if(accessCheck.data.access.add == 1){
                /*{id_role:1, id_page:2, view:1, 
                                edit:0, add:0, delete: 0} */
                var info = deserializeJSON(data);
                id_role = entityLoadByPK('role', info.id_role);
                id_page = entityLoadByPK('access_page', info.id_page);
                var entity = entityNew('access');
                entity.setRole(id_role);
                entity.setAccess_page(id_page);
                entity.setView(info.view);
                entity.setEdit(info.edit);
                entity.setAdd(info.add);
                entity.setDelete(info.delete);
                entitySave(entity);
                success = true;
                message = "Insert data success!";
        }
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    public function editAccess(string token, string data) {
        var obj = createObject("component","api/general");
        var accessCheck = obj.checkToken(token, obj.getIdPage(CGI.path_info));
        if(accessCheck.data.access.edit == 1){
            /*{id_role:1, id_page:2, view:1, id_access:4,
                                edit:1, add:1, delete: 1} */
            var info = deserializeJSON(data);
            entity = entityLoad( "access", info.id_access, true );
            id_role = entityLoadByPK('role', info.id_role);
            id_page = entityLoadByPK('access_page', info.id_page);
            entity.setRole(id_role);
            entity.setAccess_page(id_page);
            entity.setView(info.view);
            entity.setEdit(info.edit);
            entity.setAdd(info.add);
            entity.setDelete(info.delete);
            success = true;
            message = "Update data success!";
        }else{
            message = "Not Access this page"; 
            success = false;
        }
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    public function deleteAccess(string token, numeric id_access) {
        var obj = createObject("component","api/general");
        var accessCheck = obj.checkToken(token, obj.getIdPage(CGI.path_info));
        if(accessCheck.data.access.delete == 1){
            entity = entityLoad( "access", id_access, true );
            entityDelete( entity );
            success = true;
            message = "Delete data success!";
        }else{
            message = "Not Access this page"; 
            success = false; 
        }
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    } 

    function getAccessById(numeric id_access) {
        var obj = createObject("component","api/general");
        var sqlAccess = "select * from access where id_access = :idAccess";
        var queryAccess = queryExecute(sqlAccess, {idAccess:id_access});
        VARIABLES.framework.renderData('JSON', obj.queryToObject(queryAccess));
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
                listAccess(GetHttpRequestData().headers.token); 
                break;          
        } //end switch
    }
 
}