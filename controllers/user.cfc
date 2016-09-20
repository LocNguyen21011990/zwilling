component accessors=true {

    property framework;
    property userService;
    public function init(required any fw){
        var user     = new api.general();
        variables.fw = arguments.fw;
        return this;
    }
    public function login() {
        if(cgi.request_method == 'POST'){ 
            var obj = createObject("component","api/general");
            var info = DeserializeJSON(GetHttpRequestData().content);
            var message = "The username or password is incorrect";
            var success = false;
            var check = userService.getUserLogin(info.user_name, info.user_password);
            if( !isEmpty(check) )
            {
                var entity = entityLoad( "user", check.id_user, true );
                entity.setLast_login(now());
                var token = left(hash(createUUID()),15);
                newSession = entityNew("session");
                newSession.setToken(token);
                newSession.setLang(info.lang);
                newSession.setCreated_time( now() );
                newSession.setUpdated_time( now() );
                newSession.setUser(entity);
                entitySave(newSession);
                success = true;
                message = "";
            }
            if(success){
                var menus = obj.checkToken(token, 0); 
                var parentArray = []; 
                for(item in menus.data.access){
                    if(item.view == 1){
                        arrayAppend(parentArray, item);
                    }
                }
                menus.data.access = parentArray;
                if(ArrayLen(parentArray) <= 0){
                    message = "Your access denied";
                    success = false;
                    VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
                }else{
                    VARIABLES.framework.renderData('JSON', menus);
                }
                
            }else{
                VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
            }
        }   
    }

    function logout() {
        var entitySession = entityLoad("session",{token = GetHttpRequestData().headers.Authorization},true);
        entityDelete(entitySession);
        success = true;
        message = "Logout success";
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    function getlistUser(string token) { 
        var obj = createObject("component","api/general");
        var checkAccess = obj.checkToken(token, obj.getIdPage(CGI.path_info));
        var message = checkAccess.data;
        var success = false;
        var access = [];
        var listUser = [];
        if(checkAccess.success){
            access = checkAccess.data.access; 
            var listUser = obj.queryToArray(userService.getListUser());
            variables.framework.renderData('JSON', {'access': access, 'users': listUser});
        }else{
            variables.framework.renderData('JSON', {'success': success, 'message': message});
        }  
    }

    function addUser(string data) {
        var flag = false;
        var success = false;
        var obj = createObject("component","api/general");
        var checkAccess = obj.checkToken(GetHttpRequestData().headers.Authorization, obj.getIdPage(CGI.path_info));
        var message = checkAccess.data;
        if(checkAccess.success){
            var info = deserializeJSON(data);
            var reg = REMatch("^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)(?=.*[~$@!^&%*<>\\+_=:;,.?()\[\]##]+.*)[0-9a-zA-Z~$@!^&%*<>\\+_=:;,.?()\[\]##]{6,}$", info.user_password);
            if(ArrayLen(reg) <= 0){
                message = "Password must have at least one number, one letter, one special character and more than 6 digits";
            }else{
                var checkExistUserName = userService.getUserFormUserName(info.user_name, 0);
                if(isEmpty(checkExistUserName)){
                    var checkExistEmail = userService.getUserFormEmail(info.email, 0);
                    if(isEmpty(checkExistEmail))
                        flag = true;
                    else
                        message = "This is email exist";
                }else{
                    message = "This is user name exist";
                }
                if(flag){
                    var entity = entityNew('user');
                    entity.setFirst_name(info.first_name);
                    entity.setUser_name(info.user_name);
                    //entity.setUser_password(hash(info.user_password));
                    var id_role = arrayToList(info.id_role, ',');
                    entity.setId_role(id_role);
                    entity.setCompanyid(info.companyid);
                    entity.setEmail(info.email);
                    entity.setUser_type(info.user_type);
                    entity.setIs_active(info.is_active);
                    entitySave(entity);
                    success = true;
                    message = "Insert data success";
                    var token = left(hash(createUUID()),15);
                    var configMail = {};
                    configMail.mailFrom="quangkhaikg@gmail.com";
                    configMail.name=info.first_name;
                    configMail.title="Please click ";
                    configMail.mailTo=info.email;
                    configMail.mailSubject="Zwilling - forgot password for you";
                    configMail.mailContent=CGI.http_host&"/index.cfm/user.reset-Password?token="&token;
                    var mail = obj.sendMail(configMail);
                    if(mail){
                        entity = entityLoad("user", check.id_user, true);
                        entity.setLast_login(now());
                        entity.setToken(token);
                        success = true;
                        message = "We are send link forgot password for you, check mail please";
                    }
                    if(arrayLen(info.avatar) > 0)
                        uploadAvatar(info.avatar, entity.getId_user());
                }
            }
        }
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    function editUser(string data) {
        var flag = false;
        var success = false;
        var obj = createObject("component","api/general");
        var checkAccess = obj.checkToken(GetHttpRequestData().headers.Authorization, obj.getIdPage(CGI.path_info));
        var message = checkAccess.data;
        if(checkAccess.success){
            var info = deserializeJSON(data);
            var checkPass = userService.getUserPass(info.user_password, info.id_user);
            if(isEmpty(checkPass)){
                var reg = REMatch("^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)(?=.*[~$@!^&%*<>\\+_=:;,.?()\[\]##]+.*)[0-9a-zA-Z~$@!^&%*<>\\+_=:;,.?()\[\]##]{6,}$", info.user_password);
                if(ArrayLen(reg) <= 0)
                    message = "Password must have at least one number, one letter, one special character and more than 6 digits";
                else
                    flag = true;    
            }
            if(flag){
                var checkExistUserName = userService.getUserFormUserName(info.user_name, info.id_user);
                if(isEmpty(checkExistUserName)){
                    var checkExistEmail = userService.getUserFormEmail(info.email, info.id_user);
                    if(!isEmpty(checkExistEmail)){
                        message = "This is email exist";
                        flag = false;
                    } 
                }else{
                    message = "This is user name exist";
                    flag = false;
                }
            }
            if(flag){
                var entity = entityLoad( "user", info.id_user, true );
                entity.setFirst_name(info.first_name);
                entity.setUser_name(info.user_name);
                if(isEmpty(checkPass))
                    entity.setUser_password(hash(info.user_password));
                var id_role = arrayToList(info.id_role, ',');
                entity.setId_role(id_role);
                entity.setCompanyid(info.companyid);
                entity.setEmail(info.email);
                entity.setUser_type(info.user_type);
                entity.setIs_active(info.is_active);
                entitySave(entity);
                success = true;
                message = "Update data success";
                if(arrayLen(info.avatar) > 0)
                    uploadAvatar(info.avatar, info.id_user);
            }  
        }
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    function deleteUser(string token, numeric id_user) {
        var obj = createObject("component","api/general");
        var accessCheck = obj.checkToken(token, obj.getIdPage(CGI.path_info));
        var message = "Not Access this page"; 
        var success = false;
        if(accessCheck.data.access.delete == 1){ 
            entity = entityLoad( "user", id_user, true );
            entityDelete( entity );
            success = true;
            message = "Delete data success!";
        }
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    } 

    function getUserById(numeric id_user) {
        var obj = createObject("component","api/general");
        var checkAccess = obj.checkToken(GetHttpRequestData().headers.Authorization, obj.getIdPage(CGI.path_info));
        var message = checkAccess.data;
        var success = false;
        if(checkAccess.success){
            var user = obj.queryToObject(userService.getUserByUserId(id_user));
            user.id_role = listToArray(user.id_role, ',');
            variables.framework.renderData('JSON', user);
        }else{
            variables.framework.renderData('JSON', {'success': success, 'message': message});
        }
    }

    function getUserInspector(string user_type) {
        var obj = createObject("component","api/general"); 
        sql = "select * from user where user_type = :userType And is_active=1 order by first_name asc";
        VARIABLES.framework.renderData('JSON', obj.queryToArray(queryExecute(sql, {userType:user_type})));
    }

    function uploadAvatar(array data, numeric id_user){
        //var data = deserializeJSON(GetHttpRequestData().content);
        var api     = new api.general();
        var valid   = api.validMimeTypes();
        var message = "Your file upload invalid, please try again!";
        var success = false;
        try {
                var arrayFilename = [];
                for(var i =1; i<=arrayLen(data); i++){
                    var imageName = data[i].filename;
                    var imagePath = "/fileUpload/user/"; 
                    var entity_user = entityLoad("user", id_user, true);
                    var rootpath        = expandPath("/");
                    if(!IsEmpty(entity_user.getAvatar())){
                        var pathDocument = rootpath&entity_user.getAvatar();
                        if(fileExists(pathDocument)){
                            FileDelete(pathDocument);
                        }
                    }
                    file action="write" file="#expandPath(imagePath)#/#imageName#" output="#toBinary(data[i].base64)#" addnewline="false" mode="777" accept="#structKeyList(valid)#"; 
                    var fileName  = data[i].filename;
                    entity_user.setAvatar(imagePath&fileName);
                }
                success = true;   
                message = "Upload avatar success";
        }
        catch(any e) {
            message = e.message;
        } 
        return { 'success':success, 'message':message};
    }

    function getRole() {
        var obj = createObject("component","api/general");
        var roles = obj.queryToArray(userService.getListRole());
        variables.framework.renderData('JSON', roles);
    }

    function getLang() {
        var obj = createObject("component","api/general");
        var langs = obj.queryToArray(userService.getListLang());
        variables.framework.renderData('JSON', langs);
    }

    function forgotUser() {
        if(cgi.request_method == 'post'){
            var message = "Your email is incorrect or account unactive";
            var success = false;
            /*{"email": email} */
            var info = deserializeJSON(GetHttpRequestData().content); 
            var check = userService.getUserFormEmail(info.email, 0);
            if( !isEmpty(check) )
            {
                var obj = createObject("component","api/general");
                var token = left(hash(createUUID()),15);
                var configMail = {};
                configMail.mailFrom="quangkhaikg@gmail.com";
                configMail.name=check.first_name;
                configMail.title="Please click ";
                configMail.mailTo=check.email;
                configMail.mailSubject="Zwilling - forgot password for you";
                configMail.mailContent=CGI.http_host&"/##/reset-password?token="&token;
                var mail = obj.sendMail(configMail);
                if(mail){
                    entity = entityLoad("user", check.id_user, true);
                    entity.setLast_login(now());
                    entity.setToken(token);
                    success = true;
                    message = "We are send link forgot password for you, check mail please";
                }
            } 
            VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});  
        }
    }
    
    function resetPassword() {
        if(cgi.request_method == 'put'){
            var message = "Link expired";
            var success = false;
            var timeOut = -24;
            var timeType= "h" ;//hour
            var dateLimit = dateAdd(timeType, timeOut, now());
            var info = deserializeJSON(GetHttpRequestData().content);
            //var dateLimit = DateFormat(timeOfdead, 'yyyy-mm-dd')&" "&TimeFormat(timeOfdead, 'HH:mm:ss');
            var user = userService.getUserByToken(info.token, dateLimit);
            if( !isEmpty(user) )
            {
                var reg = REMatch("^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)(?=.*[~$@!^&%*<>\\+_=:;,.?()\[\]##]+.*)[0-9a-zA-Z~$@!^&%*<>\\+_=:;,.?()\[\]##]{6,}$", info.user_password);
                if(ArrayLen(reg) <= 0){
                    message = "Password must have at least one number, one letter, one special character and more than 6 digits";
                }else{
                    var entity = entityLoad("user", {token = info.token}, true);
                    entity.setUser_password(hash(info.user_password));
                    entity.setToken("");
                    success = true;
                    message = "Update data success";
                }
            }
            VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
        }
    }

    // function checkForGotPass() {
    //     var message = "Link expired";
    //     var success = false;
    //     var timeOut = -24;
    //     var timeType= "h" ;//hour
    //     var dateLimit = dateAdd(timeType, timeOut, now());
    //     //var dateLimit = DateFormat(timeOfdead, 'yyyy-mm-dd')&" "&TimeFormat(timeOfdead, 'HH:mm:ss');
    //     var user = userService.getUserByToken(URL.token, dateLimit);
    //     if( !isEmpty(user) )
    //     {
    //         success = true; 
    //         message = "valid token";
    //     }
    //     VARIABLES.framework.renderData('JSON', {'success': success, 'message': message}); 
    // }
    
    function execute() {

        switch(cgi.request_method) { 
            case "PUT": 
                    editUser(GetHttpRequestData().content); 
                    break; 
            case "POST": 
                addUser(GetHttpRequestData().content);
                break; 
            case "DELETE":
                if(StructKeyExists(URL, 'id')){
                    deleteUser(GetHttpRequestData().headers.Authorization, URL.id);
                    break; 
                }
            case "GET": 
                if(StructKeyExists(URL, 'id')){
                    getUserById(URL.id);
                    break;
                }else if(StructKeyExists(URL, 'user_type')){
                    getUserInspector(URL.user_type); 
                    break;
                }
                getlistUser(GetHttpRequestData().headers.Authorization); 
                break;         
        } //end switch
    }
}