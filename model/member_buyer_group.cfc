component persistent="true" {
	property name="member_buyer_group_id" 	fieldtype="id" generator="native" setter="false"					 	ormtype="integer";
	property name="memberid"   						ormtype="integer";
	property name="buyer_group_id"								ormtype="integer";
	property name="active" 								ormtype="integer";
	property name="lastupdate" 							ormtype="timestamp";
	property name="updateby" 							ormtype="string";
}