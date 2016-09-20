'use strict';

appServices.factory('companyService',function(ENV,$resource,$log,$http){
    var api         = ENV.domain + 'company.execute/:id';
    var resource    = $resource(api,null,{
        'update' : {method:'PUT'}
    });

    return {
        getAll : function(){
            return resource.query({},function(res){
                return res
            });
        },
        getByType : function(type){
             return $http.get(ENV.domain+'company.execute/?company_kind='+type).then(handeSuccess,handeError('Error when singout'));
        },
        getLocations : function(){
            return $http.get(ENV.domain+'company.getLocationList/').then(handeSuccess,handeError);
        },
        save : function(supplier){
            return resource.save({},supplier);
        },
        edit : function(company){
            return resource.update({},company);
        },
        getCompanyById : function(id){
            return $http.get(ENV.domain+'company.execute/?id='+id).then(handeSuccess,handeError('Error when singout'));
        }
    };
     function handeSuccess(res){
         return res.data;
     }
     function handeError(res){
         return function(){
             return {success:false,message:res.data['message']||'Somethong wrong!'};
         }
     }
});
