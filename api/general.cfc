component output="false" displayname=""  {
	property framework;

	public any function renderSlug(string text) {
		var sluglanguage = deAccent(text);
		var slugdeletesymbols = reReplace(sluglanguage, "[^a-zA-Z0-9]"," ","All") 
		var slugclearspace = Trim(reReplace(slugdeletesymbols,"\s+"," ","All"))
		var slug = reReplace(slugclearspace," ","-","All");
		return slug;
	}

	function deAccent(str){
	    //based on the approach found here: http://stackoverflow.com/a/1215117/894061
	    var Normalizer = createObject("java","java.text.Normalizer");
	    var NormalizerForm = createObject("java","java.text.Normalizer$Form");
	    var normalizedString = Normalizer.normalize(str, createObject("java","java.text.Normalizer$Form").NFD);
	    var pattern = createObject("java","java.util.regex.Pattern").compile("\p{InCombiningDiacriticalMarks}+");
	    return pattern.matcher(normalizedString).replaceAll("");
	}

	public function uploadFile(string pathDir, any fieldFile) {
		
		var filefield = FileUpload( pathDir, fieldFile );
		return filefield;
	}
	
	public function sendMail(any mail) {
		mailerService = new mail(); 
        
        /* set mail attributes using implicit setters provided */ 
        mailerService.setTo(mail.mailTo); 
        mailerService.setFrom(mail.mailFrom); 
        //mailerService.setCc("dvnfruit@gmail.com");
        mailerService.setSubject(mail.mailSubject);
        mailerService.addPart( type="html", body="
						   <html>
						       <head>
						           <style type='text/css'>
						           body { 
						           font-family:sans-serif;
						           font-size:12px;
						           color:navy;
						           }
						           </style>
						       </head>
						       <body>
                                    <h2 style='color:red'>ZWILLING J.A.HENCKELS</h2>
                                    <p>Hi #mail.name#</p>
						            <p>#mail.title#: #mail.mailContent# to reset your password.</p>					           
						       </body>
						   </html>
						");
        mailerService.setType("html"); 
        /* add mailparams */  
    
        /* send mail using send(). Attribute values specified in an end action like "send" will not persist after the action is performed */ 
        mailerService.send();         
    	return true;
	}

	public function queryToArray(required query inQuery) {
		var result = [];
        for(row in inQuery) {
            arrayAppend(result, row);
        }
        return result;
    }

    public function queryToObject(required query inQuery) {
            var item = {};
            for(row in inQuery) {
                var item = {};
                for(col in queryColumnArray(inQuery)) {
                    item[col] = row[col];
                } 
            }
        return item;
    }

	public function getIdPage(string currentUrl) {
		arrPath = listToArray(currentUrl, ".");
        slug = replace(arrPath[1], '/', '');
        sql = "select id_page from access_page where page_name=:pageName";
        
		pageQuery = queryExecute(sql, {pageName:slug});
		return pageQuery.id_page;
	}

    public function getIdUserByToken(string token) {
        var getSession = entityLoad("session",{token = token},true);
        if( isNull(getSession) ){
            return 0;
        }
        return getSession.getUser().getId_user();
    }

    public function config_user(numeric id_user ,numeric id_page, string act) {
        var conf = '{"language":"", "control":{}, "favorite":[]}';
        var getConfigUser = entityLoad("config_user", {id_user = id_user, id_page=id_page, act=act}, true);
        var data={};
        if(isNull(getConfigUser)){
            newConfigUser = entityNew('config_user');
            newConfigUser.setId_page(id_page);
            newConfigUser.setId_user(id_user);
            newConfigUser.setAct(act);
            newConfigUser.setConfig(conf);
            entitySave(newConfigUser);
            data={
                    "id_config": newConfigUser.getId_config(), 
                    "config": DeserializeJSON(conf),
                    "action": act
                }
        }else{
            data={
                    "id_config": getConfigUser.getId_config(), 
                    "config": DeserializeJSON(getConfigUser.getConfig()),
                    "action": getConfigUser.getAct()
                }
        }
        return data;
    }  

    public function save_config_user(numeric id_config, string config) { 
        config_user = entityLoad( "config_user", id_config, true );
        config_user.setConfig(config);
        return true;
    }

  //   public function save_config_user(numeric id_page, string config) {
  //    	var sql = "SELECT * FROM config_user WHERE id_page=:idPage AND id_user=:idUser";
		// var checkExist = queryExecute(sql, {idPage:id_page, idUser:Session.loginZwilling.id_user});
		// //var checkExist = queryExecute(sql, {idPage:id_page, idUser:id_user});
		
		// if(IsEmpty(checkExist)){
		// 	var entity = entityNew('config_user');
  //           entity.setId_page(id_page);
  //           entity.setId_user(Session.loginZwilling.id_user);
  //           //entity.setId_user(id_user);
  //           entity.setConfig(config);
  //           entitySave(entity);
		// }else{
		// 	entity = entityLoad( "config_user", checkExist.id_config, true );
	 //        entity.setConfig(config);
		// }
  //   }

    public function checkUseRole(numeric id_role) { 
    	var sql = "SELECT * FROM access WHERE id_role=:idRole";
    	var checkExist = queryExecute(sql, {idRole:id_role});
    	if(isEmpty(checkExist)){
            return false;
        }
    	return true;
    }
    

    // public function checkUseAccess(numeric id_access) { 
    // 	var sql = "SELECT * FROM role_access WHERE id_access=:idAccess";
    // 	var checkExist = queryExecute(sql, {idAccess:id_access});
    // 	if(isEmpty(checkExist))
    // 		return false;
    // 	else
    // 		return true;
    // }

    // public function checkUsePage(numeric id_page) { 
    // 	var sql = "SELECT * FROM role_access WHERE id_page=:idPage";
    // 	var checkExist = queryExecute(sql, {idPage:id_page});
    // 	if(isEmpty(checkExist))
    // 		return false;
    // 	else
    // 		return true;
    // }
    
       public any function validMimeTypes(param) {

          var validContentTypes = {
                                     'application/pdf': {extension: 'pdf', application: 'Adobe Acrobat'}
                                    , 'application/msword': {extension:'doc',application: 'Microsoft Word'}
                                    , 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':{extension:'docx',application: 'Microsoft Word (2007)'}
                                    , 'application/vnd.ms-excel': {extension:'xls',application: 'Microsoft Excel'}
                                    , 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': {extension:'xlsx', application:'Microsoft Excel (2007)'}
                                    , 'application/vnd.ms-powerpoint': {extension: 'ppt', application: 'PowerPoint (97-2003)'}
                                    , 'application/vnd.openxmlformats-officedocument.presentationml.presentation': {extension: 'pptx', application: 'PowerPoint (2007)'}
                                    , 'image/jpeg': {extension: 'jpg'}
                                    , 'image/png': {extension: 'png'}
                                    , 'text/plain': {extension: 'txt'}
                                }; 

           return validContentTypes;
       }

    public function checkToken(string token, numeric id_access_page) {
        var getSession = entityLoad("session",{token = token},true);
        var result = {}; 
        if( isNull(getSession) ){ 
            result["success"] = false;
            result["data"] = "Session time out!";
        }else{
            getSession.setUpdated_time(now());
            var paramset = {};
            entitySave( getSession );
            var sqlAccess = "SELECT ap.*,
                            if(sum(a.`view`) > 0, 1, 0) as 'view', 
                            if(sum(a.`edit`) > 0, 1, 0) as 'edit' , 
                            if(sum(a.`add`) > 0, 1, 0) as 'add', 
                            if(sum(a.`delete`) > 0, 1, 0) as 'delete'
                            FROM access_page ap
                            left join access a on ap.id_page = a.id_access_page and a.id_role in("&getSession.getUser().getId_role()&") 
                            where ap.show = 1";
                        if(id_access_page != 0){
                            sqlAccess &= " and ap.id_page = :id_access_page ";
                            paramset['id_access_page'] = {value=id_access_page, CFSQLType="integer"};
                        }
                        sqlAccess &= " group by ap.id_page order by ap.sort asc";
            var accessQuery = queryExecute(sqlAccess, paramset);
            var access = "";
            if(id_access_page != 0)
                access = queryToObject(accessQuery);
            else
                access = queryToArray(accessQuery);
            var user = {
                    "token": getSession.getToken(),
                    "lang" : getSession.getLang(),
                    "user_name" : getSession.getUser().getUser_name(),
                    "first_name"   : getSession.getUser().getFirst_name(),
                    "last_name"   : getSession.getUser().getLast_name(),
                    "email"       : getSession.getUser().getEmail(),
                    "id_user"     : getSession.getUser().getId_user(),
                    "access"       : access
                    }
            
            result["success"] = true;
            result["data"] = user;
        }
        return result;
    }

    public query function getRoleById( required numeric roleId) {
          
          return queryExecute(sql:"select * 
                                    from role 
                                        where id_role = :rId",
                            params:{
                                    rId:{ value = roleId, CFSQLType='NUMERIC'}
                                });
    }            
}