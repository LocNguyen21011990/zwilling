component persistent="true" table="company" {
	
	property name="companyid" ormtype="integer" fieldtype="id" column="companyid" generator="native" setter="false";
	property name="name" ormtype="string" default="";
	property name="phone" ormtype="string" default="";
	property name="address" ormtype="string" default="";
	property name="mail" ormtype="string" default="";
	property name="fax" ormtype="string" default="";
	property name="company_kind" ormtype="integer";
	property name="locationid" ormtype="integer";
	property name="country_code_phone" ormtype="string" default="";
	property name="country_code_fax" ormtype="string" default="";
	property name="gildemeisterid" ormtype="string" default="";
	property name="contact_person" ormtype="string" default="";
	property name="abbreviation_name" ormtype="string" default="";
	property name="zwilling_no" ormtype="string" default="";
	property name="is_show" ormtype="short" default=1;
	property name="active" ormtype="integer" default=1;
	property name="lastupdate" ormtype="date" default="";
	property name="updateby" ormtype="string" default="";
	property name="location" ormtype="integer";
}