<?php foreach ($news_items as $item): ?>
<div class="media">
  <a class="pull-left" href="#">
  </a>
  <div class="media-body">
    <a href="<?php print $link; ?>>"><?php print $title; ?>></a>
    <br />
    <span class="text-muted"><?php print $date; ?></span>
    <p><?php print $description; ?> </p>
  </div>
</div>
<?php endforeach; ?>
