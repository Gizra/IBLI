<?php

/**
 * @file
 */

class IbliWebformNodes extends IbliMigration {
  protected $csvColumns = array(
    array('id', 'ID'),
    array('title', 'Title'),
  );

  protected $entityType = 'node';
  protected $bundle = 'webform';

  public function __construct() {
    parent::__construct();
  }

  public function complete($entity, $row) {
    $wrapper = entity_metadata_wrapper('node', $entity);

    // Create the webform record.
    $webform_record = array(
      'nid' => $entity->nid,
      'next_serial' => 1,
      'confirmation' => '',
      'confirmation_format' => 'filtered_html',
      // Redirect to the quest's module after the webform submit.
      'redirect_url' => 'node/' . $wrapper->field_module->getIdentifier(),
      'status' => 1,
      'block' => 0,
      'allow_draft' => 1,
      'auto_save' => 0,
      'submit_notice' => 1,
      'submit_text' => '',
      'submit_limit' => 1,
      'submit_interval' => -1,
      'total_submit_limit' => -1,
      'total_submit_interval' => -1,
      'progressbar_bar' => 0,
      'progressbar_page_number' => 0,
      'progressbar_percent' => 0,
      'progressbar_pagebreak_labels' => 0,
      'progressbar_include_confirmation' => 0,
      'progressbar_label_first' => 'Start',
      'progressbar_label_confirmation' => 'Complete',
      'preview' => 0,
      'preview_next_button_label' => '',
      'preview_prev_button_label' => '',
      'preview_title' => '',
      'preview_message' => '',
      'preview_message_format' => 'filtered_html',
      'preview_excluded_components' => 1
    );
    db_insert('webform')->fields($webform_record)->execute();

    // Set the webform roles.
    $role = user_role_load_by_name('authenticated user');
    db_insert('webform_roles')->fields(array('nid' => $entity->nid, 'rid' => $role->rid))->execute();
  }
}
