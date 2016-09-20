component persistent=false {
	property name="parent_pattern_itemid" ormtype="string" default="";
	property name="child_pattern_itemid" ormtype="string" default="";
	property name="quantity" ormtype="integer" default=0;

	property name="active" ormtype="short" default=1;
	property name="lastupdate" ormtype="date" default="";
	property name="updateby" ormtype="string" default="rasia";
}