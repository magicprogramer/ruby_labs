module Logger
    def write(msg)
      File.open("log.log", "a") do |file|
        file.puts(msg)
      end
    end
  
    def log_info(message)
      write("#{Time.now}: INFO: #{message}")
    end
  
    def log_error(message)
      write("#{Time.now}: ERROR: #{message}")
    end
  
    def log_warning(message)
      write("#{Time.now}: WARNING: #{message}")
    end
  end
  
  class User
    attr_accessor :name, :balance
    def initialize(name, balance)
      @name = name
      @balance = balance
    end
  end
  
  class Transaction
    attr_reader :value, :user
    def initialize(user, value)
      @user = user
      @value = value
    end
  end
  
  class Bank
  include Logger
    def initialize
        #log_error("Cannot create an object") if instance_of?(Bank)
      raise "Cannot create an object" if instance_of?(Bank)
    end
    def process_transaction(transactions)
        # log_error("abstract method called") if instance_of?(Bank)
      raise "abstract method called" #if instance_of?(Bank)
    end
  end
  
  class CBABank < Bank
    include Logger
  
    def initialize(users)
      @users = users
    end
  
    def process_transaction(transactions)
      logs = transactions.map do |transaction|
        "Processing transaction of value #{transaction.value} for user #{transaction.user.name}"
      end.join(', ')
      log_info(logs)
  
      transactions.each do |transaction|
        user = @users.find { |u| u.name == transaction.user.name }
        success = false
        msg = ""
        if user.nil?
          log_error("User #{transaction.user.name} not found in bank")
          msg = "User #{transaction.user.name} not found in bank"
        elsif user.balance <= 0
          log_warning("#{user.name} has a balance = 0")
          msg = "#{user.name} has a balance = 0"
        elsif user.balance < -transaction.value
          log_error("#{user.name} has insufficient funds")
          msg = "#{user.name} has insufficient funds"
        else
          user.balance += transaction.value
          success = true
          log_info("Transaction of value #{transaction.value} for user #{transaction.user.name} processed successfully")
          msg = "Transaction of value #{transaction.value} for user #{transaction.user.name} processed successfully"
        end
        yield(success ? :success : :failure, transaction, msg) #"end point of success " + msg : "end point of failure " + msg) if block_given?

        end
    end
  end
  users = [
    User.new("Ali", 200),
    User.new("Peter", 500),
    User.new("Manda", 100)
  ]
  
  outside_users = [
    User.new("Menna", 400)
  ]
  
  transactions = [
    Transaction.new(users[0], -20),
    Transaction.new(users[0], -30),
    Transaction.new(users[0], -50),
    Transaction.new(users[0], -100),
    Transaction.new(users[0], -100),
    Transaction.new(outside_users[0], -100)
  ]
  
  bank = CBABank.new(users)
  bank.process_transaction(transactions) do |status, transaction, message|
    if status == :success
      puts "end point of successs: #{transaction.user.name} - #{message}"
    else
      puts "end point of failure: #{transaction.user.name} - #{message}"
    end
  end
  