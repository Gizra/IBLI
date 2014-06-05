
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
        <div class="col-md-3 col-sm-6">
          <div class="thumbnail">
            <img src="<?php print $images_path; ?>/ibli-on-the-ground-1.jpg" class="img-responsive" alt="...">
            <div class="visit"><a href="#"><i class="fa fa-question-circle"></i> More details...</a></div>
            <div class="caption">
              <p><?php print t('Index-Based Livestock Takaful in Wajir'); ?></p>
            </div>
          </div>
        </div>
        <div class="col-md-3 col-sm-6">
          <div class="thumbnail">
            <img src="<?php print $images_path; ?>/ibli-on-the-ground-2.jpg" class="img-responsive" alt="...">
            <div class="visit"><a href="#"><i class="fa fa-question-circle"></i> More details...</a></div>
            <div class="caption">
              <p><?php print t('Mifugo Maisha in Marsabit'); ?></p>
            </div>
          </div>
        </div>
        <div class="clearfix visible-sm"></div>
        <div class="col-md-3 col-sm-6">
          <div class="thumbnail">
            <img src="<?php print $images_path; ?>/ibli-on-the-ground-3.jpg" class="img-responsive" alt="...">
            <div class="visit"><a href="#"><i class="fa fa-question-circle"></i> More details...</a></div>
            <div class="caption">
              <p><?php print t('Index-Based Livestock Takaful in Borana'); ?></p>
            </div>
          </div>
        </div>
        <div class="col-md-3 col-sm-6">
          <div class="thumbnail">
            <img src="<?php print $images_path; ?>/ibli-on-the-ground-4.jpg" class="img-responsive" alt="...">
            <div class="visit"><a href="#"><i class="fa fa-question-circle"></i> More details...</a></div>
            <div class="caption">
              <p><?php print t('Mifugo Maisha in Isiolo'); ?></p>
            </div>
          </div>
        </div>
      </div>
      <!---------------------------------------------------------------------------------->


    </div>
  </div>
</div>
