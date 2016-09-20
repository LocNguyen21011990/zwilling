"use strict";
app.controller('orderImport', function($http, $rootScope, $log, $scope, $timeout, ENV, DTOptionsBuilder, DTColumnBuilder, orderService, Notification, $q, $compile) {

    var displays = [];
    $scope.histories = [];
    var getTableData = function() {
        var deferred = $q.defer();
        deferred.resolve(displays);
        return deferred.promise;
    };
    $scope.dtOptions = DTOptionsBuilder.fromFnPromise(function() {
            return getTableData() })
        .withOption('bLengthChange', false)
        .withOption('bPaginate', false)
        .withOption('bInfo', false)
        .withOption('createdRow', function(row, data, dataIndex) {
            // Recompiling so we can bind Angular directive to the DT
            $compile(angular.element(row).contents())($scope);
        })
        .withOption('bFilter', false);

    $scope.dtColumns = [
        DTColumnBuilder.newColumn('order_no').withTitle('Order No.'),
        DTColumnBuilder.newColumn('position_no').withTitle('Pos.'),
        DTColumnBuilder.newColumn('ab_no').withTitle('AB'),
        DTColumnBuilder.newColumn('product_item_no').withTitle('Product Item No.'),
        DTColumnBuilder.newColumn('product_line').withTitle('Product Line'),
        DTColumnBuilder.newColumn('product_item_name').withTitle('Product Item Name'),
        DTColumnBuilder.newColumn('order_qty').withTitle('Order Qty'),
        DTColumnBuilder.newColumn('ab_qty').withTitle('AB Qty'),
        DTColumnBuilder.newColumn('confirmed_shipping_date').withTitle('Conf. Ship. Date'),
        DTColumnBuilder.newColumn('reason').withTitle('Reason'),
        DTColumnBuilder.newColumn('status').withTitle('Status').renderWith(status)
    ];

    $scope.dtInstance = {};

    function status(data, type, full, meta) {
        var status = data;
        var strStatus = "<i class='fa fa-exclamation-circle'></i><span ng-click=retry('" + full.id + "')>&nbsp&nbsp<i class='fa fa-retweet cursor'></i></span>";
        if (status == true) {
            strStatus = "<i class='fa fa-check-square-o'></i>";
        }
        return strStatus;
    }

    //get import history
    $http.get(ENV.domain + 'order.getImportHistoryByUser/?userid=' + $rootScope.userId).then(function(res) {
        $scope.histories = res.data;
    })
    $scope.showHistory = function() {
       
        if ($scope.hitoryItem != '') {
            $http.get(ENV.domain + 'order.getImportHistoryDetailById/?importid=' + $scope.hitoryItem).then(function(res) {
                displays = res.data;
                $scope.dtInstance.reloadData();
            });
        }else{
            displays = [];
            getTableData();
            $scope.dtInstance.reloadData();
        }

    }
    $scope.retry = function(id) {
            $http.get(ENV.domain + 'order.reImportOrder/?id=' + id).then(function() {
                $http.get(ENV.domain + 'order.getImportHistoryDetailById/?importid=' + $scope.hitoryItem).then(function(res) {
                    displays = res.data;
                    $scope.dtInstance.reloadData();
                });
            })
        }
        //end get



    $scope.uploadfile = function() {
        if (angular.isUndefined($scope.file)) {
            Notification.error({ message: 'Please select file to upload first', delay: 2000 });
        } else {
            if ($scope.file.filetype == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' || $scope.file.filetype == 'application/vnd.ms-excel') {
                var data = XLSX.read($scope.file.base64);
                var sheets = data.Sheets['Import-order-template'];
                if (sheets) {
                    var sheettojson = XLSX.utils.sheet_to_json(sheets);
                    $http.post(ENV.domain + 'order.importOrder', { data: sheettojson, user: $rootScope.userId }).then(function(data) {
                        if (data.data.success) {
                            displays = data.data.data;
                            $scope.dtInstance.reloadData();
                            Notification.success({ message: 'Import success', delay: 2000 });
                            $http.get(ENV.domain + 'order.getImportHistoryByUser/?userid=' + $rootScope.userId).then(function(res) {
                                $scope.histories = res.data;
                            })
                            delete $scope.file;
                            $(".input_upload_file").html("File");
                        } else {
                            Notification.error({ message: 'Import unsuccessful, reload page and try again', delay: 2000 });
                        }
                    });
                } else {
                    Notification.error({ message: 'Can not find sheet "Import-order-template"', delay: 2000 });
                }
            } else {
                Notification.error({ message: 'File type not support', delay: 2000 });
            }
        }

    }

});
