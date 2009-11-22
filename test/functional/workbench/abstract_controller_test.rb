class  Workbench::AbstractControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def should_return_restful_json
    assert_response :success
    resp_json = JSON.parse(@response.body)
    assert_not_nil resp_json['data'], "Data should not be nil"
    assert resp_json['data'].is_a?(Array), "Data should not be an array object"
  end
end
