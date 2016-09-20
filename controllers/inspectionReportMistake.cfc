component accessors=true {

	property framework;
	property inspection_reportService;

    function addInspectionReportMistake(string data)
    {
        var success = false;
        var message = "Insert data fail";
        var ins_mis = deserializeJSON(data);
        var update_date = dateFormat(now(),'yyyy-mm-dd');
        var new_insRemistake = entityNew("inspection_report_mistake");
        new_insRemistake.setMistake_code(ins_mis.mistake_code);
        new_insRemistake.setNumber_of_critical_defect(ins_mis.number_of_critical_defect);
        new_insRemistake.setNumber_of_major_defect(ins_mis.number_of_major_defect);
        new_insRemistake.setNumber_of_minor_defect(ins_mis.number_of_minor_defect);
        new_insRemistake.setNumber_of_notice(ins_mis.number_of_notice);
        new_insRemistake.setLastupdate(update_date);
        new_insRemistake.setUpdateby(ins_mis.updateby);
        if(structKeyExists(ins_mis, "inspectionid")){
            new_insRemistake.setInspectionid(ins_mis.inspectionid);
        }
        entitySave(new_insRemistake);
        var success = true;
        var message = "Insert data success";
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message, 'inspection_mistake_id': new_insRemistake.getInspection_mistake_id()});
    }

    function editInspectionReportMistake(string data)
    {
        var success = false;
        var message = "Update data fail";
        var ins_mis = deserializeJSON(data);
        var update_date = dateFormat(now(),'yyyy-mm-dd');
        insRemistake = entityLoad( "inspection_report_mistake", ins_mis.inspection_mistake_id, true );
        insRemistake.setMistake_code(ins_mis.mistake_code);
        insRemistake.setNumber_of_critical_defect(ins_mis.number_of_critical_defect);
        insRemistake.setNumber_of_major_defect(ins_mis.number_of_major_defect);
        insRemistake.setNumber_of_minor_defect(ins_mis.number_of_minor_defect);
        insRemistake.setNumber_of_notice(ins_mis.number_of_notice);
        insRemistake.setLastupdate(update_date);
        insRemistake.setUpdateby(ins_mis.updateby);
        var success = true;
        var message = "Update data success";
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message, 'inspection_mistake_id': ins_mis.inspection_mistake_id});
    }

    function getInsReportMisById(numeric id) {
        var obj = createObject("component","api/general");
        sql = "select * from inspection_report_mistake where inspection_mistake_id = :id";
        paramset['id'] = {value=id, CFSQLType="integer"};
        VARIABLES.framework.renderData('JSON', obj.queryToObject(queryExecute(sql, paramset)));
    }

    function getInsReportMisByListId(string ids) { 
        var obj = createObject("component","api/general");
        sql = "select * from inspection_report_mistake where inspection_mistake_id in("&ids&")";
        VARIABLES.framework.renderData('JSON', obj.queryToArray(queryExecute(sql)));
    }

    function getInsReportMisByInspectionid(numeric inspectionid) {
        var obj = createObject("component","api/general");
        sql = "select inspection_report_mistake.*,mistake_dictionary.mistake_description_english from inspection_report_mistake,mistake_dictionary
 where inspection_report_mistake.mistake_code = mistake_dictionary.mistake_code and inspectionid= :inspectionid";
        paramset['inspectionid'] = {value=inspectionid, CFSQLType="integer"};
        VARIABLES.framework.renderData('JSON', obj.queryToArray(queryExecute(sql, paramset)));
    }

    function deleteInspectionReportMistake(numeric id) {
        var success = false;
        var message = "Delete data fail";
        var insRemistake = entityLoad("inspection_report_mistake", id, true);
        entityDelete(insRemistake);
        success = true;
        message = "Delete data success";
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }
    
    function execute() {

        switch(cgi.request_method) { 
            case "put": 
                    editInspectionReportMistake(GetHttpRequestData().content); 
                    break; 
            case "post": 
                    addInspectionReportMistake(GetHttpRequestData().content);
                    break; 
            case "delete":
                    deleteInspectionReportMistake(URL.id);
                    break; 
            case "get": 
                if(StructKeyExists(URL, 'id')){
                    getInsReportMisById(URL.id);
                    break;
                }
                if(StructKeyExists(URL, 'ids')){
                    getInsReportMisByListId(URL.ids);
                    break;
                }
                if(StructKeyExists(URL, 'inspectionid')){
                    getInsReportMisByInspectionid(URL.inspectionid);
                    break;
                }
                //oSearch(); 
                break;        
        } //end switch
    }
        
}
