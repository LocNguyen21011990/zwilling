'use strict'

appControllers.controller('loginCtrl',function(userService,$log,$state,Storage,Notification,$scope,$rootScope,$stateParams,vcRecaptchaService){
    
    var storageKey = 'user';
    var login = this;
    login.timeSignUp = 0;
    login.isOver3Times = false;
    login.lang = window.globalVariable.lang;
    login.signup = signup;
    login.forgotpassword = forgotpassword;
    login.resetpassword = resetpassword;
    if(Storage.get('token') != null){
        userService.singout().then(function(data){
            Storage.remove(storageKey);
            Storage.remove('token');
            $rootScope.username = '';
        });
    }
    var user = {};
    function signup(){
        var capcha = '';
        if(vcRecaptchaService != '') {
            capcha = vcRecaptchaService.getResponse(); 
        }
        userService.signup(login.username, login.password,login.lang,capcha, login.isOver3Times).then(function(data) {
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

    function resetpassword() {
        var params = $state.params;
        if(login.user_password === login.re_password) {
            userService.resetpassword(params.token, login.user_password).then(function(data) {
                if(data.success) {
                    login.errorMessage = data.message;
                    setTimeout(function() {
                        $state.go('login');
                    }, 1000);
                }
                else {
                    login.errorMessage = data.message;
                }
            });
        }
        else {
            login.errorMessage = "Confirm password not matching! Please try again.";
        }
        
    }
   
});