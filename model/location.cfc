component persistent="true" table="location" {
	//connected locations
	property name="locationid"  		fieldtype="id" column="locationid" generator="native" setter="false";

	property name="locationname" 		ormtype="string" 	default="";
	property name="active" 				ormtype="short" 	default=1;
	property name="lastupdate" 			ormtype="date";
	property name="short_name" 			ormtype="string" 	default="";
	property name="day_shipped_overdue" ormtype="date" 		default=null;
	property name="day_shipped_earlier" ormtype="date" 		default=null;

	property name="is_show" 			ormtype="short" 	default=1;
	property name="updateby" 			ormtype="string" 	default="";
	
	property name="country_code_phone"  ormtype="string";
	property name="country_code_fax"	ormtype="string";
}