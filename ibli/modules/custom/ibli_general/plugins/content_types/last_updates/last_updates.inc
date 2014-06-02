<?php

/**
 * Plugin definition.
 */
$plugin = array(
  'title' => t('Last updates'),
  'description' => t('Display Last Updates'),
  'category' => t('ibli'),
  'hook theme' => 'ibli_general_last_updates_content_type_theme',
);

/**
 * Render callback.
 */
function ibli_general_last_updates_content_type_render($subtype, $conf, $args, $context) {

  $variable = array();

  $block = new stdClass();
  $block->module = 'ibli_general';
  $block->content = theme('ibli_general_last_updates', $variable);
  return $block;

}

/**
 * Edit form.
 */
function ibli_general_last_updates_type_edit_form($form, &$form_state) {
  return $form;
}

function ibli_general_last_updates_content_type_edit_form_submit($form, &$form_state) {
  return TRUE;
}

/**
 * Delegated hook_theme().
 */
function ibli_general_last_updates_content_type_theme(&$theme, $plugin) {
  $theme['ibli_general_last_updates'] = array(
    'variable' => array(
    ),
    'path' => $plugin['path'],
    'template' => 'last-updates',
  );
}
