component persistent="true" table="image"{

	property name="image_id" 		fieldtype="id" generator="native" setter="false";
	property name="file_name" 		ormtype="string";
    property name="path" 			ormtype="string";
    property name="active"  		ormtype="integer" default=1;
    property name="inspectionid"    ormtype="integer";
    property name="lastupdate"      ormtype="timestamp";
    property name="updateby"        ormType="string";
}