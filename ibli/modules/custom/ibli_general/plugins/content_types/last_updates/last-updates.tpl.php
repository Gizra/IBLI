<div class="block-header">
  <h2>
    <span class="title"><?php print t('LATEST IBLI UPDATES') ?></span><span class="decoration"></span><span class="decoration"></span><span class="decoration"></span>
  </h2>
</div>
<ul class="nav nav-tabs">
  <li class="active"><a href="#partners" data-toggle="tab"><?php print t('Partners'); ?></a></li>
  <li><a href="#events" data-toggle="tab"><?php print t('Events'); ?></a></li>
  <li><a href="#news" data-toggle="tab"><?php print t('News'); ?></a></li>
</ul>
<div class="tab-content">
  <div class="tab-pane active" id="partners">
    <div class="media">
      <a class="pull-left" href="#">
        <img class="media-object" src="<?php print variable_get('ibli_images_path'); ?>/eu.png" alt="Blog Message" />
      </a>
    </div>
    <div class="media">
      <a class="pull-left" href="#">
        <img class="media-object" src="<?php print variable_get('ibli_images_path'); ?>/uk.png" alt="Blog Message" />
      </a>
    </div>
    <div class="media">
      <a class="pull-left" href="#">
        <img class="media-object" src="<?php print variable_get('ibli_images_path'); ?>/aid.png" alt="Blog Message" />
      </a>
    </div>
    <div class="media">
      <a class="pull-left" href="#">
        <img class="media-object" src="<?php print variable_get('ibli_images_path'); ?>/takaful.png" alt="Blog Message" />
      </a>
    </div>
    <div class="media">
      <a class="pull-left" href="#">
        <img class="media-object" src="<?php print variable_get('ibli_images_path'); ?>/mercycorps.png" alt="Blog Message" />
      </a>
    </div>
  </div>
  <div class="tab-pane" id="events">
    <iframe src="https://www.google.com/calendar/embed?showTitle=0&amp;showNav=0&amp;showDate=0&amp;showPrint=0&amp;showTabs=0&amp;showCalendars=0&amp;mode=AGENDA&amp;height=360&amp;wkst=1&amp;bgcolor=%23FFFFFF&amp;ctz=Africa%2FNairobi" style=" border-width:0 " width="360" height="360" frameborder="0" scrolling="no"></iframe>
  </div>
  <div class="tab-pane" id="news">
    <div class="media">
      <a class="pull-left" href="#">
        <img class="media-object" src="<?php print variable_get('ibli_images_path'); ?>/face1.jpg" alt="Blog Message" />
      </a>
      <div class="media-body">
        <a href="#">Alex Smith</a> <span class="text-muted">20 minutes ago</span>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam id ipsum varius...</p>
      </div>
    </div>
    <div class="media">
      <a class="pull-left" href="#">
        <img class="media-object" src="<?php print variable_get('ibli_images_path'); ?>/face2.jpg" alt="Blog Message" />
      </a>
      <div class="media-body">
        <a href="#">Dan Smith</a> <span class="text-muted">1 hour ago</span>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam id ipsum varius...</p>
      </div>
    </div>
    <div class="media">
      <a class="pull-left" href="#">
        <img class="media-object" src="<?php print variable_get('ibli_images_path'); ?>/face3.jpg" alt="Blog Message" />
      </a>
      <div class="media-body">
        <a href="#">David Smith</a> <span class="text-muted">11/10/2013</span>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam id ipsum varius...</p>
      </div>
    </div>
  </div>
</div>
