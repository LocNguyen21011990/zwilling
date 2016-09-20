component persistent="true" {
    property name="id_config" fieldtype="id" generator="native" setter="false";
    property name="id_page"     ormtype="integer";
    property name="id_user"     ormtype="integer";
    property name="config" ormtype="text"; 
    property name="act" ormtype="string";
}
