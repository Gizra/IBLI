'use strict';

angular.module('ethosiaClientApp')
  .controller('MainCtrl', function ($scope, $http) {

    //  Definition map options.
    angular.extend($scope, {
      kenya: {
        lat: 0.263,
        lng: 37.024,
        zoom: 6
      },
      usa: {
        lat: 36.5979,
        lng: -99.3164,
        zoom: 4
      },
      legend: {
        position: 'bottomright',
        colors: [ '#ff0000', '#28c9ff', '#0000ff', '#ecf386' ],
        labels: [ 'National Cycle Route', 'Regional Cycle Route', 'Local Cycle Network', 'Cycleway' ]
      },
      tile: {
        url: 'http://{s}.tiles.mapbox.com/{id}/{z}/{x}/{y}.png',
        options: {
          id: 'v3/examples.map-20v6611k'
        }
      }

    });


//    function getColor(d) {
//      return d > 1000 ? '#800026' :
//             d > 500  ? '#BD0026' :
//             d > 200  ? '#E31A1C' :
//             d > 100  ? '#FC4E2A' :
//             d > 50   ? '#FD8D3C' :
//             d > 20   ? '#FEB24C' :
//             d > 10   ? '#FED976' :
//             '#FFEDA0';
//    }
//
//    function style(feature) {
//      console.log('here');
//      console.log(feature);
//      return {
//        fillColor: getColor(feature.properties.density),
//        weight: 2,
//        opacity: 1,
//        color: 'white',
//        dashArray: '3',
//        fillOpacity: 0.7
//      };
//    }
//
//
    // Get the countries geojson data from a JSON
    $http.get("json/us-states.json").success(function(data) {
//      $scope.geojson = data;

      angular.extend($scope, {
        geojson: {
          data:data
        }
      })

    });
//
  });
