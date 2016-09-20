
component {
	
	function getListAql() {
		var sql = "select * from aql";
		return queryExecute(sql);
	}
	
	function getAql(numeric id) {
		var sql = "select * from aql where aqlid = :aqlId";
		paramset['aqlId'] = {value=id, CFSQLType="integer"};
		return queryExecute(sql, paramset);
	}

	function getAll() {
		
		return QueryExecute("SELECT *
							 FROM aql
							 WHERE active=1
							 order by lastupdate desc");
	}
	
}
