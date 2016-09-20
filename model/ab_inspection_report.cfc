component persistent=false table="ab_inspection_report" {

	property name="abid" ormtype="integer" default=null;
	property name="inspectionid" ormtype="integer" default=null;

	property name="temp_order_no" ormtype="string" default=null;
	property name="temp_position_no" ormtype="integer" default=null;
	property name="temp_abno" ormtype="integer" default=null;

	property name="active" ormtype="short" default=1;
	property name="lastupdate" ormtype="date" default=null;
	property name="updateby" ormtype="string" default="";
}