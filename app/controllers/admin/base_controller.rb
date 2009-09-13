class Admin::BaseController < ApplicationController
  before_filter :generate_sub_nav
  private

  def generate_sub_nav
   @content_for_sub_nav = render_to_string(:partial => 'admin/base/admin_sub_nav')
  end
end
