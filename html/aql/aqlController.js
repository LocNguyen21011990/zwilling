"use strict";
app.controller('aqlListing', ['$q','$compile','$rootScope','$scope', '$timeout', '$http', 'ENV', 'DTOptionsBuilder', 'DTColumnBuilder', 'DTColumnDefBuilder', 'aqlService', 'Notification', function($q,$compile,$rootScope,$scope, $timeout, $http, ENV, DTOptionsBuilder, DTColumnBuilder, DTColumnDefBuilder, aqlService, Notification) {

   $scope.aqlList = [];
   
    $scope.aql = {
        'average_quality_level': '',
        'min_quantity': '',
        'max_quantity': '',
        'inspection_lot': '',
        'accepted': '',
        'rejected': '',
        'updateby': $rootScope.username
    };
    

    $scope.flag = false;

    $scope.edit = function(index) {
        $scope.flag = true;
        var value = $scope.aqlList[index];

        $scope.aql = {
            'aqlid': value.aqlid,
            'average_quality_level': value.average_quality_level,
            'min_quantity': value.min_quantity,
            'max_quantity': value.max_quantity,
            'inspection_lot': value.inspection_lot,
            'accepted': value.accepted,
            'rejected': value.rejected,
            'updateby': $rootScope.username
        };
        $scope.aqlOld = index;
        $("html, body").animate({ scrollTop: 0 }, "slow");
    }
    $scope.addAQL = function() {


        var valid = false;
        var messageValid = 'Please, Input Fields: </br>';
        if ($scope.aql.average_quality_level == '') {
            messageValid += '- Average quantity level. </br>';
            valid = true;
        }
        if ($scope.aql.min_quantity === '') {
            messageValid += '- Min Quatity. </br>';
            valid = true;
        }
        if ($scope.aql.max_quantity === '') {
            messageValid += '- Max Quatity. </br>';
            valid = true;
        }
        if ($scope.aql.inspection_lot === '') {
            messageValid += '- Inspection Lot. </br>';
            valid = true;
        }
        if ($scope.aql.accepted === '') {
            messageValid += '- Accepted. </br>';
            valid = true;
        }
        if ($scope.aql.rejected === '') {
            messageValid += '- Rejected. </br>';
            valid = true;
        }
        if (valid) {
            Notification.error({ message: messageValid, delay: 5000 });
        } else {
            if ($scope.flag) {

                aqlService.edit($scope.aql).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: response['message'] || 'Update record aql success', delay: 2000 });
                        $scope.reset();
                        $scope.dtInstance.reloadData();
                        $scope.flag = false;
                    } else {
                        Notification.error({ message: response['message'] || 'Update record aql failed', delay: 2000 });
                    }
                });
            } else {
                aqlService.save($scope.aql).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: 'Insert new record success', delay: 2000 });
                        $scope.reset();
                        $scope.dtInstance.reloadData();
                    } else {
                        Notification.error({ message: response['message'] || 'Insert record aql failed', delay: 2000 });
                    }
                });
            }
        }
        // end aqlid not null;

    }
    $scope.reset = function() {
        $scope.aql = {
            'average_quality_level': '',
            'min_quantity': '',
            'max_quantity': '',
            'inspection_lot': '',
            'accepted': '',
            'rejected': '',
            'updateby': $rootScope.username
        };
        $scope.flag = false;
    }
    $scope.dtOptions = DTOptionsBuilder.fromFnPromise(function() {return initListAQL()})
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
            }, {
                type: 'text'
            }, {
                type: 'text'
            }]
        });
    $scope.dtColumns = [
        DTColumnBuilder.newColumn('aqlid').withTitle('AQL No'),
        DTColumnBuilder.newColumn('average_quality_level').withTitle('AQL'),
        DTColumnBuilder.newColumn('min_quantity').withTitle('Min Quatity'),
        DTColumnBuilder.newColumn('max_quantity').withTitle('Max Quatity'),
        DTColumnBuilder.newColumn('accepted').withTitle('Accepted'),
        DTColumnBuilder.newColumn('rejected').withTitle('Rejected'),
        DTColumnBuilder.newColumn(null).renderWith(renderAction)
    ];
    $scope.dtColumnDefs = [];
    $scope.dtInstance = {};
    function initListAQL(){
        var deferred = $q.defer();
        aqlService.getAll().$promise.then(function(data) {
            $scope.aqlList = data
            deferred.resolve($scope.aqlList);
        });
       
        return deferred.promise;
    }
    function renderAction(data,type,full,meta) {
        return '<a class="cursor" ng-click="edit('+meta.row+')"><i class="fa fa-pencil-square-o"></i></a>';
    }


}]);
