<?php
/**
 * @file
 * feeds_news.feeds_tamper_default.inc
 */

/**
 * Implements hook_feeds_tamper_default().
 */
function feeds_news_feeds_tamper_default() {
  $export = array();

  $feeds_tamper = new stdClass();
  $feeds_tamper->disabled = FALSE; /* Edit this to true to make a default feeds_tamper disabled initially */
  $feeds_tamper->api_version = 2;
  $feeds_tamper->id = 'news-xpathparser_2-html_entity_decode';
  $feeds_tamper->importer = 'news';
  $feeds_tamper->source = 'xpathparser:2';
  $feeds_tamper->plugin_id = 'html_entity_decode';
  $feeds_tamper->settings = array();
  $feeds_tamper->weight = 0;
  $feeds_tamper->description = 'HTML entity decode';
  $export['news-xpathparser_2-html_entity_decode'] = $feeds_tamper;

  $feeds_tamper = new stdClass();
  $feeds_tamper->disabled = FALSE; /* Edit this to true to make a default feeds_tamper disabled initially */
  $feeds_tamper->api_version = 2;
  $feeds_tamper->id = 'news-xpathparser_2-strip_tags';
  $feeds_tamper->importer = 'news';
  $feeds_tamper->source = 'xpathparser:2';
  $feeds_tamper->plugin_id = 'strip_tags';
  $feeds_tamper->settings = array(
    'allowed_tags' => '',
  );
  $feeds_tamper->weight = 1;
  $feeds_tamper->description = 'Strip tags';
  $export['news-xpathparser_2-strip_tags'] = $feeds_tamper;

  return $export;
}
