<?php

/**
 * @file
 * Populate distribution with some content.
 */

abstract class IbliMigration extends Migration {

  public function __construct() {
    parent::__construct();

    // Make sure we can use it for node and term only.
    if (!in_array($this->entityType, array('node', 'taxonomy_term'))) {
      throw new Exception('IbliMigration supports only nodes and terms.');
    }

    $this->description = t('Import @type - @bundle from CSV file.', array('@type' => $this->entityType, '@bundle' => $this->bundle));

    $this->delimiter = ',';

    $this->csvColumns = !empty($this->csvColumns) ? $this->csvColumns : array();

    // Default CSV columns.
    $csv_cols[] = array('id', 'Unique ID');
    if ($this->entityType == 'node') {
      // Nodes.
      $this->addFieldMapping('title', 'title');
      $class_name = 'MigrateDestinationNode';
      $csv_cols[] = array('title', 'Title');
    }
    elseif ($this->entityType == 'taxonomy_term') {
      // Terms.
      $this->addFieldMapping('name', 'name');
      $class_name = 'MigrateDestinationTerm';
      $csv_cols[] = array('name', 'Name');
    }

    // Rebuild the csv columns array.
    $this->csvColumns = array_merge($csv_cols, $this->csvColumns);

    // Create a map object for tracking the relationships between source rows
    $key = array(
      'id' => array(
        'type' => 'varchar',
        'length' => 255,
        'not null' => TRUE,
      ),
    );

    $destination_handler = new MigrateDestinationEntityAPI($this->entityType, $this->bundle);
    $this->map = new MigrateSQLMap($this->machineName, $key, $destination_handler->getKeySchema($this->entityType));

    // Set the options & path for the csv file.
    $path = drupal_get_path('module', 'ibli_migrate') . '/csv/' . $this->entityType . '/' . $this->bundle . '.csv';
    $options = array();
    $options['delimiter'] = $this->delimiter;
    $options['header_rows'] = 1;

    // Create a MigrateSource object.
    $this->source = new MigrateSourceCSV($path, $this->csvColumns, $options);
    $this->destination = new $class_name($this->bundle, array('text_format' => 'filtered_html'));

    $this
      ->addFieldMapping('uid')
      ->defaultValue(1);
  }
}
