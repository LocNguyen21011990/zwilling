component {

	function getListByitemno(string itemno) {
		sql = "select path, fileName, lastupdate, product_document_id, type   
			   from product_item_document 
			   where product_item_no = :productItemNo And active = 1";
		paramset['productItemNo'] = {value=itemno, CFSQLType="string"};
		return queryExecute(sql, paramset);
	}
	 function getIdCurrent() {
		
		var docId 	= 	queryExecute("select max(product_document_id) as id from product_item_document").id;
		return docId;
	}
	
	function getListProductItemDocument(){
		return QueryExecute("Select pid.product_item_no,
									pid.fileName,
								    pi.product_item_name_english,
								    pi.product_item_name_german,
								    pid.updateby,
								    pid.path
								 from product_item_document pid
									inner join product_item pi 
									on pi.product_item_no = pid.product_item_no
								where pid.active = 1
								group by pi.product_item_no");
	}

	function getListType() {
		var sql ="select `type` from product_item_document where active =1 group by `type`";
		return queryExecute(sql);
	}

	function getItemDocument(string code) {
		var paramset = {};
		var sql = "select fileName, path, `type`, product_item_no, product_document_id as id, document_type.document_name,
					if(1<3, '', '') as product_segment_id, if(1<3, 1, 1) as docType
					from product_item_document 
					inner join document_type on product_item_document.`type` = document_type.code 
					where active =1 and type = :code";
		paramset['code'] = {value=code, CFSQLType="string"};
		return queryExecute(sql, paramset);
	}

	function getItemDocumentById(numeric id) {
		var paramset = {};
		var sql = "select fileName, path, `type`, product_item_no, product_document_id as id, 
					if(1<3, '', '') as product_segment_id, if(1<3, 1, 1) as docType 
					from product_item_document 
					where active =1 and product_document_id = :product_document_id";
		paramset['product_document_id'] = {value=id, CFSQLType="integer"};
		return queryExecute(sql, paramset);
	}	
	
}