/**
*
* @file  /E/Projects/zwilling_v2/model/services/location.cfc
* @author  Dieu.Le
* @description locationService
*
*/

component  {

	
	 query function getListLocation() {
		
		return QueryExecute("select locationid,
									locationname,
									short_name,
									country_code_phone,
									country_code_fax 
							from location 
							where active =1
							order by locationname");;
	}

	function insertDataLocation(required string locationname
										, string short_name
										, string country_code_phone
										, string country_code_fax
										, string updateby){

		QueryExecute(sql:"INSERT INTO location( 
										 locationname, 
										 short_name, 
										 country_code_phone, 
										 country_code_fax, 
										 active, 
										 lastupdate,
										 updateby   )
							VALUES( :locationname, 	:short_name, 	:country_code_fax,
								    :country_code_fax, :active, 	:lastupdate, 	:updateby)",
						params:{
								locationname:{ 			value = locationname 		,CFSQLType='string'},
								short_name:{ 			value = short_name 			,CFSQLType='string'},
								country_code_phone:{ 	value = country_code_phone 	,CFSQLType='string'},
								country_code_fax:{ 		value = country_code_fax 	,CFSQLType='string'},
								active:{				value = 1 					,CFSQLType='NUMERIC'},
								lastupdate:{ 			value = dateformat(now(),'yyyy-mm-dd'), CFSQLType='DATE'},
								updateby:{ 				value = updateby			,CFSQLType='string'}
							});
	}
	function updateDataLocation(  numeric locationid
								, string locationname
								, string short_name
								, string country_code_phone
								, string country_code_fax
								, string updateby){
		QueryExecute(sql:"Update location set 
										locationname =:locationname,
										short_name =:short_name,
										country_code_phone =:country_code_phone,
										country_code_fax =:country_code_fax,
										lastupdate =:lastupdate,
										updateby =:updateby
							WHERE locationid =:locationid ",
										params:{
											locationid:{		value = locationid 			,CFSQLType='numeric'},
											locationname:{		value = locationname 		,CFSQLType='string'},
											short_name:{ 		value = short_name 			,CFSQLType='string'},
											country_code_phone:{value = country_code_phone 	,CFSQLType='string'},
											country_code_fax:{	value = country_code_fax 	,CFSQLType='string'},
											lastupdate:{ 	 	value = dateformat(now(),'yyyy-mm-dd') 	,CFSQLType='date'},
											updateby:{ 			value = updateby 			,CFSQLType='string'}
						});
	}
	
}