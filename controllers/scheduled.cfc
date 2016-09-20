component accessors=true {

    property framework;

    public function update( struct rc ) {
        var timeOut = -24;
        var timeType= "h" ;//hour
        var timeOfdead = dateAdd(timeType, timeOut, now() );
        var timeOutSessions = ormExecuteQuery("from session where updated_time <= ?", [timeOfdead] );
        entityDelete( timeOutSessions );
        VARIABLES.framework.renderData('JSON', "Clean Success!");
    }
}