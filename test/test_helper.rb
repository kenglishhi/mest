ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'shoulda/rails'   # require 'shoulda' also worked
require 'factory_girl'
require "authlogic/test_case"
#require  File.dirname(__FILE__) + "/factories"
class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
class ActionController::TestCase
  setup :activate_authlogic
end

class FastaFile < ActiveRecord::Base
  has_attached_file :fasta, :path => ":rails_root/test/fixtures/files/:class/:attachment/:id/:basename.:extension"
end
class BlastResult < ActiveRecord::Base
  has_attached_file :output, :path => ":rails_root/test/fixtures/files/:class/:attachment/:id/:basename.:extension"
end
class Alignment < ActiveRecord::Base
  has_attached_file :aln, :path => ":rails_root/test/fixtures/files/:class/:attachment/:id/:basename.:extension"
end

class ActionController::TestCase
  def self.context_with_user_logged(&block)
    context "With an object" do
      setup do
        activate_authlogic
        @user  = users(:users_001) 
        UserSession.create(@user)
      end
      merge_block(&block) if block_given?
    end
  end
  def self.should_respond_with_extjs_json
    should_respond_with :success
    should "response with extjs json data " do
      resp_json = JSON.parse(@response.body)
      assert_not_nil resp_json['results'], "Result should not be nil"
      assert_not_nil resp_json['data'], "Data should not be nil"
      assert resp_json['data'].is_a?(Array), "Data should not be an array object"
    end
  end
end