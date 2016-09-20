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

	function search(startdate, enddate) {
		var paramset = {};
		var start_con = '';
		var end_con = '';
		if (startdate != '') {
			start_con = " AND insche.plan_date >= :start ";
			paramset['start'] = {value:startdate, CFSQLType="date"};
		};
		if (enddate != '') {
			end_con = " AND insche.plan_date <= :end ";
			paramset['end'] = {value:enddate, CFSQLType="date"};
		};

		var order_spec =
			"SELECT po.orderid, po.order_no, po.order_date, po.supplier_companyid AS supid, 
					po.buyer_companyid AS cusid, 
					opos.total_price, opos.position_no, opos.ordered_quantity, opos.product_item_no,
					pi.product_item_name_english, p.product_line_name_english,
			        ab.abno, ab.shipped_quantity, ab.expected_shipping_date, ab.confirmed_shipping_date,
			        insport.result, insport.inspectionid, insport.inspection_no,
			        if(insport.quantity_accepted != '', quantity_accepted, 0) as accepted,
                    (ab.shipped_quantity - (select accepted)) as remain,
			        insche.plan_date,insche.inspector1,insche.inspector2, insche.abid, insche.id as inspection_schedule_id  
			FROM 	inspection_schedule insche 
			INNER JOIN 	ab ON ab.abid = insche.abid AND ab.active = 1 " &
					start_con & end_con &
			"INNER JOIN order_position opos ON ab.positionid = opos.positionid AND opos.active = 1 and opos.tmp = 0  
			INNER JOIN 	purchase_order po ON opos.orderid = po.orderid AND po.active = 1 
			LEFT JOIN inspection_report insport ON ab.abid = insport.abid AND insport.active = 1 
			INNER JOIN 	product_item pi ON opos.product_item_no = pi.product_item_no and pi.active = 1  
			INNER JOIN 	product_line p ON pi.product_line_no = p.product_line_no and p.active = 1  
			ORDER BY po.order_date DESC, opos.position_no";
		return queryExecute(order_spec, paramset);
	}

	function getInspection_order( numeric schab, string itemno) {
		var paramset = {};
		var sql = "select 
							insport.inspectionid, insport.inspection_no,insport.missing_td,insport.missing_ss,insport.carton_info,insport.result,insport.comment,insport.seal_from1,insport.seal_to1,insport.seal_from2,insport.seal_to2,
							insport.inspection_date,insport.inspected_quantity as reportqty,isi.id, isi.abid,isi.inspector1, isi.inspector2, isi.plan_date,
							insport.quantity_accepted, insport.is_general_report,
							po.order_no, po.orderid,
							opos.position_no,
							ab.abno, ab.shipped_quantity,
							c.name as customer_name, c.address as customer_address, c.phone as customer_phone, 
							c.fax as customer_fax, c.mail as customer_mail,
							s.name as supplier_name, s.address as supplier_address, s.phone as supplier_phone, 
							s.fax as supplier_fax, s.mail as supplier_mail,
							lc.locationname as location_cus, ls.locationname as location_sup,
							u1.first_name as first_name_inspector1, u1.last_name as last_name_inspector1, 
							u2.first_name as first_name_inspector2, u2.last_name as last_name_inspector2     
							 
					FROM 				
							inspection_schedule isi 
							inner join ab on isi.abid = ab.abid And ab.active = 1 AND ab.abid = :schab 
							inner join order_position opos on ab.positionid = opos.positionid and opos.active = 1 and opos.tmp = 0  
							inner join 	purchase_order po ON opos.orderid = po.orderid AND po.active = 1 
							inner join company c on po.buyer_companyid = c.companyid and c.active = 1  
							inner join company s on po.supplier_companyid = s.companyid and c.active = 1  
							left join inspection_report insport ON ab.abid = insport.abid AND insport.active = 1 and insport.inspected_product_item_no = :itemno 
							left join location lc ON c.locationid = lc.locationid AND lc.active = 1 
							left join location ls ON s.locationid = ls.locationid AND ls.active = 1 
							left join user u1 ON isi.inspector1 = u1.id_user AND u1.is_active = 1 
							left join user u2 ON isi.inspector2 = u2.id_user AND u2.is_active = 1";
							paramset['itemno'] = {value=itemno, CFSQLType="string"};
							paramset['schab'] = {value=schab, CFSQLType="integer"};
		return queryExecute(sql, paramset);
	}
	
	
	
	
	
	//=============================================purchase_order po

	public any function searchByTime(date fDate,date tDate) {
		var result = queryToArray(queryExecute(
					'select isi.id,po.order_no,op.position_no,pt.pattern_item_name_english as product_name,p.brand,c.name as supplier,ps.product_segment_name_english as segment,ab.expected_shipping_date
							,m1.full_name as inspector_name1,m2.full_name  as inspector_name2
					FROM 				
							inspection_schedule isi
							inner join ab on isi.abId = ab.abid and isi.inspection_planDate between :fDate and :tDate
							inner join order_position op on ab.positionid = op.positionid
							inner join purchase_order po on po.orderid = op.orderid
							inner join pattern_item pt on op.ordered_pattern_item = pt.pattern_itemid
							inner join company c on po.supplier_companyid = c.companyid 
							inner join pattern p on pt.pattern_no = p.pattern_no
							inner join product_segment ps on p.product_segment_id = ps.product_segment_id
							left join member m1 on isi.inspector1=m1.memberid
							left join member m2 on isi.inspector1=m2.memberid'
			),{fDate:fDate,tDate});
		return result;

	}

	public any function list() {
		var result = queryToArray(queryExecute(
			'SELECT isi.id,isi.inspection_planDate,isi.inspector1,isi.inspector2,isi.abId,
					po.order_no,op.position_no,pt.pattern_item_name_english as product_name,p.brand,
					c.name as supplier,ps.product_segment_name_english as segment,ab.abno,ab.expected_shipping_date
					,m1.full_name as inspector_name1,m2.full_name  as inspector_name2,
					pt.pattern_itemid,pt.itemid,ab.shipped_quantity,pt.pattern_no
			FROM 				
					inspection_schedule isi
					inner join ab on isi.abId = ab.abid 
					inner join order_position op on ab.positionid = op.positionid
					inner join purchase_order po on po.orderid = op.orderid
					inner join pattern_item pt on op.ordered_pattern_item = pt.pattern_itemid
					inner join company c on po.supplier_companyid = c.companyid 
					inner join pattern p on pt.pattern_no = p.pattern_no
					inner join product_segment ps on p.product_segment_id = ps.product_segment_id
					left join member m1 on isi.inspector1=m1.memberid
					left join member m2 on isi.inspector2=m2.memberid'
			));
		return result;
	}
	public any function search_old(Date frmDate, Date toDate,string supplier_companyid) {
		var paramset = {};
		var condition = ' WHERE 1=1 ';
		var start_con = '';
		var end_con = '';
		if (!isNull(frmDate) and frmDate != '') {
			condition &= " AND isi.inspection_planDate >= :start ";
			paramset['start'] = {value:frmDate, CFSQLType="date"};
		};
		if (!isNull(toDate) and toDate != '') {
			condition &=  " AND isi.inspection_planDate <= :end ";
			paramset['end'] = {value:toDate, CFSQLType="date"};
		};
		if (!isNull(supplier_companyid) and supplier_companyid > 0) {
			condition &=  " AND po.supplier_companyid = :supplier_companyid ";
			paramset['supplier_companyid'] = {value:supplier_companyid, CFSQLType="CF_SQL_INTEGER"};
		};
		var query = 'SELECT isi.id,isi.inspection_planDate,isi.inspector1,isi.inspector2,isi.abId,
					po.order_no,op.position_no,pt.pattern_item_name_english as product_name,p.brand,
					c.name as supplier,ps.product_segment_name_english as segment,ab.abno,
					m1.full_name as inspector_name1,m2.full_name  as inspector_name2,
					pt.pattern_itemid,pt.itemid,ab.shipped_quantity,pt.pattern_no,
					ab.confirmed_shipping_date,op.ordered_quantity
			FROM 				
					inspection_schedule isi
					inner join ab on isi.abId = ab.abid 
					inner join order_position op on ab.positionid = op.positionid
					inner join purchase_order po on po.orderid = op.orderid
					inner join pattern_item pt on op.ordered_pattern_item = pt.pattern_itemid
					inner join company c on po.supplier_companyid = c.companyid 
					inner join pattern p on pt.pattern_no = p.pattern_no
					inner join product_segment ps on p.product_segment_id = ps.product_segment_id
					left join member m1 on isi.inspector1=m1.memberid
					left join member m2 on isi.inspector2=m2.memberid
					'& condition

			;
			result = queryExecute(query,paramset);

		return result;
	}

	public any function getSupplier() {
		return queryExecute('select c.companyid as id, c.name as value from company c where c.company_kind = 2 and c.active =1');
	}

	public any function updateSchedule(required numeric id, numeric inspector1, numeric inspector2,date planDate) {
		queryExecute('Update inspection_schedule SET inspector1 = :inspector1,inspector2 =:inspector2,inspection_planDate=:planDate where id=:id',
						{inspector1=inspector1,inspector2=inspector2,planDate=DateFormat(planDate,'yyyy-mm-dd'),id=id}
			);
	}

	public any function delSchedule(required numeric id) {
		queryExecute('DELETE FROM inspection_schedule where id=:id',{id=id});
	}
	
	
	private function queryToArray(required query inQuery) {
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