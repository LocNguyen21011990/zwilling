"use strict";
app.controller('qlListing', ['$compile', '$rootScope', '$scope', '$timeout', '$http', 'ENV', 'DTOptionsBuilder', 'DTColumnBuilder', 'DTColumnDefBuilder', 'qlService', 'Notification', function($compile, $rootScope, $scope, $timeout, $http, ENV, DTOptionsBuilder, DTColumnBuilder, DTColumnDefBuilder, qlService, Notification) {

    qlService.getAvgAql().then(function(data) {
        $scope.aqlMajor = data;
    });

    qlService.getAvgAql().then(function(response) {
        $scope.aqlMinor = response;
    });

    $scope.ql = {

        'quality_level': '',
        'quality_description': '',
        'major_defect_aql': '',
        'minor_defect_aql': '',
        'updateby': $rootScope.username
    }
    $scope.edit = function(index) {
        
        var value = $scope.listQl[index];
        $scope.flag = true;
        $scope.ql = {
            'quality_level': value.quality_level,
            'quality_description': value.quality_description,
            'major_defect_aql': value.major_defect_aql + '',
            'minor_defect_aql': value.minor_defect_aql + '',
            'updateby': $rootScope.username
        };
        
        $("html, body").animate({ scrollTop: 0 }, "slow");
    }
    $scope.flag = false;
    $scope.addQL = function() {

        // valid form
        var valid = false;
        var messageValid = 'Please, Input Fields: </br>';
        if ($scope.ql.quality_level == '') {
            messageValid += '- Quality level. </br>';
            valid = true;
        }

        if ($scope.ql.major_defect_aql == '') {
            messageValid += '- Major defect_aql. </br>';
            valid = true;
        }
        if ($scope.ql.minor_defect_aql == '') {
            messageValid += '- Minor defect_aql. </br>';
            valid = true;
        }
        if (valid) {
            Notification.error({ message: messageValid, delay: 5000 });
        } else {
            if ($scope.flag) {
                qlService.edit($scope.ql).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: response['message'] || 'Update record ql success', delay: 2000 });
                        $scope.dtInstance.reloadData();
                        $scope.reset();
                        $scope.flag = false;
                    } else {
                        Notification.error({ message: response['message'] || 'Update record failed', delay: 2000 });
                    }
                });
            } else {
                qlService.save($scope.ql).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: 'Insert new ql record success', delay: 2000 });
                        $scope.dtInstance.reloadData();
                        $scope.reset();
                    } else {
                        Notification.error({ message: response['message'] || 'Insert record failed', delay: 2000 });
                    }
                });
            }
        }
        // End if else valid 
    }
    $scope.reset = function() {
        $scope.ql = {
            'quality_level': '',
            'quality_description': '',
            'major_defect_aql': '',
            'minor_defect_aql': '',
            'updateby': $rootScope.username
        };
        $scope.flag = false;
    }

    $scope.dtOptions = DTOptionsBuilder.fromFnPromise(function() {
            return qlService.getAll().$promise.then(function(data) {
                return $scope.listQl = data;
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
        DTColumnBuilder.newColumn('quality_level').withTitle('Quality Level'),
        DTColumnBuilder.newColumn('major_defect_aql').withTitle('Major Defect'),
        DTColumnBuilder.newColumn('minor_defect_aql').withTitle('Minor Defect'),
        DTColumnBuilder.newColumn('quality_description').withTitle('Quanlity Description'),
        DTColumnBuilder.newColumn('').notSortable().withTitle('Edit').renderWith(renderData)
    ];

    $scope.dtInstance = {};

    function renderData(data, type, full, meta) {
        return '<a class="cursor" ng-click="edit(' + meta.row + ')"><i class="fa fa-pencil-square-o"></i></a>';
    }

}]);
