'use strict'
appControllers.controller('loginCtrl',function(userService,$log,$state,Storage,Notification,$rootScope){
    
    var storageKey = 'user';
    var login = this;
    login.isOver3Times = false;
    login.timeSignUp = 0;
    login.lang = window.globalVariable.lang;
    login.signup = signup;
    login.forgotpassword = forgotpassword;
    if(Storage.get('token') != null){
        userService.singout().then(function(data){
            Storage.remove(storageKey);
            Storage.remove('token');
            $rootScope.username = '';
        });
    }
    var user = {};
    function signup(){
        userService.signup(login.username, login.password,login.lang).then(function(data) {
            if(data.success)
            {
                user=data.data;
                Storage.set(storageKey, user);
                Storage.set('token',user.token);
                $rootScope.username = Storage.get('user').user_name||'';
                $rootScope.userId = Storage.get('user').id_user||'';
                $rootScope.accesses = Storage.get('user').access||'';
                $state.go('home.dashboard');
            } else 
            {
                login.errorMessage = data.message;
                login.timeSignUp += 1;
                if(login.timeSignUp >= 3) {
                    login.isOver3Times = true;
                }
            }
        });
    }

    function forgotpassword() {
        userService.forgotpassword(login.email).then(function(data) {
            login.errorMessage = data.message;
        });
    }
   
});