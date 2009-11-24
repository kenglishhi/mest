class  Workbench::AbstractControllerTest < ActionController::TestCase
  # Replace this with your real tests.
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
