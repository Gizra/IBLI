<?php

/**
 * Plugin definition.
 */
$plugin = array(
  'title' => t('Contact form'),
  'description' => t('Display form contact us.'),
  'category' => t('ibli'),
);

/**
 * Render callback.
 */
function ibli_general_contact_form_content_type_render($subtype, $conf, $args, $context) {
  $block = new stdClass();
  $block->module = 'ibli_general';
  $block->content = drupal_get_form('ibli_general_contact_form');
  return $block;
}

/**
 * Edit form.
 */
function ibli_general_contact_form_content_type_edit_form($form, &$form_state) {
  return $form;
}
