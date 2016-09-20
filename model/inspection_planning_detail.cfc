component persistent="true" table="inspection_planning_detail" {
	
	property name="inspection_planning_detailid" ormtype="integer" fieldtype="id" column="inspection_planning_detailid" generator="native" setter="false";
	
	// property name="inspection_planningid" ormtype="integer";
	property name="inspection" ormtype="text" default="";
	property name="hasminor" ormtype="boolean" default=false;
 	property name="hasmajor" ormtype="boolean" default=false;

 	property name="active" ormtype="boolean" default=true;
	property name="lastupdate" ormtype="date" default="";
	property name="updateby" ormtype="string" default="";

	property 
       name="inspection_planning" fieldtype="many-to-one" cfc="inspection_planning" fkcolumn="inspection_planningid" 
    ;
}