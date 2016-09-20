
/**
*
* @file  /E/Projects/zwilling_v2/controllers/currency.cfc
* @author  Dieu Le
* @description currency Controller
*
*/ 
component output="false" displayname="" accessors="true" {

	property currencyService;
	public function init(required any fw){
		variables.fw = arguments.fw;
		return this;
	}
	function getAll(){
		var cur = EntityLoad("currency");
		VARIABLES.fw.renderData('JSON',cur);
	}

	function addCurrency(string data){

		/*  JSON {
			"currency_code":"USD",
			"exchange_rate":"1.00000",
			"exchange_year":"2016", 
			"updateby":"rasia"
			} */
		
		var getData 	= deserializeJSON(data);
		// check data exists {code, exchange_year};
		var valueExists = currencyService.checkExistsCurrency(getData.currency_code,getData.exchange_year);
		if(valueExists >0){
			var message = 'Currency code and Exchange year are existed already!';
			variables.fw.renderData('JSON',{'message':message, 'success':false});
		}else{
			QueryExecute(sql:"INSERT INTO currency( 
									 currency_code, 
									 exchange_rate, 
									 exchange_year, 
									 updateby,
									 lastupdate
									)
						VALUES( :currency_code 		,:exchange_rate 		,:exchange_year,
							    :updateby 			,:lastupdate )",
					params:{
							currency_code:{ 		value = getData.currency_code 		,CFSQLType='string'},
							exchange_rate:{ 		value = getData.exchange_rate 		,CFSQLType='DOUBLE'},
							exchange_year:{ 		value = getData.exchange_year 		,CFSQLType='NUMERIC'},
							updateby:{ 				value = getData.updateby 			,CFSQLType='string'},
							lastupdate:{ 			value = dateformat(now(),'yyyy-mm-dd') 		,CFSQLType='DATE'}
						});

			var message = 'Insert new record currency success';
			variables.fw.renderData('JSON',{'message':message, 'success':true});
		}
		
	}

	function editCurrency(string data){
		
		var getData  = deserializeJSON(data);
		
		  /*  JSON {
			"currency_code":"USD",
			"exchange_rate":"1.00000",
			"exchange_year":"2016", 
			"updateby":"rasia"

			} */
		QueryExecute(sql:"Update currency SET
		 								currency_code 	=:currency_code,
		 								exchange_rate 	=:exchange_rate,
		 								exchange_year 	=:exchange_year,
		 								updateby  		=:updateby,
		 								lastupdate 		=:lastupdate
		 								
		 					WHERE currency_code = '#getData.currency_code#' and exchange_year = '#getData.exchange_year#' ",
		 								params:{
		 									currency_code:{				value = getData.currency_code 	,CFSQLType='string'},
		 									exchange_rate:{ 			value = getData.exchange_rate 	,CFSQLType='DOUBLE'},
		 									exchange_year:{ 			value = getData.exchange_year 	,CFSQLType='NUMERIC'},
		 									updateby:{ 					value = getData.updateby 		,CFSQLType='string'},
		 									lastupdate:{ 				value = dateformat(now(),'yyyy-mm-dd') 	,CFSQLType='date'}
		 									});
		var message = 'Update record currency success';
		variables.fw.renderData('JSON',{'message':message, 'success':true});
	}

	function execute(){
		switch(cgi.request_method){
			case "POST":
				addCurrency(getHttpRequestData().content);
			break;
			case "PUT":
				editCurrency(getHttpRequestData().content);
			break;
			case "GET":
				getAll();
			break;
		}
	}
}

