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
}

/**
 * Preprocess IBLI homepage.
 */
function bootstrap_subtheme_preprocess_ibli_homepage(&$variables) {
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

/**
 * Preprocess IBLI On The Ground.
 */
function bootstrap_subtheme_preprocess_ibli_on_the_ground(&$variables) {
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
        'style_name' => 'ibli_on_the_ground_thumbnail',
      );

      $variables['nodequeue'][] = array(
        'title' => $node->title,
        'url' => url('node/' . $node->nid),
        'image' => theme('image_style', $image_vars),
      );
    }
  }
}
