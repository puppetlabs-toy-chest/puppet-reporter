$(document).ready(function() {
    $("#search_form").submit(function() {
        var str = $("#search_form").serialize();
        $.ajax({
            type: "GET",
            url: $("#search_form").attr('action'),
            data: str,
            success: function(msg) {
                $("#search_results_container").ajaxComplete(function(event, request, settings) {
                    $(this).html(msg);
                });
            }
        });
        return false;
    });
});

$(document).ready(function() {
    $('div.pagination a').livequery('click', function(event) {
        $('#search_results_container').load(this.href);
        return false;
    })
})
