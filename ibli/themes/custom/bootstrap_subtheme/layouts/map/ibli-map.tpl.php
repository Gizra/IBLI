<div ng-app="ibliApp">
  <div ng-controller="MainCtrl" period-list="true">
    <leaflet center="center" id="provincesMap" markers="markers" defaults="defaults" tiles="tiles" geojson="geojson" controls="controls" maxbounds="maxbounds"></leaflet>
    <button ng-click="savePDF()"><?php print t('Save as PDF') ?></button>
    <object type="application/pdf" width="0" height="0" id="pdf_download"></object>
  </div>
</div>
