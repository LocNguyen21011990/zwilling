component accessors=true {

	property framework;
    property purchase_orderService;
    property product_itemService;
    property product_item_documentService;
    property product_item_setService;
    property product_lineService;
    property product_item_qlService;
    
    function getProductItemByProductNo(string product_no) {
        var obj = createObject("component","api/general");
        result = obj.queryToObject(purchase_orderService.getProductItem(product_no, ""));
        VARIABLES.framework.renderData('JSON', result);
    }

    function getProductItemList() {
        var obj = createObject("component","api/general");
        result = obj.queryToArray(product_itemService.getProductItemList(""));
        VARIABLES.framework.renderData('JSON', result);
    }
    function getProductItems(){
        var api     = new api.general();
        var product = product_itemService.getItems();
        VARIABLES.framework.renderData('JSON', api.queryToArray(product));
    }
    function loadByProductLine(){
        var api     = new api.general();
        var productline   = product_itemService.getPLine();
        VARIABLES.framework.renderData('JSON', api.queryToArray(productline));
    }

    function addProductItem(string data) {
        var success = false;
        var message = "Insert data fail.";
        var info = deserializeJSON(data); 
        var update_date = now();
        var flag = false;
        if(structKeyExists(info, "product_item_set"))
        {
            for(item_set in info.product_item_set){
                if(item_set.child_product_item_no != info.product_item_no){
                   if(product_itemService.getProductItemNoExist(item_set.child_product_item_no).recordCount == 0){
                        flag = true;
                    } 
                }
            }
        }
        if(product_lineService.getProductLineById(info.product_line_no).recordCount == 0){
            flag = true;
        }
        if(flag){
            message = 'Product Item No does not exist in systerm';
        }else{
            if(product_itemService.getProductItemNoExist(info.product_item_no).recordCount > 0){
                message="The product item number is existed already!";
            }else{
                var new_productItem = entityNew('product_item');
                new_productItem.setProduct_item_no(info.product_item_no);
                new_productItem.setProduct_item_name_english(info.product_item_name_english);
                new_productItem.setProduct_item_name_german(info.product_item_name_german);
                new_productItem.setProduct_line_no(info.product_line_no);
                new_productItem.setLastupdate(update_date);
                new_productItem.setUpdateby(info.updateby);
                new_productItem.setEAN_code(info.ean_code);
                entitySave(new_productItem);
                if(structKeyExists(info, "product_item_set"))
                {
                    for(item_set in info.product_item_set){
                        var new_itemSet = entityNew('product_item_set');
                        new_itemSet.setParent_product_item_no(info.product_item_no);
                        new_itemSet.setChild_product_item_no(item_set.child_product_item_no);
                        new_itemSet.setQuantity(item_set.quantity);
                        new_itemSet.setLastupdate(update_date);
                        new_itemSet.setUpdateby(info.updateby);
                        entitySave(new_itemSet);
                    }
                }

                if(structKeyExists(info, "product_item_document"))
                {
                    for(product_document_id in info.product_item_document){
                        entity_product_document = entityLoad( "product_item_document", product_document_id, true );
                        entity_product_document.setProduct_item_no(info.product_item_no);
                    }
                }
                // if(info.product_item_ql != ""){
                //     var new_itemQl = entityNew('product_item_ql');
                //     new_itemQl.setProduct_item_no(info.product_item_no);
                //     new_itemQl.setQl(info.product_item_ql);
                //     new_itemQl.setFrom_date(update_date);
                //     new_itemQl.setTo_date(dateAdd('d',+365,update_date));
                //     new_itemQl.setDefault(1);
                //     entitySave(new_itemQl);
                // } 
                if(ArrayLen(info.product_item_ql) > 0){
                    for(itemQl in info.product_item_ql){
                        var new_itemQl = entityNew('product_item_ql');
                        new_itemQl.setProduct_item_no(info.product_item_no);
                        new_itemQl.setQl(itemQl.ql);
                        new_itemQl.setFrom_date(update_date);
                        new_itemQl.setTo_date(dateAdd('d',+365,update_date));
                        new_itemQl.setDefault(itemQl.isDefault);
                        entitySave(new_itemQl);
                    }
                }

                success = true;
                message = "Inserted Product Item Successfully";
            }
        }
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    function getProductItemNo(){
        var api = new api.general();
        var productItem_no = product_itemService.getProductItemList();
        VARIABLES.framework.renderData('JSON',api.queryToArray(productItem_no));
    }
    function editProductItem(string data) {
        var success = false;
        var message = "Update data fail.";
        var notice = "";
        var info = deserializeJSON(data);
        var update_date = now();
        var del = false;
        var flag = false;
        if(structKeyExists(info, "product_item_set"))
        {
            for(item_set in info.product_item_set){
                if(item_set.child_product_item_no != info.product_item_no){
                    if(product_itemService.getProductItemNoExist(item_set.child_product_item_no).recordCount == 0){
                        flag = true;
                    }
                }
            }
        }
        if(product_lineService.getProductLineById(info.product_line_no).recordCount == 0){
            flag = true;
        }
        if(flag){
            message = 'Product Item No does not exist in systerm';
        }else{
            var new_productItem = entityLoad( "product_item", {product_item_no=info.product_item_no}, true );
            new_productItem.setProduct_item_name_english(info.product_item_name_english);
            new_productItem.setProduct_item_name_german(info.product_item_name_german);          
            new_productItem.setProduct_line_no(info.product_line_no);
            new_productItem.setLastupdate(update_date);
            new_productItem.setUpdateby(info.updateby);
            new_productItem.setEAN_code(info.ean_code);
            var itemCheck = product_itemService.getQlItemExistInOrder(info.product_item_no);
            if(isEmpty(itemCheck)){
                del = true;
            }
            if(structKeyExists(info, "product_item_set"))
            {
                for(item_set in info.product_item_set){
                    if(item_set.isDelete){ 
                        if(del){
                            itemDel = entityLoad("product_item_set", item_set.set_compositionid, true);
                            entityDelete(itemDel);
                        }else{
                            notice &= ","&item_set.child_product_item_no;
                        }
                    }else{
                        if(structKeyExists(item_set, "set_compositionid"))
                        {
                            var entity_itemSet = entityLoad( "product_item_set", item_set.set_compositionid, true );
                            entity_itemSet.setParent_product_item_no(info.product_item_no);
                            entity_itemSet.setChild_product_item_no(item_set.child_product_item_no);
                            entity_itemSet.setQuantity(item_set.quantity);
                            entity_itemSet.setLastupdate(update_date);
                            entity_itemSet.setUpdateby(info.updateby);
                        }else{
                            var new_itemSet = entityNew('product_item_set');
                            new_itemSet.setParent_product_item_no(info.product_item_no);
                            new_itemSet.setChild_product_item_no(item_set.child_product_item_no);
                            new_itemSet.setQuantity(item_set.quantity);
                            new_itemSet.setLastupdate(update_date);
                            new_itemSet.setUpdateby(info.updateby);
                            entitySave(new_itemSet);
                        }
                    }
                }
            }

            if(structKeyExists(info, "product_item_document"))
            {
                for(product_document_id in info.product_item_document){
                    entity_product_document = entityLoad( "product_item_document", product_document_id, true );
                    entity_product_document.setProduct_item_no(info.product_item_no);
                }
            }
            if(ArrayLen(info.product_item_ql) > 0){
                QueryExecute(sql:"delete from product_item_ql where product_item_no = :product_item_no",
                    params:{ product_item_no:{ value = info.product_item_no, CFSQLType='string'}
                });
                for(itemQl in info.product_item_ql){
                    var new_itemQl = entityNew('product_item_ql');
                    new_itemQl.setProduct_item_no(info.product_item_no);
                    new_itemQl.setQl(itemQl.ql);
                    new_itemQl.setFrom_date(update_date);
                    new_itemQl.setTo_date(dateAdd('d',+365,update_date));
                    new_itemQl.setDefault(itemQl.isDefault);
                    entitySave(new_itemQl);
                }
            }
            // if(info.product_item_ql != ""){
            //     var new_itemQl = entityLoad( "product_item_ql", {product_item_no = info.product_item_no, 'default' = 1}, true );
            //     if(isnull(new_itemQl)){
            //         new_itemQl = entityNew('product_item_ql');
            //         new_itemQl.setProduct_item_no(info.product_item_no);
            //         new_itemQl.setQl(info.product_item_ql);
            //         new_itemQl.setFrom_date(update_date);
            //         new_itemQl.setTo_date(dateAdd('d',+365,update_date));
            //         new_itemQl.setDefault(1);
            //         entitySave(new_itemQl);
            //     }else{
            //         // new_itemQl.setQl(info.product_item_ql);
            //         // new_itemQl.setFrom_date(update_date);
            //         // new_itemQl.setTo_date(dateAdd('d',+365,update_date));
                    
            //         var up_itemQl = entityLoad( "product_item_ql", {product_item_no = info.product_item_no, 'default' = 0, 'ql' = info.product_item_ql}, true );
            //         if(isnull(up_itemQl)){
            //             new_itemQl.setDefault(0);
            //             var itemQl = entityNew('product_item_ql');
            //             itemQl.setProduct_item_no(info.product_item_no);
            //             itemQl.setQl(info.product_item_ql);
            //             itemQl.setFrom_date(update_date);
            //             itemQl.setTo_date(dateAdd('d',+365,update_date));
            //             itemQl.setDefault(1);
            //             entitySave(itemQl);
            //         }else{
            //             up_itemQl.setFrom_date(update_date);
            //             up_itemQl.setTo_date(dateAdd('d',+365,update_date));
            //             up_itemQl.setDefault(1);
            //             new_itemQl.setDefault(0);
            //         }
            //     } 
            // } 
            success = true;
            message = " Updated Product Item Successfully";
            if(notice  != '')
                message &= ": Item set "&notice&" can't delete because exist in Order.";
        }
         
        VARIABLES.framework.renderData('JSON', {'success': success, 'message': message});
    }

    function getProductItemByItemno(string id) {
        var obj = createObject("component","api/general");
        var result = obj.queryToObject(product_itemService.getProductItemById(id));
        
        var documents = obj.queryToArray(product_item_documentService.getListByitemno(result.product_item_no));
        result.product_item_document = documents;
        result.product_item_set = obj.queryToArray(product_item_setService.getProductItemSetByItemno(result.product_item_no));
        var qls = product_item_qlService.getQlList(result.product_item_no);
        var result.product_item_ql = obj.queryToArray(qls);
        
        VARIABLES.framework.renderData('JSON', result);
    }
    function getProductByProductLineCode(string plcode){
        var api = new api.general();
        var pItemLine = product_itemService.getPLineByCode(plcode);
        VARIABLES.framework.renderData('JSON', api.queryToArray(pItemLine));
    }
    function getListProductItemChid() {
        var obj = createObject("component","api/general");
        var product_line_no ="";
        if(StructKeyExists(URL, 'product_line_no'))
            product_line_no = URL.product_line_no;
        var data = obj.queryToArray(product_itemService.getProductItemChil(product_line_no));
        var arrProductItem = [];
        for(item in data){
            var productItemStruct = {};
            productItemStruct.value = item.product_item_no;
            productItemStruct.label = item.product_item_no&"::"&item.product_item_name_english;
            arrayAppend(arrProductItem, productItemStruct)
        }
        VARIABLES.framework.renderData('JSON', arrProductItem);
    }
    
    function execute() {

        switch(cgi.request_method) { 
            case "put": 
                    editProductItem(GetHttpRequestData().content);
                    break; 
            case "post": 
                addProductItem(GetHttpRequestData().content); 
                break; 
            case "delete":
                if(StructKeyExists(URL, 'id')){
                    //deleteAccess(GetHttpRequestData().headers.token, URL.id);
                    break; 
                }
            case "get": 
                if(StructKeyExists(URL, 'id')){
                    getProductItemByItemno(URL.id);
                    break;
                }
                if(StructKeyExists(URL, 'key')){
                    getProductItemByProductNo(URL.key);
                    break;
                }
                if(structKeyExists(URL,'plcode')){
                    getProductByProductLineCode(URL.plcode);
                    break;
                }
                getProductItemList();
                break;          
        } //end switch
    }
}