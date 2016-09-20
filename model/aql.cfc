component persistent="true" table="aql" {
	
	property name="aqlid" fieldtype="id" generator="native" setter="false";
	property name="average_quality_level" 	ormtype="double" 		default=null;
	property name="min_quantity" 			ormtype="integer" 		default=null;
	property name="max_quantity" 			ormtype="integer" 		default=null;
	property name="inspection_lot" 			ormtype="integer" 		default=null;
	property name="accepted" 				ormtype="integer" 		default=0;
	property name="rejected" 				ormtype="integer" 		default=0;
	property name="active" 					ormtype="integer" 		default=1;
	property name="lastupdate" 				ormtype="date";
	property name="updateby" 				ormtype="string" 		default="";

}