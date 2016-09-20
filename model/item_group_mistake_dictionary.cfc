component persistent="false" table="item_group_mistake_code" {
	//define mistakes of an item group to be inspected
	property name="item_groupid" ormtype="integer" default=null;
	property name="mistake_code" ormtype="string" default=null;
	property name="active" ormtype="integer" default=1;
	property name="lastupdate" ormtype="date" default="";
	property name="updateby" ormtype="string" default="";
}