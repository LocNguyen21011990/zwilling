/**
*
* @file  /C/railo/webapps/zwilling/model/services/inspection_schedule.cfc
* @author  
* @description
*
*/

component output="false" displayname=""  {

	public function init(){
		return this;
	}

	function getMissingReason() {
		sql = "select * from missing_reason";
		return queryExecute(sql);
	}
}