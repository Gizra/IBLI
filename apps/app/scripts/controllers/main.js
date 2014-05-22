'use strict';

angular.module('ibliApp')
  .controller('MainCtrl', function ($scope, $http, $compile, ibliData) {

    // Set map options.
    angular.extend($scope, ibliData.getMapOptions());

    // Get divIdToIndex data.
    ibliData.getDivIdToIndex().then(function(data) {
      $scope.divIdToIndex = data;

      // Get geoJson data. We do this here because we need the divIdToIndex
      // data to be available for the geoJson to work properly.
      ibliData.getGeoJson().then(function(data) {
        $scope.geojson = data;
      });
    });

    // Custom control for displaying name of division and percent on hover.
    $scope.controls = {
      custom: []
    };
    var hoverInfoControl = L.control();
    hoverInfoControl.setPosition('bottomleft');
    hoverInfoControl.onAdd = function () {
      return $compile(angular.element('<hover-info></hover-info>'))($scope)[0];
    };
    $scope.controls.custom.push(hoverInfoControl);

    // When hovering a division, color it white.
    $scope.$on("leafletDirectiveMap.geojsonMouseover", function(ev, leafletEvent) {
      var layer = leafletEvent.target;
      layer.setStyle(ibliData.getHoverStyle());
      layer.bringToFront();
    });

  });
