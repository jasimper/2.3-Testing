# The User class describes an account holder.
class User
  attr_accessor :name, :pin, :balance

  def initialize
    @name = ""
    @pin = ""
    @balance = 0
  end

  # Verify that the user can withdraw the requested amount
  def can_withdraw?(amount)
    amount.class == Fixnum && @balance >= amount && amount > 0
  end

  # Update the balance
  def deduct(amount)
    @balance -= amount
  end

# Closes class
end
