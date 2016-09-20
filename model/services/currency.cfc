component  {

	function getCurrencyByYear(numeric year) {
		var paramset = {};
		var sql = "SELECT * FROM currency 
			WHERE exchange_year = :year";
			paramset['year'] = {value=year, CFSQLType="integer"};					
		return queryExecute(sql, paramset);
	}

	function getRateByCodeAndYear(string code, numeric year) {
		var paramset = {};
		var sql = "SELECT * FROM currency 
			WHERE exchange_year = :year and currency_code = :code";
			paramset['year'] = {value=year, CFSQLType="integer"};
			paramset['code'] = {value=code, CFSQLType="string"};					
		return queryExecute(sql, paramset);
	}
	function getListCurrency(){
		return QueryExecute("SELECT * from currency");
	}

	function checkExistsCurrency(	string currency_code 
									,numeric exchange_year){
		var exists = QueryExecute(sql:"SELECT * 
										FROM currency
										WHERE currency_code = '#currency_code#'
											AND exchange_year = '#exchange_year#' ").recordCount;
		return exists;
	}
	
}