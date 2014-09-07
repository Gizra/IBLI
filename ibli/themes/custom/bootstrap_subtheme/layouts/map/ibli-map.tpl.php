<div ng-app="ibliApp">
  <div ng-controller="MainCtrl" period-list="true">
    <leaflet center="center" id="provincesMap" markers="markers" defaults="defaults" tiles="tiles" geojson="geojson" controls="controls" maxbounds="maxbounds"></leaflet>
    <button ng-click="takeImage()">Take image!</button>
    <div id='snapshot'></div>
  </div>
</div>
