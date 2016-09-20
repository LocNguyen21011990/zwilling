component persistent="false" table="config_services" {

	property name="configid" 		ormtype="integer";
	property name="hostname_ftp" 	ormtype="string" ;
	property name="port_ftp" 		ormtype="integer" ;
	property name="username_ftp" 	ormtype="string" ;
	property name="password_ftp" 	ormtype="string" ;

	property name="folder_out_ftp" 	ormtype="string" ;
	property name="folder_in_ftp" 	ormtype="string" ;
	property name="folder_backup_ftp" 	ormtype="string" ;
	property name="maxfile" 		ormtype="integer" ;
	property name="deletefile" 		ormtype="integer" ;
	property name="delay" 			ormtype="integer" ;

	property name="filelogpath" 	ormtype="string" ;
	property name="filelogname" 	ormtype="string" ;
	property name="folder_temp_local" 	ormtype="string" ;
	property name="folder_in_log_ftp" 	ormtype="string" ;
	property name="mail_server" 	ormtype="string" ;

	property name="active" 			ormtype="short" ;
	property name="lastupdate" 		ormtype="date" ;
	property name="updateby" 		ormtype="string" ;
}