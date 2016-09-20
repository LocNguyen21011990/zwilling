component persistent="true" {
	property name="set_compositionid" fieldtype="id" generator="native" ormtype="integer";
	property name="parent_product_item_no"   			ormtype="string";
	property name="child_product_item_no"				ormtype="string";	
	property name="quantity" 							ormtype="integer";
	property name="active" 								ormtype="integer" default=1;
	property name="lastupdate" 							ormtype="timestamp";
	property name="updateby" 							ormtype="string" default="rasia";
}