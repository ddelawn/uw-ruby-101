#!/usr/bin/env ruby
#
# David DeLaune
# UW-ruby-101
# Assignment 2-4
#
# $Id$
#
# I would typically not call functions with arguments passing and passing. It's ugly ;)
#
#
require 'date'
filename = "assignment02-input.csv"
transactions = Array.new
balance = 0.0
daily_totals = {}
contents = File.read(filename)

def create_transaction(date,payee,amount,type)
  {date: date, payee: payee, amount: amount, type: type}
end

def render_html(title,balance,withdrawls,deposits,wtotal,dtotal,daily_totals)
<<HTML
  <!doctype html>
  <html>
  #{render_html_head title}
  #{render_html_body title, balance,withdrawls, deposits, wtotal, dtotal, daily_totals}
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

def render_html_body(title,balance,withdrawls,deposits,wtotal,dtotal,daily_totals)
<<BODY
  <body>
  <h1>#{title}</h1>
  #{render_html_summary balance,withdrawls,deposits,wtotal,dtotal}
  #{render_html_transactions "Deposits", deposits }
  #{render_html_transactions "Withdrawls", withdrawls }
  #{render_html_balances 0, daily_totals}
  </body>
BODY
end

def render_html_summary(balstart, withdrawls, deposits, wtotal, dtotal)

  balend = balstart - wtotal + dtotal
  
<<SUMMARY
<p>
<table border="1">
  <tr>
    <th align="left" colspan="4">Summary</th>
  </tr>
  <tr>
    <td>Starting Balance:</td><td>#{balstart.round(2)}</td><td>Ending Balance:</td><td>#{balend.round(2)}</td>
  </tr>
  <tr>
    <td>Total Deposits:</td><td>#{dtotal.round(2)}</td><td>Total Withdrawls:</td><td>#{wtotal.round(2)}</td>
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
  <td>#{t[:date]}</td>
  <td>#{t[:amount]}</td>
  <td>#{t[:payee]}</td>
</tr>
RECORD
end


def render_html_balances(bal, dt)
<<BALANCE
<p>
<table border="1">
  <th align="left" colspan="2">Daily Balance</th>
  <tr>
  <th>Date</th>
  <th>Balance</th>
  </tr>
  #{render_html_daily_balance bal,dt}
</table>
</p>
BALANCE
end


# Could not get a hash.each to render correctly so had to change from using "HERE" doc
def render_html_daily_balance(bal,dt)
  html = ""
  dt.each do |date,value|
    bal += value
    html << "<tr><td>#{date}</td><td>#{bal.round(2)}</td></tr>\n"
  end
  html
end

# START

# oddly on both windows and Mac I could not create an array from the CSV with
# default ^M EOL so I convert to \n and then split.
contents.gsub!(/\x0D/,'\n')
records = contents.split("\n")


# not using CSV module - skip the header record
records.select! {|record| record =~ /^\d\d/}
records.each do |record|
  date, payee, amount, type = record.split(',')
  transactions.push create_transaction(date, payee, amount, type)
end

# get a real Date sort
transactions.sort_by! {|item| Date.strptime(item[:date],"%m/%d/%Y")}


withdrawls = transactions.select {|transaction| transaction[:type] == "withdrawal"}
deposits = transactions.select {|transaction| transaction[:type] == "deposit"}
transaction_dates = transactions.map {|t| t[:date]}.uniq

wtotal = withdrawls.map {|item| item[:amount].to_f}.reduce {|amt,acc| acc + amt}
dtotal = deposits.map {|item| item[:amount].to_f}.reduce {|amt,acc| acc + amt}

transaction_dates.each do |date|
  #d_date = deposits.select {|deposit| deposit[:date] == date}.map {|d| d[:amount]}
  daily_totals[date] = 0.0
  d_amounts = deposits.select {|deposit| deposit[:date] == date}.map {|d| d[:amount].to_f}
  w_amounts = withdrawls.select {|withdrawl| withdrawl[:date] == date}.map {|w| w[:amount].to_f}
  d_total = d_amounts.reduce {|amt,acc| acc + amt}
  w_total = w_amounts.reduce {|amt,acc| acc + amt}
  daily_totals[date] += d_total.round(2) unless d_total == nil
  daily_totals[date] -= w_total.round(2) unless w_total == nil
end

#puts "pause"
puts render_html("Bank Account Statement",balance, withdrawls,deposits, wtotal, dtotal, daily_totals)

#balance_by_day = 
puts "done."



