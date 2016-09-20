/**
*
* @file  /C/railo/webapps/zwilling/model/services/inspection_schedule.cfc
* @author  
* @description
*
*/

component output="false" displayname=""  {

	public function init(){
		return this;
	}

	function getProductItemSet(numeric id) {
		var sql = "select 
							isi.id, isi.abid, isi.inspector1, isi.inspector2,
							opos.ql,
							ab.shipped_quantity as quantity_ab,
							insport.result, insport.is_general_report,
							insport.inspection_no, DATE_FORMAT(insport.inspection_date, '%d %b %Y') as inspection_date,
							pis.product_item_name_english as product_item_name,
							p.product_line_name_english as product_line,
							ps.quantity as quantity_product_item_set, ps.child_product_item_no as product_item_no,
							if(ps.parent_product_item_no = ps.child_product_item_no, '1', '0') as parent    
					FROM 				
							inspection_schedule isi 
							inner join ab on isi.abid = ab.abid And ab.active = 1 AND isi.id =:id 
							inner join order_position opos on ab.positionid = opos.positionid  
							inner join 	product_item pi ON opos.product_item_no = pi.product_item_no  
							inner join product_item_set ps on pi.product_item_no = ps.parent_product_item_no AND ps.active = 1 
							left join inspection_report insport ON ab.abid = insport.abid AND insport.active = 1 and insport.inspected_product_item_no = ps.child_product_item_no 
							left join 	product_item pis ON ps.child_product_item_no = pis.product_item_no 
							left join 	product_line p ON pis.product_line_no = p.product_line_no 
							";
		return queryExecute(sql, {id:id});
	}

	function getProductItemSetByItemno(string itemno) {
		var sql = "select * from product_item_set 
					where parent_product_item_no = :itemno";
			paramset['itemno'] = {value=itemno, CFSQLType="string"};
		return queryExecute(sql, paramset);
	}
	
	
}