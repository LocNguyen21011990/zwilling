component persistent="false" table="config_data" {

	property name="config_key" ormtype="string" default="";
	property name="day_changed" ormtype="integer" default=null;
	property name="day_remind" ormtype="integer" default=null;

	property name="is_changed" ormtype="short" default=1;
	property name="is_received" ormtype="short" default=1;
	property name="is_send" ormtype="short" default=1;
	property name="at_time" ormtype="string" default=null;
	property name="day_send" ormtype="integer" default=null;	
	property name="day_highlight" ormtype="integer" default=null;	

	property name="lastupdate" ormtype="date" default=null;
	property name="updateby" ormtype="string" default="";
}