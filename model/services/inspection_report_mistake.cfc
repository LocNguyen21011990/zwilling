component output="false" {

	public function init(){
		return this;
	}
	 
	function getInsReportMisByInspectionid(numeric inspectionid) {
        sql = "select inspection_report_mistake.*,mistake_dictionary.mistake_description_english, mistake_dictionary.characteristic  
        		from inspection_report_mistake, mistake_dictionary
 				where inspection_report_mistake.mistake_code = mistake_dictionary.mistake_code 
 				and inspectionid= :inspectionid";
        paramset['inspectionid'] = {value=inspectionid, CFSQLType="integer"};
        return queryExecute(sql, paramset);
    }

    function getInsReportMisByListId(string ids) { 
    	sql = "select inspection_report_mistake.*,mistake_dictionary.mistake_description_english, mistake_dictionary.characteristic  
        		from inspection_report_mistake, mistake_dictionary
 				where inspection_report_mistake.mistake_code = mistake_dictionary.mistake_code 
 				and inspection_report_mistake.inspection_mistake_id in("&ids&")";
        return queryExecute(sql);
    }
}