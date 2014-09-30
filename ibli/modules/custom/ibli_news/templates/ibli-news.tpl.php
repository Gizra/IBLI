<?php foreach ($news_items as $item): ?>
  <div class="media">
    <a class="pull-left" href="#">
    </a>
    <div class="media-body">
      <a href="<?php print $item['link']; ?>" target="_blank"><?php print $item['title']; ?></a>
      <br />
      <span class="text-muted"><?php print $item['date']; ?></span>
      <p><?php print $item['description']; ?> </p>
    </div>
  </div>
<?php endforeach; ?>
