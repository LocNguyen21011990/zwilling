component persistent="true" {
	property name="product_line_no" fieldtype="id" ormtype="string";
	property name="brand" 							ormtype="string";
	property name="product_line_name_english" 			ormtype="string";
	property name="product_line_name_german"			ormtype="string";
	property name="active" 								ormtype="integer" default=1;
	property name="lastupdate" 							ormtype="timestamp";
	property name="updateby" 							ormtype="string";
	property name="product_segment_id" 					ormtype="integer";
	property name="ql" 									ormtype="string";
	property name="brandid" 							ormtype="integer";
}