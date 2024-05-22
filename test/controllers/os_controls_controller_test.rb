require "test_helper"

class OsControlsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get os_controls_show_url
    assert_response :success
  end

  test "should get generate" do
    get os_controls_generate_url
    assert_response :success
  end
end
