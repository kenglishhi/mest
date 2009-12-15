# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable

  helper :all # include all helpers, all the time
  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation
  protect_from_forgery # :secret => '8447460760525a05bf14b9942b939c70'

  before_filter :require_user
  before_filter :check_for_session_data


  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end
  def clear_stored_location
    session[:return_to] = nil
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def database_sub_nav
    if request.format.html?
      @content_for_sub_nav = render_to_string(:partial => '/layouts/database_sub_nav')
    end
  end
  def get_page(paginated_class)
    params[:start].blank? ? 1 : ((params[:start].to_i/paginated_class.per_page) + 1)
  end
  def project_conditions
    ['project_id = ? ', current_user.active_project.id]
  end
  def check_for_session_data

    @project_options =  Project.workbench_project_options
    return if (current_user.nil? || session[:active_project_id].blank? )
    current_user.active_project = Project.find(session[:active_project_id])
  end
  def change_active_project(project)
    session[:active_project_id] = project.id
  end



end
