component accessors=true {

    property framework;
    property product_segment_documentService;

    public function init( required any fw){
        variables.fw = arguments.fw;
        return this;
    }

    public function getListByProductSegmentId(numeric product_segment_id) {
        var obj = createObject("component","api/general");
        result = product_segment_documentService.getListByproductSegmentId(product_segment_id);
        variables.framework.renderData('JSON', obj.queryToArray(result));
    }

    function getIdCurrent() {
        
        var docId   =   queryExecute("select max(segment_document_id) as id from product_segment_document").id;
        return docId;
    }

    public function uploadProductDocument(  ){

        var data = deserializeJSON(GetHttpRequestData().content);

        var api     = new api.general();
        var valid   = api.validMimeTypes();
        var message = "Your file upload invalid, please try again!";
        var success = false;
        try {
            var arraydocId    = [];
            var arrayFilename = [];

            for(var i =1;i<=arrayLen(data);i++){

                var imageName = data[i].filename;
                var imagePath = "/fileUpload/productSegment/"; 
                file action="write" file="#expandPath(imagePath)#/#imageName#" output="#toBinary(data[i].base64)#" addnewline="false" mode="777" accept="#structKeyList(valid)#"; 
                    fileName  = data[i].filename;
                    fileType  = data[i].typeDocument;
                   
                    
                    queryExecute(sql:"INSERT INTO product_segment_document(  fileName, path, type, createtime )
                                        VALUES(:fileName, :path, :type, :createtime)",
                                        params:{
                                            fileName:{  value = #fileName#                  ,CFSQLType = 'string'},
                                            path:{      value = #imagePath#&#fileName#      ,CFSQLType = 'string'},
                                            type:{      value = #fileType#                  ,CFSQLType = 'string'},
                                            createtime:{value = dateformat(now(),'yyyy-mm-dd')  ,CFSQLType = 'date'}
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

    public any function removeSegmentDocument(numeric docId) {

        var document        = entityLoad("product_segment_document",docId, true);
        
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

    public any function updateSegmentNoByDocument( string data) {
        var getdata    = deserializeJSON(data);
        // JSON {"docId":'1',"product_segment_id":2 }
        QueryExecute(sql:"UPDATE product_segment_document 
                            set product_segment_id =:product_segment_id 
                            WHERE segment_document_id =:docId",
            params:{
                    product_segment_id:{ value  = getdata.product_segment_id    ,CFSQLType='numeric'}
                    ,docId:{ value    = getdata.docId           ,CFSQLType='numeric'} 
                });

        fw.renderData('JSON', {'success':true, 'data':getdata});
    }

    function getSegmentDocumentById(numeric docId){
        var document = entityLoad("product_segment_document", docId, true);
        variables.fw.renderData('JSON',document);
    }

    function getListSegmentDocument(){
        var document = entityLoad("product_segment_document");
        variables.fw.renderData('JSON', document);
    }

    function execute() {

        switch(cgi.request_method) { 
            case "put": 
                if(StructKeyExists(URL, 'id')){
                    updateSegmentNoByDocument(getHttpRequestData().content);
                    break; 
                }
            case "post": 
                //addAccess(GetHttpRequestData().headers.token, GetHttpRequestData().content);
                break; 
            case "delete":
                if(StructKeyExists(URL, 'docId')){
                   removeSegmentDocument(URL.docId);
                    break; 
                }
            case "get": 
                if(StructKeyExists(URL, 'id')){
                    //getAccessById(URL.id);
                    break;
                }
                if(StructKeyExists(URL, 'product_segment_id')){
                    getListByProductSegmentId(URL.product_segment_id);
                    break;
                }
                if(StructKeyExists(URL, 'docId')){
                    getSegmentDocumentById(URL.docId);
                    break;
                }
                getListSegmentDocument(); 
                break;          
        } //end switch
    }
 
}