require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_select '.entry', 3
    assert_select 'h3', 'Java Programming'
    assert_select '.price', /\$[,\d]+\.\d\d/
  end

end
