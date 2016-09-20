'use strict'
//Global variable use for setting color, start page, message, oAuth key.
window.globalVariable = {
    startPage:{
        url:'/login',
        state: 'login'
    },
    lang:'eng',
    company_kind:{
        customer: 3,
        supplier :2
    },
    document_type:{
        product_item:1,
        product_segment:2
    }
};

var app = angular.module('zwillingApp', ['zwilling.controllers','angular.filter','zwilling.services','ui.router','ngResource','ui-notification','ui.select2','ui.select2.sortable','datatables','datatables.buttons','datatables.columnfilter','naif.base64', 'ui.autocomplete','chart.js','angular-loading-bar', 'vcRecaptcha'])
.run(function($rootScope, $state,$timeout,Storage){
    if(Storage.get('user')){
        $rootScope.username = Storage.get('user').user_name;
        $rootScope.userId = Storage.get('user').id_user;
    }
    else{
        $rootScope.username = '';
         $rootScope.userId = '';
    }
    $rootScope.$on("$stateChangeStart", function(event, toState, toParams, fromState, fromParams){
        if(toState.authenticate){
            if(Storage.get('token')==null)
            {
                $state.go("login");
                event.preventDefault(); 
            }
        }
    })
    
    $timeout(function () {
        var currentURl = window.location.hash;
        if(currentURl != '') {
            var subnavigation   = $("#left-panel").find("[href='"+currentURl+"']").parent().parent();
            var navigation      = subnavigation.parent();
            subnavigation.removeClass("hidden");
            navigation.addClass("active open");
        }
    }, 200)

})
.config(function($httpProvider){
    
    //interceptors every HTTP request and inject it with an Authorization header
    $httpProvider.interceptors.push(['$q', '$location', 'Storage', function ($q, $location, Storage) {
        return {
            'request': function (config) {
                config.headers = config.headers || {};
                if (Storage.get('token')!=null) {
                    config.headers.Authorization = Storage.get('token');
                }
                return config;
            },
            'responseError': function (response) {
                if (response.status === 401 || response.status === 403) {
                    $location.path('/login');
                }
                return $q.reject(response);
            }
        };
    }]);
})
.config(['cfpLoadingBarProvider', function(cfpLoadingBarProvider) {
    cfpLoadingBarProvider.includeSpinner = false;
}])