"use strict";
app.controller('document_itemListing', ['$window', '$rootScope', '$scope', '$compile', '$q', '$timeout', '$http', 'ENV', 'DTOptionsBuilder', 'DTColumnBuilder', 'DTColumnDefBuilder', 'Notification', 'documentItemService', function($window, $rootScope, $scope, $compile, $q, $timeout, $http, ENV, DTOptionsBuilder, DTColumnBuilder, DTColumnDefBuilder, Notification, documentItemService) {

    
    $scope.type_code = 'functionrequirement';
    $scope.component = {
        "productId": "",
        "documentId": [],
        "documentName": "",
        "code": $scope.type_code + ''
    };
    // var $scope.terminal = $scope.document_type;

    $scope.listDocument = [];

    // upload document;
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

            var valid = false;
            var messageValid = 'Please, input field data </br>';
            if ($scope.type_code == '') {
                messageValid += '- Select document type </br>';
                valid = true;
                // Notification.error({ message: 'Please, select a document type above', delay: 2000 });
            }
            if (!$scope.fileInspection) {
                messageValid += '- Choose a file document </br>';
                valid = true;
                // Notification.error({ message: 'Please select file to upload first', delay: 2000 });
            }
            if (valid) {
                Notification.error({ message: messageValid, delay: 5000 });
            } else {

                for (var i = 0; i < $scope.fileInspection.length; i++) {
                    $scope.fileInspection[i].typeDocument = $scope.type_code;
                }
                if ($scope.terminal == 1) {
                    var req = {
                        method: 'POST',
                        url: ENV.domain + 'productItemDocument.uploadProductDocument',
                        headers: {
                            'Content-Type': undefined
                        },
                        data: $scope.fileInspection
                    }

                } else {
                    var req = {
                        method: 'POST',
                        url: ENV.domain + 'productSegmentDocument.uploadProductDocument',
                        headers: {
                            'Content-Type': undefined
                        },
                        data: $scope.fileInspection
                    }
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
                $("ul.upload_listing").html("");
            }
        }
        // End upload document inspection


    $scope.changeDocument = changeDocument;

    $scope.productItem = [];
    $scope.listType = [];
    $scope.listKeyDocument = [];

    documentItemService.getListTypeUpload().$promise.then(function(data) {
        $scope.listType = data;
    });
    // changeDocument();
    function changeDocument() {
        $scope.reset();
        documentItemService.getDocumentByType($scope.type_code).then(function(data) {
            $scope.productItem = data;
            $scope.dtInstance.reloadData();
        });
        angular.forEach($scope.listType, function(value) {
            if (value.code == $scope.type_code) {
                $scope.terminal = value.typeId;
            }
        });
        documentItemService.getListKeyDocument($scope.type_code).then(function(res) {
            $scope.listKeyDocument = res;

        });
    }
    $scope.isEdit = false;
    $scope.saveDocument = function() {
        var validate = false;
        var messageValid = 'Please, Input field data </br>';
        if ($scope.component.productId == '') {
            messageValid += ' - Product no. </br>';
            validate = true;
        }
        if ($scope.component.documentName == '') {
            messageValid += ' - Document name </br>';
            validate = true;
        }

        if (validate) {
            Notification.error({ message: messageValid, delay: 5000 });
        } else {
            if ($scope.isEdit) {
                $scope.component.documentId = $scope.listInspectionFilesId.concat($scope.listId);
                documentItemService.edit($scope.component).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: response['message'] || 'Updated new record success', delay: 2000 });
                        $scope.dtInstance.reloadData();
                        $scope.reset();
                        changeDocument();
                        $scope.isEdit = false;
                    } else {
                        Notification.error({ message: response['message'] || 'Update new record failed', delay: 2000 });
                    }
                });
            } else {
                $scope.component.documentId = $scope.listInspectionFilesId.concat($scope.listId);
                documentItemService.edit($scope.component).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: response['message'] || 'Add new record success', delay: 2000 });
                        $scope.dtInstance.reloadData();
                        $scope.reset();
                        changeDocument();
                    } else {
                        Notification.error({ message: response['message'] || 'Add new record failed', delay: 2000 });
                    }
                });
            }
        }
    }

    $scope.listId = [];
    $scope.edit = function(index) {

        var value = $scope.listDocument[index];
        $scope.isEdit = true;
        $scope.listId.push(value.id);
        if (value.docType === 1) {
            $scope.component = {
                "productId": value.product_item_no,
                "documentId": $scope.listId,
                "documentName": value.fileName,
                "code": $scope.type_code + ''
            };
        } else {
            $scope.component = {
                "productId": value.product_segment_id,
                "documentId": $scope.listId,
                "documentName": value.fileName,
                "code": $scope.type_code + ''
            };
        }
        $("html, body").animate({ scrollTop: 0 }, "slow");
    }

    $scope.reset = function() {
        $scope.component = {
            "productId": "",
            "documentId": [],
            "documentName": "",
            "code": $scope.type_code + ''
        };
        $scope.listInspectionFilesId = [];
        $scope.iFiles = [];
        $scope.listInspectFn = [];
        $scope.listId = [];

        $scope.isEdit = false;
    }

    $scope.searchItemNo = {
        options: {
            html: true,
            minLength: 3,
            onlySelectValid: true,
            outHeight: 50,
            source: function(request, response) {
                var data = [];
                data = $scope.listKeyDocument;
                data = $scope.searchItemNo.methods.filter(data, request.term);
                if (!data.length) {
                    data.push({
                        label: 'not found',
                        value: null
                    });
                }
                response(data);
            }
        }
    };

    $scope.dtOptions = DTOptionsBuilder.fromFnPromise(function() {
            return initListDocument()
        })
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
            }]
        });
    $scope.dtColumns = [
        DTColumnBuilder.newColumn('fileName').withTitle('Document Name'),
        DTColumnBuilder.newColumn('').renderWith(goToOpenFile),
        DTColumnBuilder.newColumn('document_name').withTitle('Document Type'),
        DTColumnBuilder.newColumn('product_item_no').withTitle('Product Item No.'),
        DTColumnBuilder.newColumn('product_segment_id').withTitle('Product segment'),
        DTColumnBuilder.newColumn(null).renderWith(renderAction)
    ];

    $scope.dtColumnDefs = [];
    $scope.dtInstance = {};

    function initListDocument() {
        var deferred = $q.defer();
        $scope.reset();
        documentItemService.getDocumentByType($scope.type_code).then(function(data) {
            $scope.listDocument = data;
            deferred.resolve($scope.listDocument);
        });
        return deferred.promise;
    }

    function renderAction(data, type, full, meta) {
        return '<a class="cursor" ng-click="edit(' + meta.row + ')"><i class="fa fa-pencil-square-o"></i></a>';
    }

    function goToOpenFile(data, type, full, meta) {
        return '<a class="cursor" ng-click="gotoFile(' + meta.row + ')"><i class="fa fa-file-pdf-o" ></i></a>';
    }
    $scope.gotoFile = function(index) {
        var value = $scope.listDocument[index];
        $window.open(value.path);
    }

}]);
