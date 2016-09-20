component persistent="true" table="inspection_plan" {
	
	property name="inspection_plan_groupid" ormtype="integer" ;
	property name="description_english" ormtype="string" default="";
	property name="description_german" ormtype="string" default="";
	property name="user_field" ormtype="string" default="";

	property name="active" ormtype="short" default=1;
	property name="lastupdate" ormtype="date" default="";
	property name="updateby" ormtype="string" default="";

}