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
  $display->layout = 'ibli_8_4';
  $display->layout_settings = array();
  $display->panel_settings = array(
    'style_settings' => array(
      'default' => NULL,
      'left' => NULL,
      'right' => NULL,
    ),
  );
  $display->cache = array();
  $display->title = '';
  $display->uuid = 'cf70b3f8-7a9b-4c88-a9e3-312296882738';
  $display->content = array();
  $display->panels = array();
    $pane = new stdClass();
    $pane->pid = 'new-52e4dfc5-d220-430b-9352-87056aade7f9';
    $pane->panel = 'left';
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
    $pane->uuid = '52e4dfc5-d220-430b-9352-87056aade7f9';
    $display->content['new-52e4dfc5-d220-430b-9352-87056aade7f9'] = $pane;
    $display->panels['left'][0] = 'new-52e4dfc5-d220-430b-9352-87056aade7f9';
    $pane = new stdClass();
    $pane->pid = 'new-b15fae41-b679-4b12-af25-c54a1615c9c8';
    $pane->panel = 'left';
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
    $pane->uuid = 'b15fae41-b679-4b12-af25-c54a1615c9c8';
    $display->content['new-b15fae41-b679-4b12-af25-c54a1615c9c8'] = $pane;
    $display->panels['left'][1] = 'new-b15fae41-b679-4b12-af25-c54a1615c9c8';
    $pane = new stdClass();
    $pane->pid = 'new-dc6ebcbf-54da-46ed-995f-54a6cdccf3da';
    $pane->panel = 'right';
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
    $pane->uuid = 'dc6ebcbf-54da-46ed-995f-54a6cdccf3da';
    $display->content['new-dc6ebcbf-54da-46ed-995f-54a6cdccf3da'] = $pane;
    $display->panels['right'][0] = 'new-dc6ebcbf-54da-46ed-995f-54a6cdccf3da';
    $pane = new stdClass();
    $pane->pid = 'new-88f036d9-475c-4894-968b-40eeb3e96ca1';
    $pane->panel = 'right';
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
    $pane->position = 1;
    $pane->locks = array();
    $pane->uuid = '88f036d9-475c-4894-968b-40eeb3e96ca1';
    $display->content['new-88f036d9-475c-4894-968b-40eeb3e96ca1'] = $pane;
    $display->panels['right'][1] = 'new-88f036d9-475c-4894-968b-40eeb3e96ca1';
  $display->hide_title = PANELS_TITLE_NONE;
  $display->title_pane = '0';
  $handler->conf['display'] = $display;
  $page->default_handlers[$handler->name] = $handler;
  $pages['contact_us'] = $page;

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
  $display->uuid = '1bf8f610-771e-4f88-8fa2-5b48e7930f2e';
  $display->content = array();
  $display->panels = array();
    $pane = new stdClass();
    $pane->pid = 'new-f64d6492-c710-4515-8004-fafdd73b7818';
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
    $pane->uuid = 'f64d6492-c710-4515-8004-fafdd73b7818';
    $display->content['new-f64d6492-c710-4515-8004-fafdd73b7818'] = $pane;
    $display->panels['left'][0] = 'new-f64d6492-c710-4515-8004-fafdd73b7818';
    $pane = new stdClass();
    $pane->pid = 'new-552c8d35-d518-42f4-8e86-bc2b779d080d';
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
    $pane->uuid = '552c8d35-d518-42f4-8e86-bc2b779d080d';
    $display->content['new-552c8d35-d518-42f4-8e86-bc2b779d080d'] = $pane;
    $display->panels['right'][0] = 'new-552c8d35-d518-42f4-8e86-bc2b779d080d';
    $pane = new stdClass();
    $pane->pid = 'new-bd5a345f-38aa-44cd-8a1c-6a86596309b6';
    $pane->panel = 'top';
    $pane->type = 'boxes_below_map';
    $pane->subtype = 'boxes_below_map';
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
    $pane->uuid = 'bd5a345f-38aa-44cd-8a1c-6a86596309b6';
    $display->content['new-bd5a345f-38aa-44cd-8a1c-6a86596309b6'] = $pane;
    $display->panels['top'][0] = 'new-bd5a345f-38aa-44cd-8a1c-6a86596309b6';
  $display->hide_title = PANELS_TITLE_FIXED;
  $display->title_pane = '0';
  $handler->conf['display'] = $display;
  $page->default_handlers[$handler->name] = $handler;
  $pages['homepage'] = $page;

  return $pages;

}
