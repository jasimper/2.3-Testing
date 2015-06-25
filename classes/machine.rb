# The machine class provides the information on the actual ATM
class Machine
  attr_accessor :balance

  # Verify that the ATM contains sufficient money for the withdrawal
  def can_withdraw?(amount)
    amount.class == Fixnum && @balance >= amount && amount > 0
  end

  # Update the balance
  def deduct(amount)
    @balance -= amount
  end
# Closes class
end
