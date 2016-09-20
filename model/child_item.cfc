component persistent="true" table="child_item" {
	//define subitems of an item
	property name="child_itemid" ormtype="integer" default=null;
	property name="parent_itemid" ormtype="integer" default=null;
	property name="quantity" ormtype="integer" default=null;

	property name="active" ormtype="short" default=1;
	property name="lastupdate" ormtype="date" default="";
	property name="updateby" ormtype="string" default="rasia";
}