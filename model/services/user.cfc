component {

	function getUserLogin(string username, string password ) {
		var sql = "select * from user where user_name = :username and user_password = :userpassword and is_active=1";
		return queryExecute(sql, {username:username, userpassword:hash(password)});
	}
	
	function getListUser() {
		var sql = "select user.user_name, user.id_user, user.first_name as displayname, 
					user.email, user.is_active, user.id_role 
					from user";
		return queryExecute(sql);
	}
	
	function getUserFormEmail(string email, numeric id_user) {
		var paramset = {};
		var sql = "select * from user where email = :emailInput and is_active=1";
		if(id_user != 0){
			sql &= " and id_user != :idUser";
			paramset['idUser'] = {value=id_user, CFSQLType="integer"};
		}
		paramset['emailInput'] = {value=email, CFSQLType="string"};
		return queryExecute(sql, paramset); 
	}

	function getUserFormUserName(string user_name, numeric id_user) {
		var paramset = {};
		var sql = "select * from user where user_name = :user_name and is_active=1";
		if(id_user != 0){
			sql &= " and id_user != :idUser";
			paramset['idUser'] = {value=id_user, CFSQLType="integer"};
		}
		paramset['user_name'] = {value=user_name, CFSQLType="string"};
		return queryExecute(sql, paramset); 
	}

	function getUserPass(string user_password, numeric id_user) {
		var paramset = {};
		var sql = "select user_password from user where id_user=:idUser And user_password=:userPass And is_active=1";
		paramset['idUser'] = {value=id_user, CFSQLType="integer"};
		paramset['userPass'] = {value=user_password, CFSQLType="string"};
		return queryExecute(sql, paramset); 
	}

	function getTokenByUserId(string token) {
		var paramset = {};
		var sql = "select * from session where token = :tokenUser";
		paramset['tokenUser'] = {value=token, CFSQLType="string"};
		return queryExecute(sql, paramset); 
	}

	function getUserByUserId(numeric id_user) {
		var paramset = {};
		var sql = "select * from user where id_user = :id_user";
		paramset['id_user'] = {value=id_user, CFSQLType="integer"};
		return queryExecute(sql, paramset); 
	}

	function getUserByToken(string token, string date_limit) {
		var paramset = {};
		var sql = "select * from user where token = :token and last_login >= :date_limit";
		paramset['token'] = {value=token, CFSQLType="string"};
		paramset['date_limit'] = {value=date_limit, CFSQLType="timestamp"};
		return queryExecute(sql, paramset); 
	}
	
	function getListRole() {
		var sql = "select * from role";
		return queryExecute(sql); 
	}

	function getListLang() {
		var sql = "select language_name, languagecol from language where active = 1";
		return queryExecute(sql); 
	}

	function getRoleById(numeric id_role) {
		var paramset = {};
		var sql = "select * from role where id_role = :id_role";
		paramset['id_role'] = {value=id_role, CFSQLType="integer"};
		return queryExecute(sql, paramset); 
	}

	function getRoleByIds(string id_role) {
		var sql = "select GROUP_CONCAT(role_name) as role_name from role where id_role in ("&id_role&")";
		return queryExecute(sql); 
	}
}