<?php
/**
 * @file
 * Garmentbox profile.
 */

/**
 * Implements hook_form_FORM_ID_alter().
 *
 * Allows the profile to alter the site configuration form.
 */
function ibli_form_install_configure_form_alter(&$form, $form_state) {
  // Pre-populate the site name with the server name.
  $form['site_information']['site_name']['#default_value'] = $_SERVER['SERVER_NAME'];
}

/**
 * Implements hook_install_tasks().
 */
function ibli_install_tasks() {
  $tasks = array();
  $tasks['ibli_set_variables'] = array(
    'display_name' => st('Set Variables'),
    'display' => FALSE,
  );

  return $tasks;
}

/**
 * Task callback; Set variables.
 */
function ibli_set_variables() {
  $variables = array(
    // Mime-mail
    'site_name' => 'IBLI',
    // Mime-mail
    'mimemail_format' => 'full_html',
    'mimemail_sitestyle' => FALSE,
    // JQuery.
    'jquery_update_jquery_version' => 1.8,
    'jquery_update_jquery_admin_version' => 1.5,
    // Images path.
    $variables['ibli_images_path'] = drupal_get_path('theme', 'bootstrap_subtheme') . '/images',
  );

  foreach ($variables as $key => $value) {
    variable_set($key, $value);
  }
}
