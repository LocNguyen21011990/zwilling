/**
*
* @file  /C/railo/webapps/zwilling/model/services/helper.cfc
* @author  
* @description
*
*/

component output="false" displayname=""  {

	public function init(){
		return this;
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