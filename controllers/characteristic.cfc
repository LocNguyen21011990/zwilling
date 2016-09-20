/**
*
* @file  /E/Projects/zwilling_v2/controllers/characteristic.cfc
* @author  Dieu Le
* @description characteristicController
*
*/

component accessors="true"  {

	property characteristicService;
	public function init(required any fw){
		variables.fw = arguments.fw;
		return this;
	}

	function getAll(){
		var api = new api.general();
		var characteristic = characteristicService.getListChacterristic();
		variables.fw.renderData('JSON',api.querytoArray(characteristic));
	}

	function addCharacteristic(string data){
		var getData  =deserializeJSON(data);
		/* JSON {
				"code":"xl test",
				"characteristic_name_english":"123",
				"characteristic_name_german":"123",
				"updateby":"rasia"
			} */
		var checkCode = characteristicService.checkExists(getData.code);
		if(checkCode > 0){
			var message = #getData.code# & ' is existed already';
			variables.fw.renderData('JSON',{'message':message, 'success':false});
		}else{
			var message = 'Insert new record characteristic success';
			characteristicService.insertDataCharacteristic( 
											getData.code,
											getData.characteristic_name_english,
											getData.characteristic_name_german,
											getData.updateby );
			variables.fw.renderData('JSON',{'message':message,'success':true});
		}
		
	}
	function updateCharacteristic(string data){
		/* JSON {
				"code":"xl test",
				"characteristic_name_english":"123",
				"characteristic_name_german":"123",
				"updateby":"rasia"
			} */
		var getData = deserializeJSON(data);
		characteristicService.updateDataCharacteristic( 
											getData.code,
											getData.characteristic_name_english,
											getData.characteristic_name_german,
											getData.updateby );

		var message = 'Updated characteristic success';
		variables.fw.renderData('JSON', {'message':message, 'success':true});
	}
	function execute(){
		switch(cgi.request_method){
			case "POST":
				addCharacteristic(getHttpRequestData().content);
			break;
			case "PUT":
				updateCharacteristic(getHttpRequestData().content);
			break;
			case "GET":
				getAll();
			break;
		}
	}
}