component persistent="true" table="item_group" {

	property name="item_groupid" ormtype="integer" fieldtype="id" column="item_groupid" generator="native" setter="false";
	property name="is_set_group" ormtype="short" default=null;
	property name="group_kind" ormtype="integer" default=null;

	property name="item_group_name_english" ormtype="text" default="";
	property name="item_group_name_german" ormtype="text" default="";
	property name="item_group_name_vietnamese" ormtype="text" default="";
	property name="item_group_name_korean" ormtype="text" default="";
	property name="item_group_name_chinese" ormtype="text" default="";

	property name="active" ormtype="short" default=1;
	property name="lastupdate" ormtype="date" default="";
	property name="updateby" ormtype="string" default="";
}