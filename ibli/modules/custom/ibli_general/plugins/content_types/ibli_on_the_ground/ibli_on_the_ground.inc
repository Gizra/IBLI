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
  $variables = array(
    'nodequeue' => array(),
  );

  // Load "IBLI On The Ground" nodequeue data.
  $query = db_select('nodequeue_queue', 'nq');
  $query->innerJoin('nodequeue_nodes', 'nn', 'nq.qid = nn.qid');
  $result = $query
    ->fields('nn', array('nid'))
    ->condition('nq.name', 'ibli_on_the_ground')
    ->execute()
    ->fetchAllAssoc('nid');
  if (!empty($result)) {
    $nodes = node_load_multiple(array_keys($result));

    foreach ($nodes as $node) {
      $wrapper = entity_metadata_wrapper('node', $node);

      // Get data for image style.
      $image = $wrapper->field_image->value();
      $image_vars = array(
        'path' => $image['uri'],
        'alt' => $node->title,
        'attributes' => array('class' => array('img-responsive')),
        'style_name' => 'ibli_on_the_ground_thumbnail',
      );

      $variables['nodequeue'][] = array(
        'title' => $node->title,
        'url' => url('node/' . $node->nid),
        'image' => theme('image_style', $image_vars),
      );
    }
  }

  $block = new stdClass();
  $block->module = 'ibli_general';
  $block->content = theme('ibli_on_the_ground', $variables);
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
