component persistent="true" table="inspection_report_mistake" {

	property name="inspection_mistake_id" fieldtype="id" generator="native" setter="false";
	property name="inspectionid" ormtype="integer" default=0;
	property name="mistake_code" ormtype="string" ;
	property name="number_of_critical_defect" ormtype="integer" default=0;
	property name="number_of_major_defect" ormtype="integer" default=0;
	property name="number_of_minor_defect" ormtype="integer" default=0;
	property name="number_of_notice" ormtype="integer" default=0;

	property name="active" ormtype="short" default=1;
	property name="lastupdate" ormtype="date";
	property name="updateby" ormtype="string" default="";
}