component {
	
	function getListDocumentType() {
		var sql = "select * from document_type";
		return queryExecute(sql); 
	}

	function getDocumentTypeByCode(string code) {
		var paramset = {};
		var sql = "select * from document_type where code = :code";
		paramset['code'] = {value=code, CFSQLType="string"};
		return queryExecute(sql, paramset); 
	}
}