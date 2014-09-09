<div ng-app="ibliApp" class="past-index-map">
  <div ng-controller="MainCtrl" period-list="true">
    <leaflet center="center" id="provincesMap" markers="markers" defaults="defaults" tiles="tiles" geojson="geojson" controls="controls" maxbounds="maxbounds"></leaflet>
    <button class="btn btn-primary btn-save" id="save_button" ng-href="{{url}}" ng-click="savePDF()"><?php print t('Save as PDF') ?></button>
    <img id="spinner" ng-src="<?php print drupal_get_path('theme', 'bootstrap_subtheme') . '/images/'; ?>spinner.gif">
    <a class="btn btn-link" id="download_link" target="_blank" ng-href="{{pdf_path}}"><?php print t('Download PDF') ?></a>
  </div>
</div>
