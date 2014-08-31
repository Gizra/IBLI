// Handle toggling "colgroups" in the premium rates table.
(function($) {

  $(document).ready(function() {
    $('.toggle-hideable a').click(function (event) {
      event.preventDefault();

      // Hide all hideable values.
      $('.hideable span').addClass('hidden');
      $('.toggle-hideable').removeClass('active');
      // Show
      var groupId = $(event.currentTarget).data('group-id');
      $('.hideable.group-' + groupId + ' span').removeClass('hidden');
      $('.toggle-hideable.group-' + groupId).addClass('active');
    });

  });

})( jQuery );
