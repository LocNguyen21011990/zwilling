"use strict";
app.controller('locationListing', ['$rootScope', '$compile', '$http', '$scope', '$timeout', 'ENV', 'DTOptionsBuilder', 'DTColumnBuilder', 'Notification', 'locationService', function($rootScope, $compile, $http, $scope, $timeout, ENV, DTOptionsBuilder, DTColumnBuilder, Notification, locationService) {

    $scope.locations = {
        "locationname": "",
        "short_name": "",
        "country_code_phone":'',
        "country_code_fax":'',
        "updateby": $rootScope.username
    };

    $scope.isEdit = false;

    $scope.reset = function() {
        $scope.locations = {
            "locationname": "",
            "short_name": "",
            "country_code_phone": "",
            "country_code_fax": "",
            "updateby": $rootScope.username
        };
        $scope.isEdit = false;

    }
    $scope.saveLocation = function() {
        var valid = false;
        var messageValid = 'Please, Input data fields: </br>';
        if ($scope.locations.locationname == '') {
            messageValid += '- Location name. </br>';
            valid = true;
        }
        if (valid) {
            Notification.error({ message: messageValid, delay: 5000 });
        } else {
            if ($scope.isEdit) {
                
                locationService.edit($scope.locations).$promise.then(function(response) {
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

                locationService.save($scope.locations).$promise.then(function(response) {
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
            return locationService.getAll().$promise.then(function(data) {
                $scope.listLocation = data;
                return $scope.listLocation;

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
            }, {
                type: 'text'
            }]
        });

    $scope.dtColumns = [
        DTColumnBuilder.newColumn('locationname').withTitle('Location Name'),
        DTColumnBuilder.newColumn('short_name').withTitle('Short Name'),
        DTColumnBuilder.newColumn('country_code_phone').withTitle('Country Code Phone'),
        DTColumnBuilder.newColumn('country_code_fax').withTitle('Country Code Fax'),
        DTColumnBuilder.newColumn('').notSortable().withTitle('Edit').renderWith(renderData)
    ];

    $scope.dtInstance = {};

    function status(data, type, full, meta) {
        return '<i class="fa fa-pencil-square-o"></i>';
    }

    function renderData(data, type, full, meta) {
        return '<a class="cursor" ng-click="editLocation(' + meta.row + ')"><i class="fa fa-pencil-square-o"></i></a>';
    }

    $scope.editLocation = function(index) {
        $scope.isEdit = true;
        var value = $scope.listLocation[index];
        
        $scope.locations = {
            "locationid":value.locationid,
            "locationname": value.locationname,
            "short_name": value.short_name,
            "country_code_phone": value.country_code_phone,
            "country_code_fax": value.country_code_fax,
            "updateby": $rootScope.username
        };
       
        $("html, body").animate({ scrollTop: 0 }, "slow");
    }
}]);
