<?php

/**
 * Migrate "page" nodes.
 */
class IbliPageNodes extends IbliMigration {
  public $entityType = 'node';
  public $bundle = 'page';

  public $csvColumns = array(
    array('field_image', 'Image'),
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
    global $base_url;
    parent::prepareRow($row);

    // Fetch the body from a file stored under
    // "ibli_migrate/html/[bundle]/".
    $file = drupal_get_path('module', 'ibli_migrate') . '/html/' . $this->bundle . '/' . $row->id . '.html';
    if (!file_exists($file)) {
      drupal_set_message('cannot find ' . $file);
      return;
    }
    $content = file_get_contents($file);
    // Fixing images path.
    $content = str_replace('<img src="', '<img src="' . $base_url . '/' . variable_get('ibli_images_path'), $content);
    $row->body = $content;

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
  }
}
