<?php
/**
 * @file
 * ibli_homepage.pages_default.inc
 */

/**
 * Implements hook_default_page_manager_pages().
 */
function ibli_homepage_default_page_manager_pages() {
  $page = new stdClass();
  $page->disabled = FALSE; /* Edit this to true to make a default page disabled initially */
  $page->api_version = 1;
  $page->name = 'homepage';
  $page->task = 'page';
  $page->admin_title = 'Homepage';
  $page->admin_description = '';
  $page->path = 'home';
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
  $handler->name = 'page_homepage_panel_context';
  $handler->task = 'page';
  $handler->subtask = 'homepage';
  $handler->handler = 'panel_context';
  $handler->weight = 0;
  $handler->conf = array(
    'title' => 'Homepage',
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
  $display->layout = 'homepage';
  $display->layout_settings = array();
  $display->panel_settings = array(
    'style_settings' => array(
      'default' => NULL,
      'top' => NULL,
      'left' => NULL,
      'right' => NULL,
      'bottom' => NULL,
    ),
  );
  $display->cache = array();
  $display->title = '<notitle>';
  $display->uuid = '508be4bc-61cd-400c-8d22-ebe2645721e9';
  $display->content = array();
  $display->panels = array();
    $pane = new stdClass();
    $pane->pid = 'new-bf0cb908-add3-4857-a1a7-735a2ac92edd';
    $pane->panel = 'bottom';
    $pane->type = 'ibli_on_the_ground';
    $pane->subtype = 'ibli_on_the_ground';
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
    $pane->uuid = 'bf0cb908-add3-4857-a1a7-735a2ac92edd';
    $display->content['new-bf0cb908-add3-4857-a1a7-735a2ac92edd'] = $pane;
    $display->panels['bottom'][0] = 'new-bf0cb908-add3-4857-a1a7-735a2ac92edd';
    $pane = new stdClass();
    $pane->pid = 'new-751ba503-fd75-4d21-a224-f7afde2174d6';
    $pane->panel = 'left';
    $pane->type = 'views_panes';
    $pane->subtype = 'page_element-panel_page_element';
    $pane->shown = TRUE;
    $pane->access = array();
    $pane->configuration = array(
      'arguments' => array(
        'field_page_value' => 'home',
        'field_position_value' => 'welcome',
      ),
    );
    $pane->cache = array();
    $pane->style = array(
      'settings' => NULL,
    );
    $pane->css = array();
    $pane->extras = array();
    $pane->position = 0;
    $pane->locks = array();
    $pane->uuid = '751ba503-fd75-4d21-a224-f7afde2174d6';
    $display->content['new-751ba503-fd75-4d21-a224-f7afde2174d6'] = $pane;
    $display->panels['left'][0] = 'new-751ba503-fd75-4d21-a224-f7afde2174d6';
    $pane = new stdClass();
    $pane->pid = 'new-78c41d5e-4ebb-4277-97b8-38fefdf6a38c';
    $pane->panel = 'right';
    $pane->type = 'last_updates';
    $pane->subtype = 'last_updates';
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
    $pane->uuid = '78c41d5e-4ebb-4277-97b8-38fefdf6a38c';
    $display->content['new-78c41d5e-4ebb-4277-97b8-38fefdf6a38c'] = $pane;
    $display->panels['right'][0] = 'new-78c41d5e-4ebb-4277-97b8-38fefdf6a38c';
    $pane = new stdClass();
    $pane->pid = 'new-48692876-9cb0-4c7f-be3c-c2cc498acb46';
    $pane->panel = 'top';
    $pane->type = 'boxes_below_map';
    $pane->subtype = 'boxes_below_map';
    $pane->shown = TRUE;
    $pane->access = array();
    $pane->configuration = array(
      'override_title' => 0,
      'override_title_text' => '',
    );
    $pane->cache = array();
    $pane->style = array(
      'settings' => NULL,
    );
    $pane->css = array();
    $pane->extras = array();
    $pane->position = 0;
    $pane->locks = array();
    $pane->uuid = '48692876-9cb0-4c7f-be3c-c2cc498acb46';
    $display->content['new-48692876-9cb0-4c7f-be3c-c2cc498acb46'] = $pane;
    $display->panels['top'][0] = 'new-48692876-9cb0-4c7f-be3c-c2cc498acb46';
  $display->hide_title = PANELS_TITLE_FIXED;
  $display->title_pane = 'new-48692876-9cb0-4c7f-be3c-c2cc498acb46';
  $handler->conf['display'] = $display;
  $page->default_handlers[$handler->name] = $handler;
  $pages['homepage'] = $page;

  return $pages;

}
