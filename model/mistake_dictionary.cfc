component persistent="true" {
	property name="mistake_code" fieldtype="id" ormtype="string";
	property name="mistake_description_english" 		ormtype="string";
	property name="mistake_description_german" 			ormtype="string";
	property name="characteristic" 				ormtype="string";
	property name="active" 								ormtype="integer" default=1;
	property name="lastupdate" 							ormtype="timestamp";
	property name="updateby" 							ormtype="string";	
	property name="nr_fo" 								ormtype="string";
	property name="nr_fe" 								ormtype="string";
}