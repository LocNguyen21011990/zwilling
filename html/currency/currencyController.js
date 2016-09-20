"use strict";
app.controller('currencyListing', ['$rootScope', '$compile', '$http', '$scope', '$timeout', 'ENV', 'DTOptionsBuilder', 'DTColumnBuilder', 'Notification', 'currencyService', function($rootScope, $compile, $http, $scope, $timeout, ENV, DTOptionsBuilder, DTColumnBuilder, Notification, currencyService) {

    $scope.currency = {
        "currency_code": "",
        "exchange_rate": "",
        "exchange_year": "",
        "updateby": $rootScope.username
    };

    $scope.isEdit = false;
    $scope.reset = function() {
        $scope.currency = {
            "currency_code": "",
            "exchange_rate": "",
            "exchange_year": "",
            "updateby": $rootScope.username
        }
        $scope.isEdit = false;

    };

    function validExchangeYear(year) {
        var reValid = /^\d+$/;
        return reValid.test(year);
    }

    function validExchangeRate(rate) {
        var reRate = /^[0-9]+(\.[0-9]{1,9})?$/;
        return reRate.test(rate);
    }
    $scope.saveCurrency = function() {
        var valid = false;
        var messageValid = 'Please, Input data fields: </br>';
        if ($scope.currency.currency_code == '') {
            messageValid += '- Currency code. </br>';
            valid = true;
        }
        if (!validExchangeYear($scope.currency.exchange_year)) {
            messageValid += '- Exchange Year OR Must be number </br>';
            valid = true;
        }
        if (!validExchangeRate($scope.currency.exchange_rate)) {
            messageValid += '- Exchange Rate Must be number OR decimals </br>';
            valid = true;
        }
        if (valid) {
            Notification.error({ message: messageValid, delay: 5000 });
        } else {
            if ($scope.isEdit) {

                $scope.currency.updateby = $rootScope.username;
                currencyService.edit($scope.currency).$promise.then(function(response) {
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

                currencyService.save($scope.currency).$promise.then(function(response) {
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
            return currencyService.getAll().$promise.then(function(data) {
                $scope.listCurrency = data;
                return $scope.listCurrency;

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
        DTColumnBuilder.newColumn('currency_code').withTitle('Currency Code'),
        DTColumnBuilder.newColumn('exchange_rate').withTitle('Exchange Rate'),
        DTColumnBuilder.newColumn('exchange_year').withTitle('Exchange Year'),
        DTColumnBuilder.newColumn('').notSortable().withTitle('Edit').renderWith(renderData)
    ];

    $scope.dtInstance = {};

    // function status(data, type, full, meta) {
    //     return '<i class="fa fa-pencil-square-o"></i>';
    // }

    function renderData(data, type, full, meta) {
        var currRow = meta.row;
        return '<a class="cursor" ng-click="editCurrency(' + currRow + ')"><i class="fa fa-pencil-square-o"></i></a>';
    }

    $scope.editCurrency = function(currRow) {
        $scope.isEdit = true;
        var value = $scope.listCurrency[currRow];

        $scope.currency = {
            "currency_code": value.currency_code,
            "exchange_rate": value.exchange_rate,
            "exchange_year": value.exchange_year,
            "updateby": value.updateby
        }
        $("html, body").animate({ scrollTop: 0 }, "slow");
    }
}]);
