<?php

/**
 * Migrate "page_element" nodes.
 */
class IbliPageElementNodes extends IbliMigration {
  public $entityType = 'node';
  public $bundle = 'page_element';

  public $csvColumns = array(
    array('field_page', 'Page'),
    array('field_position', 'Position'),
    array('body', 'Body'),
  );

  public function __construct() {
    parent::__construct();

    // Map fields that don't need extra definitions.
    $field_names = array(
      'field_page',
      'field_position',
    );
    $this->addSimpleMappings($field_names);

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
}
