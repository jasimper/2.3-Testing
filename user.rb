# define class User

class User
  attr_accessor :username, :pin, :balance, :first, :last, :phone

  def initialize(username, pin, balance=0, first='', last='', phone='')
    @username = username
    @pin = pin
    @balance = balance
    @first = first
    @last = last

  end

  def full_name
    full = self.last.class != String || self.last == '' ? self.first : [self.first, self.last].join(' ')
    self.first == '' || self.first.class != String ? self.username : full
  end

  def check_balance(op, amount)
    @balance.send(op, amount)
  end

  def update_balance(op, amount)
    @balance = @balance.send(op, amount)
  end

end
