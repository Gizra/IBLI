<?php

/**
 * @file
 */

class IbliWebformNodes extends IbliMigration {
  protected $csvColumns = array(
    array('confirmation', 'Confirmation'),
  );

  protected $entityType = 'node';
  protected $bundle = 'webform';

  public function __construct() {
    parent::__construct();
  }

  public function complete($entity, $row) {
    // Create the webform record.
    $webform_record = array(
      'nid' => $entity->nid,
      'next_serial' => 1,
      'confirmation' => $row->confirmation,
      'confirmation_format' => 'filtered_html',
      'redirect_url' => '<none>',
      'status' => 1,
      'block' => 0,
      'allow_draft' => 0,
      'auto_save' => 0,
      'submit_notice' => 1,
      'submit_text' => 'OK',
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

    db_update('webform')->fields($webform_record)->execute();
  }
}
