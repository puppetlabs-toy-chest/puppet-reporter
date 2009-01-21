$(document).ready(function() {
  $("#search_form").submit(function() {
    var str = $("#search_form").serialize();
    $.get($("#search_form").attr('action'), str, function(data) {
      $('#search_results_container').html(data);
    });
    return false;
  });
});

$(document).ready(function() {
  $('div.pagination a').livequery('click', function(event) {
    $('#search_results_container').load(this.href);
    return false;
  });
});
