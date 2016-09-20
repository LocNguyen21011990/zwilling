component persistent="true" {
    property name="id_access" fieldtype="id" generator="native" setter="false";
    property name="role"      fieldtype="many-to-one" cfc="role"   fkcolumn="id_role";
    property name="access_page"     fieldtype="many-to-one" cfc="access_page"   fkcolumn="id_access_page";
    property name="view" ormtype="short" default=0;
    property name="edit"  ormtype="short" default=0;
    property name="add"  ormtype="short" default=0;
    property name="delete"  ormtype="short" default=0;
    //property name="access_group"      fieldtype="many-to-one" cfc="access_group"   fkcolumn="id_access_group";
}
