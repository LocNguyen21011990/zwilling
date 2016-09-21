/**
*
* @file  /E/Projects/zwilling_v2/model/services/image.cfc
* @author  dieu.le
* @description imageService;
*
*/

component output="false" displayname=""  {

	public function init(){
		return this;
	}

	function insertInfoImage( 	 string file_name
								,string path
								,numeric inspectionid
								,string updateby){
		 var new_image 	= entityNew("image",{
			 	  file_name 	= file_name
			 	, path 			= path
			 	, inspectionid 	= inspectionid
			 	, updateby 		= updateby
			 	, lastupdate 	= dateformat(now(),'yyyy-mm-dd')
		 	});
		 entitySave(new_image);
	}
	function getImageIdCurrent(){
		var imageId = QueryExecute("select max(image_id) as id from image").id;
		return imageId;
	}
	function getListImageByInspectionReport(numeric id){
		return QueryExecute("Select image_id,
									file_name,
									path,
									inspectionid,
									updateby
							From image
							where active = 1 and inspectionid = '#id#' ");
	}
}