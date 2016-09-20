component {

	public function init(){
		return this;
	}
	
	public any function save(struct rc) {
		queryExecute('INSERT INTO order_document (fileName,type,pId,folderName,title,des,createTime)
						VALUES(:fileName,  :type,  :pId,  :folderName,  :title,:des,  :createTime)',
						{fileName:order_document.fileName,pId:order_document.pId,folderName:order_document.folderName,title:order_document.title,des:order_document.des,createTime:NoW()});
	}
	
	
	public any function getorder_DocumentByOrderId(id) {
		var ab = queryToArray(queryExecute('select d.fileName,
												d.folderName,
												d.title,
												d.des,
												d.createTime 
											from order_document d 
											 	where d.pId = :orderId 
											 		and d.`type` = 1 
											 		and d.isActive = 1',{orderId:id}));
		return  ab;
	}

	public function editorder_Document(numeric id, numeric order_id) {
	 	queryExecute('UPDATE order_document SET order_Id = :orderid WHERE id = :ids', {orderid:order_id, ids:id});
	}

	/* public any function getorder_DocumentByType(type) {
		return queryToArray(queryExecute('select d.* from order_document d where d.`type` = :typeTable and d.isActive = 1',{typeTable:type}));
	} */

	public query function deleteorder_Document(id) {
		return queryExecute('delete from order_document where id = :idorder_Document',{idorder_Document:id});
	}

	function getIdCurrent() {
		
		var docId 	= 	queryExecute("select max(id) as id from order_document").id;
		return docId;
	}

	function getListDocByIdOrder(numeric order_Id) {
		sql = "select * from order_document where order_Id =:orderId"
		return queryExecute(sql, {orderId:order_Id});
	}
	
	public function queryToArray(required query inQuery) {
		result = arrayNew(1);
		for(row in inQuery) {
			item = {};
			for(col in queryColumnArray(inQuery)) {
				item[col] = row[col];
			} 
			arrayAppend(result, item);
		}
		return result;
    }
	
}