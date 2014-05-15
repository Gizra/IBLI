'use strict';

angular
  .module('ibliApp', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngRoute',
    'apiMock',
    'leaflet-directive'
  ])
  .config(function ($routeProvider, apiMockProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MapController'
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
