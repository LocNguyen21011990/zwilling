'use strict'
app.config(function($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise('/');
    $stateProvider
        .state('login', {
            url: '/login',
            views: {
                'login': {
                    templateUrl: '/html/login/login.html',
                    controller: 'loginCtrl',
                    controllerAs: 'login'
                }
            },
        })
        .state('forgotpassword', {
            url: '/forgot-password',
            views: {
                'login': {
                    templateUrl: '/html/login/forgotten-password.html',
                    controller: 'loginCtrl',
                    controllerAs: 'login'
                }
            },
        })
        .state('reset-password', {
            url: '/reset-password',
            views: {
                'login': {
                    templateUrl: '/html/login/reset-password.html'
                }
            },
        })
        .state('home', {
            url: '/',
            views: {
                'leftPanel': {
                    templateUrl: '/html/shared/leftPanel.html',
                    controller: 'leftPanelCtrl'
                },
                'content@': {
                    templateUrl: '/html/dashboard/dashboard.html',
                    controller: 'dashboard'
                },
                'footer': {
                    templateUrl: '/html/shared/footer.html',
                }
            },
            authenticate: true
        })
        .state('home.dashboard', {
            url: 'dashboard',
            views: {
                'content@': {
                    templateUrl: '/html/dashboard/dashboard.html',
                    controller: 'dashboard',
                }
            },
            authenticate: true
        })
        .state('home.order', {
            url: 'order',
            views: {
                'content@': {
                    templateUrl: '/html/order/list.html',
                    controller: 'orderList',
                    controllerAs: 'OL'
                }
            },
            authenticate: true
        })
        .state('home.order.list', {
            url: '/list',
            views: {
                'content@': {
                    templateUrl: '/html/order/list.html',
                    controller: 'orderList',
                    controllerAs: 'OL'
                }
            },
            authenticate: true
        })
        .state('home.order.input', {
            url: '/input',
            views: {
                'content@': {
                    templateUrl: '/html/order/input.html',
                    controller: 'orderInput',
                    controllerAs: 'OP'
                }
            },
            authenticate: true
        })
        .state('home.order.edit', {
            url: '/input/:id',
            views: {
                'content@': {
                    templateUrl: '/html/order/input.html',
                    controller: 'orderInput',
                    controllerAs: 'OP'
                }
            },
            authenticate: true
        })
        .state('home.order.import', {
            url: '/import',
            views: {
                'content@': {
                    templateUrl: '/html/order/import.html',
                    controller: 'orderImport'
                }
            },
            authenticate: true
        })
        .state('home.order.evaluation', {
            url: '/evaluation',
            views: {
                'content@': {
                    templateUrl: '/html/order/evaluation.html',
                    controller: 'orderEvaluation'
                }
            },
            authenticate: true
        })
        .state('home.inspection', {
            url: 'inspection',
            views: {
                'content@': {
                    templateUrl: '/html/inspection/schedule.html',
                    controller: 'inspectionSchedule',
                    controllerAs: 'OI'
                }
            },
            authenticate: true
        })
        .state('home.inspection.schedule', {
            url: '/schedule',
            views: {
                'content@': {
                    templateUrl: '/html/inspection/schedule.html',
                    controller: 'inspectionSchedule',
                    controllerAs: 'OI'
                }
            },
            authenticate: true
        })
        .state('home.inspection.evaluation', {
            url: '/evaluation',
            views: {
                'content@': {
                    templateUrl: '/html/inspection/evaluation.html',
                    controller: 'inspectionEvaluation'
                }
            },
            authenticate: true
        })
        .state('home.inspection.calendar', {
            url: '/calendar',
            views: {
                'content@': {
                    templateUrl: '/html/inspection/calendar.html',
                    controller: 'inspectionCalendar'
                }
            },
            authenticate: true
        })
        .state('home.inspection.report', {
            url: '/report/:pid/:abid/:quantity/:parent',
            views: {
                'content@': {
                    templateUrl: '/html/inspection/report.html',
                    controller: 'inspectionReport'
                }
            },
            authenticate: true
        })

    .state('home.basicdata', {
            url: 'basicdata',
            views: {
                'content@': {
                    templateUrl: '/html/address_book/listing.html',
                    controller: 'addressList'
                }
            },
            authenticate: true
        })
        .state('home.basicdata.addressbook', {
            url: '/addressbook',
            views: {
                'content@': {
                    templateUrl: '/html/address_book/listing.html',
                    controller: 'addressList'
                }
            },
            authenticate: true
        })
        .state('home.basicdata.ql', {
            url: '/ql',
            views: {
                'content@': {
                    templateUrl: '/html/ql/listing.html',
                    controller: 'qlListing'
                }
            },
            authenticate: true
        })
        .state('home.basicdata.aql', {
            url: '/aql',
            views: {
                'content@': {
                    templateUrl: '/html/aql/listing.html',
                    controller: 'aqlListing'
                }
            },
            authenticate: true
        })
        .state('home.basicdata.product', {
            url: '/product',
            views: {
                'content@': {
                    templateUrl: '/html/product/listing.html',
                    controller: 'productListing'
                }
            },
            authenticate: true
        })
        .state('home.basicdata.mistake', {
            url: '/mistake',
            views: {
                'content@': {
                    templateUrl: '/html/mistake/listing.html',
                    controller: 'mistakeListing'
                }
            },
            authenticate: true
        })
        .state('home.basicdata.brand', {
            url: '/brand',
            views: {
                'content@': {
                    templateUrl: '/html/brand/listing.html',
                    controller: 'brandListing'
                }
            },
            authenticate: true
        })
        .state('home.basicdata.productline', {
            url: '/productline',
            views: {
                'content@': {
                    templateUrl: '/html/product_line/listing.html',
                    controller: 'productlineListing'
                }
            },
            authenticate: true
        })
        .state('home.basicdata.productsegment', {
            url: '/productsegment',
            views: {
                'content@': {
                    templateUrl: '/html/product_segment/listing.html',
                    controller: 'productsegmentListing'
                }
            },
            authenticate: true
        })
        .state('home.basicdata.currency', {
            url: '/currency',
            views: {
                'content@': {
                    templateUrl: '/html/currency/listing.html',
                    controller: 'currencyListing'
                }
            },
            authenticate: true
        })
        .state('home.basicdata.characteristic', {
            url: '/characteristic',
            views: {
                'content@': {
                    templateUrl: '/html/characteristic/listing.html',
                    controller: 'characteristicListing'
                }
            },
            authenticate: true
        })
        .state('home.basicdata.contact', {
            url: '/contact',
            views: {
                'content@': {
                    templateUrl: '/html/contact/listing.html',
                    controller: 'contactController'
                }
            },
            authenticate: true
        })
        .state('home.basicdata.document_item', {
            url: '/document_item',
            views: {
                'content@': {
                    templateUrl: '/html/document_item/listing.html',
                    controller: 'document_itemListing'
                }
            },
            authenticate: true
        })
        .state('home.basicdata.location', {
            url: '/location',
            views: {
                'content@': {
                    templateUrl: '/html/location/listing.html',
                    controller: 'locationListing'
                }
            },
            authenticate: true
        })
      .state('home.delivery', {
        url: 'delivery',
        views: {
            'content@': {
                templateUrl: '/html/delivery/quantity_delivery.html',
                controller: 'quantity_delivery'
            },authenticate: true}
        })
        .state('home.user', {
            url: 'user',
            views: {
                'content@': {
                    templateUrl: '/html/user/listing.html',
                    controller: 'userListing'
                }
            },
            authenticate: true
        });
});
