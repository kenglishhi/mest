class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    logger.error("[kenglish] user_session = #{params[:user_session].inspect} " )
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default root_path
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    session[:active_project_id] = nil
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end


end
