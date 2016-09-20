'use strict';


appServices.factory('userService',function(ENV,$resource,Storage,$log,$http){
     return {
           signup: function (username,password,lang) {
               var api = ENV.domain + 'user.login';
               var data = {"user_name": username, "user_password": password, "lang": lang};
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
           forgotpassword: function (email) {
            var api = ENV.domain + 'user.forgotUser';
            var data = {"email": email};
            return $http.post(api,data).then(handeSuccess,handeError('Error when get inspector'));
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
