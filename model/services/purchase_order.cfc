/* @author : duy */

component {

	function getOrderSearch(string startdate,string enddate, numeric finish) {
		var paramset = {};
		var start_con = '';
		var end_con = '';
		var finish_con = '';
		if (startdate != '') {
			start_con = " AND po.order_date >= :start ";
			paramset['start'] = {value:startdate, CFSQLType="date"};
		};
		if (enddate != '') {
			end_con = " AND po.order_date <= :end ";
			paramset['end'] = {value:enddate, CFSQLType="date"};
		};
		if(finish == 1){
			finish_con = " HAVING ab.shipped_quantity != ifnull((sum(insport.quantity_accepted)),0) ";
		}
		if(finish == 0){
			finish_con = " HAVING ab.shipped_quantity = ifnull((sum(insport.quantity_accepted)),0) ";
		}
		var order_spec =
			"SELECT po.orderid, po.order_no, po.order_date, po.supplier_companyid AS supid, 
					po.buyer_companyid AS cusid, 
					(ab.shipped_quantity*opos.unit_price) as total_price, opos.position_no, opos.ordered_quantity, opos.product_item_no,
					pi.product_item_name_english, p.product_line_name_english,
			        ab.abno, ab.shipped_quantity, ab.expected_shipping_date, ab.confirmed_shipping_date,
			        insport.result,
			        if(sum(insport.quantity_accepted) != '', sum(insport.quantity_accepted), 0) as accepted,
                  (ab.shipped_quantity - ifnull((sum(insport.quantity_accepted)),0)) as remain  
			FROM 	purchase_order po 
			INNER JOIN 	order_position opos ON po.orderid = opos.orderid AND po.active = 1 AND opos.active = 1 AND opos.tmp = 0 " &
					start_con & end_con &
			"INNER JOIN ab ON opos.positionid = ab.positionid AND ab.active = 1  
			LEFT JOIN inspection_report insport ON ab.abid = insport.abid AND insport.active = 1 
			INNER JOIN 	product_item pi ON opos.product_item_no = pi.product_item_no AND pi.active = 1  
			INNER JOIN 	product_line p ON pi.product_line_no = p.product_line_no AND p.active = 1 GROUP BY ab.abid "
			&finish_con&
			"ORDER BY po.order_date DESC, opos.position_no";
		return queryExecute(order_spec, paramset);
	}

	function getTransportList() { 
		var paramset = {};
		var stransport ="select method from shipment_method where active = 1";
		return queryExecute(stransport);
	}

	function getOrderByOrderno(string order_no) {
		var sql = "select orderid from purchase_order where order_no = :order_no";
		paramset['order_no'] = {value=order_no, CFSQLType="string"};
		return queryExecute(sql, paramset);
	}
	
	function checkOrderNoEdit(orderid, orderno) {
		var paramset = {};
		var orders =
			"SELECT po.orderid, po.order_no, po.order_date, po.active,
					c1.gildemeisterid AS supplier, 
					c2.gildemeisterid AS customer, 
					c3.gildemeisterid AS inspector 
			FROM 	purchase_order po 
			LEFT JOIN company c1 ON po.supplier_companyid = c1.companyid 
			LEFT JOIN company c2 ON po.buyer_companyid = c2.companyid
			LEFT JOIN company c3 ON po.inspector_companyid = c3.companyid
			WHERE 	po.active = 1 ";

		if (orderid != 0) {

			orders &= " AND po.orderid != :orderid";
			paramset['orderid'] = {value=orderid, CFSQLType="integer"};
		};

		if (orderno != "") {

			orders &= " AND po.order_no = :orderno";
			paramset['orderno'] = {value=orderno, CFSQLType="string"};
		};

		return queryExecute(orders, paramset);
	}

	function getOrder(orderid, orderno) {
		var paramset = {};
		var orders =
			"SELECT po.orderid, po.order_no, DATE_FORMAT(po.order_date, '%d-%b-%Y') as order_date,
					c1.companyid AS supplier_id, 
					c2.companyid AS customer_id, 
					po.currency,
					c3.gildemeisterid AS inspector 
			FROM 	purchase_order po 
			LEFT JOIN company c1 ON po.supplier_companyid = c1.companyid 
			LEFT JOIN company c2 ON po.buyer_companyid = c2.companyid
			LEFT JOIN company c3 ON po.inspector_companyid = c3.companyid
			WHERE 	po.active = 1 ";

		if (orderid != 0) {

			orders &= " AND po.orderid = :orderid";
			paramset['orderid'] = {value=orderid, CFSQLType="integer"};
		};

		if (orderno != "") {

			orders &= " AND po.order_no = :orderno";
			paramset['orderno'] = {value=orderno, CFSQLType="string"};
		};

		return queryExecute(orders, paramset);
	}

	function getPosition(posid, orderid) {
		var paramset = {};
		var positions =
			"SELECT opos.active, opos.orderid, opos.positionid, opos.position_no,  
					opos.product_item_no, opos.ordered_quantity, opos.inspected_quantity, 
					opos.exported_quantity, opos.unit_price,opos.total_price,
					DATE_FORMAT(ab.shipping_date, '%d-%b-%Y') as shipping_date,
					DATE_FORMAT(ab.ZA_date, '%d-%b-%Y') as za_date,
					DATE_FORMAT(ab.ETA_date, '%d-%b-%Y') as eta_date,
					DATE_FORMAT(ab.relevant_due_date, '%d-%b-%Y') as relevant_due_date,
					DATE_FORMAT(ab.warehouse_book_date, '%d-%b-%Y') as warehouse_book_date,
					ab.abno, opos.position_no, DATE_FORMAT(ab.confirmed_shipping_date, '%d-%b-%Y') as confirmed_shipping_date,
					ab.shipment_method, DATE_FORMAT(ab.expected_shipping_date, '%d-%b-%Y') as expected_shipping_date, ab.shipped_quantity,
					pi.product_item_name_english,
					p.product_line_name_english 
			FROM 	order_position opos 
			JOIN 	product_item pi ON opos.product_item_no = pi.product_item_no 
			LEFT JOIN product_line p ON pi.product_line_no = p.product_line_no 
			LEFT JOIN ab on ab.positionid = opos.positionid ";

		if (posid != 0) {
			positions &= " WHERE opos.positionid = :posid";
			paramset['posid'] = {value=posid, CFSQLType="integer"};
		};

		if (orderid != 0) {
			positions &= ( find("WHERE", positions) ? " AND " : " WHERE ") & "opos.orderid = :orderid";
			paramset['orderid'] = {value=orderid, CFSQLType="integer"};
		};

		return queryExecute(positions, paramset);
	}

	function getIdPositionByOrderId(numeric orderid) {
		sql = "select opos.positionid, opos.product_item_no, opos.position_no, 
		opos.ordered_quantity, opos.unit_price, opos.total_price, opos.ql,
		pi.product_item_name_english,
		p.product_line_name_english  
		from order_position opos 
		JOIN product_item pi ON opos.product_item_no = pi.product_item_no 
		LEFT JOIN product_line p ON pi.product_line_no = p.product_line_no 
		 
		where opos.orderid = :orderid";
		paramset['orderid'] = {value=orderid, CFSQLType="integer"};
		return queryExecute(sql, paramset);
	}

	function getAbByPositionId(numeric positionid) {
		sql = "select 
					DATE_FORMAT(ab.shipping_date, '%d-%b-%Y') as shipping_date,
					DATE_FORMAT(ab.ZA_date, '%d-%b-%Y') as za_date,
					DATE_FORMAT(ab.ETA_date, '%d-%b-%Y') as eta_date,
					DATE_FORMAT(ab.relevant_due_date, '%d-%b-%Y') as relevant_due_date,
					DATE_FORMAT(ab.warehouse_book_date, '%d-%b-%Y') as warehouse_book_date,
					DATE_FORMAT(ab.ETD_date, '%d-%b-%Y') as etd_date,
					ab.abid, ab.abno, DATE_FORMAT(ab.confirmed_shipping_date, '%d-%b-%Y') as confirmed_shipping_date,
					ab.shipment_method, DATE_FORMAT(ab.expected_shipping_date, '%d-%b-%Y') as expected_shipping_date, ab.shipped_quantity,
					insp.id 
		from ab 
		join inspection_schedule insp ON ab.abid = insp.abid  
		where positionid = :positionid";
		paramset['positionid'] = {value=positionid, CFSQLType="integer"};
		return queryExecute(sql, paramset);
	}

	function getPositionList(posid) {
		var paramset = {};
		var positions =
			"SELECT opos.active, opos.orderid, opos.positionid, opos.position_no,  
					opos.product_item_no, opos.ordered_quantity, opos.inspected_quantity, 
					opos.exported_quantity, opos.unit_price,opos.total_price,
					ab.abno, opos.position_no, ab.confirmed_shipping_date,
					ab.shipment_method, ab.expected_shipping_date,ab.shipped_quantity,
					pi.product_item_name_english,
					p.product_line_name_english 
			FROM 	order_position opos
			JOIN 	product_item pi ON opos.product_item_no = pi.product_item_no 
			LEFT JOIN product_line p ON pi.product_line_no = p.product_line_no 
			LEFT JOIN ab on ab.positionid = opos.positionid 
			WHERE opos.positionid in ("&posid&")";
			//paramset['posid'] = {value=posid, CFSQLType="string"};
		return queryExecute(positions);
	}

	function getPositionDelete(posid, orderid) {
		var paramset = {};
		var positions =
			"SELECT ab.abid, ins.id, opos.tmp  
			FROM 	order_position opos
			JOIN 	product_item pi ON opos.product_item_no = pi.product_item_no
			LEFT JOIN product_line p ON pi.product_line_no = p.product_line_no
			LEFT JOIN ab on ab.positionid = opos.positionid
			LEFT JOIN inspection_schedule ins on ab.abid = ins.abid";

		if (posid != 0) {
			positions &= " WHERE opos.positionid = :posid";
			paramset['posid'] = {value=posid, CFSQLType="integer"};
		};

		if (orderid != 0) {
			positions &= ( find("WHERE", positions) ? " AND " : " WHERE ") & "opos.orderid = :orderid";
			paramset['orderid'] = {value=orderid, CFSQLType="integer"};
		};

		return queryExecute(positions, paramset);
	}

	function getAB(abid, posid) {
		var paramset = {};
		var abs = 
			"SELECT ab.active, ab.abid AS id, ab.abno AS no, ab.positionid, ab.is_exported,
					ab.shipped_quantity, ab.shipping_date, ab.required_ship_date,
					ab.expected_shipping_date, ab.confirmed_shipping_date, ab.relevant_due_date
			FROM 	ab
			WHERE 	ab.active = 1";

		if (abid != 0) {

			abs &= " AND ab.abid = :abid";
			paramset['abid'] = {value=abid, CFSQLType="integer"};
		};

		if (posid != 0) {

			abs &= " AND ab.positionid = :posid";
			paramset['posid'] = {value=posid, CFSQLType="integer"};
		};

		return queryExecute(abs, paramset);
	}

	function getProductItem(itemno, itemname) {
		var paramset = {};
		var items = 
			"SELECT pi.product_item_no, 
					pi.product_item_name_english, 
					p.product_line_name_english 
			FROM 	product_item pi 
			LEFT JOIN product_line p ON pi.product_line_no = p.product_line_no 
			WHERE 	pi.active = 1";

		if (itemno != "") {
			items &= " AND pi.product_item_no LIKE :itemno";
			paramset['itemno'] = {value='%'&itemno&'%', CFSQLType="string"};
		};

		if (itemname != "") {
			items &= " AND pi.product_item_name_english LIKE :itemname";
			paramset['itemname'] = {value='%'&itemname&'%', CFSQLType="string"};
		};

		return queryExecute(items, paramset);
	}

	function getCompany(gid, kind) {
		var paramset = {};
		var companies = 
			"SELECT c.companyid, c.gildemeisterid, c.`name`, c.address, l.locationname AS country, 
					c.mail, c.contact_person, c.phone, c.fax, c.abbreviation_name, c.gildemeisterid 
			FROM 	company c
			LEFT JOIN location l ON c.locationid = l.locationid
			WHERE 	c.active = 1
			AND 	c.gildemeisterid != 0 
			AND 	c.gildemeisterid IS NOT NULL";

		if (gid != "") {
			companies &= " AND c.gildemeisterid = :gid";
			paramset['gid'] = {value=gid, CFSQLType="string"};
		};

		if (kind != 0) {
			companies &= " AND c.company_kind = :kind";
			paramset['kind'] = {value=kind, CFSQLType="integer"};
		};

		return queryExecute(companies, paramset);
	}

	function getOrderNoList() {
		return queryExecute(sql : "SELECT order_no FROM purchase_order WHERE active = 1");
	}

	function getEvaluationOrder(struct data) {
		var paramset = {};
		var sql = "select su.gildemeisterid as su_no,su.name as su_name,cu.name as cu_name,po.order_no,op.position_no
					,op.product_item_no,pi.product_item_name_english,ps.product_segment_name_english,br.brandname
					,pl.product_line_name_english,po.order_date,ab.expected_shipping_date as request_delivery_date
					,ab.ZA_date,ab.confirmed_shipping_date as confirmed_delivery_date,ab.relevant_due_date
					,op.ordered_quantity as confirmed_quantity,'2016-01-01'as etd_date,ab.shipped_quantity
					,op.unit_price,po.currency,(ab.shipped_quantity*op.unit_price)as shipped_value,ab.ETA_date  
					from purchase_order po 
					inner join order_position op on op.orderid = po.orderid and op.active = 1 and op.tmp = 0   
					inner join ab on ab.positionid = op.positionid and ab.active = 1  
					inner join product_item pi on pi.product_item_no = op.product_item_no and pi.active = 1  
					inner join product_line pl on pl.product_line_no = pi.product_line_no and pl.active = 1  
					inner join product_segment ps on ps.product_segment_id = pl.product_segment_id and ps.active=1 
					inner join brand br on br.brandid = pl.brandid and br.active=1 
					inner join company cu on cu.companyid = po.buyer_companyid and cu.active=1 
					inner join company su on su.companyid = po.supplier_companyid and su.active=1 
					where po.active = 1 ";
				if(data.supplier != "")
		        {
		        	sql &= " and su.companyid = :supplier";
		        	paramset['supplier'] = {value=data.supplier, CFSQLType="integer"};
		        }

		        if(data.customer != "")
		        {
		        	sql &= " and cu.companyid = :customer";
		        	paramset['customer'] = {value=data.customer, CFSQLType="integer"};
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
		        if(data.confirmed_shipping_date_from != "")
		        {
		        	sql &= " and ab.confirmed_shipping_date >= :confirmed_shipping_date_from";
		        	paramset['confirmed_shipping_date_from'] = {value=DateFormat(data.confirmed_shipping_date_from, 'yyyy-mm-dd'), CFSQLType="date"};
		        }
		        if(data.confirmed_shipping_date_to != "")
		        {
		        	sql &= " and ab.confirmed_shipping_date <= :confirmed_shipping_date_to";
		        	paramset['confirmed_shipping_date_to'] = {value=DateFormat(data.confirmed_shipping_date_to, 'yyyy-mm-dd'), CFSQLType="date"};
		        }
		        if(data.etd_date_from != "")
		        {
		        	sql &= " and ab.ETD_date >= :etd_date_from";
		        	paramset['etd_date_from'] = {value=DateFormat(data.etd_date_from, 'yyyy-mm-dd'), CFSQLType="date"};
		        }
		        if(data.etd_date_to != "")
		        {
		        	sql &= " and ab.ETD_date <= :etd_date_to";
		        	paramset['etd_date_to'] = {value=DateFormat(data.etd_date_to, 'yyyy-mm-dd'), CFSQLType="date"};
		        }
		return queryExecute(sql, paramset);
	}

	function getInspectionCalendar(string startDate, string endDate) {
		var sql = "select pi.product_item_name_english, ab.shipped_quantity, 
					ins.plan_date, ins.inspector1, ins.inspector2, po.supplier_companyid, 
					s.locationid, pl.product_line_name_english, inspec.inspection_no            
					from inspection_schedule ins 
					inner join ab on ins.abid = ab.abid and ab.active = 1 
					inner join order_position op on ab.positionid = op.positionid and op.active = 1 and op.tmp = 0 
					inner join purchase_order po on op.orderid = po.orderid and po.active = 1  
					inner join product_item pi on op.product_item_no = pi.product_item_no and pi.active = 1 
					inner join product_line pl on pi.product_line_no = pl.product_line_no and pl.active = 1 
					inner join company s on po.supplier_companyid = s.companyid and s.active = 1 
					left join inspection_report inspec on ab.abid = inspec.abid and inspec.active = 1 
					where ins.plan_date >= :startDate 
					and ins.plan_date <= :endDate 

					";
					//and ab.abid not in (select distinct abid from inspection_report where active = 1)
		    paramset['startDate'] = {value=DateFormat(startDate, 'yyyy-mm-dd'), CFSQLType="date"};
		    paramset['endDate'] = {value=DateFormat(endDate, 'yyyy-mm-dd'), CFSQLType="date"};
		return queryExecute(sql, paramset);
	}

	function getOrderInspection(string startDate, string endDate) {
		var sql = "select pi.product_item_name_english, ab.shipped_quantity, ins.plan_date, 
					po.supplier_companyid, pl.product_segment_id, s.locationid, pl.product_line_name_english, inspec.inspection_no          
					from inspection_schedule ins 
					inner join ab on ins.abid = ab.abid and ab.active = 1 
					inner join order_position op on ab.positionid = op.positionid and op.active = 1 and op.tmp = 0 
					inner join purchase_order po on op.orderid = po.orderid and po.active = 1  
					inner join product_item pi on op.product_item_no = pi.product_item_no and pi.active = 1 
					inner join product_line pl on pi.product_line_no = pl.product_line_no and pl.active = 1  
					inner join company s on po.supplier_companyid = s.companyid and s.active = 1  
					left join inspection_report inspec on ab.abid = inspec.abid and inspec.active = 1 
					where ins.plan_date >= :startDate 
					and ins.plan_date <= :endDate 
					
					";
					//and ab.abid not in (select distinct abid from inspection_report where active = 1)
		    paramset['startDate'] = {value=DateFormat(startDate, 'yyyy-mm-dd'), CFSQLType="date"};
		    paramset['endDate'] = {value=DateFormat(endDate, 'yyyy-mm-dd'), CFSQLType="date"};
		return queryExecute(sql, paramset);
	}

	function getOrderDelivery(string startDate, string endDate) {
		var sql = "select pi.product_item_name_english, ab.shipped_quantity, ab.confirmed_shipping_date, 
					po.supplier_companyid, pl.product_segment_id, s.locationid, pl.product_line_name_english, inspec.inspection_no         
					from ab 
					inner join order_position op on ab.positionid = op.positionid and op.active = 1 and op.tmp = 0 and ab.active = 1 
					inner join purchase_order po on op.orderid = po.orderid and po.active = 1 
					inner join product_item pi on op.product_item_no = pi.product_item_no and pi.active = 1   
					inner join product_line pl on pi.product_line_no = pl.product_line_no and pl.active = 1 
					inner join company s on po.supplier_companyid = s.companyid and s.active = 1 
					left join inspection_report inspec on ab.abid = inspec.abid and inspec.active = 1 
					where ab.confirmed_shipping_date >= :startDate  
					and ab.confirmed_shipping_date <= :endDate 
					";
					//and ab.abid not in (select distinct abid from inspection_report where active = 1)
		    paramset['startDate'] = {value=DateFormat(startDate, 'yyyy-mm-dd'), CFSQLType="date"};
		    paramset['endDate'] = {value=DateFormat(endDate, 'yyyy-mm-dd'), CFSQLType="date"};
		return queryExecute(sql, paramset);
	}

	function getOrderChartTotal(string start_chart, string end_chart, numeric supplier, numeric segment, numeric location) {
		var paramset = {};
		var sql = "select sum(op.total_price_usd) as total_price_usd          
					from purchase_order po  
					inner join order_position op on po.orderid = op.orderid and op.active = 1 and op.tmp = 0 and po.active = 1  
					inner join product_item pi on op.product_item_no = pi.product_item_no and pi.active = 1 
					inner join product_line pl on pi.product_line_no = pl.product_line_no and pl.active = 1  
					inner join company s on po.supplier_companyid = s.companyid and s.active = 1  
					where (select order_date) >= :start_chart  
					and (select order_date) <= :end_chart"; 
					if(supplier != 0){
						sql &= " and po.supplier_companyid = :supplier";
						paramset['supplier'] = {value=supplier, CFSQLType="integer"};
					}
					if(segment != 0){
						sql &= " and pl.product_segment_id = :segment";
						paramset['segment'] = {value=segment, CFSQLType="integer"};
					}
					if(location != 0){
						sql &= " and s.locationid = :location";
						paramset['location'] = {value=location, CFSQLType="integer"};
					}	
		    paramset['start_chart'] = {value=DateFormat(start_chart, 'yyyy-mm-dd'), CFSQLType="date"};
		    paramset['end_chart'] = {value=DateFormat(end_chart, 'yyyy-mm-dd'), CFSQLType="date"};
		return queryExecute(sql, paramset);
	}
	
	function getOrderChart(numeric type, string start_chart, string end_chart) {
		var paramset = {};
		var sql = "select pl.product_line_name_english, sum(op.total_price_usd) as total_price_usd,
					po.supplier_companyid, pl.product_segment_id, s.locationid, s.name,
					DATE_FORMAT(po.order_date, '%d-%b-%Y') as order_date           
					from purchase_order po  
					inner join order_position op on po.orderid = op.orderid and op.active = 1 and op.tmp = 0 and po.active = 1  
					inner join product_item pi on op.product_item_no = pi.product_item_no and pi.active = 1 
					inner join product_line pl on pi.product_line_no = pl.product_line_no and pl.active = 1  
					inner join company s on po.supplier_companyid = s.companyid and s.active = 1  
					where (select order_date) >= :start_chart  
					and (select order_date) <= :end_chart 
					";
			if(type == 1){
				sql &= " group by pl.product_line_name_english";
				sql &= " order by total_price_usd DESC limit 0,5 ";
			}
			if(type == 2){
				sql &= " group by po.supplier_companyid";
				sql &= " order by total_price_usd DESC limit 0,5 ";
			}
			if(type == 3){
				sql &= " group by YEAR(order_date), MONTH(order_date)";
				sql &= " order by po.order_date asc";
			}
			
		    paramset['start_chart'] = {value=DateFormat(start_chart, 'yyyy-mm-dd'), CFSQLType="date"};
		    paramset['end_chart'] = {value=DateFormat(end_chart, 'yyyy-mm-dd'), CFSQLType="date"};
		return queryExecute(sql, paramset);
	}

	function checkPositionNo(numeric orderid, string position_no){
		var paramset ={};
		var sql = "select * from order_position where orderid = :orderid and position_no = :position_no";
		paramset['orderid'] = {value=orderid, CFSQLType="integer"};
		paramset['position_no'] = {value=position_no, CFSQLType="string"};
		return queryExecute(sql, paramset);
	}
	
}
