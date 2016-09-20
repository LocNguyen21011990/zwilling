'use strict';

appServices.factory('productItemService',function(ENV,$resource,$log,$http){
    var api             = ENV.domain + 'productItem.execute/:id';

    // var resource        = $resource(api);
    var resource        = $resource(api,null,{
                                'update' : {method:'PUT'}
                            });
    var apiLoadProduct      = $resource(ENV.domain+'productItem.getProductItems/');
    var apiProductChid      = $resource(ENV.domain+'productItem.getListProductItemChid/')
    var apiProductDocument  = $resource(ENV.domain+'productItemDocument.execute/:id');
    var apiLoadByLine       = $resource(ENV.domain+'productItem.loadByProductLine/');
    var apiProductItemNo    = $resource(ENV.domain+'productItem.getListProductItemNo/'); 
    return {
        getAll : function(){
            return resource.query({},function(res){
                return res;
            });
        },
        getPLineById : function(plcode){
            return $http.get(ENV.domain + 'productItem.execute/?plcode='+plcode).then(handeSuccess,handeError);
        },
        getProductChid :function(){
            return apiProductChid.query({},function(res){
                return res;
            });
        },
        save : function(pItem){
            return resource.save({},pItem);
        },
        edit : function(pItem){
            return resource.update({},pItem);
        },
        getProductLines : function(){
        	return apiLoadByLine.query({},function(res){
                return res;
            })
        },
        loadProduct : function(){
            return apiLoadProduct.query({},function(res){
                return res;
            });
        },
        getProductDocument : function(res){
            return apiProductDocument.query({},function(res){
                return res;
            });
        },
        getItemDocumentById : function(docId){
            return $http.get(ENV.domain +'productItemDocument.getProductDocumentById/?docId='+docId).then(handeSuccess,handeError);
        },
        editProductDocument : function(data){
            return $http.put(apiProductDocument, data).then(handeSuccess,handeError);
        },
        getProductItemNo : function(){
            return apiProductItemNo.query({}, function(res){
                return res;
            });
        }
    };
    function handeSuccess(res){
         return res.data;
     }
     function handeError(res){
         return function(){
             return {success:false,message:res.data['message']||'Error when get Location'};
         }
     }
});