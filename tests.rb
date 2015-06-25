require 'minitest/autorun'
require './classes/program.rb'
require './classes/user.rb'
require './classes/machine.rb'

class TestUser < MiniTest::Unit::TestCase
  def setup
    @user = User.new
    @user.balance = 200
    @amount = 50
  end

  def test_can_user_withdraw
    assert_equal true, @user.can_withdraw?(@amount)
  end
   def test_has_enough_money
     assert_equal true, @user.balance >= @amount
   end
   def test_amount_more_than_zero
     amount = 0
     assert_equal false, @user.can_withdraw?(amount)
   end
   def test_amount_equals_fixnum
     amount = ""
     assert_equal false, @user.can_withdraw?(amount)
   end
  def test_deduct_works
    assert_equal (@user.balance - @amount), @user.deduct(@amount)
  end
end

class TestMachine < MiniTest::Unit::TestCase
  def setup
    @machine = Machine.new
    @machine.balance = 200
    @amount = 50
  end

  def test_can_user_withdraw
    assert_equal true, @machine.can_withdraw?(@amount)
  end
   def test_has_enough_money
     assert_equal true, @machine.balance >= @amount
   end
   def test_amount_more_than_zero
     amount = 0
     assert_equal false, @machine.can_withdraw?(amount)
   end
   def test_amount_equals_fixnum
     amount = ""
     assert_equal false, @machine.can_withdraw?(amount)
   end
  def test_deduct_works
    assert_equal (@machine.balance - @amount), @machine.deduct(@amount)
    #new_balance == @balance - amount
  end
end

class TestProgram < MiniTest::Unit::TestCase
  def setup do
    atm = Machine.new
    atm.balance = 100000
    @p = Program.new
  end

  def test_login_name
    login = {}
    @p.stub(:chomp, "Jamie") do
      login = @p.get_login_info
    end
    assert_equal "Jamie", login[:name]
    assert_equal "Jamie", login[:pin]
    end
  # def test_get_input
  #     assert_equal "hi", TestDef.stub(:gets, -> {"hi"})
  # end
  def test_withdraw_works
    var = @
end
