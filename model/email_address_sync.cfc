component persistent="true" table="email_address_sync" {
	
	property name="id" ormtype="integer" ;
	property name="user_name" ormtype="string";
	property name="email_address" ormtype="string";

	property name="active" ormtype="integer" default=1;
	property name="updateby" ormtype="string" default="";

}