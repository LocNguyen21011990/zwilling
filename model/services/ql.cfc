/**
*
* @file  /E/Projects/zwilling_v2/model/services/ql.cfc
* @author  Dieu Le
* @description qlService
*
*/

component {

	query function CheckExists(string quality_level) {
		
		return QueryExecute(sql:"SELECT quality_level
								 FROM ql
								 WHERE quality_level = '#quality_level#' ").recordCount();
	}
	
	query function getQlList() {
		return QueryExecute("SELECT * 
							FROM ql 
							WHERE active = 1
							order by quality_level asc");
	}
	

	query function getListAvgQL() {
		
		return QueryExecute("SELECT 
									distinct average_quality_level
								FROM aql
								WHERE active =1 
								order by average_quality_level");
	}
	function CheckExists(string ql) {
		
		var record = QueryExecute(sql:"SELECT quality_level
										 FROM ql
										 WHERE quality_level =:quality_level",
										 params:{ 
										 	quality_level:{ value = ql, CFSQLType='string'}
										 });
		return record;
	}
	
}