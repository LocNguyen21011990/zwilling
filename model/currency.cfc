component persistent="true"{

	property name="currency_code"  fieldtype="id"		ormtype="string";
	property name="exchange_rate"   					ormtype="double";
	property name="exchange_year"	fieldtype="id"		ormtype="integer";
	property name="lastupdate" 							ormtype="timestamp";
	property name="updateby" 							ormtype="string";
}