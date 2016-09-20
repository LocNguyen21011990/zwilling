component persistent="true" table="brand" {
	
	property name="brandid" 			ormtype="integer" 		fieldtype="id" generator="native" setter="false";
	property name="brandname" 			ormtype="string" 		default="";
	property name="description" 		ormtype="string" 			default="";
	property name="active" 				ormtype="integer" 		default=1;
	property name="lastupdate" 			ormtype="date";
	property name="updateby" 			ormtype="string" 		default="rasia";
}