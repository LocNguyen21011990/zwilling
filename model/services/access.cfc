component {
	
	function getListPage() {
		sql = "select * from access_page where active = 1 and show = 1";
        return queryAccess = queryExecute(sql);
	}
}