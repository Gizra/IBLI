<?php

/**
 * Migrate "page" nodes.
 */
class IbliPageNodes extends ShenkarMigration {
  public $entityType = 'node';
  public $bundle = 'page';

  public $csvColumns = array(
    array('field_body', 'Body'),
  );

  public function __construct() {
    parent::__construct();

    // Map fields that don't need extra definitions.
    $field_names = array(
      'field_body',
    );
    $this->addSimpleMappings($field_names);
  }
}
