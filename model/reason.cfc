component persistent="true" {
	property name="reasonid" fieldtype="id" generator="native" setter="false";
	property name="reasonname" 			ormtype="string";
	property name="active"				ormtype="boolean";
	property name="lastupdate" 			ormtype="timestamp";
	property name="updateby" 			ormtype="string";
	property name="is_show" 			ormtype="integer";
}