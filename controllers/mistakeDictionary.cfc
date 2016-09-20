component accessors=true {

	property framework;
	property mistake_dictionaryService;
    property product_segmentService;
    property characteristicService;

    function getListProductSegment() {
        var obj = createObject("component","api/general");
        var data = product_segmentService.getListProductSegment();
        VARIABLES.framework.renderData('JSON', obj.queryToArray(data));
    }

    function getListCharacteristic() {
        var obj = createObject("component","api/general");
        var data = characteristicService.getListChacterristic();
        VARIABLES.framework.renderData('JSON', obj.queryToArray(data));
    }

    function addMistakeDictionary(string data) {
        var success = false;
        var message = "";
        var info = deserializeJSON(data);
        if(mistake_dictionaryService.getMistakeDictionaryByMistakeCode(info.mistake_code).recordCount > 0){
            message = "Mistake code is existed";
        }else{
            var new_mistakeDictionary = entityNew('mistake_dictionary');
            new_mistakeDictionary.setMistake_code(info.mistake_code);
            new_mistakeDictionary.setCharacteristic(info.characteristic);
            new_mistakeDictionary.setMistake_description_english(info.mistake_description_english);
            new_mistakeDictionary.setLastupdate(dateformat(now(),'yyyy-mm-dd'));
            new_mistakeDictionary.setUpdateby(info.updateby);
            new_mistakeDictionary.setNr_fo(info.nr_fo);
            new_mistakeDictionary.setNr_fe(info.nr_fe);
            entitySave(new_mistakeDictionary);
            for(psmd in info.product_segment){
                QueryExecute(sql:"INSERT INTO product_segment_mistake_dictionary( 
                                            product_segment_id, 
                                            mistake_code, 
                                            lastupdate,
                                            updateby )
                                VALUES( :product_segment_id, :mistake_code, :lastupdate, :updateby )",
                            params:{
                                    product_segment_id:{ value = psmd, CFSQLType='integer'},
                                    mistake_code:{ value = info.mistake_code, CFSQLType='string'},
                                    lastupdate:{ value = dateformat(now(),'yyyy-mm-dd'), CFSQLType='DATE'},
                                    updateby:{ value = info.updateby, CFSQLType='string'}
                                });
            }
            success = true;
            message = "Insert data success";
        }
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    function editMistakeDictionary(string data) {
        var info = deserializeJSON(data);
       
        var mistakeDictionary = entityLoad( "mistake_dictionary", {mistake_code=info.mistake_code}, true );;
        mistakeDictionary.setMistake_code(info.mistake_code);
        mistakeDictionary.setCharacteristic(info.characteristic);
        mistakeDictionary.setMistake_description_english(info.mistake_description_english);
        mistakeDictionary.setLastupdate(dateformat(now(),'yyyy-mm-dd'));
        mistakeDictionary.setUpdateby(info.updateby);
        mistakeDictionary.setNr_fo(info.nr_fo);
        mistakeDictionary.setNr_fe(info.nr_fe);
        QueryExecute(sql:"delete from product_segment_mistake_dictionary 
                        where mistake_code = :mistake_code",
                    params:{
                            mistake_code:{ value = info.mistake_code, CFSQLType='string'}
                        });
      
        for(psmd in info.product_segment){
            if(psmd != 0){
                QueryExecute(sql:"INSERT INTO product_segment_mistake_dictionary( 
                                        product_segment_id, 
                                        mistake_code, 
                                        lastupdate,
                                        updateby )
                            VALUES( :product_segment_id, :mistake_code, :lastupdate, :updateby )",
                        params:{
                                product_segment_id:{ value = psmd, CFSQLType='integer'},
                                mistake_code:{ value = info.mistake_code, CFSQLType='string'},
                                lastupdate:{ value = dateformat(now(),'yyyy-mm-dd'), CFSQLType='DATE'},
                                updateby:{ value = info.updateby, CFSQLType='string'}
                            });
            }
        }
        success = true;
        message = "Update data success";
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    function getMistakeDictionaryList() {
        var obj = createObject("component","api/general");
        var mds = obj.queryToArray(mistake_dictionaryService.getListMistakeDictionary());
        for(item in mds){
            item.product_segment = obj.queryToArray(mistake_dictionaryService.getProductSegmentByMistakeCode(item.mistake_code));
        }
        VARIABLES.framework.renderData('JSON', mds);
    }

    function getMistakeDictionaryById(string mistake_code) {
        var obj = createObject("component","api/general");
        var md = obj.queryToObject(mistake_dictionaryService.getMistakeDictionaryByMistakeCode(mistake_code));
        md.product_segment = obj.queryToArray(mistake_dictionaryService.getProductSegmentByMistakeCode(md.mistake_code));
        VARIABLES.framework.renderData('JSON', md);
    }

    function getMistakeDics() {
        var obj = createObject("component","api/general");
        var mds = mistake_dictionaryService.getListMistakeDictionary();
        var result = [];
        for(item in mds){
            var data = mistake_dictionaryService.getProductSegmentByMistakeCode(item.mistake_code);
            var psArr = obj.queryToArray(product_segmentService.getListProductSegment());
            for(row in psArr){ 
                var flag = false;
                for(p in data){
                    if(row.product_segment_id == p.product_segment_id)
                        flag = true;
                }
                if(!flag){
                    row.product_segment_id = 0;
                }
            }
            item.product_segment = psArr;
            arrayAppend(result, item);
        }
        VARIABLES.framework.renderData('JSON', result);
    }
    
    function execute() {

        switch(cgi.request_method) { 
            case "put": 
                    editMistakeDictionary(GetHttpRequestData().content); 
                    break; 
            case "post": 
                    addMistakeDictionary(GetHttpRequestData().content);
                    break; 
            case "delete":
                if(StructKeyExists(URL, 'id')){
                    //deleteAccess(GetHttpRequestData().headers.token, URL.id);
                    break; 
                }
            case "get": 
                if(StructKeyExists(URL, 'id')){
                    getMistakeDictionaryById(URL.id);
                    break;
                }
                getMistakeDictionaryList(); 
                break;             
        } //end switch
    }
        
}
