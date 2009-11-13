class UsersController < ApplicationController
  before_filter :store_location, :only => [:index]
  def index
  end
  def edit
    @user = @current_user
  end

  def update
    @user = User.update(params[:id],params[:user]  )
    if @user.valid?
      redirect_back_or_default users_path
    else
      render :action => 'edit'
    end
  end
end
