/**
*
* @file  /E/Projects/zwilling_v2/controllers/order_document.cfc
* @author  Dieu Le
* @description Relationship to order document
*
*/

component accessors="true"  {
		
	property order_documentService;

    public function init(required any fw){
        
        variables.fw = arguments.fw;
        return this;
    }
    
	public void function uploadDocument(  ){

        var data = deserializeJSON(GetHttpRequestData().content);

        var api     = new api.general();
        var valid   = api.validMimeTypes();
        var message = "Your file upload invalid, please try again!";
        var success = false;
        try {

                // var getFile = rc.uploadFile ?:'';
                // var path    = "/fileUpload/order/";

                // newUpload = fileUpload(expandPath(path),"uploadFile", "#structKeyList(valid)#", "makeUnique");
            var arraydocId         = [];
            var arrayFilename = []
            for(var i =1;i<=arrayLen(data);i++){

                var imageName = data[i].filename;
                var imagePath = "/fileUpload/order/"; 
                file action="write" file="#expandPath(imagePath)#/#imageName#" output="#toBinary(data[i].base64)#" addnewline="false" mode="777" ;
                
                    
                    fileName  = data[i].filename;
                    QueryExecute(sql:"INSERT INTO order_document (fileName, path, createTime )
                                        VALUES(:fileName, :path,       :createTime)",
                        params:{
                              fileName:{    value   = #fileName#            ,CFSQLType = 'string'}
                            , path:{        value   = #imagePath#&#fileName#     ,CFSQLType = 'string'}
                            , createTime:{  value   = dateformat(now(),'yyyy-mm-dd'), CFSQLType = 'date'}
                        });

                    var IdCurrent   = order_documentService.getIdCurrent();
                    arrayAppend(arraydocId, IdCurrent);
                    arrayAppend(arrayFilename,fileName);
                }
                success = true;   
                variables.fw.renderData('JSON',{ 'success':success, 'docId':arraydocId,'filename':arrayFilename});
        }
        catch(any e) {
            variables.fw.renderData('JSON',{ 'success':success,'message':e.message}); 
        } 
    }

    public any function updateOrderIdByDocument( string data) {
        var getdata    = deserializeJSON(data);
        // JSON {docId:'35',order_Id:123 }
        QueryExecute(sql:"UPDATE order_document set order_Id =:orderId WHERE id=:docId",
            params:{
                    orderId:{ value  = getdata.order_Id    ,CFSQLType='string'}
                    ,docId:{ value    = getdata.docId       ,CFSQLType='numeric'} 
                });

        fw.renderData('JSON', {'success':true, 'data':getdata});
    }
    
    
    public any function removeDocument(numeric docId) {

        var document        = entityLoad("order_document",docId, true);
        
        var rootpath        = expandPath("/");
        if(!IsEmpty(document)){
            var pathDocument = rootpath&document.getPath();
           
            if(fileExists(pathDocument)){
                FileDelete(pathDocument);
            }
        }
        entityDelete(document);
        fw.renderData('JSON', {'id':document,'success':true});
    }
    function showDocumentById( numeric docId){

        var document    =  entityLoad("order_document", docId, true);
        fw.renderData('JSON', document);
    }
    function getAllDocument(){
        var document    = entityLoad("order_document");
        fw.renderData('JSON', document);
    }

    function getListDocumentByIdOrder(numeric order_Id) {
        var api     = new api.general();
        fw.renderData('JSON', api.queryToArray(order_documentService.getListDocByIdOrder(order_Id)));
    }
    
    function executeDocument() {
        
        switch(cgi.request_method){
            case "put":
                updateOrderIdByDocument(getHttpRequestData().content);
                break;
            case "delete":
                if(structKeyExists(URL, "docId")){
                    removeDocument(URL.docId);
                    break;
                }
            case "get":
                if(structKeyExists(URL, "docId")){
                    showDocumentById(URL.docId);
                    break;
                }
                if(structKeyExists(URL, "orderId")){
                    getListDocumentByIdOrder(URL.orderId);
                    break;
                }
            getAllDocument();
            break;
        }
    }
}