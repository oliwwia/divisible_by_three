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

  # Method increasing the digits of a number so that it's divisible by 3 using the rule that
  # the sum of the digits of any number divisible by 3 is also divisible by 3.
  #
  # I assign the sum of the digits of the number to a variable. Then, I iterate over digits of
  # a number, increasing every digit that isn't 9 by 1, until sum of the digits is divisible
  # by 3. In case we can't make any more changes or a digit is 9, the digit remains the same.
  def indivisible_to_divisible(array_of_digits)
    sum = array_of_digits.sum

    array_of_digits.map do |digit|
      unless digit == 9
        until sum % 3 == 0
          if @changes_left != 0
            digit += 1
            @changes_left -= 1
            sum += 1
          else
            digit
          end
        end
      end
      digit
    end
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
