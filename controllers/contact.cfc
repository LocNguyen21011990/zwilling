/**
*
* @file  /E/Projects/zwilling_v2/controllers/contact.cfc
* @author  dieu.le
* @description contactController
*
*/

component output="false" displayname="" accessors="true"  {

	property contactService;

	public function init( required any fw){
		variables.fw = arguments.fw;
		return this;
	}
	
	function addContact(string data){
		var getData = deserializeJSON(data);

		var new_contact = entityNew("contact");
		var success = false;
                var message = "Insert new data fail";

                new_contact.setFull_name(getData.full_name);
                new_contact.setTitle(getData.title)
                new_contact.setAddress(getData.address);
                new_contact.setBusiness_phone(getData.business_phone);
                new_contact.setMobile_phone(getData.mobile_phone);
                new_contact.setBusiness_fax(getData.business_fax);
                new_contact.setMail1(getData.mail1);
                new_contact.setCompany_name(getData.company_name);
                new_contact.setCompany_no(getData.company_no);
                new_contact.setCountry_code_phone(getData.country_code_phone);
                new_contact.setCountry_code_fax(getData.country_code_fax);
                new_contact.setCountry_code_business_phone(getData.country_code_phone);
                new_contact.setBuyer_no(getData.buyer_no);
                new_contact.setPlaner_no(getData.planer_no);
                new_contact.setLocationid(getData.locationid);
                new_contact.setLastupdate(now());
                new_contact.setUpdateby(getData.updateby);
                entitySave(new_contact);

                success = true;
                message = "Insert new data success";
                
                variables.fw.renderData('JSON', {'success': success, 'message': message});   
	}
	function editContact(string data){
		
		var getData = deserializeJSON(data);
		var edit_contact = entityLoad("contact",getData.contactid, true);

		edit_contact.setFull_name(getData.full_name);
                edit_contact.setTitle(getData.title)
                edit_contact.setAddress(getData.address);
                edit_contact.setBusiness_phone(getData.business_phone);
                edit_contact.setMobile_phone(getData.mobile_phone);
                edit_contact.setBusiness_fax(getData.business_fax);
                edit_contact.setMail1(getData.mail1);
                edit_contact.setCompany_name(getData.company_name);
                edit_contact.setCompany_no(getData.company_no);
                edit_contact.setCountry_code_phone(getData.country_code_phone);
                edit_contact.setCountry_code_fax(getData.country_code_fax);
                edit_contact.setCountry_code_business_phone(getData.country_code_phone);
                edit_contact.setBuyer_no(getData.buyer_no);
                edit_contact.setPlaner_no(getData.planer_no);
                edit_contact.setLocationid(getData.locationid);
                edit_contact.setLastupdate(now());
                edit_contact.setUpdateby(getData.updateby);
                entitySave(edit_contact);
               
                success = true;
                message = "Updated record success";
                variables.fw.renderData('JSON',{'message':message,'success':success});
	}

	function getAll(){
		var contact = entityLoad("contact");
		variables.fw.renderData('JSON',contact);
	}
        function getListCompany(){
                var api = new api.general();
                var data = [];
                var items = api.querytoArray(contactService.getListCompanyNo());
                for( item in items){
                        var structCompany = {};
                        structCompany.value = item.gildemeisterid;
                        structCompany.label = item.gildemeisterid &"::"&item.name;
                        arrayAppend(data, structCompany);
                }
                variables.fw.renderData('JSON', data);
        }
	function execute(){
		switch(cgi.request_method){
			case "POST":
				addContact(getHttpRequestData().content);
			break;
			case "PUT":
				editContact(getHttpRequestData().content);
			break;
			case "GET":
				getAll();
			break;
		}
	}
}