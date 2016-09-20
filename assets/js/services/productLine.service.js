'use strict';

appServices.factory('productLineService',function(ENV,$resource,$log,$http){
    var api         = ENV.domain + 'productLine.execute/:id';
    
    var apiBrand 	= $resource(ENV.domain+'productLine.getBrands/');
    var apiProductSegment = $resource(ENV.domain+'productLine.getProductSegments/');
    var apiQl 		= $resource(ENV.domain+'productLine.getQls/');

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
        },
        getBrands : function(){
        	return apiBrand.query({}, function(res){
        		return res;
        	});
        },
        getProductSegments : function(){
        	return apiProductSegment.query({},function(res){
        		return res;
        	});
        },
        getQls :function(){
        	return apiQl.query({},function(res){
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
