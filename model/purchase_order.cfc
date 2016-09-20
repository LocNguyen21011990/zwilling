component persistent="true" accessor="true" {
	property name="orderid" fieldtype="id" generator="native" setter="false";
	property name="order_no" 						ormtype="string";
	property name="supplier_companyid"				ormtype="integer";
	property name="buyer_companyid" 				ormtype="integer";
	property name="inspector_companyid" 			ormtype="integer";
	property name="order_date" 						ormtype="timestamp";
	property name="order_formula_path" 				ormtype="string";
	property name="active" 							ormtype="integer" default=1;
	property name="lastupdate" 						ormtype="timestamp" ;
	property name="updateby" 						ormtype="string"default='rasia';
	property name="is_sap" 							ormtype="boolean";
	property name="currency" 						ormtype="string"; 
}