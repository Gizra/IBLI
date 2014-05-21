'use strict';

angular.module('ibliApp')
  .directive('hoverInfo', function ($compile) {
    return {
      templateUrl: 'templates/hover-info.html',
      restrict: 'AEC'
    };
  });
