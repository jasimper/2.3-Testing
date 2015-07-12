'''
Create a little ATM

***************
TO DO
* create new user
  * create instance of new user
  * prompt for username
  * verify username is not empty
  * check if username is unique
  * store new username
  * prompt for pin
  * verify pin is not empty
  * store new pin
  * prompt for initial deposit?
'''

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Required stuffs

require './user.rb'
require 'csv'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Define ATM characteristics
atm_balance = 250000
atm_fee = 3
transaction_opt = [
  '  1: Check my available balance',
  '  2: Withdraw funds',
  '  3: Make a deposit',
  '  4: Cancel transaction'
  ]
deposit_opt = [
  '  1: Cash',
  '  2: Check',
  '  3: Bullion'
]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Parse CSV and store data
accounts = []
CSV.foreach("users.csv", headers: true) do |row|
  user = User.new(row["Name"],row["Pin"],row["Balance"].to_i)
  accounts.push(user)
end

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Define methods

# Generic user prompt
def prompt_user(message)
  puts message
  print ">> "
  gets.chomp
end

# Continue prompting user if input is empty, offer error msg if provided
def no_empty_inputs(text, err=nil)
  input_text = prompt_user(text)
  err ||= text
  input_text = prompt_user(err) while input_text.empty?
  input_text
end

# Grab account details given user input
def fetch_user(accounts_array, user, pin)
  temp = nil
  accounts_array.each do |account|
    if account.username == user && account.pin == pin
      temp = account
    end
  end
  return temp
end

# Prevent user from faux-depositing by withdrawing negative (or vice-versa).
# Also, no withdrawing/depositing $0. That'd be silly.
def get_requested_amount(type)
  request = prompt_user("How much would you like to #{type}?").to_i
  while request <= 0
    request = prompt_user("Please enter an amount greater than $0.").to_i
  end
  request.to_i
end

# Present list of available actions
def select_action(message, options)
  selection = nil
  until (1..options.length).include?(selection)
    selection = no_empty_inputs(message + "\n#{options.join("\n")}").to_i
  end
  return selection
end

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Do the ATM things

# Request user input
name_entered = no_empty_inputs(
  "Enter the name on your account:",
  "Your account is not sans nom, so try again."
  ).capitalize
pin_entered = no_empty_inputs(
  "Enter your pin:",
  "That is a terrible pin. We would never let you have such a terrible pin. Try again."
  )
current_user = fetch_user(accounts, name_entered, pin_entered)

# Present and execute available tasks
if current_user
  puts "\n Welcome back, #{(current_user.full_name)}!"
  transaction_type = select_action(" What action would you like to perform?", transaction_opt)

    case transaction_type
    # Display user's current available balance
    when 1 then puts "Your current balance is $#{current_user.balance}."

    # Prompt for a (valid) withdrawal amount
    # Verify available funds, update atm & user balances, dispense $$$
    when 2
      to_withdraw = get_requested_amount("withdraw")
      if current_user.check_balance(:-, (to_withdraw + atm_fee)) >= 0
        if atm_balance - to_withdraw >= 0
          atm_balance -= to_withdraw
          current_user.update_balance(:-, (to_withdraw + atm_fee))
          puts %{
            Please collect your cash. We charged you a $3 fee, bummer.
            Your new balance is $#{current_user.balance}.}
        else
          puts %{
            Uh oh.... We don't have that much cash right now.
            Sorry, try again tomorrow!}
        end
      else
        puts %{
          Well, this is embarassing. You don't seem to have enough
          funds in your account to complete this transaction (including our
          ridiculous fee). Sorry!}
      end

    # Prompt for a (valid) deposit amount, update atm & user balances
    when 3
      deposit_type = select_action(" What type of deposit would you like to make?", deposit_opt)
      to_deposit = get_requested_amount("deposit")
      atm_balance += to_deposit if deposit_type == 1
      current_user.update_balance(:+, to_deposit)
      puts "Your deposit has been accepted.\nYour new balance is $#{current_user.balance}."

    # Cancel the transaction
    when 4 then puts "Thank you and please come again."
    end

  #Rewrite users.csv with current available balances for all users
  update_file = File.open("./users.csv", "w")
  update_file << "Name,Pin,Balance\n"
  accounts.each do |item|
    update_file << "#{item.username},#{item.pin},#{item.balance}\n"
  end
  update_file.close

else
  # User account does not exist or credentials were mistyped
  puts "Your username and PIN do not match our records, so no moneys for you. Goodbye!"
end
