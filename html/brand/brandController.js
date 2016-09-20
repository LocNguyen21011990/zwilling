"use strict";
app.controller('brandListing', ['$rootScope', '$compile', '$http', '$scope', '$timeout', 'ENV', 'DTOptionsBuilder', 'DTColumnBuilder', 'Notification', 'brandService', function($rootScope, $compile, $http, $scope, $timeout, ENV, DTOptionsBuilder, DTColumnBuilder, Notification, brandService) {

    $scope.brands = {
        "brandname": "",
        "description": "",
        "updateby": "rasia"
    };
    $scope.isEdit = false;
    $scope.reset = function() {
        $scope.brands = {
            "brandname": "",
            "description": "",
            "updateby": $rootScope.username
        };
        $scope.isEdit = false;
        
    }
    $scope.saveBrand = function() {
        var valid = false;
        var messageValid = 'Please, Input data fields: </br>';
        if ($scope.brands.brandname == '') {
            messageValid += '- Brand name. </br>';
            valid = true;
        }

        if (valid) {
            Notification.error({ message: messageValid, delay: 5000 });
        } else {
            if ($scope.isEdit) {
                brandService.edit($scope.brands).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: response['message'] || 'Updated record success.', delay: 2000 });
                        $scope.reset();
                        $scope.dtInstance.reloadData();
                        $scope.isEdit = false;
                    } else {
                        Notification.error({ message: response['message'] || 'Update record failed', delay: 2000 });
                    }
                });
            } else {

                brandService.save($scope.brands).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: response['message'] || 'Insert new record success.', delay: 2000 });
                        $scope.reset();
                        $scope.dtInstance.reloadData();
                    } else {
                        Notification.error({ message: response['message'] || 'Insert record failed', delay: 2000 });
                    }
                });
            }
        }
    }


    $scope.dtOptions = DTOptionsBuilder.fromFnPromise(function() {
            return brandService.getAll().$promise.then(function(data) {
                $scope.listBrand = data;
                return $scope.listBrand;

            })
        })
        .withOption('createdRow', function(row, data, dataIndex) {
            // Recompiling so we can bind Angular directive to the DT
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
            }]
        });

    $scope.dtColumns = [
        DTColumnBuilder.newColumn('brandname').withTitle('Brand Name'),
        DTColumnBuilder.newColumn('description').withTitle('Description'),
        DTColumnBuilder.newColumn('brandid').notSortable().withTitle('Edit').renderWith(renderData)
    ];

    $scope.dtInstance = {};

    function status(data, type, full, meta) {
        return '<i class="fa fa-pencil-square-o"></i>';
    }

    function renderData(data) {
        return '<a class="cursor" ng-click="editBrand(' + data + ')"><i class="fa fa-pencil-square-o"></i></a>';
    }

    $scope.editBrand = function(id) {
        $scope.isEdit = true;
        angular.forEach($scope.listBrand, function(value) {
            if (value.brandid == id) {
                $scope.brands = {
                    "brandid": value.brandid,
                    "brandname": value.brandname,
                    "description": value.description,
                    "updateby": $rootScope.username
                }
            }
        });
        $("html, body").animate({ scrollTop: 0 }, "slow");
    }
}]);
