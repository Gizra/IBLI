'use strict';

angular.module('ibliApp')
  .factory('Boxes', function ($http, $q) {

    function Boxes() {
      Array.call();
    }
    Boxes.prototype = Array.prototype;


    Boxes.prototype.$gettingBoxes = function() {
      var deferred = $q.defer();

      $http({
        method: 'GET',
        url: '/geo',
        serverPredifined: true,
        apiMock: true
      })
        .success(function(response) {
          deferred.resolve(response);
        });

      return deferred.promise;
    }

    function boxes() {
      // Create a new instance of boxes.
      var _boxes = new Boxes();

      // Unwrap the boxes.
      _boxes.$gettingBoxes().then(function(data) {
        _boxes.data = data;
      });

      return _boxes;
    }

    // Public API here
    return boxes;
  });
