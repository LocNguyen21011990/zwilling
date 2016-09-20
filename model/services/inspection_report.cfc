/**
*
* @file  /C/railo/webapps/zwilling/model/services/inspection_report.cfc
* @author  
* @description
*
*/

component output="false" {

	public function init(){
		return this;
	}
	 
	function getMistakeList(numeric product_segment_id) {
		sqlmistake = "SELECT md.mistake_code, md.mistake_description_english, md.characteristic 
					  FROM product_segment_mistake_dictionary psmd 
					  INNER JOIN mistake_dictionary md on psmd.mistake_code = md.mistake_code And md.active = 1 
					  WHERE psmd.product_segment_id =:productSegmentId and psmd.active = 1";
		return queryExecute(sqlmistake, {productSegmentId:product_segment_id});
	}

	function getQualityLevel(ql, quantity) {
		var quality_spec = queryExecute(
			sql : 
				"SELECT ql.quality_level, ql.quality_description,
						ql.major_defect_aql, aa.inspection_lot, 
						aa.accepted AS major_accepted, aa.rejected AS major_rejected,
				        ql.minor_defect_aql, ab.inspection_lot, 
				        ab.accepted AS minor_accepted, ab.rejected AS minor_rejected
				FROM 	ql
				LEFT JOIN aql aa ON ql.major_defect_aql = aa.average_quality_level
				LEFT JOIN aql ab ON ql.minor_defect_aql = ab.average_quality_level
				WHERE 	ql.quality_level = :ql
				AND 	aa.min_quantity <= :quantity AND aa.max_quantity >= :quantity
				AND 	ab.min_quantity <= :quantity AND ab.max_quantity >= :quantity",
			params : { 
				ql : { value=ql, CFSQLType="string" }, 
				quantity : { value=quantity, CFSQLType="integer" } 
			}
		);

		return quality_spec;
	}	

	function checkInspectionNoExist(string inspection_no, numeric inspectionid) {
		var paramset = {};
		var sql ="select * from inspection_report where inspection_no  = :inspection_no";
		paramset["inspection_no"] = {value=inspection_no,  CFSQLType="string"};
		if (isDefined("inspectionid")) {
			sql &= " and inspectionid != :inspectionid";
			paramset["inspectionid"] = {value=inspectionid,  CFSQLType="integer"};
		};
		return queryExecute(sql, paramset);
	}

	function getInspectionNoList() {
		return queryExecute(sql : "SELECT inspection_no FROM inspection_report WHERE active = 1");
	}

	function getEvaluations(struct data) {
		var paramset = {};
		var sql = "SELECT ir.inspectionid,l.locationname,ir.inspection_no,ir.inspection_date,ir.inspected_product_item_no
					,pi.product_item_name_english,ir.result,su.name,ir.inspected_ql
					,op.ordered_quantity,ir.inspected_quantity,sum(irm.number_of_critical_defect)as total_critical_detect
					,sum(irm.number_of_major_defect)as total_major_detect,sum(irm.number_of_minor_defect)as total_minor_detect
					,count(irm.mistake_code) as total_mistake,po.order_no,op.position_no,ab.abno,ir.comment
					,concat(u1.user_name,'-',u2.user_name)as inspector,ir.seal_from1,ir.seal_to1,'singleitemno'
					,ir.seal_from2,ir.seal_to2,su.gildemeisterid,irm.mistake_code   
					FROM inspection_report ir 
					inner join ab on ab.abid = ir.abid and ab.active = 1 and ir.active = 1  
					inner join order_position op on op.positionid = ab.positionid and op.active = 1 and op.tmp = 0  
					inner join purchase_order po on po.orderid = op.orderid and po.active = 1  
					inner join product_item pi on pi.product_item_no = ir.inspected_product_item_no and pi.active = 1  
					inner join product_line pl on pl.product_line_no = pi.product_line_no and pl.active = 1  
					inner join product_segment ps on ps.product_segment_id = pl.product_segment_id and ps.active=1 
					inner join company su on su.companyid = po.supplier_companyid and su.active = 1  
					inner join location l on l.locationid = su.locationid and l.active = 1  
					left join user u1 on u1.id_user = ir.inspector1 and u1.is_active = 1 
					left join user u2 on u2.id_user = ir.inspector2 and u2.is_active = 1 
					left join inspection_report_mistake irm on irm.inspectionid = ir.inspectionid and irm.active = 1  
					where 1 = 1 ";
				if(data.supplier != "")
		        {
		        	sql &= " and su.companyid = :supplier";
		        	paramset['supplier'] = {value=data.supplier, CFSQLType="integer"};
		        }
		        if(data.inspection_date_from != "")
		        {
		        	sql &= " and ir.inspection_date >= :inspection_date_from";
		        	paramset['inspection_date_from'] = {value=DateFormat(data.inspection_date_from, 'yyyy-mm-dd'), CFSQLType="date"};
		        }
		        if(data.inspection_date_to != "")
		        {
		        	sql &= " and ir.inspection_date <= :inspection_date_to";
		        	paramset['inspection_date_to'] = {value=DateFormat(data.inspection_date_to, 'yyyy-mm-dd'), CFSQLType="date"};
		        }
		        if(data.order_no != "")
		        {
		        	sql &= " and po.order_no = :order_no";
		        	paramset['order_no'] = {value=data.order_no, CFSQLType="string"};
		        }
		        if(data.product_segment != "")
		        {
		        	sql &= " and ps.product_segment_id = :product_segment";
		        	paramset['product_segment'] = {value=data.product_segment, CFSQLType="integer"};
		        }
		        if(data.product_line != "")
		        {
		        	sql &= " and pl.product_line_no = :product_line";
		        	paramset['product_line'] = {value=data.product_line, CFSQLType="string"};
		        }
		        if(data.product_item != "")
		        {
		        	sql &= " and pi.product_item_no = :product_item";
		        	paramset['product_item'] = {value=data.product_item, CFSQLType="string"};
		        }
		        if(data.inspection_no != "")
		        {
		        	sql &= " and ir.inspection_no = :inspection_no";
		        	paramset['inspection_no'] = {value=data.inspection_no, CFSQLType="string"};
		        }
		        if(data.inspector != "")
		        {
		        	sql &= " and (ir.inspector1 = :inspector or ir.inspector2 = :inspector)";
		        	paramset['inspector'] = {value=data.inspector, CFSQLType="integer"};
		        }
		        sql &= " group by ir.inspectionid";
		return queryExecute(sql, paramset);
	}
	
	
}