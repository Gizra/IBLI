<?php

/**
 * @file
 *
 * Base class for all Ibli migrations.
 */

class IbliBaseMigration extends Migration {

  public function prepareRow($row) {
    // Load html snippets.
    foreach ($row as $column => &$original_value) {
      // If the value is divided to multiple values, search a snippet for each
      // one separately.
      $values = explode('|', $original_value);
      foreach($values as $delta => &$value) {
        if ($value != '[file]') {
          continue;
        }
        // If the field is divided, add its delta to the file name.
        $column_delta = count($values) > 1 ? '_' . ($delta + 1) : '';
        $file = $this->entityType . '_' . $this->bundle . '_' . $row->id . '_' . $column . $column_delta . '.txt';
        // Get the html snippet.
        $value = file_get_contents(drupal_get_path('module', 'ibli_migrate') . '/file/' . $file);
      }

      // If the value was divided, combine it again.
      $original_value = implode('|', $values);
    }
  }
}
