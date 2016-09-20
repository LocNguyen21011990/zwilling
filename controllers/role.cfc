component accessors=true {

    property framework;
    property roleService;
    public function init(required any fw){
      
        variables.fw = arguments.fw;
        return this;
    }

    public function listRole(string Authorization) {
        var obj = createObject("component","api/general");
        var accessCheck = obj.checkToken(Authorization, obj.getIdPage(CGI.path_info));
        if(accessCheck.data.access.view == 1){
            var sql = "select * from role";
            var queryRole = queryExecute(sql);
            roles = obj.queryToArray(queryRole);
            VARIABLES.framework.renderData('JSON', {'roles':roles, 'access': accessCheck.data.access});
        }else{
            message = "Not Access this page"; 
            success = false;
            variables.framework.renderData('JSON', {'success': success, 'message': message});
        }
    }

    public function addRole(struct rc) {
        var data        = DeserializeJSON(GetHttpRequestData().content);

        var obj         = new api.general();
        var loginCheck  = obj.checkLogin(obj.getIdPage(CGI.path_info), 'add');
        if(loginCheck){
            if(cgi.request_method == 'post'){
                /*role_add = {"role_name":role_name} */
                var role = entityNew('role');
                role.setRole_name(data.role_name);
                entitySave(role);
                //variables.framework.redirect("role.listRole");
                success = true;
                message = "Insert data success";
                VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
            }
        }else{
            message = "Not Access this page"; 
            success = false;
            VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
        }
    }

    public function editRole( string Authorization ) {

        var data    = DeserializeJSON(GetHttpRequestData().content);
        var obj     = new api.general();

       var accessCheck = obj.checkToken(Authorization, obj.getIdPage(CGI.path_info));
        if(accessCheck.data.access.edit == 1){ 
            if(cgi.request_method == 'put'){
                /*role_edit = {role_name:"role_name", id_role:"id_role" } */
    
                entity = entityLoad( "role", data.id_role, true );
                entity.setRole_name(data.role_name);
                //variables.framework.redirect("role.listRole");
                success = true;
                message = "Update data success";
                VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
            }else{
                var sql = "select * from role where id_role=:idRole";
               /*  var sql = queryExecute(sql:"select * from role where id_role=:idRole",
                    params:{
                            idRole:{ value=rc.id_role, CFSQLType='NUMERIC'}
                        }); */
                queryRole = queryExecute(sql, {idRole: rc.id_role});
                role = {};
                for(item in queryRole){
                    role.id_role=item.id_role;
                    role.role_name=item.role_name;
                }
                VARIABLES.framework.renderData('JSON', {'role':role});
            }
        }else{
            message = "Not Access this page"; 
            success = false;
            VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
        }
    }

    public function deleteRole( string Authorization 
                                ,numeric id_role ) {

        var obj         = new api.general();
        var accessCheck = obj.checkToken(Authorization, obj.getIdPage(CGI.path_info));
        if(accessCheck.data.access.delete == 1){ 
            var roleExist = obj.checkUseRole(id_role);
            if(!roleExist){
                if(cgi.request_method == 'delete'){
                    entity = entityLoad( "role", id_role, true );
                    entityDelete( entity );
                    //variables.framework.redirect("role.listRole");
                    success = true;
                    message = "Delete data success";
                    VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
                }
            }else{
                success = false;
                message = "This role using by table other";
                VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
            }
        }else{
            message = "Not Access this page"; 
            success = false;
            VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
        }
    } 
    function getRoleById(numeric roleId) {
        var api        = new api.general();
        var queryRole  = api.getRoleById(roleId);
        VARIABLES.framework.renderData('JSON', api.queryToObject(queryRole));
    }
    
    public any function actionRole(struct rc) {
        
        switch(cgi.request_method){
            case "delete":
                deleteRole(GetHttpRequestData().headers.Authorization, rc.id_role);
            break;
            case "post":
                addRole();
            break;
            case "put":
                editRole(GetHttpRequestData().headers.Authorization);
            break;
            case "get":
                if(structKeyExists(URL, "id_role")){
                    getRoleById(URL.id_role);
                    break;
                }
            listRole(GetHttpRequestData().headers.Authorization);
            break;
        }
    }
    
    
}