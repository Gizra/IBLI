'use strict';

angular.module('ibliApp')
  .controller('MainCtrl', function ($scope, $http, $compile, ibliData) {


    ibliData.getDivIdToIndex().then(function(data) {
      $scope.divIdToIndex = data;


      console.log($scope.divIdToIndex);
      console.log($scope.divIdToIndex[30]);

      ibliData.getGeoJson().then(function(data) {
        $scope.geojson = data;
      });
    });





    angular.extend($scope, ibliData.getMapOptions());



    // Define a function to be executed when hovering a division.
    $scope.$on("leafletDirectiveMap.geojsonMouseover", function(ev, leafletEvent) {
      divisionMouseover(leafletEvent);
    });





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

    // Custom control for displaying name of division and percent on hover.
    $scope.controls = {
      custom: []
    };
    var hoverInfoControl = L.control();
    hoverInfoControl.setPosition('bottomleft');
    hoverInfoControl.onAdd = function () {
      return $compile(angular.element('<hover-info></hover-info>'))($scope)[0];;
    }
    $scope.controls.custom.push(hoverInfoControl);

  });
