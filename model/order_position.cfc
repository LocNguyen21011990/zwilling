component persistent="true" {
	property name="positionid" fieldtype="id" generator="native" setter="false";

	property name="position_no" 								ormtype="integer";
	property name="ordered_quantity" 							ormtype="integer";
	property name="inspected_quantity" 							ormtype="integer";
	property name="exported_quantity" 							ormtype="integer";	
	property name="orderid" 									ormtype="integer";	
	property name="unit_price" 									ormtype="double";	
	property name="total_price" 								ormtype="double";
	property name="total_price_usd" 							ormtype="double";	
	property name="product_item_no" 							ormtype="string";
	property name="active" 										ormtype="integer" default=1;
	property name="lastupdate" 									ormtype="timestamp" default="";
	property name="updateby" 									ormtype="string" default='rasia';
	property name="tmp" 										ormtype="integer" default=1;
	property name="ql" 											ormtype="string";
}