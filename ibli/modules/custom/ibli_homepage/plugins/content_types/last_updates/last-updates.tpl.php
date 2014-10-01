<div class="block-header">
  <h2>
    <span class="title"><?php print t('LATEST IBLI UPDATES') ?></span><span class="decoration"></span><span class="decoration"></span><span class="decoration"></span>
  </h2>
</div>
<ul class="nav nav-tabs">
  <li class="active"><a href="#news" data-toggle="tab"><?php print t('News'); ?></a></li>
  <li><a href="#events" data-toggle="tab"><?php print t('Events'); ?></a></li>
</ul>
<div class="tab-content">
  <div class="tab-pane" id="events">
    <iframe src="https://www.google.com/calendar/embed?src=iblikenyaethiopia%40gmail.com&showTitle=0&amp;showNav=0&amp;showDate=0&amp;showPrint=0&amp;showTabs=0&amp;showCalendars=0&amp;mode=AGENDA&amp;height=300&amp;wkst=1&amp;bgcolor=%23FFFFFF&amp;ctz=Africa%2FNairobi" style=" border-width:0 " width="360" height="300" frameborder="0" scrolling="no"></iframe>
  </div>
  <div class="tab-pane  active" id="news">
    <?php print ibli_news_get_news(); ?>
  </div>
</div>
