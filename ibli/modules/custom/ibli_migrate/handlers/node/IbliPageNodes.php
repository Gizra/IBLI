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
    array('parent', 'Parent'),
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

    if (!$row->is_in_menu) {
      // Do not create menu link.
      return;
    }

    $m = array();
    $m['menu_name'] = 'main-menu';
    $m['link_path'] = 'node/' . $entity->nid;
    $m['link_title'] = $entity->title;

    if ($row->parent) {
      $links = menu_load_links('main-menu');
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
