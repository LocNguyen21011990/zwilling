component accessors="true" {

    property framework;
    property product_item_documentService ;

        
    public function init( required any fw){
        variables.fw = arguments.fw;
        return this;
    }

    public function getProductItemDocumentByitemno(string itemno) {
        var obj = createObject("component","api/general");
        result = product_item_documentService.getListByitemno(itemno);
        variables.framework.renderData('JSON', obj.queryToArray(result));
    }
    
     function getIdCurrent() {
        
        var docId   =   queryExecute("select max(product_document_id) as id from product_item_document").id;
        return docId;
    }
    public function uploadProductDocument(  ){

        var data = deserializeJSON(GetHttpRequestData().content);
        var api     = new api.general();
        var valid   = api.validMimeTypes();
        var message = "Your file upload invalid, please try again!";
        var success = false;
        try {
                // var getFile = rc.uploadFile ?:'';
                // var path    = "/fileUpload/order/";
                // newUpload = fileUpload(expandPath(path),"uploadFile", "#structKeyList(valid)#", "makeUnique");
            var arraydocId    = [];
            var arrayFilename = [];

            for(var i =1;i<=arrayLen(data);i++){

                var imageName = data[i].filename;
                var imagePath = "/fileUpload/productItem/"; 
                file action="write" file="#expandPath(imagePath)#/#imageName#" output="#toBinary(data[i].base64)#" addnewline="false" mode="777" accept="#structKeyList(valid)#"; 
                    fileName  = data[i].filename;
                    fileType  = data[i].filetype;
                   
                    
                    queryExecute(sql:"INSERT INTO product_item_document(  fileName, active, path, type, lastupdate )
                                        VALUES(:fileName, :active, :path, :type, :lastupdate)",
                                        params:{
                                            fileName:{  value = #fileName#                  ,CFSQLType = 'string'},
                                            active:{    value = 1                           ,CFSQLType = 'numeric'},
                                            path:{      value = #imagePath#&#fileName#      ,CFSQLType = 'string'},
                                            type:{      value = #data[i].typeDocument#                  ,CFSQLType = 'string'},
                                            lastupdate:{value = dateformat(now(),'yyyy-mm-dd')  ,CFSQLType = 'date'}
                                            });
                    
                    var IdCurrent   = getIdCurrent();

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
    public any function removeProductDocument(numeric docId) {

        var document        = entityLoad("product_item_document",docId, true);
        
        var rootpath        = expandPath("/");
        if(!IsEmpty(document)){
            var pathDocument = rootpath&document.getPath();
           
            if(fileExists(pathDocument)){
                FileDelete(pathDocument);
            }
        }
        entityDelete(document);
        fw.renderData('JSON', {'success':true});
    }
    public any function updateProductNoByDocument( string data) {
        var getdata    = deserializeJSON(data);
        // JSON {"docId":'1',"product_no":'01000-040-9' }
        QueryExecute(sql:"UPDATE product_item_document 
                            set product_item_no =:product_no 
                            WHERE product_document_id =:docId",
            params:{
                    product_no:{ value  = getdata.product_no    ,CFSQLType='string'}
                    ,docId:{ value    = getdata.docId           ,CFSQLType='numeric'} 
                });

        fw.renderData('JSON', {'success':true, 'data':getdata});
    }

    function getListProductDocument(){
        var document = entityLoad("product_item_document");
        variables.fw.renderData('JSON', document);
    }
    function getProductDocumentById(numeric docId){
        var document = entityLoad("product_item_document", docId, true);
        variables.fw.renderData('JSON',document);
    }
    function execute() {

        switch(cgi.request_method) { 
            case "put": 
                    updateProductNoByDocument(getHttpRequestData().content);
                    break; 
            case "post": 
                //addAccess(GetHttpRequestData().headers.token, GetHttpRequestData().content);
                break; 
            case "delete":
                if(StructKeyExists(URL, 'docId')){
                   removeProductDocument(URL.docId);
                    break; 
                }
            case "get": 
                if(StructKeyExists(URL, 'id')){
                    //getAccessById(URL.id);
                    break;
                }
                if(StructKeyExists(URL, 'itemno')){
                    getProductItemDocumentByitemno(URL.itemno);
                    break;
                }
                if(StructKeyExists(URL, 'docId')){
                    getProductDocumentById(URL.docId);
                    break;
                }
               getListProductDocument();
                break;          
        } //end switch
    }
 
}