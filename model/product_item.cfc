component persistent="true" {
	property name="product_item_no" fieldtype="id" ormtype="string";
	property name="product_item_name_english"   		ormtype="string";
	property name="product_line_no"						ormtype="string";	
	property name="product_item_name_german" 			ormtype="string";
	property name="active" 								ormtype="integer" default=1;
	property name="lastupdate" 							ormtype="timestamp";
	property name="updateby" 							ormtype="string" default="rasia";
	property name="EAN_code"							ormtype="string";
	property name="shape"								ormtype="string";
	property name="colour"								ormtype="string";
	property name="size"								ormtype="string";
}