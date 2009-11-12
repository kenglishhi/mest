require 'test_helper'

class Tools::ExtractSequencesControllerTest < ActionController::TestCase

  context "test create generate fasta" do
    setup do
      u = users(:users_001)
      UserSession.create(u)
      @delayed_job_count =  Job.count
    end
    context "Empty Post for JSON" do
      setup do
        post :create, :format=> 'json'
      end
      should "fail on empty post to create with JSON" do
        assert_response :success
        assert_match /FAIL!/, @response.body
      end
    end
    context "Valid Post to HTML" do
      setup do
        post :create, :fasta_file_id =>  fasta_files(:fasta_files_006).id
      end
      should "Assert Should succeed on post to create with HTML" do
        assert_response :success
        assert_match /Queued to Extract/, @response.body
        assert_equal @delayed_job_count+1,Job.count
      end
    end
    context "Valid Post to JSON" do
      setup do
        post :create, :format=> 'json',
          :fasta_file_id =>  fasta_files(:fasta_files_006).id
      end
      should "Assert Should succeed on post to create with JSON" do
        assert_response :success
        assert_match /Data Saved/, @response.body
        assert_equal @delayed_job_count+1,Job.count
      end
    end
  end

end
