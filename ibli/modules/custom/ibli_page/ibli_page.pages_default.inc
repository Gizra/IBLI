<?php
/**
 * @file
 * ibli_page.pages_default.inc
 */

/**
 * Implements hook_default_page_manager_pages().
 */
function ibli_page_default_page_manager_pages() {
  $page = new stdClass();
  $page->disabled = FALSE; /* Edit this to true to make a default page disabled initially */
  $page->api_version = 1;
  $page->name = 'premium_rates';
  $page->task = 'page';
  $page->admin_title = 'Premium rates';
  $page->admin_description = '';
  $page->path = 'premium-rates';
  $page->access = array();
  $page->menu = array();
  $page->arguments = array();
  $page->conf = array(
    'admin_paths' => FALSE,
  );
  $page->default_handlers = array();
  $handler = new stdClass();
  $handler->disabled = FALSE; /* Edit this to true to make a default handler disabled initially */
  $handler->api_version = 1;
  $handler->name = 'page_premium_rates_panel_context';
  $handler->task = 'page';
  $handler->subtask = 'premium_rates';
  $handler->handler = 'panel_context';
  $handler->weight = 0;
  $handler->conf = array(
    'title' => 'Panel',
    'no_blocks' => 0,
    'pipeline' => 'standard',
    'body_classes_to_remove' => '',
    'body_classes_to_add' => '',
    'css_id' => '',
    'css' => '',
    'contexts' => array(),
    'relationships' => array(),
  );
  $display = new panels_display();
  $display->layout = 'general_page';
  $display->layout_settings = array();
  $display->panel_settings = array(
    'style_settings' => array(
      'default' => NULL,
      'content' => NULL,
    ),
  );
  $display->cache = array();
  $display->title = '';
  $display->uuid = '5e47a544-f919-482a-8c12-eea43af4fa92';
  $display->content = array();
  $display->panels = array();
    $pane = new stdClass();
    $pane->pid = 'new-05c0a8a5-2e8c-45b8-8f32-ae7d1d1e9b77';
    $pane->panel = 'content';
    $pane->type = 'premium_rates';
    $pane->subtype = 'premium_rates';
    $pane->shown = TRUE;
    $pane->access = array();
    $pane->configuration = array();
    $pane->cache = array();
    $pane->style = array(
      'settings' => NULL,
    );
    $pane->css = array();
    $pane->extras = array();
    $pane->position = 0;
    $pane->locks = array();
    $pane->uuid = '05c0a8a5-2e8c-45b8-8f32-ae7d1d1e9b77';
    $display->content['new-05c0a8a5-2e8c-45b8-8f32-ae7d1d1e9b77'] = $pane;
    $display->panels['content'][0] = 'new-05c0a8a5-2e8c-45b8-8f32-ae7d1d1e9b77';
  $display->hide_title = PANELS_TITLE_FIXED;
  $display->title_pane = '0';
  $handler->conf['display'] = $display;
  $page->default_handlers[$handler->name] = $handler;
  $pages['premium_rates'] = $page;

  return $pages;

}
