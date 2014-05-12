<?php
/**
 * @file
 * ibli_general.features.menu_custom.inc
 */

/**
 * Implements hook_menu_default_menu_custom().
 */
function ibli_general_menu_default_menu_custom() {
  $menus = array();

  // Exported menu: menu-ibli-main-menu.
  $menus['menu-ibli-main-menu'] = array(
    'menu_name' => 'menu-ibli-main-menu',
    'title' => 'IBLI Main Menu',
    'description' => '',
  );
  // Translatables
  // Included for use with string extractors like potx.
  t('IBLI Main Menu');


  return $menus;
}
