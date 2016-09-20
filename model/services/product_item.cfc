component {

	function getItems(){
		return queryExecute(" SELECT distinct ps.parent_product_item_no, pi.product_item_no as pcode,
									pi.product_item_name_english as pname,
									pl.product_line_name_english as plinename,
							        b.brandname,
							        pseg.product_segment_name_english as psegname,
							        IF(ISNULL(pql.ql),pl.ql,pql.ql)as ql,
							        ps.active   
	
							FROM product_item pi
								left join product_item_set ps
								 	on ps.parent_product_item_no = pi.product_item_no and pi.active=1 and ps.active = 1 
								left join product_line pl
									on pl.product_line_no = pi.product_line_no and pl.active = 1 
								inner join product_segment pseg
									on pseg.product_segment_id = pl.product_segment_id and pseg.active = 1 
								left join product_item_ql pql
									on pql.product_item_no = pi.product_item_no and pql.default = 1 
								inner join brand b 
									on b.brandid = pl.brandid and b.active = 1 
								");
	}
	function getPLine(){
		return queryExecute("SELECT pl.product_line_name_english as plname,
									pl.product_line_no as plcode,
									pl.ql,
									b.brandid,
									b.brandname,
									ps.product_segment_id,
									ps.product_segment_name_english as psname
							FROM product_line pl
								inner join brand b 
									on b.brandid = pl.brandid and b.active = 1 
								inner join product_segment ps 
									on ps.product_segment_id = pl.product_segment_id and ps.active = 1 
							WHERE pl.active=1
							GROUP BY plname");
	}
	function getPLineByCode( numeric plcode ){
		return queryExecute(sql:"SELECT pl.product_line_name_english as plname,
									pl.product_line_no as plcode,
									pl.ql,
									b.brandid,
									b.brandname,
									ps.product_segment_id,
									ps.product_segment_name_english as psname
							FROM product_line pl
								inner join brand b 
									on b.brandid = pl.brandid
								inner join product_segment ps 
									on ps.product_segment_id = pl.product_segment_id
							WHERE pl.active=1 and pl.product_line_no =:plcode
							GROUP BY plname",
							params:{
								plcode:{ value = plcode, CFSQLType = 'numeric'}
								});
	}
	function getBrand(){
		return queryExecute("SELECT brandid,
									brandname
							FROM brand
							WHERE active=1");
	}
	function getProductSegment(){
		return queryExecute("SELECT product_segment_id as segId,
									product_segment_name_english as segment
							FROM product_segment
							WHERE active=1");
	}




	function getProductItemList(itemno,limit) {
		var paramset = {};
		var items = 
			"SELECT pi.product_item_no, 
					pi.product_item_name_english, 
					p.product_line_name_english 
			FROM 	product_item pi 
			LEFT JOIN product_line p ON pi.product_line_no = p.product_line_no 
			WHERE 	pi.active = 1";

		if (isDefined('itemno') and (len(itemno) > 0)) {
			items &= " AND pi.product_item_no = :number";
			paramset["number"] = {value=itemno,  CFSQLType="varchar"};
		};

		if (isDefined("limit")) {
			items &= " limit :limit";
			paramset["limit"] = {value=limit,  CFSQLType="int"};
		};

		return queryExecute(items, paramset);
	}

	function getQl(string product_item_no) {
		var sql = 
			"SELECT p.ql, p.product_line_name_english, p.product_segment_id, pi.product_item_name_english  
			FROM product_item pi 
			INNER JOIN product_line p ON pi.product_line_no = p.product_line_no 
			WHERE pi.product_item_no = :productItemNo And pi.active=1";
		return queryExecute(sql, {productItemNo:product_item_no});
	}
	
	function getProductItemById(string id) {
		var paramset = {};
		var sql = "SELECT 
						pi.product_item_no,pi.product_item_name_english, pi.product_item_name_german,
						pi.product_line_no, pi.EAN_code as ean_code, pi.shape, pi.colour, pi.size, 
						pl.brandid, pl.product_line_name_english, pl.product_segment_id, if((pql.ql)!='',(pql.ql),pl.ql) as product_item_ql, 
						b.brandname, seg.product_segment_name_english  
					FROM product_item pi 
						left join product_item_set ps on ps.parent_product_item_no = pi.product_item_no and ps.active = 1 
						left join product_line pl on pl.product_line_no = pi.product_line_no and pl.active = 1 
						left join product_item_ql pql on pql.product_item_no = pi.product_item_no and pql.default = 1  
						inner join brand b on pl.brandid = b.brandid and b.active = 1 
						inner join product_segment seg on pl.product_segment_id = seg.product_segment_id and seg.active = 1 
						where pi.product_item_no = :id";
			paramset['id'] = {value=id, CFSQLType="string"};					
		return queryExecute(sql, paramset);
	}

	function getProductItemChil(string product_line_no) {
		var paramset = {};
		var sql = "select product_item_name_english, product_item_no 
					from product_item  
					where product_item_no not in (select distinct parent_product_item_no from product_item_set where active = 1)";
			if(product_line_no != ""){
				sql &= " and product_line_no = :product_line_no 
						group by product_item_no";
				paramset['product_line_no'] = {value=product_line_no, CFSQLType="string"};
			}	
		return queryExecute(sql, paramset);
	}

	function getProductItemNoExist(string itemno){
		var paramset = {};
		var sql = "SELECT pi.product_item_name_english,pl.product_line_name_english FROM product_item pi 
			LEFT JOIN product_line pl on pi.product_line_no = pl.product_line_no 
		 where product_item_no = :itemno and pi.active = 1";
			paramset['itemno'] = {value=itemno, CFSQLType="string"};					
		return queryExecute(sql, paramset);
	}

	function getQlItemExistInOrder(string itemno) {
		var paramset = {};
		var sql = "select pi.product_item_no from product_item pi 
					inner join order_position op on pi.product_item_no = op.product_item_no 
					and op.active = 1 and pi.active = 1 
					where pi.product_item_no = :itemno";
			paramset['itemno'] = {value=itemno, CFSQLType="string"};
		return queryExecute(sql, paramset);
	}
	
	
	
}