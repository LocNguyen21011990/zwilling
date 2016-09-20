"use strict";
app.controller('characteristicListing', ['$rootScope', '$compile', '$http', '$scope', '$timeout', 'ENV', 'DTOptionsBuilder', 'DTColumnBuilder', 'Notification', 'characteristicService', function($rootScope, $compile, $http, $scope, $timeout, ENV, DTOptionsBuilder, DTColumnBuilder, Notification, characteristicService) {

    $scope.characteristic = {
        "code": "",
        "characteristic_name_english": "",
        "characteristic_name_german": "",
        "updateby": $rootScope.username
    };

    $scope.isEdit = false;

    $scope.reset = function() {
        $scope.characteristic = {
            "code": "",
            "characteristic_name_english": "",
            "characteristic_name_german": "",
            "updateby": $rootScope.username
        };
        $scope.isEdit = false;

    };

    $scope.saveCharacteristic = function() {
        var valid = false;
        var messageValid = 'Please, Input data fields: </br>';
        if ($scope.characteristic.code == '') {
            messageValid += '- Characteristic code. </br>';
            valid = true;
        }
        if ($scope.characteristic.characteristic_name_english == '') {
            messageValid += '- Characteristic name english </br>';
            valid = true;
        }
        if (valid) {
            Notification.error({ message: messageValid, delay: 5000 });
        } else {
            if ($scope.isEdit) {

                $scope.characteristic.updateby = $rootScope.username;
                characteristicService.edit($scope.characteristic).$promise.then(function(response) {
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

                characteristicService.save($scope.characteristic).$promise.then(function(response) {
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
            return characteristicService.getAll().$promise.then(function(data) {
                $scope.listCharacteristic = data;
                return $scope.listCharacteristic;

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
            }, {
                type: 'text'
            }]
        });

    $scope.dtColumns = [
        DTColumnBuilder.newColumn('code').withTitle('Code'),
        DTColumnBuilder.newColumn('characteristic_name_english').withTitle('Characteristic Name English'),
        DTColumnBuilder.newColumn('characteristic_name_german').withTitle('Characteristic Name German'),
        DTColumnBuilder.newColumn('').notSortable().withTitle('Edit').renderWith(renderData)
    ];

    $scope.dtInstance = {};

    // function status(data, type, full, meta) {
    //     return '<i class="fa fa-pencil-square-o"></i>';
    // }

    function renderData(data, type, full, meta) {
        var currRow = meta.row;
        return '<a class="cursor" ng-click="editCharacteristic(' + currRow + ')"><i class="fa fa-pencil-square-o"></i></a>';
    }

    $scope.editCharacteristic = function(currRow) {
        $scope.isEdit = true;
        var value = $scope.listCharacteristic[currRow];
        $scope.characteristic = {
            "code": value.code,
            "characteristic_name_english": value.characteristic_name_english,
            "characteristic_name_german": value.characteristic_name_german,
            "updateby": value.updateby
        };
        $("html, body").animate({ scrollTop: 0 }, "slow");
    }
}]);
