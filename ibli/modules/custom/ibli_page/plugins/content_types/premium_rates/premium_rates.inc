<?php

/**
 * Plugin definition.
 */
$plugin = array(
  'title' => t('Premium Rates'),
  'description' => t('Premium rates table.'),
  'category' => t('ibli'),
);

/**
 * Render callback.
 */
function ibli_page_premium_rates_content_type_render($subtype, $conf, $args, $context) {
  drupal_add_js(drupal_get_path('module', 'ibli_page') . '/plugins/content_types/premium_rates/premium_rates.js');

  $block = new stdClass();
  $block->module = 'ibli_page';

  $csv = array_map('str_getcsv', file('public://data/IBLI_unit_premium_rates.csv'));

  // Hide redundant columns.
  foreach ($csv as &$row) {
    unset($row[3]);
    unset($row[5]);
    // Fix indices.
    $row = array_values($row);
  }

  $raw_header = array_slice($csv, 0, 1);
  $raw_header = $raw_header[0];
  $rows = array_slice($csv, 1);

  // Set colspans on the header.
  $header = array();
  $columns = count($raw_header);
  for ($index = 0; $index < $columns; $index++) {
    $colspan = 1;
    // Convert the title IBLI_UNIT to UNIT.
    $title = preg_match('/IBLI/i', $raw_header[$index]) ? substr($raw_header[$index], -4) : $raw_header[$index];
    // Convert empty titles into a colspan of the last non-empty title.
    while ($index < $columns - 1 && !$raw_header[$index + 1]) {
      $colspan++;
      $index++;
    }

    if ($index > 3) {
      // The first rate is on the 4th cell. Each block has 5 rates.
      $group_id = floor(($index - 5) / 5) + 1;

      $active = $group_id == 1 ? 'active' : '';
      $header[] = array(
        'data' => l($title, '', array('external' => TRUE, 'attributes' => array('data-group-id' => $group_id))),
        'colspan' => $colspan,
        'class' => array('toggle-hideable', $active, 'group-' . $group_id),
      );
    }
    else {
      $header[] = $title;
    }
  }

  // Premium class
  $premium_class = '';

  // Add a unique "colgroup" class to the rates sections.
  foreach ($rows as &$row) {
    foreach ($row as $index => &$cell) {
      $cell = ucwords(strtolower($cell));

      // The first rate is on the 4th cell.
      if ($index < 4) {
        continue;
      }

      // Each block has 5 rates.
      $group_id = floor(($index - 4) / 5) + 1;
      $class = $group_id > 1 ? 'hidden' : '';
      // Convert the title "rate" to "trigger".
      $cell = preg_match('/rate/i', $cell) ? str_replace('rate', ' trigger', $cell) : $cell;
      // Convert value of the cell to %.
      $cell = is_numeric($cell) ? $cell = number_format($cell*100, 2, '.', '').'%' : $cell;
      // Add "premium" class to the 15rate column.
      $premium_class = ($index - 4) % 5 == 1 ? 'premium' : '';

      $cell = array('data' => "<span class=\"$class\">$cell</span>", 'class' => array('hideable', 'group-' . $group_id, $premium_class));
    }
  }

  $block->content = theme('table', array('header' => $header, 'rows' => $rows));

  return $block;
}

/**
 * Edit form.
 */
function ibli_page_premium_rates_type_edit_form($form, &$form_state) {
  return $form;
}
