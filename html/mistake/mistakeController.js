"use strict";
app.controller('mistakeListing', ['$rootScope', '$scope', '$compile', '$q', '$timeout', '$http', 'ENV', 'DTOptionsBuilder', 'DTColumnBuilder', 'DTColumnDefBuilder', 'Notification', 'mistakeService', function($rootScope, $scope, $compile, $q, $timeout, $http, ENV, DTOptionsBuilder, DTColumnBuilder, DTColumnDefBuilder, Notification, mistakeService) {

    $scope.listProductSegment = [];
    $scope.listMistake = [];

    $scope.columnTable = [
        DTColumnBuilder.newColumn('mistake_code').withTitle('Mistake Code'),
        DTColumnBuilder.newColumn('nr_fo').withTitle('Nr.Fo'),
        DTColumnBuilder.newColumn('characteristic').withTitle('Characteristic'),
        DTColumnBuilder.newColumn('nr_fe').withTitle('Nr.Fe'),
        DTColumnBuilder.newColumn('mistake_description_english').withTitle('Description')
    ];

    mistakeService.getListProductSegment().then(function(data) {
        $scope.listProductSegment = data;
        angular.forEach(data, function(value) {
            $scope.columnTable.push(DTColumnBuilder.newColumn('product_segment').withTitle('<span class="rotate">' + value.product_segment_name_english + '</span').notSortable().renderWith(renderMistakeCheck));
        });
        $scope.columnTable.push(DTColumnBuilder.newColumn('').withTitle('<span class="rotate">Edit</span>').notSortable().renderWith(renderAction));
    });

    $scope.dtOptions = DTOptionsBuilder.fromFnPromise(function() {
            return initListMistake()
        })
        .withOption('createdRow', function(row, data, dataIndex) {
            $compile(angular.element(row).contents())($scope);
        })
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
            }]
        });

    $scope.dtColumns = $scope.columnTable;
    $scope.dtColumnDefs = [];
    $scope.dtInstance = {};

    function initListMistake() {
        var deferred = $q.defer();
        $http.get(ENV.domain + 'mistakeDictionary.getMistakeDics/').then(function(res) {
            $scope.listMistake = res.data;
            deferred.resolve($scope.listMistake);
        });
        return deferred.promise;
    }
    /*function initListMistake() {
        return mistakeService.getListCheck().$promise.then(function(data){
            $scope.listMistake = data;
            return $scope.listMistake;
        });
    }*/

    function renderMistakeCheck(data, full, type, meta) {
        var col = (meta.col) - 5;
        var icon = data[col].product_segment_id != 0 ? 'x' : '';
        return '<td>' + icon + '</td>'
    }

    function renderAction(data, full, type, meta) {
        var row = meta.row;
        var editBtn = '<td class="btn_edit"><a class="cursor" ng-click="editMistake(' + row + ')"><i class="fa fa-pencil-square-o"></i></a></td>'
        return editBtn;
    }

    mistakeService.getListCharacteristic().then(function(data) {
        $scope.characteristic = data;
    });

    $scope.product_segment = [];

    $scope.check = function(id) {
        if ($scope.product_segment.indexOf(id) === -1) {
            $scope.product_segment.push(id);
        } else {
            $scope.product_segment.splice($scope.product_segment.indexOf(id), 1);
        }
    }

    $scope.mistake = {
        "mistake_code": "",
        "characteristic": "",
        "mistake_description_english": "",
        "updateby": $rootScope.username,
        "nr_fo": "",
        "nr_fe": "",
        "product_segment": []
    }

    $scope.editMistake = function(index) {
        $scope.addnew = true;
        var value = $scope.listMistake[index];
        $scope.product_segment = [];
        angular.forEach(value.product_segment, function(data) {
            $scope.product_segment.push(data.product_segment_id)

        });
        //bug select2
        $('#select_mistake').select2('val', value.characteristic);
        //
        $scope.mistake = {
            'mistake_code': value.mistake_code,
            'characteristic': value.characteristic + '',
            'mistake_description_english': value.mistake_description_english,
            'updateby': $rootScope.username,
            'nr_fo': value.nr_fo,
            'nr_fe': value.nr_fe,
            'product_segment': $scope.product_segment
        };

        // $scope.listOld = index;
        $scope.itemPSegment = value.product_segment;
        $("html, body").animate({ scrollTop: 0 }, "slow");
    }


    $scope.addnew = false;
    $scope.uncheckAll = [];
    $scope.uncheckAll = $scope.uncheckAll.concat($scope.product_segment);
    $scope.reset = function() {
        $('#select_mistake').select2('val', '');
        $scope.mistake = {
            "mistake_code": "",
            "characteristic": "",
            "mistake_description_english": "",
            "updateby": $rootScope.username,
            "nr_fo": "",
            "nr_fe": "",
            "product_segment": []
        };
        $scope.uncheckAll = [];
        $scope.product_segment = [];
        $scope.itemPSegment = [];

        $scope.addnew = false;
    }
    $scope.saveMistake = function() {
        var valid = false;
        var messageValid = 'Please, Input Fields: </br>';
        if ($scope.mistake.mistake_code == '') {
            messageValid += '- Mistake code. </br>';
            valid = true;
        }
        if ($scope.mistake.characteristic == '') {
            messageValid += '- Characteristic. </br>';
            valid = true;
        }

        if (valid) {
            Notification.error({ message: messageValid, delay: 5000 });
        } else {
            if ($scope.addnew) {

                $scope.mistake.product_segment = $scope.product_segment;
                // console.log($scope.mistake.product_segment)
                mistakeService.edit($scope.mistake).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: response['message'] || 'Update record mistake success', delay: 2000 });
                        // if ($scope.listOld > -1) {
                        //     $scope.listMistake.splice($scope.listOld, 1);
                        //     $scope.listMistake.push($scope.mistake);
                        // }
                        $scope.reset();
                        $scope.dtInstance.reloadData();
                        $scope.addnew = false;

                    } else {
                        Notification.error({ message: response['message'] || 'Update record failed', delay: 2000 });
                    }
                });
            } else {

                $scope.mistake.product_segment = $scope.product_segment;

                mistakeService.save($scope.mistake).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: 'Insert new record success', delay: 2000 });
                        initListMistake();
                        // $scope.listMistake.push($scope.mistake);
                        $scope.reset();
                        $scope.dtInstance.reloadData();
                    } else {
                        Notification.error({ message: response['message'] || 'Insert record failed', delay: 2000 });
                    }
                });
            }
        }
    }
    $timeout(function() {
        pageSetUp();
    }, 100);

}]);
