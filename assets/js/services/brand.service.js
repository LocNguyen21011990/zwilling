'use strict';

appServices.factory('brandService',function(ENV,$resource,$log,$http){
    var api         = ENV.domain + 'brand.execute/:id';
    
    var resource    = $resource(api,null,{
        'update' : {method:'PUT'}
    });

    return {
        getAll : function(){
            return resource.query({},function(res){
                return res
            });
        },
        save : function(productLine){
            return resource.save({},productLine);
        },
        edit : function(productLine){
            return resource.update({},productLine);
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
