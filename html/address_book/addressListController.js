"use strict";
app.controller('addressList', ['$rootScope', '$scope','$compile', '$q','$timeout', '$http', 'ENV', 'DTOptionsBuilder', 'DTColumnBuilder', 'DTColumnDefBuilder', 'Notification', 'addressBookService', function($rootScope, $scope, $compile,$q, $timeout, $http, ENV, DTOptionsBuilder, DTColumnBuilder, DTColumnDefBuilder, Notification, addressBookService) {

    $scope.customerType = window.globalVariable.company_kind.customer;
    $scope.supplierType = window.globalVariable.company_kind.supplier;
    $scope.company_kind = $scope.customerType + '';
    var valid = false;
    $scope.dtInstance = {};
    $scope.companyDisplay = {
        'name': '',
        'abbreviation_name': '',
        'address': '',
        'locationid': '',
        'country_code_phone': '',
        'phone': '',
        'country_code_fax': '',
        'fax': '',
        'mail': '',
        'contact_person': '',
        'company_kind': '3',
        'gildemeisterid': '',
        'updateby': $rootScope.username
    };

    $scope.addCompany = addCompany;
    $scope.changeCompany = changeCompany;
    $scope.changeLocation = changeLocation;


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

    function changeCompany() {
        $scope.reset();
        addressBookService.getByType($scope.company_kind).then(function(data) {
            for (var i = 0; i < data.length; i++) {
                data[i].locationname = '';
                for (var j = 0; j < $scope.locations.length; j++) {
                    if (data[i].locationid == $scope.locations[j].locationid) {
                        data[i].locationname = $scope.locations[j].locationname;
                        break;
                    }
                }
            }
            $scope.listCompany = data;
            $scope.dtInstance.reloadData();
            $scope.flag = false;
        });
    }

    $scope.edit = function(index) {

        var value = $scope.listCompany[index];
        $scope.flag = true;
        $('#select_location').select2('val', value.locationid);
        changeLocation(value.locationid);
        $scope.companyDisplay = {
            'name': value.name,
            'abbreviation_name': value.abbreviation_name,
            'address': value.address,
            'locationid': value.locationid + '',
            'country_code_phone': value.country_code_phone,
            'phone': value.phone,
            'country_code_fax': value.country_code_fax,
            'fax': value.fax,
            'mail': value.mail,
            'contact_person': value.contact_person,
            'company_kind': value.company_kind + '',
            'gildemeisterid': value.gildemeisterid,
            'companyid': value.companyid,
            'updateby': $rootScope.username
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
        $scope.companyDisplay = {
            'name': '',
            'abbreviation_name': '',
            'address': '',
            'locationid': '',
            'country_code_phone': '',
            'phone': '',
            'country_code_fax': '',
            'fax': '',
            'mail': '',
            'contact_person': '',
            'company_kind': $scope.company_kind,
            'gildemeisterid': '',
            'updateby': $rootScope.username
        };
        $scope.countryCode = {
            "country_code_phone": "",
            "country_code_fax": ""
        }
        $scope.flag = false;
    }

    function addCompany() {
        valid = false;

        var messageValid = 'Please, Input data in fields: </br>';
        if ($scope.companyDisplay.gildemeisterid == '') {
            messageValid += '- Company no. </br>';
            valid = true;
        }
        if ($scope.companyDisplay.name == '') {
            messageValid += '- Company name. </br>';
            valid = true;
        }

        if ($scope.companyDisplay.locationid == '') {
            messageValid += '- Select Location. </br>';
            valid = true;
        }

        if ($scope.companyDisplay.phone == '') {
            messageValid += '- Business phone. </br>';
            valid = true;
        }

        if (!validateEmail($scope.companyDisplay.mail)) {
            messageValid += '- Email. </br>';
            valid = true;
        }

        if (valid) {
            Notification.error({ message: messageValid, delay: 5000 });
        } else {
            if ($scope.flag) {
                $scope.companyDisplay.country_code_phone = $scope.countryCode.country_code_phone;
                $scope.companyDisplay.country_code_fax = $scope.countryCode.country_code_fax;
                addressBookService.edit($scope.companyDisplay).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: response['message'] || 'Update company success', delay: 2000 });
                        $scope.reset();
                        changeCompany();
                    } else {
                        Notification.error({ message: response['message'] || 'Update Addressbook failed', delay: 2000 });
                    }
                });

            } else {
                $scope.companyDisplay.company_kind = $scope.company_kind;
                $scope.companyDisplay.country_code_phone = $scope.countryCode.country_code_phone;
                $scope.companyDisplay.country_code_fax = $scope.countryCode.country_code_fax;
                addressBookService.save($scope.companyDisplay).$promise.then(function(response) {
                    if (response['success']) {
                        Notification.success({ message: 'Insert new record success', delay: 2000 });
                        $scope.reset();
                        changeCompany();
                    } else {
                        Notification.error({ message: response['message'] || 'Insert new record failed', delay: 2000 });
                    }
                });
            }
        }

    }

    $scope.dtOptions = DTOptionsBuilder.fromFnPromise(function() {return initListAddress()})
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
            }, {
                type: 'text'
            }, {
                type: 'text'
            }]
        });
     $scope.dtColumns = [
        DTColumnBuilder.newColumn('gildemeisterid').withTitle('No.'),
        DTColumnBuilder.newColumn('name').withTitle('Company Name'),
        DTColumnBuilder.newColumn('abbreviation_name').withTitle('Abbreviation Name'),
        DTColumnBuilder.newColumn('locationname').withTitle('Location'),
        DTColumnBuilder.newColumn('address').withTitle('Address'),
        DTColumnBuilder.newColumn('mail').withTitle('Email'),
        DTColumnBuilder.newColumn('contact_person').withTitle('Contact Person'),
        DTColumnBuilder.newColumn('phone').withTitle('Phone'),
        DTColumnBuilder.newColumn('fax').withTitle('Fax'),
        DTColumnBuilder.newColumn(null).renderWith(renderAction)
    ];



    $scope.dtColumnDefs = [];
    $scope.dtInstance = {};

    function initListAddress(){
        var deferred = $q.defer();
        $scope.reset();
        addressBookService.getLocations().then(function(data) {
            $scope.locations = data;
            addressBookService.getByType($scope.company_kind).then(function(data) {
                for (var i = 0; i < data.length; i++) {
                    data[i].locationname = ''
                    for (var j = 0; j < $scope.locations.length; j++) {
                        if (data[i].locationid == $scope.locations[j].locationid) {
                            data[i].locationname = $scope.locations[j].locationname;
                            break;
                        }
                    }
                }
                $scope.listCompany = data;
                deferred.resolve($scope.listCompany);
                $scope.flag = false;
            });
        });
       
        return deferred.promise;
    }
    function renderAction(data,type,full,meta) {
        return '<a class="cursor" ng-click="edit('+meta.row+')"><i class="fa fa-pencil-square-o"></i></a>';
    }

}]);
