<div class="ibli-on-the-ground">
  <div class="row">
    <div class="col-md-12 block-header">
      <h2>
        <span class="title"><?php print t('IBLI ON THE GROUND'); ?></span><span class="decoration"></span><span class="decoration"></span><span class="decoration"></span>
      </h2>
    </div>
  </div>
  <div class="row">
    <?php foreach ($nodequeue as $page): ?>
      <div class="col-md-3 col-sm-6">
        <div class="thumbnail">
          <a href="<?php print $page['video_url'] ?>?width=500&height=500&iframe=true" class="colorbox-load"><?php print $page['image']; ?></a>
          <div class="visit"><?php print t('Play video'); ?></div>
          <div class="caption">
            <p><a href="<?php print $page['url']; ?>"><?php print $page['title']; ?></a></p>
          </div>
        </div>
      </div>
    <?php endforeach; ?>
  </div>
</div>
