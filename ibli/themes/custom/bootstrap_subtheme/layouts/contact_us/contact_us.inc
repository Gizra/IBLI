<?php

// Plugin definition
$plugin = array(
  'title' => t('Contact Us'),
  'category' => t('IBLI'),
  'icon' => 'contact-us.png',
  'theme' => 'contact_us',
  'css' => 'contact-us.css',
  'regions' => array(
    'form' => t('Form'),
    'address' => t('Address'),
    'map' => t('Map'),
  ),
);
