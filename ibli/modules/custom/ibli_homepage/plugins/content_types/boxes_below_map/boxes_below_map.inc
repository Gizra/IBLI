<?php

/**
 * Plugin definition.
 */
$plugin = array(
  'title' => t('Boxes below map'),
  'description' => t('Display boxes below map.'),
  'category' => t('ibli'),
  'hook theme' => 'ibli_homepage_boxes_below_map_content_type_theme',
);

/**
 * Render callback.
 */
function ibli_homepage_boxes_below_map_content_type_render($subtype, $conf, $args, $context) {
  $block = new stdClass();
  $block->module = 'ibli_homepage';
  $block->content = theme('ibli_homepage_boxes_below_map');
  return $block;
}

/**
 * Edit form.
 */
function ibli_homepage_boxes_below_map_content_type_edit_form($form, &$form_state) {
  return $form;
}

/**
 * Delegated hook_theme().
 */
function ibli_homepage_boxes_below_map_content_type_theme(&$theme, $plugin) {
  $theme['ibli_homepage_boxes_below_map'] = array(
    'path' => $plugin['path'],
    'template' => 'boxes-below-map',
  );
}
