component persistent="true" table="email" {
	property name="emailid" ormtype="integer" fieldtype="id" column="emailid" generator="native" setter="false";
	property name="email" ormtype="string" default="";
}