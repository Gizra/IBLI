<?php

/**
 * Plugin definition.
 */
$plugin = array(
  'title' => t('Contact form'),
  'description' => t('Display form contact us.'),
  'category' => t('ibli'),
  'hook theme' => 'ibli_general_contact_form_content_type_theme',
);

/**
 * Render callback.
 */
function ibli_general_contact_form_content_type_render($subtype, $conf, $args, $context) {
  $block = new stdClass();
  $block->module = 'ibli_general';
  $block->content = theme('ibli_general_contact_form');
  return $block;
}

/**
 * Edit form.
 */
function ibli_general_contact_form_content_type_edit_form($form, &$form_state) {
  return $form;
}

/**
 * Delegated hook_theme().
 */
function ibli_general_contact_form_content_type_theme(&$theme, $plugin) {
  $theme['ibli_general_contact_form'] = array(
    'path' => $plugin['path'],
    'template' => 'contact-form',
  );
}
