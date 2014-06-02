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
 *
 * Set the images path.
 */
function bootstrap_subtheme_preprocess_ibli_homepage(&$variables) {
  $variables['images_path'] = drupal_get_path('theme', 'bootstrap_subtheme') . '/images';

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
 * Preprocess last updates.
 */
function bootstrap_subtheme_preprocess_ibli_general_last_updates(&$variables) {
  // Set the images path.
  $variables['images_path'] = drupal_get_path('theme', 'bootstrap_subtheme') . '/images';
}
