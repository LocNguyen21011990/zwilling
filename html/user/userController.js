"use strict";
app.controller('userListing', function($compile, $http,$log, $scope, $timeout, ENV, DTOptionsBuilder, DTColumnBuilder, Notification,userService) {
   
   userService.getRoles().then(function(data){
       $scope.roles = data
   })
    $scope.dtOptions = DTOptionsBuilder.fromFnPromise(function(){
         return userService.getAll().$promise.then(function(data) {
                $scope.listUser = data;
                return $scope.listUser;

            })
    })
        .withOption('createdRow', function(row, data, dataIndex) {
            $compile(angular.element(row).contents())($scope);
        })
        .withButtons([
            'print',
            'excel'
        ])
        .withPaginationType('full_numbers')
        .withColumnFilter({
            sPlaceHolder: 'head:before',
            aoColumns: [{
                type: 'text'
            }, {
                type: 'text'
            }, {
                type: 'text'
            }, {
                type: 'text'
            }]
        });
    $scope.dtColumns = [
        DTColumnBuilder.newColumn('user_name').withTitle('User Name'),
        DTColumnBuilder.newColumn('displayname').withTitle('Display Name'),
        DTColumnBuilder.newColumn('email').withTitle('Email Address'),
        DTColumnBuilder.newColumn('id_role').withTitle('Roles'),
        DTColumnBuilder.newColumn('is_active').withTitle('Active'),
        DTColumnBuilder.newColumn(null).withTitle('Edit').renderWith(renderAction)
    ];
    $scope.dtColumnDefs = [];
    $scope.dtInstance = {};
    $scope.changeActive = changeActive;
    $scope.listUser = [];
    $scope.reset = reset;
    $scope.saveUser = saveUser;
    $scope.checkInspector = checkInspector;
    $scope.user = createUser();
    $scope.edit = edit;
    $scope.isInspector = false;
    var valid = false;
    var isEdit = false;
    var arrRoles = [];

    function renderAction(data,type,full,meta) {
        return '<a class="cursor"><i class="fa fa-pencil-square-o" ng-click="edit('+data.id_user+')"></i></a>';
    }
    function changeActive(isCheck){
        if(isCheck)
            $scope.user.is_active = 1;
        else
            $scope.user.is_active = 0;
    }
    function saveUser(){
        valid = false;

        var messageValid = 'Please, Input data in fields: </br>';
        if ($scope.user.user_name == '') {
            messageValid += '- User Name. </br>';
            valid = true;
        }
        if ($scope.user.first_name == '') {
            messageValid += '- Display Nane. </br>';
            valid = true;
        }

        if($scope.user.email ==''){
            messageValid += '- Email. </br>';
            valid = true;
        }else if(!validateEmail($scope.user.email)) {
            messageValid += '- Email  is not valid . </br>';
            valid = true;
        }
        

        if ($scope.user.id_role.length == 0) {
            messageValid += '- Select Roles. </br>';
            valid = true;
        }

        if (valid) {
            Notification.error({ message: messageValid, delay: 5000 });
        } else {
            if(isEdit){
                userService.edit($scope.user).$promise.then(function(response){
                        if (response['success']) {
                            Notification.success({ message: response['message'] || 'Update record ql success', delay: 2000 });
                            $scope.dtInstance.reloadData();
                            $scope.reset();
                        } else {
                            Notification.error({ message: response['message'] || 'Update record failed', delay: 2000 });
                        }
                })
            }else{
                userService.save($scope.user).$promise.then(function(response){
                        if (response['success']) {
                            Notification.success({ message: response['message'] || 'Insert record ql success', delay: 2000 });
                            $scope.dtInstance.reloadData();
                            $scope.reset();
                        } else {
                            Notification.error({ message: response['message'] || 'Insert record failed', delay: 2000 });
                        }
                })
            }
            
        }
    }
    function edit (id){
        userService.getById(id).then(function(response){
            var editUser = createUser();
            editUser.first_name = response.first_name;
            editUser.user_name = response.user_name;
            editUser.id_role = response.id_role.split(',').map(Number);;
            editUser.email = response.email;
            editUser.user_type = response.user_type;
            editUser.is_active = response.is_active;
            editUser.avatar = response.avatar==""?[]:response.avatar;
            editUser.id_user = response.id_user;
            $scope.user = editUser;
            if($scope.user.user_type == "inspector")
                 $scope.isInspector = true;
            else
                 $scope.isInspector = false;
            isEdit = true;
            $("html, body").animate({ scrollTop: 0 }, "slow");
        });
    }
    function checkInspector(isInspector){
        if(isInspector)
            $scope.user.user_type = "inspector";
        else
            $scope.user.user_type = "";
    }
    function createUser(){
        return {
            "first_name": "",
            "user_name": "",
            "id_role": [],
            "email": "",
            "user_type": "",
            "is_active":1,
            "avatar":[]
        }
    }
    function reset(){
        $scope.user = createUser();
        isEdit = false;
    }
    function validateEmail(email) {
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(email);
    }
});
