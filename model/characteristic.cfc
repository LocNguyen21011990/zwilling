component persistent="true" {
	//categories of mistake
	property name="code" fieldtype="id"				ormtype="string";
	property name="characteristic_name_english" 	ormtype="string";
	property name="characteristic_name_german" 		ormtype="string";

	property name="active" 		ormtype="short" default=1;
	property name="lastupdate" 	ormtype="date";
	property name="updateby" 	ormtype="string";
}