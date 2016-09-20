'use strict';

appServices.factory('fileService',function(ENV,$resource,$log,$http){
    var api  = ENV.domain + 'order_document.executeDocument';
    var apiResouce = ENV.domain + 'product_item_document.execute/:id';
    return {
        getByID : function(id){
            return $http.get(api+'/?docId='+id).then(handeSuccess,handeError);
        },
        edit : function(data){
            return $http.put(api,data).then(handeSuccess,handeError);
        }
    };
     function handeSuccess(res){
         return res.data;
     }
     function handeError(res){
         return function(){
             return {success:false,message:res.data['message']||'Somethong wrong!'};
         }
     }
});
