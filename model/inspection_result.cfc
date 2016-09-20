component persistent="false" table="inspection_result" {
	//valid inspection results
	property name="inspection_result_description" ormtype="string" default="";
	property name="active" ormtype="integer" default=1;
	property name="lastupdate" ormtype="date" default="";
	property name="updateby" ormtype="string" default="";
}