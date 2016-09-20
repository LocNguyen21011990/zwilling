"use strict";
app.controller('userListing', ['$compile', '$http', '$scope', '$timeout', 'ENV', 'DTOptionsBuilder', 'DTColumnBuilder', 'Notification', function($compile, $http, $scope, $timeout, ENV, DTOptionsBuilder, DTColumnBuilder, Notification) {
   
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

    function renderAction(data,type,full,meta) {
        return '<a class="cursor"><i class="fa fa-pencil-square-o"></i></a>';
    }
}]);
