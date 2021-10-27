if ($('.pagination')) {
  $(window).scroll(function() {
    let url = $('.pagination .next_page a').attr('href');

    if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 700) {
      $('.pagination').html('<div class="loader" width="70" height="70"/>')
      $.getScript(url)
    }
  });
}