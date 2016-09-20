'use strict';

appServices.factory('qlService',function(ENV,$resource,$log,$http){
    var api         = ENV.domain + 'ql.executeQL/:id';

    var resource    = $resource(api,null,{
        'update' : {method:'PUT'}
    });

    return {
        getAll : function(){
            return resource.query({},function(res){
                return res
            });
        },
        save : function(ql){
            return resource.save({},ql);
        },
        edit : function(ql){
            return resource.update({},ql);
        },
        getAvgAql : function(){
            return $http.get(ENV.domain+'ql.getAvgQL/').then(handeSuccess,handeError);
        }
        /*,
        getCompanyById : function(id){
            return $http.get(ENV.domain+'company.execute/?id='+id).then(handeSuccess,handeError('Error when singout'));
        }*/
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
