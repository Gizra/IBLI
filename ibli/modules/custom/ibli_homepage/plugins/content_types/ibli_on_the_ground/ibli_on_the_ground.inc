<?php

/**
 * Plugin definition.
 */
$plugin = array(
  'title' => t('IBLI On The Ground'),
  'description' => t('Display IBLI On The Ground.'),
  'category' => t('ibli'),
  'hook theme' => 'ibli_homepage_ibli_on_the_ground_content_type_theme',
);

/**
 * Render callback.
 */
function ibli_homepage_ibli_on_the_ground_content_type_render($subtype, $conf, $args, $context) {
  // Load "IBLI On The Ground" nodequeue data.
  $query = db_select('nodequeue_queue', 'nq');
  $query->innerJoin('nodequeue_nodes', 'nn', 'nq.qid = nn.qid');
  $query->innerJoin('node', 'n', 'n.nid = nn.nid');
  $result = $query
    ->fields('nn', array('nid'))
    ->condition('nq.name', 'ibli_on_the_ground')
    ->condition('n.status', NODE_PUBLISHED)
    ->execute()
    ->fetchAllAssoc('nid');

  if (empty($result)) {
    // Nodequeue is empty.
    return;
  }
  $nodes = node_load_multiple(array_keys($result));

  $variables = array(
    'nodequeue' => array(),
  );
  foreach ($nodes as $node) {
    $wrapper = entity_metadata_wrapper('node', $node);

    // Get data for image style.
    $image = $wrapper->field_image->value();
    $image_vars = array(
      'path' => $image['uri'],
      'alt' => check_plain($node->title),
      'attributes' => array('class' => array('img-responsive')),
      'style_name' => 'ibli_on_the_ground_thumbnail',
    );

    // If there's no Youtube video with the node, Remove "colorbox" class and prevent default anchor behavior.
    $video_url = 'javascript://';
    $colorbox_load = '';
    if ($wrapper->field_youtube_video->value()) {
      $video_url = $wrapper->field_youtube_video->value() . '?width=640&height=360&iframe=true';
      $colorbox_load = 'colorbox-load';
    }

    $variables['nodequeue'][] = array(
      'title' => $node->title,
      'url' => url('node/' . $node->nid),
      'image' => theme('image_style', $image_vars),
      'video_url' =>  $video_url,
      'colorbox_class' => $colorbox_load,
    );
  }

  $block = new stdClass();
  $block->module = 'ibli_homepage';
  $block->content = theme('ibli_on_the_ground', $variables);
  return $block;
}

/**
 * Edit form.
 */
function ibli_homepage_ibli_on_the_ground_type_edit_form($form, &$form_state) {
  return $form;
}

/**
 * Delegated hook_theme().
 */
function ibli_homepage_ibli_on_the_ground_content_type_theme(&$theme, $plugin) {
  $theme['ibli_on_the_ground'] = array(
    'path' => $plugin['path'],
    'template' => 'ibli-on-the-ground',
  );
}
