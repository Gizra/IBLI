<?php

/**
 * Plugin definition.
 */
$plugin = array(
  'title' => t('Last updates'),
  'description' => t('Display Last Updates.'),
  'category' => t('ibli'),
  'hook theme' => 'ibli_homepage_last_updates_content_type_theme',
);

/**
 * Render callback.
 */
function ibli_homepage_last_updates_content_type_render($subtype, $conf, $args, $context) {
  $block = new stdClass();
  $block->module = 'ibli_homepage';
  $block->content = theme('ibli_homepage_last_updates');
  return $block;
}

/**
 * Edit form.
 */
function ibli_homepage_last_updates_type_edit_form($form, &$form_state) {
  return $form;
}

/**
 * Delegated hook_theme().
 */
function ibli_homepage_last_updates_content_type_theme(&$theme, $plugin) {
  $theme['ibli_homepage_last_updates'] = array(
    'path' => $plugin['path'],
    'template' => 'last-updates',
  );
}
