/**
*
* @file  /E/Projects/zwilling_v2/controllers/location.cfc
* @author  Dieu.Le
* @description restAPI location
*
*/

component accessors="true" {

	property locationService;
	public function init(required any fw){
		variables.fw = arguments.fw;
		return this;
	}

	function getAll(){
		var api 	 = new api.general();
		var location = locationService.getListLocation();
		variables.fw.renderData('JSON',api.queryToArray(location));
	}

	function addLocation(string data){
		var getData  =deserializeJSON(data);
		/* JSON {
				"locationname":"xl test",
				"short_name":"xl",
				"country_code_phone":"123",
				"country_code_fax":"123",
				"updateby":"rasia"
			} */
		var message = 'Insert new record location success';
		locationService.insertDataLocation( getData.locationname,
											getData.short_name,
											getData.country_code_phone,
											getData.country_code_fax,
											getData.updateby );
		variables.fw.renderData('JSON',{'message':message,'success':true});
	}
	function updateLocation(string data){
		/* JSON {
				"locationid":"117",
				"locationname":"xl test",
				"short_name":"xl",
				"country_code_phone":"123",
				"country_code_fax":"123",
				"updateby":"rasia"
			} */
		var getData = deserializeJSON(data);
		locationService.updateDataLocation( getData.locationid,
											getData.locationname,
											getData.short_name,
											getData.country_code_phone,
											getData.country_code_fax,
											getData.updateby );

		var message = 'updated location success';
		variables.fw.renderData('JSON', {'message':message, 'success':true});
	}
	function execute(){
		switch(cgi.request_method){
			case "POST":
				addLocation(getHttpRequestData().content);
			break;
			case "PUT":
				updateLocation(getHttpRequestData().content);
			break;
			case "GET":
				getAll();
			break;
		}
	}
}