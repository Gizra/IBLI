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

  // Exported menu link: menu-ibli-main-menu_about-us:<nolink>
  $menu_links['menu-ibli-main-menu_about-us:<nolink>'] = array(
    'menu_name' => 'menu-ibli-main-menu',
    'link_path' => '<nolink>',
    'router_path' => '<nolink>',
    'link_title' => 'About Us',
    'options' => array(
      'attributes' => array(
        'title' => '',
      ),
      'identifier' => 'menu-ibli-main-menu_about-us:<nolink>',
    ),
    'module' => 'menu',
    'hidden' => 0,
    'external' => 0,
    'has_children' => 1,
    'expanded' => 1,
    'weight' => -47,
    'customized' => 1,
  );
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
    'weight' => -50,
    'customized' => 1,
    'parent_identifier' => 'menu-ibli-main-menu_information:<nolink>',
  );
  // Exported menu link: menu-ibli-main-menu_contact-us:contact-us
  $menu_links['menu-ibli-main-menu_contact-us:contact-us'] = array(
    'menu_name' => 'menu-ibli-main-menu',
    'link_path' => 'contact-us',
    'router_path' => 'contact-us',
    'link_title' => 'Contact Us',
    'options' => array(
      'attributes' => array(
        'title' => '',
      ),
      'identifier' => 'menu-ibli-main-menu_contact-us:contact-us',
    ),
    'module' => 'menu',
    'hidden' => 0,
    'external' => 0,
    'has_children' => 0,
    'expanded' => 0,
    'weight' => -48,
    'customized' => 1,
    'parent_identifier' => 'menu-ibli-main-menu_about-us:<nolink>',
  );
  // Exported menu link: menu-ibli-main-menu_gallery:https://www.flickr.com/photos/125283442@N04/
  $menu_links['menu-ibli-main-menu_gallery:https://www.flickr.com/photos/125283442@N04/'] = array(
    'menu_name' => 'menu-ibli-main-menu',
    'link_path' => 'https://www.flickr.com/photos/125283442@N04/',
    'router_path' => '',
    'link_title' => 'Gallery',
    'options' => array(
      'attributes' => array(
        'title' => '',
      ),
      'identifier' => 'menu-ibli-main-menu_gallery:https://www.flickr.com/photos/125283442@N04/',
    ),
    'module' => 'menu',
    'hidden' => 0,
    'external' => 1,
    'has_children' => 0,
    'expanded' => 0,
    'weight' => -49,
    'customized' => 1,
    'parent_identifier' => 'menu-ibli-main-menu_about-us:<nolink>',
  );
  // Exported menu link: menu-ibli-main-menu_get-ibli:<front>
  $menu_links['menu-ibli-main-menu_get-ibli:<front>'] = array(
    'menu_name' => 'menu-ibli-main-menu',
    'link_path' => '<front>',
    'router_path' => '',
    'link_title' => 'Get IBLI',
    'options' => array(
      'attributes' => array(
        'title' => '',
      ),
      'identifier' => 'menu-ibli-main-menu_get-ibli:<front>',
    ),
    'module' => 'menu',
    'hidden' => 0,
    'external' => 1,
    'has_children' => 0,
    'expanded' => 0,
    'weight' => -49,
    'customized' => 1,
  );
  // Exported menu link: menu-ibli-main-menu_information:<nolink>
  $menu_links['menu-ibli-main-menu_information:<nolink>'] = array(
    'menu_name' => 'menu-ibli-main-menu',
    'link_path' => '<nolink>',
    'router_path' => '<nolink>',
    'link_title' => 'Information',
    'options' => array(
      'attributes' => array(
        'title' => '',
      ),
      'identifier' => 'menu-ibli-main-menu_information:<nolink>',
    ),
    'module' => 'menu',
    'hidden' => 0,
    'external' => 0,
    'has_children' => 1,
    'expanded' => 1,
    'weight' => -48,
    'customized' => 1,
  );
  // Exported menu link: menu-ibli-main-menu_partners:<front>
  $menu_links['menu-ibli-main-menu_partners:<front>'] = array(
    'menu_name' => 'menu-ibli-main-menu',
    'link_path' => '<front>',
    'router_path' => '',
    'link_title' => 'Partners',
    'options' => array(
      'attributes' => array(
        'title' => '',
      ),
      'identifier' => 'menu-ibli-main-menu_partners:<front>',
    ),
    'module' => 'menu',
    'hidden' => 0,
    'external' => 1,
    'has_children' => 0,
    'expanded' => 0,
    'weight' => -50,
    'customized' => 1,
    'parent_identifier' => 'menu-ibli-main-menu_about-us:<nolink>',
  );
  // Exported menu link: menu-ibli-main-menu_past-index-maps:<front>
  $menu_links['menu-ibli-main-menu_past-index-maps:<front>'] = array(
    'menu_name' => 'menu-ibli-main-menu',
    'link_path' => '<front>',
    'router_path' => '',
    'link_title' => 'Past Index Maps',
    'options' => array(
      'attributes' => array(
        'title' => '',
      ),
      'identifier' => 'menu-ibli-main-menu_past-index-maps:<front>',
    ),
    'module' => 'menu',
    'hidden' => 0,
    'external' => 1,
    'has_children' => 0,
    'expanded' => 0,
    'weight' => -49,
    'customized' => 1,
    'parent_identifier' => 'menu-ibli-main-menu_information:<nolink>',
  );
  // Exported menu link: menu-ibli-main-menu_what-is-ibli:node/5
  $menu_links['menu-ibli-main-menu_what-is-ibli:node/5'] = array(
    'menu_name' => 'menu-ibli-main-menu',
    'link_path' => 'node/5',
    'router_path' => 'node/%',
    'link_title' => 'What is IBLI?',
    'options' => array(
      'identifier' => 'menu-ibli-main-menu_what-is-ibli:node/5',
    ),
    'module' => 'menu',
    'hidden' => 0,
    'external' => 0,
    'has_children' => 0,
    'expanded' => 0,
    'weight' => -50,
    'customized' => 1,
  );
  // Translatables
  // Included for use with string extractors like potx.
  t('About Us');
  t('Blog');
  t('Contact Us');
  t('Gallery');
  t('Get IBLI');
  t('Information');
  t('Partners');
  t('Past Index Maps');
  t('What is IBLI?');


  return $menu_links;
}
