component persistent="true" table="inspection_planning" {
	
	property name="inspection_planningid" ormtype="integer" fieldtype="id" column="inspection_planningid" generator="native" setter="false";
	
	property name="plan_no" ormtype="text" default="";
	property name="name" ormtype="text" default="";
	property name="description" ormtype="text" default="";
 
 	property name="active" ormtype="boolean" default=1;
	property name="lastupdate" ormtype="date" default="";
	property name="updateby" ormtype="string" default="";


    property 
        name="planning_details" singularname="planning_detail" 
        fieldtype="one-to-many" cfc="inspection_planning_detail" fkcolumn="inspection_planningid" 
    ;

}