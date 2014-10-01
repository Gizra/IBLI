<?php

/**
 * Migrate "page" nodes.
 */
class IbliNewsFeedImporterNodes extends IbliMigration {
  public $entityType = 'node';
  public $bundle = 'news_feed_importer';

  public $csvColumns = array(
    array('feeds', 'Feeds'),
  );

  public function __construct() {
    parent::__construct();

  }
  /**
   * Insert the feed url into the node.
   */
  public function complete($entity, $row) {
    $entity->feeds['FeedsHTTPFetcher']['source'] = $row->feeds;
    node_save($entity);

    // Start the import process.
    while (FEEDS_BATCH_COMPLETE != feeds_source('news', $entity->nid)->import());
  }
}
