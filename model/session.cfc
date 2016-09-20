component persistent="true" {

	property name="id" fieldtype="id" generator="native" setter="false";
    property name="token"             ormType="string"     unique="true"         required="true";
    property name="lang"             ormType="string";
    property name="created_time"    ormtype="timestamp"    sqltype="timestamp" required="true";
    property name="updated_time"    sqltype="timestamp" ormtype="timestamp"    required="true";
    property name="user"             fieldtype="many-to-one" cfc="user"    fkcolumn="id_user" ;
}