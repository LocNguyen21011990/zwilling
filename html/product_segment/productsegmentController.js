"use strict";
app.controller('productsegmentListing', ['$compile', '$http', '$scope', '$rootScope', '$timeout', 'ENV', 'DTOptionsBuilder', 'DTColumnBuilder', 'Notification', 'productSegmentService', function($compile, $http, $scope, $rootScope, $timeout, ENV, DTOptionsBuilder, DTColumnBuilder, Notification, productSegmentService) {


    $scope.listDocument = [];
    // upload Inspection plan document;
    $scope.listInspectionFilesId = [];
    $scope.iFiles = [];
    $scope.listInspectFn = [];

    $scope.icheckData = 0;
    $scope.listFileInspection = function() {
        $scope.iFiles = [];
        angular.forEach($scope.listInspectionFilesId, function(value) {
            $scope.iFiles.push(value);
            $scope.icheckData = $scope.iFiles.length;
        });
        $scope.icheckData = $scope.iFiles.length;
    }
    $scope.removeFileInspection = function(index, id) {
        $http.delete(ENV.domain + 'productSegmentDocument.execute/?docId=' + id).then(function(response) {
            if (response.data['success']) {
                $scope.iFiles.splice(index, 1);
                $scope.listInspectFn.splice(index, 1);
                $scope.listInspectionFilesId.splice(index, 1);
                Notification.success({ message: response.data['message'] || 'Delete file success', delay: 2000 });
            } else {
                Notification.error({ message: response.data['message'] || 'Delete file failed', delay: 2000 });
            }
        });


    }
    $scope.uploadFileInspection = function() {
            if (!$scope.fileInspection) {
                Notification.error({ message: 'Please select file to upload first', delay: 2000 });
            } else {
                for (var i = 0; i < $scope.fileInspection.length; i++) {
                    $scope.fileInspection[i].typeDocument = "inspectionplan";
                }
                var req = {
                    method: 'POST',
                    url: ENV.domain + 'productSegmentDocument.uploadProductDocument',
                    headers: {
                        'Content-Type': undefined
                    },
                    data: $scope.fileInspection
                }
                $http(req).then(function(d) {
                    if (d.data['success']) {
                        $scope.listInspectionFilesId = $scope.listInspectionFilesId.concat(d.data.docId);
                        $scope.listDocument = $scope.listDocument.concat($scope.listInspectionFilesId);
                        $scope.listInspectFn = $scope.listInspectFn.concat(d.data.filename);
                        Notification.success({ message: 'Upload success', delay: 2000 });
                        delete $scope.fileInspection;
                    } else {
                        Notification.error({ message: d.data['message'] || 'Please select file to upload first', delay: 2000 });
                    }

                })
                $("ul.upload_listing_inspection").html("");
            }
        }
        // End upload document inspection
        // start upload document limit sample Catalog
    $scope.listLimitCatalogid = [];
    $scope.listLimitCatalogFn = [];
    $scope.lcFiles = [];

    $scope.lcCheckData = 0;
    $scope.listFileLimitCatalog = function() {
        $scope.lcFiles = [];
        angular.forEach($scope.listLimitCatalogid, function(value) {
            $scope.lcFiles.push(value);
            $scope.lcCheckData = $scope.lcFiles.length;
        });
        $scope.lcCheckData = $scope.lcFiles.length;
    }
    $scope.removeFileLimitCatalog = function(index, id) {

        $http.delete(ENV.domain + 'productSegmentDocument.execute/?docId=' + id).then(function(response) {
            if (response.data['success']) {
                $scope.lcFiles.splice(index, 1);
                $scope.listLimitCatalogFn.splice(index, 1);
                $scope.listLimitCatalogid.splice(index, 1);

                Notification.success({ message: response.data['message'] || 'Delete file success', delay: 2000 });
            } else {
                Notification.error({ message: response.data['message'] || 'Delete file failed', delay: 2000 });
            }
        });

    }
    $scope.uploadFileLimitCatalog = function() {
            if (!$scope.fileCatalog) {
                Notification.error({ message: 'Please select file to upload first', delay: 2000 });
            } else {
                for (var i = 0; i < $scope.fileCatalog.length; i++) {
                    $scope.fileCatalog[i].typeDocument = "limitcatalog";
                }
                var req = {
                    method: 'POST',
                    url: ENV.domain + 'productSegmentDocument.uploadProductDocument',
                    headers: {
                        'Content-Type': undefined
                    },
                    data: $scope.fileCatalog
                }

                $http(req).then(function(d) {
                    if (d.data['success']) {
                        $scope.listLimitCatalogid = $scope.listLimitCatalogid.concat(d.data.docId);
                        $scope.listLimitCatalogFn = $scope.listLimitCatalogFn.concat(d.data.filename);
                        $scope.listDocument = $scope.listDocument.concat($scope.listLimitCatalogid);
                        Notification.success({ message: 'Upload success', delay: 2000 });
                        delete $scope.fileCatalog;
                    } else {
                        Notification.error({ message: d.data['message'] || 'Please select file to upload first', delay: 2000 });
                    }

                })
                $("ul.upload_listing_limit").html("");
            }
        }
        // end upload document limit catalog
        // start upload document Function requirement

    $scope.listFunctionRequireid = [];
    $scope.listFileFunctionRequireFn = [];
    $scope.frFiles = [];

    $scope.frCheckData = 0;
    $scope.listFileFunctionRequire = function() {
        $scope.frFiles = [];
        angular.forEach($scope.listFunctionRequireid, function(value) {
            $scope.frFiles.push(value);
            $scope.frCheckData = $scope.frFiles.length;
        });
        $scope.frCheckData = $scope.frFiles.length;
    }
    $scope.removeFileFunctionRequire = function(index, id) {

        $http.delete(ENV.domain + 'productSegmentDocument.execute/?docId=' + id).then(function(response) {
            if (response.data['success']) {
                $scope.frFiles.splice(index, 1);
                $scope.listFileFunctionRequireFn.splice(index, 1);
                $scope.listFunctionRequireid.splice(index, 1);

                Notification.success({ message: response.data['message'] || 'Delete file success', delay: 2000 })
            } else {
                Notification.error({ message: response.data['message'] || 'Delete file failed', delay: 2000 });
            }
        });
    }
    $scope.uploadFileFunctionRequire = function() {
            if (!$scope.fileFunRequire) {
                Notification.error({ message: 'Please select file to upload first', delay: 2000 });
            } else {
                for (var i = 0; i < $scope.fileFunRequire.length; i++) {
                    $scope.fileFunRequire[i].typeDocument = "functionrequirement";
                }
                var req = {
                    method: 'POST',
                    url: ENV.domain + 'productSegmentDocument.uploadProductDocument',
                    headers: {
                        'Content-Type': undefined
                    },
                    data: $scope.fileFunRequire
                }
                $http(req).then(function(d) {
                    if (d.data['success']) {
                        $scope.listFunctionRequireid = $scope.listFunctionRequireid.concat(d.data.docId);
                        $scope.listFileFunctionRequireFn = $scope.listFileFunctionRequireFn.concat(d.data.filename);
                        $scope.listDocument = $scope.listDocument.concat($scope.listFunctionRequireid);
                        Notification.success({ message: 'Upload success', delay: 2000 });
                        delete $scope.fileFunRequire;
                    } else {
                        Notification.error({ message: d.data['message'] || 'Please select file to upload first', delay: 2000 });
                    }

                })
                $("ul.upload_listing_function").html("");
            }
        }
        // End upload function requirement

    $scope.productSegment = {
        "product_segment_name_english": "",
        "product_segment_name_german": "",
        "updateby": $rootScope.username,
        "documentSegment": []
    }

    $scope.flag = false;

    $scope.dtOptions = DTOptionsBuilder.fromFnPromise(function() {
            return productSegmentService.getAll().$promise.then(function(data) {
                $scope.listProductSegment = data;
                return $scope.listProductSegment;
            });
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
        DTColumnBuilder.newColumn('product_segment_name_english').withTitle('English Name'),
        DTColumnBuilder.newColumn('product_segment_name_german').withTitle('German Name'),
        DTColumnBuilder.newColumn('product_segment_id').withTitle('Edit').renderWith(renderAction)
    ];

    $scope.dtInstance = {};

    function status(data, type, full, meta) {
        return '<i class="fa fa-pencil-square-o"></i>';
    }

    function renderAction(data) {
        return '<a class="cursor" ng-click="editPSegment(' + data + ')"><i class="fa fa-pencil-square-o"></i></a>';
    }

    $scope.editPSegment = function(id) {
        $http.get(ENV.domain + 'productSegment.execute/?Id=' + id).then(function(res) {
            $scope.productSegment = res.data;
            $scope.productSegment.product_segment_name_english = res.data.product_segment_name_english;
            $scope.productSegment.product_segment_name_german = res.data.product_segment_name_german;

            $scope.listInspectionFilesId = [];
            $scope.listInspectFn = [];
            $scope.listLimitCatalogid = [];
            $scope.listLimitCatalogFn = [];
            $scope.listFunctionRequireid = [];
            $scope.listFileFunctionRequireFn = [];

            angular.forEach($scope.productSegment.document, function(value) {

                if (value.type == "inspectionplan") {
                    $scope.listInspectionFilesId.push(value.segment_document_id);
                    $scope.listInspectFn.push(value.fileName);

                }
                if (value.type == "limitcatalog") {
                    $scope.listLimitCatalogid.push(value.segment_document_id);
                    $scope.listLimitCatalogFn.push(value.fileName);

                }
                if (value.type == "functionrequirement") {
                    $scope.listFunctionRequireid.push(value.segment_document_id);
                    $scope.listFileFunctionRequireFn.push(value.fileName);

                }
            });
            $scope.productSegment.documentSegment = $scope.listInspectionFilesId.concat($scope.listLimitCatalogid).concat($scope.listFunctionRequireid);


            $scope.productSegment = {
                "product_segment_id": $scope.productSegment.product_segment_id,
                "product_segment_name_english": $scope.productSegment.product_segment_name_english,
                "product_segment_name_german": $scope.productSegment.product_segment_name_german,
                "updateby": $rootScope.username,
                "documentSegment": $scope.productSegment.documentSegment
            };
            $scope.flag = true;
        });
        $("html, body").animate({ scrollTop: 0 }, "slow");
        // END method GET
    }
    $scope.saveProductSegment = function() {
        var valid = false;
        var messageValid = 'Please, Input data fields: </br>';
        if ($scope.productSegment.product_segment_name_english == '') {
            messageValid += '- Product segment name. </br>';
            valid = true;
        }
        if (valid) {
            Notification.error({ message: messageValid, delay: 5000 });
        } else {
            if ($scope.flag) {
                $scope.productSegment.documentSegment = $scope.listInspectionFilesId.concat($scope.listLimitCatalogid).concat($scope.listFunctionRequireid);

                productSegmentService.edit($scope.productSegment).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: response['message'] || 'Updated record success', delay: 2000 });
                        $scope.listInspectionFilesId = [];
                        $scope.listInspectFn = [];
                        $scope.listLimitCatalogid = [];
                        $scope.listLimitCatalogFn = [];
                        $scope.listFunctionRequireid = [];
                        $scope.listFileFunctionRequireFn = [];
                        $scope.productSegment.documentSegment = [];
                        $scope.dtInstance.reloadData();
                        $scope.reset();
                        $scope.flag = false;

                    } else {
                        Notification.error({ message: response['message'] || 'Insert record failed', delay: 2000 })
                    }
                });
            } else {
                $scope.productSegment.documentSegment = $scope.listDocument;
                productSegmentService.save($scope.productSegment).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: response['message'] || 'Insert new record success', delay: 2000 });
                        $scope.listInspectionFilesId = [];
                        $scope.listInspectFn = [];
                        $scope.listLimitCatalogid = [];
                        $scope.listLimitCatalogFn = [];
                        $scope.listFunctionRequireid = [];
                        $scope.listFileFunctionRequireFn = [];
                        $scope.productSegment.documentSegment = [];
                        $scope.dtInstance.reloadData();
                        $scope.reset();
                    } else {
                        Notification.error({ message: response['message'] || 'Insert record failed', delay: 2000 })
                    }
                });
            }
        }
    }
    $scope.reset = function() {
        $scope.productSegment = {
            "product_segment_name_english": "",
            "product_segment_name_german": "",
            "updateby": $rootScope.username,
            "documentSegment": []
        };
        $scope.listInspectionFilesId = [];
        $scope.listInspectFn = [];
        $scope.listLimitCatalogid = [];
        $scope.listLimitCatalogFn = [];
        $scope.listFunctionRequireid = [];
        $scope.listFileFunctionRequireFn = [];
        $scope.productSegment.documentSegment = [];
        $scope.flag = false;
    }
}]);
