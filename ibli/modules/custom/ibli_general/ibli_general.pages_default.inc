<?php
/**
 * @file
 * ibli_general.pages_default.inc
 */

/**
 * Implements hook_default_page_manager_pages().
 */
function ibli_general_default_page_manager_pages() {
  $page = new stdClass();
  $page->disabled = FALSE; /* Edit this to true to make a default page disabled initially */
  $page->api_version = 1;
  $page->name = 'contact_us';
  $page->task = 'page';
  $page->admin_title = 'Contact Us';
  $page->admin_description = 'Contact Us panel';
  $page->path = 'contact-us';
  $page->access = array(
    'type' => 'none',
    'settings' => NULL,
  );
  $page->menu = array();
  $page->arguments = array();
  $page->conf = array(
    'admin_paths' => FALSE,
  );
  $page->default_handlers = array();
  $handler = new stdClass();
  $handler->disabled = FALSE; /* Edit this to true to make a default handler disabled initially */
  $handler->api_version = 1;
  $handler->name = 'page_contact_us_panel_context';
  $handler->task = 'page';
  $handler->subtask = 'contact_us';
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
  $display->layout = 'contact_us';
  $display->layout_settings = array();
  $display->panel_settings = array(
    'style_settings' => array(
      'default' => NULL,
      'form' => NULL,
      'address' => NULL,
      'map' => NULL,
    ),
  );
  $display->cache = array();
  $display->title = '';
  $display->uuid = 'cf70b3f8-7a9b-4c88-a9e3-312296882738';
  $display->content = array();
  $display->panels = array();
    $pane = new stdClass();
    $pane->pid = 'new-24e5a80c-78bd-454e-ae2a-84cf0feec1d5';
    $pane->panel = 'address';
    $pane->type = 'views_panes';
    $pane->subtype = 'page_element-panel_page_element';
    $pane->shown = TRUE;
    $pane->access = array();
    $pane->configuration = array(
      'arguments' => array(
        'field_page_value' => 'contact',
        'field_position_value' => 'address',
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
    $pane->uuid = '24e5a80c-78bd-454e-ae2a-84cf0feec1d5';
    $display->content['new-24e5a80c-78bd-454e-ae2a-84cf0feec1d5'] = $pane;
    $display->panels['address'][0] = 'new-24e5a80c-78bd-454e-ae2a-84cf0feec1d5';
    $pane = new stdClass();
    $pane->pid = 'new-17596442-c407-4bde-a0df-9a5468a756aa';
    $pane->panel = 'form';
    $pane->type = 'views_panes';
    $pane->subtype = 'page_element-panel_page_element';
    $pane->shown = TRUE;
    $pane->access = array();
    $pane->configuration = array(
      'arguments' => array(
        'field_page_value' => 'contact',
        'field_position_value' => 'form',
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
    $pane->uuid = '17596442-c407-4bde-a0df-9a5468a756aa';
    $display->content['new-17596442-c407-4bde-a0df-9a5468a756aa'] = $pane;
    $display->panels['form'][0] = 'new-17596442-c407-4bde-a0df-9a5468a756aa';
    $pane = new stdClass();
    $pane->pid = 'new-c2fc4a79-fe31-4ae2-a928-22f631721d66';
    $pane->panel = 'form';
    $pane->type = 'contact';
    $pane->subtype = 'contact';
    $pane->shown = TRUE;
    $pane->access = array();
    $pane->configuration = array(
      'override_title' => 1,
      'override_title_text' => '',
    );
    $pane->cache = array();
    $pane->style = array(
      'settings' => NULL,
    );
    $pane->css = array();
    $pane->extras = array();
    $pane->position = 1;
    $pane->locks = array();
    $pane->uuid = 'c2fc4a79-fe31-4ae2-a928-22f631721d66';
    $display->content['new-c2fc4a79-fe31-4ae2-a928-22f631721d66'] = $pane;
    $display->panels['form'][1] = 'new-c2fc4a79-fe31-4ae2-a928-22f631721d66';
    $pane = new stdClass();
    $pane->pid = 'new-d7fe1cd7-2bb8-46f9-836d-856aaf607324';
    $pane->panel = 'map';
    $pane->type = 'views_panes';
    $pane->subtype = 'page_element-panel_page_element';
    $pane->shown = TRUE;
    $pane->access = array();
    $pane->configuration = array(
      'arguments' => array(
        'field_page_value' => 'contact',
        'field_position_value' => 'map',
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
    $pane->uuid = 'd7fe1cd7-2bb8-46f9-836d-856aaf607324';
    $display->content['new-d7fe1cd7-2bb8-46f9-836d-856aaf607324'] = $pane;
    $display->panels['map'][0] = 'new-d7fe1cd7-2bb8-46f9-836d-856aaf607324';
  $display->hide_title = PANELS_TITLE_NONE;
  $display->title_pane = '0';
  $handler->conf['display'] = $display;
  $page->default_handlers[$handler->name] = $handler;
  $pages['contact_us'] = $page;

  $page = new stdClass();
  $page->disabled = FALSE; /* Edit this to true to make a default page disabled initially */
  $page->api_version = 1;
  $page->name = 'partners';
  $page->task = 'page';
  $page->admin_title = 'Partners';
  $page->admin_description = '';
  $page->path = 'partners';
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
  $handler->name = 'page_partners_panel_context';
  $handler->task = 'page';
  $handler->subtask = 'partners';
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
  $display->layout = 'partners';
  $display->layout_settings = array();
  $display->panel_settings = array(
    'style_settings' => array(
      'default' => NULL,
    ),
  );
  $display->cache = array();
  $display->title = '';
  $display->uuid = '6ed7e305-5b58-466b-8173-2d205f44eb82';
  $display->content = array();
  $display->panels = array();
  $display->hide_title = PANELS_TITLE_FIXED;
  $display->title_pane = '0';
  $handler->conf['display'] = $display;
  $page->default_handlers[$handler->name] = $handler;
  $pages['partners'] = $page;

  return $pages;

}
