component {

	function getProductLines() {
		var sql = 
			"SELECT pl.product_line_no, pl.product_line_name_english, pl.product_line_name_german, pl.ql, 
					b.brandname,  
					ps.product_segment_name_german, ps.product_segment_name_english,
					b.brandid,
					ps.product_segment_id,
					pl.ql
			FROM 	product_line pl  
			INNER JOIN brand b ON pl.brandid = b.brandid And b.active = 1   
			INNER JOIN product_segment ps ON pl.product_segment_id = ps.product_segment_id And ps.active = 1   
			WHERE 	pl.active = 1";
		return queryExecute(sql);
	}
	
	function getProductLineById(string id) {
		var paramset = {};
		var sql = 
			"SELECT pl.product_line_no, pl.product_line_name_english, pl.product_line_name_german, 
					pl.brandid, pl.product_segment_id   
			FROM 	product_line pl 
			WHERE pl.active = 1 and pl.product_line_no = :id";
			paramset['id'] = {value=id, CFSQLType="string"};					
		return queryExecute(sql, paramset);
	}	
	
}