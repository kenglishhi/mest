class Admin::BaseController < ApplicationController

  before_filter :admin_sub_nav
  private

  def admin_sub_nav
    @content_for_sub_nav = render_to_string(:partial => '/layouts/admin_sub_nav')
  end
end
