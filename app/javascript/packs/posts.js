if ($('.pagination')) {
  $(window).scroll(function() {
    url = $('.pagination .next_page a').attr('href');

    if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 150) {
      $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
      $.getScript(url)
    }
  });
}
