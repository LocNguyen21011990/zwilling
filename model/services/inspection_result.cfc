/**
*
* @file  /C/railo/webapps/zwilling/model/services/inspection_report.cfc
* @author  
* @description
*
*/

component output="false" {

	public function init(){
		return this;
	}
	 
	function getInspectionResultList() {
		inspection_result = "SELECT * FROM inspection_result";
		return queryExecute(inspection_result);
	}

}