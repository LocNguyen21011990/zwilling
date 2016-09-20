component accessors=true {

	property framework;
    property companyService;

    function addCompany(string data) {
        var success = false;
        var message = "Insert data fail";
        var info = deserializeJSON(data);
        var new_company = entityNew('company');
        var companyid = 0;
        if(companyService.getCompanyByCompanyNo(info.gildemeisterid, info.company_kind, 0).recordCount > 0){
            message="The number is existed already!";
        }else{
            new_company.setName(info.name);
            new_company.setGildemeisterid(info.gildemeisterid);
            new_company.setAbbreviation_name(info.abbreviation_name);
            new_company.setAddress(info.address);
            new_company.setLocationid(info.locationid);
            new_company.setCountry_code_phone(info.country_code_phone);
            new_company.setPhone(info.phone);
            new_company.setCountry_code_fax(info.country_code_fax);
            new_company.setFax(info.fax);
            new_company.setMail(info.mail);
            new_company.setContact_person(info.contact_person);
            new_company.setCompany_kind(info.company_kind);
            new_company.setLastupdate(now());
            new_company.setUpdateby(info.updateby);
            entitySave(new_company);
            companyid = new_company.getCompanyid();
            success = true;
            message = "Insert data success";
        }
        
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message, 'companyid': companyid});   
    }

    function editCompany(string data) {
        var success = false;
        var message = "Update data fail";
        var info = deserializeJSON(data);
        if(companyService.getCompanyByCompanyNo(info.gildemeisterid, info.company_kind, info.companyid).recordCount > 0){
            message="The number is existed already!";
        }else{
            entity_company = entityLoad( "company", info.companyid, true );
            entity_company.setName(info.name);
            entity_company.setGildemeisterid(info.gildemeisterid);
            entity_company.setAbbreviation_name(info.abbreviation_name);
            entity_company.setAddress(info.address);
            entity_company.setLocationid(info.locationid);
            entity_company.setCountry_code_phone(info.country_code_phone);
            entity_company.setPhone(info.phone);
            entity_company.setCountry_code_fax(info.country_code_fax);
            entity_company.setFax(info.fax);
            entity_company.setMail(info.mail);
            entity_company.setContact_person(info.contact_person);
            entity_company.setCompany_kind(info.company_kind);
            entity_company.setLastupdate(now());
            entity_company.setUpdateby(info.updateby);
            success = true;
            message = "Update data success";
        }
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
           
    }

    function delCompany(numeric id) {
        entity_company = entityLoad( "company", id, true );
        entity_company.setActive(0);
        success = true;
        message = "Delete data success";
        VARIABLES.framework.renderData('JSON', {'success': success, 
                                                    'message': message});
    }
    
    function getCompanyById(numeric companyid) {
        var obj = createObject("component","api/general");
        result = obj.queryToObject(companyService.getCompanyById(companyid, 0));
        VARIABLES.framework.renderData('JSON', result);
    }

    function getCompanyByKind(numeric company_kind) {
        var obj = createObject("component","api/general");
        result = obj.queryToArray(companyService.getCompanyById("", company_kind));
        VARIABLES.framework.renderData('JSON', result);
    }

   function getCustomerAndSupplier() {
        var obj = createObject("component","api/general");
        result = obj.queryToArray(companyService.getCompanyList());
        VARIABLES.framework.renderData('JSON', result);
    }
    
    function getLocationList() {
        var obj = createObject("component","api/general");
        VARIABLES.framework.renderData('JSON', obj.queryToArray(companyService.getLocationList()));
    }
    
    function execute() {
        switch(cgi.request_method) { 
            case "put": 
                    editCompany(GetHttpRequestData().content);
                    break; 
            case "post": 
                addCompany(GetHttpRequestData().content);
                break; 
            case "delete":
                if(StructKeyExists(URL, 'id')){
                    delCompany(URL.id);
                    break;
                }
            case "get": 
                if(StructKeyExists(URL, 'id')){
                    getCompanyById(URL.id);
                    break;
                }
                if(StructKeyExists(URL, 'company_kind')){
                    getCompanyByKind(URL.company_kind);
                    break;
                }
                getCustomerAndSupplier();
                break;         
        } //end switch
    }
}