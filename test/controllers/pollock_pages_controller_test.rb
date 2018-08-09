require 'test_helper'

class PollockPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:snorlax)
  end

  # test 'should not get pollock form if not signed in' do
  #   get pollock_new_path
  #   assert_redirected_to login_url
  # end

  # test "should get main Pollock page logged in as user" do
  #   log_in_as(@user)
  #   get pollock_new_path
  #   assert_response :success
  # end

end
