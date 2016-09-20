component persistent="false" table="buyer_group" {

	property name="buyer_group_id" ormtype="integer";
	property name="buyer_group_no" ormtype="string" default="";
	property name="description" ormtype="string" default="";
	property name="is_change" ormtype="integer" default=null;

	property name="active" ormtype="short" default=1;
	property name="lastupdate" ormtype="date" default=null;
	property name="updateby" ormtype="string" default="";
}