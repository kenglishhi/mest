# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def cancel_button(options=nil)
    if !options
      url=url_for(:action=>'index')
    else
      url=url_for options
    end
    "<input type=\"button\" value=\"Cancel\" onclick=\"document.location='#{url}';\" />"
  end


  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, html_escape(flash[msg.to_sym]), :id => "flash-#{msg}") unless flash[msg.to_sym].blank?
    end
    messages
  end
  def logged_in?
    current_user
  end


end
