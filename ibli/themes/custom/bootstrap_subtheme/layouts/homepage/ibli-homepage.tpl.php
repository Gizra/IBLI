
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
    </div>
  </div>
</div>
