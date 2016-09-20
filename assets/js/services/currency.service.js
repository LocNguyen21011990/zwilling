'use strict';

appServices.factory('currencyService',function(ENV,$resource,$log,$http){
    var api         = ENV.domain + 'currency.execute/:id';
    
    var resource    = $resource(api,null,{
        'update' : {method:'PUT'}
    });

    return {
        getAll : function(){
            return resource.query({},function(res){
                return res
            });
        },
        save : function(currency){
            return resource.save({},currency);
        },
        edit : function(currency){
            return resource.update({},currency);
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
