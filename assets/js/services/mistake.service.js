'use strict';

appServices.factory('mistakeService',function(ENV,$resource,$log,$http){
    var api         = ENV.domain + 'mistakeDictionary.execute/:id';
    
    var apiCheck    = $resource(ENV.domain+'mistakeDictionary.getMistakeDics/');
    var resource    = $resource(api,null,{
        'update' : {method:'PUT'}
    });

    return {
        getAll : function(){
            return resource.query({},function(res){
                return res
            });
        },
        save : function(mistake){
            return resource.save({},mistake);
        },
        edit : function(mistake){
            return resource.update({},mistake);
        },
        getListProductSegment :function(){
        	return $http.get(ENV.domain + 'mistakeDictionary.getListProductSegment/').then(handeSuccess,handeError);
        },
   		getListCharacteristic : function(){
   			return $http.get(ENV.domain + 'mistakeDictionary.getListCharacteristic/').then(handeSuccess,handeError);
   		},
        getListCheck : function(){
            return apiCheck.query({},function(res){
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
