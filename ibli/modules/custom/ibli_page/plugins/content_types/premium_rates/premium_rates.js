// Handle toggling "colgroups" in the premium rates table.
(function($) {

  $(document).ready(function() {
    $('.toggle-hideable a').click(function (event) {
      event.preventDefault();

      var groupId = $(event.currentTarget).data('group-id');
      if ( $('.toggle-hideable.group-' + groupId).hasClass('active') ) {
        // Hide
        $('.hideable.group-' + groupId + ' span').addClass('hidden');
        $('.toggle-hideable.group-' + groupId).removeClass('active');
      }
      else {
        // Show
        $('.hideable.group-' + groupId + ' span').removeClass('hidden');
        $('.toggle-hideable.group-' + groupId).addClass('active');
      }
    });

  });

})( jQuery );
