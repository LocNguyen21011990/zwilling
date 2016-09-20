component {

	function getListByproductSegmentId(numeric product_segment_id) {
		var paramset = {};
		var sql = "select path, fileName, createtime as lastupdate    
			   from product_segment_document 
			   where product_segment_id = :product_segment_id";
		paramset['product_segment_id'] = {value=product_segment_id, CFSQLType="integer"};
		return queryExecute(sql, paramset);
	}

	function getProductSegmentByPSId(numeric product_segment_id) {
		var paramset = {};
		var sql = "select segment_document_id, `type`, fileName, path from product_segment_document 
					where product_segment_id = :psi";
		paramset['psi'] = {value=product_segment_id, CFSQLType="integer"};
		return queryExecute(sql, paramset);
	}
	
	function getListType(param) {
		var sql = "select `type` from product_segment_document  
					group by `type`";
		return queryExecute(sql);
	}

	function getSegmentDocument(string code) {
		var paramset = {};
		var sql = "select fileName, path, `type`, if(1<3, '', '') as product_item_no, segment_document_id as id, 
		 			document_type.document_name,
					product_segment_id, if(1<3, 2, 2) as docType
					from product_segment_document 
					inner join document_type on product_segment_document.`type` = document_type.code 
					where type = :code";
		paramset['code'] = {value=code, CFSQLType="string"};
		return queryExecute(sql, paramset);
	}

	function getSegmentDocumentById(numeric id) {
		var paramset = {};
		var sql = "select fileName, path, `type`, if(1<3, '', '') as product_item_no, segment_document_id as id, 
					product_segment_id, if(1<3, 2, 2) as docType  
					from product_segment_document 
					where segment_document_id = :segment_document_id";
		paramset['segment_document_id'] = {value=id, CFSQLType="integer"};
		return queryExecute(sql, paramset);
	}	
}