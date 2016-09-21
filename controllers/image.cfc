/**
*
* @file  /E/Projects/zwilling_v2/controllers/image.cfc
* @author  dieu.le
* @description imageController
*
*/

component accessors="true"  {

	property imageService;
	public function init( required any fw){
		variables.fw = arguments.fw;
		return this;
	}

	 
	function uploadImages(){
		var data = deserializeJSON(GetHttpRequestData().content);

		variables.contentType = {
			 'image/jpeg': {extension: 'jpg'}
            ,'image/png': {extension: 'png'}
        };
        var valid = structKeyArray(#variables.contentType#);

        var message = "Upload file only allow images, please try again!";
        var success = false;

        try {
            var arrayImageId    = [];
            var arrayFilename 	= [];
           
            for(var i =1;i<=arrayLen(data);i++){

                var imageName = data[i].filename;
                var imagePath = "/fileUpload/images/"; 
                file action="write" file="#expandPath(imagePath)#/#imageName#" output="#toBinary(data[i].base64)#" 
                	addnewline="false" mode="777" accept="#structKeyList(variables.contentType)#";
            

                    fileName  		= data[i].filename;
                    fileType  		= data[i].filetype;
                    var fullPath 	= #imagePath#&#fileName#;
                    var inspectionid= data[i].inspectionid;
                    var updateby 	= data[i].updateby;
                    imageService.insertInfoImage( 	fileName
                    								,fullPath
                    								,inspectionid
                    								,updateby );
                    var IdCurrent   = imageService.getImageIdCurrent();

                    arrayAppend(arrayImageId, IdCurrent);
                    arrayAppend(arrayFilename,fileName);
                    
                }
                success = true;   
                variables.fw.renderData('JSON',{ 'success':success, 'imageId':arrayImageId,'filename':arrayFilename});
        }
        catch(any e) {
            variables.fw.renderData('JSON',{ 'success':success,'message':e.message}); 
        } 
	}
	function getListImageByInspectionId(numeric inspectionid){
		var api = new api.general();
		var listImage = imageService.getListImageByInspectionReport(inspectionid);
		variables.fw.renderData('JSON',api.queryToArray(listImage));
	}

	function execute(){
		switch(cgi.request_method){
			case "GET":
				if(structKeyExists(URL, "inspectionid")){
					getListImageByInspectionId(URL.inspectionid);
					break;
				}
		}
	}
}