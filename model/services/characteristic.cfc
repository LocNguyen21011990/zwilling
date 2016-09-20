component {

	function getListChacterristic() {
		var sql = "select * 
				   FROM characteristic 
				   where active=1 
				   order by characteristic_name_english asc, characteristic_name_german asc";
		return queryExecute(sql);
	}
	function insertDataCharacteristic(required string code
										, string characteristic_name_english
										, string characteristic_name_german
										, string updateby){

		QueryExecute(sql:"INSERT INTO characteristic( 
										 code, 
										 characteristic_name_english, 
										 characteristic_name_german, 
										 active, 
										 lastupdate,
										 updateby   )
							VALUES( :code 		,:characteristic_name_english 	,:characteristic_name_german, 
									:active 	,:lastupdate 					,:updateby)",
						params:{
								code:{ 							value = code 						,CFSQLType='string'},
								characteristic_name_english:{ 	value = characteristic_name_english ,CFSQLType='string'},
								characteristic_name_german:{ 	value = characteristic_name_german 	,CFSQLType='string'},
								active:{						value = 1 							,CFSQLType='NUMERIC'},
								lastupdate:{ 					value = dateformat(now(),'yyyy-mm-dd'), CFSQLType='DATE'},
								updateby:{ 						value = updateby					,CFSQLType='string'}
							});
	}
	function updateDataCharacteristic(
								  string code
								, string characteristic_name_english
								, string characteristic_name_german
								, string updateby){
		QueryExecute(sql:"Update characteristic set 
										code =:code,
										characteristic_name_english =:characteristic_name_english,
										characteristic_name_german =:characteristic_name_german,
										lastupdate =:lastupdate,
										updateby =:updateby
							WHERE code = '#code#' ",
										params:{
											code:{							value = code 						,CFSQLType='string'},
											characteristic_name_english:{ 	value = characteristic_name_english ,CFSQLType='string'},
											characteristic_name_german:{	value = characteristic_name_german 	,CFSQLType='string'},
											lastupdate:{ 	 				value = dateformat(now(),'yyyy-mm-dd') 	,CFSQLType='date'},
											updateby:{ 						value = updateby 			,CFSQLType='string'}
						});
	}
	function checkExists(string code){
		var checkCode = QueryExecute("select *
										from characteristic
										where code = '#code#' ").recordCount;
		return checkCode;
	}
}