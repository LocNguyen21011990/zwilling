component persistent="true" table="ab" {

	property name="abid" column="abid" fieldtype="id" type="integer" generator="native" setter="false";
	property name="abno" 						ormtype="integer" default=1; 
	property name="expected_shipping_date" 		ormtype="date";
	property name="confirmed_shipping_date" 	ormtype="date";
	property name="positionid" 					ormtype="integer" ;
	property name="shipment_method" 			ormtype="string";
	property name="shipped_quantity" 			ormtype="integer" default=0;
	property name="status" 						ormtype="integer";
	property name="active" 						ormtype="integer" default=1;
	property name="lastupdate" 					ormtype="date";
	property name="updateby" 					ormtype="string" default="rasia";
	property name="shipping_date" 		        ormtype="date";
	property name="ZA_date" 					ormtype="date";
	property name="ETA_date" 					ormtype="date";
	property name="ETD_date" 					ormtype="date";
	property name="relevant_due_date" 			ormtype="date";
	property name="warehouse_book_date" 		ormtype="date";
}