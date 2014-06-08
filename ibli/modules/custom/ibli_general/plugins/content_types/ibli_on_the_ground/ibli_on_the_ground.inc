<?php

/**
 * Plugin definition.
 */
$plugin = array(
  'title' => t('IBLI On The Ground'),
  'description' => t('Display IBLI On The Ground.'),
  'category' => t('ibli'),
  'hook theme' => 'ibli_general_ibli_on_the_ground_content_type_theme',
);

/**
 * Render callback.
 */
function ibli_general_ibli_on_the_ground_content_type_render($subtype, $conf, $args, $context) {
  $block = new stdClass();
  $block->module = 'ibli_general';
  $block->content = theme('ibli_on_the_ground');
  return $block;
}

/**
 * Edit form.
 */
function ibli_general_ibli_on_the_ground_type_edit_form($form, &$form_state) {
  return $form;
}

/**
 * Delegated hook_theme().
 */
function ibli_general_ibli_on_the_ground_content_type_theme(&$theme, $plugin) {
  $theme['ibli_on_the_ground'] = array(
    'path' => $plugin['path'],
    'template' => 'ibli-on-the-ground',
  );
}
