class UsersController < ApplicationController
#  before_filter :store_location, :only => [:index]
 def index
    @users = User.find(:all)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.save do |result|
      if result
        flash[:notice] = "Account registered!"
        add_lockdown_session_values
        if params[:action_todo]
          redirect_to params[:action_todo]
        else
          redirect_back_or_default(account_url)
        end
      else
        render :action => :new
      end
    end
  end

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  def destroy
    if current_user_is_admin?
      user = User.find(params[:id])
      user.destroy
      flash[:notice] = "User #{user.login} deleted!"
    end

    redirect_to root_path
  end
#  def index
#  end
#  def edit
#    @user = @current_user
#  end
#
#  def update
#    @user = User.update(params[:id],params[:user]  )
#    if @user.valid?
#      redirect_back_or_default users_path
#    else
#      render :action => 'edit'
#    end
#  end
end
