'use strict';

appServices.factory('aqlService',function(ENV,$resource,$log,$http){
    var api         = ENV.domain + 'aql.execute/:id';

    var resource    = $resource(api,null,{
        'update' : {method:'PUT'}
    });

    return {
        getAll : function(){
            return resource.query({},function(res){
                return res
            });
        },
        save : function(aql){
            return resource.save({},aql);
        },
        edit : function(aql){
            return resource.update({},aql);
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
