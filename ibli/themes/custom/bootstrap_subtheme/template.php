<?php

/**
 * @file
 * template.php
 */

function bootstrap_subtheme_preprocess_page(&$variables) {
  $container_key = array_search('container', $variables['navbar_classes_array']);
  if ($container_key !== FALSE) {
    unset($variables['navbar_classes_array'][$container_key]);
  }
}
