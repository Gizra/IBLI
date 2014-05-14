'use strict';

angular.module('ethosiaClientApp')
  .controller('MainCtrl', function ($scope, Boxes) {
    // Call the new
    $scope.boxes = new Boxes();
  });
