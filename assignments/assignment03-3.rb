#!/usr/bin/env ruby
require "date"
require "csv"


class BankAccount
  attr_reader :start_balance, :end_balance, :transactions, :name, :number, :type
  attr_reader :deposit_total, :withdrawal_total
  
  def initialize(name, number, type, balance = 0.00)
    @start_balance = balance
    @end_balance = balance
    @name = name
    @number = number
    @type = type
    @deposit_total = 0.00
    @withdrawal_total = 0.00
  end
  
  def load_transactions(file)
    @transactions = Array.new
    # load transactions and create array
      contents = CSV.new(File.read(file))
      records = contents.to_a
      records.shift # dump the header row    records.each do |record|
      records.each do |record|
      date, payee, amount, type = record
      if type =~ /withdrawal/i
        transaction = Withdrawal.new(date,payee,amount)
      elsif type =~ /deposit/i
        transaction =  Deposit.new(date,payee,amount)
      else
        break
      end
      transactions.push transaction
    end
      
    # sort the transactions by date
    transactions.sort_by! {|item| Date.strptime(item.date,"%m/%d/%Y")}
    
    # calculate end balance
    @withdrawal_total = self.withdrawals.inject(0) { |sum,w | sum += w.amount  }
    @deposit_total = self.deposits.inject(0) {|sum, d| sum += d.amount }
    @end_balance = @deposit_total + @withdrawal_total
  end
  
  def withdrawals
    transactions.select {|transaction| transaction.type == "withdrawal"}
  end
  
  def deposits
    transactions.select {|transaction| transaction.type == "deposit"}
  end
  
  def daily_transactions(date)
    dt = 0.0
    d_date = deposits.select {|deposit| deposit.date == date}.map {|d| d.amount}
    w_date = withdrawals.select {|withdrawal| withdrawal.date == date}.map {|w| w.amount}
    d_total = d_date.reduce {|amt,acc| acc + amt}
    w_total = w_date.reduce {|amt,acc| acc + amt}
    dt += d_total.round(2) unless d_total == nil
    dt -= w_total.round(2) unless w_total == nil
    dt
  end

  def daily_balances
    db = {}
    bal = 0.0
    transaction_dates = transactions.map {|t| t.date}.uniq
    transaction_dates.each do |date|
      bal += self.daily_transactions(date)
      db[date] = sprintf("%.2f",bal)
    end
    db
  end
  
  def to_s
    summary  = "Balance: #{balance}\n"
    summary << "Account Name: #{account_name}\n"
    summary << "Account Number: #{account_number}\n"
    summary << "Account Type: #{account_type}\n"
    transactions.each {|t| summary << t.to_s << "\n"}
    summary
  end
  
  def each_t
    transactions.each {|t| t}
  end
end

class Transaction
  attr :date, :amount, :payee, :type
  
  def initialize(date, payee, amount, type)
    @date = date
    @payee = payee
    @amount = amount.to_f
    @type = type
  end
  
  def to_s
    "Transaction Date: #{date}, Transaction Amount: #{amount}, Transaction Payee: #{payee}, Transaction Type: #{type}"
  end  
end

class Withdrawal < Transaction
  def initialize(date,payee, amount)
    super(date,payee,amount,"withdrawal")
  end
end

class Deposit < Transaction
  def initialize(date,payee,amount)
    super(date,payee,amount,"deposit")
  end  
end

def render_html(account)
<<HTML
  <!doctype html>
  <html>
  #{render_html_head account.name}
  #{render_html_body account}
  </html>
HTML
end

def render_html_head(title)
<<HEAD
  <head>
  <title>#{title}</title>
  </head>
HEAD
end

def render_html_body(account)
<<BODY
  <body>
  <h1>Account Name: #{account.name} Account Number: #{account.number} Account Type: #{account.type}</h1>
  #{render_html_summary account}
  #{render_html_transactions "Deposits", account.deposits }
  #{render_html_transactions "Withdrawals", account.withdrawals }
  #{render_html_balances account.daily_balances}
  </body>
BODY
end

def render_html_summary(account)
<<SUMMARY
<p>
<table border="1">
  <tr>
    <th align="left" colspan="4">Summary</th>
  </tr>
  <tr>
    <td>Starting Balance:</td><td>#{account.start_balance}</td>
    <td>Ending Balance:</td><td>#{account.end_balance}</td>
  </tr>
  <tr>
    <td>Total Deposits:</td><td>#{account.deposit_total}</td>
    <td>Total Withdrawls:</td><td>#{account.withdrawal_total}</td>
  </tr>
</table>
</p>
SUMMARY
end

def render_html_transactions(title,trans)
<<TRANS
<p>
<table border="1">
  <th align="left" colspan="3">#{title}</th>
  <tr>
  <th>Date</th>
  <th>Amount</th>
  <th>Payee</th>
  </tr>
  #{trans.map {|t| render_html_transaction t}.join "\n"}
</table>
</p>
TRANS
end

def render_html_transaction(t)
<<RECORD
  <tr>
  <td>#{t.date}</td>
  <td>#{t.amount}</td>
  <td>#{t.payee}</td>
</tr>
RECORD
end


def render_html_balances(balances)
<<BALANCE
<p>
<table border="1">
  <th align="left" colspan="2">Daily Balance</th>
  <tr>
  <th>Date</th>
  <th>Balance</th>
  </tr>
  <tr>
  <td>
  #{render_daily_balance(balances)}
</table>
</p>
BALANCE
end


# Could not get a hash.each to render correctly so had to change from using "HERE" doc
def render_daily_balance(balances)
  html = ""
  balances.each do |date,value|
    if block_given?
      yield(date,value)
    else
      html << "<tr><td>#{date}</td><td>#{sprintf("%.2f",value)}</td></tr>\n"
    end
  end
  html
end


ba = BankAccount.new("Ruby CU", "12345678", "Checking")
ba.load_transactions("assignment02-input.csv")
puts render_html(ba)