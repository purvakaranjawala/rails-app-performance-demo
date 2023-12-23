require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  def setup
    @user = User.new(username: "user1")
  end
  
  test "user should be valid" do
    assert @user.valid?
  end

  test "username should not be blank" do
    @user.username = ""
    assert_not @user.valid?
  end
end
