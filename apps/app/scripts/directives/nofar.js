'use strict';

angular.module('ethosiaClientApp')
  .directive('nofar', function () {
    return {
      template: '<div></div>',
      restrict: 'E',
      link: function postLink(scope, element, attrs) {
        element.text('this is the nofar directive');
      }
    };
  });
