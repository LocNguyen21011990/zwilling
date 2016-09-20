component {

	function getBrands() {
		var sql = "SELECT * FROM brand WHERE active = 1 order by brandname asc";
		return queryExecute(sql);
	}
	
	function getBrandById(numeric id) {
		var paramset = {};
		var sql = 
			"SELECT * FROM  brand WHERE active = 1 and brandid = :id";
			paramset['id'] = {value=id, CFSQLType="integer"};					
		return queryExecute(sql, paramset);
	}	
	
}