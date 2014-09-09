<?php

/**
 * @file
 * template.php
 */

/**
 * Preprocess page.
 */
function bootstrap_subtheme_preprocess_page(&$variables) {
  // Remove the 'container' class from the top menu.
  $container_key = array_search('container', $variables['navbar_classes_array']);
  if ($container_key !== FALSE) {
    unset($variables['navbar_classes_array'][$container_key]);
  }

  // Get contact address for footer.
  $query = new EntityFieldQuery();
  $results = $query
    ->entityCondition('entity_type', 'node')
    ->propertyCondition('type','page_element')
    ->fieldCondition('field_page','value', 'contact')
    ->fieldCondition('field_position','value', 'address')
    ->execute();

  if (empty($results['node'])) {
    return;
  }

  $node = node_load(key($results['node']));
  $render = node_view($node);
  $variables['contact_address'] = render($render);

  // Add a awesome icons css
  drupal_add_css('http://netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css', array('type' => 'external'));

  // Add required libraries and CSS for the map.
  drupal_add_js(libraries_get_path('angular') . '/angular.min.js');
  drupal_add_js(libraries_get_path('leaflet') . '/dist/leaflet.js');
  drupal_add_js(libraries_get_path('angular-leaflet-directive') . '/dist/angular-leaflet-directive.min.js');
  drupal_add_js(libraries_get_path('Leaflet.awesome-markers') . '/dist/leaflet.awesome-markers.min.js');
  drupal_add_js(libraries_get_path('ibli-map') . '/dist/ibli-map.js');
  drupal_add_css(libraries_get_path('leaflet') . '/dist/leaflet.css');
  drupal_add_css(libraries_get_path('Leaflet.awesome-markers') . '/dist/leaflet.awesome-markers.css');
  // Custom leaflet-image library, Changed because of markers CORS failure.
  drupal_add_js(drupal_get_path('theme', 'bootstrap_subtheme') . '/js/leaflet-image.js');

  // Setting for holding the path to map data files.
  $setting = array(
    'ibli_general' => array(
      'iblimap_library_path' => libraries_get_path('ibli-map') . '/dist',
    ),
  );
  drupal_add_js($setting, array('type' => 'setting'));
}
