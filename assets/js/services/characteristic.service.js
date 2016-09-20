'use strict';

appServices.factory('characteristicService',function(ENV,$resource,$log,$http){
    var api         = ENV.domain + 'characteristic.execute/:id';
    
    var resource    = $resource(api,null,{
        'update' : {method:'PUT'}
    });

    return {
        getAll : function(){
            return resource.query({},function(res){
                return res
            });
        },
        save : function(characteristic){
            return resource.save({},characteristic);
        },
        edit : function(characteristic){
            return resource.update({},characteristic);
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
