// Handle toggling "colgroups" in the premium rates table.
(function($) {

  $(document).ready(function() {
    $("a.toggle-hideable").click(function (event) {
      event.preventDefault();
      var table = $(event.currentTarget).parents('table');
      // Hide all hideable values.
      table.find('.hideable span').addClass('hidden');
      // Show
      table.find('.hideable.group-' + $(event.currentTarget).data('group-id') + ' span').removeClass('hidden');
    });

  });

})( jQuery );
