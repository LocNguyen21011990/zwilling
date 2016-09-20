/**
*
* @file  /zwillingv3/controllers/import.cfc
* @author  Dieu Le
* @description import order from SAP with function importData
*
*/

component output="false" displayname=""  {
	 
	public function init(required any fw){
		// SESSION.orders = [];
		variables.fw = arguments.fw;
		return this;
	}

	public any function importOrder() {
		rc.pagetitle = 'Import New Orders';
		// writeDump(var=rc.orders,output="/home/tam/test.html");
		return;
	}

	
	public any function parseDataFromFile(struct rc) {
		 
			var filename = 'Import-Order-1.csv';
			//var filename = rc.filename;
			var Utils = createObject("component","utils");
			var path = expandPath("/resource/" & filename);
			var csvArray = Utils.csvToArray(file=path);
			writeDump(var=csvArray,output="j:/csv.html");
			abort;
			var listOrder = arrayNew();
			// var listPurchaseOrder = EntityLoad("purchase_order",{active=1},{offset=21, maxResults=10});
			
			// var ordertest = createObject("component","/model/views/purchase_order_view");
			// writeDump(var=ordertest,output="/home/tam/test2.html");

			for(var i = 2 ; i <= ArrayLen(csvArray); i++){
				var order = EntityNew("purchase_order");
				order.setActive(true);
				order.setlastupdate(now());
				order.setis_show(1);

				var orderPosition = EntityNew("order_position");
				orderPosition.setActive(true);
				orderPosition.setlastupdate(now());

				var ab = EntityNew("ab");
				ab.setlastupdate(now());

				var scheduleItem = EntityNew("inspection_schedule");
				scheduleItem.setlastupdate(now());

				var orderID = 0;
				var orderPositionID = 0;

				var csvEntity = csvArray[i];

				// for(var j = 1; j <= ArrayLen(csvEntity); j++){
					if(ArrayLen(csvEntity) != 12){
						continue;
					}
					try {
						order.setorder_no(csvEntity[1]);
						var bo = (!isNull(order.getorder_no()) and len(trim(order.getorder_no())));
						if(!isNull(order.getorder_no()) and len(trim(order.getorder_no()))){
							var orderCheck = EntityLoad("purchase_order",{active=1,order_no=order.getorder_no()},true);
							if(!isNull(orderCheck)){
								orderID = orderCheck.getorderid();
							}
						}

					}
					catch(any) {
						writeDump(var=any,output="console");
					}

					try {
						order.setorder_date(csvEntity[2]);

					}
					catch(any) {
						writeDump(var=any,output="console");
					}  
					
					// Customer No
					try {
						if(!isNull(csvEntity[3]) and len(trim(csvEntity[3]))){
							var customer = EntityLoad("company",{gildemeisterid = csvEntity[3],active = 1,company_kind = 3},true);
							if(!isNull(customer)){
								order.setbuyer_companyid(customer.getcompanyid());
							}
						}
					}
					catch(any) {
						writeDump(var=any,output="console");
					}

					// Supplier No
					try {
						if(!isNull(csvEntity[4]) and len(trim(csvEntity[4]))){
							var supplier = EntityLoad("company",{gildemeisterid = csvEntity[4],active = 1,company_kind = 2},true);
							if(!isNull(supplier)){
								order.setsupplier_companyid(supplier.getcompanyid());
							}
						}
						 
					}
					catch(any) {
						writeDump(var=any,output="console");
					}

					if(orderID == 0){
						EntitySave(order);
						orderPosition.setorderid(order.getorderid());
					}
					// order position
					try {
						var checkPositionExist = false;
						if(!isNull(csvEntity[5]) and len(trim(csvEntity[5]))){
							if(orderID != 0){
								orderPosition.setorderid(orderID);
								var orderPositionCheck = EntityLoad("order_position",{orderid = orderID,position_no = csvEntity[5],active = 1},true);
								if(!isNull(orderPositionCheck)){
									checkPositionExist = true;
									order.setImportStatus(false);
									order.setImportResult("Order position exists already!");
								} 

							}
							// var item = entityLoad("pattern_item",{pattern_itemid=csvEntity[6]});
							
							order.setpositionNo(csvEntity[5]);
							order.setproductItem(csvEntity[6]);
							order.setproductItemName(csvEntity[6]);
							order.setProductLine(csvEntity[6]);
							
							order.setOrderQuantity(csvEntity[7]);
							order.setAcceptedQuantity(csvEntity[6]);
							order.setRemain(csvEntity[11]);
							order.setConfShipDate(csvEntity[12]);

							orderPosition.setposition_no(csvEntity[5]);
							orderPosition.setordered_pattern_item(csvEntity[6]);
							orderPosition.setordered_quantity(csvEntity[7]);
							orderPosition.setunit_price(csvEntity[8]);
							orderPosition.setcurrency(csvEntity[9]);
						}
						if(!checkPositionExist){
							EntitySave(orderPosition);
							// AB of position
							
							ab.setpositionid(orderPosition.getpositionid());

							ab.setabno(1);
							ab.setShipped_quantity(csvEntity[7]);
							ab.setshipment_method(csvEntity[10])
							ab.setexpected_shipping_date(csvEntity[11])
							ab.setconfirmed_shipping_date(csvEntity[12])
							EntitySave(ab);
							 order.setimportStatus(true);

							order.setAB(1);
							order.setABQuantity(csvEntity[7]);

							scheduleItem.setabId(ab.getabid());
							var dateSchdule = DateAdd("d",-7,ab.getexpected_shipping_date());
							scheduleItem.setinspection_planDate(dateSchdule);
							EntitySave(scheduleItem);
						 }
						 
					}
					catch(any) {
						writeDump(var=any,output="console");
						order.setimportStatus(false);
					}   

				ArrayAppend(listOrder, order);

					
			// 	// }
			}
			// writeDump(var=listPurchaseOrder,output="/home/tam/test.html");
			// SESSION.orders = listOrder;
			variables.fw.renderData("Json", listOrder);	 
	}


	public void function importorder(  ){

        var data = deserializeJSON(GetHttpRequestData().content);

        var api     = new api.general();
        var valid   = api.validMimeTypes();
        var message = "Your file upload invalid, please try again!";
        var success = false;
        try {
                var imagePath = "/fileUpload/importorder/"; 
                var fullpath = expandPath(imagePath)&"/"& data.filename;
                file action="write" file="#fullpath#" output="#toBinary(data.base64)#" addnewline="false" mode="777" ;

                success = true;   



            //begin read file
   //          var Utils = createObject("component","utils");
			// var csvArray = Utils.csvToArray(file=fullpath);


			var openFile	= fileOpen(fullpath, "read");
			var readFile	= fileRead(openFile);
			var getLines 	= listToArray(readFile, "#chr(13)##chr(10)#");
			dump(readFile);
			abort;
            //end read file




                variables.fw.renderData('JSON',{ 'success':success,'filename':data.filename});
        }
        catch(any e) {
            variables.fw.renderData('JSON',{ 'success':success,'message':e.message}); 
        } 
    }

	
	function importData( struct rc ){

		var success = false;

		if(structKeyExists(rc, "uploadFile")){

			var getFile 		= rc.uploadFile ?: "";
			var fullPath 		= expandpath("/fileUpload/importFile/");
			if(len(getFile)){
				newUpload 		= fileUpload(fullPath, "uploadFile", "","makeUnique");
				fileName 		= newUpload.serverfile;
				var openFile	= fileOpen("#fullPath##fileName#", "read");
				var readFile	= fileRead(openFile);
				var getLines 	= listToArray(readFile, "#chr(13)##chr(10)#");

				var arr = arrayLen(getLines);
				writeDump(arr)
				// writeDump(getLines);
				for(var i=1;i<=10;i++){
					var temp 	=	listgetat(getLines[i],1,";");
					var temp1 	= 	listgetat(getLines[i],2,";");
					writeDump(temp);
					writeDump(temp1);
				}
				
				/* for(line in getLines){
					var temp 	= trim(listgetat(line,1,";"));
					writeDump(temp);
					
				} */
				
				fileClose(openFile);
				fw.renderData('JSON', {'data':getLines, 'success':success});
			}
		}
		fw.renderData('JSON',{'success':success})
	}
}