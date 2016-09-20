
/**
*
* @file  /E/Projects/zwilling_v2/controllers/aql.cfc
* @author  Dieu Le
* @description aql Controller
*
*/ 
component output="false" displayname="" accessors="true" {

	property aqlService;

	public function init(required any fw){
		variables.fw = arguments.fw;
		return this;
	}
	function getAll(){
		var api 	= new api.general();
		var aql 	= aqlService.getAll();

		fw.renderData('JSON', api.queryToArray(aql));
	}
	
	function addAQL(string data){

		/*  JSON {
			"average_quality_level":"3.5",
			 "min_quantity":"1",
			"max_quantity":"1", 
			"inspection_lot":"2",
			"accepted":1,
			"rejected":0

			} */
		var getData 	= deserializeJSON(data);

		QueryExecute(sql:"INSERT INTO aql( 
										 average_quality_level, 
										 min_quantity, 
										 max_quantity, 
										 inspection_lot, 
										 active, 
										 accepted,
										 rejected,
										 lastupdate,
										 updateby   )
							VALUES( :average_quality_level 		,:min_quantity 		,:max_quantity,
								    :inspection_lot 			,:active 			,:accepted,
								    :rejected 					,:lastupdate 		,:updateby)",
						params:{
								average_quality_level:{ value = getData.average_quality_level 		,CFSQLType='NUMERIC'},
								min_quantity:{ 			value = getData.min_quantity 				,CFSQLType='NUMERIC'},
								max_quantity:{ 			value = getData.max_quantity 				,CFSQLType='NUMERIC'},
								inspection_lot:{ 		value = getData.inspection_lot 				,CFSQLType='NUMERIC'},
								active:{				value = 1 									,CFSQLType='NUMERIC'},
								accepted:{ 				value = getData.accepted 					,CFSQLType='NUMERIC'},
								rejected:{ 				value = getData.rejected 					,CFSQLType='NUMERIC'},
								lastupdate:{ 			value = dateformat(now(),'yyyy-mm-dd') 		,CFSQLType='DATE'},
								updateby:{ 				value = getData.updateby 					,CFSQLType='string'}
							});

		var message = 'Insert new record aql success';
		fw.renderData('JSON',{'message':message, 'success':true});
	}

	function updateAQL(string data){
		
		var getData  = deserializeJSON(data);
		
		  // JSON {"aqlid": 1,"average_quality_level":"3.5","min_quantity":"1","max_quantity":"1", "inspection_lot":"2","accepted":1,"rejected":0} 
		QueryExecute(sql:"Update aql set 
		 								average_quality_level =:average_quality_level,
		 								min_quantity 	=:min_quantity,
		 								max_quantity 	=:max_quantity,
		 								inspection_lot  =:inspection_lot,
		 								accepted 		=:accepted,
		 								rejected 		=:rejected,
		 								lastupdate 		=:lastupdate,
		 								updateby 		=:updateby
		 					WHERE aqlid = '#getData.aqlid#' ",
		 								params:{
		 									average_quality_level:{	value = getData.average_quality_level 	,CFSQLType='NUMERIC'},
		 									min_quantity:{ 			value = getData.min_quantity 			,CFSQLType='NUMERIC'},
		 									max_quantity:{ 			value = getData.max_quantity 			,CFSQLType='NUMERIC'},
		 									inspection_lot:{ 		value = getData.inspection_lot 			,CFSQLType='NUMERIC'},
		 									accepted:{ 				value = getData.accepted 				,CFSQLType='NUMERIC'},
		 									rejected:{ 				value = getData.rejected 				,CFSQLType='NUMERIC'},
		 									lastupdate:{ 			value = dateformat(now(),'yyyy-mm-dd') 	,CFSQLType='date'},
		 									updateby:{ 				value = getData.updateby 				,CFSQLType='string'}
		 									});
		var message = 'update record aql success';
		fw.renderData('JSON',{'message':message, 'success':true});
	}

	function execute(){
		switch(cgi.request_method){
			case "POST":
				addAQL(getHttpRequestData().content);
			break;
			case "PUT":
				updateAQL(getHttpRequestData().content);
			break;
			case "GET":
				getAll();
			break;
		}
	}
}
