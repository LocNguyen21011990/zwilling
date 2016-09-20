"use strict";
app.controller('userListing', function($compile, $http,$log, $scope, $timeout, ENV, DTOptionsBuilder, DTColumnBuilder, Notification,userService) {
   
   userService.getRoles().then(function(data){
       $scope.roles = data
   })
    $scope.dtOptions = DTOptionsBuilder.fromSource("assets/data/user.json")
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
        DTColumnBuilder.newColumn('username').withTitle('User Name'),
        DTColumnBuilder.newColumn('displayname').withTitle('Display Name'),
        DTColumnBuilder.newColumn('email').withTitle('Email Address'),
        DTColumnBuilder.newColumn('roles').withTitle('Roles'),
        DTColumnBuilder.newColumn('active').withTitle('Active'),
        DTColumnBuilder.newColumn(null).withTitle('Edit').renderWith(renderAction)
    ];
    $scope.dtColumnDefs = [];
    $scope.dtInstance = {};
    $scope.saveUser = saveUser;
    $scope.checkRole = checkRole;
    $scope.checkInspector = checkInspector;
    $scope.user = createUser();
    var arrRoles = [];
    userService.getAll().$promise.then(function(data){
        $log.debug(data);
    })

    function renderAction(data,type,full,meta) {
        return '<a class="cursor"><i class="fa fa-pencil-square-o"></i></a>';
    }
    function saveUser(){
       $log.debug($scope.user);
    }
    function checkRole(role,ischeck){
        if(ischeck){
            arrRoles.push(role)
        }else{
            var index = arrRoles.indexOf(role);
            arrRoles.splice(index,1);
        }
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
            "is_active":0,
            "avatar":""
        }
    }
});
