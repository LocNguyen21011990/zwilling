component persistent="true" {
    property name="id_user" fieldtype="id" generator="native" setter="false";
    property name="user_name"       ormtype="string";
    property name="first_name"      ormtype="string";
    property name="last_name"       ormtype="string";
    property name="user_password"   ormtype="text";
    property name="last_login"      ormtype="timestamp" default="";
    property name="companyid"       ormtype="integer" ;
    property name="id_role"         ormtype="string";
    property name="email"           ormtype="string";
    property name="user_type"       ormtype="string";
    property name="avatar"          ormtype="string";
    property name="token"           ormtype="string";
    property name="is_active"       ormtype="short" default=1;
}
