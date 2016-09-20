
component extends="framework.one" {
	this.datasource = "zwilling";
	this.ormEnabled = true;
	this.sessionmanagement = true;
    this.sessionTimeout = CreateTimeSpan(1,0,0,0);
    this.sessionStorage = "memory";
 	// function setupApplication() {
	// 	ORMReload();
	// }
	 // function setupRequest( rc ) {    
  //       if ( isJSON( getHttpRequestData().content ) ){
  //               rc.data = deserializeJSON( getHttpRequestData().content );
  //              	//writedump(rc);abort;
  //       }
  //   }
}
