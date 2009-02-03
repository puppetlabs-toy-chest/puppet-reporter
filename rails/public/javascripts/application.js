// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function toggle_log_message(link) {
	$(link).siblings("div[class$='_msg']").toggle();
	$(link).text( ($(link).text() == 'show more') ? 'show less' : 'show more' );
}
