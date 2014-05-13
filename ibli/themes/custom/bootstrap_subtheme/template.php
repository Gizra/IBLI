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
}
