class Workbench::AlignmentsController < ApplicationController
  include ExtJS::Controller
  protect_from_forgery :except => :destroy
end
