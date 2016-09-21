'use strict';


appServices.factory('userService',function(ENV,$resource,Storage,$log,$http){
    var restFul = ENV.domain + 'user.execute/:id';
    var resource    = $resource(restFul,null,{
        'update' : {method:'PUT'}
    });
     return {
           signup: function (username,password,lang,capcha,is3Times) {
               var api = ENV.domain + 'user.login';
               var data = {"user_name": username, "user_password": password, "lang": lang, "capcha": capcha, "is3Times": is3Times};
               return $http.post(api,data).then(handeSuccess,handeError('Error conneting server'));
           },

           singout: function(){
               var api = ENV.domain + 'user.logout';
               return $http.get(api).then(handeSuccess,handeError('Error when singout'));
           },

           listInspection: function(){
            var api = ENV.domain + 'user.execute?user_type=inspector';
            return $http.get(api).then(handeSuccess,handeError('Error when get inspector'));
           },

           getRoles: function name() {
               var api = ENV.domain + 'user.getRole';
               return $http.get(api).then(handeSuccess,handeError('Error when get Roles'));
           },

           forgotpassword: function (email) {
            var api = ENV.domain + 'user.forgotUser';
            var data = {"email": email};
            return $http.post(api,data).then(handeSuccess,handeError('Error when get inspector'));
           },

           getAll : function(){
                return resource.query({},function(res){
                    return res
                });
           },

           save : function(user){
                return resource.save({},user);
           },

           edit : function (user){
               return resource.update({},user);
           },

           resetpassword: function(token, user_password) {
                var api = ENV.domain + 'user.resetPassword';
                var data = {"token": token, "user_password": user_password};
                return $http.put(api,data).then(handeSuccess,handeError('Error when get inspector'));
           },

           getById : function(id){
                return $http.get(ENV.domain+'user.execute/?id='+id).then(handeSuccess,handeError('Error when get user id: '+id));
           }
     };
     function handeSuccess(res){
         return res.data;
     }
     function handeError(error){
         return function(){
             return {success:false,message:error}
         }
     }
});
