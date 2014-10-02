<?php

class MigrateDestinationWebformComponent extends MigrateDestination {
  static public function getKeySchema() {
    return array(
      'cid' => array(
        'type' => 'int',
        'not null' => TRUE,
        'unsigned' => TRUE,
      ),
    );
  }

  /**
   * Constructs a destination for a given webform node.
   *
   * @param object $node
   *   A node object that's type has been enabled for webform use.
   */
  public function __construct() {
    parent::__construct();

    // We use the functions in this file in import() but load it here so we
    // only do it once.
    module_load_include('inc', 'webform', 'includes/webform.components');
  }

  public function __toString() {
    return 'Webform components';
  }

  /**
   * Returns a list of fields available to be mapped.
   *
   * @return array
   *   Keys: machine names of the fields (to be passed to addFieldMapping)
   *   Values: Human-friendly descriptions of the fields.
   */
  public function fields() {

    $fields = array(
      'nid' => t('Webform node'),
      'cid' => t('Component id'),
      'pid' => t('Parent component id'),
      'form_key' => t('Component machine name'),
      'name' => t('Component label'),
      'type' => t('Component type'),
      'value' => t('Default value'),
      'extra' => t('Serialized settings'),
      'required' => t('Required'),
      'weight' => t('Weight'),
    );

    return $fields;
  }

  /**
   * Give handlers a shot at modifying the object before saving it.
   *
   * @param $entity
   *   Webform component object to build. Prefilled with any fields mapped in
   *   the Migration.
   * @param $source_row
   *   Raw source data object - passed through to prepare handlers.
   */
  public function prepare($entity, stdClass $source_row) {
    $migration = Migration::currentMigration();
    $entity->migrate = array(
      'machineName' => $migration->getMachineName(),
    );

    // Then call any prepare handler for this specific Migration.
    if (method_exists($migration, 'prepare')) {
      $migration->prepare($entity, $source_row);
    }
  }

  /**
   * Give handlers a shot at modifying the object (or taking additional action)
   * after saving it.
   *
   * @param $entity
   *   Webform component object to build. This is the complete object after
   *   saving.
   * @param $source_row
   *   Raw source data object - passed through to complete handlers.
   */
  public function complete($entity, stdClass $source_row) {
    $migration = Migration::currentMigration();
    // Call any general object handlers.
    migrate_handler_invoke_all('WebformComponent', 'complete', $entity, $source_row);
    // Then call any complete handler for this specific Migration.
    if (method_exists($migration, 'complete')) {
      $migration->complete($entity, $source_row);
    }
  }

  /**
   * Import a record.
   *
   * @param $entity
   *   Webform component object to build. This is the complete object after
   *   saving.
   * @param $source_row
   *   Raw source data object - passed through to complete handlers.
   */
  public function import(stdClass $entity, stdClass $row) {
    // Updating previously-migrated content?
    $migration = Migration::currentMigration();
    if (isset($row->migrate_map_destid1)) {
      if (isset($entity->cid) && $entity->cid != $row->migrate_map_destid1) {
        throw new MigrateException(t("Incoming cid !cid and map destination sid !destid1 don't match",
          array('!cid' => $entity->cid, '!destid1' => $row->migrate_map_destid1)));
      }
      else {
        $entity->cid = $row->migrate_map_destid1;
      }
    }

    if (is_array($entity->nid)) {
      $entity->nid = $entity->nid['destid1'];
    }

    // Invoke migration prepare handlers
    $this->prepare($entity, $row);

    migrate_instrument_start('webform_component_update/insert');
    // Determine if it's an insert or update.
    if (empty($entity->cid)) {
      $updating = FALSE;
      $component = (array)$entity;
      $entity->cid = webform_component_insert($component);
    }
    else {
      // If the sid was specified but doesn't exist we'll need to stick an
      // empty record in so webform's update has something to stick to.
      $status = db_merge('webform_component')
        ->key(array(
          'cid' => $entity->cid,
        ))
        ->insertFields(array(
          'nid' => $entity->nid,
          'cid' => $entity->cid,
          'pid' => $entity->pid,
          'form_key' => $entity->form_key,
          'name' => $entity->name,
          'type' => $entity->type,
          'value' => $entity->value,
          'extra' => $entity->extra,
          'required' => $entity->required,
          'weight' => $entity->wight,
        ))
        ->execute();
      // If db_merge() makes no changes $status is NULL so make a less
      // elegant comparison.
      $updating = MergeQuery::STATUS_INSERT !== $status;
      webform_component_update($entity);
    }
    migrate_instrument_stop('webform_component_update/insert');


    if ($updating) {
      $this->numUpdated++;
    }
    else {
      $this->numCreated++;
    }

    // Invoke migration complete handlers
    $this->complete($entity, $row);

    return array($entity->cid);
  }

  /**
   * Delete a batch of submissions at once.
   *
   * @param $cids
   *   Array of component IDs to be deleted.
   */
  public function bulkRollback(array $cids) {
    // TODO: Implement rollback
  }
}
