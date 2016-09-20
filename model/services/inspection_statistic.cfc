component {
	function getInspectionStatic() {
		var sql = "SELECT round(op.total_price_usd/op.ordered_quantity,2) price,
				   	sum(ab.shipped_quantity * (select price)) ab_qty ,
					sum(ifnull(ir.quantity_accepted,0) * (select price)) ac_qty,
					sum((ab.shipped_quantity-ifnull(ir.quantity_accepted,0)) * (select price)) re_qty,
					ir.inspectionid,
					l.locationname,ir.result,su.name,op.ordered_quantity,ir.inspected_quantity,su.gildemeisterid   
				FROM inspection_report ir 
					inner join ab on ab.abid = ir.abid and ab.active = 1 and ir.active = 1  
					inner join order_position op on op.positionid = ab.positionid and op.active = 1 and op.tmp = 0  
					inner join purchase_order po on po.orderid = op.orderid and po.active = 1  
					inner join company su on su.companyid = po.supplier_companyid and su.active = 1  
					inner join location l on l.locationid = su.locationid and l.active = 1  
				where 1 = 1 group by su.companyid order by su.name";
		return queryExecute(sql);
	}
	
}