<?php

/**
 * Migrate "page" nodes.
 */
class IbliPageNodes extends ShenkarMigration {
  public $entityType = 'node';
  public $bundle = 'page';

  public $csvColumns = array(
    array('body', 'Body'),
    array('is_in_menu', 'Is In Menu'),
    array('parent', 'Menu Parent'),
    array('weight', 'Menu Order'),
  );

  public function __construct() {
    parent::__construct();

    // Map fields that don't need extra definitions.
    $field_names = array(
      'body',
    );
    $this->addSimpleMappings($field_names);
  }

  public function complete($entity, $row) {
    $menu_name = variable_get('menu_main_links_source', 'menu-ibli-main-menu');

    if (!$row->is_in_menu) {
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
