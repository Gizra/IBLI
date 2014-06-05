<?php

/**
 * Migrate "page" nodes.
 */
class IbliPageNodes extends IbliMigration {
  public $entityType = 'node';
  public $bundle = 'page';

  public $csvColumns = array(
    array('field_image', 'Image'),
    array('show_in_menu', 'Show In Menu'),
    array('parent', 'Menu Parent'),
    array('weight', 'Menu Order'),
    array('show_in_ground', 'Show In IBLI On The Ground'),
  );

  public function __construct() {
    parent::__construct();

    // Map body.
    $this->addFieldMapping('body', 'body')
      ->arguments(array('format' => 'full_html'));

    // Map image.
    $this->addFieldMapping('field_image', 'field_image');
    $this
      ->addFieldMapping('field_image:file_replace')
      ->defaultValue(FILE_EXISTS_REPLACE);
    $this
      ->addFieldMapping('field_image:source_dir')
      ->defaultValue(drupal_get_path('module', 'ibli_migrate') . '/images');
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

    if (!empty($row->field_image)) {
      // Remove the "public://" from image paths.
      $row->field_image = str_replace('public://', '', $row->field_image);
    }
  }

  /**
   * Create menu links for nodes and add nodes to nodequeue.
   */
  public function complete($entity, $row) {
    if (!empty($row->show_in_ground)) {
      // Add node to the "IBLI On The Ground" nodequeue.
      $this->nodequeueAddNodeToSubqueueList('ibli_on_the_ground', $entity->nid);
    }

    if (!$row->show_in_menu) {
      // Do not create menu link.
      return;
    }

    $menu_name = variable_get('menu_main_links_source', 'menu-ibli-main-menu');

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
