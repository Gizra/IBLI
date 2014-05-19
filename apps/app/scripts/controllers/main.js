'use strict';

angular.module('ibliApp')
  .controller('MainCtrl', function ($scope, $http) {

    //  Definition map options.
    angular.extend($scope, {
      kenya: {
        lat: 1.1864,
        lng: 37.925,
        zoom: 7
      },
      tiles: {
        url: 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        options: {
          id: 'v3/examples.map-20v6611k'
        }
      }
    });

    function style(feature) {
      return {
        fillColor: '#003399',
        weight: 2,
        opacity: 1,
        color: 'white',
        dashArray: '3',
        fillOpacity: 0.7
      };
    }

    $http.get("json/kenya.json").success(function(data) {
      angular.extend($scope, {
        geojson: {
          data: data,
          style: style
        }
      })
    });

  });
