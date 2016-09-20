component persistent="true" {
    property name="import_detailid" fieldtype="id" generator="native" setter="false";
    property name="order_no"      ormtype="string";
    property name="order_date"     ormtype="string";
    property name="customer_no"     ormtype="string";
    property name="supplier_no"     ormtype="string";
    property name="position_no"     ormtype="string";
    property name="productitem_no"     ormtype="string";
    property name="quantity"     ormtype="string";
    property name="unitprice"     ormtype="string";
    property name="currency"     ormtype="string";
    property name="transport"     ormtype="string";
    property name="expected_date"     ormtype="string";
    property name="comfirmed_date"     ormtype="string";
    property name="status"  ormtype="integer" default=0;
    property name="message"     ormtype="string" default="";
    property name="import_id"  ormtype="integer";
}
