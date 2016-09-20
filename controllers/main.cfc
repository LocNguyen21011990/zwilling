component accessors=true {
	property inspection_scheduleService;
    function default( struct rc ) {
        param name="rc.name" default="anonymous";
    } 
    function inspector( struct rc ) {
         // rc.listSupplier = serializeJSON(inspection_scheduleService.getSupplier());
    } 
}