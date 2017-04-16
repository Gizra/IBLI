'use strict';

angular.module('ibliApp')
  .directive('hoverInfo', function () {
    return {
      templateUrl: 'templates/hover-info.html',
      restrict: 'AEC'
    };
  });
