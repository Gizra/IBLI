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
    'mimemail_format' => 'full_html',
    'mimemail_sitestyle' => FALSE,
  );

  foreach ($variables as $key => $value) {
    variable_set($key, $value);
  }
}
