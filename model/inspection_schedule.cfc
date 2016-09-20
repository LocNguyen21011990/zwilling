component persistent="true"{
	
	property name="id" ormtype="integer" fieldtype="id" generator="native" setter="false";
	property name="abid" ormtype="integer";
	property name="inspector1" ormtype="integer";
	property name="inspector2" ormtype="integer";
	property name="plan_date" ormtype="timestamp";
	property name="lastupdate" ormtype="date" default="";
	property name="updateby" ormtype="string" default="rasia";

}