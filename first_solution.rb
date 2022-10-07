class Intern
  attr_reader :numbers

  def initialize(numbers)
    @numbers = numbers
    @changes_left = 6
  end

  # Requirements:
  #
  # each number must be divisible by 3
  # sum of all numbers must be as large as possible
  # digit 9 cannot be changed
  # we can only increase digits
  # max 6 changes in total

  # Main method
  #
  # First, I convert the given array into nested array with given numbers as seperate arrays 
  # with their digits. Then, if all of the elements in the given array are divisible by 3, I assign
  # it to a variable, and when at least one of the elements in the given array is indivisible
  # by three, I modify nested array to make every number divisible by 3, and then I assign it
  # to a variable. Finally, I increase numbers making sure they all are still divisible by 3.
  def change
    nested_array_of_digits = numbers_into_nested_array_of_digits(numbers)

    divisible_numbers = if numbers.all? {|number| divisible_by_three?(number)}
      nested_array_of_digits
    else
      nested_array_of_digits.map {|array_of_digits| indivisible_to_divisible(array_of_digits)}
    end

    result = when_all_divisible_by_three(divisible_numbers).map {|array_of_digits| array_of_digits.join.to_i}
  end

  private

  def divisible_by_three?(num)
    num % 3 == 0
  end

  def numbers_into_nested_array_of_digits(numbers)
    numbers.map do |number|
      integer_into_array_of_digits(number)
    end
  end

  def integer_into_array_of_digits(number)
    number.to_s.chars.map {|digit| digit.to_i}
  end

  # Method increasing the digits of a number so that their sum is as large as possible.
  #
  # First, I assign nested array to a variable to freely transform it with method map!. Then, I sort
  # it by numbers' length (the longer the number, the larger the number - I want to change digits
  # representing the largest possible numbers) and by first digit of the number (in case when several
  # numbers' lengths are the same, I reduce the probability that the program will take a number that 
  # starts with 9 or 8, etc. and then it will go to the next digit with a lower value instead of
  # increasing first digit of the number that starts with 1 or 2, etc.). @changes_left is the number
  # of changes we can make. The given array is an array with numbers that are all divisible by 3 so
  # I can only add 3 or 6 to their digits to keep that. I create 3 conditions - in first one, the
  # digit is increased by 6 (it won't exceed 9 because the digit is less or equal to 3), in second
  # one, the digit is increased by 3 (there is less than 6 changes left) and in third one the digit
  # is also increased by 3 (it won't exceed 9 because the digit is larger than 3 but smaller than 7).
  # If the digit and the amount of changes left don't fulfill any of these conditions, the digit 
  # remains the same. However, there are cases where the sum of the numbers will not be as large as  
  # possible - e.g. number 822000 - the method change 2 to 5 or 8 instead of changing first 8 to 9 
  # and then 2 to 4 or 7. There is also another problem - the method shouldn't stop at each number  
  # and increase it up to the last digit. It should, for example, increase all the thousands in all
  # numbers, then all the hundreds and then all the tens. Unfortunately, after numerous attempts, 
  # I was unable to solve these problems for now.
  def when_all_divisible_by_three(nested_array_of_digits)
    nested_array_with_right_order = nested_array_of_digits
    nested_array_with_right_order.sort_by { |array_of_digits| array_of_digits[0] }.sort_by(&:length).reverse.map! do |array_of_digits|
      array_of_digits.map! do |digit|
        if digit <= 3 && @changes_left == 6
          @changes_left -= 6
          digit += 6
        elsif digit <= 3 && @changes_left >= 3
          @changes_left -= 3
          digit += 3
        elsif digit > 3 && digit < 7 && @changes_left >= 3
          @changes_left -= 3
          digit += 3
        else
          digit
        end
      end
    end
    nested_array_with_right_order
  end

  # Method increasing the digits of a number so that it's divisible by 3 using the remainder from dividing
  #
  # I use the remainder from dividing and I subtract it from 3 to know how much I have to add to
  # the number to make it divisible by three. I find the first numbers' digit which is not 9 and
  # which won't be 9 after the addition and I add missing number to it.
  def indivisible_to_divisible(array_of_digits)
    number = array_of_digits.join.to_i
    remainder = number % 3 
    to_add = 3 - remainder
  
    if to_add == 1 && @changes_left >= 1
      @changes_left -= to_add
      array_of_digits[index_of_first_number_within_limit(array_of_digits)] += to_add
    elsif to_add == 2 && @changes_left >= 2
      @changes_left -= to_add
      array_of_digits[index_of_first_number_within_limit(array_of_digits, 8)] += to_add
    elsif @changes_left == 0
      array_of_digits
    end
    array_of_digits
  end
  
  # Method searching for the index of the first digit which is within the limit 
  # - is not 9 and won't be 9 after adding some number
  def index_of_first_number_within_limit(array_of_digits, limit = 9)
    array_of_digits.index(array_of_digits.find {|digit| digit < limit})
  end
end

# Scenario 1 - all of the numbers are divisible by 3
 input = [3, 33, 333]
 should_be = [3, 33, 933]

# Scenario 2 - all of the numbers are divisible by 3 and there are nines in them
# (checking if sorting in the method 'when_all_divisible_by_three' works properly)
# input = [9, 9933, 3999]
# should_be = [9, 9933, 9999]

# Scenario 3 - one of the numbers is indivisible by 3
# input = [1, 3, 3]
# should_be = [3, 6, 3]

# Scenario 4 - two of the numbers are indivisible by 3
# input = [6, 1, 4]
# should_be = [6, 3, 6]

# Scenario 5 - none of the numbers is divisible by 3
# input = [784, 4765, 5291]
# should_be = [984, 6765, 6291]

# Scenario 6 - when all of the numbers are divisible by 3 - the program increases the numbers so
# that they are all divisible by 3. My solution works but doesn't cover all situations - for some
# inputs numbers sum is not possibly largest.

# My program selects a number with the most figures and begins to increase its digits from left
# to right (in order to gain possibly most). When for some reason it can't increment digit
# (e.g. number is already 9) it tries again with the next one. Although there is no mechanism
# checking if it would be more profitable to change number which digits we are trying to increase.

# input = [111, 111111, 9999111111]
# should_be = [111, 711111, 9999111111]

puts "Input: #{input.inspect}"

output = Intern.new(input).change

puts "Output: #{output.inspect}"

puts "Should be: #{should_be.inspect}"
