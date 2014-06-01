<?php

// Plugin definition
$plugin = array(
  'title' => t('Homepage'),
  'category' => t('IBLI'),
  'icon' => 'homepage.png',
  'theme' => 'ibli_homepage',
  'css' => 'homepage.css',
  'regions' => array(
    'top' => t('Top'),
    'left' => t('Left side'),
    'right' => t('Right side'),
    'last_updates' => t('Last updates'),
    'bottom' => t('Bottom'),
  ),
);
