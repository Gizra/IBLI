'use strict';

angular
  .module('ethosiaClientApp', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngRoute',
    'apiMock'
  ])
  .config(function ($routeProvider, apiMockProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });

    // Add configuration of the apiMock.
    apiMockProvider.config({
      mockDataPath: '/data-mock/',
      apiPath: '/'
    });
  });
