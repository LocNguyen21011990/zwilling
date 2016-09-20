component persistent="true" {
    property name="import_id" fieldtype="id" generator="native" setter="false";
    property name="createTime"      ormtype="timestamp";
    property name="userId"     ormtype="integer";
    property name="success" ormtype="integer" default=0;
    property name="fail"  ormtype="integer" default=0;
}
