component persistent="true" {
	property name="product_document_id" fieldtype="id" generator="native" ormtype="integer";
	property name="product_item_no"   					ormtype="string";
	property name="fileName"							ormtype="string";
	property name="type"								ormtype="string";
	property name="lastupdate" 							ormtype="timestamp";
	property name="active" 								ormtype="integer" default=1;	
	property name="updateby" 							ormtype="string" default="rasia";
	property name="path" 								ormtype="string";
}