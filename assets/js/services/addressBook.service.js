'use strict';

appServices.factory('addressBookService',function(ENV,$resource,$log,$http){
    var api         = ENV.domain + 'addressBook.execute/:id';
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
             return $http.get(ENV.domain+'addressBook.execute/?company_kind='+type).then(handeSuccess,handeError('Error when singout'));
        },
        getLocations : function(){
            return $http.get(ENV.domain+'addressBook.getLocationList/').then(handeSuccess,handeError);
        },
        save : function(supplier){
            return resource.save({},supplier);
        },
        edit : function(company){
            return resource.update({},company);
        },
        getCompanyById : function(id){
            return $http.get(ENV.domain+'addressBook.execute/?id='+id).then(handeSuccess,handeError('Error when singout'));
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
