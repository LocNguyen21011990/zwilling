'use strict';

appServices.factory('contactService',function(ENV,$resource,$log,$http){
    var api         = ENV.domain + 'contact.execute/:id';
    var apiCompany  = $resource(ENV.domain + 'contact.getListCompany/');
    var apiLocation = $resource(ENV.domain + 'addressBook.getLocationList/');

    var resource    = $resource(api,null,{
        'update' : {method:'PUT'}
    });

    return {
        getAll : function(){
            return resource.query({},function(res){
                return res
            });
        },
        getLocations : function(){
            return apiLocation.query({}, function(res){
                return res;
            });
        },
        save : function(contact){
            return resource.save({},contact);
        },
        edit : function(contact){
            return resource.update({},contact);
        },
        getListCompany : function(){
            return apiCompany.query({}, function(res){
                return res;
            });
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
