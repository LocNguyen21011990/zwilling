component persistent="true" table="inspection_report" {
	
	property name="inspectionid" ormtype="integer" fieldtype="id" column="inspectionid" generator="native" setter="false";
	property name="inspection_no" ormtype="string";
	property name="set_item_lot_size" ormtype="integer";
	property name="item_lot_size" ormtype="integer";
	property name="inspected_quantity" ormtype="integer";
	property name="result" ormtype="string" default="";
	property name="comment" ormtype="text" default="";
	property name="seal_from1" ormtype="string" default="";
	property name="seal_to1" ormtype="string" default="";
	property name="seal_from2" ormtype="string" default="";
	property name="seal_to2" ormtype="string" default="";
	property name="inspected_product_item_no" ormtype="string" default="";
	property name="inspector1" ormtype="integer";
	property name="inspector2" ormtype="integer";
	property name="last_change_person" ormtype="integer";
	property name="inspection_date" ormtype="date";
	property name="is_general_report" ormtype="short" default=0;
	property name="active" ormtype="short" default=1;
	property name="lastupdate" ormtype="date" default="";
	property name="updateby" ormtype="string" default="";
	property name="carton_info" ormtype="text" default="";
	property name="missing_td" ormtype="integer" default=0;
	property name="missing_ss" ormtype="integer" default=0;
	property name="inspected_ql" ormtype="string" default="";
	property name="abid" ormtype="integer";
	property name="quantity_accepted" ormtype="integer" default=0;
}