component persistent="true" {
	
	property name="product_segment_id" 				fieldtype="id" generator="native" setter="false";
	property name="product_segment_name_english"   	ormtype="string";
	property name="product_segment_name_german"		ormtype="string";
	property name="active" 							ormtype="integer" default=1;
	property name="lastupdate" 						ormtype="timestamp";
	property name="updateby" 						ormtype="string" default="rasia";
}