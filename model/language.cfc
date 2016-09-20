component persistent="false" table="language" {
	//supported languages
	property name="language" ormtype="integer" default="";	
	property name="active" ormtype="integer" default=1;
	property name="lastupdate" ormtype="date" default="";
	property name="updateby" ormtype="string" default="";
}