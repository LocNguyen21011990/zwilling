component {

	function getImportHistory(numeric userid) {
		var paramset ={};
		var sql = "select * from import_history where userId = :userid 
					order by createTime desc limit 10";
		paramset['userid'] = {value=userid, CFSQLType="integer"};
		return queryExecute(sql, paramset);
	}

	function getImportHistoryDetail(numeric importid) {
		var paramset ={};
		var sql = "select imhd.import_detailid as id ,imhd.order_no, imhd.position_no, 1 as ab_no, imhd.productitem_no as product_item_no,
					imhd.quantity as order_qty, imhd.message as reason,imhd.comfirmed_date as confirmed_shipping_date, imhd.status,
					pl.product_line_name_english as product_line,
					pi.product_item_name_english as product_item_name,
					imhd.quantity as ab_qty 
		from import_history_detail imhd 
		left join product_item pi on imhd.productitem_no = pi.product_item_no and pi.active = 1 
		left join product_line pl on pi.product_line_no = pl.product_line_no and pl.active = 1 
		where import_id = :importid";
		paramset['importid'] = {value=importid, CFSQLType="integer"};
		return queryExecute(sql, paramset);
	}

	function getImportHistoryDetailById(numeric detailid) {
		var paramset ={};
		var sql = "select * from import_history_detail imhd 
					where import_detailid = :detailid";
		paramset['detailid'] = {value=detailid, CFSQLType="integer"};
		return queryExecute(sql, paramset);
	}
}