require 'test_helper'
require File.dirname(__FILE__) + '/as_controller_test_helper.rb'

class FastaFilesControllerTest < ActionController::TestCase
  include AsControllerTestHelper
  def setup
    activate_authlogic
    @user = UserSession.create(users(:users_001))
  end

  context "Test New and upload" do
    setup do
      activate_authlogic
      @user = users(:users_001)
      UserSession.create(@user)
    end
    context "test new" do
      setup do

        get :new
      end
      should_respond_with :success
    end
    context "test create" do
      setup do
        fdata = fixture_file_upload('files/EST_Clade_A_5.fasta', 'text/plain')
        @old_fasta_file_count = FastaFile.count
        post :create, :project_id => @user.active_project.id, :fasta_files => [{ :uploaded_data => fdata }], :html => { :multipart => true }

      end
      should_respond_with :redirect
      should "Increase fasta file count" do
        assert_equal @old_fasta_file_count + 1, FastaFile.count, "need more one more fasta file"
      end
    end
  end
end
