<?php
/**
 * @file
 * ibli_homepage.features.inc
 */

/**
 * Implements hook_ctools_plugin_api().
 */
function ibli_homepage_ctools_plugin_api($module = NULL, $api = NULL) {
  if ($module == "strongarm" && $api == "strongarm") {
    return array("version" => "1");
  }
}

/**
 * Implements hook_image_default_styles().
 */
function ibli_homepage_image_default_styles() {
  $styles = array();

  // Exported image style: ibli_on_the_ground_thumbnail.
  $styles['ibli_on_the_ground_thumbnail'] = array(
    'name' => 'ibli_on_the_ground_thumbnail',
    'label' => 'IBLI On The Ground Thumbnail',
    'effects' => array(
      2 => array(
        'label' => 'Scale and crop',
        'help' => 'Scale and crop will maintain the aspect-ratio of the original image, then crop the larger dimension. This is most useful for creating perfectly square thumbnails without stretching the image.',
        'effect callback' => 'image_scale_and_crop_effect',
        'dimensions callback' => 'image_resize_dimensions',
        'form callback' => 'image_resize_form',
        'summary theme' => 'image_resize_summary',
        'module' => 'image',
        'name' => 'image_scale_and_crop',
        'data' => array(
          'width' => 263,
          'height' => 157,
        ),
        'weight' => 1,
      ),
    ),
  );

  return $styles;
}
