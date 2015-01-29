# ========================================================================================
# Assignment 3
# ========================================================================================

# ========================================================================================
#  Problem 1 - re-implement titleize, palindrome?

# re-implement titleize and palindrome? as methods on String
class String
  def titleize
    # your implementation here
    result = ""
    word_array = self.split " "
    word_array.each do |word|
      result << word.downcase.capitalize
      result << " "
    end
    result.chop
    result
  end
  
  def palindrome?
    # your implementation here
    tmpstr = self.gsub(/\W/,"")
    tmpstr.downcase == tmpstr.downcase.reverse
  end

end

puts "hEllo WORLD".titleize                         #=> "Hello World"
puts "gooDbye CRUel wORLD".titleize                 #=> "Goodbye Cruel World"

puts "abba".palindrome?                             #=> true
puts "aBbA".palindrome?                             #=> true
puts "abb".palindrome?                              #=> false

puts "Able was I ere I saw elba".palindrome?        #=> true
puts "A man, a plan, a canal, Panama".palindrome?   #=> true


# ========================================================================================
#  Problem 2 - re-implement mean, median, to_sentence

# re-implement mean, median, to_sentence as methods on Array
class Array
  def mean
    # your implementation here
    avg = self.reduce(0) {|item,acc| acc + item} / self.length
    avg
  end
  
  def median
    # your implementation here
    if self.length % 2 != 0
      ary_median = self[(self.length / 2)]
    else
      med_index = self.length / 2
      ary_median = (self[med_index - 1, 2].reduce(0) {|item,acc| item + acc} / 2.0)
    end
    ary_median
  end
  
  def to_sentence
    # your implementation here
    words = self
    result = ""
    
    while words.length > 0 do
      result << words.shift.to_s
      if words.length > 1
        result << ", "
      elsif words.length == 1
        result << " and " 
      end  
    end
    result
  end

end
# Your method should generate the following results:
puts [1, 2, 3].mean     #=> 2
puts [1, 1, 4].mean     #=> 2

puts [1, 2, 3].median   #=> 2
puts [1, 1, 4].median   #=> 1

puts [].to_sentence                       #=> ""
puts ["john"].to_sentence                 #=> "john"
puts ["john", "paul"].to_sentence         #=> "john and paul"
puts [1, "paul", 3, "ringo"].to_sentence  #=> "1, paul, 3 and ringo"


# ========================================================================================
#  Problem 3 - re-implement bank statement

# re-implement bank statement from Assignment 2

# instead of using hashes, create classes to represent:
# - BankAccount
# - Transaction
# - DepositTransaction
# - WithdrawalTransaction

# use blocks for your HTML rendering code

####
#### See assignment03-3.rb for implementation
####
#### Dave DeLaune
