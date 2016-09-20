component persistent="false" table="account" {
	
	property name="account" ormtype="string" default=null;
	property name="password" ormtype="string" default=null;
	property name="memberid" ormtype="integer" default=null;
	property name="user_groupid" ormtype="integer" default=null;

	property name="is_blocked" ormtype="short" default=0;
	property name="is_new" ormtype="short" default=1;

	property name="active" ormtype="short" default=1;
	property name="lastupdate" ormtype="date" default=null;
	property name="updateby" ormtype="string" default="";
}