component persistent="true" {
	property name="segment_document_id" fieldtype="id" generator="native" setter="false";
	property name="fileName"   							ormtype="string";
	property name="product_segment_id" 					ormtype="integer";
	property name="updateby" 							ormtype="string" default="rasia";
	property name="createtime" 							ormtype="date";
	property name="type"								ormtype="string";
	property name="path"								ormtype="string";	
}