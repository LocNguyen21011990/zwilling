"use strict";
app.controller('productlineListing', ['$rootScope', '$compile', '$http', '$scope', '$timeout', 'ENV', 'DTOptionsBuilder', 'DTColumnBuilder', 'productLineService', 'Notification', function($rootScope, $compile, $http, $scope, $timeout, ENV, DTOptionsBuilder, DTColumnBuilder, productLineService, Notification) {

    productLineService.getBrands().$promise.then(function(data) {
        $scope.listBrand = data;

    });

    productLineService.getProductSegments().$promise.then(function(data) {
        $scope.listProductSegment = data;
    });
    productLineService.getQls().$promise.then(function(data) {
        $scope.listQl = data;
    });
    $scope.productLine = {
        "product_line_no": "",
        "product_line_name_english": "",
        "product_line_name_german": "",
        "updateby": $rootScope.username,
        "product_segment_id": "",
        "brandid": "",
        "ql": ""
    };
    
    $scope.isEdit = false;
    $scope.reset = function() {
        $('#select_brand').select2('val', '');
        $('#select_product_segment').select2('val', '');
        $('#select_ql').select2('val', '');
        $scope.productLine = {
            "product_line_no": "",
            "product_line_name_english": "",
            "product_line_name_german": "",
            "updateby": $rootScope.username,
            "product_segment_id": "",
            "brandid": "",
            "ql": ""
        };
        $scope.isEdit = false;
    }
    

    $scope.saveProductLine = function() {

        var valid = false;
        var messageValid = 'Please, Input data fields: </br>';
        if ($scope.productLine.product_line_no == '' || $scope.productLine.product_line_no === undefined ) {
            messageValid += '- Product line no. </br>';
            valid = true;
        }
        if ($scope.productLine.product_line_name_english == '' || $scope.productLine.product_line_name_english === undefined) {
            messageValid += '- Product line name english. </br>';
            valid = true;
        }
        
        if ($scope.productLine.brandid == '' || $scope.productLine.brandid === undefined) {
            messageValid += '- Select brand. </br>';
            valid = true;
        }
        if ($scope.productLine.product_segment_id == '' || $scope.productLine.product_segment_id === undefined) {
            messageValid += '- Select segment. </br>';
            valid = true;
        }
        if ($scope.productLine.ql == '' ||$scope.productLine.ql === undefined) {
            messageValid += '- Select QL. </br>';
            valid = true;
        }
        if (valid) {
            Notification.error({ message: messageValid, delay: 5000 });
        } else {
            if ($scope.isEdit) {
                productLineService.edit($scope.productLine).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: response['message'] || 'Updated record success', delay: 2000 });
                        $scope.reset();
                        $scope.dtInstance.reloadData();
                        $scope.isEdit = false;
                    } else {
                        Notification.error({ message: response['message'] || 'Update record failed.', delay: 2000 });
                    }

                });
            } else {
                productLineService.save($scope.productLine).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: response['message'] || 'Insert new record success', delay: 2000 });

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
            return productLineService.getAll().$promise.then(function(data) {
                return $scope.listPLine = data;
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
            }, {
                type: 'text'
            },{
                type:'text'
            }]
        });

    $scope.dtColumns = [
        DTColumnBuilder.newColumn('product_line_no').withTitle('Product Line No'),
        DTColumnBuilder.newColumn('product_line_name_english').withTitle('English Name'),
        DTColumnBuilder.newColumn('product_line_name_german').withTitle('German Name'),
        DTColumnBuilder.newColumn('brandname').withTitle('Brand'),
        DTColumnBuilder.newColumn('product_segment_name_english').withTitle('Product Segment English Name'),
        DTColumnBuilder.newColumn('ql').withTitle('Quality Level'),
        DTColumnBuilder.newColumn('product_line_no').notSortable().withTitle('Edit').renderWith(renderAction)
    ];

    $scope.dtInstance = {};

    function status(data, type, full, meta) {
        return '<i class="fa fa-pencil-square-o"></i>';
    }

    function renderAction(data) {

        return '<a class="cursor" ng-click="editProductLine(' + data + ')"><i class="fa fa-pencil-square-o"></i></a>';
    }

    $scope.editProductLine = function(id) {

        $scope.isEdit = true;
        angular.forEach($scope.listPLine, function(value) {
            if (value.product_line_no == id) {

                // keep selected when editing;
                $('#select_brand').select2('val', value.brandid);
                $('#select_product_segment').select2('val', value.product_segment_id);
                $('#select_ql').select2('val', value.ql);

                $scope.productLine = {
                    "product_line_no": value.product_line_no,
                    "product_line_name_english": value.product_line_name_english,
                    "product_line_name_german": value.product_line_name_german,
                    "updateby": $rootScope.username,
                    "product_segment_id": value.product_segment_id + "",
                    "brandid": value.brandid + "",
                    "ql": value.ql + ""
                };
            }

        });
        $("html, body").animate({ scrollTop: 0 }, "slow");
    }
}]);
