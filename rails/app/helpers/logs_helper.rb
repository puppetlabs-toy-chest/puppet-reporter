module LogsHelper
  def display_log_message(msg)
    if msg.size < 100
      "<div>#{msg}</div>"
    else
      <<-HTML
      <div class="brief_msg">#{truncate(msg, 100)}</div>
      <div class="full_msg" style="display:none;">#{msg}</div>
      #{link_to_function('show more', 'toggle_log_message(this)')}
      HTML
    end
  end
end
