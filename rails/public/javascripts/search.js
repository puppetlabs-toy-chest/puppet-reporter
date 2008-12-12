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
