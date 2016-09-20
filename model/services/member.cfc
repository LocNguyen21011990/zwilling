/**
*
* @file  /C/railo/webapps/zwilling/model/services/member.cfc
* @author  
* @description
*
*/

component output="false" displayname=""  {

	public function init(){
		return this;
	}
	property helperService;


	public any function getListInspector() {
		return queryToArray(queryExecute(
			'SELECT m.memberid as id,m.full_name as value 
			FROM member m LEFT JOIN account acc ON acc.memberid = m.memberid 
			WHERE acc.user_groupid = 3 or acc.user_groupid=4'));
	}

	public function queryToArray(required query inQuery) {
		result = arrayNew(1);
		for(row in inQuery) {
			item = {};
			for(col in queryColumnArray(inQuery)) {
				item[col] = row[col];
			} 
			arrayAppend(result, item);
		}
		return result;
    }
	
	
}