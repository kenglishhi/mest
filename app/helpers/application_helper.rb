# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include ExtJS::Helpers::Store
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

  def form_auth_token
    (protect_against_forgery?) ? form_authenticity_token : ''
  end

  def biodatabase_options
    Biodatabase.find(:all, :order => 'name' ).map { |ff| [ff.name, ff.id ] }
  end

end
