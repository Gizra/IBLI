'use strict';

angular.module('ethosiaClientApp')
  .controller('MainCtrl', [ '$scope', function($scope) {
    angular.extend($scope, {
      london: {
        lat: 0.263,
        lng: 37.024,
        zoom: 6
      }
    });
  }]);
