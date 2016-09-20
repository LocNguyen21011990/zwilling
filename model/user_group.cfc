component persistent="true" {
	property name="user_groupid" fieldtype="id" generator="native" setter="false";
	property name="user_group_name" 	ormtype="string";
	property name="active"				ormtype="boolean";
	property name="lastupdate" 			ormtype="timestamp";
	property name="updateby" 			ormtype="string";
}