'use strict';

appServices.factory('locationService',function(ENV,$resource,$log,$http){
    var api         = ENV.domain + 'location.execute/:id';

    var resource    = $resource(api,null,{
        'update' : {method:'PUT'}
    });

    return {
        getAll : function(){
            return resource.query({},function(res){
                return res
            });
        },
        save : function(location){
            return resource.save({},location);
        },
        edit : function(location){
            return resource.update({},location);
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
