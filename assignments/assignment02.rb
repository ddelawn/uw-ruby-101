# ========================================================================================
# Assignment 2
# ========================================================================================

# ========================================================================================
#  Problem 1 - `to_sentence`

# implement method `to_sentence`

# creates an english string from array

def to_sentence(ary)
  # your implementation here
  words = ary
  result = ""
  
  while words.length > 0 do
    result << words.shift.to_s
    if words.length > 1
      result << ", "
    elsif words.length == 1
      result << " and " 
    end  
  end
  puts result
end

# Your method should generate the following results:
to_sentence []                       #=> ""
to_sentence ["john"]                 #=> "john"
to_sentence ["john", "paul"]         #=> "john and paul"
to_sentence [1, "paul", 3, "ringo"]  #=> "1, paul, 3 and ringo"


# ========================================================================================
#  Problem 2 - `mean, median`

# implement methods "mean", "median" on Array of numbers
def mean(ary)
  # your implementation here
  avg = ary.reduce(0) {|item,acc| acc + item} / ary.length
  avg
end

def median(ary)
  # your implementation here
  if ary.length % 2 != 0
    ary_median = ary[(ary.length / 2)]
  else
    med_index = ary.length / 2
    ary_median = (ary[med_index - 1, 2].reduce(0) {|item,acc| item + acc} / 2.0)
  end  
  ary_median
end

# Your method should generate the following results:
mean [1, 2, 3]    #=> 2
mean [1, 1, 4]    #=> 2

median [1, 2, 3]  #=> 2
median [1, 1, 4]  #=> 1
median [2,3,4,5]  #=> 3.5


# ========================================================================================
#  Problem 3 - `pluck`

# implement method `pluck` on array of hashes
def pluck(ary, key)
  # your implementation here
  ary.map {|item| item[key]}
end

# Your method should generate the following results:
records = [
  {name: "John",   instrument: "guitar"},
  {name: "Paul",   instrument: "bass"  },
  {name: "George", instrument: "guitar"},
  {name: "Ringo",  instrument: "drums" }
]
print pluck records, :name        #=> ["John", "Paul", "George", "Ringo"]
print "\n"
print pluck records, :instrument  #=> ["guitar", "bass", "guitar", "drums"]
print "\n"

# ========================================================================================
#  Problem 4 - monthly bank statement

# given a CSV file with bank transactions for a single account (see assignment02-input.csv)
# generate an HTML file with a monthly statement

# assume starting balance is $0.00

# the monthly statement should include the following sections:
# - withdrawals
# - deposits
# - daily balance
# - summary:
#   - starting balance, total deposits, total withdrawals, ending balance
