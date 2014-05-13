<?php
/**
 * @file
 * ibli_general.features.menu_links.inc
 */

/**
 * Implements hook_menu_default_menu_links().
 */
function ibli_general_menu_default_menu_links() {
  $menu_links = array();

  // Exported menu link: menu-ibli-main-menu_blog:http://livestockinsurance.wordpress.com
  $menu_links['menu-ibli-main-menu_blog:http://livestockinsurance.wordpress.com'] = array(
    'menu_name' => 'menu-ibli-main-menu',
    'link_path' => 'http://livestockinsurance.wordpress.com',
    'router_path' => '',
    'link_title' => 'Blog',
    'options' => array(
      'attributes' => array(
        'title' => '',
      ),
      'identifier' => 'menu-ibli-main-menu_blog:http://livestockinsurance.wordpress.com',
    ),
    'module' => 'menu',
    'hidden' => 0,
    'external' => 1,
    'has_children' => 0,
    'expanded' => 0,
    'weight' => 10,
    'customized' => 1,
  );
  // Exported menu link: menu-ibli-main-menu_pages:<nolink>
  $menu_links['menu-ibli-main-menu_pages:<nolink>'] = array(
    'menu_name' => 'menu-ibli-main-menu',
    'link_path' => '<nolink>',
    'router_path' => '<nolink>',
    'link_title' => 'Pages',
    'options' => array(
      'attributes' => array(
        'title' => '',
      ),
      'identifier' => 'menu-ibli-main-menu_pages:<nolink>',
    ),
    'module' => 'menu',
    'hidden' => 0,
    'external' => 0,
    'has_children' => 1,
    'expanded' => 1,
    'weight' => 2,
    'customized' => 1,
  );
  // Exported menu link: menu-ibli-main-menu_partners:<nolink>
  $menu_links['menu-ibli-main-menu_partners:<nolink>'] = array(
    'menu_name' => 'menu-ibli-main-menu',
    'link_path' => '<nolink>',
    'router_path' => '<nolink>',
    'link_title' => 'Partners',
    'options' => array(
      'attributes' => array(
        'title' => '',
      ),
      'identifier' => 'menu-ibli-main-menu_partners:<nolink>',
    ),
    'module' => 'menu',
    'hidden' => 0,
    'external' => 0,
    'has_children' => 1,
    'expanded' => 1,
    'weight' => 6,
    'customized' => 1,
  );
  // Translatables
  // Included for use with string extractors like potx.
  t('Blog');
  t('Pages');
  t('Partners');


  return $menu_links;
}
