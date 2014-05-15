'use strict';

angular.module('ethosiaClientApp')
  .controller('MainCtrl', function ($scope) {


    angular.extend($scope, {
      kenya: {
        lat: 0.263,
        lng: 37.024,
        zoom: 6
      },
      legend: {
        position: 'bottomright',
        colors: [ '#ff0000', '#28c9ff', '#0000ff', '#ecf386' ],
        labels: [ 'National Cycle Route', 'Regional Cycle Route', 'Local Cycle Network', 'Cycleway' ]
      }
    });


  });
