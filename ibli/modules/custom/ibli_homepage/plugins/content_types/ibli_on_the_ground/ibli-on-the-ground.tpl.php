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
          <a href="<?php print $page['video_url'] ?>" class="<?php print $page['colorbox_class'] ?>">
            <?php print $page['image']; ?>
            <div class="play-video"></div>
            <div class="caption">
              <p><?php print $page['title']; ?></p>
            </div>
          </a>
        </div>
      </div>
    <?php endforeach; ?>
  </div>
</div>
