/**
*
* @file  /E/Projects/zwilling_v2/model/services/contact.cfc
* @author  dieu.le
* @description contactService
*
*/

component {

	public function init(){
		return this;
	}

	function getListCompanyNo(){
		var company = QueryExecute("SELECT  gildemeisterid,
											name
									FROM company
									where active = 1 ");
		return company;
	}
}