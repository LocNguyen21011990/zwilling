component {

	function getQl(string product_item_no) {
		var sql = "select * from product_item_ql 
					where product_item_no = :productItemNo";
		return queryExecute(sql, {productItemNo:product_item_no});
	}

	function getQlByItemno(string product_item_no) {
		var sql = "select * from product_item_ql 
					where product_item_no = :productItemNo and `default`=1";
		return queryExecute(sql, {productItemNo:product_item_no});
	}
	
	function getProductItenQl(string product_item_no) {
		sql = "select pql.* 
			   from product_item_ql pql 
			   inner join product_item pi on pql.product_item_no = pi.product_item_no And pi.active = 1 
			   where pi.product_item_no = :productItemNo And pql.`default`=1";
		return queryExecute(sql, {productItemNo:product_item_no});
	}
	function getQlList(string product_item_no) {
		var sql = "select ql, `default` as isDefault from product_item_ql 
					where product_item_no = :productItemNo";
		return queryExecute(sql, {productItemNo:product_item_no});
	}
}