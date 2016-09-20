component persistent="true" {
	property name="product_item_ql_id" fieldtype="id" generator="native" ormtype="integer";
	property name="product_item_no"   			ormtype="string";
	property name="ql"							ormtype="string";	
	property name="from_date" 					ormtype="date";
	property name="to_date" 					ormtype="date";
	property name="default" 					ormtype="integer";
}