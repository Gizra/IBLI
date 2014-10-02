<?php

/**
 * @file
 * IbliSubscriptionWebform
 */

class IbliSubscriptionWebform extends IbliMigration {
  protected $csvColumns = array(
    array('id', 'ID'),
    array('nid', 'Subscription'),
    array('type', 'Type'),
    array('name', 'Label'),
    array('weight', 'Weight'),
    array('value', 'Value'),
    array('required', 'Required'),
    array('settings', 'Settings'),
  );

  protected $entityType = 'webform_component';
  protected $bundle = 'subscription';

  public function __construct() {
    parent::__construct();

    $this->dependencies = array(
      'IbliWebformNodes',
    );

    $this->description = t('Import @bundle nodes from CSV file.', array('@bundle' => $this->bundle));

    $key = array(
      'id' => array(
        'type' => 'int',
        'not null' => TRUE,
        'unsigned' => TRUE,
      ),
    );

    $this->destination = new MigrateDestinationWebformComponent();
    $this->map = new MigrateSQLMap($this->machineName, $key, $this->destination->getKeySchema($this->entityType));

    // Create a MigrateSource object.
    $csv_file = $this->entityType . '/' . $this->bundle . '.csv';
    $this->source = new MigrateSourceCSV(drupal_get_path('module', 'ibli_migrate') . '/csv/' . $csv_file, $this->csvColumns, array('header_rows' => 1));

    $field_names = array(
      'form_key',
      'type',
      'name',
      'weight',
      'value',
      'required',
    );
    $this->addSimpleMappings($field_names);

    $this
      ->addFieldMapping('nid', 'nid')
      ->sourceMigration('IbliWebformNodes');

    $this
      ->addFieldMapping('pid')
      ->defaultValue(0);

    // Extra is being set in prepare().
    $this->addFieldMapping('extra');
  }

  /**
   * Automatically assign the component machine name.
   */
  public function prepareRow($row) {
    parent::prepareRow($row);

    $row->form_key = $row->nid . '_' . $row->id . '_' . $row->type;
  }

  public function prepare($entity, $row) {
    // Default component settings.
    $settings = array(
      'wrapper_classes' => 'input-group',
      'css_classes' => 'form-control',
    );

    // Add component type default settings.
    if ($row->type == 'textfield') {
      $settings += array(
        'title_display' => 'none',
        'resizable' => FALSE,
        'placeholder' => $row->name,
      );
    }

    // Override the default type settings with the row's custom settings.
    if ($row->settings) {
      $settings += json_decode($row->settings, TRUE);
    }

    $entity->extra = $settings;
  }
}
