component persistent="true" {
	property name="memberid" fieldtype="id" generator="native" setter="false";
	property name="full_name" 						ormtype="string";
	property name="title"				ormtype="string";
	property name="address" 				ormtype="string";
	property name="business_phone" 			ormtype="string";
	property name="mobile_phone" 						ormtype="string";
	property name="business_fax" 				ormtype="string";
	property name="mail1" 				ormtype="string";
	property name="mail2" 				ormtype="string";
	property name="companyid" 				ormtype="integer";
	property name="active" 							ormtype="integer";
	property name="lastupdate" 						ormtype="timestamp";
	property name="updateby" 						ormtype="string";
	property name="country_code_phone" 						ormtype="string";
	property name="country_code_fax" 						ormtype="string";
	property name="country_code_business_phone" 						ormtype="string";
	property name="is_show" 						ormtype="integer";
	property name="buyer_no" 						ormtype="string";
	property name="planer_no" 						ormtype="string";
	property name="is_send_todolist" 						ormtype="boolean";
}