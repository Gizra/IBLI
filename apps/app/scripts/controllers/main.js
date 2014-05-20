'use strict';

angular.module('ibliApp')
  .controller('MainCtrl', function ($scope, $http) {

    var div_to_index;

    var colors = {
      green:  '#00AA00',
      yellow: '#DDDD00',
      orange: '#BB5500',
      red:    '#AA0000',
      black:  '#000000'
    };

    // Get current month from 1 to 12.
    var date = new Date();
    var currentMonth = date.getMonth() + 1;

    // Get current season, in March-September it is LRLD, otherwise SRSD.
    var currentSeason = currentMonth >=3 && currentMonth <= 9 ? 'LRLD' : 'SRSD';

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
      },
      legend: {
        position: 'bottomleft',
        colors: [ colors['green'], colors['yellow'], colors['orange'], colors['red'], colors['black'] ],
        labels: [ '0%-6%', '6%-8%', '8%-10%', '10%-15%', '15%-100%' ]
      }
    });

    function getColor(divId) {
      // First key in array is 0, but first divId is 1, so subtract 1 from the
      // divId to match the array keys.
      divId = divId -1;

      // Get index for the divID.
      var index = div_to_index[divId];

      var color = index < 0.06 ? colors['green'] :
                  index < 0.08 ? colors['yellow'] :
                  index < 0.10 ? colors['orange'] :
                  index < 0.15 ? colors['red'] :
                  colors['black'];

      return color;
    }

    function style(feature) {
      return {
        fillColor: getColor(feature.properties.DIV_ID),
        weight: 2,
        opacity: 1,
        color: 'white',
        dashArray: '3',
        fillOpacity: 0.7
      };
    }

    $http.get('csv/indexes' + currentSeason + '.csv').success(function(data) {
      div_to_index = data.split("\n");

      $http.get('json/kenya.json').success(function(data) {
        angular.extend($scope, {
          geojson: {
            data: data,
            style: style
          }
        })
      });
    });

  });
