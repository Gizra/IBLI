<?php

/**
 * Migrate "page" nodes.
 */
class IbliPageNodes extends IbliMigration {
  public $entityType = 'node';
  public $bundle = 'page';

  public $csvColumns = array(
    array('show_in_menu', 'Show In Menu'),
    array('parent', 'Menu Parent'),
    array('weight', 'Menu Order'),
    array('show_in_ground', 'Show In IBLI On The Ground'),
    array('ground_weight', 'IBLI On The Ground Order'),
  );

  public function __construct() {
    parent::__construct();

    // Map body.
    $this->addFieldMapping('body', 'body')
      ->arguments(array('format' => 'full_html'));
  }

  /**
   * Get body content from HTML.
   */
  public function prepareRow($row) {
    parent::prepareRow($row);

    // Fetch the body from a file stored under
    // "ibli_migrate/html/[bundle]/".
    $file = drupal_get_path('module', 'ibli_migrate') . '/html/' . $this->bundle . '/' . $row->id . '.html';
    if (!file_exists($file)) {
      drupal_set_message('cannot find ' . $file);
      return;
    }
    $row->body = file_get_contents($file);
  }

  /**
   * Create menu links for nodes.
   */
  public function complete($entity, $row) {
    $menu_name = variable_get('menu_main_links_source', 'menu-ibli-main-menu');

    if (!$row->show_in_menu) {
      // Do not create menu link.
      return;
    }

    $m = array();
    $m['menu_name'] = $menu_name;
    $m['link_path'] = 'node/' . $entity->nid;
    $m['link_title'] = $entity->title;
    $m['weight'] = $row->weight;

    if ($row->parent) {
      $links = menu_load_links($menu_name);
      foreach ($links as $link) {
        if ($link['link_title'] == $row->parent) {
          $m['plid'] = $link['mlid'];
          break;
        }
      }
    }

    menu_link_save($m);
  }
}
