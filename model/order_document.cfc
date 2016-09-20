component persistent="true" {

    property name="id" fieldtype="id" generator="native" setter="false";

    property name="order_Id"		ormtype="integer";
    property name="fileName"        ormtype="string";
    property name="path"            ormType="string";
    property name="updateBy"		ormType="string";
    property name="createTime" 		ormtype="datetime";
    
}
