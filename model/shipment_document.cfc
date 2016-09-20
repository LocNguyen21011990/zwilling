component persistent="true" {
	property name="shipment_documentid" fieldtype="id" generator="native" setter="false";
	property name="invoice_date" 					ormtype="timestamp";
	property name="supplier_companyid"				ormtype="integer";
	property name="invoice_no" 						ormtype="string";
	property name="active" 							ormtype="boolean";
	property name="lastupdate" 						ormtype="timestamp";
	property name="updateby" 						ormtype="string";
	property name="is_show" 						ormtype="integer";
	property name="port_loading" 					ormtype="string";
	property name="port_discharge" 					ormtype="string";
	property name="shipping_method" 				ormtype="string";
	property name="awb_nr" 							ormtype="string";
	property name="container_nr" 					ormtype="string";
	property name="bl_nr" 							ormtype="string";
	property name="eta_date" 						ormtype="timestamp";
	property name="shipping_date" 					ormtype="timestamp";
}