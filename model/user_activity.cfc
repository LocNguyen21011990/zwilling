component persistent="true" {
    property name="id" fieldtype="id" generator="native" setter="false";
    property name="username" ormtype="string";
    property name="messages" ormtype="string";
    property name="user_action" ormtype="string";
    property name="createddate" ormtype="timestamp"    sqltype="timestamp";
    property name="table_type" ormtype="string";
}
