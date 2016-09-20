'use strict';

appServices.factory('orderService',function(ENV,$resource,$log,$http){
    var api = ENV.domain + 'order.position/:id';
    var apiOrder = ENV.domain + 'order.execute/:id';
    var resource = $resource(api,null,{
        'update' : {method:'PUT'}
    });
    var resourceOrder = $resource(apiOrder,null,{
        'update' : {method:'PUT'}
    });

    return {
        getAll : function(){
            return resource.query({},function(res){
                return res;
            });
        },
        getById : function(id){
            return  $http.get(ENV.domain+'order.execute/?id='+id).then(handeSuccess,handeError);
        },
        savePosition :function(position){
            return resource.save({},position);
        },
        updatePosition :function(position){
            return resource.update({},position);
        },
        checkOrderExist:function(orderno){
            return $http.get(ENV.domain + 'order.orderExist?order_no='+orderno).then(handeSuccess,handeError);
        },
        saveOrder:function(order){
            return resourceOrder.save({},order);
        },
        updateOrder:function(order){
            return resourceOrder.update({},order);
        },
        deleteAb:function(id){
            return $http.delete(ENV.domain + 'order.deleteAb/?id='+id).then(handeSuccess,handeError);
        },
        delete : function(id){
            return $http.delete(ENV.domain + 'order.position/?id='+id).then(handeSuccess,handeError);
        },
        getTransport:function(){
            return $http.get(ENV.domain+'order.transport/').then(handeSuccess,handeError);
        }
    };
     function handeSuccess(res){
         return res.data;
     }
     function handeError(res){
         return function(){
             return {success:false,message:res.error||'Error when get tranport list'}
         }
     }
});