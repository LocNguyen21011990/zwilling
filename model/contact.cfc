component persistent="true" table="contact" {
	
	property name="contactid" 				ormtype="integer" fieldtype="id" 
											column="contactid" generator="native" setter="false";

	property name="full_name" 			ormtype="string" default="";
	property name="title" 				ormtype="string" default="";
	property name="address" 			ormtype="string" default="";
	property name="business_phone" 		ormtype="string" default="";
	property name="business_fax" 		ormtype="string" default="";
	property name="mail1" 				ormtype="string" default="";
	property name="company_no" 			ormtype="string" default="";
	property name="company_name" 		ormtype="string" default="";
	
	property name="locationid" 			ormtype="integer";
	property name="country_code_fax" 	ormtype="string" default="";
	property name="country_code_phone" 	ormtype="string" default="";
	property name="buyer_no" 			ormtype="string" default="";
	property name="planer_no" 			ormtype="string" default="";
	property name="mobile_phone" 		ormtype="string";
	property name="country_code_business_phone" ormtype="string";
	property name="active" 				ormtype="integer" default=1;
	property name="lastupdate" 			ormtype="date" default="";
	property name="updateby" 			ormtype="string" default="";
}