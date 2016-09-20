component {
	function getMasterData() {
		var mst = "SELECT messages, createddate 
			 FROM user_activity
			 WHERE 	table_type not in('inspection_report', 'purchase_order') 
			 group by username, messages, user_action 
			 order by createddate desc 
			 limit 0, 5";
		return queryExecute(mst);
	}

	function getOrderData() {
		var mst = "SELECT messages, createddate 
			 FROM user_activity
			 WHERE 	table_type in('purchase_order') 
			 group by username, messages, user_action 
			 order by createddate desc 
			 limit 0, 5";
		return queryExecute(mst);
	}

	function getInspectionData() {
		var mst = "SELECT messages, createddate 
			 FROM user_activity
			 WHERE 	table_type in('inspection_report') 
			 group by username, messages, user_action 
			 order by createddate desc 
			 limit 0, 5";
		return queryExecute(mst);
	}
	
}