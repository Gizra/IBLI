'use strict';

angular.module('ibliApp')
  .controller('MainCtrl', function ($scope, $http) {
    // Array of indexes, keyed by division ID.
    var divIdToIndex;

    // Get current month from 1 to 12.
    var date = new Date();
    var currentMonth = date.getMonth() + 1;

    // Get current season, in March-September it is LRLD, otherwise SRSD.
    var currentSeason = currentMonth >=3 && currentMonth <= 9 ? 'LRLD' : 'SRSD';

    // Specific HEX codes for colors we use in the map.
    var colors = {
      green:  '#00AA00',
      yellow: '#DDDD00',
      orange: '#BB5500',
      red:    '#AA0000',
      black:  '#000000'
    };

    // Map options.
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

    // Define a function to be executed when hovering a division.
    $scope.$on("leafletDirectiveMap.geojsonMouseover", function(ev, leafletEvent) {
      divisionMouseover(leafletEvent);
    });

    // Get the CSV of indexes, according to the current season.
    $http.get('csv/indexes' + currentSeason + '.csv').success(function(data) {
      // Split the data into an array of indexes.
      divIdToIndex = data.split("\n");

      // First key in array is 0, but first divId is 1, so add a dummy at the
      // beginning of the array so that the first real index's key is 1.
      divIdToIndex.unshift('');

      // Get the divisions data from the JSON file.
      $http.get('json/kenya.json').success(function(data) {
        angular.extend($scope, {
          geojson: {
            data: data,
            style: style,
            resetStyleOnMouseout: true
          }
        })
      });
    });

    /**
     * Returns style settings for a given geoJson feature.
     *
     * @param feature
     *    GeoJson feature.
     *
     * @return
     *    Style settings for the feature.
     */
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

    /**
     * Returns color for a given divion ID.
     *
     * @param divId
     *    Division ID.
     *
     * @return
     *    The HEX color for the division ID.
     */
    function getColor(divId) {
      // Get index for the given division ID.
      var index = divIdToIndex[divId];

      // Get color according to the index.
      var color = index < 0.06 ? colors['green'] :
                  index < 0.08 ? colors['yellow'] :
                  index < 0.10 ? colors['orange'] :
                  index < 0.15 ? colors['red'] :
                  colors['black'];

      return color;
    }

    /**
     * Event handler for hovering a division.
     *
     * @param leafletEvent
     *    Leaflet event object.
     */
    function divisionMouseover(leafletEvent) {
      var layer = leafletEvent.target;
      layer.setStyle({
        weight: 2,
        color: '#666666',
        fillColor: 'white'
      });
      layer.bringToFront();
    }

  });
