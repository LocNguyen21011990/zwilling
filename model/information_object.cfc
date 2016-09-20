component persistent="false" table="information_object" {
	
	property name="info_objectid" ormtype="integer" ;
	property name="info_object_name" ormtype="string";

	property name="active" ormtype="integer" default=1;
	property name="lastupdate" ormtype="date" default="";
	property name="updateby" ormtype="string" default="";

}