"use strict";
app.controller('productListing', function($compile,$q,$log,$scope,$rootScope, $state, $timeout, $http, ENV, DTOptionsBuilder, DTColumnBuilder, DTColumnDefBuilder, productItemService, Notification, fileService) {

    var productList = [];
    $scope.productChild = [];
    $scope.isEdit = false;
    var isSet = false;
    var arrDel = [];
    var idRowCurr = -1;
    var qlArray = [];
     $scope.selection = [];
    $http.get(ENV.domain+'ql.executeQL').then(function(res){
        qlArray = res.data
    });
    $scope.getObjectsData = function(term, result) {
        result(qlArray);
    };

// return id
$scope.complexId = function (item) {
    return item.quality_level;
};

//return displayed label
$scope.complexText = function (item) {
    return item.quality_level;
};

    $scope.dtOptions = DTOptionsBuilder.fromFnPromise(function() {return initListProduct()})
        .withOption('createdRow', function(row, data, dataIndex) {
            $compile(angular.element(row).contents())($scope);
        })
        .withButtons([
            'print',
            'excel'
        ])
        .withPaginationType('full_numbers')
        .withColumnFilter({
            sPlaceHolder: 'head:before',
            aoColumns: [{
                type: 'text'
            }, {
                type: 'text'
            }, {
                type: 'text'
            }, {
                type: 'text'
            }, {
                type: 'text'
            }, {
                type: 'text'
            }]
        });

    $scope.dtColumns = [
        DTColumnBuilder.newColumn('pcode').withTitle('No.'),
        DTColumnBuilder.newColumn('plinename').withTitle('Product Line'),
        DTColumnBuilder.newColumn('pname').withTitle('Product Item'),
        DTColumnBuilder.newColumn('psegname').withTitle('Segment'),
        DTColumnBuilder.newColumn('brandname').withTitle('Brand'),
        DTColumnBuilder.newColumn('ql').withTitle('QL'),
        DTColumnBuilder.newColumn('active').withTitle('Set Composition').renderWith(renderComposition),
        DTColumnBuilder.newColumn(null).withTitle('Edit').renderWith(renderAction)
    ];
     
    $scope.dtColumnDefs = [];
    $scope.dtInstance = {};

    function renderAction(data,type,full,meta) {
        return '<a class="cursor" ng-click="editItem(\''+full.pcode.trim()+'\',\''+full.active+'\',\''+meta.row+'\')"><i class="fa fa-pencil-square-o"></i></a>';
    }
    
    $scope.editItem = function(id,active,idrow){
        $http.get(ENV.domain+'productItem.execute/?id='+id).then(function(res){
           $scope.component = res.data;
           $scope.product_segment_name = res.data.product_segment_name_english;
           $scope.brandname = res.data.brandname;
           $scope.searchResult = res.data.product_line_name_english;
           $scope.selection = [];
            angular.forEach(qlArray,function(value,key){
                angular.forEach($scope.component.product_item_ql,function(val,k){
                    if(value.quality_level == val.ql)
                    {
                        if(val.isDefault == 1)
                            $scope.selection.unshift(value);
                        else
                            $scope.selection.push(value);
                        $scope.component.product_item_ql.splice(k,1);
                    }
                })
            })
            if(active == 1 ){
                $scope.addItem = true;
                isSet = true
            }else{
                $scope.addItem = false;
                isSet = false;
            }
            listtFilesid=[];
            $scope.listFileName=[];
            listsFilesid=[];
            $scope.listsFileName=[];
            angular.forEach($scope.component.product_item_document,function(value) {
                if(value.type=="technical"){
                    listtFilesid.push(value.product_document_id);
                    $scope.listFileName.push(value.fileName);
                }else{
                    listsFilesid.push(value.product_document_id);
                    $scope.listsFileName.push(value.fileName);
                }
            });
            $scope.component.product_item_document = listtFilesid.concat(listsFilesid);
            $scope.isEdit = true;
            idRowCurr=idrow;
            $scope.productChild;
            $(".product_item_no_label").addClass("label-helper");
        });
        $("html, body").animate({ scrollTop: 0 }, "slow");
    }
    $scope.resetPage = resetPage;

    function renderComposition(data) {
        var active = "";
        if (data === 1) {
            active = "<i class='fa fa-check-square-o'></i>";
        }
        return active;
    }
    //defind variable
    $scope.component = createProductItem();
    $scope.addComposition = addComposition;
    $scope.delComposition = delComposition;
    $scope.saveProduct = saveProduct;
    var newItem = {};
    //end defind variable
    //load data
   
    //end load data

    //autocomplete
    $scope.listProducts = [];
    productItemService.getProductLines().$promise.then(function(data){
        angular.forEach(data,function(value){
            $scope.listProducts.push({
                value:value['plname'],
                label:value['plcode'] + '::' + value['plname'],
                segment: value['psname'],
                code:value['plcode'],
                brand: value['brandname'],
                ql:value['ql']
            });
        }) 
    });
    $scope.tretrau = function(index){
        $log.debug(index);
    }

     $scope.searchProduct = {
        options: {
            html: true,
            minLength: 3,
            onlySelectValid: true,
            outHeight: 50,
            source: function (request, response) {
                var data = [];
                data = $scope.productChild;
                data     = $scope.searchProduct.methods.filter(data, request.term);
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
                if($scope.isEdit == true){
                    if($scope.addItem && isSet==false)
                    {
                        if(ui.item.value == $scope.component.product_item_no)
                        {
                            Notification.error({message:"Cannot choose itself!"})
                            ui.item.value = null;
                        }else{
                        }
                    }

                } 
                var index = event.target.id.split('_')[1];
                $scope.component.product_item_set[index].product_item_name = ui.item.label.split('::')[1];
            },
            change:function(event,ui){
                if(ui.item == null){
                    var index = event.target.id.split('_')[1];
                    $scope.component.product_item_set[index].product_item_name = "";
                }
            }
        }
    };

    $scope.searchProductitem = {
        options: {
            html: true,
            minLength: 3,
            onlySelectValid: true,
            outHeight: 50,
            source: function (request, response) {
                var data = [];
                data = $scope.listProducts;
                data     = $scope.searchProductitem.methods.filter(data, request.term);
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
                $scope.product_segment_name = ui.item.segment;
                $scope.component.product_line_no = ui.item.code;
                $scope.brandname = ui.item.brand;

                newItem.plinename= ui.item.value;
                newItem.psegname =  ui.item.segment;
                newItem.brandname = ui.item.brand;
            },
            change:function(event,ui){
                if(ui.item==null)
                {
                    $scope.product_line_no = '';
                    $scope.product_segment_name = '';
                    $('#product_segment_name').val('');
                    $('#brandname').val('');
                    $scope.brandname = '';
                }
            }
        }
    };
    //end autocomplete 

    //upload document
        var listtFilesid = [];
        $scope.listFileName = [];
        $scope.tFiles =[];
        $scope.listFileTech = function(){
            $scope.tFiles =[];
            angular.forEach(listtFilesid,function(data){
                $scope.tFiles.push(data);
            })
        }
        $scope.removefileTech = function(index,id){
            $http.delete(ENV.domain+'productItemDocument.execute?docId='+id).then(function(res){
                if(res.data['success']){
                    $scope.tFiles.splice(index, 1);
                    listtFilesid.splice(index,1);
                    $scope.listFileName.splice(index,1);
                    Notification.success({message : 'Delete file success',delay : 2000});
                }else{
                    Notification.error({message : 'Can not delete this file',delay : 2000});
                }
            });
        }

        $scope.uploadFileTech = function(){
            if(!$scope.fileTech){
                Notification.error({message : 'Please select file to upload first',delay : 2000});
            }else{
                 for(var i =0 ;i<$scope.fileTech.length;i++){
                    $scope.fileTech[i].typeDocument = "technical";
                }
                var req = {
                method: 'POST',
                url: ENV.domain+'productItemDocument.uploadProductDocument',
                headers: {
                'Content-Type': undefined
                },
                data: $scope.fileTech
                }
                $http(req).then(function(d){
                    if(d.data['success'])
                    {
                        listtFilesid = listtFilesid.concat(d.data.docId);
                        $scope.listFileName = $scope.listFileName.concat(d.data.filename);
                        Notification.success({message : 'Upload success',delay : 2000});
                        delete $scope.fileTech;
                    }else{
                        Notification.error({message : d.data['message']||'Please select file to upload first',delay : 2000});
                    }
                    
                })
                $("ul.upload_listing").html("");
            }
           
        }

        var listsFilesid = [];
        $scope.listsFileName = [];
        $scope.sFiles =[];
        $scope.listfileSpec = function(){
            $scope.sFiles =[];
            angular.forEach(listsFilesid,function(data){
                $scope.sFiles.push(data);
            })
        }
        $scope.removefileSpec = function(index,id){
            $http.delete(ENV.domain+'productItemDocument.execute?docId='+id).then(function(res){
                if(res.data['success']){
                    $scope.sFiles.splice(index, 1);
                    listsFilesid.splice(index,1);
                    $scope.listsFileName.splice(index,1);
                    Notification.success({message : 'Delete file success',delay : 2000});
                }else{
                    Notification.error({message : 'Can not delete this file',delay : 2000});
                }
            });
        }

        $scope.uploadfileSpec = function(){
            if(!$scope.fileSpec){
                Notification.error({message : 'Please select file to upload first',delay : 2000});
            }else{
                 for(var i =0 ;i<$scope.fileSpec.length;i++){
                    $scope.fileSpec[i].typeDocument = "specification";
                }
                var req = {
                method: 'POST',
                url: ENV.domain+'productItemDocument.uploadProductDocument',
                headers: {
                'Content-Type': undefined
                },
                data: $scope.fileSpec
                }
                $http(req).then(function(d){
                    if(d.data['success'])
                    {
                        listsFilesid = listsFilesid.concat(d.data.docId);
                        $scope.listsFileName = $scope.listsFileName.concat(d.data.filename);
                        Notification.success({message : 'Upload success',delay : 2000});
                        delete $scope.fileSpec;
                    }else{
                        Notification.error({message : d.data['message']||'Please select file to upload first',delay : 2000});
                    }
                    
                })
                $("ul.upload_listing_spec").html("");
            }
           
        }
    //end upload file
    function saveProduct(){
        // check validate
        var flag = false;
        var errString = 'Missing some Information:</br>';
        if($scope.component.product_item_no==''){
            errString +='- Field Product Item No.</br>' ;
            flag = true;
        }
        if($scope.component.product_item_name_english ==''){
            errString +='- Field Product Item Name.</br>' ;
            flag = true;
        }
        if($scope.component.product_line_no ==''){
            errString +='- Field Product Line Name.</br>' ;
            flag = true;
        }
        if($scope.selection.length == 0){
            errString +='- Select Quality Level.</br>' ;
            flag = true;
        }
        // if($scope.component.ean_code ==''){
        //     errString +='- Field Ean code.</br>' ;
        //     flag = true;
        // }
        angular.forEach($scope.component.product_item_set,function(value,key){
            if($scope.addItem){
                if(value.child_product_item_no == '' || value.quantity=="")
                {
                    var count = key+1;
                    errString +='- Missing information in Product Child number '+ count+"</br>";
                    flag = true;
                }
            }
        });
        if(flag)
            Notification.error({message :errString ,delay : 5000});
                //end check validate
        else{
            if($scope.isEdit){
                if(!isSet && !$scope.addItem){
                    delete $scope.component.product_item_set;
                }else if(!isSet && $scope.addItem){
                    var itemRoot = {
                        "child_product_item_no": $scope.component.product_item_no,
                        "quantity": 1,
                        'isDelete':false,
                        "parent_product_item_no" :  $scope.component.product_item_no
                    }
                    $scope.component.product_item_set.push(itemRoot);
                }else if(isSet && !$scope.addItem){
                    var newChildList = [];
                    angular.forEach($scope.component.product_item_set,function(value,key){
                        var item = {
                            "isDelete": true,
                            "set_compositionid": value.set_compositionid,
                            "child_product_item_no": value.child_product_item_no,
                            "quantity": value.quantity,
                            "parent_product_item_no" :  $scope.component.product_item_no
                        }
                        newChildList.push(item);
                    });
                    $scope.component.product_item_set = newChildList;
                }else if(isSet && $scope.addItem){
                    var newChildList = [];
                    angular.forEach($scope.component.product_item_set,function(value,key){
                        if(value.child_product_item_no !== value.parent_product_item_no){
                            var item = {
                            "isDelete": false,
                            "set_compositionid": value.set_compositionid,
                            "child_product_item_no": value.child_product_item_no,
                            "quantity": value.quantity,
                            "parent_product_item_no" :  $scope.component.product_item_no
                            }
                            newChildList.push(item);
                        }
                        if(!value.set_compositionid)
                            delete item.set_compositionid;
                    });
                     angular.forEach(arrDel,function(value,key){
                        if(value.child_product_item_no !== value.parent_product_item_no){
                            var item = {
                            "isDelete": true,
                            "set_compositionid": value.set_compositionid,
                            "child_product_item_no": value.child_product_item_no,
                            "quantity": value.quantity,
                            "parent_product_item_no" :  $scope.component.product_item_no
                            }
                             newChildList.push(item);
                        }
                    });
                    $scope.component.product_item_set = newChildList;
                }
                $scope.component.updateby = $rootScope.username;   
                $scope.component.product_item_document = listtFilesid.concat(listsFilesid);
                $scope.component.product_item_ql=[];
                var displayQL = "";
                angular.forEach($scope.selection,function(value,key){
                    if(key==0)
                        displayQL = value.quality_level;
                    $scope.component.product_item_ql.push({ql:value.quality_level,isDefault:key==0?1:0});
                });
                productItemService.edit($scope.component).$promise.then(function(res){
                    if(res['success'])
                    {
                        var test = {
                            brandname:$scope.component.brandname,
                            pcode:$scope.component.product_item_no,
                            plinename:$scope.component.product_line_name_english,
                            pname:$scope.component.product_item_name_english,
                            psegname:$scope.component.product_segment_name_english,
                            ql:displayQL,
                            active:$scope.addItem==true?1:""
                        }
                        var table=$('#product_item_datatable').DataTable();
                        table.row(idRowCurr).remove();
                        table.row.add(test);
                        resetPage();
                         Notification.success({message : res['message']||'Edit Product Item success',delay : 2000});
                    }else{
                        Notification.error({message : res['message']||'Something wrong. Please double check all information',delay : 2000});
                    }
                });
            }
            else{
                if($scope.addItem){
                    var itemRoot = {
                        "child_product_item_no": $scope.component.product_item_no,
                        "quantity": 1
                    }
                    $scope.component.product_item_set.push(itemRoot);
                    angular.forEach($scope.component.product_item_set,function(value){
                        value.parent_product_item_no =  $scope.component.product_item_no;
                    });
                }else{
                    delete $scope.component.product_item_set;
                }

                $scope.component.product_item_ql=[];
                var displayQL = "";
                angular.forEach($scope.selection,function(value,key){
                    if(key==0)
                        displayQL = value.quality_level;
                    $scope.component.product_item_ql.push({ql:value.quality_level,isDefault:key==0?1:0});
                });

                $scope.component.product_item_document = listtFilesid.concat(listsFilesid);
                productItemService.save($scope.component).$promise.then(function(res){
                    if(res['success'])
                    {   
                        Notification.success({message : res['message']||'Save Product Item success',delay : 2000});
                        newItem.pcode =  $scope.component.product_item_no;
                        newItem.ql = displayQL;
                        newItem.pname =  $scope.component.product_item_name_english;
                        newItem.active = $scope.addItem==true?1:"";
                        var table=$('#product_item_datatable').DataTable();
                        table.row.add(newItem);
                        resetPage();
                    }else{
                            Notification.error({message : res['message']||'Something wrong. Please double check all information',delay : 2000});
                    }
                 })
            }
        }
    }

    function initListProduct(){
        var deferred = $q.defer();
        $http.get(ENV.domain + 'productItem.getProductItems/').then(function(res){
            productList = res.data;
            deferred.resolve(productList);
        });
        return deferred.promise;
    }
    function createProductItem(){
        return {
            "product_item_no": "",
            "product_item_name_english": "",
            "product_line_no": "",
            "product_item_name_german":"",
            "updateby": $rootScope.username,
            "ean_code": "",
            "product_item_set":[],
            "product_item_document": [],
            "product_item_ql": "",
            "shape" : "",
            "colour":"",
            "size": ""
        }
    }
    function initListProductChild(){
        productItemService.getProductChid().$promise.then(function(res){
            $scope.productChild = res;
        });
    }
    function resetPage(){
        $scope.component = createProductItem();
        $scope.addItem = false;
        $scope.searchResult = '';
        //reset arrDel when save
        arrDel = [];
        $scope.product_segment_name ='';
        $scope.brandname = '';
        listtFilesid = [];
        $scope.listFileName = [];
        $scope.tFiles =[];
        listsFilesid = [];
        $scope.listsFileName = [];
        $scope.sFiles =[];
        initListProductChild();
        $scope.selection = [];
        $scope.isEdit = false;
        idRowCurr = -1;
        $(".product_item_no_label").removeClass("label-helper");
    }
    function addComposition(){
        if($scope.productChild.length <=0){
           initListProductChild();
        }
        var item_set = {
            "child_product_item_no": "",
            "product_item_name": "",
			"quantity": ''
        }
        if($scope.isEdit){
            item_set.isDelete = false;
        }
        $scope.component.product_item_set.push(item_set);
    }
    function delComposition(index){
        if(!$scope.isEdit || !isSet)
            $scope.component.product_item_set.splice(index,1);
        else{
            arrDel.push($scope.component.product_item_set[index]);
            $scope.component.product_item_set[index].isDelete = true;
            $scope.component.product_item_set.splice(index,1);
        }
    }
    $scope.checkProductItem = function(){
        if($scope.component.product_item_set.length<=0){
           addComposition();
        }
    }
});
