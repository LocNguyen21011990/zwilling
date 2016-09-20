"use strict";

app.controller('orderInput', function($filter,ENV,$state,$http,$compile,$scope,$q,$timeout,$log,DTOptionsBuilder,DTColumnDefBuilder,DTColumnBuilder,companyService,orderService,Notification,productItemService,fileService,$stateParams){

    //page setup
    $timeout(function () {
        $(".datepicker").datepicker({ dateFormat: "dd-M-yy" }).val();
        $( ".datepicker" ).datepicker( "option", "prevText", "<" );
        $( ".datepicker" ).datepicker( "option", "nextText", ">" );
        $( ".datepicker" ).datepicker( "option", "firstDay", 1 );
        pageSetUp();
    }, 100)

    //define model of page
    var OP = this;
    OP.addMore = false;
    var flag = false;
    var isEdit = false;
    var tempPrice = 0;
    OP.checkModal = 0;
    OP.totalPrice = 0;
    OP.customer = '';
    OP.supplier = '';
    OP.purchase_order = {
        "order_no":"",
        "order_date":$filter('date')(new Date(), 'dd-MMM-yyyy'),
        "supplier_id":"",
        "customer_id":"",
        "currency": "",
        "position":[],
        "document":[]
    };
    //end define
    OP.displayCompany = createComnpany();
    OP.customers = [];
    OP.suppliers = [];
    OP.currencies= [];
    OP.displayAB = [];
    OP.tranports = [];
    OP.locations = [];
    OP.positions = [];
    OP.listdocumentid =[];
    OP.listdocumentfn =[];
    OP.aFiles =[];
    OP.orderPosition = createPosition();
    //end define model
    //load data for edit action
    if($stateParams.id){
        isEdit = true;
         orderService.getById($stateParams.id).then(function(data){
             OP.purchase_order.order_no = data['purchase_order'].order_no.trim();
             OP.purchase_order.order_date = $filter('date')(data['purchase_order'].order_date.trim(), 'dd-MMM-yyyy');
             OP.purchase_order.currency = data['purchase_order'].currency.trim();
             OP.purchase_order.orderid = data['purchase_order'].orderid;
             OP.purchase_order.inspector = data['purchase_order'].inspector.trim();
             OP.purchase_order.position = data['purchase_order'].position;
             OP.purchase_order.document = data['purchase_order'].document;
             OP.listdocumentid = OP.purchase_order.document;
             angular.forEach(OP.listdocumentid, function(value, key) {
                 fileService.getByID(value).then(function(data){
                     OP.listdocumentfn.push(data.fileName);
                 });
             });
             OP.customer =  data['purchase_order'].customer_id+'';
             OP.supplier =  data['purchase_order'].supplier_id+'';
             companyService.getByType(window.globalVariable.company_kind.customer).then(function(data){
                 OP.customers = data;
                 OP.selectCustomer();
            });
            companyService.getByType(window.globalVariable.company_kind.supplier).then(function(data){
                OP.suppliers = data;
                OP.selectSupplier();
            });

            $http.get(ENV.domain+'order.getCurrencyByYear?order_date='+OP.purchase_order.order_date).then(function(data){
                OP.currencies = data.data;
            });
             //load position
             angular.forEach(data['order_position'], function(value, key) {
                 value.product_item_name = value.product_item_name_english;
                 delete value.product_item_name_english;
                 value.product_item_line = value.product_line_name_english;
                 delete value.product_line_name_english;
                 angular.forEach(value.ab, function(val, k) {
                     var abDisplay = {
                            'id' : value.positionid,
                            'positionid' : value.position_no,
                            'abno':val.abno,
                            'product_item_no':value.product_item_no,
                            'product_item_line' : value.product_item_line,
                            'product_item_name':value.product_item_name,
                            'pqty':value.ordered_quantity,
                            'abqty':val.shipped_quantity,
                            'unit_price': value.unit_price,
                            'total_price':Math.round((val.shipped_quantity*value.unit_price) * 100) / 100,
                            'trans' : val.shipment_method,
                            'confirmed_shipping_date' :val.confirmed_shipping_date,
                            'expected_shipping_date' : val.expected_shipping_date,
                            'isDel' : false
                    };
                    OP.displayAB.push(abDisplay);
                 });
                 OP.totalPrice +=value.total_price;
                 OP.positions.push(value);
             });
              OP.orderPosition = createPosition();
                $timeout(function () {
                    $(".datepicker").datepicker({ dateFormat: "dd-M-yy" }).val();
                    $( ".datepicker" ).datepicker( "option", "prevText", "<" );
                    $( ".datepicker" ).datepicker( "option", "nextText", ">" );
                    $( ".datepicker" ).datepicker( "option", "firstDay", 1 );
                    pageSetUp();
                }, 100)
         });
    }
    //end load data
    
    //render data for select
    if(!isEdit){
         companyService.getByType(window.globalVariable.company_kind.customer).then(function(data){
            OP.customers = data
        });
        companyService.getByType(window.globalVariable.company_kind.supplier).then(function(data){
            OP.suppliers = data;
        });

        $http.get(ENV.domain+'order.getCurrencyByYear?order_date='+OP.purchase_order.order_date).then(function(data){
            OP.currencies = data.data;
        });
    }
    
    companyService.getLocations().then(function(data){
        OP.locations = data;
    });
    orderService.getTransport().then(function(data){
         OP.tranports = data;
    });

    $scope.listProducts = [];
    productItemService.getAll().$promise.then(function(data){
        angular.forEach(data,function(value){
            $scope.listProducts.push({
                value:value['product_item_no'],
                label:value['product_item_no'] + '::' + value['product_item_name_english'],
                name: value['product_item_name_english'],
                line: value['product_line_name_english'],
            });
        })
    });

    //end render data
    $scope.searchProducts = {
        options: {
            html: true,
            minLength: 3,
            onlySelectValid: true,
            outHeight: 50,
            source: function (request, response) {
                var data = [];
                data = $scope.listProducts;
                data     = $scope.searchProducts.methods.filter(data, request.term);
                if (!data.length) {
                    data.push({
                        label: 'not found',
                        value: null
                    });
                }
                response(data);
            }
        },
        events: {
            select: function (event, ui) {
                if(OP.checkModal == 1){
                    OP.orderPosition.product_item_name = ui.item.name;
                    OP.orderPosition.product_item_line = ui.item.line;
                    $(".product_item_name_label").addClass("label-helper");
                }else{
                    OP.positions[OP.currentPosition].product_item_name = ui.item.name;
                    OP.positions[OP.currentPosition].product_item_line= ui.item.line;
                    $(".product_item_name_label").addClass("label-helper");
                }
            },
            change:function(event,ui){
                if(ui.item==null)
                {
                    if(OP.checkModal == 1){
                        OP.orderPosition.product_item_name = "";
                        OP.orderPosition.product_item_line = "";
                        $('#product_line_name').val("");
                        $('#product_item_name').val("");
                        $(".product_item_name_label").removeClass("label-helper");
                    }else{
                        OP.positions[OP.currentPosition].product_item_name = '';
                        OP.positions[OP.currentPosition].product_item_line= '';
                    }
                }
            }
        }
    };

   //define event for select
    OP.selectCustomer = function(){
        flag = false;
        angular.forEach(OP.customers, function(value, key) {
            if(value.companyid == OP.customer){
                OP.cusEmail = value.mail;
                OP.cusContact = value.contact_person;
                OP.purchase_order.customer_id = OP.customer;
                displayCompany(value,3);
                flag = true;
            }
        });
        if(!flag){
            OP.cusEmail ="";
            OP.cusContact = '';
            OP.displayCompany = createComnpany();
        }
          
    };
    OP.selectSupplier = function(){
        flag = false;
        angular.forEach(OP.suppliers, function(value, key) {
            if(parseInt(value.companyid) == OP.supplier){
                OP.supEmail = value.mail;
                OP.supContact = value.contact_person;
                displayCompany(value,2);
                OP.purchase_order.supplier_id = OP.supplier;
                flag = true;
            }
        });
         if(!flag){
            OP.supEmail = '';
            OP.supContact = '';
            OP.displayCompany = createComnpany();
         } 
    };
    //end define for event

    //define function for event 
    OP.showDetail = showDetail;
    OP.saveCompany = saveCompany;
    OP.savePosition = savePosition;
    OP.savePurchase_order = savePurchase_order;
    OP.changeCurrency = changeCurrency;
    //end define function

    //define datatable
    OP.selected     = [];
    OP.dtInstance   = {};
    OP.currentPosition = -1;
    OP.editPosition = editPosition;
    OP.splitAB = splitAB;
    OP.delAB =  delAB;
    OP.changeTotalQty = changeTotalQty;
    OP.delPosition = delPosition;
    OP.updatePosition = updatePosition;
    OP.dtOptions    = DTOptionsBuilder.newOptions()
        .withOption('aaData',OP.displayAB)
        .withOption('bLengthChange', false)
        .withOption('bPaginate', false)
        .withOption('bInfo', false)
        .withOption('createdRow', function(row, data, dataIndex) {
            // Recompiling so we can bind Angular directive to the DT
            $compile(angular.element(row).contents())($scope);
        })
        .withOption('bFilter', false);

    OP.dtColumns = [
        DTColumnBuilder.newColumn("positionid","Pos.").withClass('dt-body-center'),
        DTColumnBuilder.newColumn("abno","AB").withClass('dt-body-center'),
        DTColumnBuilder.newColumn("product_item_no"," Product Item No.").withClass('dt-body-left'),
        DTColumnBuilder.newColumn("product_item_line","Product Line").withClass('dt-body-left'),
        DTColumnBuilder.newColumn("product_item_name","Product Item Name").withClass('dt-body-left'),
        DTColumnBuilder.newColumn("pqty","Order Q'TY").renderWith(renderQty).withClass('dt-body-right'),
        DTColumnBuilder.newColumn("abqty","AB Q'TY").renderWith(renderQty).withClass('dt-body-right'),
        DTColumnBuilder.newColumn("unit_price","Unit Price").renderWith(renderMoney).withClass('dt-body-right'),
        DTColumnBuilder.newColumn("total_price","Total Price").renderWith(renderMoney).withClass('dt-body-right'),
        DTColumnBuilder.newColumn("trans","Trans").withClass('dt-body-center'),
        DTColumnBuilder.newColumn("expected_shipping_date","Expeted Ship Date").withClass('dt-body-center'),
        DTColumnBuilder.newColumn("confirmed_shipping_date","Conf. Ship Date").withClass('dt-body-center'),
        DTColumnBuilder.newColumn(null).withTitle('Edit').notSortable().renderWith(function(data,type,full,meta){return '<td class="btn_edit"><a class="cursor" data-toggle="modal" ng-click="OP.editPosition('+data.id+')" data-target="#editPosition"><i class="fa fa-pencil-square-o"></i></a></td>'})
    ];
    OP.dtColumnDefs  = [
        DTColumnDefBuilder.newColumnDef(0)
    ];

    function renderQty(data){
        return $filter('number')(data, 0);
    }

    function renderMoney(data){
        return $filter('number')(data,2);
    }

    function changeCurrency(){
        $http.get(ENV.domain+'order.getCurrencyByYear?order_date='+OP.purchase_order.order_date).then(function(data){
            OP.currencies = data.data;
        });
    }

    function editPosition(id)
    {
        OP.checkModal = 2;
        flag = true;
        angular.forEach(OP.positions, function(value, key) {
             if(flag)
             {
                 if(value.positionid == id){
                    OP.currentPosition = key;
                    tempPrice = value.total_price;
                    //bug select2
                     $('#product_item_no_detail').select2('val',value.product_item_no);
                    //
                    $timeout(function () {
                        $(".datepicker").datepicker({ dateFormat: "dd-M-yy" }).val();
                        $( ".datepicker" ).datepicker( "option", "prevText", "<" );
                        $( ".datepicker" ).datepicker( "option", "nextText", ">" );
                        $( ".datepicker" ).datepicker( "option", "firstDay", 1 );
                        pageSetUp();
                    }, 100);
                    flag = false;
                }
             }  
        });
        $(".input-disable-label").addClass("label-helper ");
    }
    function splitAB(){
        var abitem = {
            abno:OP.positions[OP.currentPosition].ab[OP.positions[OP.currentPosition].ab.length-1].abno + 1,
            shipped_quantity:'',
            shipment_method:OP.positions[OP.currentPosition].ab[0].shipment_method,
            expected_shipping_date:'',
            confirmed_shipping_date:'',
            shipping_date:'',
            za_date:'',
            eta_date:'',
            relevant_due_date:'',
            warehouse_book_date:''
        };
        OP.positions[OP.currentPosition].ab.push(abitem);
        $timeout(function () {
             $(".datepicker").datepicker({ dateFormat: "dd-M-yy" }).val();
             $( ".datepicker" ).datepicker( "option", "prevText", "<" );
            $( ".datepicker" ).datepicker( "option", "nextText", ">" );
            $( ".datepicker" ).datepicker( "option", "firstDay", 1 );
            pageSetUp();
        }, 100);
    }
    function delAB(index){
        if(OP.positions[OP.currentPosition].ab.length>1){
            if(OP.positions[OP.currentPosition].ab[index].abid)
            {
                orderService.deleteAb(OP.positions[OP.currentPosition].ab[index].abid).then(function(data){
                    if(data['success']){
                         OP.positions[OP.currentPosition].ab.splice(index,1);
                         changeTotalQty();
                         OP.dtInstance.reloadData();
                    }else{
                         Notification.error({message : data['message']||'you can delete this AB',delay : 1000});
                    }
                });
            }else{
                OP.positions[OP.currentPosition].ab.splice(index,1);
                changeTotalQty();
            }
        }
        else{
             Notification.error({message : 'you can delete last ab in position!!',delay : 1000});
        }
    };
   
    function changeTotalQty(){
        var total = 0;
        angular.forEach(OP.positions[OP.currentPosition].ab, function(value, key) {
            if(value.shipped_quantity!='')
            total = parseInt(total) + parseInt(value.shipped_quantity);
        });
        OP.positions[OP.currentPosition].ordered_quantity = total;
    }
    function delPosition(id){
        orderService.delete(id).then(function(data){
            if(data['success']){
                OP.positions.splice(OP.currentPosition,1);
                var indexPosition = OP.purchase_order.position.indexOf(id);
                OP.purchase_order.position.splice(indexPosition,1);
                var lengthAb = OP.displayAB.length;
                for(var i = 0 ; i < lengthAb; i++)
                {
                    if(OP.displayAB[i].id == id){
                        OP.displayAB.splice(i,1);
                        i--; lengthAb--;
                    }
                }
                OP.dtInstance.reloadData();
                OP.totalPrice = OP.totalPrice-tempPrice;
                $('#editPosition').modal('hide');
                Notification.success({message : data['message']||'Delete data success',delay : 2000});
            }else{
                Notification.error({message :data['message']||'Something wrong! reload page and try again',delay : 2000});
            }
        });
    }


    function updatePosition(){
        OP.positions[OP.currentPosition].total_price = Math.round((OP.positions[OP.currentPosition].ordered_quantity*OP.positions[OP.currentPosition].unit_price) * 100) / 100 ;
        angular.forEach(OP.positions[OP.currentPosition].ab, function(value, key) {
            if(angular.isUndefined(value.abid)){
                value.eta_date = value.confirmed_shipping_date;
                value.relevant_due_date = value.confirmed_shipping_date;
            }
        });
        orderService.updatePosition(OP.positions[OP.currentPosition]).$promise.then(function(data){
            if(data['success'])
            {
                var lengthAb = OP.displayAB.length;
                for(var i = 0 ; i < lengthAb; i++)
                {
                    if(OP.displayAB[i].id == OP.positions[OP.currentPosition].positionid){
                        OP.displayAB.splice(i,1);
                        i--; lengthAb--;
                    }
                }
                 //display data
                 angular.forEach(OP.positions[OP.currentPosition].ab, function(value, key) {
                     angular.forEach(data['ab'], function(val, k) {
                            if(val.abno == value.abno){
                                value.abid = val.abid;
                                value.id = val.id;
                            }
                     });
                    var abDisplay = {
                            'id' : OP.positions[OP.currentPosition].positionid,
                            'positionid' : OP.positions[OP.currentPosition].position_no,
                            'abno':value.abno,
                            'product_item_no':OP.positions[OP.currentPosition].product_item_no,
                            'product_item_line' : OP.positions[OP.currentPosition].product_item_line,
                            'product_item_name':OP.positions[OP.currentPosition].product_item_name,
                            'pqty':OP.positions[OP.currentPosition].ordered_quantity,
                            'abqty':value.shipped_quantity,
                            'unit_price': OP.positions[OP.currentPosition].unit_price,
                            'total_price':Math.round((value.shipped_quantity*OP.positions[OP.currentPosition].unit_price) * 100) / 100,
                            'trans' : value.shipment_method,
                            'confirmed_shipping_date' :value.confirmed_shipping_date,
                            'expected_shipping_date' : value.expected_shipping_date,
                            'isDel' : false
                    };
                    OP.displayAB.push(abDisplay);
                });
                OP.totalPrice = OP.totalPrice-tempPrice + OP.positions[OP.currentPosition].total_price;
                 //end display data
                 $('#editPosition').modal('hide');
                 Notification.success({message : data['message']||'Update data success',delay : 2000});
            }else{
                 Notification.error({message :data['message']||'Please double check all information!',delay : 2000});
            }
        });
    }
    //end define datatable

    function savePosition(){
         //check validate
        flag = false;
        var errString = 'Missing some Information:</br>';
        if(OP.orderPosition.product_item_no==''){
            errString +='- Field Product Item No.</br>' ;
            flag = true;
        }
        if(OP.orderPosition.ordered_quantity ==''){
            errString +='- Field Quantity.</br>' ;
            flag = true;
        }
        if(OP.orderPosition.unit_price ==''){
            errString +='- Field Unit Price.</br>' ;
            flag = true;
        }
        if(OP.orderPosition.ab[0].shipment_method ==''){
            errString +='- Select Tranport.</br>' ;
            flag = true;
        }
        if(OP.orderPosition.ab[0].expected_shipping_date ==''){
            errString +='- Select Expected Shipping Date.</br>' ;
            flag = true;
        }
        if(OP.orderPosition.ab[0].confirmed_shipping_date ==''){
            errString +='- Select Confirmed Shipping Date.</br>' ;
            flag = true;
        }
        // if(OP.orderPosition.ab[0].za_date ==''){
        //     errString +='- Select Za Date.</br>' ;
        //     flag = true;
        // }
        // if(OP.orderPosition.ab[0].shipping_date ==''){
        //     errString +='- Select Actual Shipping Date.</br>' ;
        //     flag = true;
        // }
        // if(OP.orderPosition.ab[0].warehouse_book_date ==''){
        //     errString +='- Select Warehouse Booking Date.</br>' ;
        //     flag = true;
        // }
        if(OP.orderPosition.product_item_name == ''){
            errString +='- Select product item.</br>';
            flag = true;
        }
        if(flag)
            Notification.error({message :errString ,delay : 5000});
             //end check validate
        else{
            OP.orderPosition.total_price = Math.round((OP.orderPosition.ordered_quantity*OP.orderPosition.unit_price) * 100) / 100 ;
            OP.orderPosition.ab[0].shipped_quantity = OP.orderPosition.ordered_quantity;
            OP.orderPosition.ab[0].eta_date = OP.orderPosition.ab[0].confirmed_shipping_date;
            OP.orderPosition.ab[0].relevant_due_date = OP.orderPosition.ab[0].confirmed_shipping_date;
            if(isEdit == true){
                OP.orderPosition.orderid = OP.purchase_order.orderid;
            }
            orderService.savePosition(OP.orderPosition).$promise.then(function(response){
                if(response['success']){
                    Notification.success({message : 'Insert new position success',delay : 2000});
                    OP.orderPosition.positionid = response['positionid'];
                    OP.orderPosition.ql = response['ql'];
                    OP.orderPosition.qls = response['qls'];
                    OP.purchase_order.position.push(OP.orderPosition.positionid);
                    OP.orderPosition.ab[0].abid = response['ab'][0].abid;
                    OP.orderPosition.ab[0].id = response['ab'][0].id;
                    OP.positions.push(OP.orderPosition);
                    //display data
                    angular.forEach(OP.orderPosition.ab, function(value, key) {
                    value.shipped_quantity = OP.orderPosition.ordered_quantity;
                    var abDisplay = {
                            'id' : OP.orderPosition.positionid,
                            'positionid' : OP.orderPosition.position_no,
                            'abno':value.abno,
                            'product_item_no': OP.orderPosition.product_item_no,
                            'product_item_line' : OP.orderPosition.product_item_line,
                            'product_item_name':OP.orderPosition.product_item_name,
                            'pqty':OP.orderPosition.ordered_quantity,
                            'abqty':value.shipped_quantity,
                            'unit_price': OP.orderPosition.unit_price,
                            'total_price':Math.round((value.shipped_quantity*OP.orderPosition.unit_price) * 100) / 100,
                            'trans' : value.shipment_method,
                            'confirmed_shipping_date' :value.confirmed_shipping_date,
                            'expected_shipping_date' : value.expected_shipping_date,
                            'isDel' : false
                        };
                        OP.displayAB.push(abDisplay);
                    });
                    OP.totalPrice +=OP.orderPosition.total_price;
                    //end display data
                    OP.productName = "";
                    OP.orderPosition = createPosition();
                    $("#product_item_no").select2("val", "");
                    OP.dtInstance.reloadData();
                    $timeout(function () {
                        $(".datepicker").datepicker({ dateFormat: "dd-M-yy" }).val();
                        $( ".datepicker" ).datepicker( "option", "prevText", "<" );
                        $( ".datepicker" ).datepicker( "option", "nextText", ">" );
                        $( ".datepicker" ).datepicker( "option", "firstDay", 1 );
                        pageSetUp();
                    }, 100);
                    if(!OP.addMore){
                        $('#addPosition').modal('hide');
                    }
                     $(".product_item_name_label").removeClass("label-helper");
                }else{
                    Notification.error({message : response['message']||'Please double check all information!',delay : 2000});
                }
            });
        }
    }

    function savePurchase_order(){
        //check validate
        flag = false;
        var errString = 'Missing some Information:</br>';
        if(OP.purchase_order.order_no==''){
            errString +='- Field Order No.</br>' ;
            flag = true;
        }
        if(OP.purchase_order.order_date ==''){
            errString +='- Field Order Date.</br>' ;
            flag = true;
        }
        if(OP.purchase_order.supplier_id ==''){
            errString +='- Select Supplier.</br>' ;
            flag = true;
        }
        if(OP.purchase_order.customer_id ==''){
            errString +='- Select Customer.</br>' ;
            flag = true;
        }
        if(OP.purchase_order.position.length <=0){
            errString +='- Add Position.</br>' ;
            flag = true;
        }
        if(OP.purchase_order.currency ==''){
            errString +='- Select Currency.</br>' ;
            flag = true;
        }
        if(flag)
            Notification.error({message :errString ,delay : 5000});
             //end check validate
        else{
            if(isEdit)
            {
                orderService.updateOrder(OP.purchase_order).$promise.then(function(response){
                    if(response['success']){
                        Notification.success({message : 'Save order success',delay : 2000});
                    }else{
                        Notification.error({message : response['message']||'Check infor and try again!',delay : 2000});
                    }
                });
            }else{
                orderService.saveOrder(OP.purchase_order).$promise.then(function(response){
                    if(response['success']){
                        Notification.success({message : 'Save new order success',delay : 2000});
                        $state.reload();
                    }else{
                        Notification.error({message : response['message'],delay : 2000});
                    }
                });
            }
        }
    }
    function validateEmail(email) {
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(email);
    }
    function saveCompany(){
        var valid = false;
        var messageValid = 'Please, Input data in fields: </br>';
        if (OP.displayCompany.gildemeisterid == undefined || OP.displayCompany.gildemeisterid == '') {
            messageValid += '- Company no. </br>';
            valid = true;
        }
        if (OP.displayCompany.name == undefined ||OP.displayCompany.name == '') {
            messageValid += '- Company name. </br>';
            valid = true;
        }

        if (OP.displayCompany.locationid == undefined || OP.displayCompany.locationid == '') {
            messageValid += '- Select Location. </br>';
            valid = true;
        }

        if (OP.displayCompany.phone == undefined || OP.displayCompany.phone == '') {
            messageValid += '- Business phone. </br>';
            valid = true;
        }

        if (OP.displayCompany.mail == undefined || !validateEmail(OP.displayCompany.mail)) {
            messageValid += '- Email. </br>';
            valid = true;
        }
        if(OP.displayCompany.abbreviation_name == undefined){
            OP.displayCompany.abbreviation_name = '';
        }
        if(OP.displayCompany.fax == undefined){
            OP.displayCompany.fax = '';
        }
        if(OP.displayCompany.address == undefined){
            OP.displayCompany.address = '';
        }
        if(OP.displayCompany.contact_person == undefined){
            OP.displayCompany.contact_person = '';
        }
        if (valid) {
            Notification.error({ message: messageValid, delay: 5000 });
        } else {
            companyService.edit(OP.displayCompany).$promise.then(function(response){
                if(response['success']){
                    Notification.success({message : response['message']||'Update company success',delay : 2000});
                    $('#editCustomer').modal('hide');
                    if(OP.displayCompany.company_kind == "3")
                    {
                        companyService.getByType(window.globalVariable.company_kind.customer).then(function(data){
                            OP.customers = data;
                            angular.forEach(OP.customers, function(value, key) {
                                if(value.companyid == OP.customer){
                                    OP.cusEmail = value.mail;
                                    OP.cusContact = value.contact_person;
                                    displayCompany(value,3);
                                }
                            });
                        });
                    }else{
                        companyService.getByType(window.globalVariable.company_kind.supplier).then(function(data){
                            OP.suppliers = data;
                            angular.forEach(OP.suppliers, function(value, key) {
                                if(parseInt(value.companyid) == OP.supplier){
                                    OP.supEmail = value.mail;
                                    OP.supContact = value.contact_person;
                                    displayCompany(value,2);
                                }
                            });
                        });
                    }
                } 
                else{
                    Notification.error({message : response['message']||'Something wrong! pls reload page',delay : 2000});
                }
            });
        }
    }
    function showDetail(type)
    {
        if(type == 2)
        {
            flag = false;
            angular.forEach(OP.suppliers, function(value, key) {
            if(parseInt(value.companyid) == OP.supplier){
                displayCompany(value,type);
                flag = true;
                $('#editCustomer').modal('show');
            }
            });
            if(!flag)
                 Notification.error({message : 'Select Supplier first',delay : 2000});
        }else{
            flag = false;
            angular.forEach(OP.customers, function(value, key) {
                if(parseInt(value.companyid) == OP.customer){
                    displayCompany(value,type);
                    flag = true;
                    $('#editCustomer').modal('show');
                }
            });
            if(!flag)
                 Notification.error({message : 'Select Customer first',delay : 2000});
        }
    }
    function createPosition ()
    {
        var pNo = OP.positions[OP.positions.length-1]?OP.positions[OP.positions.length-1].position_no+1:1;
        return {
            "positionid":0,
            "product_item_no": "",
            "product_item_name":"",
            "product_item_line":"",
            "position_no":pNo,
            "ordered_quantity": '',
            "unit_price": '',
            "total_price": '',
            "ab":  [
                        {
                            abno:1,
                            shipped_quantity:'',
                            shipment_method:'',
                            expected_shipping_date:'',
                            confirmed_shipping_date:'',
                            shipping_date:'',
                            za_date:'',
                            eta_date:'',
                            etd_date:'',
                            relevant_due_date:'',
                            warehouse_book_date:''
                        }
                    ]
        };
    }
    function createComnpany (type){
        return {
            'gildemeisterid' : 0,
            'companyid' : 0,
            'title' : type == 2 ?'Supplier':'Customer',
            'company_kind' : type,
            'name' : '',
            'abbreviation_name' : '',
            'address' : '',
            'locationid' : '',
            'country_code_phone' : '',
            'phone' : '',
            'country_code_fax' : '',
            'fax': '',
            'mail' : '',
            'contact_person' : ''
        };
    }
    function displayCompany(value ,type)
    {
        OP.displayCompany.title = type == 2 ?'Supplier':'Customer';
        OP.displayCompany.gildemeisterid = value.gildemeisterid;
        OP.displayCompany.companyid = value.companyid;
        OP.displayCompany.company_kind = type;
        OP.displayCompany.name = value.name.trim();
        OP.displayCompany.abbreviation_name = value.abbreviation_name.trim();
        OP.displayCompany.address = value.address.trim();
        //bug select2
        OP.displayCompany.locationid = value.locationid;
        $('#loaction').select2('val',value.locationid);
        //end bug
        OP.displayCompany.country_code_phone = value.country_code_phone.trim();
        OP.displayCompany.phone = value.phone.trim();
        OP.displayCompany.country_code_fax = value.country_code_fax.trim();
        OP.displayCompany.fax = value.fax.trim();
        OP.displayCompany.mail = value.mail.trim();
        OP.displayCompany.contact_person = value.contact_person.trim();
    }
    //upload document
    OP.listfile = function(){
        OP.aFiles =[];
        angular.forEach(OP.listdocumentid,function(data){
            OP.aFiles.push(data);
        })
    }
    OP.removefile = function(index,id){
        OP.aFiles.splice(index, 1);
        OP.listdocumentid.splice(index,1);
        OP.listdocumentfn.splice(index,1);
        $http.delete(ENV.domain+'order_document.executeDocument?docId='+id,function(data){
        });
    }

    OP.uploadfile = function(){
        if(angular.isUndefined(OP.file)){
            Notification.error({message : 'Please select file to upload first',delay : 2000});
        }
        else{
            var req = {
            method: 'POST',
            url: ENV.domain+'order_document.uploadDocument',
            headers: {
            'Content-Type': undefined
            },
            data: OP.file
            }
            $http(req).then(function(d){
                if(d.data['success'])
                {
                    OP.listdocumentid = OP.listdocumentid.concat(d.data.docId);
                    OP.purchase_order.document = OP.listdocumentid;
                    OP.listdocumentfn = OP.listdocumentfn.concat(d.data.filename);
                    if(isEdit){
                        var data = {
                            docId:d.data.docId[0],
                            order_Id:OP.purchase_order.orderid
                        }
                        fileService.edit(data).then(function(){
                            Notification.success({message : d.data['message']||'Upload success',delay : 2000});
                        })
                    }else
                    Notification.success({message : d.data['message']||'Upload success',delay : 2000});
                    delete OP.file;
                }else{
                    Notification.error({message : d.data['message']||'Please select file to upload first',delay : 2000});
                }
                
            })
            $("ul.upload_listing").html("");
        }
    }
    //end upload file

});

app.controller('orderEvaluation', ['$scope','$timeout','ENV', function($scope,$timeout,ENV){
    $timeout(function () {
        pageSetUp();
    }, 100);
}]);

