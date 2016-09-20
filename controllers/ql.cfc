/**
*
* @file  /E/Projects/zwilling_v2/controllers/ql.cfc
* @author  Dieu Le
* @description relationship with table QL
*
*/

component  accessors="true" {

	property qlService;
	public function init(required any fw){

		variables.fw = arguments.fw;
		return this;
	}
	function getAll(){
		var api = new api.general();
		var ql 	= qlService.getQlList();

		fw.renderData('JSON', api.queryToArray(ql));
	}
	function getAvgQL(){
		var api = new api.general();
		var aql = qlService.getListAvgQL();
		fw.renderData('JSON', api.queryToArray(aql));

	}
	function CheckExists(string ql) {
		var record = qlService.CheckExists(ql);
		return IsEmpty(record)?false:true;
	}
	function addQL(string data){

		/*  JSON {
			"quality_level":"abc",
			 "quality_description":"snvsdfgfdg",
			"major_defect_aql":"1", 
			"minor_defect_aql":"2.5",
			"updateby":"rasia"
			} */
		var getData 	= deserializeJSON(data);
		var checkExists = CheckExists(getData.quality_level);
		
		if(!checkExists){
			QueryExecute(sql:"INSERT INTO ql( quality_level, 
										 quality_description, 
										 major_defect_aql, 
										 minor_defect_aql, 
										 active, 
										 lastupdate,
										 updateby   )
							VALUES( :quality_level, 	:quality_description, 	:minor_defect_aql,
								    :minor_defect_aql, :active, 				:lastupdate, :updateby)",
						params:{
								quality_level:{ 		value = getData.quality_level 		,CFSQLType='string'},
								quality_description:{ 	value = getData.quality_description ,CFSQLType='string'},
								major_defect_aql:{ 		value = getData.major_defect_aql 	,CFSQLType='NUMERIC'},
								minor_defect_aql:{ 		value = getData.minor_defect_aql 	,CFSQLType='NUMERIC'},
								active:{				value = 1 							,CFSQLType='NUMERIC'},
								lastupdate:{ 			value = dateformat(now(),'yyyy-mm-dd'), CFSQLType='DATE'},
								updateby:{ 				value = getData.updateby			,CFSQLType='string'}
							});
			var message = 'Insert new record ql success';
			fw.renderData('JSON',{'message':message, 'success':true});
		}else{
			fw.renderData('JSON',{'message':'quality_level exists, pls add other!', 'success':false});
		}
		
	}

	function updateQL(string data){
		var getData  = deserializeJSON(data);
		/*  JSON {
			"quality_level":"abc",
			 "quality_description":"toilaai",
			"major_defect_aql":"1", 
			"minor_defect_aql":"22.5"
			} */
		var checkExists = CheckExists(getData.quality_level);
		
			QueryExecute(sql:"Update ql set 
		 								quality_description =:quality_description,
		 								major_defect_aql =:major_defect_aql,
		 								minor_defect_aql =:minor_defect_aql,
		 								lastupdate =:lastupdate,
		 								updateby =:updateby
		 					WHERE quality_level = '#getData.quality_level#' ",
		 								params:{
		 									quality_description:{	value = getData.quality_description ,CFSQLType='string'},
		 									major_defect_aql:{ 		value = getData.major_defect_aql 	,CFSQLType='NUMERIC'},
		 									minor_defect_aql:{ 		value = getData.minor_defect_aql 	,CFSQLType='NUMERIC'},
		 									lastupdate:{ 			value = dateformat(now(),'yyyy-mm-dd') 	,CFSQLType='date'},
		 									updateby:{ 				value = getData.updateby 			,CFSQLType='string'}
		 									});

		var message = 'update record ql success';
		fw.renderData('JSON',{'message':message, 'success':true});

		
	}

	function executeQL(){
		switch(cgi.request_method){
			case "POST":
				addQL(getHttpRequestData().content);
			break;
			case "PUT":
				updateQL(getHttpRequestData().content);
			break;
			case "GET":
				getAll();
			break;
		}
	}
}