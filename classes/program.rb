#*****************************************************************************#
# 1.4 ATM with classses
# 2015-06-18 homework for The Iron Yard

# Required modules
require 'csv'

# Required files
require_relative 'user'
require_relative 'machine'

#*****************************************************************************#


# The program class provides the actual functionality of the program.
class Program
  MAIN_MENU = ['1: Login to your account', '2: View ATM balance', '3: Exit program'].freeze
  ACC_MENU = ['1: Check balance', '2: Make withdrawal', '3: Log out of your account'].freeze

 def initialize(machine)
    @atm = machine
    @account_holders = []
    @user = nil
    @show_acc_menu = false
    @exit_prog = false
    @data_file = './user-data/users.csv'

    # Create the array of user classes by parsing the supplied data file
    parse_data_file(@data_file)
  end

  # This is the main loop that is called to run the program.
  def run
    # Display a greeting message with the main menu.
    puts "Welcome to ATM #8675309"
    puts "What would you like to do?"
    puts ""

    # Display the main menu and get the users input
    main_menu_sel = get_menu_selection(MAIN_MENU)

    # Depending on the user's input, perform the correct function
    case main_menu_sel
    # Main Menu option 1 is to log in to the user's account.
    when 1
      # First, this is a new login, so we need to reset some program defaults
      @show_acc_menu = false
      @user = nil

      # OK, lets get the user's login information
      # This will return a hash with the user's name and pin
      login = get_login_info()

      # Next, let's try to verify that information and determine our course of action.
      @user = get_user(login)

      # Only display the account menu if the user is valid.
      while @show_acc_menu
        # Run the account menu
        show_acc_menu()
      end

    # Main Menu option 2 is to view the ATM's available balance.
    when 2
      # This code should view the atm's current balance
      puts "This ATM currently has $#{@atm.balance}"
      puts ""

    # Main Menu option 3 is to exit the ATM program.
    when 3
      # The user would like to exit the program entirely.
      @exit_prog = true
      puts "Now exiting the ATM program. Goobye."
      puts ""

    # This else should be theoretically impossible.
    else
      display_error()
    end
  end

  # We need to access @exit_prog's value outside of the class. Let's make a getter
  def exit_prog
    @exit_prog
  end

  # This method displays input prompt and returns the value input as a string.
  # Loops until input is given.
  def get_input(prompt)
    var = ""
    while var == ""
      puts "#{prompt}"
      print ">> "
      var = gets.chomp
      puts ""
    end

    var

  end

  # Gathers the user's login and pin information
  def get_login_info
    name = get_input("Please enter your name")
    pin = get_input("Please enter your pin")
    login = { name: name, pin: pin}

   login

  end

  # This method displays a menu and verifies that the
  # input collected and returned is a valid option.
  # Menu must be an array with options starting at 1.
  def get_menu_selection(menu)
    men_sel = 0
    until (1..menu.count).include?(men_sel)
      men_sel = get_input(menu.join("\n")).to_i
      unless (1..menu.count).include?(men_sel)
        puts "Invalid entry. Try again."
        puts ""
      end
    end

    men_sel

  end

  # This method takes login info and searches the "database" for a valid
  # user id and pin to match. If no match is found, valid user is left false.
  def get_user(login)
    match_found = false
    @account_holders.each do |user|
      if user.name == login[:name] && user.pin == login[:pin]
        @show_acc_menu = true
        match_found = true
        puts "Your account has been verified."
        puts ""
        return user
      end
    end
    unless match_found
      puts "Something went wrong. Please start over."
      puts ""
    end
  end

  def display_error
    puts "Something has gone horribly wrong. This machine"
    puts "is now set to self detonate. You should run."
    puts ""
  end

  # This method is responsible for operating the Account Holder's menu
  def show_acc_menu
    # Now display the account menu and get the user's input
    acc_menu_sel = get_menu_selection(ACC_MENU)

    # Depending on the user's input, perform the correct function
    case acc_menu_sel
    # Account Menu option 1 indicates the user wants to check their balance.
    when 1
      puts "Your current account balance is: $#{@user.balance}"
      puts ""
    # Account Menu option 2 indicates the user would like to withdraw funds
    when 2
      # Make a withdrawal
      withdraw_funds()
    # Account Menu option 3 indicates the user would like to log out
    when 3
      @show_acc_menu = false
      puts "Returning to the Main Menu."
      puts ""
    # If menu options 1-3 have failed, the world might end. Display an error
    else
      display_error()
    end
  end

  # This method handles the withdrawing funds logic.
  def withdraw_funds
    # Ask the user how much they would like to withdraw from their account
    amount = get_input("How much would you like to withdraw?").to_i
    # Let's make sure the account and the ATM can handle this transaction
    user_can_withdraw = @user.can_withdraw?(amount)
    atm_can_withdraw = @atm.can_withdraw?(amount)
    if user_can_withdraw && atm_can_withdraw
      # Passed that check. Now update account amounts in memory and on file...
      @user.deduct(amount)
      @atm.deduct(amount)
      update_data_file(@data_file)
      # ... and dispense the monies.
      puts "Sure thing. Dispensing cash below..."
      puts ""
      puts "Your new balance is $#{@user.balance}"
      puts ""
    elsif amount <= 0
      puts "You can not withdraw a negative amount."
      puts ""
    elsif !user_can_withdraw
      puts "You have asked to withdraw more than you have in your account"
      puts ""
    elsif !atm_can_withdraw
      puts "ATM has insufficient balance to fulfill this request."
      puts ""
    else
      display_error()
    end
  end

  # This method handles parsing the users.csv file that serves as our database table.
  def parse_data_file(file_name)
    CSV.foreach(file_name, headers: true) do |row|
      user = User.new
      user.name = row["Name"]
      user.pin = row["Pin"]
      user.balance = row["Balance"].to_i
      @account_holders.push(user)
    end
    @account_holders
  end

  # This method handles updating our user data file after a transaction to ensure the
  # file contains the most up to date information.
  def update_data_file(file_name)
    header = ["Name", "Pin", "Balance"]
    CSV.open(file_name, "wb") do |csv|
      csv << header
      @account_holders.each do |user|
        data = [user.name, user.pin, user.balance]
        csv << data
      end
    end
  end

  def chomp
    var = gets.chomp
    return var
  end

# Closes the class
end
