/* @author : duy */

component {

	function getCompanyById(gid, kind) {
		var paramset = {};
		var companies = 
			"SELECT c.companyid, c.abbreviation_name, c.`name`, c.address, c.locationid, 
			c.country_code_phone, c.phone, c.country_code_fax, c.fax, c.company_kind,
					c.mail, c.contact_person, c.gildemeisterid  
			FROM 	company c 
			WHERE 	c.active = 1 "

		if (gid != "") {
			companies &= " AND c.companyid = :gid";
			paramset['gid'] = {value=gid, CFSQLType="integer"};
		};

		if (kind != 0) {
			companies &= " AND c.company_kind = :kind";
			paramset['kind'] = {value=kind, CFSQLType="integer"};
		};
		companies &= " order by c.`name` asc";
		return queryExecute(companies, paramset);
	}


	function getLocationList() { 
		sql = "select locationid, locationname, country_code_phone, country_code_fax 
				from location 
				where active = 1 
				order by locationname asc"; 
		return queryExecute(sql);
	}
	
	function getCompanyList() {
		sql = "select c.name, c.abbreviation_name, l.locationname, c.address, c.mail,
			  c.contact_person, c.phone, c.fax, c.companyid, c.gildemeisterid    
			  from company c 
			  inner join location l on c.locationid = l.locationid And l.active = 1 
			  where c.active = 1"
		return queryExecute(sql);
	}


	function getEvaluationSupplier(struct data) {
		var paramset = {};
		var sql = "select su.gildemeisterid as su_no,su.name as su_name,sum((ab.shipped_quantity*op.unit_price)) as shipped_value, po.currency 
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
		        sql &= " group by su.gildemeisterid, po.currency"
		return queryExecute(sql, paramset);
	}

	function getBilitySupplier(struct data) {
		var paramset = {};
		var sql = "select su.gildemeisterid as su_no,su.name as su_name,cu.name as cu_name,po.order_no,op.position_no,op.product_item_no,pi.product_item_name_english,ps.product_segment_name_english,br.brandname,pl.product_line_name_english,po.order_date,ab.expected_shipping_date as request_delivery_date,ab.ZA_date,ab.confirmed_shipping_date as confirmed_delivery_date,ab.relevant_due_date,op.ordered_quantity as confirmed_quantity,'2016-01-01'as etd_date,ab.shipped_quantity,op.unit_price,po.currency,(ab.shipped_quantity*op.unit_price)as shipped_value,ab.ETA_date,if('2016-01-01'>ab.relevant_due_date,DATEDIFF('2016-01-01',ab.relevant_due_date),0)as days_of_delay,if('2016-01-01'<ab.relevant_due_date,DATEDIFF(ab.relevant_due_date,'2016-01-01'),0)as days_of_earlier_shipment,if((select days_of_delay)>7 or (select days_of_earlier_shipment)>7,'no','yes') as delivered_in_time,(select shipped_value)as due_value,if((select delivered_in_time)='yes',(select shipped_value),0)as value_shipped_in_time,round(((select value_shipped_in_time)/(select due_value)*100),2) as percent_shipped_in_time 
		from purchase_order po 
		inner join order_position op on op.orderid = po.orderid 
		and op.active = 1 and op.tmp = 0 
		inner join ab on ab.positionid = op.positionid 
		and ab.active = 1 
		inner join product_item pi on pi.product_item_no = op.product_item_no 
		and pi.active = 1 
		inner join product_line pl on pl.product_line_no = pi.product_line_no 
		and pl.active = 1 
		inner join product_segment ps on ps.product_segment_id = pl.product_segment_id 
		and ps.active=1 
		inner join brand br on br.brandid = pl.brandid 
		and br.active=1 
		inner join company cu on cu.companyid = po.buyer_companyid 
		and cu.active=1 inner join company su on su.companyid = po.supplier_companyid 
		and su.active=1 where po.active = 1 ";
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
		        sql &= " group by su.gildemeisterid, po.currency"
		return queryExecute(sql, paramset);
	}

	function getCompanyByCompanyNo(string companyno, numeric kind, numeric id) {
		var paramset={};
		var sql = "select * from company 
		where gildemeisterid = :companyno and company_kind = :kind and active = 1 ";
		if(id != 0){
			sql &= " and companyid != :id"
		}
		paramset['id'] = {value=id, CFSQLType="integer"};
		paramset['companyno'] = {value=companyno, CFSQLType="string"};
		paramset['kind'] = {value=kind, CFSQLType="integer"};
		return queryExecute(sql, paramset);
	}

	function getCompanyByLocation(locationid, kind) {
		var paramset = {};
		var companies = 
			"SELECT c.companyid, c.abbreviation_name, c.`name`, c.address, c.locationid, 
			c.country_code_phone, c.phone, c.country_code_fax, c.fax, c.company_kind,
					c.mail, c.contact_person, c.gildemeisterid  
			FROM 	company c 
			WHERE 	c.active = 1 "

		if (locationid != "") {
			companies &= " AND c.locationid = :locationid";
			paramset['locationid'] = {value=locationid, CFSQLType="integer"};
		};

		if (kind != 0) {
			companies &= " AND c.company_kind = :kind";
			paramset['kind'] = {value=kind, CFSQLType="integer"};
		};
		return queryExecute(companies, paramset);
	}
	
}