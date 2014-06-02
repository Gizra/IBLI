
<div class="panel-display panel-ibli-homepage clearfix" <?php if (!empty($css_id)) { print 'id="' . $css_id . '"'; } ?>>

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
            <span class="title">Recent Works</span><span class="decoration"></span><span class="decoration"></span><span class="decoration"></span>
          </h2>
        </div>
      </div>
      <div class="row">
        <div class="col-md-3 col-sm-6">
          <div class="thumbnail">
            <img src="<?php print $images_path; ?>/works1.jpg" class="img-responsive" alt="...">
            <div class="visit"><a href="#"><i class="fa fa-question-circle"></i> More details...</a></div>
            <div class="caption">
              <h4>Project #1</h4>
              <div class="rating">
                <i class="fa fa-star"></i>
                <i class="fa fa-star"></i>
                <i class="fa fa-star"></i>
                <i class="fa fa-star"></i>
                <i class="fa fa-star"></i>
              </div>
              <p>Cras justo odio, dapibus ac facilisis in, egestas eget quam.</p>
            </div>
          </div>
        </div>
        <div class="col-md-3 col-sm-6">
          <div class="thumbnail">
            <img src="<?php print $images_path; ?>/works2.jpg" class="img-responsive" alt="...">
            <div class="visit"><a href="#"><i class="fa fa-question-circle"></i> More details...</a></div>
            <div class="caption">
              <h4>Project #2</h4>
              <div class="rating">
                <i class="fa fa-star"></i>
                <i class="fa fa-star"></i>
                <i class="fa fa-star"></i>
                <i class="fa fa-star"></i>
              </div>
              <p>Cras justo odio, dapibus ac facilisis in, egestas eget quam.</p>
            </div>
          </div>
        </div>
        <div class="clearfix visible-sm"></div>
        <div class="col-md-3 col-sm-6">
          <div class="thumbnail">
            <img src="<?php print $images_path; ?>/works3.jpg" class="img-responsive" alt="...">
            <div class="visit"><a href="#"><i class="fa fa-question-circle"></i> More details...</a></div>
            <div class="caption">
              <h4>Project #3</h4>
              <div class="rating">
                <i class="fa fa-star"></i>
                <i class="fa fa-star"></i>
                <i class="fa fa-star"></i>
                <i class="fa fa-star"></i>
                <i class="fa fa-star-half"></i>
              </div>
              <p>Cras justo odio, dapibus ac facilisis in, egestas eget quam.</p>
            </div>
          </div>
        </div>
        <div class="col-md-3 col-sm-6">
          <div class="thumbnail">
            <img src="<?php print $images_path; ?>/works4.jpg" class="img-responsive" alt="...">
            <div class="visit"><a href="#"><i class="fa fa-question-circle"></i> More details...</a></div>
            <div class="caption">
              <h4>Project #4</h4>
              <div class="rating">
                <i class="fa fa-star"></i>
                <i class="fa fa-star"></i>
                <i class="fa fa-star"></i>
                <i class="fa fa-star"></i>
                <i class="fa fa-star"></i>
              </div>
              <p>Cras justo odio, dapibus ac facilisis in, egestas eget quam.</p>
            </div>
          </div>
        </div>
      </div>
      <!---------------------------------------------------------------------------------->


    </div>
  </div>
</div>
