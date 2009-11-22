require 'test_helper'

module AsControllerTestHelper
  # Replace this with your real tests.
  def test_index 
    get :index
    assert_response :success
  end
end
