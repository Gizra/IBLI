
<div class="panel-display panel-ibli-homepage clearfix" <?php if (!empty($css_id)) { print 'id="' . $css_id . '"'; } ?>>

  <div class="row">
    <div class="col-md-12">
      <?php print $content['top']; ?>
    </div>
  </div>
  
  <div class="row">

    <div class="panel-panel panel-col-left col-xs-8 col-sm-8 col-md-8 col-lg-8">
      <div class="block-header">
        <h2>
          <span class="title">Welcome to IBLI</span><span class="decoration"></span><span class="decoration"></span><span class="decoration"></span>
        </h2>
      </div>
      <?php print $content['left']; ?>
    </div>

    <div class="panel-panel panel-col-right col-xs-4 col-sm-4 col-md-4 col-lg-4">
      <?php print $content['right']; ?>
    </div>
  </div>
  
  <div class="row">
    <div class="col-md-12 panel-col-bottom">
      <?php print $content['bottom']; ?>


      <!---------------------------------------------------------------------------------->
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
              <a href="<?php print $page['url']; ?>"><?php print $page['image']; ?></a>
              <div class="visit"><a href="#"><i class="fa fa-question-circle"></i> More details...</a></div>
              <div class="caption">
                <p><a href="<?php print $page['url']; ?>"><?php print $page['title']; ?></a></p>
              </div>
            </div>
          </div>
        <?php endforeach; ?>
      </div>
      <!---------------------------------------------------------------------------------->


    </div>
  </div>
</div>
