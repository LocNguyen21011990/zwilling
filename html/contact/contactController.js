"use strict";
app.controller('contactController', ['$rootScope', '$scope', '$compile', '$q', '$timeout', '$http', 'ENV', 'DTOptionsBuilder', 'DTColumnBuilder', 'DTColumnDefBuilder', 'Notification', 'contactService', function($rootScope, $scope, $compile, $q, $timeout, $http, ENV, DTOptionsBuilder, DTColumnBuilder, DTColumnDefBuilder, Notification, contactService) {

    var valid = false;
    $scope.dtInstance = {};
    $scope.contact = {
        "full_name": "",
        "title": "",
        "address": "",
        "business_phone": "",
        "mobile_phone": "",
        "business_fax": "",
        "mail1": "",
        "company_name": "",
        "company_no": "",
        "country_code_business_phone": "",
        "buyer_no": "",
        "planer_no": "",
        "locationid": "",
        "updateby": $rootScope.username
    };

    $scope.addContact = addContact;
    $scope.changeLocation = changeLocation;

    $scope.locations = [];
    $scope.listCompany = [];
    contactService.getLocations().$promise.then(function(data) {
        $scope.locations = data;
    });
    contactService.getListCompany().$promise.then(function(data) {
        $scope.listCompany = data;
    });

    $scope.searchItemNo = {
        options: {
            html: true,
            minLength: 3,
            onlySelectValid: true,
            outHeight: 50,
            source: function(request, response) {
                var data = [];
                data = $scope.listCompany;
                data = $scope.searchItemNo.methods.filter(data, request.term);
                if (!data.length) {
                    data.push({
                        label: 'not found',
                        value: null
                    });
                }
                response(data);
            }
        },
        events: {
            select: function (event, ui) {
                $scope.contact.company_name = ui.item.label.split('::')[1];
            },
            change:function(event,ui){
                if(ui.item == null){
                     $scope.contact.company_name ="";
                }
            }
        }
    };
    function changeLocation(id) {
        if (id !== '') {
            angular.forEach($scope.locations, function(value) {
                if (value.locationid == id) {
                    $scope.countryCode = {
                        "country_code_phone": value.country_code_phone,
                        "country_code_fax": value.country_code_fax
                    }
                }
            });
        } else {
            $scope.countryCode = {};
        }
    }

    $scope.edit = function(index) {

        var value = $scope.listContact[index];
        $scope.flag = true;
        $('#select_location').select2('val', value.locationid);
        changeLocation(value.locationid);
        $scope.contact = {
            "contactid": value.contactid,
            "full_name": value.full_name,
            "title": value.title,
            "address": value.address,
            "business_phone": value.business_phone,
            "mobile_phone": value.mobile_phone,
            "business_fax": value.business_fax,
            "mail1": value.mail1,
            "company_name": value.company_name,
            "company_no": value.company_no,
            "country_code_business_phone": value.country_code_phone,
            "buyer_no": value.buyer_no,
            "planer_no": value.planer_no,
            "locationid": value.locationid + '',
            "updateby": $rootScope.username
        };

        $("html, body").animate({ scrollTop: 0 }, "slow");
    }

    function validateEmail(email) {
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(email);
    }
    $scope.flag = false;

    $scope.reset = function() {
        $('#select_location').select2('val', '');
        $scope.contact = {
            "full_name": "",
            "title": "",
            "address": "",
            "business_phone": "",
            "mobile_phone": "",
            "business_fax": "",
            "mail1": "",
            "company_name": "",
            "company_no": "",
            "country_code_business_phone": "",
            "buyer_no": "",
            "planer_no": "",
            "locationid": "",
            "updateby": $rootScope.username
        };
        $scope.countryCode = {
            "country_code_phone": "",
            "country_code_fax": ""
        }
        $scope.flag = false;
    }

    function addContact() {
        valid = false;
        var messageValid = 'Please, Input data in fields: </br>';
        if ($scope.contact.full_name == '') {
            messageValid += '- Full Name </br>';
            valid = true;
        }
        if($scope.contact.company_no == ''){
            messageValid +='- Company no. </br>';
            valid = true;
        }
        if ($scope.contact.company_name == '') {
            messageValid += '- Company name. </br>';
            valid = true;
        }

        if ($scope.contact.business_phone == '') {
            messageValid += '- Business phone. </br>';
            valid = true;
        }

        if (!validateEmail($scope.contact.mail1)) {
            messageValid += '- Email. </br>';
            valid = true;
        }
        if ($scope.contact.locationid == '') {
            messageValid += '- Choose location </br>';
            valid = true;
        }
        if (valid) {
            Notification.error({ message: messageValid, delay: 5000 });
        } else {
            if ($scope.flag) {
                $scope.contact.country_code_phone = $scope.countryCode.country_code_phone;
                $scope.contact.country_code_fax = $scope.countryCode.country_code_fax;
                contactService.edit($scope.contact).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: response['message'] || 'Updated contact success', delay: 2000 });
                        $scope.reset();
                        $scope.dtInstance.reloadData();
                    } else {
                        Notification.error({ message: response['message'] || 'Update contact failed', delay: 2000 });
                    }
                });

            } else {
                $scope.contact.country_code_phone = $scope.countryCode.country_code_phone;
                $scope.contact.country_code_fax = $scope.countryCode.country_code_fax;
                contactService.save($scope.contact).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: 'Insert new record success', delay: 2000 });
                        $scope.dtInstance.reloadData();
                        $scope.reset();
                    } else {
                        Notification.error({ message: response['message'] || 'Insert new record failed', delay: 2000 });
                    }
                });
            }
        }

    }

    $scope.dtOptions = DTOptionsBuilder.fromFnPromise(function() {
            return initContact()
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
            }, {
                type: 'text'
            }, {
                type: 'text'
            }]
        });
    $scope.dtColumns = [
        DTColumnBuilder.newColumn('full_name').withTitle('Full Name'),
        DTColumnBuilder.newColumn('company_name').withTitle('Company Name'),
        DTColumnBuilder.newColumn('title').withTitle('Title'),
        DTColumnBuilder.newColumn('address').withTitle('Address'),
        DTColumnBuilder.newColumn('mail1').withTitle('Email'),
        DTColumnBuilder.newColumn('business_phone').withTitle('Business Phone'),
        DTColumnBuilder.newColumn('business_fax').withTitle('Business Fax'),
        DTColumnBuilder.newColumn('').withTitle('Edit').notSortable().renderWith(renderAction)
    ];



    $scope.dtColumnDefs = [];
    $scope.dtInstance = {};

    function initContact() {
        var deferred = $q.defer();
        contactService.getAll().$promise.then(function(data) {
            $scope.listContact = data;
            deferred.resolve($scope.listContact);
        });

        return deferred.promise;
    }

    function renderAction(data, type, full, meta) {
        return '<a class="cursor" ng-click="edit(' + meta.row + ')"><i class="fa fa-pencil-square-o"></i></a>';
    }

}]);
