<?php

/**
 * Migrate "publication" nodes.
 */
class IbliPublicationNodes extends IbliMigration {
  public $entityType = 'node';
  public $bundle = 'publication';

  public $csvColumns = array(
    array('field_file', 'File'),
  );

  public function __construct() {
    parent::__construct();

    // Map body.
    $this->addFieldMapping('body', 'body')
      ->arguments(array('format' => 'full_html'));

    // Map image.
    $this->addFieldMapping('field_file', 'field_file');
    $this
      ->addFieldMapping('field_file:file_replace')
      ->defaultValue(FILE_EXISTS_REPLACE);
    $this
      ->addFieldMapping('field_file:source_dir')
      ->defaultValue(drupal_get_path('module', 'ibli_migrate') . '/files');
  }

  /**
   * Set file path.
   */
  public function prepareRow($row) {
    parent::prepareRow($row);

    if (!empty($row->field_file)) {
      // Remove the "public://" from file paths.
      $row->field_file = str_replace('public://', '', $row->field_file);
    }
  }
}
