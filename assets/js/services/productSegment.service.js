'use strict';

appServices.factory('productSegmentService',function(ENV,$resource,$log,$http){
    var api         = ENV.domain + 'productSegment.execute/:id';
    var apiPSegment = $resource(ENV.domain +'productSegmentDocument.execute/:id');

    var resource    = $resource(api,null,{
        'update' : {method:'PUT'}
    });

    return {
        getAll : function(){
            return resource.query({},function(res){
                return res
            });
        },
        save : function(productSegment){
            return resource.save({},productSegment);
        },
        edit : function(productSegment){
            return resource.update({},productSegment);
        },
        editProductSegmentDocument :function(data){
        	return $http.put(apiPSegment, data).then(handeSuccess,handeError);
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
