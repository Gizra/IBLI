<?php
/**
 * @file
 * ibli_news.features.inc
 */

/**
 * Implements hook_ctools_plugin_api().
 */
function ibli_news_ctools_plugin_api($module = NULL, $api = NULL) {
  if ($module == "feeds" && $api == "feeds_importer_default") {
    return array("version" => "1");
  }
  if ($module == "strongarm" && $api == "strongarm") {
    return array("version" => "1");
  }
}

/**
 * Implements hook_node_info().
 */
function ibli_news_node_info() {
  $items = array(
    'news' => array(
      'name' => t('News'),
      'base' => 'node_content',
      'description' => t('Rss new feed'),
      'has_title' => '1',
      'title_label' => t('Title'),
      'help' => '',
    ),
    'news_feed_importer' => array(
      'name' => t('News feed importer'),
      'base' => 'node_content',
      'description' => '',
      'has_title' => '1',
      'title_label' => t('Title'),
      'help' => '',
    ),
  );
  drupal_alter('node_info', $items);
  return $items;
}
