'use strict';

angular.module('ibliApp')
  .factory('ibliData', function ($http, $q) {

    var divIdToIndex = [];

    /**
     * Get current season.
     *
     * @return
     *    In March-September returns "LRLD", otherwise SRSD.
     */
    function _getSeason() {
      // Get current month from 1 to 12.
      var date = new Date();
      var currentMonth = date.getMonth() + 1;

      // Get current season, in March-September it is LRLD, otherwise SRSD.
      var currentSeason = currentMonth >=3 && currentMonth <= 9 ? 'LRLD' : 'SRSD';

      return currentSeason;
    }

    /**
     * Get HEX codes for colors we use in the map.
     *
     * @return
     *    Array of HEX colors, keyed by the color's name.
     */
    function _getColors() {
      return {
        green:  '#00AA00',
        yellow: '#DDDD00',
        orange: '#BB5500',
        red:    '#AA0000',
        black:  '#000000'
      };
    }

    /**
     * Get map options.
     *
     * @return
     *    Object of map-related options, used for extending the scope.
     */
    function _getMapOptions() {
      var colors = _getColors();

      return {
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
        },
        maxbounds: {
          southWest: {
            lat: -3.0966358718415505,
            lng: 33.310546875
          },
          northEast: {
            lat: 5.462895560209557,
            lng: 42.5390625
          }
        }
      };
    }

    /**
     * Get indexes keyed by division ID.
     *
     * @return
     *    Array of indexes keyed by division ID.
     */
    function _getDivIdToIndex() {
      var deferred = $q.defer();
      $http({
        method: 'GET',
        url: 'csv/indexes' + _getSeason() + '.csv',
        serverPredefined: true
      }).success(function(response) {
          divIdToIndex = response.split("\n");
          deferred.resolve(divIdToIndex);
        });
      return deferred.promise;
    }

    /**
     * Get geoJson object.
     *
     * @return
     *    Object of geoJson data, used for extending the scope.
     */
    function _getGeoJson() {
      // Get divisions data from geoJSON file.
      var deferred = $q.defer();
      $http({
        method: 'GET',
        url: 'json/kenya.json',
        serverPredefined: true
      }).success(function(kenyaDivisions) {
          // Prepare geoJson object with the division data.
          var geojsonObject = {
            data: kenyaDivisions,
            style: style,
            resetStyleOnMouseout: true
          };
          deferred.resolve(geojsonObject);
        });
      return deferred.promise;
    }

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
     * Returns color for a given division ID.
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
      // Get all colors.
      var colors = _getColors();

      // Get color according to the index.
      var color = index < 0.06 ? colors['green'] :
                  index < 0.08 ? colors['yellow'] :
                  index < 0.10 ? colors['orange'] :
                  index < 0.15 ? colors['red'] :
                  colors['black'];

      return color;
    }

    // Public API here
    return {
      getMapOptions: function () {
        return _getMapOptions();
      },
      getDivIdToIndex: function () {
        return _getDivIdToIndex();
      },
      getGeoJson: function () {
        return _getGeoJson();
      }
    };
  });
