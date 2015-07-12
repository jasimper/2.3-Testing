require 'minitest/autorun'

require_relative './user.rb'
require_relative './assignment.rb'

class TestUser < Minitest::Test
  def setup
    @user = User.new("test_username", "test_pin", 500)
  end


  def test_full_name_works
    @user.first = "test_first"
    @user.last = "test_last"
    assert_equal "test_first test_last", @user.full_name
  end

  def test_full_name_without_last
    @user.first = "test_first"
    @user.last = ""
    assert_equal "test_first", @user.full_name
  end

  def test_full_name_without_last
    @user.first = ""
    @user.last = "test_last"
    assert_equal "test_username", @user.full_name
  end

  def test_full_name_without_first_or_last
    @user.first = ""
    @user.last = ""
    assert_equal "test_username", @user.full_name
  end

  def test_check_balace
    assert_equal 500, @user.balance
  end

  def test_update_balance
    @user.update_balance(:-, 300)
    assert_equal 200, @user.balance
  end

  # program tests
  # =============

  def test_prompt_user
    skip()
  end

  def test_no_empty_input
    skip()
  end

  def test_fetch_user
    # accounts_array = [{username: "test_username", pin: 1234}, {username: "test_user2", pin: 3456}]
    # assert_equal "test_username" "1234", true
    skip()
  end

  def test_get_requested_amount_pos
    skip()
  end

  def test_get_requested_amount_neg
    skip()
  end

  def test_action_selection
    skip()
  end
end
