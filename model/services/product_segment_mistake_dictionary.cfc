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
	 
	function getMistakeList(numeric product_segment_id) {
		flag = true;
		paramset = {}
		sqlmistake = "SELECT md.mistake_code, md.mistake_description_english, md.characteristic 
					  FROM product_segment_mistake_dictionary psmd 
					  INNER JOIN mistake_dictionary md on psmd.mistake_code = md.mistake_code And md.active = 1 
					  WHERE psmd.active = 1";
		if (flag) {
			sqlmistake &= " AND psmd.product_segment_id = :productSegmentId";
			paramset["productSegmentId"] = {value=product_segment_id, CFSQLType="integer"};
		}
		return queryExecute(sqlmistake, paramset);
	}
}