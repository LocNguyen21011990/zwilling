component persistent="true" table="item" {
	//number of description based on number of language record

	property name="itemid" ormtype="integer" fieldtype="id" column="itemid" generator="native" setter="false";
	property name="item_no" ormtype="string" default="";
	property name="item_groupid" ormtype="integer" default=null;

	property name="description_english" ormtype="text" default="";
	property name="description_german" ormtype="text" default="";
	property name="description_vietnamese" ormtype="text" default="";
	property name="description_korean" ormtype="text" default="";
	property name="description_chinese" ormtype="text" default="";

	property name="is_show" ormtype="short" default=1;
	property name="active" ormtype="short" default=1;
	property name="lastupdate" ormtype="date" default="";
	property name="updateby" ormtype="string" default="";
}