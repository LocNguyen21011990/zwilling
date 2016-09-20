component {

	function getListMistakeDictionary() {
		var sql = "select mistake_code, characteristic, mistake_description_english, nr_fo, nr_fe  
				   FROM mistake_dictionary  
				   where active=1"; 
		return queryExecute(sql);
	}

	function getProductSegmentByMistakeCode(string mistake_code) {
		var sql = "select ps.product_segment_id, ps.product_segment_name_english  
				   FROM product_segment_mistake_dictionary psmd  
				   inner join product_segment ps on psmd.product_segment_id = ps.product_segment_id and ps.active=1 
				   where psmd.active=1 and psmd.mistake_code = :mistake_code"; 
			paramset['mistake_code'] = {value=mistake_code, CFSQLType="string"};
		return queryExecute(sql, paramset);
	}
	
	function getMistakeDictionaryByMistakeCode(string mistake_code) {
		var sql = "select mistake_code, characteristic, mistake_description_english, nr_fo, nr_fe  
				   FROM mistake_dictionary  
				   where active=1 and mistake_code = :mistake_code"; 
				   paramset['mistake_code'] = {value=mistake_code, CFSQLType="string"};
		return queryExecute(sql, paramset);
	}
	
}