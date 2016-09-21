"use strict";
app.controller('inspectionReport', ['$rootScope','$window', '$scope', '$timeout', 'ENV', '$state', '$stateParams', '$http', 'userService', 'Notification', function($rootScope,$window, $scope, $timeout, ENV, $state, $stateParams, $http, userService, Notification) {

    $scope.tab = 1;
    $scope.critical = 0;
    $scope.major = 0;
    $scope.minor = 0;
    $scope.notice = 0;

    $("#mistake_dictionary").select2("val", "");
    $scope.setTab = function(newTab) {
        $scope.tab = newTab;
    };

    $scope.isSet = function(tabNum) {
        return $scope.tab === tabNum;
    };


    $scope.pid = $stateParams.pid;
    $scope.abid = $stateParams.abid;
    $scope.qty = $stateParams.quantity;
    $scope.parent = $stateParams.parent;
    var date_shown = "dd-M-yy";

    $scope.inspection_date = new Date().toFormat(date_shown);

    $scope.inspectionReport = null;

    $scope.listInspection = [];

    userService.listInspection().then(function(data) {
        $scope.listInspection = data;

    });


    // $scope.listMissingReason=[];
    $http.get(ENV.domain + 'missingReason.execute').then(function(data) {
        $scope.listMissingReason = data.data;
    });


    function isNumber(obj) {
        return !isNaN(parseFloat(obj))
    }


    $http.get(ENV.domain + 'inspectionResult.execute').then(function(data) {
        $scope.listInspectionResult = data.data;
        $scope.inspection_result = $scope.listInspectionResult[0].inspection_result_description;
    });

    $scope.listMistakeItem = [];
    $scope.totalCritical = 0;
    $scope.totalMajor = 0;
    $scope.totalMinor = 0;

    function validValues(value) {
        var re = /^[0-9]{1,7}$/;
        return re.test(value);
    }

    $scope.saveMistake = function() {

        var valid = false;
        var messageValid = 'Please, Input data in fields: </br>';
        if ($scope.mistake_dictionary == undefined) {
            messageValid += '- Mistake description </br>';
            valid = true;
        }

        if (!validValues($scope.critical)) {
            messageValid += '- Critical / Must be number </br>';
            valid = true;
        }

        if (!validValues($scope.major)) {
            messageValid += '- Major / Must be number </br>';
            valid = true;
        }

        if (!validValues($scope.minor)) {
            messageValid += '- Minor / Must be number </br>';
            valid = true;
        }
        if (!validValues($scope.notice)) {
            messageValid += '- Notice / Must be number </br>';
            valid = true;
        }
        if (valid) {
            Notification.error({ message: messageValid, delay: 3000 });
            return;
        }


        $scope.mistake_dictionary = angular.fromJson($scope.mistake_dictionary);
        $scope.listMistakeItem.push({ mistake_code: $scope.mistake_dictionary.mistake_code, mistake_description_english: $scope.mistake_dictionary.mistake_description_english, critical: $scope.critical, major: $scope.major, minor: $scope.minor, notice: $scope.notice });
        $scope.totalCritical += parseInt($scope.critical);
        $scope.totalMajor += parseInt($scope.major);
        $scope.totalMinor += parseInt($scope.minor);

        if ($scope.totalCritical > 0 || $scope.totalMajor > $scope.inspectionReport.major_allow || $scope.totalMajor > $scope.inspectionReport.major_reject || $scope.totalMinor > $scope.inspectionReport.minor_allow || $scope.totaMinor > $scope.inspectionReport.minor_reject) {
            $scope.inspection_result = $scope.listInspectionResult[2].inspection_result_description;
            $("#inspection_result").select2('val', $scope.inspection_result);
        }

        //save mistake when edit inspection report
        if ($scope.inspectionid != '') {
            var data = {
                "inspectionid": $scope.inspectionid,
                "mistake_code": $scope.mistake_dictionary.mistake_code,
                "number_of_critical_defect": $scope.critical,
                "number_of_major_defect": $scope.major,
                "number_of_minor_defect": $scope.minor,
                "number_of_notice": $scope.notice,
                "updateby": $rootScope.username
            }
            $http.post(ENV.domain + 'inspectionReportMistake.execute', data).then(function(res) {
                if(res.data['success']){
                    $scope.listMistakeItem[$scope.listMistakeItem.length - 1].inspection_mistake_id = res.data.inspection_mistake_id;
                    Notification.success({message:res.data['message'] || 'Input mistake success', delay:2000});
                }else{
                    Notification.error({message:res.data['message'] || 'Input mistake failed.', delay:5000});
                }
            });
            $scope.critical = 0;
            $scope.major = 0;
            $scope.minor = 0;
            $scope.notice = 0;
            $scope.mistake_dictionary = '';
            $("#mistake_dictionary").select2("val", "");
        }

    }

    $scope.listDocuments = [];
    $scope.reportforchild = false;

    $http.get(ENV.domain + "inspection.execute?schab=" + $scope.abid + "&itemno=" + $scope.pid + "&quantity=" + $scope.qty).then(function(data) {
        $scope.inspectionReport = data.data;
        //console.log($scope.inspectionReport)
        $scope.reportforchild = Boolean($scope.inspectionReport.is_general_report);

        $http.get(ENV.domain + 'productSegmentMistakeDictionary.execute?product_segment_id=' + $scope.inspectionReport.product_segment_id).then(function(data) {
            $scope.listMistakeDictionary = data.data;
        });


        $scope.inspection_no = $scope.inspectionReport.inspection_no;
        $scope.inspectionid = $scope.inspectionReport.inspectionid;

        //get documents by product_segment_id
        $http.get(ENV.domain + 'inspection.getListDocument?itemno=' + $scope.pid + '&product_segment_id=' + $scope.inspectionReport.product_segment_id).then(function(data) {
            $scope.listDocuments = data.data;
        });


        if ($scope.inspectionid != '') {
            $http.get(ENV.domain + 'inspectionReportMistake.execute?inspectionid=' + $scope.inspectionid).then(function(data) {
                angular.forEach(data.data, function(item) {
                    $scope.totalCritical += parseInt(item.number_of_critical_defect);
                    $scope.totalMajor += parseInt(item.number_of_major_defect);
                    $scope.totalMinor += parseInt(item.number_of_minor_defect);
                    $scope.listMistakeItem.push({ mistake_code: item.mistake_code, mistake_description_english: item.mistake_description_english, critical: item.number_of_critical_defect, major: item.number_of_major_defect, minor: item.number_of_minor_defect, notice: item.number_of_notice, inspection_mistake_id: item.inspection_mistake_id });
                });

            });

        }
        $scope.ab_no = $scope.inspectionReport.abno;
        $scope.pos_no = $scope.inspectionReport.position_no;
        $scope.order_no = $scope.inspectionReport.order_no;
        $scope.inspector1 = $scope.inspectionReport.inspector1;
        $scope.plan_date = $scope.inspectionReport.plan_date;
        $scope.inspector2 = $scope.inspectionReport.inspector2;
        $scope.inspectedQty = $scope.inspectionid != '' ? $scope.inspectionReport.reportqty : $scope.inspectionReport.inspected_quantity;
        // $scope.inspectedQty = $scope.inspectionReport.inspected_quantity;
        $scope.quantity_accepted = $scope.inspectionReport.quantity_accepted;
        if ($scope.inspectionReport.result != '') {
            $scope.inspection_result = $scope.inspectionReport.result;
        }

        if ($scope.inspectionReport.inspection_date != '') {
            $scope.inspection_date = new Date($scope.inspectionReport.inspection_date).toFormat(date_shown);
        }


        $scope.sealFrom1 = $scope.inspectionReport.seal_from1;
        $scope.sealTo1 = $scope.inspectionReport.seal_to1;
        $scope.sealFrom2 = $scope.inspectionReport.seal_from2;
        $scope.sealTo2 = $scope.inspectionReport.seal_to2;
        $scope.comment = $scope.inspectionReport.comment;
        $scope.carton_info = $scope.inspectionReport.carton_info;

        if ($scope.inspectionReport.missing_td != '') {
            $scope.technicalDrawin = 0;
            $scope.missing_reason_td = $scope.inspectionReport.missing_td;
        }
        if ($scope.inspectionReport.missing_ss != '') {
            $scope.sealedSample = 0;
            $scope.missing_reason_ss = $scope.inspectionReport.missing_ss;
        }
    });

    $scope.removeMistake = function(index) {
        var value = $scope.listMistakeItem[index];
        if (value.inspection_mistake_id != '') {
            $http.delete(ENV.domain + 'inspectionReportMistake.execute?id=' + value.inspection_mistake_id).then(function(response) {
                if (response.data['success']) {
                    $scope.listMistakeItem.splice(index, 1);
                    $scope.totalCritical -= parseInt(value.critical);
                    $scope.totalMajor -= parseInt(value.major);
                    $scope.totalMinor -= parseInt(value.minor);
                    Notification.success({ message: response.data['message'] || 'Delete record mistake success', delay: 2000 });
                } else {
                    Notification.error({ message: response.data['message'] || 'Delete record mistake failed', delay: 2000 });
                }
            });
        }

    }
    $scope.saveReport = function() {
        var messageValid = 'Input Accepted Quantity must be less than equal ' + $scope.inspectionReport.item_lost_size;
        if ($scope.technicalDrawin == undefined) {
            Notification.error({ message: 'Check Technical Drawin, Please!</br>', delay: 5000 });
            return;
        }
        if ($scope.sealedSample == undefined) {
            Notification.error({ message: 'Check Sealed Sample, Please!</br>', delay: 5000 });
            return;
        }
        if ($scope.inspection_no == '') {
            Notification.error({ message: 'Please input Inspection No.', delay: 2000 });
            return;
        }
        if (!validValues($scope.quantity_accepted)) {
            Notification.error({ message: 'Field Accepted Quantity must be number </br>', delay: 5000 });
            return;
        }
        if ($scope.quantity_accepted > $scope.inspectionReport.item_lost_size) {
            Notification.error({ message: messageValid, delay: 5000 });
            return;
        }
        $scope.listMistakeID = [];

        //update inspector schedule
        var dataSchedule = { id: $scope.inspectionReport.id, inspector1: $scope.inspector1, inspector2: $scope.inspector2, plan_date: $scope.plan_date, updateby: 'rasia' };
        $http.put(ENV.domain + 'inspection.editSchedule', dataSchedule).then(function(data) {});

        var inspection = {
            "inspectionid": $scope.inspectionid,
            "abid": $scope.inspectionReport.abid,
            "inspection_no": $scope.inspection_no,
            "inspection_date": $scope.inspection_date,
            "set_item_lot_size": $scope.inspectionReport.shipped_quantity,
            "item_lot_size": $scope.inspectionReport.item_lost_size,
            "inspected_quantity": $scope.inspectedQty,
            "quantity_accepted": $scope.quantity_accepted,
            "inspected_ql": $scope.inspectionReport.quality_level,
            "product_item_no": $scope.inspectionReport.product_item_no,
            "inspector1": $scope.inspector1,
            "inspector2": $scope.inspector2,
            "last_change_person": 1,
            "sealfrom1": $scope.sealFrom1,
            "sealfrom2": $scope.sealFrom2,
            "sealto1": $scope.sealTo1,
            "sealto2": $scope.sealTo2,
            "td_materials": "no",
            "missing_td": $scope.missing_reason_td,
            "ss_materials": "no",
            "missing_ss": $scope.missing_reason_ss,
            "carton_info": $scope.carton_info,
            "result": $scope.inspection_result,
            "comment": $scope.comment,
            "is_general_report": $scope.reportforchild,
            "mistake": $scope.listMistakeID
        };
        if ($scope.inspectionid != '') {
            //edit inspection report
            $timeout(function() {

                $http.put(ENV.domain + 'inspection.execute', inspection).then(function(d) {
                    if (d.data['success']) {
                        Notification.success({ message: d.data['message'] || 'Updated Inspection report success', delay: 2000 });
                    } else {
                        Notification.error({ message: d.data['message'] || 'Update Inspection report failed', delay: 2000 });
                    }
                });

            }, 300);

        } else {

            //create new inspection report.

            angular.forEach($scope.listMistakeItem, function(item) {
                var data = {
                    "mistake_code": item.mistake_code,
                    "number_of_critical_defect": item.critical,
                    "number_of_major_defect": item.major,
                    "number_of_minor_defect": item.minor,
                    "number_of_notice": item.notice,
                    "updateby": $rootScope.username
                }
                $http.post(ENV.domain + 'inspectionReportMistake.execute', data).then(function(res) {
                    if (res.data.success) {
                        $scope.listMistakeID.push(res.data.inspection_mistake_id);
                    }
                });
            });


            $timeout(function() {

                $http.post(ENV.domain + 'inspection.execute', inspection).then(function(d) {
                    if (d.data['success']) {
                        $scope.inspectionid = d.data['id'];
                        Notification.success({ message: d.data['message'] || 'inspection report saved success', delay: 2000 });
                    } else {
                        Notification.error({ message: d.data['message'] || 'Inspection report failed', delay: 2000 });
                    }
                });

            }, 300);
        }


    }

    //create pdf
    $scope.viewPDF = function() {
        var pathfile = ENV.domain.replace('index.cfm/', '') + 'fileUpload/inspectionReport/' + $scope.inspection_no + '.pdf';
        $window.open(pathfile);
    }

    $timeout(function() {
        $("#inspection_date").datepicker({ dateFormat: "dd-M-yy" }).val();
        $(".datepicker").datepicker("option", "prevText", "<");
        $(".datepicker").datepicker("option", "nextText", ">");
        $(".datepicker").datepicker("option", "firstDay", 1);
        pageSetUp();
    }, 100)
}]);
