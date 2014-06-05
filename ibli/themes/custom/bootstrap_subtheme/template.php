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

  // Set the images path.
  $variables['images_path'] = drupal_get_path('theme', 'bootstrap_subtheme') . '/images';
}

/**
 * Preprocess IBLI homepage.
 */
function bootstrap_subtheme_preprocess_ibli_homepage(&$variables) {
  // Set the images path.
  $variables['images_path'] = drupal_get_path('theme', 'bootstrap_subtheme') . '/images';

  // Load "IBLI On The Ground" nodequeue data.
  $variables['nodequeue'] = array();
  $query = db_select('nodequeue_queue', 'nq');
  $query->innerJoin('nodequeue_nodes', 'nn', 'nq.qid = nn.qid');
  $result = $query
    ->fields('nn', array('nid'))
    ->condition('nq.name', 'ibli_on_the_ground')
    ->execute()
    ->fetchAllAssoc('nid');
  if (!empty($result)) {
    $nodes = node_load_multiple(array_keys($result));

    foreach ($nodes as $node) {
      $wrapper = entity_metadata_wrapper('node', $node);

      $image = $wrapper->field_image->value();
      $image_vars = array(
        'path' => $image['uri'],
        'alt' => $node->title,
        'attributes' => array('class' => array('img-responsive')),
      );

      $variables['nodequeue'][] = array(
        'title' => $node->title,
        'url' => url('node/' . $node->nid),
        'image' => theme('image', $image_vars),
      );
    }
  }

  // Add required libraries and CSS for the map.
  drupal_add_js(libraries_get_path('angular') . '/angular.min.js');
  drupal_add_js(libraries_get_path('leaflet') . '/dist/leaflet.js');
  drupal_add_js(libraries_get_path('angular-leaflet-directive') . '/dist/angular-leaflet-directive.min.js');
  drupal_add_js(libraries_get_path('ibli-map') . '/dist/ibli-map.js');
  drupal_add_css(libraries_get_path('leaflet') . '/dist/leaflet.css');

  // Setting for holding the path to map data files.
  $setting = array(
    'ibli_general' => array(
      'iblimap_library_path' => libraries_get_path('ibli-map') . '/dist',
    ),
  );
  drupal_add_js($setting, array('type' => 'setting'));
}
