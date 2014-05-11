<?php
/**
 * @file
 * ibli_general.features.wysiwyg.inc
 */

/**
 * Implements hook_wysiwyg_default_profiles().
 */
function ibli_general_wysiwyg_default_profiles() {
  $profiles = array();

  // Exported profile: filtered_html
  $profiles['filtered_html'] = array(
    'format' => 'filtered_html',
    'editor' => 'tinymce',
    'settings' => FALSE,
    'rdf_mapping' => array(),
  );

  return $profiles;
}
