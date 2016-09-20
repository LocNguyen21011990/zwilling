component {

	function getListProductSegment() {
		var sql = "select product_segment_id, product_segment_name_english, product_segment_name_german  
				   FROM product_segment  
				   where active=1 
				   order by product_segment_name_english asc, product_segment_name_german asc";
		return queryExecute(sql);
	}

	function getProductSegmentById(numeric id) {
		var paramset = {};
		var sql = "select product_segment_id, product_segment_name_english, product_segment_name_german  
				   FROM product_segment  
				   where active=1 and product_segment_id = :id";
				   paramset['id'] = {value=id, CFSQLType="integer"};
		return queryExecute(sql, paramset);
	}
	
	function getId() {
		var sql = "select max(product_segment_id) as product_segment_id from product_segment";
		return queryExecute(sql);
	}
	
	
	
}