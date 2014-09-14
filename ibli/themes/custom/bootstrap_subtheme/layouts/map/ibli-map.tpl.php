<div ng-app="ibliApp" class="past-index-map">
  <div ng-controller="MainCtrl" period-list="true">
    <select class="period-select" ng-model="period" ng-options="period.label for period in periods track by period.value"></select>
    <leaflet center="center" id="provincesMap" markers="markers" defaults="defaults" tiles="tiles" geojson="geojson" controls="controls" maxbounds="maxbounds"></leaflet>
    <button class="btn btn-primary btn-save" ng-hide="pdf_path" id="save_button" ng-click="savePDF()"><?php print t('Save as PDF') ?></button>
    <img id="spinner" ng-show="loader" ng-src="<?php print variable_get('ibli_images_path'); ?>/spinner.gif">
    <a class="btn btn-link" id="download_link" ng-show="pdf_path" target="_blank" ng-href="{{pdf_path}}"><?php print t('Download PDF') ?></a>
  </div>
</div>
