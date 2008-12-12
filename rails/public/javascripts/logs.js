var LOG_MESSAGE_LIMIT = 100;
var LOG_CHECK_INTERVAL = 2;  // in seconds

function limit_log_messages() {
  $('#scrolling_logs tr:gt(' + LOG_MESSAGE_LIMIT + ')').remove();
}

window.setInterval(limit_log_messages, LOG_CHECK_INTERVAL * 1000);
